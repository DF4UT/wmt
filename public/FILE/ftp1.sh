dnf install -y vsftpd

echo "anonymous_enable=YES
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=NO
listen_ipv6=YES

pam_service_name=vsftpd
userlist_enable=YES

anon_root=/var/ftp
anon_upload_enable=YES
anon_mkdir_write_enable=YES" > /etc/vsftpd/vsftpd.conf

echo "vsftpd.conf已配置完成，匿名用户根目录为/var/ftp，匿名用户具有上传和创建目录的权限"

mkdir -p /var/ftp
chown ftp:ftp /var/ftp
chmod 755 /var/ftp
echo "目录/var/ftp已创建，权限为755，所有者为ftp"

mkdir -p /var/ftp/pub
chown ftp:ftp /var/ftp/pub
chmod 777 /var/ftp/pub -R
echo "目录/var/ftp/pub已创建，权限为777，所有者为ftp"

firewall-cmd --permanent --add-service=ftp
firewall-cmd --reload
echo "防火墙已永久允许FTP服务"

systemctl restart vsftpd
echo "vsftpd已重启"
