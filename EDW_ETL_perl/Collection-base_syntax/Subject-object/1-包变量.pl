use strict;
use utf8;
binmode(STDIN,  ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

# 包变量:
# 	在包的内部使用,不需要加包名;
# 	在包的外部使用,需要加包名;
package main;
for($main::i=1;$main::i<10;$main::i++){

	$otherpackage::time=localtime();
	print "$main::i at $otherpackage::time\n";
}

package otherpackage;
print "last time was $otherpackage::time;\n";
print "last index was $main::i;\n";

# 词法变量
# 	只在代码的词法边界内部使用
package main2;
my $j;
for($j=1;$j<10;$j++){
	my $time2=localtime();
	print "$j at $time2\n";
}

