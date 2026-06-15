dnf install bind bind-utils -y
systemctl start named
systemctl enable named
echo 'DNS服务已安装并启动'

cp /etc/named.conf /etc/named.conf.bak
echo "options {
	listen-on port 53 { any; };  
	listen-on-v6 port 53 { any; };  
	directory 	'/var/named';
	dump-file 	'/var/named/data/cache_dump.db';
	statistics-file '/var/named/data/named_stats.txt';
	memstatistics-file '/var/named/data/named_mem_stats.txt';
	secroots-file	'/var/named/data/named.secroots';
	recursing-file	'/var/named/data/named.recursing';
	allow-query     { any; };  
	recursion yes;
	
	forwarders{192.168.20.1;}; 
	forward only;
	
	dnssec-enable yes;
	dnssec-validation yes;
	managed-keys-directory '/var/named/dynamic';
	pid-file '/run/named/named.pid';
	session-keyfile '/run/named/session.key';
	include '/etc/crypto-policies/back-ends/bind.config';
};" > /etc/named.conf
echo '已配置named.conf文件'

firewall-cmd --add-service=dns --permanent
firewall-cmd --reload
echo '已配置防火墙规则，允许DNS服务通过'

setenforce 0
echo '已设置SELinux为宽松模式'

systemctl restart named
echo '已重启DNS服务'

echo "本脚本仅适用与案例1中的dnsexample.com域名和192.168.20.1 IP地址，请根据实际情况修改named.conf文件中的forwarders部分和zone文件中的IP地址。"