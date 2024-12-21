// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PatentBase {

    // 定义专利结构体
    struct Patent {
        uint patentId;         // 专利唯一编号
        string patentName;     // 专利名称
        address currentOwner;  // 当前专利所有者
        string description;    // 专利描述
        uint price;            // 专利价格
        bool isForSale;        // 专利是否在出售
        uint256 registrationTime; // 注册时间（时间戳）
        uint256 expiryTime;    // 专利有效期（时间戳）
    }
    // 专利计数器（共享）
    uint public patentCount;

    // 专利存储（共享）
    mapping(uint => Patent) public patents;
}
