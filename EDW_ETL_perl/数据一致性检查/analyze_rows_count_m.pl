# !/usr/bin/perl -W
###########################################################################
#功能说明：收集vertica表的rows count信息
#维 护 人：徐长亮
#维护时间：2018-11-06
#运行周期：月
#例    程：perl analyze_rows_count_m.pl 2018-11-06

# 修改说明：
# select * from TEMP.TABLE_ROWS_COUNT order by rows_count desc
# VQueryExecutor::Execute: ErrorException: VPrepareError: Multiple commands cannot be active on the same connection. Considerincreasing ResultBufferSize or fetching all results before initiating another command

###########################################################################
use File::Basename;
use File::Path;
use File::stat;
use Net::FTP;
use DBI;
use warnings;
use strict;
use Time::Local;
use Digest::MD5;
use lib '/app/etlscript/bdw_cfg';
use MyDBI;

##系统常量
my $c_dbname          = "dws";                    ##数据库名
my $c_logfilename     = "/app/etlscript/log/dwa/analyze_statistics_w.log";
my $c_username         =$ENV{'USER'};               ##获取系统用户名
my $c_text            = '';                         ##注释文本
##传入参数变量
my $i_date_10;                                      ##数据日期
##自定义参数
my $gv_date_8;
my $gv_debug = 0;                                   ##是否打印sal,默认不开启
#############################################################################################
sub main {
  unless (@ARGV == 1) {
   die "$0 Please check the parameters: the first parameter is Data Date! \n";
  }
  $i_date_10  = $ARGV[0];      ##执行日期
  $gv_date_8  = $i_date_10;
  $gv_date_8  =~s/\-//g;

  my $dbh = MyDBI::connectDb($c_dbname);
  $dbh->{AutoCommit}=0;

  get_execsql($dbh);

  $dbh->commit  if $dbh ;
  $dbh->disconnect  if $dbh ;

  $c_text="所有表的rows count收集完毕";
  writelogfile();
  return 0;
}
# run main
exit(main());
#############################################################################################
sub get_execsql
{
  my ($dbh)=@_;
  my @data;
  my $avc_rows;
  my $avc_execsql;

  my $avc_quesql = qq{ 
SELECT 'INSERT INTO TEMP.TABLE_ROWS_COUNT(TABLE_SCHEMA,TABLE_NAME,ROWS_COUNT,EXEC_DATE) SELECT '''||TABLE_SCHEMA||''','''||TABLE_NAME||''',COUNT(*),TO_CHAR(SYSDATE,''YYYY-MM-DD HH24:MI:SS'') FROM '||TABLE_SCHEMA||'.'||TABLE_NAME||';'
FROM TABLES
WHERE IS_TEMP_TABLE IS FALSE
  AND UPPER(TABLE_SCHEMA) IN ('TEMP',
                              'RISK_MANAGEMENT',
                              'RISK',
                              'MARKETING',
                              'ETL_CFG2_BAK',
                              'ETL_CFG2',
                              'ETL_CFG',
                              'BDW_SDL',
                              'BDW_MS',
                              'BDW_LAB_BAK',
                              'BDW_LAB',
                              'BDW_KPI_BAK',
                              'BDW_KPI',
                              'BDW_FDL_BAK',
                              'BDW_FDL',
                              'BDW_DX',
                              'BDW_DIM_BAK',
                              'BDW_DIM',
                              'BDW_BKBDL',
                              'BDW_BDL',
                              'BDW_AGT',
                              'BDW_ADL_BAK',
                              'BDW_ADL',
                              'AML')
ORDER BY TABLE_SCHEMA,
         TABLE_NAME;

  };
  # $dbh->prepare or  $dbh->prepare_cached
  my ($sth) = $dbh->prepare("$avc_quesql") or die "Couldn't prepare statement: " . $dbh->errstr;
  $avc_rows = $sth->execute()||warn "Unable to process $avc_quesql \n";

  while (@data = $sth->fetchrow_array()) {
        # chomp(my $avc_columnref = join "\t", @data);
        $avc_execsql = $data[0];

# VPrepareError: Multiple commands cannot be active on the same connection
        my $insert_dbh = MyDBI::connectDb($c_dbname);
        $insert_dbh->{AutoCommit}=0;
        execSql($insert_dbh,$avc_execsql);
        $insert_dbh->commit  if $insert_dbh ;
        $insert_dbh->disconnect  if $insert_dbh ;

       }

  if ($sth->rows == 0) {
      print "No table_name matched from tables where table_schema in'.\n\n";
  }
  $sth->finish;
  return 0;
};
#############################################################################################
sub execSql {
  my ($dbh,$v_sql) = @_;
  if ($gv_debug == 1) {
    print "---------------------------------------------------------\n";
    print "$v_sql \n";
    print "---------------------------------------------------------\n";
  }

  $dbh->do($v_sql)||warn "Unable to process $v_sql\n";
  my ($v_err,$v_state,$v_errmsg) = ($dbh->err,$dbh->state,$dbh->errstr);
  if (!defined($v_errmsg) ) {
    $v_state =0;
  }
  else {
    $c_text="PROGRAM EXIT ERROR：SQLSTATE: $v_state ; ERROR MESSAGE: $v_errmsg ; ERR: $v_err";
    ##替换换行符为.号
    $c_text=~s/\n/./g;
    writelogfile();
    $dbh->rollback;
    die "$c_text\n";
  }

  $c_text ="[2] 执行完毕rows count信息收集 $v_sql \n";
  writelogfile();
}
#############################################################################################
sub writelogfile {
  my ($v_sec,$v_min,$v_hour,$v_mday,$v_mon,$v_year) = localtime(time);
  my $avc_exetms=sprintf "%4d-%02d-%02d %02d:%02d:%02d",$v_year+1900,$v_mon+1,$v_mday,$v_hour,$v_min,$v_sec;
  open (OUTFILE,">> $c_logfilename");
  print OUTFILE  "$avc_exetms $c_username $c_text\n";
  close(OUTFILE);
  return 0;
};
