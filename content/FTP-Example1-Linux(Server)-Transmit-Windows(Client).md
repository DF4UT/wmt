# RHEL8 FTP 匿名传输服务器搭建
## 服务端(Linux)
### 准备工作:
- 配置本地仓库，[dvd.repo](RHEL8-DVD-Media-Repo-Mount)，下载vsftpd并启动服务
- 创建目标目录(/var/ftp/pub)和测试文件(test)
- 目录权限配置
- 配置主配置文件:
### 2.项目实施
- 安装服务并启动
```bash title:bash
dnf install vsftpd -y
systemctl start vsftpd
```
- 创建目录和测试文件
```bash title:bash
mkdir -p /var/ftp/pub
touch /var/ftp/pub/test
```
- 将目标目录(/var/ftp/pub)属主改为匿名用户ftp并为其他用户赋予写权限
```bash title:bash
chown ftp:nobody /var/ftp/pub
chmod o+w /var/ftp/pub
```
- 配置主配置文件
```bash title:bash
grep -v '#' /etc/vsftpd/vsftpd.conf > /etc/vsftpd/vsftpd.conf.bak #先输出到备份文件
cat /etc/vsftpd/vsftpd.conf.bak > /etc/vsftpd/vsftpd.conf
vim /etc/vsftpd/vsftpd.conf
```
使用vim进入vsftpd后添加或修改以下选项:
```bash title:vsftpd.conf
anonymous_enable=YES
anon_root=/var/ftp
anon_upload_enable=YES
anon_mkdir_write_enable=YES
```
关闭selinux开放服务端口
```bash
setenforce 0
firewall-cmd --permanent --add-service=ftp
systemctl restart vsftpd
```
### 客户端(windows)
- 打开资源管理器(win+e)
- 在搜索框中输入ftp://\<linux ip\>
  ![ftp1](/IMG/ftp1.png)
linux ip 可通过ifconfig命令获取

### 注意
- FTP根目录(/var/ftp)权限必须为755
  ```bash title:bash
  chmod 755 /var/ftp
  ```
- FTP目标目录(/var/ftp/pub)权限可自定义

### 附件
[自动配置脚本](/public/FILE/ftp1.sh)
