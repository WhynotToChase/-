<template>
    <div class="personal-info-container">
      <h1>个人信息</h1>
      <p>用户名：{{ username }}</p>
      <p>邮箱：{{ email }}</p>
      <button @click="goToHome">返回首页</button>
      <button @click="goToLogin">退出登录</button>
    </div>
</template>
  
<script lang="ts" setup name = "PersonalInfo">
  import { defineComponent ,ref} from "vue";
  import { useRouter } from "vue-router";

  let username = ref("q区块链");
  let email = ref("qkl@tongji.edu.com")
  const router = useRouter();

  function goToHome(){
    router.push("/home");
  }
  function goToLogin(){
    router.push("/");
  }
</script>
  
<style scoped>
  .personal-info-container {
    text-align: center;
    margin-top: 20%;
  }
  
  button {
    padding: 8px 16px;
    margin: 16px;
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
  