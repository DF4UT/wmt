# Samba 配置用户和组共享目录
---
### 准备工作
- 安装服务并启动
- 配置防火墙关闭SELinux
- 创建共享目录
- 创建用户并分配组加入到samba用户列表
- 追加用户和组的共享目录配置至smb.conf
### 项目实施
- 安装服务并启动
```bash title:bash
dnf install samba -y
systemctl start samba
```
- 配置防火墙关闭SELinux
```bash title:bash
firewall-cmd --add-service=samba --permanent
setenforce 0
```
- 创建共享目录并设置归属和权限
```bash title:bash
mkdir -p /opt
cd /opt
mkdir tech manager
chmod 777 tech -R
chmod 777 manager -R
chown admin:tech tech
chown admin:manager manager
```
 - 创建用户并分配组加入到samba用户列表
 ```bash title:bash
 #添加示例用户
 useradd tech1
 useradd tech2
 useradd admin
 useradd manager
 #添加示例组
 groupadd tech
 groupadd manager
 #以下密码自行设置
 passwd tech1
 passwd tech2
 passwd admin
 passwd manager
 #分组
 gpasswd -a tech1 tech
 gpasswd -a tech2 tech
 gpasswd -a admin manager
 gpasswd -a admin tech
 gpasswd -a manager manager
 #将上述用户加入到samba用户列表 需要自行设置密码
 smbpasswd tech1
 smbpasswd tech2
 smbpasswd admin
 smbpasswd manager
 ```
 - 追加用户和组目录配置
 ```bash title:bash
 vim /etc/samba/smb.conf
 ```
 追加以下内容
 ```bash title:smb.conf
 [manager]
	comment = manager
	hosts allow = *
	path = /opt/manager
	read only = No
	valid users = @manager


[tech]
	comment = tech
	guest ok = Yes
	hosts allow = *
	path = /opt/tech
	read only = No
	valid users = @tech,admin
 ```
 重启服务
 ```bash title:bash
 systemctl restart smb
 ```
 - 创建验证文件并打开Windows客户端UNC连接到对应目录测试
 在tech目录下创建公共存储目录并创建验证文件hi_windows
 ```bash title:bash
 mkdir -p /opt/tech/pub
 touch /opt/tech/pub/hi_windows
 ```
 在Windows客户机打开UNC连接到tech共享目录
 ![smb3](/IMG/smb3.png)
 结果如下
 ![smb4](/IMG/smb4.png)
 测试客户端创建目录和文件（文件操作）
  ![smb5](/IMG/smb5.png)
  结果如下
   ![smb6](/IMG/smb6.png)

### 附件
- [smb.conf追加用户和组共享目录脚本](/FILE/smb2.sh)