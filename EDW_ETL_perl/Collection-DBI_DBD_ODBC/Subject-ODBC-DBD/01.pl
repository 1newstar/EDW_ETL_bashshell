use DBI;
use warnings;
use strict;
use Time::Local;
use POSIX qw(mktime);
#use Date::Calc qw(:all); 

##传入参数变量
my $i_date='2017-08-07';                                         ##数据日期
my $i_schname='bdw_test';                                      ##schema名称
my $i_tabname='bdl_test';   

##自定义参数变量
my $v_debug = 0;  

print "into main \n";
### 脚本执行主函数main
sub main {

  my $v_dbname          = "dws";#数据库名

  #判断日期参数$i_date格式，若为YYYYMMDD转换成YYYY-MM-DD
  my $v_datelen = length("$i_date");
  my $v_date='';

  #日志格式: 20170807 转换为2017-08-17
  if($v_datelen == 8){
  	 $v_date = substr("$i_date",0,4)."-".substr("$i_date",4,2)."-".substr("$i_date",6,2);
  	}else{
  	 $v_date = $i_date ;
  	}

  #获得数据日期月份
  my $v_month= substr("$v_date",0,7);
  my @mlist = split (/-/, $v_month);
  my $v_mdt=join("",@mlist);

  #获得上月第一天和最后一天日期 
  my ($year, $month) = (substr($v_date,0,4), substr($v_date,5,2));
  
  # mktime(sec, min, hour, mday, mon, year, wday=0, yday=0, isdst=-1)，其中mon,wday和yday 是从0开始的
   my $lastday_time = POSIX::mktime(
    0, 0, 0,
    0, $month, $year-1900,    # Tricks: set mday=0, mon (0=Jan.,,,11=Dec
    0, 0, -1);
  my $lastday = (localtime($lastday_time))[3];
  my $v_fdt=$year.$month."01";
  my $v_ldt=$year.$month.$lastday;
  
   return 0;
}
print "exist main \n";
exit(main());