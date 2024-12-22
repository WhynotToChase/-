<template>
  <div id="a" v-loading="loading" :element-loading-text="loadingText">
    <div v-if="show" id='e'>
      <div id='b'>
        <div id='g'></div>
        <h2>当前拥有的专利</h2>
        <el-button type='primary' @click="refresh" id='g'>刷新</el-button>
      </div>

      <el-table :data="paginatedPatents" border id="c">
        <el-table-column fixed prop="patentID" label="专利ID" width="150" />
        <el-table-column prop="patentDetail" label="专利描述" width="1050" show-overflow-tooltip />
        <el-table-column fixed prop="patentPrice" label="价格" width="150" />
        <el-table-column fixed="right" label="操作" width="100">
          <template #default="{row}">
            <el-button type="primary" size="small" @click="onsale(row)">出售</el-button>
          </template>
        </el-table-column>
      </el-table>
      <!-- 分页组件 -->
      <div id="d">
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
 
<script setup name="PatentSell" lang="ts">
import { ElMessage, ElMessageBox } from 'element-plus';
import {computed, onMounted, ref} from 'vue';
import {PatentMarket, web3, Patent} from "@/web3.ts";

interface Patent {
  patentID: number;
  patentDetail: string;
  patentPrice: number;
}

let patents = ref<Patent[]>([]);
let pageSize = ref(10); // 每页显示行数
let currentPage = ref(1); // 当前页码

// 计算当前页显示的数据
const paginatedPatents = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value;
  const end = start + pageSize.value;
  return patents.value.slice(start, end);
});

let loading=ref(false);
let onsalepatent = ref<Patent | null>(null);

function handlePageChange(page:number){
	currentPage.value=page;
}

async function getPatents(){
	loading.value = true;
	try {
		//获取用户名下的专利
    // 获取当前用户地址
    const owner = localStorage.getItem("userAddress"); // 当前用户的地址

    console.log('owner:', owner);

    // Call the contract's fetchPatentsCanSale function
    const userPatentsForSale = await Patent.methods.fetchPatentsCanSale().call({
      from: owner,
      gas: "300000",
    });

    console.log('userPatentsForSale:', userPatentsForSale);

    // Ensure the response is an array before mapping
    if (Array.isArray(userPatentsForSale)) {
      patents.value = userPatentsForSale.map(patent => ({
        patentID: patent.patentId,
        patentDetail: patent.description,
        patentPrice: patent.price
      }));
    } else {
      patents.value = [];
    }
	}
	catch(error){
		ElMessage({message:'获取专利信息失败',type:'warning'});
	}
	finally{ 
		loading.value=false; 		
	}
}

onMounted(()=>{
	loadingText.value="查询专利中";
	getPatents();
})

function refresh(){
	loadingText.value="查询专利中";
	getPatents();
}

let show=ref(true);

async function onsale(row: Patent) {
  onsalepatent.value = row;
  console.log("onsalepatent", onsalepatent.value);
  const owner = localStorage.getItem("userAddress"); // 当前用户的地址
  try {
    console.log("onsalepatent patentID", onsalepatent.value.patentID);
    await Patent.methods.listForSale(onsalepatent.value.patentID).send({ from: owner });
    ElMessage.success('专利已成功上架出售');

    // Clear the patents array and fetch the latest data
    patents.value = [];
    await getPatents();
  } catch (error) {
    console.error('专利上架失败：', error);
    ElMessage.error('专利上架失败，请检查链上状态或钱包连接');
  }
}

function back(){
	show.value=true;
}

let price=ref(0);
let loadingText=ref("")

async function comfirmSale() {
  loading.value = true; // 开始查询时显示加载状态
  loadingText.value = "正在交易";
  try {
    // 获取当前用户地址
    const accounts = await web3.eth.getAccounts();
    const seller = accounts[0];

    // 调用合约的 listForSale 函数
    await PatentMarket.methods.listForSale(onsalepatent.value.patentID, price.value).send({ from: seller });

    ElMessageBox.alert('专利已成功上架出售', '交易成功', {
      confirmButtonText: '确认',
      callback: () => {
        ElMessage({
          type: 'success',
          message: '已返回',
        });
        show.value = true; // 或者 router.back();
      },
    });
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : '未知错误';
    ElMessageBox.alert(errorMessage, '交易失败', {
      confirmButtonText: '确认',
      callback: () => {
        ElMessage({
          type: 'error',
          message: '已返回',
        });
        show.value = true; // 或者 router.back();
      },
    });
  } finally {
    loading.value = false;
  }
}
</script>

<style scoped>
#a {
  position: relative;
  height: 100vh;
  background-color: rgba(0, 0, 0, 0.084);
}

#a .el-loading-spinner {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

	
#b{
	height: 50px;
	width: 1000px;
	display: flex;
	justify-content: space-between;
}
#c{
	width: 1100px;
	height: 450px;
	margin:0 auto;
}
#e{
	
	margin-top: -50px;
	display: flex;
	flex-direction: column;
	justify-content:space-around;
	height:600px;
	width: 1300px;
	background-color: #ffffff;
	border-radius: 30px;
	align-items: center;
}
#g{
	width: 80px;
	height: auto;
}
#h{
	width: 500px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	flex-direction: row;
	height: 50px;
}
#j{
	width: 80px;
}
#k{
	margin-top: 20px;
	width: 500px;
	height: 400px;
}
#m{
	margin-top: -50px;
	display: flex;
	justify-content:space-around;
	height:600px;
	width: 1300px;
	background-color: #ffffff;
	border-radius: 30px;
	align-items: center;
	
}
#n{
	display: flex;
	flex-direction: column;
	justify-content:center;
	height:600px;
	width: 500px;
	align-items: center;
}
#l{
	height: 350px;
}
#o{
	height: 200px;
	width: 500px;
	display: flex;
	flex-direction: column;
	justify-content: space-around;
	align-items: center;
}
#p{
	width: 350px;
}

</style>