#!/bin/sh

#例程:sh foradl.sh date_start date_end adl_name
#例如:sh foradl.sh 20161101 20161108 adl_offline_pos_installment_income_d

v_tablename=`echo $3|tr 'A-Z' 'a-z'`
v_scriptname=$v_tablename.pl
# 加工频度:d日报,w周报,m月报,y日报
v_frequent=`echo ${v_tablename: -1}`


if [ $v_frequent == 'd' ];then
	declare -i date_start=`date --date=$1 +%s`
	declare -i date_end=`date --date=$2 +%s`
	declare -i date_len_s=`expr $date_end-$date_start`
	declare -i date_len=$(($date_len_s/60/60/24))

	for ((j=0; j<=$date_len; ++j))
		do 
			declare -i date_temp=`date -d "+$j days $1" +%Y%m%d`
		perl $v_scriptname.pl $date_temp BDW_ADL $v_tablename
	done
fi

if [ $v_frequent == 'm' ];then
	declare -i month_start=`date --date=$1 +%m | sed -r 's/^0+//'`
	declare -i month_end=`date --date=$2 +%m | sed -r 's/^0+//'`
	declare -i month_len=`expr $month_end-$month_start`

	for ((j=0; j<=$month_len; ++j))
		do 
			declare -i date_temp=`date -d "+$j month $1" +%Y%m%d`
			perl $v_scriptname.pl $date_temp BDW_ADL $v_tablename
	done
fi

# 必须第一个参数是周日的参数 20170101,第二个参数也是周日20171217
if [ $v_frequent == 'w' ];then
	declare -i date_start=`date --date=$1 +%s`
	declare -i date_end=`date --date=$2 +%s`
	declare -i date_len_s=`expr $date_end-$date_start`
	declare -i date_len=$(($date_len_s/60/60/24/7))
	for ((j=0; j<=$date_len; ++j))
		do   
			z=$j*7
			declare -i date_temp=`date -d "+$z days $1" +%Y%m%d`
		echo "perl $v_scriptname.pl $date_temp BDW_ADL $v_tablename" >> test.log
	done
fi