#!/bin/bash

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   Graph Ontology Explorer - 停止脚本                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Stop backend
echo -e "${BLUE}🛑 停止后端服务...${NC}"
if [ -f "/tmp/backend.pid" ]; then
    BACKEND_PID=$(cat /tmp/backend.pid)
    if ps -p $BACKEND_PID > /dev/null 2>&1; then
        kill $BACKEND_PID
        echo -e "${GREEN}✓ 后端服务已停止 (PID: $BACKEND_PID)${NC}"
    else
        echo -e "${YELLOW}⚠️  后端服务未运行${NC}"
    fi
    rm /tmp/backend.pid
else
    # Try to kill by port
    BACKEND_PID=$(lsof -ti:8080)
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID
        echo -e "${GREEN}✓ 后端服务已停止 (PID: $BACKEND_PID)${NC}"
    else
        echo -e "${YELLOW}⚠️  后端服务未运行${NC}"
    fi
fi

# Stop frontend
echo -e "${BLUE}🛑 停止前端服务...${NC}"
if [ -f "/tmp/frontend.pid" ]; then
    FRONTEND_PID=$(cat /tmp/frontend.pid)
    if ps -p $FRONTEND_PID > /dev/null 2>&1; then
        kill $FRONTEND_PID
        echo -e "${GREEN}✓ 前端服务已停止 (PID: $FRONTEND_PID)${NC}"
    else
        echo -e "${YELLOW}⚠️  前端服务未运行${NC}"
    fi
    rm /tmp/frontend.pid
else
    # Try to kill by port
    FRONTEND_PID=$(lsof -ti:3000)
    if [ ! -z "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID
        echo -e "${GREEN}✓ 前端服务已停止 (PID: $FRONTEND_PID)${NC}"
    else
        echo -e "${YELLOW}⚠️  前端服务未运行${NC}"
    fi
fi

# Stop demo server
DEMO_PID=$(lsof -ti:8080 2>/dev/null | head -1)
if [ ! -z "$DEMO_PID" ]; then
    kill $DEMO_PID 2>/dev/null
    echo -e "${GREEN}✓ Demo服务已停止${NC}"
fi

echo ""
echo -e "${GREEN}✅ 所有服务已停止${NC}"
echo ""
