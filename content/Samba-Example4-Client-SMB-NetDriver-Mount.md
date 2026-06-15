## Samba 客户端挂载网络映射驱动器
---
## 服务端
---
#### 本次服务端配置以前三个案例为基础，本文不再对服务端进行配置
#### 案例配置参考以下文档

## Windows客户端
---
### 准备工作
- 请确保客户端与服务端正常ping通（其他文档的补充）
- 打开资源管理器定位到此电脑添加映射网络驱动器
- 选择任意一个目录进行添加
### 项目实施
- 添加映射网络驱动器
![smb11](/IMG/smb11.png)
格式为\\\\\<server ip\>\\\<directory\>
![smb12](/IMG/smb12.png)
选择任一目录添加（以share为例）
![smb13](/IMG/smb13.png)
结果如下
![smb14](/IMG/smb14.png)
## Linux客户端
---
### 准备工作
- 安装samba-client尝试连接服务器
- 添加映射目录并挂载
### 项目实施
- 安装samba-client并尝试连接服务器
```bash title:bash
dnf install samba-client -y
sambaclient //<server ip>/share #尝试连接
```
- 添加映射目录并挂载
```bash title:bash
mkdir -p /opt/share
mount -t cifs //<server ip>/directory /opt/share -o username=<username>,password=<password>
```
测试和结果如下
![smb15](/IMG/smb15.png)
测试目录是否成功挂载可查看其内部是否存在服务器samba配置下的目录的文件
```bash title:bash
ll /opt/share
```
