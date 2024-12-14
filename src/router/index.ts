import { createRouter, createWebHistory } from 'vue-router';

import Login from "../views/Login.vue";
import Register from "../views/Register.vue";
import Home from "../views/Home.vue";
import PatentRegister from '../components/PatentRegister.vue';
import PatentLicense from '../components/PatentLicense.vue';
import PatentBuySell from '../components/PatentBuySell.vue';
import PatentMonitor from '../components/PatentMonitor.vue';
import PersonalInfo from '../components/PersonalInfo.vue';
import AcquiesceConent from '../components/AcquiesceContent.vue';

const Router = createRouter({
  history:createWebHistory(),
  routes:[
    { path: "/", component: Login },
    { path: "/register", component: Register },
    { path: "/home", component: Home ,
      children:[
        { path: "",component: AcquiesceConent},
        { path: "/patent-register", component: PatentRegister },
        { path: "/patent-license", component: PatentLicense },
        { path: "/patent-buy-sell", component: PatentBuySell },
        { path: "/patent-monitor", component: PatentMonitor },
        { path: "/personal-info", component: PersonalInfo },
      ],
    },
  ]
});

export default  Router;
