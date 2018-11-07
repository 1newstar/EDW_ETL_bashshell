use strict;
use utf8;
binmode(STDIN,  ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

#标量常量
	use constant PI=> 4 * atan2(1,1);
	print PI,qq(\n);

#列表常量
	use constant WEEKDAYS =>qw(
		Sunday Monday Tuesday Wednesday Thursday Friday Saturday
	);										#声明
											#qw(foo bar baz) 相当于 ('foo', 'bar', 'baz')
	print "Today is ",(WEEKDAYS)[2],".\n";	#使用必须加括号
#hash常量
	use constant WEEKABBR=>(
		'Monday'	=> 'Mon',
		'Tuesday'	=> 'Tue',
		'Wednesday' => 'Wed',
		'Thursday'  => 'Thur',
		'Friday'   => 'Fri');
	my %abbr = WEEKABBR;
	print $abbr{'Wednesday'},"\r";
