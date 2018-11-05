#!/bin/bash
###############################################################################
#    文件名  :   
#    功  能  :   
#    编  写  :                                                               
#    时  间  :                                                              
#    修  改  :                                                                       
#    说  明  :                                                               
###############################################################################
#ftp ip:0.0.0.0
#user:admin
#passwd:??
#定义变量
EXPORT_PAHT="/DXP/"
FTP_USER="admin"
FTP_PASS="???"
FTP_SERVER="0.0.0.0"
#设定文件名前缀前部分
PRE1="TRADE_"
PRE2="BUSINESS_"
SUF=".txt"
ISGET=1
#判断是否有第一个位置参数是否为空
#说明：if  [ -n $string  ]  如果string 非空(非0），返回0(true)
#定义日期格式为：date +%Y%m%d 20161209
if [ ! -n "$1" ]
        then
                DATE=`date +%Y%m%d`
        else
                DATE=$1
fi

FILE="${PRE1}${DATE}${SUF} ${PRE1}${DATE}${SUF}.done ${PRE2}${DATE}${SUF} ${PRE2}${DATE}${SUF}.done"
echo ${FILE}
#定义ftp方法
function ftpGet()
{
        cd ${EXPORT_PAHT}
        /usr/bin/ftp -v -n ${FTP_SERVER} <<EOF>ftp.log
    user ${FTP_USER} ${FTP_PASS}
    binary
    prom
    mget $@
EOF
        grep "Transfer complete" ftp.log
        X=$?
        grep "send aborted" ftp.log
        Y=$?
        echo X:$X  Y:$Y 
        if [ $X -eq 0 -a $Y -ne 0 ]
                then
                        ISGET=0
                        echo ftp $1文件成功！
                        return 0
                else
                        ISGET=1
                        echo ftp $1文件失败！
                        return 1
        fi
}

while [ ${ISGET} -eq 1 ]
do
        echo "`date` 文件未成功等待10秒钟继续执行"> ftp.log
        sleep 10s
        ftpGet ${FILE}
done 

/DXP/DATA/TAS

