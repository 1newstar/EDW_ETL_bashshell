use strict;
use utf8;
binmode(STDIN,  ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

#操作符
##赋值操作符
##算数操作符
##字符操作符
	my $x='hello'.'world'; 					#连接操作符.
	my $x='name' x 8;						#赋值操作符;
	my @array=(1,2,3) x 3;
	# print join("\t",@array);				#列表的复制;
##比较操作符
	# 1 lt 2
	# 2 gt 1
	# 1 eq 1
	# 1 le 2
	# 2 ge 1
	# 1 ne 2
	# a cmp b #等于0,大于1,小于0
##逻辑操作符
	# !  逻辑非
	# || 逻辑或
	#&&	逻辑与
##位操作符
	# &	位与
	print 'a' & '_',qq(\t);
	print 'z' & '_',qq(\t);
	# | 位或
	print 'A' | ' ',qq(\t);
	print 'Z' | ' ',qq(\t\n);#A	Z a	z
	# ~位非 ^位异或
##组合字符操作符
	# +=	-=	*= /=	%=	**=
	# x= 重复字符串 .=连接字符串
	my $y='a';
	$y x=3;
	print qq($y\n);
	# ++$var;var++
##逗号和-列表运算符
##箭头操作符
	#引用的数据元素
	#多维数组,隐含使用了箭头操作符.
##范围操作符--列表上下文.
	my @mynum=1..5;
	my @mychar='a'..'e';
	print join(',',@mynum),qq(\t);
	print join(':',@mychar),qq(\n); #1,2,3,4,5	a:b:c:d:e
##三元操作符
	# condition?ture-result:false-result;
	print (2<1?$y:$mychar[0]);






