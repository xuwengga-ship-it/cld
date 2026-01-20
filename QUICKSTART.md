# 快速启动指南

## 🚀 一键启动

系统已经在本地运行！

### 当前运行状态

✅ **后端服务**: http://localhost:8080
- Node.js Express后端
- RESTful API
- 内存数据库（包含示例数据）

✅ **前端服务**: http://localhost:3000
- Vue 3 + AntV X6
- 完整图谱可视化界面
- 所有6大功能已实现

## 🌐 访问地址

**立即访问前端**: http://localhost:3000

**API文档**: http://localhost:8080/api/health

## 📋 功能清单

### 1️⃣ 图谱可视化
- 拖拽节点
- 缩放、平移
- 自动布局

### 2️⃣ 周边搜索
1. 点击选择节点
2. 点击"周边搜索"按钮
3. 选择关系类型
4. 设置搜索深度
5. 查看结果

### 3️⃣ 对象属性面板
- 点击任意节点
- 左侧显示详细属性

### 4️⃣ 时间轴
- 拖动底部时间滑块
- 查看不同时间点的图谱

### 5️⃣ 动作按钮
- 选择节点
- 点击"动作"
- 执行操作

### 6️⃣ 新增对象
- 点击"新增对象"
- 选择类型和实例
- 批量添加到画布

## 🎮 快速体验流程

```bash
# 1. 打开浏览器访问
http://localhost:3000

# 2. 点击"海王集团股份有限公司"节点
#    → 左侧显示详细信息

# 3. 保持选中，点击"周边搜索"
#    → 选择关系类型
#    → 点击"搜索"
#    → 查看新增节点

# 4. 点击"自动布局"
#    → 图谱自动优化排列

# 5. 点击"新增对象"
#    → 选择"公司"类型
#    → 多选"阿里巴巴"、"腾讯"等
#    → 添加到画布
```

## 🔧 管理命令

### 启动服务（如果停止了）

```bash
cd /home/user/cld
./start.sh
```

### 停止服务

```bash
cd /home/user/cld
./stop.sh
```

### 查看日志

```bash
# 后端日志
tail -f /tmp/backend.log

# 前端日志
tail -f /tmp/frontend.log
```

### 重启服务

```bash
./stop.sh && ./start.sh
```

## 📊 预置数据

系统包含以下示例数据：

**本体类型** (5个)
- 公司
- 供应商
- 经销商
- 产品
- 人员

**实体实例** (11个)
- 海王集团股份有限公司
- 宁波海龙科技有限公司
- 南京科技有限公司
- 供应商A/B/C
- 经销商A/B
- 中国医药集团
- 阿里巴巴集团
- 腾讯控股

**关系类型** (5种)
- 拥有
- 供应
- 销售
- 合作
- 关联

**动作** (6个)
- 查看详情
- 编辑信息
- 查看报表
- 添加子公司
- 查看供应信息
- 查看销售数据

## 🔌 API接口

### 健康检查
```bash
curl http://localhost:8080/api/health
```

### 获取所有本体类型
```bash
curl http://localhost:8080/api/ontology/types
```

### 获取图谱数据
```bash
curl http://localhost:8080/api/graph/data
```

### 周边搜索
```bash
curl -X POST http://localhost:8080/api/graph/peripheral-search \
  -H "Content-Type: application/json" \
  -d '{
    "entityIds": [1],
    "relationTypeIds": [1, 2],
    "depth": 2
  }'
```

### 获取实体详情
```bash
curl http://localhost:8080/api/graph/entity/1
```

### 获取对象类型的动作
```bash
curl http://localhost:8080/api/graph/actions/1
```

## 🛠️ 技术栈

### 后端
- **Node.js** + Express
- **内存数据库**（快速启动）
- **CORS**支持
- **RESTful API**

### 前端
- **Vue 3** (Composition API)
- **AntV X6** (图谱可视化)
- **Element Plus** (UI组件)
- **Vite** (构建工具)

## 📁 目录结构

```
/home/user/cld/
├── backend-node/          # Node.js后端
│   ├── server.js         # Express服务器
│   ├── package.json
│   └── node_modules/
├── frontend/             # Vue 3前端
│   ├── src/
│   │   ├── views/GraphExplorer.vue
│   │   ├── api/graph.js
│   │   └── main.js
│   ├── package.json
│   └── node_modules/
├── start.sh             # 启动脚本
├── stop.sh              # 停止脚本
└── QUICKSTART.md        # 本文档
```

## ❓ 常见问题

### 端口被占用

如果8080或3000端口被占用：

```bash
# 查找占用进程
lsof -ti:8080
lsof -ti:3000

# 停止进程
./stop.sh
```

### 服务无法访问

```bash
# 检查服务状态
curl http://localhost:8080/api/health
curl http://localhost:3000/

# 查看日志
cat /tmp/backend.log
cat /tmp/frontend.log

# 重启服务
./stop.sh && ./start.sh
```

### 依赖未安装

```bash
# 后端
cd backend-node
npm install

# 前端
cd frontend
npm install
```

## 🎯 下一步

1. ✅ 系统已运行 - 访问 http://localhost:3000
2. 🎨 体验所有功能
3. 📝 查看和修改示例数据
4. 🔧 根据需求自定义开发

## 💡 提示

- **自动保存**: 所有操作实时生效
- **数据重置**: 重启服务后数据恢复初始状态
- **并发支持**: 支持多用户同时访问
- **响应式**: 支持不同屏幕尺寸

---

🎉 **享受使用 Graph Ontology Explorer！**
