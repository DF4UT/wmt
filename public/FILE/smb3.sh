dnf install samba -y
systemctl enable smb
systemctl start smb
echo "Samba服务已安装并启动"

echo "[public]
	comment = annoymous directory
	path = /opt/public
	browseable = yes
	writable = yes
	guest ok = yes
	public = yes
	hosts allow = *" >> /etc/samba/smb.conf
echo "Samba配置已更新 追加了新目录 public 匿名目录"

mkdir /opt/public
chmod 777 /opt/public -R
chown nobody:nobody /opt/public
touch /opt/public/hellosmb
echo "Samba目录 public已创建并配置"

firewall-cmd --add-service=samba --permanent
setenforce 0
systemctl restart firewalld
echo "防火墙已配置允许 Samba 服务，SELinux 已设置为宽松模式，Samba 服务已重启"