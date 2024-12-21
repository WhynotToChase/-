// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserIdentityManagement {
    // 定义用户角色
    enum Role { Unregistered, PatentHolder, Buyer, Licensor }

    // 用户信息结构体
    struct User {
        address addr;       // 用户地址
        string name;        // 用户名
        string email;        // 电子邮箱
        Role role;          // 用户角色
        bool isRegistered;  // 注册状态
    }

    // 用户映射（地址 -> 用户信息）
    mapping(address => User) public users;

    // 事件
    event UserRegistered(address indexed userAddress, string name, Role role);
    event RoleUpdated(address indexed userAddress, Role newRole);

    // 修饰器：仅允许注册用户访问
    modifier onlyRegistered() {
        require(users[msg.sender].isRegistered, "User is not registered");
        _;
    }

    // 修饰器：仅允许特定角色访问
    modifier onlyRole(Role requiredRole) {
        require(users[msg.sender].role == requiredRole, "Access denied: Insufficient role");
        _;
    }

    // 注册用户
    function registerUser(string memory name, string memory email, Role role) public {
        require(!users[msg.sender].isRegistered, "User is already registered");
        require(role != Role.Unregistered, "Invalid role");

        users[msg.sender] = User({
            addr: msg.sender,
            name: name,
            email: email,
            role: role,
            isRegistered: true
        });

        emit UserRegistered(msg.sender, name, role);
    }

    // 更新用户角色
    function updateUserRole(address userAddress, Role newRole) public onlyRole(Role.PatentHolder) {
        require(users[userAddress].isRegistered, "User is not registered");
        require(newRole != Role.Unregistered, "Invalid role");

        users[userAddress].role = newRole;

        emit RoleUpdated(userAddress, newRole);
    }

    // 获取用户信息
    function getUser(address userAddress) public view returns (User memory) {
        require(users[userAddress].isRegistered, "User is not registered");
        return users[userAddress];
    }

    // 示例函数：仅允许专利持有者调用
    function patentHolderOnlyFunction() public onlyRole(Role.PatentHolder) {
        // 仅限专利持有者访问的功能
    }

    // 示例函数：仅允许注册用户调用
    function registeredUserFunction() public onlyRegistered {
        // 仅限注册用户访问的功能
    }
}
