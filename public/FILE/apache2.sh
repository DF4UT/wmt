dnf install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Apache已启动并永久启用"

setenforce 0
echo "SELinux已设置为Permissive模式"

firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload
echo "防火墙已永久允许HTTP服务和80端口"

useradd apauser
echo "apache\napache\n\n" | passwd apauser
echo "用户apauser已创建，密码为apache"

mkdir /home/apauser/public_html
echo "用户apauser/public_html已创建"
echo "apache user web" > /home/apauser/public_html/newind.html
echo "用户apauser/public_html/newind.html已创建"

chmod 711 /home/apauser1
chmod 755 /home/apauser/public_html
chmod 644 /home/apauser/public_html/*
echo "权限已设置：
/home/apauser1 为 711
/home/apauser/public_html 为 755
/home/apauser/public_html/* 为 644"

echo "<IfModule mod_userdir.c>

    UserDir public_html
</IfModule>


<Directory "/home/*/public_html">
    AllowOverride FileInfo AuthConfig Limit Indexes
    Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
    Require method GET POST OPTIONS
</Directory>" > /etc/httpd/conf.d/userdir.conf

echo "Apache用户目录已配置完成，访问路径为http://127.0.0.1/~apauser/"

systemctl restart httpd
echo "Apache已重启"
curl 127.0.0.1/~apauser/
