// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PatentLicenseManagement {
    // 定义专利状态
    enum LicenseStatus { NotLicensed, Licensed, Expired }

    // 定义授权信息结构体
    struct License {
        address patentHolder;  // 专利持有者地址
        address licensee;      // 被授权者地址
        uint256 fee;           // 授权费用
        uint256 duration;      // 授权期限（从授权开始的时间戳）
        uint256 startTime;     // 授权开始时间
        LicenseStatus status;  // 授权状态
    }

    // 专利ID -> 授权信息映射
    mapping(uint256 => License) public licenses;
    
    // 专利ID计数
    uint256 public patentCount;

    // 事件：授权成功
    event LicenseGranted(uint256 patentId, address indexed patentHolder, address indexed licensee, uint256 fee, uint256 duration);
    
    // 事件：授权状态更新
    event LicenseStatusUpdated(uint256 patentId, LicenseStatus newStatus);

    // 事件：更新授权费用
    event LicenseFeeUpdated(uint256 patentId, uint256 licenseFee);

    // 授权专利
    function grantLicense(uint256 patentId, address licensee, uint256 fee, uint256 duration) public {
        // 获取专利持有者（调用者地址）
        address patentHolder = msg.sender;

        // 确保专利尚未授权或已经过期
        require(licenses[patentId].status != LicenseStatus.Licensed, "Patent is already licensed");
        require(licenses[patentId].status != LicenseStatus.Expired, "Patent license has expired");

        // 创建授权信息
        licenses[patentId] = License({
            patentHolder: patentHolder,
            licensee: licensee,
            fee: fee,
            duration: duration,
            startTime: block.timestamp,
            status: LicenseStatus.Licensed
        });

        // 触发授权事件
        emit LicenseGranted(patentId, patentHolder, licensee, fee, duration);
    }

    // 获取授权状态
    function getLicenseStatus(uint256 patentId) public view returns (LicenseStatus) {
        License storage license = licenses[patentId];

        // 如果授权已过期，则更新状态为已过期
        if (block.timestamp >= license.startTime + license.duration && license.status == LicenseStatus.Licensed) {
            return LicenseStatus.Expired;
        }

        return license.status;
    }

    function updateLisenceFee(uint256 patentId, uint256 lisenceFee ) public {
        License storage license = licenses[patentId];
        // 更新费用
        license.fee = lisenceFee;

        emit LicenseFeeUpdated(patentId, lisenceFee);
    }

    // 用户支付授权费用（假设是直接转账的形式）
    function payLicenseFee(uint256 patentId) public payable {
        License storage license = licenses[patentId];

        // 确保专利被授权给当前用户
        require(license.licensee == msg.sender, "You are not the licensee");
        
        // 确保支付的费用正确
        require(msg.value == license.fee, "Incorrect fee amount");

        // 转账授权费用到专利持有者
        payable(license.patentHolder).transfer(msg.value);
    }

    // 更新授权状态（如延长授权期限等）
    function updateLicenseStatus(uint256 patentId, LicenseStatus newStatus) public {
        License storage license = licenses[patentId];
        
        // 仅允许专利持有者更新授权状态
        require(license.patentHolder == msg.sender, "Only patent holder can update license status");

        // 更新授权状态
        license.status = newStatus;

        // 触发事件
        emit LicenseStatusUpdated(patentId, newStatus);
    }
    
    // 测试：创建新的专利
    function createPatent() public {
        patentCount++;
    }
}
