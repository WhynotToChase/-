// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PatentRegistry.sol";  // 导入共享结构体合约

contract PatentMarket is PatentRegistry {
    // 定义授权申请结构体
    struct AuthorizationRequest {
        address applicant;       // 申请人地址
        uint256 patentId;        // 申请的专利 ID
        uint256 requestTime;     // 申请时间
        bool approved;           // 是否被批准
    }

    // 定义使用记录结构体
    struct UseRecord {
        uint256 patentId;       // 专利 ID
        address user;           // 使用者地址
        uint256 useTime;        // 使用时间
        bool isAuthorized;      // 是否已授权使用
    }

    // 专利ID映射到授权用户
    mapping(uint => mapping(address => bool)) public authorizedUsers;
    mapping(uint256 => AuthorizationRequest[]) public authorizationRequests; // 存储专利的授权申请记录
    mapping(uint256 => UseRecord[]) public useRecords; // 存储专利的使用记录
    // 事件
    event PatentListed(uint indexed patentId, string name, address indexed owner, uint price);
    event PatentSold(uint indexed patentId, string name, address indexed previousOwner, address indexed newOwner, uint price);
    event PatentAuthorized(uint indexed patentId, address indexed user);
    event PatentInfringementDetected(uint indexed patentId, address indexed infringer);
    event LegalActionTriggered(uint indexed patentId, address indexed infringer);
    // 事件：授权申请
    event PatentAuthorizationRequested(uint256 indexed patentId, address indexed applicant);
    // 事件：授权申请被拒绝
    event PatentAuthorizationRejected(uint256 indexed patentId, address indexed user);
    
    // 设置专利为出售状态
    function listForSale(uint patentId, uint price) public {
        Patent storage patent = patents[patentId];
        require(patent.currentOwner == msg.sender, "You are not the owner");
        require(patent.isForSale == false, "Patent is already for sale");

        patent.price = price;
        patent.isForSale = true;

        emit PatentListed(patentId, patent.patentName, msg.sender, price);
    }

    // 购买专利
    function buyPatent(uint patentId) public payable {
        Patent storage patent = patents[patentId];
        require(patent.isForSale, "Patent is not for sale");
        require(msg.value >= patent.price, "Insufficient funds to buy patent");

        address previousOwner = patent.currentOwner;
        patent.currentOwner = msg.sender;
        patent.isForSale = false;

        // 将购买费用转给之前的所有者
        payable(previousOwner).transfer(msg.value);

        emit PatentSold(patentId, patent.patentName, previousOwner, msg.sender, patent.price);
    }

    // 判断用户是否可以申请专利授权
    function canApplyForAuthorization(uint256 patentId, address user) public view returns (bool) {
        // 1. 用户不是专利的当前拥有者
        if (user == patents[patentId].currentOwner) {
            return false;  // 用户已经拥有该专利，不能申请授权
        }
        
        // 2. 用户是否已获得该专利授权
        if (authorizedUsers[patentId][user]) {
            return false;  // 用户已被授权使用该专利，不能再次申请
        }

        // 3. 判断该专利是否在出售状态，只有未出售的专利才能被授权
        if (patents[patentId].isForSale) {
            return false;  // 专利在出售状态，用户不能申请授权
        }

        // 如果满足以上条件，用户可以申请授权
        return true;
    }

    // 用户申请专利授权
    function requestPatentAuthorization(uint256 patentId) public {
        // 检查专利是否存在
        require(patents[patentId].patentId == patentId, "Patent does not exist");

        // 检查用户是否已经获得授权
        require(!authorizedUsers[patentId][msg.sender], "You are already authorized");

        // 记录授权申请
        authorizationRequests[patentId].push(AuthorizationRequest({
            applicant: msg.sender,
            patentId: patentId,      // 记录申请的专利 ID
            requestTime: block.timestamp,
            approved: false // 初始为未批准
        }));

        emit PatentAuthorizationRequested(patentId, msg.sender);
    }

    // 专利持有者批准授权申请
    function approveAuthorization(uint256 patentId, address user) public {
        // 确保调用者是专利持有者
        require(patents[patentId].currentOwner == msg.sender, "Only the owner can approve");

        // 查找该用户的申请记录
        bool applicationFound = false;
        for (uint i = 0; i < authorizationRequests[patentId].length; i++) {
            if (authorizationRequests[patentId][i].applicant == user && !authorizationRequests[patentId][i].approved) {
                // 批准申请
                authorizationRequests[patentId][i].approved = true;
                authorizedUsers[patentId][user] = true;

                emit PatentAuthorized(patentId, user);
                applicationFound = true;
                break;
            }
        }

        require(applicationFound, "Authorization request not found or already approved");
    }

    // 专利持有者拒绝授权申请
    function rejectAuthorization(uint256 patentId, address user) public {
        // 确保调用者是专利持有者
        require(patents[patentId].currentOwner == msg.sender, "Only the owner can reject");

        // 查找该用户的申请记录
        bool applicationFound = false;
        for (uint i = 0; i < authorizationRequests[patentId].length; i++) {
            if (authorizationRequests[patentId][i].applicant == user && !authorizationRequests[patentId][i].approved) {
                // 拒绝申请
                authorizationRequests[patentId][i].approved = false;

                emit PatentAuthorizationRejected(patentId, user);
                applicationFound = true;
                break;
            }
        }
        require(applicationFound, "Authorization request not found or already approved");
    }

    // 用户使用专利
    function usePatent(uint256 patentId) public {
        // 检查专利是否存在
        require(patents[patentId].patentId == patentId, "Patent does not exist");

        // 判断用户是否是专利持有者或已被授权使用该专利
        bool hasPermission = (msg.sender == patents[patentId].currentOwner || authorizedUsers[patentId][msg.sender]);

        // 记录使用记录
        useRecords[patentId].push(UseRecord({
            patentId: patentId,
            user: msg.sender, 
            useTime: block.timestamp,
            isAuthorized: hasPermission
        }));

        // 如果没有权限，抛出异常
        require(hasPermission, "You do not have permission to use this patent");

        emit PatentUsed(patentId, msg.sender, block.timestamp);
    }

    // 获取用户所有拥有的专利的使用记录
    function getOwnedPatentsUseRecords(address user) public view returns (UseRecord[] memory) {
        uint256 ownedPatentsCount = 0;
        // 计算当前用户拥有的专利数
        for (uint256 i = 0; i < patentCount; i++) {
            if (patents[i].currentOwner == user) {
                ownedPatentsCount++;
            }
        }

        // 创建一个数组存储所有拥有专利的使用记录
        UseRecord[] memory allUseRecords = new UseRecord[](ownedPatentsCount);

        uint256 index = 0;
        for (uint256 i = 0; i < patentCount; i++) {
            if (patents[i].currentOwner == user) {
                // 如果是用户拥有的专利，获取该专利的使用记录
                for (uint256 j = 0; j < useRecords[i].length; j++) {
                    allUseRecords[index] = useRecords[i][j];
                    index++;
                }
            }
        }

        return allUseRecords;
    }

    // 事件：使用专利
    event PatentUsed(uint256 patentId, address user, uint256 useTime);

    // 检测非法使用专利
    function detectIllegalUse(uint256 patentId, address user) public view returns (bool) {
        // 检查用户是否是专利的拥有者或已授权
        bool hasPermission = (user == patents[patentId].currentOwner || authorizedUsers[patentId][user]);
        return !hasPermission;
    }

    // 侵权检测并触发警告
    function triggerInfringementWarning(uint patentId, address infringer) public {
        require(detectIllegalUse(patentId, infringer), "No infringement detected");

        emit PatentInfringementDetected(patentId, infringer);
    }

    // 获取专利信息
    function getPatentInfo(uint patentId) public view returns (Patent memory) {
        return patents[patentId];
    }

    // 获取专利是否为待售
    function isPatentForSale(uint patentId) public view returns (bool) {
        return patents[patentId].isForSale;
    }

    // 获取专利是否已授权
    function isAuthorizedUser(uint patentId, address user) public view returns (bool) {
        return authorizedUsers[patentId][user];
    }

    // 获取当前用户可以购买的所有专利
    function fetchMarketPatents(address user) public view returns (Patent[] memory) {
        uint count = 0;
        uint[] memory availablePatentIds = new uint[](patentCount);

        // 统计所有在售的专利
        for (uint i = 0; i <= patentCount; i++) {
            if (patents[i].isForSale  && patents[i].currentOwner != user) {
                availablePatentIds[count] = i;
                count++;
            }
        }

        // 创建一个Patent数组返回可购买的专利信息
        Patent[] memory availablePatents = new Patent[](count);
        for (uint i = 0; i < count; i++) {
            uint patentId = availablePatentIds[i];
            availablePatents[i] = patents[patentId];
        }

        return availablePatents;
    }

    // 获取当前用户可以出售的所有专利
    function fetchPatentsCanSale(address user) public view returns (Patent[] memory) {
        uint count = 0;
        
        // 先计算当前用户可以出售的专利数量
        for (uint i = 0; i < patentCount; i++) {
            if (patents[i].currentOwner == user && !patents[i].isForSale) {
                count++;
            }
        }

        // 创建一个数组存储所有该用户可以出售的专利信息
        Patent[] memory userPatentsForSale = new Patent[](count);
        uint index = 0;

        // 填充用户的专利数组
        for (uint i = 0; i < patentCount; i++) {
            if (patents[i].currentOwner == user && patents[i].isForSale) {
                userPatentsForSale[index] = patents[i];
                index++;
            }
        }
        return userPatentsForSale;
    }

    // 获取已出售的所有专利
    function fetchSoldPatents(address user) public view returns (Patent[] memory) {
        uint count = 0;

        // 先计算当前用户已出售的专利数量
        for (uint i = 0; i < patentCount; i++) {
            if (patents[i].currentOwner == user && patents[i].isForSale) {
                count++;
            }
        }

        // 创建一个数组存储所有已出售的专利信息
        Patent[] memory soldPatents = new Patent[](count);
        uint index = 0;

        // 填充用户的已出售专利数组
        for (uint i = 0; i < patentCount; i++) {
            if (patents[i].currentOwner == user && patents[i].isForSale) {
                soldPatents[index] = patents[i];
                index++;
            }
        }

        return soldPatents;
    }
    // 撤回出售状态
    function withdrawPatentFromSale(uint patentId) public {
        Patent storage patent = patents[patentId];

        // 确保调用者是专利持有者
        require(patent.currentOwner == msg.sender, "You are not the owner of this patent");

        // 确保专利已经在出售状态
        require(patent.isForSale == true, "Patent is not currently for sale");

        // 撤回出售状态
        patent.isForSale = false;

        // 触发撤回出售事件
        emit PatentWithdrawn(patentId, patent.patentName, msg.sender);
    }

    // 事件：撤回专利出售
    event PatentWithdrawn(uint indexed patentId, string patentName, address indexed owner);
}
