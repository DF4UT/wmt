dnf install vsftpd -y

userdel -rf ftpuser
echo "用户ftpuser已删除"

useradd ftpuser
echo "ftp\nftp\n\n" | passwd ftpuser
echo "用户ftpuser已创建 密码为ftp"

echo "ftpuser" > /etc/vsftpd/chroot_list
echo "用户ftpuser已添加到chroot_list中"

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
anon_mkdir_write_enable=YES

local_root=/ftp/www
chroot_local_user=NO
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list
allow_writeable_chroot=YES
" > /etc/vsftpd/vsftpd.conf

echo "vsftpd.conf已配置完成"

mkdir -p /ftp/www

chmod 755 /ftp/www -R
firewall-cmd --permanent --add-service=ftp
firewall-cmd --reload

echo "防火墙已永久允许FTP服务"

setenforce 0

echo "SELinux已设置为Permissive模式"
systemctl restart vsftpd
echo "vsftpd已重启"