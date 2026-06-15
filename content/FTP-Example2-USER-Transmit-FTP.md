# RHEL8用户传输FTP服务器搭建
---
## 服务端
---
### 准备工作：
- 安装vsftpd并配置
- 新建FTP用户并配置用户配置文件
- 设置防火墙和关闭SELinux并启动服务
- 生成测试目录和文件
### 项目实施：
- 安装与配置
安装：
```bash title:bash
dnf install vsftpd -y
```
配置：
```bash title:bash
grep -v '#' /etc/vsftpd/vsftpd.conf > /etc/vsftpd/vsftpd.conf.bak
cat /etc/vsftpd/vsftpd.conf.bak > /etc/vsftpd/vsftpd.conf
```
主配置文件(/etc/vsftpd/vsftpd.conf)：
```bash title:bash
	vim /etc/vsftpd/vsftpd.conf
```
按照以下内容添加以及修改(可自定义，本文仅作示例)：
```bash title:vsftpd.conf
annoymous_enable=NO
local_enable=YES
local_root=/ftp/www
chroot_local_user=NO
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list
allow_writeable_chroot=YES
```
- 添加用户并配置用户配置文件
添加用户(可多用户添加，当前仅用两个用户作示例)：
```bash title:bash
useradd ftpuser #FTP用户
useradd reguser #普通对比用户
passwd ftpuser #输入密码并确认即可
passwd reguser
```
配置FTP用户配置文件(/etc/vsftpd/chroot_list)：
```bash title:chroot_list
ftpuser
#该文件用于添加可进行FTP文件传输的用户，将用户名添加至该文件即可
```
- 设置防火墙并关闭SELinux
```bash title:bash
firewall-cmd --add-service=ftp --permanent
setenforce 0
systemctl start vsftpd #若无返回内容则成功 反之主配置文件出错
```
- 生成测试文件和目录
根据主配置文件设置的根目录
```bash title:bash
mkdir -p /ftp/www
touch /ftp/www/helloFTP
```
设置目录权限
```bash title:bash
chmod o+w /ftp/www -R
```
重启服务
```bash title:bash
systemctl restart vsftpd
```

## 客户端
---
### 准备工作
- 安装FTP客户端
- 连接FTP服务器ip
### 项目实施
- 安装FTP客户端
```bash title:bash
dnf install ftp -y
```
- 使用FTP客户端连接FTP服务器
```bash title:bash
ftp <server ip>
#接下去输入服务端中添加的用户和密码即可 若失败请检查服务端的配置或者网络
```

### 附件
[服务端自动配置脚本](/public/FILE/ftp2.sh)
