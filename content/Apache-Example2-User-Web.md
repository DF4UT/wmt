# Apache 用户主页配置
---
## 准备工作：
- 本地yum源仓库配置
- 安装httpd并启动
- 配置SELinux以及防火墙
- 创建用户并完善目录
- 配置userdir.conf
## 项目实施
 yum源仓库配置请看 [dvd.repo](RHEL8-DVD-Media-Repo-Mount)
- 安装httpd并启动
```bash title:bash
dnf install httpd -y
systemctl start httpd
```
- 配置SELinux和防火墙
```bash title:bash
setenforce 0
firewall-cmd --add-service=http
#如果无法访问请打开80端口
firewall-cmd --add-port=80/tcp
```
- 创建用户目录
```bash title:bash
useradd apauser1
passwd apauser1
```
完善目录
```bash title:bash
mkdir /home/apauser1/public_html
#新建索引文件
echo "apache user1" > /home/apauser1/public_html/index.html
```
设置目录权限（推荐）
```bash title:bash
#按照userdir.conf中要求 /home/<user>通常设置为711，/home/<user>/public_html必须755，public_html下的文件可设置也可不设置
chmod 711 /home/apauser1
chmod 755 /home/apauser1/public_html
chmod 644 /home/apauser1/public_html/*
```
- 配置用户目录
```bash title:bash
vim /etc/httpd/conf.d/userdir.conf
```
根据以下修改
```bash title:userdir.conf
#19 将UserDir disabled注释或删除
# UserDir disabled
#26 将UserDir public_html的注释删除
UserDir public_html
```
重启服务
```bash title:bash
systemctl restart httpd
```
测试
```bash title:bash
curl 127.0.0.1/~apauser1/
#返回"apache user1"则成功
```

### 附件
- [Apache进阶配置](/public/FILE/apache2.sh)     