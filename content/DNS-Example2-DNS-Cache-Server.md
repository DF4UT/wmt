# DNS 缓存服务器搭建
### 准备工作
- 安装dns相关服务
- 配置named.conf仅缓存模式
- 配置防火墙和关闭SELinux
- dig,host等命令测试
### 项目实施
- 安装服务
```bash title:bash
dnf install bind bind-chroot -y
systemctl start named
```
- 配置主配置文件仅缓存
```bash title:named.conf
# 本配置仅在options选项中进行配置
options {
	listen-on port 53 { any; };  #本地ip替换为any
	listen-on-v6 port 53 { any; };  #本地ip替换为any
	directory 	"/var/named";
	dump-file 	"/var/named/data/cache_dump.db";
	statistics-file "/var/named/data/named_stats.txt";
	memstatistics-file "/var/named/data/named_mem_stats.txt";
	secroots-file	"/var/named/data/named.secroots";
	recursing-file	"/var/named/data/named.recursing";
	allow-query     { any; };  #本地域名替换为any
	recursion yes;
	
	#添加forwarders,forward选项按照以下配置
	forwarders{192.168.20.1;};  #指向DNS主服务器
	forward only;
	
	dnssec-enable yes;
	dnssec-validation yes;
	managed-keys-directory "/var/named/dynamic";
	pid-file "/run/named/named.pid";
	session-keyfile "/run/named/session.key";
	include "/etc/crypto-policies/back-ends/bind.config";
};
```
- 防火墙放行dns和关闭SELinux
```bash title:bash
firewall-cmd --add-service=dns
firewall-cmd --reload
setenforce 0
systemctl restart named
```
- 测试
dig命令测试
```bash title:bash
# 模板 dig www.<domain name> 
# 示例
dig www.dnsexample.com
```
结果
![dns6](/IMG/dns6.png)
host命令测试
```bash title:bash
# 模板 host [option] <domain name/server ip>
# 示例
host -a dnsexample.com
```
![dns7](/IMG/dns7.png)

### 附件
- [DNS 缓存服务器搭建脚本文件 衔接示例1](/FILE/dns2.sh)	