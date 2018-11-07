use DBI;
use warnings;
use Time::Local;
use POSIX qw(mktime);

sub consist{
	(my $m_sql_str,$e_sql_str,my @var_arr) = @_;
	my $var_size = $#var_arr+1;
	# print $var_size; 3
	my $union_m_sql_str = '';
	#定义最大组合个数，根据维度个数计算最大组合个数
	my $var_max = '';
	for(my $i = 0;$i < $var_size;$i++){
		$var_max = $var_max.'1';
		# var_max=1,11,111
		# print "\n-----------------------------------------\n";
		# print $var_max;
		# print "\n-----------------------------------------\n";
	}
	$var_max = oct( '0b' . $var_max );
		# var_max=7
		# print "\n-----------------------------------------\n";
		# print $var_max;
		# print "\n-----------------------------------------\n";
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


my $v_date='2017-08-07';                                         ##数据日期
my $tmp_sql_str = qq(create local temporary table temp_trade ON COMMIT PRESERVE ROWS  as
					                      (with t as (select * form t1) select * from t);
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
# print "\n-----------------------------------------\n";
# print $union_m_sql_str;
# print "\n-----------------------------------------\n";
my $del_sql_str =qq(delete from bdw_test.bdl_test where stat_date='$v_date';);
my $ins_sql_str = qq(insert into  bdw_test.bdl_test \n$union_m_sql_str;);
my $v_inssql = qq($tmp_sql_str\n$del_sql_str\n$ins_sql_str);
# print $v_inssql;
