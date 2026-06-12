# Apache 虚拟目录配置
---
### 准备工作
- 参考案例[Apache1](Apache-Example1-Http-Server-Build)，[Apache2](Apache-Example2-User-Web)的前3步
- 添加virdir.conf并配置
- 完善目录和文件
### 项目实施
- 添加virdir.conf并配置
```bash title:bash
vim /etc/httpd/conf.d/virdir.conf
```
添加以下内容
```bash title:virdir.conf
Alias /test "/virdir"
<Directory '/virdir'>
	AllowOverride None
	Require all granted
</Directory>

#可按照上述添加多个虚拟目录
```
- 完善目录和文件
```bash title:bash
mkdir /virdir -p
echo 'virtual directory test' > /virdir/index.html
```
测试
```bash title:bash
curl 127.0.0.1/test
#返回"virtual directory test"则成功
```
### 附件
[virdir.conf配置脚本](/public/FILE/apache3.sh)