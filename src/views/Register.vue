<template>
  <div class="register-background">
    <div class="register-container">
      <h1>注册</h1>
      <div class="input-group">
        <label for="username">用户名：</label>
        <input id="username" v-model="username" type="text" placeholder="请输入用户名" />
      </div>
      <div class="input-group">
        <label for="email">邮箱：</label>
        <input id="email" v-model="email" type="email" placeholder="请输入邮箱" />
      </div>
      <div class="input-group">
        <label for="password">密码：</label>
        <input id="password" v-model="password" type="password" placeholder="请输入密码" />
      </div>
      <div>
        <button @click="register">注册</button><br>
        已有账号？<button @click="goToLogin">返回登录</button>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup name="Register">
  import { ref } from "vue";
  import { useRouter } from "vue-router";
  
  let username = ref("");
  let email = ref("");
  let password = ref("");
  const router = useRouter();

  function register() {
    router.replace("/home");
  }

  function goToLogin() {
    router.replace("/");
  }
</script>

<style scoped>
.register-background {
  width: 100%;
  height: 100vh;
  background-image: url('../asserts/background.jpg');
  background-size: cover;
  background-position: center;
  display: flex; /* 启用 flexbox */
  justify-content: center; /* 水平居中 */
  align-items: center; /* 垂直居中 */
}

.register-container {
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
