# !/usr/bin/perl -W
###########################################################################
#功能说明：通过 etl_cfg2.EXPDATASQL配置信息，生成数据文件和控制文件
#查询的表：etl_cfg2.EXPDATASQL  导出数据配置表
#维 护 人：徐长亮
#维护时间：2017-12-12
#维护说明：修改etl_cfg2.EXPDATASQL,添加ftp地址和create_date,修改成适应31省推送的数据的脚本,增加日期过滤
#运行周期：日
#例    程：perl ExpTableToFtp.pl Data_Date i_filename
#备    注：Data_Date(数据日期,格式YYYY-MM-DD) i_filename(配置表etl_cfg2.EXPDATASQL中i_filename的值)

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

# --数据
# --沃账户个人用户新增日明细
# insert into  ETL_CFG2.EXPDATASQL select 'anhui_WO_USER_ADD','SELECT PROV_NAME,CITY_NAME,PHONE_NO,REG_DATE,REG_SOURCE,REAL_LEVEL,STAT_DATE,EXEC_DATE FROM BDW_DX.DX_WO_USER_ADD_D where PROV_NAME=''安徽'' and STAT_DATE=''DATA_DT'''  ,'/wzhdataftp/anhui','BDW_DX','DX_WO_USER_ADD_D',sysdate from dual;
# insert into  ETL_CFG2.EXPDATASQL select 'beijing_WO_USER_ADD','SELECT PROV_NAME,CITY_NAME,PHONE_NO,REG_DATE,REG_SOURCE,REAL_LEVEL,STAT_DATE,EXEC_DATE FROM BDW_DX.DX_WO_USER_ADD_D where PROV_NAME=''北京'' and STAT_DATE=''DATA_DT'''  ,'/app/sftp/wzhdataftp/beijing','BDW_DX','DX_WO_USER_ADD_D',sysdate from dual;

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

##系统变量
my $s_sysname          ='DWA';                      ##系统名
my $s_logfilename      ='/app/etlscript/log/dwa/';  ##日志文件全路径名,缺少日志文件名
my $s_username         =$ENV{'USER'};               ##获取系统用户名
my $s_text             ='';                         ##注释文本
###########################################################################
##传入参数变量
# my $i_date;      ##数据日期
# my $i_filename;  ##生成文件名
# 变量说明:
# $s_logfilename  日志根目录
# $v_filedate     全局日期 (数据文件,sql时间戳)
# $v_datafile     全局落地数据文件(含路径)
# $filepath       同$v_datafile,全局落地数据文件(含路径),ftppush,scppush,sftppush函数调用
# $is_fileexists  .DAT文件是否已经存在(0表示不存在，大于0表示存在)
# $v_ctlfile      全局控制文件(含路径)
# $is_ctlfileexists .CTL文件是否已经存在(0表示不存在，大于0表示存在)
# $v_dattotrownum expsql语句导出的数据的总行数

##数据变量
# my $v_delrows=0;   ##程序删除记录行数，默认为0
# my $v_insrows=0;   ##程序插入记录行数，默认为0

# 函数说明:
# 一.main()
#   输入:@ARGV == 2 日期和配置表索引 $i_date 和 $i_filename

#   操作变量:v_filedate     全局日期 (数据文件,sql时间戳)
#        s_logfilename  全局日志文件名(含路径)
#   输出: my $dbh 获取数据库连接
#   操作函数:
#       SQLmain($dbh,$i_filename);FTPmain($dbh,$i_filename);disconnectDb($dbh);
#       writelogfile();

# 二.SQLmain()
#  输入: 形参$dbh,$i_filename.实参:$dbh,$filename
#  操作变量:
      # 中间变量$v_columnsql, 保存select语句
      # 中间变量$v_dattotrownum,保存select语句的行数
      # 中间变量$v_columnmeta,保存列元数据的信息;
#  操作函数:
      # put_datafile($v_columnmeta,10);写入文件元数据
      # execSqlWf($dbh,$v_columnsql,);
# 输出:全局变量v_insrows 插入行数

# 三.execSqlWf
#   输入:形参 $dbh,$v_sql 实参:$dbh,$v_columnsql
#   操作函数:execSql($dbh,$v_sql)
#   操作变量:$v_rows,$v_err,$v_state,$v_errmsg

# 四.execSql
# 输入:形参($dbh,$v_sql)
# 操作变量: my $v_datatext保存sql查看的数据;
#           my $v_rows++ ;判断行数
# 操作函数: 写入文件put_datafile("$v_datatext","$v_rows");
# 输出:return ($v_rows,$v_err,$v_state,$v_errmsg);

# 五.get_totalrowsnum
# 输入:$dbh,$v_columnsql
# 操作变量:$v_sql=~s/$DATA_DT/$i_date/g; 有日期过滤的sql
           # $v_mysql = qq{ select count(1) from ($v_sql) tt ; } 记录要卸载的数据行数的sql;
# 计算总行数: my ($v_totalrowsnum)=$dbh->selectrow_array($v_mysql);
# 返回总函数:v_totalrowsnum

# 六.put_datafile(my ($v_filecontent,$v_rownum) = @_)
#   输入:文本内容,文件数据行数 ($v_filecontent,$v_rownum)
#   操作:读$v_datafile 获取落地数据文件(含路径),写入文本内容.
#   判断:执行失败,断开数据库连接
#   判断:
        # $is_filesplit 数据变量,表示划分几个文件总行数.
        # 
# 返回:return $v_rows;

###########################################################################
##自定义参数变量
my $v_filedate ;                                    ##数据文件日期
my $v_debug = 0;                                    ##Debug变量,默认不开启
my $v_delrows=0;                                    ##程序删除记录行数，默认为0
my $v_insrows=0;                                    ##程序插入记录行数，默认为0
my $v_datafile ;                                    ##数据文件路径以及名称
my $v_ctlfile ;                                     ##控制文件路径以及名称
my $is_fileexists = 0;                              ##.DAT文件是否已经存在(0表示不存在，大于0表示存在)
my $is_ctlfileexists = 0;                           ##.CTL文件是否已经存在(0表示不存在，大于0表示存在)
my $v_delimiter = "|";                              ##生成.DAT文件的分隔符
my $v_dattotrownum = 0 ;                            ##expsql语句导出的数据的总行数
my $v_maxrownum = 10000000;                         ##定义一个.DAT文件行数的限制
##add by xuchangliang
my $filepath='';
my $DATA_DT='DATA_DT';
my $ftp_ip='192.168.20.21';
my $ftp_user='WZH_data';
my $ftp_passwd='m0dTMi\<q3';
##生成.DAT文件
sub put_datafile
{
	my ($v_filecontent,$v_rownum) = @_ ;
	my $v_mydatafile ;
	
	##获取控制文件
  $v_ctlfile ="/DXP/DATA/EDW/ROUT/"."$i_filename"."_"."$v_filedate".".CTL" ;
  ##判断数据量是否超过阀值，若超过则导成多个数据文件，若没有则用一个数据文件
  my $is_filesplit = int($v_dattotrownum / $v_maxrownum) ;
  my $v_cycnum = int($v_rownum / $v_maxrownum) ;
  
  ##获取余数，判断数据文件是否完成，若余数为0表示数据文件完成
  my $is_datafilecpl = $v_rownum % $v_maxrownum ;

  if($is_filesplit >0 ){  	 
  	 ##获取商，来判断是导入第几个数据文件
  	 my $v_cycseq ; 
  	 
     ##若输出数据没有到阀门值则在同一文件中，若到达了阀门值则为一个数据文件结束；数据文件S01、S02
     if( $is_datafilecpl != 0 ){
   	     $v_cycnum = $v_cycnum + 1 ;
   	   }
  	 
  	 ##若为个位数，则在前面补充0
  	 if ($v_cycnum > 9 ) {
          $v_cycseq = "$v_cycnum" ;
         } else {
          $v_cycseq = "0"."$v_cycnum" ;
         }
     #配置数据文件生成路径和数据文件名称信息，如有需要请自行配置#
     $v_datafile ="/DXP/DATA/EDW/ROUT/"."$i_filename"."_"."$v_filedate"."_S"."$v_cycseq".".DAT";
     $v_mydatafile = "$i_filename"."_"."$v_filedate"."_S"."$v_cycseq".".DAT";
       	
  	}else{
  	  $v_datafile ="/DXP/DATA/EDW/ROUT/"."$i_filename"."_"."$v_filedate".".DAT";
  	  $v_mydatafile = "$i_filename"."_"."$v_filedate".".DAT";
  	}
  	
   # ##判断是否新的数据文件开始，并将开始标志置0	
   # if( ( $v_rownum - 1) % $v_maxrownum == 0 ){
   # 	 $is_fileexists = 0 ;
   # }
     	 
   ##将数据导入数据文件	 
	 if ( $is_fileexists == 0 ){
       my $myrc=open(MYFILE,">$v_datafile");
       if ($myrc == 1 ){
       	   print MYFILE ("$v_filecontent");
       	   close(MYFILE);
       	              }
           else {
       my $myrc=open(MYFILE,">$v_datafile");
            if($myrc != 1 ) {
                print "open $v_datafile file error";
            }
                print MYFILE ("$v_filecontent");
                close(MYFILE);
            }
       ##关闭文件    
       close(MYFILE);
       $is_fileexists++ ;    
	 }else{
	     my $myrc=open(MYFILE,">>$v_datafile");
       if ($myrc == 1 ){
       	   print MYFILE ("$v_filecontent");
       	   close(MYFILE);
       	              }
           else {
       my $myrc=open(MYFILE,">>$v_datafile");
            if($myrc != 1 ) {
                print "open $v_datafile file error";
            }
                print MYFILE ("$v_filecontent");
                close(MYFILE);
            }
       ##关闭文件    
       close(MYFILE);
       return($v_datafile);
       
	 }

    ##判断数据文件是否完成，若完成则输出控制文件信息   
    if($is_filesplit >0 ){
    	    	
    	 ##若余数为0表示数据文件完成
    	 if( $is_datafilecpl == 0 ){    	 	   
    	 	   ##生成CTL文件(第一个参数为生成CTL文件路径，第二个参数生成CTL文件名称但‘不带.CTL’后缀，第三个参数为生成.DAT文件里数据的行数)
           put_ctlfile( "$v_ctlfile" ,"$v_datafile" , "$v_maxrownum" ,"$v_mydatafile");
    	 	}
    	 if( $v_dattotrownum == $v_rownum ){    	 	   
    	 	   ##生成CTL文件(第一个参数为生成CTL文件路径，第二个参数生成CTL文件名称但‘不带.CTL’后缀，第三个参数为生成.DAT文件里数据的行数)
           put_ctlfile( "$v_ctlfile" ,"$v_datafile" , "$is_datafilecpl" ,"$v_mydatafile");
    	 	}  	 	
    	 
    	}else{
    	  
    	 if( $v_dattotrownum == $v_rownum ){    	 
    	 	   ##生成CTL文件(第一个参数为生成CTL文件路径，第二个参数生成CTL文件名称但‘不带.CTL’后缀，第三个参数为生成.DAT文件里数据的行数)
           put_ctlfile( "$v_ctlfile" ,"$v_datafile" , "$v_rownum" ,"$v_mydatafile");
    	 	} 
    	}	 
	 
	 
	 
	 

};

##获取生成文件的SQL语句
sub get_EXPDATASQL
{
	my ($dbh,$v_myfilename)=@_;
	my $v_rows;
	my $v_columnsql ;
  
  $s_text ="[1.2] 将配置信息的sql语句从 etl_cfg2.EXPDATASQL 表中导出 ";
  my $v_quesql = qq{ select exp_sql from etl_cfg2.EXPDATASQL where upper(file_name) = '$v_myfilename'; };
  my ($sth) = $dbh->prepare_cached("$v_quesql") || die $dbh->errstr ;
  $v_rows = $sth->execute()||warn "Unable to process $v_quesql \n";  
  
  while(my @ref = $sth->fetchrow_array()){
        chomp (@ref);
        #以制表符来分割最后导出来的数据 
        my $v_columnref = join "\t", @ref ;  
        $v_columnsql = " $v_columnref " ;
       }
       
  ##写日志
  writelogfile();     
  ##返回配置表中配置的sql语句
  return ($v_columnsql);
};

## 生成.CTL控制文件
sub put_ctlfile
{
	 my ($v_ctlfile , $v_datafilename ,$v_filerows ,$v_mydatafile) = @_;
	 #.DAT文件的大小	 
	 my $v_ctlfilesize = stat("$v_datafilename")->size ;
	 #.DAT文件的MD5值
	 my $v_ctlfilemd5  = get_datafilemd5("$v_datafilename") ;
	 #.CTL文件的内容（文件名{TAB}大小{TAB}记录数{TAB}MD5值）
	 my $v_ctlfilecontent = "$v_mydatafile"."|"."$v_ctlfilesize"."|"."$v_filerows"."|"."$v_ctlfilemd5 \n" ;
	 	 
	 if ($is_ctlfileexists == 0){
       ##打开文件(若该控制文件已存在则覆盖该文件)
       my $myrc=open(MYFILE,">$v_ctlfile");
       if ($myrc == 1 ){
   	       print MYFILE ("$v_ctlfilecontent");
   	       close(MYFILE);
   	              }
       else {
        my $myrc=open(MYFILE,">$v_ctlfile");
        if($myrc != 1 ) {
            print "open $v_ctlfile file error";
            close(MYFILE);
        }
            print MYFILE ("$v_ctlfilecontent");
            close(MYFILE);
        }
        
       $is_ctlfileexists = $is_ctlfileexists + 1 ;  	

	 	}else{
       ##打开文件(若该控制文件已存在则覆盖该文件)
       my $myrc=open(MYFILE,">>$v_ctlfile");
       if ($myrc == 1 ){
   	       print MYFILE ("$v_ctlfilecontent");
   	       close(MYFILE);
   	              }
       else {
        my $myrc=open(MYFILE,">>$v_ctlfile");
        if($myrc != 1 ) {
            print "open $v_ctlfile file error";
            close(MYFILE);
        }
            print MYFILE ("$v_ctlfilecontent");
            close(MYFILE);
        }		 	
	 	
	 	} 
   
};

##生成.DAT文件的MD5代码
sub get_datafilemd5
{
	 my ($v_myfilename ) = @_;
	 $v_myfilename = shift || "$v_myfilename";
	 #打开该文件
	 open(FH, $v_myfilename ) or die "Can't open get_datafilemd5 '$v_myfilename': $!";
	 binmode(FH);
	 #获取文件MD5值
	 my $v_myfilemd5 = Digest::MD5->new->addfile(*FH)->hexdigest ;
	 close(FH);
	 ##返回文件MD5值
	 return ($v_myfilemd5);
};

#写日志文件
sub writelogfile {
  my ($v_sec,$v_min,$v_hour,$v_mday,$v_mon,$v_year) = localtime(time);
  my $v_exetms=sprintf "%4d-%02d-%02d %02d:%02d:%02d",$v_year+1900,$v_mon+1,$v_mday,$v_hour,$v_min,$v_sec;
	open (OUTFILE,">> $s_logfilename");
	print OUTFILE  "$v_exetms $s_username $s_text\n";
	close(OUTFILE);
  return 0;
};


#disconnectDb
sub disconnectDb {
  my ($dbh) = @_;
  $dbh->disconnect  if $dbh ;
}

##获得expsql语句导出数据的总行数
sub get_totalrowsnum {
  my ($dbh,$v_sql) = @_;
  my $v_rows = 0 ;

  if ($v_debug == 1) {
    print "---------------------------------------------------------\n";
    print $v_sql;print "\n";
    print "---------------------------------------------------------\n";
  }
   $v_sql=~s/$DATA_DT/$i_date/g;
   
  ##由于 etl_cfg2.EXPDATASQL 中配置的 exp_sql 语句末尾都带有分号(;)且分号后面有空格，会影响语句执行
  ##下面步骤去除末尾分号和空格(由于sql语句格式，行数比较多，用字符函数比较好)
  ##获得expsql的长度
  my $v_expsqllen = length($v_sql) ;
  ##获得expsql中末尾分号的位置
  my $v_expsqlsemlen = rindex($v_sql , ";" ) ;
  ##判断expsql末尾是否有分号和空格，若有去除；并且误差在10个字节
  if ( ($v_expsqllen - $v_expsqlsemlen) < 10 ) {
     $v_sql = substr($v_sql ,0 , $v_expsqlsemlen )  ;
    }   
   
  ##拼接count(1)语句
  my $v_mysql = qq{ select count(1) from ($v_sql) tt ; };
     
  ##执行count(1)语句
  my ($v_totalrowsnum)=$dbh->selectrow_array($v_mysql);
  if(!defined($v_totalrowsnum)){
    die "ERROR: Please check the SQL: $v_mysql  \n";
  }
  writelogfile();
 
  return ($v_totalrowsnum );#返回  
}


#执行SQL,正常执行返回影响行数,异常报错时程序退出
sub execSql {
  my ($dbh,$v_sql) = @_;
  my $v_rows = 0 ;

  if ($v_debug == 1) {
    print "---------------------------------------------------------\n";
    print $v_sql;print "\n";
    print "---------------------------------------------------------\n";
  }
   $v_sql=~s/$DATA_DT/$i_date/g;
  
  my $sth = $dbh->prepare(" $v_sql ") || die $dbh->errstr;
  $sth->execute()||warn "Unable to process $v_sql\n";
  ##循环获得每行数据
  while(my @ref = $sth->fetchrow_array()){
        ##获得一行数据有多少列
        my $v_countnum = scalar(@ref);
        ##一行数据信息
        my $v_datatext ;
  	    ##循环对一行数据每一列加分隔符
  	    for (my $i=0;$i< $v_countnum ;$i++){
          my $v_refcontent ;
          if (defined ($ref[$i]) ){
             $v_refcontent = $ref[$i] ; 
          }else {
             $v_refcontent = "" ;
          }
  	    	##若为第一列直接取，其他列加分隔符
          if ( $i==0 ){
             $v_datatext = "$v_refcontent" ;
          }else {
             $v_datatext = "$v_datatext"."$v_delimiter"."$v_refcontent" ;
          }   	    	
        }    	          
        ##累计数据行
        $v_rows++ ;
        ##每行数据加转换符
        ($v_datatext) = "$v_datatext"."\n" ;
       
        ##调用生成数据文件函数
        $filepath=put_datafile("$v_datatext","$v_rows");
       }
       
  my ($v_err,$v_state,$v_errmsg) = ($dbh->err,$dbh->state,$dbh->errstr);
  ## $sth->finish(); 
  #返回
  return ($v_rows,$v_err,$v_state,$v_errmsg);
}

#执行SQL,写日志
sub execSqlWf {
  my ($dbh,$v_sql) = @_;
  my ($v_rows,$v_err,$v_state,$v_errmsg) = execSql($dbh,$v_sql);##执行SQL

  ##判断执行状态，报错退出，回滚且记日志
  if (!defined($v_errmsg) ) {
    $v_state =0;
  } else {
    $s_text="Program Error: SQLSTATE: $v_state ; ERROR MESSAGE: $v_errmsg ;ERR :$v_err" ;
    ##替换换行符为.号
    $s_text=~s/\n/./g;
    writelogfile();
    $dbh->rollback;
    die "$s_text\n";
  }
  
  #返回受影响行数
  return $v_rows;
}


###SQL Main

sub SQLmain {
  my ($dbh,$filename)= @_;

  $s_text ="[1] 获得expsql语句 ";
  my $v_columnsql = get_EXPDATASQL($dbh,$filename );
  
  $s_text ="[2] 获取expsql的数据总行数 ";
  $v_dattotrownum = get_totalrowsnum($dbh,$v_columnsql);
  
  $s_text ="[3] 获取expsql的table_name,返回表的元数据 ";
  my $v_columnmeta = get_meta_info($dbh,$filename );

  $s_text ="[4] 写入table的元数据 ";
  my $v_get_meta_info=put_datafile($v_columnmeta,10);

  ##若导出数据量为0，则直接写空文件
  if($v_dattotrownum == 0 ){
  	   $s_text ="[3] 调用生成数据文件函数";
       ##调用生成数据文件函数
       $filepath=put_datafile("","$v_dattotrownum");
       $filepath ="/DXP/DATA/EDW/ROUT/"."$i_filename"."_"."$v_filedate".".DAT";
  	}else{
  	   $s_text ="[3] 导出数据并返回生成数据行数 ";
       $v_insrows=execSqlWf($dbh,$v_columnsql,);
  	}
 
}

##获取生成文件的SQL语句
sub get_expftppath
{
  my ($dbh,$v_myfilename)=@_;
  my $v_rows;
  my $v_ftppath ;
  
  $s_text ="[1.2] 将配置信息的sql语句从 etl_cfg2.EXPDATASQL 表中导出 ";
  my $v_quesql = qq{ select trim(FTP_PATH) from etl_cfg2.EXPDATASQL where upper(file_name) = '$v_myfilename'; };
  my ($sth) = $dbh->prepare_cached("$v_quesql") || die $dbh->errstr ;
  $v_rows = $sth->execute()||warn "Unable to process $v_quesql \n";  
  
  while(my @ref = $sth->fetchrow_array()){
        chomp (@ref);
        #以制表符来分割最后导出来的数据 
        my $v_columnref = join "\t", @ref ;
        # my $v_columnref=$ref[0];
        $v_ftppath = "$v_columnref" ;
       }
       
  ##写日志
  writelogfile();     
  ##返回配置表中配置的sql语句
  return ($v_ftppath);
};

##获取生成表的列名
sub get_meta_info
{
  my ($dbh,$v_myfilename)=@_;
  my $v_rows;
  my $v_columnmeta="";
  
  $s_text ="[1.2] 将配置信息的sql语句从 etl_cfg2.EXPDATASQL 表中导出 ";
  my $v_quesql = qq{select b.column_name from etl_cfg2.EXPDATASQL a join columns b on a.table_name=b.table_name  where upper(file_name) = '$v_myfilename'; };
  my ($sth) = $dbh->prepare_cached("$v_quesql") || die $dbh->errstr ;
  $v_rows = $sth->execute()||warn "Unable to process $v_quesql \n";  
  
  while(my @ref = $sth->fetchrow_array()){
        chomp (@ref);
        #以制表符来分割最后导出来的数据 
        my $v_columnref = join "", @ref ;
        # my $v_columnref=$ref[0];
        if(length($v_columnmeta) ==0 ){
          $v_columnmeta =$v_columnref;
        }
        else{
          $v_columnmeta =$v_columnmeta.'|'.$v_columnref;
        }
       }
  
  ##写日志
  $v_columnmeta=$v_columnmeta."\n";
  writelogfile();     
  ##返回配置表中配置的sql语句
  return ($v_columnmeta);
};


##ftp登陆
sub ftppush{
  my ($ftp_filepath,$ftp_v_ftppath)= @_;
  chomp($ftp_v_ftppath);
  my $ftp = Net::FTP->new("$ftp_ip;", Debug => 0) or die "Cannot connect to$ftp_ip: $@";
  $ftp->login("$ftp_user","$ftp_passwd") or die "Cannot login ", $ftp->message;
  $ftp->cwd("$ftp_v_ftppath") or die "Cannot change working directory ", $ftp->message;
  print $ftp_filepath,qq(\n),$ftp_v_ftppath,qq(\n);
  $ftp->put("$ftp_filepath") or die "put failed ", $ftp->message;
  $ftp->quit;
}

###scp登陆
sub scppush{
  my ($ftp_filepath,$ftp_v_ftppath)= @_;
  chomp($ftp_v_ftppath);
  my $sftp_ip=$ftp_ip;
  my $sftp_user=$ftp_user;
  my $sftp_passwd=$ftp_passwd;
  my $sftp_src_file=$ftp_filepath;
  my $sftp_dest_file=$ftp_v_ftppath;
  my $sftp_cmd="expect /app/etlscript/BDW_SHELL/scp.sh $sftp_ip $sftp_user $sftp_passwd $sftp_src_file $sftp_dest_file";
  print $sftp_cmd,"\n";
  system($sftp_cmd);

}

###sftp登陆
sub sftppush{
  my ($ftp_filepath,$ftp_v_ftppath)= @_;
  chomp($ftp_v_ftppath);
  my $sftp_ip=$ftp_ip;
  my $sftp_user=$ftp_user;
  my $sftp_passwd=$ftp_passwd;
  my $sftp_src_file=$ftp_filepath;
  my $sftp_dest_file=$ftp_v_ftppath;
  my $sftp_cmd="expect /app/etlscript/BDW_SHELL/sftp.sh $sftp_ip $sftp_user $sftp_passwd $sftp_src_file $sftp_dest_file";
  # print "传入之后的路径",$sftp_dest_file,"\n";
  print $sftp_cmd,"\n";
  system($sftp_cmd);

}

##执行FTP功能
sub FTPmain {
  my ($dbh,$filename)= @_;
  $s_text ="[1] 获得expsql语句ftp";
  my $v_ftppath = get_expftppath($dbh,$filename );
  # print "传入之前的路径",$v_ftppath,"\n";
  # ftppush($filepath,$v_ftppath);
  # scppush($filepath,$v_ftppath);
  sftppush($filepath,$v_ftppath);
}


### main
###脚本执行主函数
sub main {
  #判断入参个数为2个，i_date 执行时间
  unless (@ARGV == 2) {
   die "$0 Please check the parameters: the first parameter is Data Date, the second parameter is FileName! \n";
  }
  
  my $v_dbname        = "dws";         ##数据库名

  $i_date             = $ARGV[0];      ##执行日期
  # 文件名大写开关
  $i_filename         = uc($ARGV[1]);  ##生成文件名
  
  #数据文件日期格式转换#
  $v_filedate= $i_date ;
  # 决定日期的格式
  # $v_filedate=~s/\-//g;
  
  #配置数据文件生成路径和数据文件名称信息，如有需要请自行配置#
  # $filepath ="/DXP/DATA/EDW/ROUT/"."$i_filename"."_"."$v_filedate".".DAT";

  ##设置日志文件全路径名
  $s_logfilename = "$s_logfilename"."$i_filename".".log" ;

  #建立数据源连接,没有建立成功,脚本出错退出
  my $dbh = MyDBI::connectDb($v_dbname);
  ##执行主体SQL语句（第一个参数数据库句柄，第二个参数）
  SQLmain($dbh,$i_filename);

  ##执行FTP功能
  FTPmain($dbh,$i_filename);
  ##断开数据源连接
  disconnectDb($dbh);
  
  ##生成CTL文件(第一个参数为生成CTL文件路径，第二个参数生成CTL文件名称但‘不带.CTL’后缀，第三个参数为生成.DAT文件里数据的行数)
  ##put_ctlfile( "/DXP/DATA/EDW/ROUT/" ,"$i_filename"."_"."$v_filedate" , $v_insrows ) ;
  
  
  ##执行成功退出记录日志
  $s_text="PROG END,删除记录条数： $v_delrows 插入记录条数： $v_insrows";
  ##写日志
  writelogfile();

  return 0;
}

# run main
exit(main());