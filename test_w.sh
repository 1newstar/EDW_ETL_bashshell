#!/bin/sh
#例程:sh foradl.sh date_start date_end adl_name
#例如:sh foradl.sh 20161101 20161108 adl_offline_pos_installment_income_d

# 必须第一个参数是周日的参数 20170101,第二个参数也是周日20171217

# v_tablename=`echo $3|tr 'A-Z' 'a-z'`
# v_scriptname=$v_tablename.pl
DATE(1)                          User Commands                         DATE(1)

NAME
       date - print or set the system date and time


       -d, --date=STRING
              display time described by STRING, not ‘now’


# 加减运算
date -d '20170101 +7 day' +%Y%m%d
20170108
date -d '+7 days 20170101' +%Y%m%d
20170108
date -d '20170101 +1 week' +%Y%m%d
20170108

# 星期判断
date -d '20170101' +%w
0 --周日
date -d '20170102' +%w
1 --周一


# 加工频度:d日报,w周报,m月报,y日报
# v_frequent=`echo ${v_tablename: -1}`

# declare -i date_start=`date --date=$1 +%s`
# declare -i date_end=`date --date=$2 +%s`
# declare -i date_len_s=`expr $date_end-$date_start`
# declare -i date_len=$(($date_len_s/60/60/24/7))

# for ((j=0; j<=$date_len; ++j))
# 		do   
# 			z=$j*7
# 			declare -i date_temp=`date -d "+$z days $1" +%Y%m%d`
# 		echo "perl $v_scriptname.pl $date_temp BDW_ADL $v_tablename" >> test.log
# done




