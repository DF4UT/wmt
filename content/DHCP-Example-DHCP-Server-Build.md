# DHCP 服务器搭建
---
### 准备工作
- 安装dhcp-server
- 配置dhcpd.conf
- 防火墙配置和关闭SELinux
- 网卡配置仅主机且不使用物理机DHCP
### 项目实施
- 安装dhcp-server
```bash title:bash
dnf install dhcp-server -y
```
- 配置dhcpd.conf
先复制样板
```bash title:bash
cp /usr/share/doc/dhcp-server/dhcpd.conf.example /etc/dhcp/dhcpd.conf
```
默认样板如下
```bash title:dhcpd.conf.example
# dhcpd.conf
#
# Sample configuration file for ISC dhcpd
#

# option definitions common to all supported networks...
option domain-name "example.org";
option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 600;
max-lease-time 7200;

# Use this to enble / disable dynamic dns updates globally.
#ddns-update-style none;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
#authoritative;

# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
log-facility local7;

# No service will be given on this subnet, but declaring it helps the 
# DHCP server to understand the network topology.

subnet 10.152.187.0 netmask 255.255.255.0 {
}

# This is a very basic subnet declaration.

subnet 10.254.239.0 netmask 255.255.255.224 {
  range 10.254.239.10 10.254.239.20;
  option routers rtr-239-0-1.example.org, rtr-239-0-2.example.org;
}

# This declaration allows BOOTP clients to get dynamic addresses,
# which we don't really recommend.

subnet 10.254.239.32 netmask 255.255.255.224 {
  range dynamic-bootp 10.254.239.40 10.254.239.60;
  option broadcast-address 10.254.239.31;
  option routers rtr-239-32-1.example.org;
}

# A slightly different configuration for an internal subnet.
subnet 10.5.5.0 netmask 255.255.255.224 {
  range 10.5.5.26 10.5.5.30;
  option domain-name-servers ns1.internal.example.org;
  option domain-name "internal.example.org";
  option routers 10.5.5.1;
  option broadcast-address 10.5.5.31;
  default-lease-time 600;
  max-lease-time 7200;
}

# Hosts which require special configuration options can be listed in
# host statements.   If no address is specified, the address will be
# allocated dynamically (if possible), but the host-specific information
# will still come from the host declaration.

host passacaglia {
  hardware ethernet 0:0:c0:5d:bd:95;
  filename "vmunix.passacaglia";
  server-name "toccata.example.com";
}

# Fixed IP addresses can also be specified for hosts.   These addresses
# should not also be listed as being available for dynamic assignment.
# Hosts for which fixed IP addresses have been specified can boot using
# BOOTP or DHCP.   Hosts for which no fixed address is specified can only
# be booted with DHCP, unless there is an address range on the subnet
# to which a BOOTP client is connected which has the dynamic-bootp flag
# set.
host fantasia {
  hardware ethernet 08:00:07:26:c0:a5;
  fixed-address fantasia.example.com;
}

# You can declare a class of clients and then do address allocation
# based on that.   The example below shows a case where all clients
# in a certain class get addresses on the 10.17.224/24 subnet, and all
# other clients get addresses on the 10.0.29/24 subnet.

class "foo" {
  match if substring (option vendor-class-identifier, 0, 4) = "SUNW";
}

shared-network 224-29 {
  subnet 10.17.224.0 netmask 255.255.255.0 {
    option routers rtr-224.example.org;
  }
  subnet 10.0.29.0 netmask 255.255.255.0 {
    option routers rtr-29.example.org;
  }
  pool {
    allow members of "foo";
    range 10.17.224.10 10.17.224.250;
  }
  pool {
    deny members of "foo";
    range 10.0.29.10 10.0.29.230;
  }
}
```
汉化样板参考
```bash dhcpd.conf.example
#-----------------------------------------------
# 一、全局配置
#-----------------------------------------------
# 1.默认租约时间，单位为秒
default-lease-time 600;

# 2.最大租约时间，单位为秒
max-lease-time 7200;

# 3.是否允许动态更新dns，以及更新方式
ddns-update-style none;

# 4.日志输出路径和级别
log-facility local7;

#-----------------------------------------------
# 二、DHCP配置模板范例
#-----------------------------------------------

# 每次只使用一个范例进行配置

# 范例1.简单配置（仅声明网段，分配全网段可用IP）

#subnet <subnet ip> netmask 255.255.255.0 {
#}

# 范例2.静态IP配置（连续）

#subnet <subnet ip> netmask 255.255.255.0 {
#    range <subnet ip range start> <subnet ip range end>;  #地址范围
#    option routers <router ip>;       #网关地址
#    option domain-name-servers <DNS IP>;    #DNS地址
#}

# 范例3.静态IP配置（分段）

#subnet <subnet ip> netmask 255.255.255.0 {
#    range <subnet ip range1 start> <subnet ip range1 end>;	#地址范围1
#    range <subnet ip range2 start> <subnet ip range2 end>;	#地址范围2
#    option routers <router ip>;	#网关地址
#    option domain-name-servers <DNS IP>;	#DNS地址
#}

# 范例4.动态IP配置

#subnet <subnet ip> netmask 255.255.255.0 {
#    range dynamic-bootp <dynamic ip range start> <dynamic ip range end>; #动态地址范围
#    option routers <router ip>;                    #网关地址
#    option domain-name-servers <dns ip>;    #DNS地址
#}

# 范例5.子网IP配置

#subnet <subnet ip> netmask 255.255.255.0 {
#    range <subnet ip range start> <subnet ip range end>;               #子网地址范围
#    option domain-name-servers <dns ip>;    #DNS地址
#    option domain-name <domain name>;            #DNS域名
#    option routers <router ip>;                   #网关地址
#    option broadcast-address <broadcast ip>;         #广播地址
# }

#-----------------------------------------------
# 三、保留IP地址配置(需搭配subnet使用）
#-----------------------------------------------

host pc1 {
  hardware ethernet <hardware ip>; 		#指定物理设备的MAC地址(按实际修改）
  fixed-address <fix ip>; 		#指定分配的IP地址
}
```
- 示例 静态IP分段配置
```bash title:dhcpd.conf
#-----------------------------------------------
# 一、全局配置
#-----------------------------------------------
# 1.默认租约时间，单位为秒
default-lease-time 600;

# 2.最大租约时间，单位为秒
max-lease-time 7200;

# 3.是否允许动态更新dns，以及更新方式
ddns-update-style none;

# 4.日志输出路径和级别
log-facility local7;

#-----------------------------------------------
# 二、DHCP配置模板范例
#-----------------------------------------------

# 每次只使用一个范例进行配置

# 范例1.简单配置（仅声明网段，分配全网段可用IP）

#subnet 192.168.1.0 netmask 255.255.255.0 {
#}

# 范例2.静态IP配置（连续）

#subnet 192.168.1.0 netmask 255.255.255.0 {
#    range 192.168.1.10 192.168.1.20;  #地址范围
#    option routers 192.168.1.1;       #网关地址
#    option domain-name-servers 192.168.20.1;    #DNS地址
#}

# 范例3.静态IP配置（分段）

#subnet 192.168.1.0 netmask 255.255.255.0 {
#    range 192.168.1.50 192.168.1.100;	#地址范围1
#    range 192.168.1.150 192.168.1.200;	#地址范围2
#    option routers 192.168.1.1;	#网关地址
#    option domain-name-servers 114.114.114.114;	#DNS地址
#}

# 范例4.动态IP配置

#subnet 192.168.1.0 netmask 255.255.255.0 {
#    range dynamic-bootp 192.168.1.30 192.168.1.40; #动态地址范围
#    option routers 192.168.1.1;                    #网关地址
#    option domain-name-servers 114.114.114.114;    #DNS地址
#}

# 范例5.子网IP配置

subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.50 192.168.1.100;               #子网地址范围
    option domain-name-servers 1.1.1.1;    #DNS地址
    option domain-name "www.dhcpexample.com";            #DNS域名
    option routers 192.168.1.1;                   #网关地址
    option broadcast-address 192.168.1.254;         #广播地址
 }

#-----------------------------------------------
# 三、保留IP地址配置(需搭配subnet使用）
#-----------------------------------------------

host pc1 {
  hardware ethernet 00:0C:29:3D:EC:DA; 		#指定物理设备的MAC地址(按实际修改）
  fixed-address 192.168.1.35; 		#指定分配的IP地址
}
```
- 防火墙配置和关闭SELinux
```bash title:bah
firewall-cmd --add-service=dhcp
setenforce 0
systemctl restart dhcpd
```
- 网卡配置仅主机且不使用物理机DHCP (此选项请随机应变 不再做图片展示)
1.使用虚拟网络编辑器编辑所使用的网卡
2.使用客户机连接服务器的网卡进行检测(ifconfig)

### 附件
- [dhcp案例配置脚本](/FILE/dhcp.sh)	