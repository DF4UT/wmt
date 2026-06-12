dnf install samba -y
systemctl start smb
echo "Samba已启动"
firewall-cmd --permanent --add-service=samba
firewall-cmd --reload
echo "防火墙已永久允许Samba服务"

setenforce 0
echo "SELinux已设置为Permissive模式"

echo "[share]
	comment = share dir 
	path = /share       
	browseable = yes
	public = yes
	hosts allow = *" >> /etc/samba/smb.conf

echo "共享目录已配置完成"

mkdir -p /share
touch /share/hellosmb
chmod 777 /share -R
chown nobody:nobody /share -R
echo "共享目录/share已创建
权限为777，所有者为nobody"

systemctl restart smb
echo "Samba已重启"