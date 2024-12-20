<template>
  <div id="a" v-loading="loading" :element-loading-text="loadingText">
    <div id="d4">
      <el-table :data="paginatedPatents" border stripe id="d5">
        <el-table-column fixed prop="patentID" label="专利ID" width="150" />
        <el-table-column prop="price" label="专利价格/￥" width="150" />
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
import { ElMessage, ElMessageBox } from 'element-plus';
import { useRouter } from 'vue-router';
import { web3, PatentMarket } from '@/web3';

const router = useRouter();

interface Patent {
  patentID: string;
  patentDetail: string;
  price: number;
}

let loading = ref(false);
let loadingText = ref("查询中...");
let patents = ref<Patent[]>([]);
let pageSize = ref(10);
let currentPage = ref(1);

// 计算当前页显示的数据
const paginatedPatents = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value;
  const end = start + pageSize.value;
  return patents.value.slice(start, end);
});

// 切换分页
function handlePageChange(page: number) {
  currentPage.value = page;
}

// 获取所有可购买的专利
async function getPatents() {
  loading.value = true;
  try {
    // 获取当前用户地址
    const accounts = await web3.eth.getAccounts();
    const buyer = accounts[0];

    // 调用合约的 fetchMarketPatents 函数
    const marketPatents = await PatentMarket.methods.fetchMarketPatents().call();

    // 确保返回的数据是数组
    if (Array.isArray(marketPatents)) {
      patents.value = marketPatents.map((patent: any) => ({
        patentID: patent.patentId,
        patentDetail: patent.description,
        price: patent.price
      }));
    } else {
      patents.value = [];
    }
  } catch (error) {
    ElMessage({ message: '获取专利信息失败', type: 'warning' });
  } finally {
    loading.value = false;
  }
}

// 购买专利
async function buy(row: Patent) {
  loading.value = true;
  loadingText.value = "正在购买...";
  try {
    // 获取当前用户地址
    const accounts = await web3.eth.getAccounts();
    const buyer = accounts[0];

    // 调用合约的 buyPatent 函数
    await PatentMarket.methods.buyPatent(row.patentID).send({ from: buyer, value: row.price });

    ElMessageBox.alert('专利购买成功', '交易成功', {
      confirmButtonText: '确认',
      callback: () => {
        ElMessage({
          type: 'success',
          message: '已返回',
        });
        getPatents(); // 重新获取专利列表
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
      },
    });
  } finally {
    loading.value = false;
  }
}

onMounted(() => {
  getPatents();
});
</script>

<style scoped>
/* 页面样式 */
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