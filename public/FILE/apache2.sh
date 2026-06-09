dnf install -y httpd
systemctl start httpd
systemctl enable httpd

setenforce 0
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload

useradd apauser

mkdir /home/apauser/public_html
echo "apache user web" > /home/apauser/public_html/newind.html

chmod 711 /home/apauser1
chmod 755 /home/apauser/public_html
chmod 644 /home/apauser/public_html/*

echo "<IfModule mod_userdir.c>

    UserDir public_html
</IfModule>


<Directory "/home/*/public_html">
    AllowOverride FileInfo AuthConfig Limit Indexes
    Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
    Require method GET POST OPTIONS
</Directory>" > /etc/httpd/conf.d/userdir.conf

systemctl restart httpd
curl 127.0.0.1/~apauser/