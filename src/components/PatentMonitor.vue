<template>
  <div v-loading="loading" element-loading-text="正在查询专利使用记录" id="d3">
	<div id="d4">
	  <div id ='d7'>
		  <div id='d8'></div>
		  <h2>专利使用记录</h2>
		  <el-button id='d8' @click="query" type="primary">刷新 </el-button>
	  </div>
	  <el-table :data="paginatedPatents" border stripe id="d5">
		<el-table-column fixed prop="patentID" label="专利ID" width="100" />
		<el-table-column fixed label="使用时间" width="160" >
		  <template #default="{ row }">
			{{ new Date(row.time).toLocaleString() }}
		  </template>
		</el-table-column>/>
		<el-table-column prop="patentDetail" label="专利描述" width="1200" show-overflow-tooltip />
		<el-table-column fixed="right" prop="auth" label="是否有权限" width="150" />
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

interface patent {patentID:string,patentDetail:string,time:number,auth:boolean}
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
	{  patentID: '12344', patentDetail: '描述1' ,time:1671485395000,auth:true},
	{  patentID: '22222', patentDetail: '描述2' ,time:1671485395000,auth:true}, 
	{  patentID: '22222', patentDetail: '描述2' ,time:1671485395000,auth:false},
	{  patentID: '22222', patentDetail: '描述2' ,time:1671485395000,auth:true},
	{  patentID: '22222', patentDetail: '描述2' ,time:1671485395000,auth:false},
	{  patentID: '22222', patentDetail: '描述2' ,time:1671485395000,auth:false},
	{  patentID: '22222', patentDetail: '描述2' ,time:1671485395000,auth:true},
	{  patentID: '22222', patentDetail: '描述2' ,time:1671485395000,auth:true},
	{  patentID: '22222', patentDetail: '描述2' ,time:1671485395000,auth:false}, 
	{  patentID: '22222', patentDetail: '描述2' ,time:1671485395000,auth:false},
	{  patentID: '22222', patentDetail: '描述2' ,time:1671485395000,auth:true},
	{  patentID: '22222', patentDetail: '描述2' ,time:1671485395000,auth:true},
  ];
    
  } catch (error) {
    ElMessage({
      type: 'warning',
      message:'查询专利使用记录出现问题',
    });
  } finally {
    loading.value=false; 
  }
}
// 切换分页
function handlePageChange(page: number) {
  currentPage.value = page;
}

onMounted(()=>{
	query();
});

</script>

<style scoped>
/* 页面样式 */
#d3 {
  position: relative;
  height: 100vh;
  background-color:rgba(0, 0, 0, 0.084);
  display: flex;
  justify-content: center;
  align-items: center;
}

#d3 .el-loading-spinner {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

#d4 {
  height: 650px;
  width: 1200px;
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  align-items: center;
  background-color: #ffffff;
  border-radius: 30px;
}

#d5 {
  padding: 10px;
  height: 460px;
  width: 1200px;
  margin-bottom: 20px;
}

#d6 {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}
#d7{
	width: 1000px;
	height: 50px;
	justify-content: space-between;
	align-items: center;
	display: flex;
}
#d8{
	width: 80px;
	height: auto;
}

</style>
