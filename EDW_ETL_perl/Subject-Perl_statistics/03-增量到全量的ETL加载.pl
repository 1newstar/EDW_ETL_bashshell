use DBI;
use warnings;
use strict;
use Time::Local;

##自定义参数变量
my $v_debug = 0;  

sub writelogfile {
  my ($v_sec,$v_min,$v_hour,$v_mday,$v_mon,$v_year) = localtime(time);
  my $v_exetms=sprintf "%4d-%02d-%02d %02d:%02d:%02d",$v_year+1900,$v_mon+1,$v_mday,$v_hour,$v_min,$v_sec;
    open (OUTFILE,">> $s_logfilename");
    print OUTFILE  "$v_exetms $s_username $s_text\n";
    close(OUTFILE);
  return 0;
};


sub connectDb {
  # my ($dbcfg) =@_;
  my ($dbcfg)="DB.cfg";#
  my ($dbrc)=open(FILE,"$dbcfg");
### 文件 DB.cfg 内容 #############
# ##Write in format limit
# Vertica_DWS
# {
# DB_Driver=VerticaDSN
# DB_Server=127.0.0.1
# DB_Port=5433
# DB_User=etl
# DB_PassWord=etl
# DB_NAME=dws
# }
#########################
  #存放配置文件信息数组#
  my (@dbinfo);
  #判断配置文件是否存在#
  if ($dbrc == 1 )
  {
    @dbinfo=<FILE>;
    close(FILE);
  }
 else {
    print "open DBLink.cfg file error";
    close(FILE);
  }

  #转换数组格式#
  $dbinfo[3]=~s/^.{1,}\=//g;
  $dbinfo[4]=~s/^.{1,}\=//g;
  $dbinfo[5]=~s/^.{1,}\=//g;
  $dbinfo[6]=~s/^.{1,}\=//g;
  $dbinfo[7]=~s/^.{1,}\=//g;
  $dbinfo[8]=~s/^.{1,}\=//g;
  #去除转换符#
  chomp $dbinfo[3];
  chomp $dbinfo[4];
  chomp $dbinfo[5];
  chomp $dbinfo[6];
  chomp $dbinfo[7];
  chomp $dbinfo[8];
  #取数据库用户与密码#
  my ($DB_Driver)   = $dbinfo[3];
  my ($DB_Server)   = $dbinfo[4];
  my ($DB_Port)     = $dbinfo[5];
  my ($DB_User)     = $dbinfo[6];
  my ($DB_PassWord) = $dbinfo[7];
  my ($DB_dbname)   = $dbinfo[8];

      my ($dbh) = DBI->connect("dbi:ODBC:DRIVER=$DB_Driver;Server=$DB_Server;ConnectionLoadBalance=1;" .
        "Port=$DB_Port;Database=$DB_dbname;UID=$DB_User;PWD=$DB_PassWord",{AutoCommit=>0})
        or die "Could not connect to database: " . DBI::errstr . "\n";
  return $dbh;#返回连接

}

sub main {
    my $dbh = connectDb("DB.cfg");
    my ($v_inssql,$v_delsql)=$dbh->selectrow_array(qq(select ins_sql,del_sql from etl_cfg2.odsetlsql));
    if(!defined($v_inssql)){
    die "ERROR:no table etl script! please check input parameter!\n";
  	}

    if ($v_debug == 1) {
       print "---------------------------------------------------------\n";
       print $v_inssql,"\n";
       print $v_delsql,"\n";
       print "---------------------------------------------------------\n";
     }

     ############### 执行delete ##############################
     $v_rows = $dbh->do($v_delsql)||warn "Unable to process $v_delsql\n";
     $dbh->do($v_delsql)||warn "Unable to process $v_delsql\n";
     my ($v_err,$v_state,$v_errmsg) = ($dbh->err,$dbh->state,$dbh->errstr);
     
     #判断执行状态，报错退出，回滚且记日志
     if (!defined($v_errmsg) ) {
       $v_state =0;
  	   $s_text ="[1] 删除目标表 $i_tabschema"."."."$i_tabname 数据";
     } 
     else {
       $s_text="PROGRAM EXIT ERROR：SQLSTATE: $v_state ; ERROR MESSAGE: $v_errmsg ; ERR: $v_err";
       ##替换换行符为.号
       $s_text=~s/\n/./g;
       writelogfile();
       $dbh->rollback;
       die "$s_text\n";
     }


     ############### 执行insert ##############################
     $v_rows = $dbh->do($v_inssql)||warn "Unable to process $v_inssql\n";
     $dbh->do($v_inssql)||warn "Unable to process $v_inssql\n";
     my ($v_err,$v_state,$v_errmsg) = ($dbh->err,$dbh->state,$dbh->errstr);
     
     #判断执行状态，报错退出，回滚且记日志
     if (!defined($v_errmsg) ) {
       $v_state =0;
 	   $s_text ="[2] 向目标表 $i_tabschema"."."."$i_tabname 插入数据";
     } 
     else {
       $s_text="PROGRAM EXIT ERROR：SQLSTATE: $v_state ; ERROR MESSAGE: $v_errmsg ; ERR: $v_err";
       ##替换换行符为.号
       $s_text=~s/\n/./g;
       writelogfile();
       $dbh->rollback;
       die "$s_text\n";
     }

    ###检查主键##################################################
  	 my  $v_pksql = qq{ select \"Column values\" from ( SELECT ANALYZE_CONSTRAINTS(\'$i_tabschema.$i_tabname\') )t where \"Constraint Type\" = \'PRIMARY\' ; }; 
  	 $v_rows = $dbh->do($v_inssql)||warn "Unable to process $v_inssql\n";
     
     $dbh->do($v_pksql)||warn "Unable to process $v_pksql\n";
     my ($v_err,$v_state,$v_errmsg) = ($dbh->err,$dbh->state,$dbh->errstr);
     
     #判断执行状态，报错退出，回滚且记日志
     if (!defined($v_errmsg) ) {
       $v_state =0;
 	   $s_text ="[2] 向目标表 $i_tabschema"."."."$i_tabname 插入数据";
     } 
     else {
       $s_text="PROGRAM EXIT ERROR：SQLSTATE: $v_state ; ERROR MESSAGE: $v_errmsg ; ERR: $v_err";
       ##替换换行符为.号
       $s_text=~s/\n/./g;
       writelogfile();
       $dbh->rollback;
       die "$s_text\n";
     }

  	#判断主键是否冲突若冲突则回滚数据没有冲突就提交
  	if ( $v_rows == 0 ){ 
      #数据库提交
      $dbh->commit  if $dbh;
  	}else{
  	    $dbh->rollback()  if $dbh ;
  		die "$s_text \n";
  	}

    #断开数据库连接
    $dbh->disconnect  if $dbh ;
    return 0;
}
exit(main());

