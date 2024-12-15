<template>
  <div v-loading="loading" element-loading-text="查询中..." id="d3">
	<div id="d1">
	  <div id="d2">
		<el-input v-model="id" placeholder="请输入要查询的专利ID" clearable />
		<el-button type="primary" @click="query">查询</el-button>
	  </div>
	</div>
	<div id="d4">
	  <el-table :data="paginatedPatents" border id="d5">
		<el-table-column fixed prop="patentID" label="专利ID" width="150" />
		<el-table-column prop="price" label="专利价格" width="150" />
		<el-table-column prop="patentDetail" label="专利描述" width="1200" show-overflow-tooltip />
		<el-table-column fixed="right" label="操作" width="100">
		  <template #default="{row}">
			<el-button type="primary" size="small" @click="buy(row)">购买</el-button>
		  </template>
		</el-table-column>
	  </el-table>

	  <!-- 分页组件 -->
	  <div id="d6">
		<el-pagination
		  background
		  layout="prev, pager, next, jumper"
		  :total="patents.length"
		  :page-size="pageSize"
		  :current-page="currentPage"
		  @current-change="handlePageChange"
		  :pager-count="10"
		/>
	  </div>
	</div>  
 </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import axios from 'axios';
import { useRouter } from "vue-router";
import { ElMessage } from 'element-plus';
const router = useRouter()

interface patent {patentID:string,patentDetail:string,price:number}
let id = ref(''); // 用户输入的专利ID
let loading = ref(false); // 加载状态
let patents = ref<patent[]>([]);

let pageSize = ref(10); // 每页显示行数
let currentPage = ref(1); // 当前页码

// 计算当前页显示的数据
const paginatedPatents = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value;
  const end = start + pageSize.value;
  return patents.value.slice(start, end);
});

// 查询操作
async function query() {
  loading.value = true;
  try {
    const response = await axios.get('/api/patents', {
      params: { id: id.value }  // 传递专利ID进行筛选查询
    });

    // 假设 API 返回的数据格式为 { data: [{ patentID, patentDetail }, ...] }
    patents.value=[  // 初始化专利列表
  {  patentID: '12344', patentDetail: '描述1' ,price: 100},
  {  patentID: '22222', patentDetail: '描述2' ,price: 100},
  {  patentID: '33333', patentDetail: '描述3' ,price: 100},
  {  patentID: '55555', patentDetail: '描述5' ,price: 100},
  { patentID: '44444', patentDetail: '描述4' ,price: 100},
  { patentID: '77777', patentDetail: '描述7' ,price: 100},
  { patentID: '66666', patentDetail: '描述6' ,price: 100},
  { patentID: '88888', patentDetail: '描述8' ,price: 100},
  { patentID: '88888', patentDetail: '描述8' ,price: 100},
  { patentID: '88888', patentDetail: '描述8' ,price: 100},
  { patentID: '88888', patentDetail: '描述8' ,price: 100},
  { patentID: '88888', patentDetail: '描述8' ,price: 100},
  { patentID: '88888', patentDetail: '描述8' ,price: 100},
  { patentID: '88888', patentDetail: '描述8' ,price: 100},
  { patentID: '88888', patentDetail: '描述8' ,price: 100},
  { patentID: '88888', patentDetail: '描述8' ,price: 100},
  { patentID: '88888', patentDetail: '描述8' ,price: 100},
  { patentID: '88888', patentDetail: '描述8' ,price: 100},
  { patentID: '88888', patentDetail: '描述8',price: 100 },
  { patentID: '88888', patentDetail: '描述8' ,price: 100},
  { patentID: '88888', patentDetail: '描述8' ,price: 100},
  { patentID: '88888', patentDetail: '描述8' ,price: 100},
  ];
    
  } catch (error) {
    ElMessage({
      type: 'warning',
      message:'未找到专利',
    });
  } finally {
    loading.value=false; 
  }
}
// 切换分页
function handlePageChange(page: number) {

  currentPage.value = page;
}

function buy(row:patent){
	router.push({path:"/home/buy",query:{id:row.patentID}});
}

async function getPatents(){
	loading.value = true;
	try {
	  const response = await axios.get('/api/patents');
	  patents.value=response.data;
	 
	}
	catch(error){
		ElMessage({message:'获取专利信息失败',type:'warning'});
	}
	finally{ 
		loading.value=false; 		
	}
}
onMounted(()=>{
	getPatents();
});

</script>

<style scoped>
/* 页面样式 */
#d1 {
  display: flex;
  justify-content: center; /* 水平居中 */
  align-items: center; /* 垂直居中 */
  margin: 0;
  background-color: rgba(0, 0, 0, 0.084);
}

#d2 {
  width: 800px;
  height: 30px;
  padding: 10px;
  display: flex;
  align-items: center;
}

#d2 .el-input {
  margin-right: 10px;
}

#d3 {
  position: relative;
  height: 100vh;
}

#d3 .el-loading-spinner {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

#d4 {
  height: 600px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  background-color: #110c0c16;
}

#d5 {
  padding: 10px;
  height: 500px;
  width: 1200px;
  border-radius: 20px;
  margin-bottom: 20px;
}

#d6 {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

</style>
