echo "Alias /test "/virdir"
<Directory '/virdir'>
	AllowOverride None
	Require all granted
</Directory>" > /etc/httpd/conf.d/virdir.conf

mkdir /virdir -p
echo "virtual directory test" > /virdir/index.html
curl 127.0.0.1/test/