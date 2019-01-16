use DBI;
use warnings;
use Time::Local;
use POSIX qw(mktime);



##传入参数变量
my $v_date='2017-08-07';                                         ##数据日期
my $i_schname='bdw_test';                                      ##schema名称
my $i_tabname='bdl_test';
# my $i_date=$ARGV[0];                                         ##数据日期
# my $i_schname=$ARGV[1];                                      ##schema名称
# my $i_tabname=$ARGV[2];                                      ##表名

################################################################################
sub consist{
	(my $m_sql_str,$e_sql_str,my @var_arr) = @_;
	my $var_size = $#var_arr+1;
	my $union_m_sql_str = '';
	#定义最大组合个数，根据维度个数计算最大组合个数
	my $var_max = '';
	for(my $i = 0;$i < $var_size;$i++){
		$var_max = $var_max.'1';
	}
	$var_max = oct( '0b' . $var_max );
	print "最大组合数：".($var_max+1)."\n";
	print "组合长度：$var_size\n";
	print "=========组合形式如下=========\n";
	#根据最大组合次数，推算出各种组合
	for(my $j = 0;$j <= $var_max;$j++){
		#"%0".$#var_size."b"根据数组维度个数生成二进制数字自动补0长度，例如：'1'如果数组长度是3变成二进制'001'
		my $bin = sprintf("%0".$var_size."b",$j);
		print $bin."\n";
		#根据组合形式对维度进行all转换：例如：维度（a,b,c），组合形式010 ，转换成（a,'all',c）
		my $tmpstr = '';
		for($m = 0 ;$m < $var_size;$m++){
			if(substr($bin,$m,1)==1){
				$tmpstr = $tmpstr."'all'".',';
			}else{
				$tmpstr = $tmpstr.$var_arr[$m].',';	
			}
		}
		#进行语句的union拼接
		if($j==$var_max){
			$union_m_sql_str = $union_m_sql_str."select ".$tmpstr.$m_sql_str.$tmpstr.$e_sql_str."\n";
			#print "finish \n";
		}else{
			$union_m_sql_str = $union_m_sql_str."select ".$tmpstr.$m_sql_str.$tmpstr.$e_sql_str."\n"."union all \n";
			#print $j ."\n";
		}		
		#print $union_m_sql_str. "\n";
	}	
	return $union_m_sql_str;
}
##############################################################################################
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
###########################################################################
#写日志文件
sub writelogfile {
  my ($v_sec,$v_min,$v_hour,$v_mday,$v_mon,$v_year) = localtime(time);
  my $v_exetms=sprintf "%4d-%02d-%02d %02d:%02d:%02d",$v_year+1900,$v_mon+1,$v_mday,$v_hour,$v_min,$v_sec;
    open (OUTFILE,">> $s_logfilename");
    print OUTFILE  "$v_exetms $s_username $s_text\n";
    close(OUTFILE);
  return 0;
};

###########################################################################
#执行sql
sub execSQL(){
	my ($db_cfg,$v_sql) = @_;
	my $dbh = connectDb($db_cfg);

    if ($v_debug == 1) {
       print "---------------------------------------------------------\n";
       print $v_sql,"\n";
       print "---------------------------------------------------------\n";
     }
    
     #执行前写日志
     writelogfile(); 
     
     $dbh->do($v_sql)||warn "Unable to process $v_sql\n";
     my ($v_err,$v_state,$v_errmsg) = ($dbh->err,$dbh->state,$dbh->errstr);
     
     #判断执行状态，报错退出，回滚且记日志
     if (!defined($v_errmsg) ) {
       $v_state =0;
     } 
     else {
       $s_text="PROGRAM EXIT ERROR：SQLSTATE: $v_state ; ERROR MESSAGE: $v_errmsg ; ERR: $v_err";
       ##替换换行符为.号
       $s_text=~s/\n/./g;
       writelogfile();
       $dbh->rollback;
       die "$s_text\n";
     }
    
       #数据库提交
    $dbh->commit  if $dbh;
    #断开数据库连接
    $dbh->disconnect  if $dbh ;
    return 0;
}

############################################################################################
#main
############################################################################################
print "--------------------------\n 1-prepare into main() \n --------------------------\n";
sub main {
	print "--------------------------\n 2-first into main() \n --------------------------\n";

	my $tmp_sql_str = qq(create local temporary table temp_trade ON COMMIT PRESERVE ROWS  as (with t as (select * form t1) select * from t);
                        );
    my $e_sql_str = qq('$v_date',to_char(sysdate,'yyyymmdd'));
    my $m_sql_str = qq(
				count(distinct case when a.STATUS='1' then  a.user_phone else NULL end )  as succ_user_num, ---成功用户数
				SUM( case when a.STATUS='1' then a.total_money else NULL end)/100 as succ_trade_amt,
				count(distinct case when a.STATUS='1' then  a.id else NULL end )  as succ_trade_num,     ---成功笔数
				count(distinct case when a.STATUS='2' then  a.user_phone else NULL end )  as succ_user_num, ---失败用户数
				SUM( case when a.STATUS='2' then a.total_money else NULL end)/100 as succ_trade_amt,
				count(distinct case when a.STATUS='2' then  a.id else NULL end )  as succ_trade_num,  ---失败笔数
				'$v_date',
				TO_CHAR(SYSDATE,'YYYY-MM-DD')
				from temp_trade a
				where a.date='$v_date'
                GROUP BY );
    my $one_dim=qq(nvl(a.BUSI_TYPE_CODE,'other'));
	my $two_dim=qq(nvl(a.user_source,'other'));
	my $three_dim=qq(nvl(a.pay_tools,'other'));
	#定义维度，调用拼接union all语句 方法
	my @var_arr = ($one_dim,$two_dim,$three_dim);

	my $union_m_sql_str = consist($m_sql_str,$e_sql_str,@var_arr);
	my $del_sql_str =qq(delete from bdw_test.bdl_test where stat_date='$v_date';);
	my $ins_sql_str = qq(insert into  bdw_test.bdl_test \n$union_m_sql_str;);
	my $v_inssql = qq($tmp_sql_str\n$del_sql_str\n$ins_sql_str);
	print $v_inssql;
	print "--------------------------\n 3-end into main() \n --------------------------\n";

}
# 运行 main
exit(main());
print "--------------------------\n 4-out of main() \n --------------------------\n";
