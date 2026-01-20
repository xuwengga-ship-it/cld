#!/bin/bash

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   Graph Ontology Explorer - 停止公网访问                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Stop frontend tunnel
if [ -f "/tmp/frontend-tunnel.pid" ]; then
    FRONTEND_PID=$(cat /tmp/frontend-tunnel.pid)
    if ps -p $FRONTEND_PID > /dev/null 2>&1; then
        kill $FRONTEND_PID
        echo -e "${GREEN}✓ 前端公网隧道已停止${NC}"
    fi
    rm /tmp/frontend-tunnel.pid
fi

# Stop backend tunnel
if [ -f "/tmp/backend-tunnel.pid" ]; then
    BACKEND_PID=$(cat /tmp/backend-tunnel.pid)
    if ps -p $BACKEND_PID > /dev/null 2>&1; then
        kill $BACKEND_PID
        echo -e "${GREEN}✓ 后端公网隧道已停止${NC}"
    fi
    rm /tmp/backend-tunnel.pid
fi

# Also kill any remaining lt processes
pkill -f "lt --port" 2>/dev/null
echo -e "${GREEN}✓ 所有公网隧道已清理${NC}"

echo ""
echo -e "${YELLOW}💡 本地服务仍在运行:${NC}"
echo "   前端: http://localhost:3000"
echo "   后端: http://localhost:8080"
echo ""
echo "如需停止本地服务，请运行: ./stop.sh"
echo ""
