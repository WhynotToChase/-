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
              <el-button @click="approveRequest(scope.row)" type="success" size="small">批准</el-button>
              <el-button @click="denyRequest(scope.row)" type="danger" size="small">拒绝</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
      <p v-else>暂无授权申请</p>
    </div>
    <div class="patent-apply">
      <div slot="header" class="clearfix" >
        <h3>申请授权</h3>
        <div class="search-container" style="float: left">
          <el-input v-model="searchQuery" placeholder="搜索专利..." style="width: 200px;margin-right:20px"></el-input>
          <el-button class="search-button" >搜索</el-button>
        </div>
      </div>
      <el-table :data="filteredPatents.length > 0 ? filteredPatents : null" style="width: 100%">
        <el-table-column prop="id" label="专利ID"></el-table-column>
        <el-table-column prop="status" label="状态"></el-table-column>
        <el-table-column prop="fee" label="费用"></el-table-column>
        <el-table-column label="操作">
          <template #default="scope">
            <el-button @click="requestLicense(scope.row.id)">申请授权</el-button>
          </template>
        </el-table-column>
      </el-table>
      <p v-if="searchQuery && filteredPatents.length === 0">没有找到相关专利</p>
      <p v-else-if="!searchQuery && filteredPatents.length === 0">暂无专利可供授权</p>
    </div>
    <!-- 新增专利信息设置表单 -->
    <div class="patent-setting">
      <h3>设置专利费用</h3>
      <el-form :model="patentForm" label-width="120px" ref="patentForm">
        <el-form-item label="选择专利">
          <el-select v-model="patentForm.selectedPatentId" placeholder="请选择专利" @change="onPatentSelect">
            <el-option
              v-for="patent in ownedPatents"
              :key="patent.id"
              :label="patent.name"
              :value="patent.id"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="申请费用" v-if="patentForm.selectedPatentId !== ''">
          <el-input-number v-model="patentForm.applicationFee" controls-position="right" :min="0"></el-input-number>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitPatentFee">保存费用</el-button>
          <el-button @click="resetPatentForm">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      searchQuery:'',
      patentForm: {
        name: '',
        description: '',
        applicationFee: 0, // 默认值为0
      },
      licenseRequests: [
        { patentId: 1, applicantName: '张三', requestDate: '2024-12-15' }
      ],
      filteredPatents: [{ id: 1, status: "Expired", fee: 400 }]
    };
  },
  methods: {
    approveRequest(request) {
      this.$confirm('确定要批准此授权申请吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        // 执行批准逻辑
        this.$message({
          message: `已批准专利ID为${request.patentId}的授权申请`,
          type: 'success'
        });
        // 假设批准后从列表中移除该条目
        this.licenseRequests = this.licenseRequests.filter(req => req !== request);
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消批准'
        });
      });
    },
    denyRequest(request) {
      this.$confirm('确定要拒绝此授权申请吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'error'
      }).then(() => {
        // 执行拒绝逻辑
        this.$message({
          message: `已拒绝专利ID为${request.patentId}的授权申请`,
          type: 'info'
        });
        // 假设拒绝后从列表中移除该条目
        this.licenseRequests = this.licenseRequests.filter(req => req !== request);
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消拒绝'
        });
      });
    }
  }
};
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