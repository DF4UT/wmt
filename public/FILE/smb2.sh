dnf install samba -y
systemctl start smb
echo "Samba已启动"

firewall-cmd --permanent --add-service=samba
firewall-cmd --reload
echo "防火墙已永久允许Samba服务"

setenforce 0
echo "SELinux已设置为Permissive模式"

echo "[manager]
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
	valid users = @tech,admin" >> /etc/samba/smb.conf

echo "用户组共享目录已配置完成"

echo "为后续正常运行，本脚本运行后自动删除将要添加的用户和组，如果你之前已经添加过了，请忽略删除用户和组的提示"
userdel manager
userdel admin
userdel tech1
userdel tech2
groupdel manager
groupdel tech
echo "之前添加的用户和组已删除"

groupadd manager
groupadd tech
echo "用户组manager和tech已创建"

useradd manager -G manager
echo "用户manager已创建并添加到manager组"
useradd admin -G manager,tech
echo "用户admin已创建并添加到manager和tech组"
useradd tech1 -G tech
useradd tech2 -G tech
echo "用户tech1和tech2已创建并添加到tech组"

echo "manager\nmanager\n\n" | passwd manager
echo "admin\nadmin\n\n" | passwd admin
echo "tech\ntech\n\n" | passwd tech1
echo "tech\ntech\n\n" | passwd tech2
echo "samba用户密码已配置
admin % admin
manager % manager
tech1 % tech
tech2 % tech"

mkdir -p /opt/manager
mkdir -p /opt/tech
echo "用户组目录/opt/manager和/opt/tech已创建"

chmod 770 /opt/manager
chmod 770 /opt/tech
echo "用户组目录权限已设置为770"

mkdir -p /opt/manager/pub
mkdir -p /opt/tech/pub
touch /opt/manager/pub/hellosmb
touch /opt/tech/pub/hellosmb
echo "用户组共享目录/opt/manager/pub和/opt/tech/pub已创建
hellosmb文件已创建"

systemctl restart smb
echo "Samba已重启"
echo "快去windows上访问共享目录吧，路径为\\\\<IP_ADDRESS>\\manager和\\\\<IP_ADDRESS>\\tech"
