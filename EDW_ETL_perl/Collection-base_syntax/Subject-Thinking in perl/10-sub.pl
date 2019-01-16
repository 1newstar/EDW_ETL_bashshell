use strict;
use utf8;
binmode(STDIN,  ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');
#subroutime--含参

#列表上下文
sub Logger(@){
	my @line=@_;
	print join("\n",@line);
}
Logger('hello','world');

#字符上下文
sub Logger1($){
	(my $line1)=@_;
	print qq($line1\n);
}
Logger1("\nperl");

#多个参数
sub Logger2(@){
	(my $line2,my $line3)=@_;
	print qq($line2\t$line3\n);
}
Logger2("perl2","perl3");


