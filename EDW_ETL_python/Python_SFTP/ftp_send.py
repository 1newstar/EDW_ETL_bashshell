# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf-8')
from ftplib import FTP 
import paramiko
import os
import platform

if platform.system() == 'Windows':
    split_char = '\\'
else:
    split_char = '/'
 
def ftp_up(ip,port,loggin_id,loggin_pwd,cwd,file_list): 
    for filename in file_list:
        print '-----------'
        print filename
        ftp=FTP() 
        ftp.set_debuglevel(0)#打开调试级别2，显示详细信息;0为关闭调试信息 
        ftp.connect(ip,port)#连接 
        print u'连接服务器成功'
        ftp.login(loggin_id,loggin_pwd)#登录，如果匿名登录则用空串代替即可 
        print u'登录成功'
        print ftp.getwelcome()#显示ftp服务器欢迎信息 
        ftp.cwd(cwd) #选择操作目录 
        bufsize = 1024#设置缓冲块大小 
        file_handler = open(filename,'rb')#以读模式在本地打开文件 
        ftp.storbinary('STOR %s' % os.path.basename(filename),file_handler,bufsize)#上传文件 
        ftp.set_debuglevel(0) 
        file_handler.close() 
        ftp.quit() 
        print "ftp up OK"
    return True

def sftp_upload(host,port,username,password,cwd,file_list):
    sf = paramiko.Transport(sock=(host,port))
    print u'连接服务器成功'
    sf.connect(username = username,password = password)
    print u'登录成功'
    sftp = paramiko.SFTPClient.from_transport(sf)
    for file in file_list:
        print file
        remotefile = cwd + split_char + file.split('/')[-1]
        print remotefile
        sftp.put(file,remotefile)#上传文件
    sf.close()

if __name__ == '__main__' : 
    ftp_up(filename = "HongBao_2_2017-06-27.xls")
    ftp_up(filename = "xiaofei_2017-08-22.csv")