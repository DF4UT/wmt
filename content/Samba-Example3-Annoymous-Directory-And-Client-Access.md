# Samba 匿名用户访问目录与客户端访问服务器配置
---
## 服务端
---
### 准备工作
- 服务安装并启动
- 防火墙配置和关闭SELinux
- 配置smb.conf
- 创建匿名访问目录
### 项目实施
- 安装samba并启动
```bash title:bash
dnf install samba -y
systemctl start smb
```
- 配置防火墙和关闭SELinux
```bash title:bash
firewall-cmd --add-service=samba --permanent
setenforce 0
```
- 添加匿名共享目录配置
```bash title:bash
vim /etc/samba/smb.conf
```
追加以下内容至smb.conf
```bash title:smb.conf
[public]
	comment = annoymous directory
	path = /opt/public
	browseable = yes
	writable = yes
	guest ok = yes
	public = yes
	hosts allow = *
```
- 创建匿名共享目录和测试文件
```bash title:bash
mkdir /opt/public
chmod 777 /opt/public -R
chown nobody:nobody /opt/public
touch /opt/public/hellosmb
```
- 访问测试
打开Windows UNC
![smb7](/IMG/smb7.png)
结果如下
![smb8](/IMG/smb8.png)
测试文件操作
![smb9](/IMG/smb9.png)
## 客户端
### 准备工作
- 安装samba-client
- 使用samba-client连接服务器
### 项目实施
- 安装samba-client
```bash title:bash
dnf install samba-client -y
```
- 连接服务器
```bash title:bash
#访问匿名目录 匿名目录直接回车无输入即可
samba-client //<server ip>/public
```
- 结果如下
![smb10](/IMG/smb10.png)

### 附件
- [smb.conf追加匿名共享目录脚本](/FILE/smb3.sh)	