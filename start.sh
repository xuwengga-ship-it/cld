#!/bin/bash

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   Graph Ontology Explorer - 启动脚本                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if backend-node directory exists
if [ ! -d "backend-node" ]; then
    echo -e "${YELLOW}⚠️  backend-node 目录不存在${NC}"
    exit 1
fi

# Check if frontend directory exists
if [ ! -d "frontend" ]; then
    echo -e "${YELLOW}⚠️  frontend 目录不存在${NC}"
    exit 1
fi

# Start backend
echo -e "${BLUE}🚀 启动后端服务...${NC}"
cd backend-node

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}📦 安装后端依赖...${NC}"
    npm install
fi

node server.js > /tmp/backend.log 2>&1 &
BACKEND_PID=$!
echo -e "${GREEN}✓ 后端服务已启动 (PID: $BACKEND_PID)${NC}"
echo -e "${GREEN}  地址: http://localhost:8080${NC}"

cd ..

# Start frontend
echo ""
echo -e "${BLUE}🚀 启动前端服务...${NC}"
cd frontend

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}📦 安装前端依赖...${NC}"
    npm install
fi

npm run dev > /tmp/frontend.log 2>&1 &
FRONTEND_PID=$!
echo -e "${GREEN}✓ 前端服务已启动 (PID: $FRONTEND_PID)${NC}"
echo -e "${GREEN}  地址: http://localhost:3000${NC}"

cd ..

# Wait for services to start
echo ""
echo -e "${YELLOW}⏳ 等待服务启动...${NC}"
sleep 3

# Test services
echo ""
echo -e "${BLUE}🔍 检查服务状态...${NC}"

# Test backend
if curl -s http://localhost:8080/api/health > /dev/null 2>&1; then
    echo -e "${GREEN}✓ 后端服务运行正常${NC}"
else
    echo -e "${YELLOW}⚠️  后端服务可能未完全启动${NC}"
fi

# Test frontend
if curl -s http://localhost:3000/ > /dev/null 2>&1; then
    echo -e "${GREEN}✓ 前端服务运行正常${NC}"
else
    echo -e "${YELLOW}⚠️  前端服务可能未完全启动${NC}"
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    服务已成功启动！                        ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}🌐 请在浏览器中访问：${NC}"
echo -e "${BLUE}   Frontend: http://localhost:3000${NC}"
echo -e "${BLUE}   Backend:  http://localhost:8080${NC}"
echo ""
echo -e "${YELLOW}📝 日志文件：${NC}"
echo "   Backend:  /tmp/backend.log"
echo "   Frontend: /tmp/frontend.log"
echo ""
echo -e "${YELLOW}🛑 停止服务：${NC}"
echo "   ./stop.sh"
echo ""
echo "按 Ctrl+C 可以停止此脚本（服务将继续在后台运行）"
echo ""

# Save PIDs
echo "$BACKEND_PID" > /tmp/backend.pid
echo "$FRONTEND_PID" > /tmp/frontend.pid

# Keep script running
tail -f /tmp/backend.log
