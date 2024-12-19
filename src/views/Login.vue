<template>
  <div class="login-background">
    <div class="login-container">
      <h1>登录</h1>
      <div class="input-group">
        <label for="account">选择账户：</label>
        <select id="account" v-model="selectedAccount">
          <option v-for="account in accounts" :key="account" :value="account">
            {{ account }}
          </option>
        </select>
      </div>
      <div>
        <button @click="login">登录</button>
        <button @click="goToRegister">注册</button>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup name="Login">
  import { ref, onMounted } from "vue";
  import { useRouter } from "vue-router";
  import { web3, User } from "@/web3";

  let emailaddress = ref("");
  let password = ref("");
  const router = useRouter();
  const accounts = ref<string[]>([]); // 用于存储所有连接的账户
  const selectedAccount = ref<string>(""); // 用户选择的账户

  interface User {
    addr: string; // 用户地址
    name: string; // 用户名
    email: string; // 电子邮箱
    role: number; // 用户角色 (Role 枚举值)
    isRegistered: boolean; // 注册状态
  }

  // 获取账户列表
  async function fetchAccounts() {
    try {
      accounts.value = await web3.eth.getAccounts();
      if (accounts.value.length > 0) {
        selectedAccount.value = accounts.value[0]; // 默认选择第一个账户
      }
    } catch (error) {
      console.error("Failed to fetch accounts:", error);
    }
  }

  // 登录逻辑
  async function login() {
  if (!selectedAccount.value) {
    alert("请选择一个账户！");
    return;
  }

  try {
      console.log("Selected account", selectedAccount.value);
      const userInfo = (await User.methods.getUser(selectedAccount.value).call()) as User;
      console.log("User info", userInfo);

      if (userInfo.isRegistered) {
        localStorage.setItem("userAddress", userInfo.addr);
        localStorage.setItem("username", userInfo.name);
        localStorage.setItem("email", userInfo.email);

        alert(`欢迎回来, ${userInfo.name}！`);
        router.replace("/home");
      } else {
        alert("未注册用户，请先注册！");
        router.replace("/register");
      }
    } catch (error) {
      console.error("登录失败：", error);
      alert("未注册用户，请先注册！");
    }
  }

  // 跳转到注册页
  function goToRegister() {
    router.replace("/register");
  }

  // 页面加载时获取账户
  onMounted(fetchAccounts);
</script>

<style scoped>
.login-background {
  width: 100%;
  height: 100vh;
  background-image: url('../asserts/background.jpg');
  background-size: cover;
  background-position: center;
  display: flex; /* 启用 flexbox */
  justify-content: center; /* 水平居中 */
  align-items: center; /* 垂直居中 */
}

.login-container {
  background-color: rgba(255, 255, 255, 0.8); /* 半透明背景，增加对比度 */
  text-align: center;
  width: 30%;
  border-radius: 8px;
  padding: 20px;
}

.input-group {
  display: flex;
  align-items: center; /* 使文本和输入框垂直居中 */
  margin-bottom: 10px;
}

.input-group label {
  flex: 0 0 80px; /* 给标签设置固定宽度 */
  text-align: right; /* 标签对齐右边 */
  margin-right: 10px; /* 标签和输入框之间的间隔 */
}

input {
  display: block;
  padding: 8px;
  width: 70%; /* 输入框宽度占父容器的 70% */
  border: 1px solid #ddd;
  border-radius: 4px;
}

button {
  padding: 8px 30px;
  margin: 12px 40px;
  border: none;
  border-radius: 12px;
  background: #007bff;
  color: white;
  cursor: pointer;
}

button:hover {
  background: #0056b3;
}
</style>
