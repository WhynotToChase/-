// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PatentBase.sol";  // 导入共享结构体合约

contract PatentRegistry is PatentBase {
    // 事件
     event PatentRegistered(
        uint256 patentId,
        string name,
        address indexed owner,
        string description,
        uint256 price,
        bool isForSale,
        uint256 registrationTime,
        uint256 expiryTime
    );

    mapping(address => uint256[]) private userPatents; // 用户地址 => 专利ID列表

    function registerPatent(
        string memory name,
        string memory description,
        uint256 duration,
        uint256 price
    ) public returns (uint256) {
        // require(patents[patentCount].patentId == 0, "Patent ID already exists");
        require(duration > 0, "Duration must be greater than zero");

        // 注册专利
        patents[patentCount] = Patent({
            patentId: patentCount,
            patentName: name,              // 专利名称
            currentOwner: msg.sender,      // 当前专利所有者
            description: description,      // 专利描述
            price: price,                  // 专利价格
            isForSale: true,          // 专利是否出售
            registrationTime: block.timestamp,  // 注册时间
            expiryTime: block.timestamp + duration  // 专利到期时间
        });

        userPatents[msg.sender].push(patentCount);
        patentCount++;

        // 触发事件
        emit PatentRegistered(
            patentCount - 1,
            name,
            msg.sender,
            description,
            price,
            true,
            block.timestamp,
            block.timestamp + duration
        );
    }

    // 获取专利信息
    function getPatent(uint256 patentId) public view returns (
        uint256,
        string memory,
        string memory,
        address,
        uint256,
        uint256,
        uint256
    ) {
        // require(patents[patentId].patentId != 0, "Patent does not exist");

        Patent memory patent = patents[patentId];
        return (
            patent.patentId,
            patent.patentName,
            patent.description,
            patent.currentOwner,
            patent.registrationTime,
            patent.expiryTime,
            patent.price
        );
    }

    // 检查专利是否过期
    function isPatentExpired(uint256 patentId) public view returns (bool) {
        // require(patents[patentId].patentId != 0, "Patent does not exist");

        return block.timestamp > patents[patentId].expiryTime;
    }

    // 获取用户所有专利ID
    function getUserPatents() public view returns (uint256[] memory) {
        return userPatents[msg.sender];
    }
}
