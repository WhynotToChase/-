<template>
  <div class="personal-info-container">
    <h1>个人信息</h1>
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
  let username = ref("q区块链");
  let email = ref("qkl@tongji.edu.com");
  const router = useRouter();

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
  const patents = ref([
    { key: 1, patentID: '销售好', patentDetail: '某种技术的专利' },
    { key: 2, patentID: '销售差', patentDetail: '其他技术的专利' }]);
  // 获取用户专利信息的函数
  const getUserPatents = async (userId: string) => {
    // 模拟从后端获取专利信息的 API 请求
    const data = [
      { key: 1, patentID: '销售好', patentDetail: '某种技术的专利' },
      { key: 2, patentID: '销售差', patentDetail: '其他技术的专利' }
    ];
    // 将数据赋值给专利列表
    patents.value = data;
  };

  // 模拟用户 ID 获取
  onMounted(() => {
    const userId = "123";  // 在实际使用中，应从当前用户数据中获取
    getUserPatents(userId);
  });

  // 路由跳转
  function goToHome() {
    router.push("/home");
  }

  function goToLogin() {
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
