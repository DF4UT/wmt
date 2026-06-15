dnf install -y dhcp-server
systemctl start dhcpd

echo "default-lease-time 600;
max-lease-time 7200;
ddns-update-style none;
log-facility local7;
#subnet 192.168.1.0 netmask 255.255.255.0 {
#}

#subnet 192.168.1.0 netmask 255.255.255.0 {
#    range 192.168.1.10 192.168.1.20;
#    option routers 192.168.1.1; 
#    option domain-name-servers 192.168.20.1; 
#}

#subnet 192.168.1.0 netmask 255.255.255.0 {
#    range 192.168.1.50 192.168.1.100;	
#    range 192.168.1.150 192.168.1.200;	
#    option routers 192.168.1.1;
#    option domain-name-servers 114.114.114.114;
#}

#subnet 192.168.1.0 netmask 255.255.255.0 {
#    range dynamic-bootp 192.168.1.30 192.168.1.40;
#    option routers 192.168.1.1;  
#    option domain-name-servers 114.114.114.114; 
#}

subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.50 192.168.1.100;
    option domain-name-servers 1.1.1.1; 
    option domain-name 'www.dhcpexample.com';
    option routers 192.168.1.1;
    option broadcast-address 192.168.1.254;
}

host pc1 {
  hardware ethernet 00:0C:29:3D:EC:DA;
  fixed-address 192.168.1.35; 
}" > /etc/dhcp/dhcpd.conf
echo '已配置dhcpd.conf文件'

firewall-cmd --add-service=dhcp --permanent
firewall-cmd --reload
echo '已配置防火墙规则，允许DHCP服务通过'

setenforce 0
echo '已设置SELinux为宽松模式'

systemctl restart dhcpd
echo '已重启DHCP服务'