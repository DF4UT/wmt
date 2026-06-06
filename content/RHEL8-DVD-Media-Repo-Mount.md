# RHEL8 DVD媒体挂载本地yum源仓库

- 1.进入RHEL8设置DVD连接RHEL8.ISO媒体:
![cnt.png](/IMG/cnt.png)
- 2.编辑仓库文件(dvd.repo):
```bash title:bash
vim /etc/yum.repos.d/dvd.repo
```
在确保当前用户是root的情况下添加以下内容(可自行配置或照搬):
```bash title:dvd.repo
[Media]
name=Media
baseurl=file:///media/BaseOS
gpgcheck=0
enabled=1

[rhel8-AppStream]
name=rhel8-AppStream
baseurl=file:///media/AppStream
gpgcheck=0
enabled=1
```
- 3.将cdrom挂载到media上:
```bash title:bash
mount /dev/cdrom /media
```

### 附件
[自动挂载脚本](/public/FILE/mnt-media.sh)
