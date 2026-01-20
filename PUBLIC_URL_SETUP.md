# 🌐 获取公网访问地址

## ✅ 系统状态

当前系统已经在本地成功运行：
- **前端**: http://localhost:3000 ✅
- **后端**: http://localhost:8080 ✅

## 🚀 快速获取公网URL（三选一）

### 方法1️⃣: LocalTunnel（最简单）

在新终端运行以下命令：

```bash
cd /home/user/cld
lt --port 3000
```

**等待10-15秒**，会显示类似：

```
your url is: https://sharp-monkey-12.loca.lt
```

**复制这个HTTPS地址，在浏览器中打开即可！**

---

### 方法2️⃣: Python内置服务器 + Serveo

```bash
# 运行此命令
ssh -R 80:localhost:3000 serveo.net
```

会显示：
```
Forwarding HTTP traffic from https://something.serveo.net
```

**复制显示的URL即可访问！**

---

### 方法3️⃣: 使用演示页面（单文件方案）

```bash
# 启动演示页面的公网隧道
cd /home/user/cld/demo
python3 -m http.server 8000 &
lt --port 8000
```

这会为演示页面创建公网访问。

---

## 📋 完整操作步骤（推荐方法1）

### 步骤 1: 打开新终端

```bash
cd /home/user/cld
```

### 步骤 2: 运行隧道命令

```bash
lt --port 3000
```

### 步骤 3: 等待显示URL

输出示例：
```
your url is: https://heavy-eagles-sit-42-87-123-45.loca.lt
```

### 步骤 4: 访问系统

1. 复制上述URL
2. 在浏览器中打开
3. 首次访问可能显示警告页面，点击 "Click to Continue"
4. 开始使用系统！

---

## 🎯 一键启动脚本

我已为你准备好启动脚本：

```bash
cd /home/user/cld
./public-access.sh
```

这个脚本会：
1. 检查本地服务状态
2. 启动 LocalTunnel
3. 显示公网URL

---

## 💡 使用技巧

### 固定子域名（可选）

如果想要自定义URL：

```bash
lt --port 3000 --subdomain my-graph-app
```

你会得到：`https://my-graph-app.loca.lt`

**注意**: 子域名需要未被占用

### 后台运行

```bash
nohup lt --port 3000 > /tmp/tunnel.log 2>&1 &
```

然后查看URL：

```bash
sleep 10
grep "https://" /tmp/tunnel.log
```

### 查看当前公网地址

```bash
cat /tmp/public-url.txt
```

---

## 🔧 故障排除

### 问题: "Address already in use"

```bash
# 停止现有隧道
pkill -f "lt --port"

# 重新运行
lt --port 3000
```

### 问题: 显示"This site can't be reached"

**解决方案**:
1. 等待15秒再刷新
2. 检查本地服务: `curl http://localhost:3000`
3. 重启隧道

### 问题: 需要点击"Click to Continue"

这是 LocalTunnel 的安全特性，点击按钮即可继续。

---

## 🌟 其他隧道方案

### Serveo（无需安装）

```bash
ssh -R 80:localhost:3000 serveo.net
```

### Telebit（需注册）

```bash
telebit http 3000
```

### Ngrok（需安装）

```bash
ngrok http 3000
```

---

## 📱 测试公网访问

一旦获得公网URL，测试所有功能：

1. ✅ **图谱可视化** - 查看节点和关系
2. ✅ **周边搜索** - 选择节点并搜索
3. ✅ **属性面板** - 点击节点查看详情
4. ✅ **时间轴** - 拖动时间滑块
5. ✅ **动作按钮** - 查看可用操作
6. ✅ **新增对象** - 添加实体到画布

---

## 🛑 停止公网访问

按 `Ctrl+C` 或运行：

```bash
pkill -f "lt --port"
```

---

## 📞 需要帮助？

如果遇到问题：

1. 确认本地服务运行: `curl http://localhost:3000`
2. 检查 localtunnel: `which lt`
3. 查看日志: `cat /tmp/tunnel.log`

---

## ⚡ 现在就开始！

**运行这个命令获取公网URL：**

```bash
lt --port 3000
```

**复制显示的 HTTPS 地址，在浏览器中打开！🚀**

---

*提示: 保持终端开启，隧道就会一直运行*
