#coding:utf-8
import os, sys, ftplib
from mimetypes import guess_type, add_type
# mimetypes - Guess the MIME type of a file.
# guess_type(url, strict=True) -- guess the MIME type and encoding of a URL.
# add_type(type, ext, strict=True)--Add a mapping between a type and an extension.
ftp_site = '192.168.85.146'
ftp_dir = '/home/dbadmin'
ftp_usr = 'dbadmin'
local_dir='.'
ftp_pwd='dbadmin'

class FtpTools:
    # allow these 3 to be redefined
    def getlocaldir(self):
        return (len(sys.argv) > 1 and sys.argv[1]) or '.'

    def configTransfer(self, ftp_site=ftp_site, ftp_dir=ftp_dir, ftp_usr=ftp_usr,ftp_pwd=ftp_pwd,local_dir=local_dir):
        self.nonpassive=False
        self.ftp_site=ftp_site
        self.ftp_dir=ftp_dir
        self.ftp_usr=ftp_usr
        self.ftp_pwd=ftp_pwd
        self.local_dir=local_dir

    def connectFtp(self):
        print('connecting...')
        connection = ftplib.FTP(self.ftp_site)
        connection.login(self.ftp_usr, self.ftp_pwd)
        try:
            connection.cwd(self.ftp_dir)
        except(Exception):
            print(Exception)
        if self.nonpassive:
            connection.set_pasv(False)
        self.connection = connection


    def cleanLocals(self):
        """
        尝试删除所有的本地文件
        """
        if self.cleanall:
            # 本地文件的遍历
            for localname in os.listdir(self.localdir):
                try:
                    # 本地文件删除
                    print('deleting local', localname)
                    os.remove(os.path.join(self.localdir, localname))
                except:
                    print('cannot delete local', localname)

    def cleanRemotes(self):
        """
        尝试删除所有远程文件为移除无效文件
        """
        if self.cleanall:
            for remotename in self.connection.nlst():
                try:
                    print('deleting remote', remotename)
                    self.connection.delete(remotename)
                except:
                    # remote dir listing # remote file delete
                    print('cannot delete remote', remotename)



    def isTextKind(self, remotename, trace=True):
        add_type('text/x-python-win', '.pyw')
        mimetype, encoding = guess_type(remotename, strict=False)
        mimetype = mimetype or '?/?'
        maintype = mimetype.split('/')[0]
        if trace: print(maintype, encoding or '')
        return maintype == 'text' and encoding == None


    def downloadOne(self, remotename, localpath):
        """
        download one file by FTP in text or binary mode local name need not be same as remote name
        使用FTP下载一个文件
        remotename:远程文件
        localpath:本地文件
        """
        if self.isTextKind(remotename):
            localfile = open(localpath, 'w', encoding=self.connection.encoding)
            def callback(line): localfile.write(line + '\n')
            #RETR表示下载命令 callback表示回调
            self.connection.retrlines('RETR ' + remotename, callback)
        else:
            localfile = open(localpath, 'wb')
            self.connection.retrbinary('RETR ' + remotename, localfile.write)
            localfile.close()

    def uploadOne(self, localname, localpath, remotename):
        """
        upload one file by FTP in text or binary mode remote name need not be same as local name
        使用FTP上传一个文件
        """
        if self.isTextKind(localname):
            localfile = open(localpath, 'rb')
            #STOR表示上传
            self.connection.storlines('STOR ' + remotename, localfile)
        else:
            localfile = open(localpath, 'rb')
            self.connection.storbinary('STOR ' + remotename, localfile)
        localfile.close()

    def downloadDir(self):
        """
        从远程下载所有的文件
        download all files from remote site/dir per config
        ftp nlst() gives files list, dir() gives full details
        """
        remotefiles = self.connection.nlst() # nlst is remote listing
        for remotename in remotefiles:
            if remotename in ('.', '..'): continue
            localpath = os.path.join(self.localdir, remotename)
            #print('downloading', remotename, 'to', localpath, 'as', end=' ')
            self.downloadOne(remotename, localpath)
        print('Done:', len(remotefiles), 'files downloaded.')

    def uploadDir(self):
        """
        upload all files to remote site/dir per config
        listdir() strips dir path, any failure ends script
        上传一个目录
        """
        localfiles = os.listdir(self.localdir) # listdir is local listing
        for localname in localfiles:
            localpath = os.path.join(self.localdir, localname)
            print('uploading', localpath, 'to', localname, 'as')
            self.uploadOne(localname, localpath, localname)
        print('Done:', len(localfiles), 'files uploaded.')

    def run(self, cleanTarget=lambda:None, transferAct=lambda:None):
        """
        run a complete FTP session
        default clean and transfer are no-ops don't delete if can't connect to server
        """
        self.connectFtp()
        cleanTarget()
        transferAct()
        self.connection.quit()


if __name__ == '__main__':
    ftp = FtpTools()
    xfermode = 'download'
    if len(sys.argv) > 1:
        xfermode = sys.argv.pop(1)
        if xfermode == 'download':
            ftp.configTransfer()
            # get+del 2nd arg
            ftp.run(cleanTarget=ftp.cleanLocals, transferAct=ftp.downloadDir)
        elif xfermode == 'upload':
            redir=os.path.basename((len(sys.argv) > 1 and sys.argv[1]) or '.')
            ftp.configTransfer(site='192.168.30.252', rdir=redir, user='child')
            ftp.run(cleanTarget=ftp.cleanRemotes, transferAct=ftp.uploadDir)
    else:
        print('Usage: ftptools.py ["download" | "upload"] [localdir]')