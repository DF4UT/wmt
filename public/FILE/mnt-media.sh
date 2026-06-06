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

mount /dev/cdrom /media