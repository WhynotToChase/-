<template>
    <div class="register-container">
      <h1>注册</h1>
      <input v-model="username" type="text" placeholder="请输入用户名" />
      <input v-model="email" type="email" placeholder="请输入邮箱" />
      <input v-model="password" type="password" placeholder="请输入密码" />
      <div>
        <button @click="register">注册</button><br>
        已有账号？<button @click="goToLogin">返回登录</button>
      </div>
    </div>
</template>
  
<script lang="ts" setup name = "Register">
  import { defineComponent ,ref} from "vue";
  import { useRouter } from "vue-router";
  
  let username = ref("");
  let email = ref("")
  let password =ref("")
  const router = useRouter();

  function register(){
    router.replace("/home");
  }
  function goToLogin(){
    router.replace("/");
  }
</script>
  
<style scoped>
  .register-container {
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
    margin: 8px;
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
  