import Web3 from "web3";
import type { AbiItem } from "web3-utils"; // 使用 type-only 导入
import UserContract from "../../patent-dapp/build/contracts/UserIdentityManagement.json";
import PatentContract from "../../patent-dapp/build/contracts/PatentRegistry.json";
import LicenseManageContract from "../../patent-dapp/build/contracts/PatentLicenseManagement.json";
import PatentMarketContract from "../../patent-dapp/build/contracts/PatentMarket.json";

// 定义合约 JSON 类型
interface ContractJSON {
  abi: AbiItem[];
  networks: { [key: string]: { address: string } };
}

// 确保合约类型符合 JSON 格式
const userContractJSON = UserContract as ContractJSON;
const patentContractJSON = PatentContract as ContractJSON;
const licenseManageJSON = LicenseManageContract as ContractJSON;
const patentMarketJSON = PatentMarketContract as ContractJSON;

const web3 = new Web3(new Web3.providers.HttpProvider("http://43.142.99.126:8545"));

// 获取网络 ID 和合约实例
const networkId = await web3.eth.net.getId(); // networkId 是 number 类型
const networkIdStr = networkId.toString();   // 转换为字符串类型

const User = new web3.eth.Contract(
  userContractJSON.abi,
  userContractJSON.networks[networkIdStr]?.address
);

const Patent = new web3.eth.Contract(
  patentContractJSON.abi,
  patentContractJSON.networks[networkIdStr]?.address
);

const LicenseManage = new web3.eth.Contract(
  licenseManageJSON.abi,
  licenseManageJSON.networks[networkIdStr]?.address
);

const PatentMarket = new web3.eth.Contract(
  patentMarketJSON.abi,
  patentMarketJSON.networks[networkIdStr]?.address
);

export { web3, User, Patent, LicenseManage, PatentMarket };