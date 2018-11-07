use strict;
use utf8;
binmode(STDIN,  ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

查找已安装模块
> perl -MModuleName -e " print "
或者:
perl -e "use ModuleName"
# 可以通过编程产生一个所有可用模块的列表：
use File::Find;
# Module list
foreach my $dir (@INC){
	find sub {
		print "$File::Find::name\n" if /\.pm$/;
	}, $dir;
}


或者使用CPAN模块察看所有的安装模块
>perl -MCPAN -e auto ndle