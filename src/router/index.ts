import { createRouter, createWebHistory } from 'vue-router';

import Login from "../views/Login.vue";
import Register from "../views/Register.vue";
import Home from "../views/Home.vue";
import PatentRegister from '../components/PatentRegister.vue';
import PatentLicense from '../components/PatentLicense.vue';
import PatentBuy from '../components/PatentBuy.vue';
import PatentMonitor from '../components/PatentMonitor.vue';
import PersonalInfo from '../components/PersonalInfo.vue';
import AcquiesceConent from '../components/AcquiesceContent.vue';
import Buy from '../components/BuyPage.vue';
import Sell from '../components/SellPage.vue'

const Router = createRouter({
  history:createWebHistory(),
  routes:[
    { path: "/", component: Login },
    { path: "/register", component: Register },
    { path: "/home", component: Home ,
      children:[
        { path: "",component: AcquiesceConent},
        { path: "patent-register", component: PatentRegister },
        { path: "patent-license", component: PatentLicense },
        { path: "patent-buy", component: PatentBuy },
        { path: "patent-monitor", component: PatentMonitor },
        { path: "personal-info", component: PersonalInfo },
		{ path: "buy",component: Buy},
		{path:"sell",component:Sell},
      ],
    },
	
  ]
});

export default  Router;
