# !/usr/bin/perl -W
###########################################################################
#功能说明：通过 etl_cfg2.EXPDATASQL配置信息，生成数据文件和控制文件
#查询的表：etl_cfg2.EXPDATASQL  导出数据配置表
#维 护 人：徐长亮
#维护时间：2017-12-12
#运行周期：日
#例    程：perl ExpTableToFtp.pl Data_Date i_filename
#备    注：Data_Date(数据日期,格式YYYY-MM-DD) t_expdatasql_filename(配置表etl_cfg2.EXPDATASQL中FILE_NAME的值)
###########################################################################
# 一.配置表说明
#1.配置表
# CREATE TABLE ETL_CFG2.EXPDATASQL
# (
# FILE_NAME VARCHAR2(100),
# EXP_SQL VARCHAR2(2000),
# FTP_PATH VARCHAR2(2000),
# SCHEMA_NAME VARCHAR2(50),
# TABLE_NAME VARCHAR2(50),
# CREATE_DATE TIMESTAMP
# )
# SEGMENTED BY HASH( FILE_NAME) ALL NODES;
# ALTER TABLE ETL_CFG2.EXPDATASQL ADD CONSTRAINT PK_EXPDATASQL PRIMARY KEY (FILE_NAME);

#2.配置表数据示例
# --沃账户个人用户新增日明细
# insert into  ETL_CFG2.EXPDATASQL select 'anhui_WO_USER_ADD','SELECT PROV_NAME,CITY_NAME,PHONE_NO,REG_DATE,REG_SOURCE,REAL_LEVEL,STAT_DATE,EXEC_DATE FROM BDW_DX.DX_WO_USER_ADD_D where PROV_NAME=''安徽'' and STAT_DATE=''DATA_DT'''  ,'/wzhdataftp/anhui','BDW_DX','DX_WO_USER_ADD_D',sysdate from dual;
# insert into  ETL_CFG2.EXPDATASQL select 'beijing_WO_USER_ADD','SELECT PROV_NAME,CITY_NAME,PHONE_NO,REG_DATE,REG_SOURCE,REAL_LEVEL,STAT_DATE,EXEC_DATE FROM BDW_DX.DX_WO_USER_ADD_D where PROV_NAME=''北京'' and STAT_DATE=''DATA_DT'''  ,'/app/sftp/wzhdataftp/beijing','BDW_DX','DX_WO_USER_ADD_D',sysdate from dual;

# 二.变量定义
# 1.配置表变量
#   t_expdatasql_filename 配置表中file-name作为数据文件前缀和查找索引使用.
# 2.常量:
# my $c_sysname          ='DWA';                      ##系统名
# my $c_logfilename      ='/app/etlscript/log/dwa/';  ##日志文件全路径名,缺少日志文件名
# my $c_username         =$ENV{'USER'};               ##获取系统用户名
# my $c_text             ='';                         ##注释文本
# my $c_maxrownum = 10000000;                         ##定义一个.DAT文件行数的限制
# my $c_DATA_DT='DATA_DT';
# my $c_delimiter = "|";                              ##生成.DAT文件的分隔符
#3.传入参数变量
# my $i_date;                                         ##数据日期
# my $i_filename;                                     ##生成文件名
#4.自定义数值变量
# my $v_n_delrows=0;                                    ##程序删除记录行数，默认为0
# my $v_n_insrows=0;                                    ##程序插入记录行数，默认为0
# my $v_is_fileexists = 0;                              ##.DAT文件是否已经存在(0表示不存在，大于0表示存在)
# my $v_is_ctlfileexists = 0;                           ##.CTL文件是否已经存在(0表示不存在，大于0表示存在)
# my $v_n_dattotrownum = 0 ;                            ##expsql语句导出的数据的总行数
# 5.自定义字符变量
# my $v_c_datafile ;                                    ##数据文件路径以及名称
# my $v_c_ctlfile ;                                     ##控制文件路径以及名称
# 6.程序内部变量
# avc_

# 三.函数
# (一)put_datafile($avc_filecontent,$avc_rownum)
###########################################################################

use File::Basename;
use File::Path;
use DBI;
use warnings;
use strict;
use Time::Local;
use File::stat;
use Digest::MD5;
use lib '/app/etlscript/bdw_cfg';
use MyDBI;
use Net::FTP;

##传入参数变量
my $i_date;                                         ##数据日期
my $i_filename;                                     ##生成文件名

##系统常量
my $c_sysname          ='DWA';                      ##系统名
my $c_logfilename      ='/app/etlscript/log/dwa/';  ##日志文件全路径名,缺少日志文件名
my $c_username         =$ENV{'USER'};               ##获取系统用户名
my $c_text             ='';                         ##注释文本
my $c_maxrownum = 10000000;                         ##定义一个.DAT文件行数的限制
my $c_DATA_DT='DATA_DT';                            ##配置表中日期变量
my $c_delimiter = "|";                              ##生成.DAT文件的分隔符

#4.自定义数值变量
my $v_n_delrows=0;                                  ##程序删除记录行数，默认为0
my $v_n_insrows=0;                                  ##程序插入记录行数，默认为0
my $v_is_fileexists = 0;                            ##.DAT文件是否已经存在(0表示不存在，大于0表示存在)
my $v_is_ctlfileexists = 0;                         ##.CTL文件是否已经存在(0表示不存在，大于0表示存在)
my $v_n_dattotrownum = 0;                          ##expsql语句导出的数据的总行数
my $v_n_debug = 0; 
# 5.自定义字符变量
my $v_c_datafile;                                    ##数据文件路径以及名称
my $v_c_ctlfile;                                     ##控制文件路径以及名称
my $v_c_filedate;
#############################################################################
#disconnectDb
sub disconnectDb {
  my ($dbh) = @_;
  $dbh->disconnect  if $dbh;
}
#############################################################################
# ftp, scp, sftp 模块

##ftp登陆
sub ftppush{
  my ($avc_ftp_srcfilepath,$avc_remote_ftppath)= @_;
  chomp($avc_remote_ftppath);
  my $ftp = Net::FTP->new("$c_ftp_ip;", Debug => 0) or die "Cannot connect to$c_ftp_ip: $@";
  $ftp->login("$c_ftp_user","$c_ftp_passwd") or die "Cannot login ", $ftp->message;
  $ftp->cwd("$avc_remote_ftppath") or die "Cannot change working directory ", $ftp->message;
  print $avc_ftp_srcfilepath,qq(\n),$avc_remote_ftppath,qq(\n);
  $ftp->put("$avc_ftp_srcfilepath") or die "put failed ", $ftp->message;
  $ftp->quit;
}

###scp登陆
sub scppush{
  my ($avc_ftp_srcfilepath,$avc_remote_ftppath)= @_;
  chomp($avc_remote_ftppath);
  my $avc_sftp_ip=$c_ftp_ip;
  my $avc_sftp_user=$c_ftp_user;
  my $avc_sftp_passwd=$c_ftp_passwd;
  my $avc_sftp_src_file=$avc_ftp_srcfilepath;
  my $avc_sftp_dest_file=$avc_remote_ftppath;
  my $avc_sftp_cmd="expect /app/etlscript/BDW_SHELL/scp.sh $avc_sftp_ip $avc_sftp_user $avc_sftp_passwd $avc_sftp_src_file $avc_sftp_dest_file";
  print $avc_sftp_cmd,"\n";
  system($avc_sftp_cmd);

}

###sftp登陆
sub sftppush{
  my ($avc_ftp_srcfilepath,$avc_remote_ftppath)= @_;
  chomp($avc_remote_ftppath);
  my $avc_sftp_ip=$c_ftp_ip;
  my $avc_sftp_user=$c_ftp_user;
  my $avc_sftp_passwd=$c_ftp_passwd;
  my $avc_sftp_src_file=$avc_ftp_srcfilepath;
  my $avc_sftp_dest_file=$avc_remote_ftppath;
  my $avc_sftp_cmd="expect /app/etlscript/BDW_SHELL/sftp.sh $avc_sftp_ip $avc_sftp_user $avc_sftp_passwd $avc_sftp_src_file $avc_sftp_dest_file";
  print $avc_sftp_cmd,"\n";
  system($avc_sftp_cmd);
}

##执行FTP功能
sub FTPmain {
  my ($dbh,$avc_i_filename)= @_;
  $c_text ="[1] 获得expsql语句ftp";
  my $avc_remote_ftppath = get_expftppath($dbh,$avc_i_filename );
  # ftppush($v_c_datafile,$avc_columnsql);
  # scppush($v_c_datafile,$avc_columnsql);
  sftppush($v_c_datafile,$avc_remote_ftppath);
}
#############################################################################
#配置表信息查询模块

##获得expsql语句导出数据的总行数
sub get_totalrowsnum {
  my ($dbh,$avc_sql) = @_;
  my $avc_rows = 0 ;

  if ($v_n_debug == 1) {
    print "---------------------------------------------------------\n";
    print $avc_sql;print "\n";
    print "---------------------------------------------------------\n";
  }

  $avc_sql=~s/$c_DATA_DT/$i_date/g;

  ##由于 etl_cfg2.EXPDATASQL 中配置的 exp_sql 语句末尾都带有分号(;)且分号后面有空格，会影响语句执行
  ##下面步骤去除末尾分号和空格(由于sql语句格式，行数比较多，用字符函数比较好)
  ##获得expsql的长度
  my $avc_expsqllen = length($avc_sql) ;
  ##获得expsql中末尾分号的位置
  my $avc_expsqlsemlen = rindex($avc_sql , ";" ) ;
  ##判断expsql末尾是否有分号和空格，若有去除；并且误差在10个字节
  if ( ($avc_expsqllen - $avc_expsqlsemlen) < 10 ) {
     $avc_sql = substr($avc_sql ,0 , $avc_expsqlsemlen )  ;
    }

  ##拼接count(1)语句
  my $avc_mysql = qq{ select count(1) from ($avc_sql) tt ; };

  ##执行count(1)语句
  my ($avc_totalrowsnum)=$dbh->selectrow_array($avc_mysql);
  if(!defined($avc_totalrowsnum)){
    die "ERROR: Please check the SQL: $avc_mysql  \n";
  }

  $c_text ="[2.1] 获取EXP_SQL查询的数据结果的总行数: $avc_totalrowsnum \n执行的sql为: $avc_mysql\n";
  writelogfile();
 
  return ($avc_totalrowsnum);#返回  
}


##获取生成文件的SQL语句
sub get_EXPDATASQL
{
  my ($dbh,$avc_i_filename)=@_;
  my $avc_rows;
  my $avc_columnsql ;
  
  my $avc_quesql = qq{ select exp_sql from etl_cfg2.EXPDATASQL where upper(file_name) = '$avc_i_filename'; };
  my ($sth) = $dbh->prepare_cached("$avc_quesql") || die $dbh->errstr ;
  $avc_rows = $sth->execute()||warn "Unable to process $avc_quesql \n";  
  
  while(my @ref = $sth->fetchrow_array()){
        chomp (@ref);
        #以制表符来分割最后导出来的数据 
        my $avc_columnref = join "\t", @ref;  
        $avc_columnsql = "$avc_columnref";
       }
       
  ##写日志
  $c_text ="[1.1] 将配置信息的EXP_SQL从etl_cfg2.EXPDATASQL表中导出,内容为: $avc_columnsql \n执行的sql为$avc_quesql\n ";
  writelogfile();     
  ##返回配置表中配置的sql语句
  return ($avc_columnsql);
};

##获取生成文件的SQL语句
sub get_expftppath
{
  my ($dbh,$avc_i_filename)=@_;
  my $avc_rows;
  my $avc_columnsql;
  my $avc_quesql = qq{ select trim(FTP_PATH) from etl_cfg2.EXPDATASQL where upper(file_name) = '$avc_i_filename'; };
  my ($sth) = $dbh->prepare_cached("$avc_quesql") || die $dbh->errstr ;
  $avc_rows = $sth->execute()||warn "Unable to process $avc_quesql \n";  
  
  while(my @ref = $sth->fetchrow_array()){
        chomp (@ref);
        #以制表符来分割最后导出来的数据 
        my $avc_columnref = join "\t", @ref ;
        $avc_columnsql = "$avc_columnref" ;
       }
       
  ##写日志
  $c_text ="[4.1] 将配置信息的查询ftp路径从 etl_cfg2.EXPDATASQL 表中导出$avc_columnsql \n 查询sql为 $avc_quesql \n";
  writelogfile();     
  ##返回配置表中配置的sql语句
  return ($avc_columnsql);
};

##获取生成表的列名
sub get_meta_info
{
  my ($dbh,$avc_i_filename)=@_;
  my $avc_rows;
  my $avc_columnmeta="";
  
  
  my $avc_quesql = qq{select b.column_name from etl_cfg2.EXPDATASQL a join columns b on a.table_name=b.table_name  where upper(file_name) = '$avc_i_filename'; };
  my ($sth) = $dbh->prepare_cached("$avc_quesql") || die $dbh->errstr ;
  $avc_rows = $sth->execute()||warn "Unable to process $avc_quesql \n";  
  
  while(my @ref = $sth->fetchrow_array()){
        chomp (@ref);
        #以制表符来分割最后导出来的数据 
        my $avc_columnref = join "", @ref ;
        # my $avc_columnref=$ref[0];
        if(length($avc_columnmeta) ==0 ){
          $avc_columnmeta =$avc_columnref;
        }
        else{
          $avc_columnmeta =$avc_columnmeta.$c_delimiter.$avc_columnref;
        }
       }
  
  ##写日志
  $avc_columnmeta=$avc_columnmeta."\n";

  $c_text ="[3.1] 将配置信息etl_cfg2.EXPDATASQL 表中导出元数据 $avc_columnmeta \n执行的sql为$avc_quesql\n";
  writelogfile();
  ##返回配置表中配置的sql语句
  return ($avc_columnmeta);
};

#############################################################################
## 表数据查询模块

#执行SQL,正常执行返回影响行数,异常报错时程序退出
sub execSql {
  my ($dbh,$avc_sql) = @_;
  my $avc_rows = 0 ;

  if ($v_n_debug == 1) {
    print "---------------------------------------------------------\n";
    print $avc_sql;print "\n";
    print "---------------------------------------------------------\n";
  }
   $avc_sql=~s/$c_DATA_DT/$i_date/g;
  $c_text ="[5.2] 提取表的数据的sql为: $avc_sql\n";
  writelogfile();
  my $sth = $dbh->prepare(" $avc_sql ") || die $dbh->errstr;
  $sth->execute()||warn "Unable to process $avc_sql\n";
  ##循环获得每行数据
  while(my @ref = $sth->fetchrow_array()){
        ##获得一行数据有多少列
        my $avc_countnum = scalar(@ref);
        ##一行数据信息
        my $avc_datatext;
        ##循环对一行数据每一列加分隔符
        for (my $i=0;$i< $avc_countnum ;$i++){
          my $avc_refcontent;
          if (defined ($ref[$i]) ){
             $avc_refcontent = $ref[$i] ; 
          }else {
             $avc_refcontent = "" ;
          }
          ##若为第一列直接取，其他列加分隔符
          if ( $i==0 ){
             $avc_datatext = "$avc_refcontent" ;
          }else {
             $avc_datatext = "$avc_datatext"."$c_delimiter"."$avc_refcontent" ;
          }
        }
        ##累计数据行
        $avc_rows++ ;
        ##每行数据加转换符
        ($avc_datatext) = "$avc_datatext"."\n" ;
         $c_text ="[5.3] 拼接第$avc_rows行的数据: $avc_datatext\n";
         writelogfile();
        ##调用生成数据文件函数
        put_datafile("$avc_datatext","$avc_rows");
       }
       
  my ($avc_err,$avc_state,$avc_errmsg) = ($dbh->err,$dbh->state,$dbh->errstr);
  ## $sth->finish(); 
  #返回
  return ($avc_rows,$avc_err,$avc_state,$avc_errmsg);
}

#执行SQL,写日志
sub execSqlWf {
  my ($dbh,$avc_sql) = @_;
  my ($avc_rows,$avc_err,$avc_state,$avc_errmsg) = execSql($dbh,$avc_sql);##执行SQL

  ##判断执行状态，报错退出，回滚且记日志
  if (!defined($avc_errmsg) ) {
    $avc_state =0;
  } else {
    $c_text="Program Error: SQLSTATE: $avc_state ; ERROR MESSAGE: $avc_errmsg ;ERR :$avc_err" ;
    ##替换换行符为.号
    $c_text=~s/\n/./g;
    writelogfile();
    $dbh->rollback;
    die "$c_text\n";
  }
  
  #返回受影响行数
  return $avc_rows;
}

#############################################################################
# 文件操作模块
##生成.DAT文件
sub put_datafile
{
  my ($avc_filecontent,$avc_rownum) = @_ ;
  my $avc_mydatafile ;
  
  ##获取控制文件
  $v_c_ctlfile ="/DXP/DATA/EDW/ROUT/"."$i_filename"."_"."$v_c_filedate".".CTL" ;
  ##判断数据量是否超过阀值，若超过则导成多个数据文件，若没有则用一个数据文件
  my $avc_is_filesplit = int($v_n_dattotrownum / $c_maxrownum) ;
  my $avc_cycnum = int($avc_rownum / $c_maxrownum) ;
  
  ##获取余数，判断数据文件是否完成，若余数为0表示数据文件完成
  my $avc_is_datafilecpl = $avc_rownum % $c_maxrownum ;

  if($avc_is_filesplit >0 ){    
     ##获取商，来判断是导入第几个数据文件
     my $avc_cycseq; 
     
     ##若输出数据没有到阀门值则在同一文件中，若到达了阀门值则为一个数据文件结束；数据文件S01、S02
     if( $avc_is_datafilecpl != 0 ){
         $avc_cycnum = $avc_cycnum + 1 ;
       }
     
     ##若为个位数，则在前面补充0
     if ($avc_cycnum > 9 ) {
          $avc_cycseq = "$avc_cycnum" ;
         } else {
          $avc_cycseq = "0"."$avc_cycnum" ;
         }
     #配置数据文件生成路径和数据文件名称信息，如有需要请自行配置#
     $v_c_datafile ="/DXP/DATA/EDW/ROUT/"."$i_filename"."_"."$v_c_filedate"."_S"."$avc_cycseq".".DAT";
     $avc_mydatafile = "$i_filename"."_"."$v_c_filedate"."_S"."$avc_cycseq".".DAT";
        
    }else{
      $v_c_datafile ="/DXP/DATA/EDW/ROUT/"."$i_filename"."_"."$v_c_filedate".".DAT";
      $avc_mydatafile = "$i_filename"."_"."$v_c_filedate".".DAT";
    }
    
   # ##判断是否新的数据文件开始，并将开始标志置0  
   # if( ( $avc_rownum - 1) % $c_maxrownum == 0 ){
   #   $v_is_fileexists = 0 ;
   # }
       
   ##将数据导入数据文件   
   if ( $v_is_fileexists == 0 ){
       my $myrc=open(MYFILE,">$v_c_datafile");
       if ($myrc == 1 ){
           print MYFILE ("$avc_filecontent");
           close(MYFILE);
                      }
           else {
       my $myrc=open(MYFILE,">$v_c_datafile");
            if($myrc != 1 ) {
                print "open $v_c_datafile file error";
            }
                print MYFILE ("$avc_filecontent");
                close(MYFILE);
            }
       ##关闭文件    
       close(MYFILE);
       $v_is_fileexists++ ;    
   }else{
       my $myrc=open(MYFILE,">>$v_c_datafile");
       if ($myrc == 1 ){
           print MYFILE ("$avc_filecontent");
           close(MYFILE);
                      }
           else {
       my $myrc=open(MYFILE,">>$v_c_datafile");
            if($myrc != 1 ) {
                print "open $v_c_datafile file error";
            }
                print MYFILE ("$avc_filecontent");
                close(MYFILE);
            }
       ##关闭文件    
       close(MYFILE);
       
   }
  $c_text ="[5.4] 写入文件$v_c_datafile每一行的数据: $avc_filecontent\n";
  writelogfile();
    ##判断数据文件是否完成，若完成则输出控制文件信息   
    if($v_is_fileexists >0 ){
            
       ##若余数为0表示数据文件完成
       if( $avc_is_datafilecpl == 0 ){           
           ##生成CTL文件(第一个参数为生成CTL文件路径，第二个参数生成CTL文件名称但‘不带.CTL’后缀，第三个参数为生成.DAT文件里数据的行数)
           put_ctlfile( "$v_c_ctlfile" ,"$v_c_datafile" , "$c_maxrownum" ,"$avc_mydatafile");
        }
       if( $v_n_dattotrownum == $avc_rownum ){           
           ##生成CTL文件(第一个参数为生成CTL文件路径，第二个参数生成CTL文件名称但‘不带.CTL’后缀，第三个参数为生成.DAT文件里数据的行数)
           put_ctlfile( "$v_c_ctlfile" ,"$v_c_datafile" , "$avc_is_datafilecpl" ,"$avc_mydatafile");
        }     
       
      }else{
        
       if( $v_n_dattotrownum == $avc_rownum ){       
           ##生成CTL文件(第一个参数为生成CTL文件路径，第二个参数生成CTL文件名称但‘不带.CTL’后缀，第三个参数为生成.DAT文件里数据的行数)
           put_ctlfile( "$v_c_ctlfile" ,"$v_c_datafile" , "$avc_rownum" ,"$avc_mydatafile");
        } 
      }  
   
   
   
   

};



## 生成.CTL控制文件
sub put_ctlfile
{
   my ($v_c_ctlfile , $v_c_datafilename ,$avc_filerows ,$avc_mydatafile) = @_;
   #.DAT文件的大小  
   my $v_c_ctlfilesize = stat("$v_c_datafilename")->size ;
   #.DAT文件的MD5值
   my $avc_ctlfilemd5  = get_datafilemd5("$v_c_datafilename") ;
   #.CTL文件的内容（文件名{TAB}大小{TAB}记录数{TAB}MD5值）
   my $avc_c_ctlfilecontent = "$avc_mydatafile"."|"."$v_c_ctlfilesize"."|"."$avc_filerows"."|"."$avc_ctlfilemd5 \n" ;
     
   if ($v_is_ctlfileexists == 0){
       ##打开文件(若该控制文件已存在则覆盖该文件)
       my $myrc=open(MYFILE,">$v_c_ctlfile");
       if ($myrc == 1 ){
           print MYFILE ("$avc_c_ctlfilecontent");
           close(MYFILE);
                  }
       else {
        my $myrc=open(MYFILE,">$v_c_ctlfile");
        if($myrc != 1 ) {
            print "open $v_c_ctlfile file error";
            close(MYFILE);
        }
            print MYFILE ("$avc_c_ctlfilecontent");
            close(MYFILE);
        }
        
       $v_is_ctlfileexists = $v_is_ctlfileexists + 1 ;    

    }else{
       ##打开文件(若该控制文件已存在则覆盖该文件)
       my $myrc=open(MYFILE,">>$v_c_ctlfile");
       if ($myrc == 1 ){
           print MYFILE ("$avc_c_ctlfilecontent");
           close(MYFILE);
                  }
       else {
        my $myrc=open(MYFILE,">>$v_c_ctlfile");
        if($myrc != 1 ) {
            print "open $v_c_ctlfile file error";
            close(MYFILE);
        }
            print MYFILE ("$avc_c_ctlfilecontent");
            close(MYFILE);
        }     
    
    }
  $c_text ="[5.4] 写入控制文件$v_c_ctlfile,$v_c_ctlfile , $v_c_datafilename ,$avc_filerows ,$avc_mydatafile\n";
  writelogfile();
   
};

##生成.DAT文件的MD5代码
sub get_datafilemd5
{
   my ($avc_i_filename ) = @_;
   $avc_i_filename = shift || "$avc_i_filename";
   #打开该文件
   open(FH, $avc_i_filename ) or die "Can't open get_datafilemd5 '$avc_i_filename': $!";
   binmode(FH);
   #获取文件MD5值
   my $avc_myfilemd5 = Digest::MD5->new->addfile(*FH)->hexdigest ;
   close(FH);
   ##返回文件MD5值
   return ($avc_myfilemd5);
};

#写日志文件
sub writelogfile {
  my ($v_sec,$v_min,$v_hour,$v_mday,$v_mon,$v_year) = localtime(time);
  my $avc_exetms=sprintf "%4d-%02d-%02d %02d:%02d:%02d",$v_year+1900,$v_mon+1,$v_mday,$v_hour,$v_min,$v_sec;
  open (OUTFILE,">> $c_logfilename");
  print OUTFILE  "$avc_exetms $c_username $c_text\n";
  close(OUTFILE);
  return 0;
};


#############################################################################
# main函数

sub SQLmain {
  my ($dbh,$avc_filename)= @_;
  $c_text ="[3] 获取expsql的table_name,返回表的元数据 ";
  my $avc_columnmeta = get_meta_info($dbh,$avc_filename);
  $c_text ="[4] 写入table的元数据 ";
  put_datafile($avc_columnmeta,2);
  $c_text ="[1] 获得expsql语句 ";
  my $avc_columnsql = get_EXPDATASQL($dbh,$avc_filename );
  $c_text ="[2] 获取expsql的数据总行数 ";
  $v_n_dattotrownum = get_totalrowsnum($dbh,$avc_columnsql);

  #有数据写数据，无数据只保留元数据信息的空文件
  if($v_n_dattotrownum > 0 ){
       $c_text ="[5.1] 导出数据并返回生成数据行数 ";
       $v_n_insrows=execSqlWf($dbh,$avc_columnsql);
    }
 
}

### main
###脚本执行主函数
sub main {
  #判断入参个数为2个，i_date 执行时间
  unless (@ARGV == 2) {
   die "$0 Please check the parameters: the first parameter is Data Date, the second parameter is FileName! \n";
  }
  
  my $avc_dbname        = "dws";         ##数据库名

  $i_date             = $ARGV[0];      ##执行日期
  # 文件名大写开关
  $i_filename         = uc($ARGV[1]);  ##生成文件名
  
  #数据文件日期格式转换#
  $v_c_filedate= $i_date ;
  # 决定日期的格式
  # $v_c_filedate=~s/\-//g;
  
  #配置数据文件生成路径和数据文件名称信息，如有需要请自行配置#
  # $v_c_datafile ="/DXP/DATA/EDW/ROUT/"."$i_filename"."_"."$v_c_filedate".".DAT";
  ##设置日志文件全路径名
  $c_logfilename = "$c_logfilename"."$i_filename".".log" ;

  #建立数据源连接,没有建立成功,脚本出错退出
  my $dbh = MyDBI::connectDb($avc_dbname);

  $c_text ="##############################$i_date start################\n";
  writelogfile();
  ##执行主体SQL语句（第一个参数数据库句柄，第二个参数)

  SQLmain($dbh,$i_filename);

  ##执行FTP功能
  FTPmain($dbh,$i_filename);
  ##断开数据源连接
  disconnectDb($dbh);
  
  ##生成CTL文件(第一个参数为生成CTL文件路径，第二个参数生成CTL文件名称但‘不带.CTL’后缀，第三个参数为生成.DAT文件里数据的行数)
  ##put_ctlfile( "/DXP/DATA/EDW/ROUT/" ,"$i_filename"."_"."$v_c_filedate" , $v_n_insrows ) ;
  
  
  ##执行成功退出记录日志
  $c_text="PROG END,删除记录条数： $v_n_delrows 插入记录条数： $v_n_insrows";
  ##写日志
  writelogfile();
  $c_text ="##############################$i_date end################\n";
  writelogfile();
  return 0;
}

# run main
exit(main());






