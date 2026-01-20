#!/bin/bash

echo "═══════════════════════════════════════════════════════════════"
echo "  Graph Ontology Explorer - 公网访问地址获取"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Check if frontend is accessible locally
if ! curl -s http://localhost:3000/ > /dev/null 2>&1; then
    echo "❌ 前端服务未运行，请先启动服务"
    exit 1
fi

echo "🚀 正在创建公网隧道..."
echo ""

# Create a temporary file for the URL
TEMP_FILE=$(mktemp)

# Start localtunnel and capture output
lt --port 3000 2>&1 | tee $TEMP_FILE &
LT_PID=$!

# Wait for the URL to appear
for i in {1..30}; do
    if grep -q "https://" $TEMP_FILE; then
        break
    fi
    sleep 1
    echo -n "."
done
echo ""

# Extract and display the URL
PUBLIC_URL=$(grep -o 'https://[^[:space:]]*' $TEMP_FILE | head -1)

if [ -n "$PUBLIC_URL" ]; then
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║              ✅ 公网访问已启用！                          ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    echo "🌍 公网访问地址:"
    echo ""
    echo "   $PUBLIC_URL"
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo "📱 复制上方地址到浏览器即可访问系统"
    echo "🔗 此隧道将保持开启状态"
    echo "🛑 按 Ctrl+C 停止公网访问"
    echo ""

    # Save the PID and URL
    echo $LT_PID > /tmp/public-tunnel.pid
    echo $PUBLIC_URL > /tmp/public-url.txt

    # Keep the tunnel running
    wait $LT_PID
else
    echo "❌ 无法创建公网隧道，请检查网络连接"
    kill $LT_PID 2>/dev/null
    rm $TEMP_FILE
    exit 1
fi

rm $TEMP_FILE
