#!/bin/bash

clear

cat << "EOF"
╔════════════════════════════════════════════════════════════╗
║   Graph Ontology Explorer - 公网访问启动器                ║
╚════════════════════════════════════════════════════════════╝
EOF

echo ""
echo "🚀 正在创建公网隧道，请稍候..."
echo ""

# Check if local service is running
if ! curl -s http://localhost:3000/ > /dev/null 2>&1; then
    echo "❌ 前端服务未运行"
    echo "📝 请先运行: cd /home/user/cld && ./start.sh"
    echo ""
    exit 1
fi

echo "✓ 本地服务运行正常"
echo ""

# Execute localtunnel
echo "═══════════════════════════════════════════════════════════════"
echo "  等待公网地址生成（约10-15秒）..."
echo "═══════════════════════════════════════════════════════════════"
echo ""

exec lt --port 3000
