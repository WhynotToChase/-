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
import { ref, onMounted } from "vue";
import { web3, Patent } from "@/web3";

export default {
  data() {
    return {
      form: {
        description: ''
      },
      patents: [], // 专利列表
    };
  },
  methods: {
    resetForm() {
      this.$refs.patentForm.resetFields();
    },
    async submitPatent() {
      if (!this.form.description) {
        this.$message.error('注册失败：请填写专利描述');
        return;
      }

      try {
        const owner = localStorage.getItem("userAddress"); // 当前用户的地址
        const patentId = Math.floor(Math.random() * 100000); // 随机生成专利ID
        const duration = 365 * 24 * 60 * 60; // 专利有效期（1年，单位：秒）

        console.log("owner", owner);
        console.log("patentId", patentId);
        console.log("description", this.form.description);
        console.log("duration", duration);
        // 调用合约的 registerPatent 方法
        await Patent.methods
          .registerPatent(patentId, this.form.description, duration)
          .send({ 
            from: owner,
            gas: "300000", // 设置 gasLimit  
          });

        this.$message.success('专利注册成功');
        this.resetForm(); // 清空表单
        this.fetchPatents(); // 刷新专利列表
      } catch (error) {
        console.error('专利注册失败：', error);
        this.$message.error('专利注册失败，请检查链上状态或钱包连接');
      }
    },
    async fetchPatents() {
      try {
        const owner = localStorage.getItem("userAddress"); // 当前用户的地址

        this.patents = []; // 清空专利列表

        // 调用合约方法获取当前用户的专利ID列表
        const patentIds = await Patent.methods.getUserPatents().call({ from: owner });

        for (const patentId of patentIds) {
          const patent = await Patent.methods.getPatent(patentId).call();
          const isExpired = await Patent.methods.isPatentExpired(patentId).call();

          // 将时间戳从 BigInt 转为 Number
          const registrationTime = Number(patent[3]);
          const expiryTime = Number(patent[4]);

          this.patents.push({
            patentId: patent[0],
            description: patent[1],
            registerationTime: new Date(registrationTime * 1000).toISOString().split("T")[0],
            expiryTime: new Date(expiryTime * 1000).toISOString().split("T")[0],
            isExpired: isExpired,
          });
        }
      } catch (error) {
        console.error('获取专利信息失败：', error);
        this.$message.error('获取专利信息失败，请检查链上状态或钱包连接');
      }
    }
  },
  mounted() {
    this.fetchPatents();
  },
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