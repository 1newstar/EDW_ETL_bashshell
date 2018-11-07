use strict;
use utf8;
binmode(STDIN,  ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');
############################################################################################
# 一个makefile 由一系列变量定义和依赖规则组成
# 变量定义
# 	# CC 			C 编译器的名称。在多数 unix 的 make 版本，缺省是 cc 或 gcc，windows 中是 cl
# 	# CFLAGS		一个传给 C 编译器的选项列表。通常用来设置包含路径(-I) 或构建调试版本 (-g)。
# 	# LDFLAGS		传给 linker 选项列表。通常用来包含应用相关的库文件(-l) 和设置库搜索路径(-L)
# 依赖规则
# 	一个规则通常由两类行组成：一个依赖行，接着是一条或多条命令行
# 	binky.o : binky.c binky.h akbar.h
##############################################################################################
# Makefile.PL是为整个项目生成makefile的脚本;
# ExtUtils::MakeMaker 库中的 WriteMakefile 函数实现的
perl Makefile.PL
make
make test;
make install;
# 先卸载重新安装
make install UNINST=1

要生成的 Makefile 可以通过在命令行增加参数，以 KEY=VALUE 的形式。例如：
perl Makefile.PL PREFIX=/tmp/myperl5

make config # 检查 Makefile 是否是最新的
make clean # 删除本地临时文件
make ci # 检查在MANIFEST文件中的所有文件

##############################################################################################
# CPAN安装
# CPAN.pm模块来安装
perl -MCPAN -e "install SQL::Translator"

