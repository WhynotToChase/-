<template>
  <div class="layout">
    <!-- 左侧侧边栏 -->
    <aside class="sidebar">
      <div class="logo">专利管理系统</div>
      <ul>
        <li>
          <RouterLink replace to="/home/patent-register" class="nav-link">专利注册和存储</RouterLink>
        </li>
        <li>
          <RouterLink replace to="/home/patent-license" class="nav-link">专利授权与许可管理</RouterLink>
        </li>
         <!-- 点击“专利买卖和转让”时展开/收起下面的两个链接 -->
         <li>
          <button @click="togglePatentTrade" class="nav-link" style="background: transparent; border: none; cursor: pointer;">
            专利买卖和转让
          </button>
          <!-- 展开项，只有当showPatentTrade为true时显示 -->
          <ul v-if="showPatentTrade">
            <li>
              <RouterLink replace to="/home/patent-buy" class="nav-link_1">专利购买</RouterLink>
            </li>
            <li>
              <RouterLink replace to="/home/sell" class="nav-link_1">专利出售</RouterLink>
            </li>
          </ul>
        </li>
        <li>
          <RouterLink replace to="/home/patent-monitor" class="nav-link">专利监控与侵权检测</RouterLink>
        </li>
      </ul>
    </aside>

    <!-- 内容区域 -->
    <main class="content">
      <header class="header">
        <RouterLink to="/home/personal-info" class="header-link">
          个人信息
        </RouterLink>
      </header>
      <div class="main-content">
        <RouterView></RouterView>
      </div>
    </main>
  </div>
</template>

<script lang="ts" setup name = "Home">
  import { RouterView } from "vue-router";
  import {ref} from "vue"
  // 控制“专利买卖和转让”项展开和收起
  const showPatentTrade = ref(false);

  function togglePatentTrade() {
    showPatentTrade.value = !showPatentTrade.value;
  }
</script>

<style scoped>
.layout {
  display: flex;
  min-height: 100vh;
}

.sidebar { /*侧边栏 */
  width: 200px;
  background: #333;
  color: #fff;
  padding: 16px;
  border-radius: 8px; 
}

.logo {  
  font-size: 24px;
  color: #f9f900;
  text-align: center;
  margin-bottom: 16px;
}

.sidebar ul {
  list-style: none;
  padding: 0;
}

.sidebar li {
  padding: 12px 12px;
  cursor: pointer;
  transition: background 0.3s;
  color: white;
  border-radius: 8px; 
}

.nav-link {
  width: 100%;  /* 使链接占满父元素宽度 */
  color: white;
  text-decoration: none;  /* 去除下划线 */
  display: block;  /* 让整个li区域变成点击区域 */
  font-size: 16px; 
}

.nav-link_1 {
  color: white;
  text-decoration: none;  /* 去除下划线 */
  display: block;  /* 让整个li区域变成点击区域 */
  font-size: 13px; 
}

.sidebar li:hover,
.sidebar li.active {
  background: #555;
  color: #e1df9d;
}

.content {
  flex: 1;
  display: flex;
  flex-direction: column;
  border-radius: 8px; 
}

.header {
  background: #f5f5f5;
  padding: 16px;
  border-bottom: 1px solid #ddd;
  border-radius: 8px;
  display: flex;               /* 使用flexbox布局 */
  justify-content: flex-end;   /* 将内容对齐到最右边 */
  align-items: center;         /* 垂直居中对齐 */
}

.header-link{
  background: #4f89fe;
  color: white;
  padding: 16px;
  text-decoration: none;  /* 去除下划线 */
  display: block;  /* 让整个区域变成点击区域 */
  border-radius: 8px; 
}

.main-content {
  flex: 1;
  padding: 24px;
  border-radius: 8px; 
}
</style>
