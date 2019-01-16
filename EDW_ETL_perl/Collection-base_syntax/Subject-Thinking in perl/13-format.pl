use strict;
use utf8;
binmode(STDIN,  ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

use IO::Handle;

 ########### Text Fields ###########
 # If the name is omitted, format "STDOUT" is defined. A single "." in column 1 is used to terminate a format. 
#.之前不能有空格,之后不能有注释
# 每一列以一个@开头
# < 左对齐。例如，如下是长度为 5 的左对齐列：
# @<<<<
# > 右对齐。例如
# @>>>>，如下是长度为5的右对齐列：
# | 居中对齐。例如，如下是长度为 5 的居中对齐列：
# @||||

# 第三行是数据

format STDOUT =
   @<<<<<<   @||||||   @>>>>>>
   "left","middle","right"
.
$~='STDOUT';
write;

#x写文件
# 	open(my $io,'>E:\GitHub\perl-for-EDW-ETL\base-syntax\tmp.txt');
# 	my $fh = IO::Handle->new();
# 	if ($fh->fdopen($io,"w")) {
#         $fh->print("Some text\n");
#     }

# $fh -> format_name('STDOUT');
# $fh -> format_write();
# $fh -> close;
###################### # Numeric Fields ##########################
 format MYOUT2 =
      @###   @.###   @##.###  @###   @####   @####
       42,   3.1415,  undef,    0, 1000,   undef
.
$~='MYOUT2';
write;

######################The Field ^* for Variable-Width One-line-at-a-time Text###############
my $text = "line 1\nline 2\nline 3";
format MYOUT =
Text: ^*
$text
~~    ^*
$text
.
$~='MYOUT';
write;
