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

mkdir -p /ftp/www

chmod 755 /ftp/www -R
firewall-cmd --permanent --add-service=ftp
firewall-cmd --reload

setenforce 0

systemctl restart vsftpd