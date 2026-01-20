# 🌐 获取公网访问地址 - 最简单方法

## 🚀 一行命令获取公网URL

系统已经在本地运行，现在运行以下命令获取公网访问地址：

```bash
lt --port 3000
```

### 预期输出

```
your url is: https://random-name-123.loca.lt
```

### 下一步

1. **复制**上面显示的 `https://` 开头的URL
2. **打开浏览器**，粘贴URL
3. 首次访问如果显示警告页面，点击 **"Click to Continue"**
4. **开始使用**完整的图谱本体管理系统！

---

## 📸 示例截图

```
$ lt --port 3000
your url is: https://sharp-monkey-42.loca.lt

→ 复制这个地址到浏览器即可访问！
```

---

## ⚡ 完整操作（含检查）

### 1. 确认本地服务运行

```bash
curl http://localhost:3000
```

应该返回HTML内容（如果没有，运行 `./start.sh`）

### 2. 启动公网隧道

```bash
lt --port 3000
```

### 3. 复制并访问URL

等待 10-15 秒，会显示类似：

```
your url is: https://heavy-eagles-sit.loca.lt
```

复制这个URL到浏览器！

---

## 💡 高级选项

### 自定义子域名

```bash
lt --port 3000 --subdomain my-awesome-graph
```

获得固定URL: `https://my-awesome-graph.loca.lt`

### 后台运行

```bash
nohup lt --port 3000 > tunnel.log 2>&1 &
sleep 10
grep "https://" tunnel.log
```

---

## 🔍 其他方法（备选）

### 方法 A: Serveo（无需安装）

```bash
ssh -R 80:localhost:3000 serveo.net
```

### 方法 B: 使用脚本

```bash
./public-access.sh
```

---

## 🛑 停止公网访问

按 `Ctrl+C` 或：

```bash
pkill -f "lt --port"
```

---

## ❓ 常见问题

**Q: 命令找不到？**

```bash
npm install -g localtunnel
```

**Q: 连接超时？**

等待 15秒 后刷新页面

**Q: 需要验证？**

点击 "Click to Continue" 按钮

---

## 🎯 现在就试试！

**运行命令：**

```bash
lt --port 3000
```

**然后访问显示的URL！** 🚀
