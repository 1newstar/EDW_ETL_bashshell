use strict;
use utf8;
binmode(STDIN,  ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

#############################################
##		简述1
#############################################
## (1)在进行模式匹配的时候,默认搜索对象是$_  --There is a strange scalar variable called $_ in Perl
	my @en_char='a'..'z';
	print foreach @en_char,"\n";			#foreach遍历列表的元素,并且通过标量变量$_引用每个列表的元素.abcdefghijklmnopqrstuvwxyz

## (2)if修饰符
	$_="xabccy\n";
	print if /abc/;							#xabccy

## (3)模式绑定运算符=~
	$_="xabccy\n";
	print if $_=~/abc/;						#等价于print if /abc/;

## (4)文件句柄或者STDIN
# use strict;
	# use warnings;
	# use v5.10;
	#  while (<STDIN>) {
	#    chomp;
	#    pirnt if /MATCH/;
	# }
# 等价于
	# use strict;
	# use warnings;
	# use v5.10;
	# while ($_ = <STDIN>) {
	#    chomp $_;
	#    print $_ if ($_ =~ /MATCH/);
	#    }
	# }
## 

#############################################
##		方式1-m运算符和匹配      
## 		m/<regexp>/match_option		   
#############################################

## m/<regexp>;/match_option
	## m作为定界符
	 	#  /Regular Expression/ 	default delimiter
		# m#Regular Expression# 	optional delimiters
		# m{regular expression} 	pair of delimiters

	##match_option 修饰符gimosxe
		#o 仅编译模式一次.节省perl编译长的正则表达式时间.
		#g 全局匹配。即查找所有具体值。如果用于数组型上下文语境，则会返回一个列表；如果用于标量型上下文语境，则返回真或假
		#i 不区分大小写匹配
		#m 看成多行匹配:(1)适用于$,^  (2)对于. POSIX元字符,匹配的时候,不匹配换行符
		#s 把字符串看成单行.(1)强迫^$不特殊看待新行符号. (2)让.匹配换行符
		#x 。修饰符x 用于在正则表达式中放入注释或者空白字符（空格、制表符、换行符等），以便让表达式含义更明确。而这些字符是不作为正则表达式的组成部分来解释的

	##匹配修饰符:gi,结果保存在列表中
		$_="I lost my loves in the clover,Love.";
		my @love_list=m/love/g;
		print join("\t",@love_list),qq(\n);					#love	love
	##特殊标量
		# $_,搜索该模式
		# $&,保存该模式
		# $`,保存该匹配模式的字符串之前的内容;--对于g全局,以最后一次匹配为准
		# $',保存该匹配模式的字符串之后的内容;--对于g全局,以最后一次匹配为准
		print $&,qq(\n);											#love
		print $',qq(\n);											#r,Love.
		print $`,qq(\n);											#I lost my loves in the c
	##匹配修饰符:x --用于在正则表达式中放入注释或者空白字符
		/loves #找一个单词
		/x;
		print $&,qq(\n);											#loves
		print $',qq(\n);											# in the clover,Love..
		print $`,qq(\n);											#I lost my 


#############################################
##		方式2-s运算符和替换      
## 		s/pattern/replacement/match_option   
#############################################

##s/pattern/replacement/egimosx
	##match_option 修饰符egimosx
		# e 将替换一侧作为表达式来求值
		# i 关闭大小写敏感性
		# o 只编译模式一次。用于优化搜索流程
		# s 嵌入换行符时，将字符串作为单行处理a
		# m 将字符串作为多行处理
		# x 允许在正则表达式中提供注释，并忽略空白字符
		# g 全局匹配。即查找所有具体值
	##修饰符:e
		$a="zzz123a4xxx123b4www123f4sss12374";
		$a=~s/123(.*?)4/&getdata($1)/eg;
		sub getdata {
			my ($a)=@_;
			my $data.=$a." ";
			return $data;
		}
		print $a;
		##zzza xxxb wwwf sss7

		##例子2
		$_=5000;
		s/$_/$& * 2/e;
		print $_;			#1000

		##例子3
		$_="i like rock and roll";
		s/rock/"$&," x 2 ."$&ing"/ei;
		print $_;			#i like rock,rock,rocking and roll

#############################################
##		方式3-tr运算符(单个字符匹配)和转换      
## 		tr/pattern1/pattern2/match_option
##		y/pattern1/pattern2/match_option
#############################################		
	##修饰符
		#c 	c表示把匹配不上的字符进行替换.
		#d  表示把匹配上的字符全部替换
		#s  表示如果要替换的字符中出现连续多个一样的字符，则去冗余：
	##修饰符c  匹配不上的字符进行替换.
		my $temp="AAAABCDEF";
		my $count=$temp=~tr/A/H/c;
		print "$temp\t$count\n";				#结果：AAAAHHHHH 5
#############################################
##		简述2--模式绑定运算符
##	=~
##	!=
#############################################
#模式匹配运算符 示例     涵　义
		# $name =~/John/ 			如果$name 含有模式则为真。如果是真，返回1；否则返回空值
									#n个匹配呢,返回n
		# $name !~/John/ 			如果$name 不含有模式，则为真
		# $name =~s/John/Sam/ 		将匹配John 的第一个值替换为Sam
		# $name =~s/John/Sam/g 		将匹配John 的所有具体值替换为Sam
		# $name =~tr/a-z/A-Z/ 		将所有小写字符翻译为大写字母
		# $name =~/$pal/ 			在搜索字符串时使用变量
