# !/usr/bin/perl -W
###########################################################################
#功能说明：收集vertica表的统计信息
#维 护 人：徐长亮
#维护时间：2018-05-07
#运行周期：日
#例    程：perl analyze_statistics_w.pl 2018-05-07
#修改日期：2018-09-12
#修改人:徐长亮
#修改内容:
# select count(table_name) from tables where is_temp_table is false;
# select count(table_name) from all_tables where table_type='TABLE';
# select * from tables where is_temp_table is true;
# select * from all_tables where table_type='GLOBAL TEMPORARY';
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

  $c_text="所有表的统计信息收集完毕";
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

  my $avc_quesql = qq{ select 'select ANALYZE_STATISTICS('''||(table_schema||'.'||table_name)||''');' from tables where is_temp_table is false and upper(table_schema) in ('BDW_FDL','BDW_LAB','BDW_KPI','BDW_DIM','BDW_ADL') order by table_name; };
  # $dbh->prepare or  $dbh->prepare_cached
  my ($sth) = $dbh->prepare("$avc_quesql") or die "Couldn't prepare statement: " . $dbh->errstr;
  $avc_rows = $sth->execute()||warn "Unable to process $avc_quesql \n";

  while (@data = $sth->fetchrow_array()) {
        # chomp(my $avc_columnref = join "\t", @data);
        $avc_execsql = $data[0];
        execSql($dbh,$avc_execsql);
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

  $c_text ="[2] 执行完毕统计信息收集 $v_sql \n";
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
