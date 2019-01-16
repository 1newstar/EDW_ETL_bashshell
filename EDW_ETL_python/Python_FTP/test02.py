
from ftplib import FTP
ftp = FTP()
ftp.set_debuglevel(2)
# ftp.connect("192.168.85.146", "21") 错误,端口是数字
ftp.connect("192.168.85.146",21)
ftp.login("dbadmin", "dbadmin")  # 连接的用户名，密码
ftp.getwelcome()  # 打印出欢迎信息
ftp.cwd("/home/dbadmin")  # 进入远程目录
ftp.mkd('upload')  # 新建远程目录
ftp.cwd('upload')
ftp.pwd()  # 返回当前所在位置
bufsize = 1024  # 设置的缓冲区大小

##上传
import os
os.listdir('D:\installtools\ELK_ElasticStack\logstash-5.4.3\config')
localfilename=open('D:\installtools\ELK_ElasticStack\logstash-5.4.3\config\logstash.yml','w+')
remotefilename='logstash.yml'
ftp.storlines(remotefilename, localfilename, bufsize)  # 上传目标文件

ftp.retrbinaly("RETR filename.txt", file_handle, bufsize)  # 接收服务器上文件并写入本地文件
ftp.set_debuglevel(0)  # 关闭调试模式
ftp.quit()  # 退出ftp


# ftp.cwd(pathname)  # 设置FTP当前操作的路径
# ftp.dir()  # 显示目录下所有目录信息
# ftp.nlst()  # 获取目录下的文件
# ftp.mkd(pathname)  # 新建远程目录
# ftp.pwd()  # 返回当前所在位置
# ftp.rmd(dirname)  # 删除远程目录
# ftp.delete(filename)  # 删除远程文件
# ftp.rename(fromname, toname)  # 将fromname修改名称为toname。
# ftp.storbinaly("STOR filename.txt", file_handel, bufsize)  # 上传目标文件
# ftp.retrbinary("RETR filename.txt", file_handel, bufsize)  # 下载FTP文件


