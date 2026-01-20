# 🌐 公网访问指南

## 快速开始

系统已经在本地运行，现在为你提供公网访问方案。

### 方法 1: 使用 LocalTunnel（推荐）

#### 一键启动公网访问

```bash
cd /home/user/cld
lt --port 3000
```

等待几秒钟，会显示类似以下信息：

```
your url is: https://random-name-12345.loca.lt
```

**复制这个 URL 到浏览器即可访问！**

### 方法 2: 使用启动脚本

```bash
cd /home/user/cld

# 方式A: 直接启动（会显示URL）
lt --port 3000

# 方式B: 使用自定义子域名（需要先注册）
lt --port 3000 --subdomain my-graph-app
```

### 方法 3: 手动启动并保存URL

```bash
# 启动隧道
cd /home/user/cld
nohup lt --port 3000 > tunnel-url.txt 2>&1 &

# 等待几秒钟
sleep 8

# 查看公网地址
grep "https://" tunnel-url.txt
```

## 🎯 完整配置（前后端分离）

如果需要前后端分别暴露：

### 终端 1 - 启动前端隧道
```bash
lt --port 3000
# 会显示: your url is: https://xxx.loca.lt
```

### 终端 2 - 启动后端隧道（可选）
```bash
lt --port 8080
# 会显示: your url is: https://yyy.loca.lt
```

**注意**: 前端已经配置了代理，只需要暴露前端即可！

## 📱 访问系统

1. 复制 localtunnel 显示的 HTTPS 地址
2. 在任何浏览器中打开该地址
3. 首次访问可能需要点击"Click to Continue"按钮
4. 即可使用完整的图谱本体管理系统！

## 🔒 安全提示

- LocalTunnel 提供的是临时公网地址
- 每次重启隧道会获得不同的随机域名
- 如需固定域名，可使用 `--subdomain` 参数
- 不要分享给不信任的人

## 🛑 停止公网访问

按 `Ctrl+C` 停止 localtunnel 进程即可关闭公网访问。

## 💡 高级选项

### 固定子域名
```bash
lt --port 3000 --subdomain my-custom-name
# URL: https://my-custom-name.loca.lt
```

### 查看所有运行的隧道
```bash
ps aux | grep "lt --port"
```

### 停止所有隧道
```bash
pkill -f "lt --port"
```

## 🌟 其他公网访问方案

### 使用 ngrok（如果可用）
```bash
ngrok http 3000
```

### 使用 Cloudflare Tunnel
```bash
cloudflared tunnel --url http://localhost:3000
```

### 使用 serveo.net
```bash
ssh -R 80:localhost:3000 serveo.net
```

## ❓ 常见问题

### Q: 显示"This site can't be reached"
A: 等待10-15秒让隧道完全建立，然后刷新页面

### Q: 显示需要验证
A: LocalTunnel 首次访问需要点击"Click to Continue"，这是正常的

### Q: 如何固定域名？
A: 使用 `--subdomain` 参数，但需要域名未被占用

### Q: 速度慢怎么办？
A: LocalTunnel 是免费服务，速度受限。可考虑：
- 使用 ngrok（更快但有限制）
- 部署到云服务器
- 使用 Cloudflare Tunnel

## 📞 技术支持

如遇到问题，检查：
1. 本地服务是否运行：`curl http://localhost:3000`
2. localtunnel 是否安装：`which lt`
3. 网络连接是否正常

---

**准备好了吗？运行命令开始使用：**

```bash
lt --port 3000
```

然后复制显示的 URL，在浏览器中打开！🚀
