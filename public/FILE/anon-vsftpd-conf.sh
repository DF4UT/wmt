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

mkdir -p /var/ftp
chown ftp:ftp /var/ftp
chmod 755 /var/ftp

mkdir -p /var/ftp/pub
chown ftp:ftp /var/ftp/pub
chmod 777 /var/ftp/pub -R

firewall-cmd --permanent --add-service=ftp
firewall-cmd --reload

systemctl restart vsftpd