## 01: PLSLQL: select into
#      $dbh->selectrow_array
 my $v_selsql = qq{
                   select ins_sql,del_sql
                     from etl_cfg2.odsetlsql
                     where ods_scm = '$i_tabschema'
                       and ods_tab = '$i_tabname';
                   };
  my ($v_inssql,$v_delsql)=$dbh->selectrow_array($v_selsql);
  
## 02: PLSQL  excute immediate 'DML'
$v_rows = $dbh->do($v_sql)||warn "Unable to process $v_sql\n";

## 03: PLSQL: excption   when others  sqlerr,sqlmsg
my ($v_err,$v_state,$v_errmsg) = ($dbh->err,$dbh->state,$dbh->errstr);
return ($v_rows,$v_err,$v_state,$v_errmsg);

## 04: PLSQL强制主键:
##运用了Vertica数据库中ANALYZE_CONSTRAINTS()函数，来查找表的主键
#select \"Column values\" from ( SELECT ANALYZE_CONSTRAINTS(\'$i_tabschema.$i_tabname\') )t where \"Constraint Type\" = \'PRIMARY\' ;
my  $v_pksql = qq{ select \"Column values\" from ( SELECT ANALYZE_CONSTRAINTS(\'$i_tabschema.$i_tabname\') )t where \"Constraint Type\" = \'PRIMARY\' ; }; 
$v_pkconrows=$dbh->do($v_pksql)||warn "Unable to process $v_pksql\n";
if ( $v_pkconrows == 0 ){ 
  	$dbh->commit() if $dbh ; 	
}else{
    $dbh->disconnect() if $dbh ;
}

## 05: PLSQL写日志表
  $s_text ="[3] 检查表 $i_tabschema"."."."$i_tabname 插入的数据是否出现主键冲突情况 ";
  my ($v_sec,$v_min,$v_hour,$v_mday,$v_mon,$v_year) = localtime(time);
  my $v_exetms=sprintf "%4d-%02d-%02d %02d:%02d:%02d",$v_year+1900,$v_mon+1,$v_mday,$v_hour,$v_min,$v_sec;
	open (OUTFILE,">> $s_logfilename");
	print OUTFILE  "$v_exetms $s_username $s_text \n";
	close(OUTFILE);

## 06:程序入口:
# run main
exit(main());


## 07: call sub procedure参数
my ($dbh,$v_sql) = @_;

## 08: sub main() 接收命令行参数
  unless (@ARGV == 3) {
   die "$0 Please check the parameters: the first parameter is the data date, the second parameter is Schema_Name, the third parameter is Table_Name! \n";
  }

  $i_date               = $ARGV[0];##执行日期
  $i_tabschema          = uc($ARGV[1]);##ODS表模式名
  $i_tabname            = uc($ARGV[2]);##ODS表名

## 09. 数据库连接:
###定义功用模块:

package MyDBI;
use DBI;
#connectDb
sub connectDb {
  ##获得连接信息
  my ($dbrc)=open(FILE,"$dbcfg");
  my (@dbinfo);
  if ($dbrc == 1 ){
   	@dbinfo=<FILE>;
   	close(FILE);
   }
  #取数据库用户与密码#
  my ($dbname) =@_;
  $dbinfo[3]=~s/^.{1,}\=//g;
  $dbinfo[4]=~s/^.{1,}\=//g;
  $dbinfo[5]=~s/^.{1,}\=//g;  
  $dbinfo[6]=~s/^.{1,}\=//g;  
  $dbinfo[7]=~s/^.{1,}\=//g;        
  #去除转换符#      
  chomp $dbinfo[3];
  chomp $dbinfo[4];
  chomp $dbinfo[5];
  chomp $dbinfo[6];
  chomp $dbinfo[7];
  my ($DB_Driver)   = $dbinfo[3];
  my ($DB_Server)   = $dbinfo[4];
  my ($DB_Port)     = $dbinfo[5];
  my ($DB_User)     = $dbinfo[6];
  my ($DB_PassWord) = $dbinfo[7];
  my ($dbh) = DBI->connect("dbi:ODBC:DRIVER=$DB_Driver;Server=$DB_Server;ConnectionLoadBalance=1;" .
        "Port=$DB_Port;Database=$dbname;UID=$DB_User;PWD=$DB_PassWord",{AutoCommit=>0})
        or die "Could not connect to database: " . DBI::errstr . "\n";
                       
  return $dbh;#返回连接
}

###模块调用
use MyDBI;
my $dbh = MyDBI::connectDb($v_dbname);