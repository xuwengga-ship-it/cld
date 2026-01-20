const localtunnel = require('localtunnel');

console.log('═══════════════════════════════════════════════════════════════');
console.log('  Graph Ontology Explorer - 公网访问启动器');
console.log('═══════════════════════════════════════════════════════════════\n');

console.log('🚀 正在创建公网隧道...\n');

(async () => {
  try {
    const tunnel = await localtunnel({
      port: 3000,
      // subdomain: 'graph-ontology-explorer' // 可以设置自定义子域名
    });

    console.log('╔════════════════════════════════════════════════════════════╗');
    console.log('║              ✅ 公网访问已启用！                          ║');
    console.log('╚════════════════════════════════════════════════════════════╝\n');

    console.log('🌍 公网访问地址:\n');
    console.log(`   ${tunnel.url}\n`);
    console.log('═══════════════════════════════════════════════════════════════\n');

    console.log('📱 复制上方地址到浏览器即可访问系统');
    console.log('🔗 此隧道将保持开启状态');
    console.log('🛑 按 Ctrl+C 停止公网访问\n');

    // Save URL to file
    require('fs').writeFileSync('/tmp/public-url.txt', tunnel.url);
    console.log('💾 公网地址已保存到: /tmp/public-url.txt\n');

    tunnel.on('close', () => {
      console.log('\n隧道已关闭');
      process.exit(0);
    });

  } catch (err) {
    console.error('❌ 创建隧道失败:', err.message);
    process.exit(1);
  }
})();
