<template>
  <div class="patent-license">
    <div class="license-requests">
      <h3>收到的授权申请</h3>
      <el-table :data="licenseRequests" style="width: 100%" v-if="licenseRequests.length > 0">
        <el-table-column prop="patentId" label="专利ID"></el-table-column>
        <el-table-column prop="applicantName" label="申请人"></el-table-column>
        <el-table-column prop="requestDate" label="申请日期"></el-table-column>
        <el-table-column label="操作">
          <template #default="scope">
            <div class="button-group" v-if="scope && scope.row">
              <el-button @click="approveRequest(scope.row)" type="success" size="small">Approve</el-button>
              <el-button @click="denyRequest(scope.row)" type="danger" size="small">Deny</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
      <p v-else>暂无授权申请</p>
    </div>
    <div class="patent-apply">
      <div slot="header" class="clearfix">
        <h3>申请授权</h3>
      </div>
      <el-table :data="filteredPatents.length > 0 ? filteredPatents : null" style="width: 100%">
        <el-table-column prop="id" label="专利ID"></el-table-column>
        <el-table-column prop="status" label="状态"></el-table-column>
        <el-table-column prop="fee" label="费用"></el-table-column>
        <el-table-column label="操作">
          <template #default="scope">
            <el-button @click="requestLicense(scope.row.patentId)">申请授权</el-button>
          </template>
        </el-table-column>
      </el-table>
      <p v-if="searchQuery && filteredPatents.length === 0">No related patents found</p>
      <p v-else-if="!searchQuery && filteredPatents.length === 0">No patents available for licensing</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import { web3, PatentLicenseManagement } from '@/web3';

interface LicenseRequest {
  patentId: number;
  applicantName: string;
  requestDate: string;
}

interface Patent {
  patentId: number;
  status: string;
  fee: number;
}

const searchQuery = ref('');
const licenseRequests = ref<LicenseRequest[]>([]);
const filteredPatents = ref<Patent[]>([]);

async function getLicenseRequests() {
  try {
    const accounts = await web3.eth.getAccounts();
    const user = accounts[0];
    const requests = await PatentLicenseManagement.methods.getLicenseRequests(user).call();
    licenseRequests.value = requests.map((request: any) => ({
      patentId: request.patentId,
      applicantName: request.applicantName,
      requestDate: new Date(request.requestDate * 1000).toLocaleDateString(),
    }));
  } catch (error) {
    ElMessage({ message: 'Failed to fetch license requests', type: 'warning' });
  }
}

async function getAvailablePatents() {
  try {
    const accounts = await web3.eth.getAccounts();
    const user = accounts[0];
    const patents = await PatentLicenseManagement.methods.fetchAvailablePatents(user).call();
    filteredPatents.value = patents.map((patent: any) => ({
      patentId: patent.patentId,
      status: patent.status,
      fee: patent.fee,
    }));
  } catch (error) {
    ElMessage({ message: 'Failed to fetch available patents', type: 'warning' });
  }
}

async function approveRequest(request: LicenseRequest) {
  try {
    await ElMessageBox.confirm('Are you sure you want to approve this license request?', 'Warning', {
      confirmButtonText: 'Confirm',
      cancelButtonText: 'Cancel',
      type: 'warning',
    });

    const accounts = await web3.eth.getAccounts();
    const user = accounts[0];
    await PatentLicenseManagement.methods.approveLicenseRequest(request.patentId, request.applicantName).send({ from: user });

    ElMessage({ message: `Approved license request for patent ID ${request.patentId}`, type: 'success' });
    getLicenseRequests();
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage({ message: 'Failed to approve license request, please try again', type: 'error' });
    }
  }
}

async function denyRequest(request: LicenseRequest) {
  try {
    await ElMessageBox.confirm('Are you sure you want to deny this license request?', 'Warning', {
      confirmButtonText: 'Confirm',
      cancelButtonText: 'Cancel',
      type: 'error',
    });

    const accounts = await web3.eth.getAccounts();
    const user = accounts[0];
    await PatentLicenseManagement.methods.denyLicenseRequest(request.patentId, request.applicantName).send({ from: user });

    ElMessage({ message: `Denied license request for patent ID ${request.patentId}`, type: 'info' });
    getLicenseRequests();
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage({ message: 'Failed to deny license request, please try again', type: 'error' });
    }
  }
}

async function requestLicense(patentId: number) {
  try {
    const accounts = await web3.eth.getAccounts();
    const user = accounts[0];
    await PatentLicenseManagement.methods.requestLicense(patentId).send({ from: user });

    ElMessage({ message: `Requested license for patent ID ${patentId}`, type: 'success' });
  } catch (error) {
    ElMessage({ message: 'Failed to request license, please try again', type: 'error' });
  }
}

function searchPatents() {
  // Implement search logic if needed
}

onMounted(() => {
  getLicenseRequests();
  getAvailablePatents();
});
</script>

<style scoped>
.header {
  color: #333;
  text-align: center;
  margin-bottom: 20px;
}

.form-container,
.license-requests,
.patent-apply {
  max-width: 800px;
  margin: 0 auto;
}
</style>