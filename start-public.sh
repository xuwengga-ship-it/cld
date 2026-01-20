#!/bin/bash

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   Graph Ontology Explorer - 公网访问启动器                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}🌐 正在创建公网访问隧道...${NC}"
echo ""

# Check if services are running
if ! curl -s http://localhost:8080/api/health > /dev/null 2>&1; then
    echo -e "${RED}❌ 后端服务未运行，请先运行: ./start.sh${NC}"
    exit 1
fi

if ! curl -s http://localhost:3000/ > /dev/null 2>&1; then
    echo -e "${RED}❌ 前端服务未运行，请先运行: ./start.sh${NC}"
    exit 1
fi

echo -e "${GREEN}✓ 本地服务运行正常${NC}"
echo ""

# Start localtunnel for backend
echo -e "${BLUE}🔗 创建后端公网隧道 (端口 8080)...${NC}"
lt --port 8080 > /tmp/backend-tunnel.log 2>&1 &
BACKEND_TUNNEL_PID=$!
echo "$BACKEND_TUNNEL_PID" > /tmp/backend-tunnel.pid

# Start localtunnel for frontend
echo -e "${BLUE}🔗 创建前端公网隧道 (端口 3000)...${NC}"
lt --port 3000 > /tmp/frontend-tunnel.log 2>&1 &
FRONTEND_TUNNEL_PID=$!
echo "$FRONTEND_TUNNEL_PID" > /tmp/frontend-tunnel.pid

echo ""
echo -e "${YELLOW}⏳ 等待隧道建立连接...${NC}"
sleep 5

# Get tunnel URLs
BACKEND_URL=$(grep -o 'https://[^[:space:]]*' /tmp/backend-tunnel.log | head -1)
FRONTEND_URL=$(grep -o 'https://[^[:space:]]*' /tmp/frontend-tunnel.log | head -1)

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║              🎉 公网访问已启用！                          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

if [ -n "$FRONTEND_URL" ]; then
    echo -e "${GREEN}🌍 前端公网地址:${NC}"
    echo -e "${CYAN}   $FRONTEND_URL${NC}"
    echo ""
else
    echo -e "${YELLOW}⚠️  前端隧道地址获取中，请稍候查看日志: cat /tmp/frontend-tunnel.log${NC}"
    echo ""
fi

if [ -n "$BACKEND_URL" ]; then
    echo -e "${GREEN}🔌 后端公网地址:${NC}"
    echo -e "${CYAN}   $BACKEND_URL${NC}"
    echo ""
else
    echo -e "${YELLOW}⚠️  后端隧道地址获取中，请稍候查看日志: cat /tmp/backend-tunnel.log${NC}"
    echo ""
fi

echo -e "${BLUE}📱 本地访问地址:${NC}"
echo -e "   前端: http://localhost:3000"
echo -e "   后端: http://localhost:8080"
echo ""

echo -e "${YELLOW}📝 重要提示:${NC}"
echo "1. 公网地址可以在任何地方访问"
echo "2. localtunnel 提供的域名是随机的"
echo "3. 如果需要固定域名，可以使用参数: lt --port 3000 --subdomain yourname"
echo "4. 隧道将一直保持打开状态，直到手动停止"
echo ""

echo -e "${YELLOW}🛑 停止公网访问:${NC}"
echo "   ./stop-public.sh"
echo ""

echo -e "${YELLOW}📊 查看隧道日志:${NC}"
echo "   前端: cat /tmp/frontend-tunnel.log"
echo "   后端: cat /tmp/backend-tunnel.log"
echo ""

# Save URLs to file
cat > /tmp/public-urls.txt <<EOF
╔════════════════════════════════════════════════════════════╗
║   Graph Ontology Explorer - 公网访问地址                  ║
╚════════════════════════════════════════════════════════════╝

🌍 前端公网地址:
   $FRONTEND_URL

🔌 后端公网地址:
   $BACKEND_URL

📱 本地访问地址:
   前端: http://localhost:3000
   后端: http://localhost:8080

⏰ 生成时间: $(date)

💡 提示: 请使用前端公网地址访问系统
EOF

echo -e "${GREEN}✅ 公网地址已保存到: /tmp/public-urls.txt${NC}"
echo ""

# Wait a bit more to ensure tunnels are fully established
sleep 3

# Check again and display
BACKEND_URL=$(grep -o 'https://[^[:space:]]*' /tmp/backend-tunnel.log | head -1)
FRONTEND_URL=$(grep -o 'https://[^[:space:]]*' /tmp/frontend-tunnel.log | head -1)

if [ -n "$FRONTEND_URL" ] && [ -n "$BACKEND_URL" ]; then
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║          ✨ 准备就绪！请复制下方地址访问：                ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    echo -e "${CYAN}${FRONTEND_URL}${NC}"
    echo ""
    echo "🎯 直接在浏览器中打开上方地址即可使用系统！"
else
    echo -e "${YELLOW}正在建立连接，请等待几秒后运行以下命令查看地址：${NC}"
    echo "  cat /tmp/public-urls.txt"
fi

echo ""
echo "按 Ctrl+C 可以停止显示日志（隧道将继续运行）"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Keep script running and show logs
tail -f /tmp/frontend-tunnel.log /tmp/backend-tunnel.log
