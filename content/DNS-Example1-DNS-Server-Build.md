# DNS 主服务器搭建
### 准备工作
- 安装bind和bind-chroot
- 编辑主配置文件named.conf
- 编辑区域配置文件named.zones
- 配置正向解析文件\<domain name\>.zone
- 配置反向解析文件\<reversed ip\>.zone
- 防火墙配置和关闭SELinux以及添加正反向解析文件
### 项目实施
- 安装服务软件
```bash title:bash
dnf install bind bind-chroot -y
systemctl start named
```
- 配置主配置文件
```bash title:bash
cp /etc/named.conf /etc/named.conf.bak #拷贝防止主配置文件丢失
vim /etc/named.conf
```
定位到options选项修改为以下内容
```bash title:named.conf
#将有关本地的信息替换为any 即将127.0.0.1和localhost改为any
listen-on port 53 {any;};
allow-query {any;};
#dnssec-validation 选项改为 no
dnssec-validation no;
#添加 dnssec-lookaside 选项并设置为auto属性
dnssec-lookaside auto;
```
配置include项
```bash title:named.conf
#将区域配置选项 include "/etc/named.rfc1912.zones"; 改为
include "/etc/named.zones";
```
- 编辑区域配置文件named.zones
```bash title:bash
vim /etc/named.zones
```
按照以下内容对named.zones添加正反向解析的配置
模板
```bash title:named.zones
zone "<domain name>" IN {
        type master;
        file "<domain name>.zone";
        allow-update {none;};
};

zone "<reversed ip colum>.in-addr.arpa" IN {
        type master;
        file "<reversed ip>.zone";
        allow-update {none;};
};
```
示例
```bash title:named.zones
zone "dnsexample.com" IN {
        type master;
        file "dnsexample.com.zone";
        allow-update {none;};
};

zone "20.168.192.in-addr.arpa" IN {
        type master;
        file "1.20.168.192.zone";
        allow-update {none;};
};
```
- 正向解析文件配置
```bash title:bash
cp -p /var/named/named.localhost /var/named/<domain name>.zone
vim /var/named/<domain name>.zone
```
按照以下内容进行配置
模板
```bash title:<domain-name>.zone
$TTL 1D
@	IN SOA	@ root.<domain name>. (
					0	; serial  #版本
					1D	; refresh  #更新时间间隔
					1H	; retry  #重试时间间隔
					1W	; expire  #过期时间
					3H )	; minimum  #最小时间间隔

#按对应选项配置域名或ip
@	IN	NS		dns.<domain name>.
@	IN	MX	10	mail.<domain name>.
dns	IN	A		<dns server ip ip1>
mail	IN	A		<mail server ip ip2>
slave	IN	A		<ip3>
www	IN	A		<ip4>
ftp	IN	A		<ftp server ip ip5>
web	IN	CNAME		www.<domain name>.
```
示例
```bash title:bash
cp -p /var/named/named.localhost /var/named/dnsexample.com.zone
vim /var/named/dnsexample.com.zone
```

```bash title:dnsexample.com.zone
$TTL 1D
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
web	IN	CNAME		www.dnsexample.com.
```
- 配置反向解析文件
```bash title:bash
cp -p named.loopback <reversed ip>.zone
vi /var/named/<reversed ip>.zone
```
按照以下内容进行配置
```bash title:<reversed-ip>.zone
# 按其意配置对应正向解析文件中的各个选项
$TTL 1D
@	IN SOA	@ root.<domain name>. (
					0	; serial
					1D	; refresh
					1H	; retry
					1W	; expire
					3H )	; minimum
@	IN NS		dns.<domain name>.
@	IN MX	10	mail.<domain name>.
1	IN PTR		dns.<domain name>.
2	IN PTR		mail.<domain name>.
3	IN PTR		slave.<domain name>.
4	IN PTR		www.<domain name>.
5	IN PTR		ftp.<domain name>.
```
示例
```bash title:bash
cp -p named.loopback 1.20.168.192.zone
vi /var/named/1.20.168.192.zone
```

```bash title:1.20.168.192.zone
$TTL 1D
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
5	IN PTR		ftp.dnsexample.com.
```

- 防火墙配置和关闭SELinux以及添加正反向解析文件
```bash title:bash
firewall-cmd --permanent --add-service=dns
firewall-cmd --reload

chgrp named /etc/named.conf /etc/named.zones
chgrp named dnsexample.com.zone 1.20.168.192.zone

systemctl restart named
```

- 测试
Windows客户端
打开网络编辑器
![dns1](/IMG/dns1.png)
添加DNS服务器的IP
![dns2](/IMG/dns2.png)
打开终端使用nslookup测试
![dns3](/IMG/dns3.png)
以上均成功即可

Linux客户端
同理 打开网络设置DNS服务器的IP
![dns4](/IMG/dns4.png)
使用nslookup测试
![dns5](/IMG/dns5.png)
以上均成功即可

### 附件
- [DNS基础服务器dnsexample服务器搭建脚本](/FILE/dns1.sh)	