use strict;
use utf8;
binmode(STDIN,  ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

	my %info_salery = (  
	"name" => "clark",  
	"part" => "BI",
	"salery" => 10000
	); 

#perl两种引用,硬引用和符号引用(被use strict;禁止)
#创建:
	#(1)使用\操作符创建引用.--或者指针.
	#(2)[]{}分别创建一个指向数组和hash表的引用.会创建自己内容的一个副本
	#   (根据字面量创建对象),返回指向它的一个引用(数组名本身就算引用),和\操作符不一样
	my $string_ref=\'hello ref';
	my $array_ref=[1,2,3,4];
	my $copy_hash_ref={%info_salery};

#访问引用
	# $相当C语言中的*,访问\操作符的标量引用

#引用:标量引用
	my $a='hello ref';
	my $ra=\$a; 							#指向标量的引用
	$$ra="change the $a\n"; 				#标量引用的解引用.
	print $a; 								#change the hello ref  #a的值被改变了.

##数组引用方式1:\操作符,引用已经存在的数组
	my @arry_norm=(1,2,3,4);
	my $rl=\@arry_norm; 					##指向已经存在的数组的引用
	print qq(@$rl\n);						##数组的解引用:用@,区别标量的解引用.
	print $rl->[1],qq(\n);  				#单个元素的箭头符号

##数组引用方式2:$=[]操作符引用
	my $rl2=[1,2,3]; 						#指向匿名块
	print qq(@$rl2\n);						#数组的解引用
	print $rl2->[1],qq(\n);  				#单个元素的箭头符号
	print qq($rl2\n);						#ARRAY(0x487908)

##哈希引用-方式1
	my $rh=\%info_salery;					#指向hash的引用
	print join("\t",keys(%$rh)),"\n";		#解引用%$
	my $x=$rh->{"name"};					#单个元素的箭头符号
	print "name=",$x,"\n";

##代码引用
	# my $rs=\&foo;							#引用一个已有子程序foo
	my $rs=sub {print "subroutnime foo,exexute foo()\n"};				#引用一个匿名的子程序
	&$rs();

##ref函数返回引用类型
	print qq(代码引用:),ref($rs),qq(\n);
	print qq(哈希引用:),ref($rh),qq(\n);
	print qq(数组引用:),ref($rl),qq(\n);
	print qq(标量引用:),ref($ra),qq(\n);
		# 代码引用:CODE
		# 哈希引用:HASH
		# 数组引用:ARRAY
		# 标量引用:SCALAR

