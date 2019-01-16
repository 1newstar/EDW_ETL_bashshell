# 变量：
# 	标量			$
# 	数组			@
# 	hash关联数组	%
# 数字
	#整形
	# int->string;
	$a=2001;
	# printf "%4d",$a;
	# compare int
	# $a==2001;

	# float->int
	# float->string
	# $f=100.1;
	# printf "%4d",int($f);
	# printf "%e",$f;

# 字符串
	# q()单引号
	# qq()双引号
	# qr()正则表达式
	# qw()单词表
	# qx()执行外部程序

# 字符串相关函数
	# print @list
	# chop 截断最后一个字符
	$b=chop $a;
	print $b."\n";
	#chomp $lines截断换行符，返回换行符
	print ord('A')."\n"; #65
	print chr('65')."\n";
	# print length("abcd")."\n";
	print index("look for what", "oo")."\n"; #1
	#逆向查找-fail
	print rindex("look for what", "oo")."\n"; #1
	#substr
    use utf8;
	print substr("零一二三四",2,2)."\n";
# perl.exe : Unrecognized character \xC1; marked by <-- HERE after nt substr(<-- HERE near column 14 at -e line 1.
# 解决use utf8;

	# PS C:\Users\unicom> perl -e "print '012345'"
	# 012345
	# ___________________________________________________________________________________________________
	# PS C:\Users\unicom> perl -e 'print "012345";'
	# 5349
	# ________________________________________________________________________________________________________
	# PS C:\Users\unicom> perl -e 'print qq(012345);'
	# 012345

	#大写uc，小写lc
	#连接字符串
	@lines=('hello',' ','world','!');
	my $text=join('-',@lines);
	my @arry=join("--\n",@lines);
	print qq(2.$text.\n);
	# print qq(3.@arry\n);

	#ltrim rtrim来源oracle
	#字符串比较 eq
use strict;
# here doc
	# here文档定义了一种字符串，字符串的结束符，以<<后面的【符号】定义，符号可以通过q qq括起来
	#支持插值，比如类似往print,sqlplus,vi等命令打开的输入缓存区中插值
 #    print<<EEOFA;
	# Usage: test.pl -c config, -f file -l lines
	# -c config file
	# -f file name
	# -l number of lines
	# EEOFA

my $html =<<EEOF
<html>
<head>hello</head>
<body>
<h1>春</h1>
你好春
</body>
</html>
EEOF
;
print $html;



