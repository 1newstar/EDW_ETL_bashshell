#模块是 Perl 中可重用代码的基本单元。它可以是一个相关例程的集合或一个类
use strict;
use utf8;
binmode(STDIN,  ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

##perl 的模块文件一般是以 pm 结尾（pm 是 Perl Module 的缩写）
##它有时候也叫做库文件,相当c的库文件,java的jar包
# 模块的导入
use Module;
# 相当于
BEGIN{
	require Module;
	Module->import;
};

use Module LIST;
# 等价于：
require Module;
BEGIN{
require Module;
import Module LIST;
}

#程序块
BEGIN 编译之前执行
CHECK INIT编译之后执行

