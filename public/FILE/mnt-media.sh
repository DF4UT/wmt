echo "[Media]
name=Media
baseurl=file:///media/BaseOS
gpgcheck=0
enabled=1

[rhel8-AppStream]
name=rhel8-AppStream
baseurl=file:///media/AppStream
gpgcheck=0
enabled=1
" > /etc/yum.repos.d/dvd.repo
echo "Media.repo已创建并配置完成"

mount /dev/cdrom /media
echo "光驱已挂载到/media"

echo "请检查是否连接到光驱"
