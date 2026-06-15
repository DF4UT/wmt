dnf install bind bind-utils -y
systemctl start named
systemctl enable named
echo '已安装并启动DNS服务'

cp /etc/named.conf /etc/named.conf.bak
echo "
options {
	listen-on port 53 { any; };
	listen-on-v6 port 53 { ::1; };
	directory 	'/var/named';
	dump-file 	'/var/named/data/cache_dump.db';
	statistics-file '/var/named/data/named_stats.txt';
	memstatistics-file '/var/named/data/named_mem_stats.txt';
	secroots-file	'/var/named/data/named.secroots';
	recursing-file	'/var/named/data/named.recursing';
	allow-query     { any; };

	recursion yes;

	dnssec-enable yes;
	dnssec-validation no;
	dnssec-lookaside auto;

	managed-keys-directory '/var/named/dynamic';

	pid-file '/run/named/named.pid';
	session-keyfile '/run/named/session.key';

	include '/etc/crypto-policies/back-ends/bind.config';
};

logging {
        channel default_debug {
                file 'data/named.run';
                severity dynamic;
        };
};

zone '.' IN {
	type hint;
	file 'named.ca';
};

include '/etc/named.zones';
include '/etc/named.root.key';" > /etc/named.conf
echo '已配置named.conf文件'

echo "
zone 'dnsexample.com' IN {
        type master;
        file 'dnsexample.com.zone';
        allow-update {none;};
};

zone '20.168.192.in-addr.arpa' IN {
        type master;
        file '1.20.168.192.zone';
        allow-update {none;};
};" > /etc/named.zones
echo '已配置named.zones文件'

cp -p /var/named/named.localhost /var/named/dnsexample.com.zone
echo "$TTL 1D
@	IN SOA	@ root.dnsexample.com. (
					0	; serial
					1D	; refresh
					1H	; retry
					1W	; expire
					3H )	; minimum
@	IN	NS		dns.dnsexample.com.
@	IN	MX	10	mail.dnsexample.com.
dns	IN	A		192.168.20.1
mail	IN	A		192.168.20.2
slave	IN	A		192.168.20.3
www	IN	A		192.168.20.4
ftp	IN	A		192.168.20.5
web	IN	CNAME		www.dnsexample.com." > /var/named/dnsexample.com.zone
echo '已配置正向解析区文件'

cp -p /var/named/named.loopback /var/named/1.20.168.192.zone
echo "$TTL 1D
@	IN SOA	@ root.dnsexample.com. (
					0	; serial
					1D	; refresh
					1H	; retry
					1W	; expire
					3H )	; minimum
@	IN NS		dns.dnsexample.com.
@	IN MX	10	mail.dnsexample.com.
1	IN PTR		dns.dnsexample.com.
2	IN PTR		mail.dnsexample.com.
3	IN PTR		slave.dnsexample.com.
4	IN PTR		www.dnsexample.com.
5	IN PTR		ftp.dnsexample.com." > /var/named/1.20.168.192.zone
echo '已配置反向解析区文件'

echo "TYPE='Ethernet'
BOOTPROTO='static'
DEFROUTE='yes'
IPV4_FAILURE_FATAL='no'
NAME='ens33'
DEVICE='ens33'
ONBOOT='yes'
IPADDR='192.168.20.1'
NETMASK='255.255.255.0'
GATEWAY='192.168.20.1'" > /etc/sysconfig/network-scripts/ifcfg-ens33
systemctl restart network

echo "请检查DNS服务器的IP是否已改为192.168.20.1"

firewall-cmd --permanent --add-service=dns
firewall-cmd --reload
echo '已开放DNS服务的防火墙端口'

chgrp named /etc/named.conf /etc/named.zones
chgrp named dnsexample.com.zone 1.20.168.192.zone
echo "已将named.conf文件和named.zones文件的权限设置为named用户"

setenforce 0
echo "已临时关闭SELinux，确保DNS服务正常运行"

systemctl restart named
echo 'DNS服务已重启，请在客户端使用nslookup命令测试DNS解析是否正常'