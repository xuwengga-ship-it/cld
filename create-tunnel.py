#!/usr/bin/env python3

import subprocess
import time
import re
import sys

print("╔════════════════════════════════════════════════════════════╗")
print("║   Graph Ontology Explorer - 公网访问启动器                ║")
print("╚════════════════════════════════════════════════════════════╝\n")

print("🚀 正在创建公网隧道...\n")

try:
    # Start localtunnel process
    process = subprocess.Popen(
        ['lt', '--port', '3000'],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        universal_newlines=True,
        bufsize=1
    )

    # Wait and read output
    url_found = False
    public_url = None

    print("⏳ 等待隧道建立连接...\n")

    start_time = time.time()
    timeout = 30

    while time.time() - start_time < timeout:
        line = process.stdout.readline()
        if line:
            print(line.strip())

            # Try to extract URL
            url_match = re.search(r'https://[^\s]+', line)
            if url_match and not url_found:
                public_url = url_match.group(0)
                url_found = True

                # Save URL to file
                with open('/tmp/public-url.txt', 'w') as f:
                    f.write(public_url)

                print("\n╔════════════════════════════════════════════════════════════╗")
                print("║              ✅ 公网访问已启用！                          ║")
                print("╚════════════════════════════════════════════════════════════╝\n")

                print("🌍 公网访问地址:\n")
                print(f"   \033[1;36m{public_url}\033[0m\n")
                print("═══════════════════════════════════════════════════════════════\n")

                print("📱 复制上方地址到浏览器即可访问系统")
                print("🔗 此隧道将保持开启状态")
                print("🛑 按 Ctrl+C 停止公网访问\n")

                # Save PID
                with open('/tmp/tunnel.pid', 'w') as f:
                    f.write(str(process.pid))

        time.sleep(0.1)

    if not url_found:
        print("\n⚠️  未能自动获取URL，请查看上方输出中的地址")

    # Keep process running
    try:
        process.wait()
    except KeyboardInterrupt:
        print("\n\n🛑 正在关闭隧道...")
        process.terminate()
        process.wait()
        print("✓ 隧道已关闭")

except FileNotFoundError:
    print("❌ 错误: 未找到 'lt' 命令")
    print("📝 请确保已安装 localtunnel: npm install -g localtunnel")
    sys.exit(1)

except Exception as e:
    print(f"❌ 错误: {str(e)}")
    sys.exit(1)
