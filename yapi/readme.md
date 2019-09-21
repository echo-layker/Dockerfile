### 官方部署

url : https://hellosean1025.github.io/yapi/devops/index.html

```bash
mkdir yapi
cd yapi
git clone https://github.com/YMFE/yapi.git vendors //或者下载 zip 包解压到 vendors 目录（clone 整个仓库大概 140+ M，可以通过 `git clone --depth=1 https://github.com/YMFE/yapi.git vendors` 命令减少，大概 10+ M）
cp vendors/config_example.json ./config.json //复制完成后请修改相关配置
cd vendors
npm install --production --registry https://registry.npm.taobao.org
npm run install-server //安装程序会初始化数据库索引和管理员账号，管理员账号名可在 config.json 配置
node server/app.js //启动服务器后，请访问 127.0.0.1:{config.json配置的端口}，初次运行会有个编译的过程，请耐心等候
```



### 私有镜像部署
  
  >已做初始化工作
  
```bash
docker build -t layker/yapi/yapi:1.8.0 -f yapi/Dockerfile  yapi
docker push  layker/yapi/yapi:1.8.0
```

### k8s部署或者Docker启动
