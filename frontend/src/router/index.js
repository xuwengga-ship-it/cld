import { createRouter, createWebHistory } from 'vue-router'
import GraphExplorer from '../views/GraphExplorer.vue'

const routes = [
  {
    path: '/',
    name: 'GraphExplorer',
    component: GraphExplorer
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
