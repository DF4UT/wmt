# Samba Share共享目录公开
---
### 准备工作
- 服务安装并启动
- 防火墙配置和关闭SELinux
- 配置smb.conf
- 添加共享目录share
### 项目实施
- 服务安装并启动
```bash title:bash
dnf install samba -y
systemctl start smb
```
- 防火墙配置并关闭SELinux
```bash title:bash
firewall-cmd --add-service=samba --permanent
setenforce 0
```
- 配置smb.conf（位于/etc/samba/smb.conf）
```bash title:bash
vim /etc/samba/smb.conf
```
追加以下内容
```bash title:smb.conf
[share]
	comment = share dir #可不写
	path = /share       #共享目录
	browseable = yes
	public = yes
	hosts allow = *     #最好这样填 不然客户找不到
```
- 创建共享目录和测试文件并设置权限和所属用户和组
```bash title:bash
mkdir /share
touch /share/hellosmb
cd /
chmod 777 share -R  #暂时设置最高权限 可自定义
chown nobody:nobody share
```
重启服务并在Windows客户机测试
重启
```bash title:bash
systemctl restart smb
```
在Windows客户机测试
打开UNC（Win+R）填入服务器ip，格式为\\\\\<server's ip\>\\\<directory\>
![smb1](/IMG/smb1.png)
结果如下
![smb2](/IMG/smb2.png)

### 附件
- [smb.conf追加share共享目录脚本](/FILE/smb1.sh)