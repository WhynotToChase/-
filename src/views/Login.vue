<template>
  <div class="login-container">
    <h1>登录</h1>
    <input v-model="username" type="text" placeholder="请输入用户名" />
    <input v-model="password" type="password" placeholder="请输入密码" />
    <div>
      <button @click="login">登录</button>
      <button @click="goToRegister">注册</button>
    </div>
  </div>
</template>

<script lang="ts" setup name = "Login">
  import { defineComponent ,ref} from "vue";
  import { useRouter } from "vue-router";

  let username = ref("")
  let password = ref("")
  const router = useRouter();
  function login(){
      router.push("/home");
  }
  function goToRegister(){
    router.push("/register");
  }
</script>

<style scoped>
.login-container {
  text-align: center;
  margin-top: 20%;
}

input {
  display: block;
  margin: 8px auto;
  padding: 8px;
  width: 300px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

button {
  padding: 8px 16px;
  margin: 12px;
  border: none;
  border-radius: 4px;
  background: #007bff;
  color: white;
  cursor: pointer;
}

button:hover {
  background: #0056b3;
}
</style>
