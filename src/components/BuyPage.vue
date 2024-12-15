<template>
	<div v-loading="loading" :element-loading-text='loadingText' id="a" >
		<div id="b">
		    <div id="i">
				<div id="e">
					<el-button type="primary" id="d" @click="back">返回</el-button>
					<h2 id="c">正在购买专利</h2>
				</div>
				<el-card  id="f">
					<template #header>
					  <div>
						<span>专利ID：{{patents.patentID}}</span>
					  </div>
					</template>
					<div id="g">
						<el-scrollbar>
							<el-text>专利描述：<br>{{patents.patentDetail}}</el-text>
						</el-scrollbar>
					</div>
					<template #footer>
						<span>价格：{{patents.price}}</span>
					</template>
				</el-card>
			</div>
			<el-divider direction="vertical" border-style="solid" />
			<div id ="h">
				<div id="j">
					<el-input v-model="password" placeholder="请输入密码"  show-password />
				</div>
				<div id="l"></div>
				<el-button type="danger" id="k" @click="buy">购买</el-button>
			</div>
		</div>
	</div>
</template>

<script lang="ts" setup name="BuyPage">
import {ref,computed, onMounted} from "vue";
import { useRouter,useRoute } from 'vue-router';
import axios from "axios";
import { ElMessage, ElMessageBox } from "element-plus";
let password = ref("");
const router = useRouter();
const route = useRoute();
let loading = ref(false);
interface patent {patentID:string,patentDetail:string,price:number};
let patents= ref<patent>({patentID:"",patentDetail:"",price:0});
let loadingText = ref("");
async function query() {
  loading.value = true; // 开始查询时显示加载状态 
  loadingText.value="交易订单生成中";
  try {
	  //根据id查询专利的信息。
    const response = await axios.get('/api/patents', {
      params: { id: route.query.id }
    });
    //patents.value = response.data; // 更新专利列表
  } catch (error) {
    ElMessageBox.alert(error, "生成交易订单失败", {
      confirmButtonText: '确认',
      callback: (action) => {
        ElMessage({
          type: 'error',
          message:'已返回上一级界面',
        });
        router.go(-1); // 或者 router.back();
      },
    });
  } finally {
	loading.value=false;
  }
}

onMounted(()=>{
	query();
});


async function buy(){
	loading.value = true; // 开始查询时显示加载状态
	loadingText.value="正在交易";
	try {
		  //购买
	  const response = await axios.get('/api/patents', {
	    params: { id: route.query.id }
	  });
	  const msg = response.data; //交易结果
	  ElMessageBox.alert(msg, '交易成功', {
	    confirmButtonText: '确认',
	    callback: (action) => {
	      ElMessage({
	        type: 'success',
	        message:'已返回上一级界面',
	      });
	      router.go(-1); // 或者 router.back();
	    },
	  });
	} catch (error) {
	   ElMessageBox.alert(error, '交易失败', {
	     confirmButtonText: '确认',
	     callback: (action) => {
	       ElMessage({
	         type: 'error',
	         message:'已返回上一级界面',
	       });
	       router.go(-1); // 或者 router.back();
	     },
	   });
	} finally {
	  loading.value=false;
	}
}
	
function back(){
    router.go(-1);
}
</script>

<style>
#a{
	width: 100%;
	height: 100%;
	background-color:  rgba(0, 0, 0, 0.084);
	display: flex;
	justify-content: center;
	align-items: center;
}

#b{
    width: 1000px;
	height: 600px;
	background-color: #ffffff;
	border-radius: 20px;
	display: flex;
	align-items: center;
	justify-content: center;
}
#e{
	width: 500px;
	height: 50px;
	display: flex;
	align-items: center;
}
#c{
	font-weight: 800;
	margin-left: 100px;
}
#d {
	margin-left: 20px;
}
#f{
	margin-top: 10px;
	width: 400px;
}
#g {
  width: 100%;
  height: 300px;  /* 设置最大高度，限制滚动区域的高度 */
  overflow-y: auto;   /* 启用垂直滚动 */
  padding-right: 10px; /* 防止内容与滚动条重叠 */
  box-sizing: border-box;
}
#i{
	display: flex;
	flex-direction: column;
	align-items: center;
}
#h{
	width: 300px;
	height: 500px;
	display: flex;
	flex-direction:column;
	align-items: center;
	justify-content: center;
}
#j{
	width: 250px;
}
#l{
	height: 50px;
}

</style>