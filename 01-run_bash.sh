#!/bin/sh
#创建人徐长亮
#例程:sh run_bash_frequent.sh adl_name date_start date_end 
#例如:sh run_bash_frequent.sh adl_offline_pos_installment_income_d 20161101 20161108 
# nohup sh run_bash_frequent.sh adl_wo_user_source_login_w 20170101 20171217 >foradllog/20171219-adl_wo_user_source_login_w.log 2>foradllog/20171124-adl_wo_user_source_login_w.err &

v_tablename=`echo $1|tr 'A-Z' 'a-z'`
v_scriptname="/app/etlscript/BDW_ADL/$v_tablename.pl"
# 加工频度:d日报,w周报,m月报,y日报
v_frequent=${v_tablename: -1}


if [ $v_frequent == 'd' ];then
	declare -i date_start=`date --date=$2 +%s`
	declare -i date_end=`date --date=$3 +%s`
	declare -i date_len_s=`expr $date_end-$date_start`
	declare -i date_len=$(($date_len_s/60/60/24))

	for ((j=0; j<=$date_len; ++j))
		do 
			declare -i date_temp=`date -d "+$j days $2" +%Y%m%d`
		perl $v_scriptname $date_temp BDW_ADL $v_tablename
		# echo "perl $v_scriptname $date_temp BDW_ADL $v_tablename"
	done
fi

if [ $v_frequent == 'm' ];then
	# month (01..12) sed -r 's/^0+//'去掉0,因此不支持跨年的.
	declare -i month_start=`date --date=$2 +%m | sed -r 's/^0+//'`
	declare -i month_end=`date --date=$3 +%m | sed -r 's/^0+//'`
	declare -i month_len=`expr $month_end-$month_start`

	for ((j=0; j<=$month_len; ++j))
		do 
			declare -i date_temp=`date -d "+$j month $2" +%Y%m%d`
			perl $v_scriptname $date_temp BDW_ADL $v_tablename
			# echo "perl $v_scriptname $date_temp BDW_ADL $v_tablename"
	done
fi

# 必须第一个参数是周日的参数 20170101,第二个参数也是周日20171217
# week number of year, with Monday as first day of week (00..53) 不支持跨年.


if [ $v_frequent == 'w' ];then
	# week number of year,week (00..53) 不支持跨年. sed -r 's/^0+//'去掉0,因此不支持跨年的.
	declare -i week_start=`date --date=$2 +%W | sed -r 's/^0+//'`
	declare -i week_end=`date --date=$3 +%W | sed -r 's/^0+//'`
	declare -i week_len=`expr $week_end-$week_start`
	declare -i week_name=`date -d $2 +%w`
	if [ $week_name == 0 ];then
		for ((j=0; j<=$week_len; ++j))
			do 
				declare -i date_temp=`date -d "+$j weeks $2" +%Y%m%d`
				perl $v_scriptname $date_temp BDW_ADL $v_tablename
				# echo "perl $v_scriptname $date_temp BDW_ADL $v_tablename"
		done
	else
		echo "input error:: the firt input,must be a date of sunday"
		return 1
	fi
fi