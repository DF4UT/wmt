import CataCard from "@/components/CataCard";

const Catalogue = () => {
    return (
        <>
        <h1 className="max-w-xs text-3xl font-semibold leading-10 tracking-tight text-black dark:text-zinc-50">
            案例文档目录
          </h1>
        <CataCard title="RHEL8 DVD媒体挂载本地yum源仓库" 
            url="https://www.df4t.asia/docx/RHEL8-DVD-Media-Repo-Mount"
            description="RHEL8 DVD媒体挂载本地yum源仓库案例，为后续安装服务此步为第一步也是最重要的一步" />

        <CataCard title="DHCP 服务器搭建"
            url="https://www.df4t.asia/docx/DHCP-Example-DHCP-Server-Build"
            description="DHCP服务器搭建案例，按需配置，本文档为最新文档暂无完全内容" />
            
        <CataCard title="DNS 主服务器搭建"
            url="https://www.df4t.asia/docx/DNS-Example1-DNS-Server-Build"
            description="DNS 案例1，手动配置DNS服务器时请认真仔细查看文档中的配置项，按需配置，以及IP正反向解析配置，脚本仅为案例中的示例起作用" />
        
        <CataCard title="DNS 缓存服务器搭建"
            url="https://www.df4t.asia/docx/DNS-Example2-DNS-Cache-Server"
            description="DNS 案例2，本文档衔接DNS 案例1的内容，以DNS主服务器的配置为基础再新开一台服务器以作缓存服务器" />

        <CataCard title="Samba Share共享目录公开" 
            url="https://www.df4t.asia/docx/Samba-Example1-Share-Directory-Public"
            description="Samba 案例1，本文档含Samba服务器配置的基础内容，为后续3个文档作基础" />

        <CataCard title="Samba 配置用户和组共享目录" 
            url="https://www.df4t.asia/docx/Samba-Example2-User-Group-Directory"
            description="Samba 案例2，Samba用户和组共享目录服务器顾名思义，要创建用户和组并添加至Samba用户，才能共享目录" />

        <CataCard title="Samba 匿名用户访问目录与客户端访问服务器配置" 
            url="https://www.df4t.asia/docx/Samba-Example3-Annoymous-Directory-And-Client-Access"
            description="Samba 案例3，与Samba案例1相似，同样是配置共享目录，权限放宽，允许匿名用户访问目录" />

        <CataCard title="Samba 客户端挂载网络映射驱动器" 
            url="https://www.df4t.asia/docx/Samba-Example4-Client-SMB-NetDriver-Mount"
            description="Samba 案例4，本文着重于操作，含客户端挂载网络映射驱动器的步骤以及Samba-Client的使用" />

        <CataCard title="Apache HTTP 基础服务器搭建" 
            url="https://www.df4t.asia/docx/Apache-Example1-HTTP-Server-Build"
            description="Apache 案例1，本文为Apache HTTP服务器搭建配置基础，为后2个文档作基础" />

        <CataCard title="Apache 用户主页配置" 
            url="https://www.df4t.asia/docx/Apache-Example2-User-Web"
            description="Apache 案例2，顾名思义，需创建用户，以案例1为基础" />

        <CataCard title="Apache 虚拟目录配置" 
            url="https://www.df4t.asia/docx/Apache-Example3-Virtual-Directory-Web"
            description="Apache案例3，相当于给存在的目录另起名并映射到服务器上开放" />

        <CataCard title="RHEL8 FTP 匿名传输服务器搭建" 
            url="https://www.df4t.asia/docx/FTP-Example1-Linux(Server)-Transmit-Windows(Client)"
            description="FTP 案例1，与Samba这类文件服务器类似，将目录共享" />

        <CataCard title="RHEL8 用户传输FTP服务器搭建" 
            url="https://www.df4t.asia/docx/FTP-Example2-USER-Transmit-FTP"
            description="FTP 案例2，在案例1的基础上打开用户配置，添加用户将其目录共享" />
        </>
    )
}

export default Catalogue;