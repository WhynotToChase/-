<template>
  <div class="personal-info-container">
    <h1>个人信息</h1>
    <p>用户地址：{{ userAddress }}</p>
    <p>用户名：{{ username }}</p>
    <p>邮箱地址：{{ email }}</p>
    <!-- 展示专利信息 -->
    <br>
    <h3>持有的专利</h3>
    <div v-if="patents.length > 0" class="patent-list">
      <a-table
        :columns="patents_column"
        :dataSource="patents"
        rowKey="key"
        :pagination="false"
        bordered
      />
    </div>
    <div v-else class="patent-list">
      <p>暂无专利</p>
    </div>
  </div>
  <button @click="goToHome">返回首页</button>
  <button @click="goToLogin">退出登录</button>
</template>

<script lang="ts" setup name="PersonalInfo">
  import { ref, onMounted } from "vue";
  import { useRouter } from "vue-router";
  import { Table } from 'ant-design-vue'; // 引入 Table 组件
  import { web3, Patent } from "@/web3";
  let userAddress = ref("");
  let username = ref("");
  let email = ref("");
  const router = useRouter();
  // 定义专利数据的类型
  interface Patent {
    key: number;
    patentID: number;
    patentDetail: string;
  }

  // 专利信息列配置
  const patents_column = ref([
    {
      title: "专利ID",
      dataIndex: "patentID", // 修改为正确的属性名
      align: "center",  // 使文字居中
      customHeaderCell: () => ({ style: "font-size: 15px;" }),
    },
    {
      title: "专利详情",
      dataIndex: "patentDetail", // 修改为正确的属性名
      align: "center",  // 使文字居中
      customHeaderCell: () => ({ style: "font-size: 15px;" }),
    },
  ]);

  // 专利数据
  const patents = ref<Patent[]>([]); // 明确指定 patents 的类型
  
  // 获取用户专利信息
  const getUserPatents = async () => {
    try {
      // 调用合约获取专利ID列表
      const patentIds: number[] = await Patent.methods.getUserPatents().call({ from: userAddress.value });

      const patentDetails = [];

      // 定义返回值类型
      type PatentInfo = [number, string, string, number, number];

      // 获取每个专利的详细信息
      for (const patentId of patentIds) {
        const patent = (await Patent.methods.getPatent(patentId).call()) as PatentInfo;
        patentDetails.push({
          key: patentId, // 唯一键
          patentID: patentId, // 专利ID
          patentDetail: patent[1], // 专利描述
        });
      }

      patents.value = patentDetails; // 更新专利列表
    } catch (error) {
      console.error("获取专利信息失败：", error);
      patents.value = []; // 确保出错时清空数据
    }
  };

  // 模拟用户 ID 获取
  onMounted(async () => {
    userAddress.value = localStorage.getItem("userAddress") || "未知地址";
    username.value = localStorage.getItem("username") || "未知用户";
    email.value = localStorage.getItem("email") || "未知邮箱";

    await getUserPatents(); // 获取专利信息
  });

  // 路由跳转
  function goToHome() {
    router.push("/home");
  }

  function goToLogin() {
    localStorage.clear(); // 清除用户信息
    router.push("/");
  }
</script>

<style scoped>
  .personal-info-container {
    text-align: center;
    margin-top: 20px;
    display: flex;
    flex-direction: column;
    align-items: center;  /* 水平居中列表内容 */
  }

  .patent-list {
    margin-top: 40px;
    height: 300px;
    width: 800px;
    border: 1px solid #000000; /* 外边框 */
    border-radius: 8px; /* 圆角 */
    background-color: #f9f9f9; /* 背景颜色 */
    overflow-y: auto; /* 当内容超出时，显示垂直滚动条 */
    display: flex;
    border-radius: 4px;
    flex-direction: column;
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

  /* 自定义 a-table 的边框样式 */
  :deep(.ant-table th){
    background-color: rgba(0, 0, 0, 0.219);
    font-size: 15px;
    padding: 10px;
    text-align: center; /* 设置字体居中 */
  }
  :deep(.ant-table td){
    background-color: rgba(31, 31, 31, 0.219);
    font-size: 15px;
    padding: 10px;
    text-align: center; /* 设置字体居中 */
  }
</style>
