<template>
  <div class="patent-register">
    <h3>专利注册</h3>
    <el-form :model="form" ref="patentForm" class="form-container">
      <el-form-item label="专利描述" prop="description" class="custom-form-item">
        <el-input type="textarea" v-model="form.description" placeholder="请描述您的专利" class="large-textarea"></el-input>
      </el-form-item>
      <el-form-item class="button-container">
        <el-button @click="resetForm" class="clean-button">清空</el-button>
        <el-button type="primary" @click="submitPatent" class="register-button">立即注册</el-button>
      </el-form-item>
    </el-form>
  </div>
  <div class="patent-store">
    <h3>已注册专利列表</h3>
    <el-table :data="patents" style="width: 100%" v-if="patents.length > 0">
      <el-table-column prop="patentId" label="专利ID"></el-table-column>
      <el-table-column prop="description" label="描述"></el-table-column>
      <el-table-column prop="registerationTime" label="授权时间"></el-table-column>
      <el-table-column prop="expiryTime" label="到期时间"></el-table-column>
      <el-table-column label="是否到期">
          <template #default="scope">{{ scope.row.isExpired ? '是' : '否' }}</template>
        </el-table-column>
    </el-table>
    <p v-else>暂无专利</p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      form: {
        description: ''
      },
      patents: [{
        patentId: 1,
        description: '这是一个测试专利',
        registerationTime: '2024-01-01',
        expiryTime: '2025-01-01',
        isExpired: false
      }]
    };
  },
  methods: {
    resetForm() {
      this.$refs.patentForm.resetFields();
    },
    submitPatent() {
      // 模拟提交专利逻辑
      if (this.form.description) {
        this.$confirm('确定要注册该专利吗？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.patents.push({
            patentId: this.patents.length + 1,
            description: this.form.description,
            registerationTime: new Date().toISOString().split('T')[0],
            expiryTime: new Date(new Date().setFullYear(new Date().getFullYear() + 1)).toISOString().split('T')[0],
            isExpired: false
          });
          this.$message({
            message: '注册成功',
            type: 'success'
          });
          this.resetForm();
        }).catch(() => {
          this.$message({
            type: 'info',
            message: '已取消注册'
          });
        });
      } else {
        this.$message.error('注册失败：请填写专利描述');
      }
    }
  }
};
</script>

<style scoped>
.form-container {
  margin: 0 auto;
}

.custom-form-item .el-form-item__content {
  padding: 5px 10px;
  border-radius: 4px;
  display: flex;
  justify-content: center;
}

.custom-form-item .large-textarea {
  width: 100%;
  box-sizing: border-box; 
  color: white;
  padding: 5px 10px;
  border-radius: 4px;
}

.custom-form-item .el-form-item__label {
  text-align: center;
  width: 100%; 
  background-color: #007bff;
  color: white;
  padding: 5px 10px;
  border-radius: 4px;
  margin-bottom: 10px;
}


.large-textarea {
  width: 800px;
}

.button-container {
  display: flex;
  justify-content: center;
  gap: 20px;
}

.clean-button{
  margin-left:30px;
  margin-right:40px
}


</style>