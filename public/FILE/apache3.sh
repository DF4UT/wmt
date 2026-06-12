echo "Alias /test "/virdir"
<Directory '/virdir'>
	AllowOverride None
	Require all granted
</Directory>" > /etc/httpd/conf.d/virdir.conf
echo "虚拟目录已配置完成
虚拟目录真实路径为/virdir，访问路径为/test/"

mkdir /virdir -p
echo "虚拟目录/virdir已创建"
echo "virtual directory test" > /virdir/index.html
echo "虚拟目录/virdir/index.html已创建"
curl 127.0.0.1/test/
