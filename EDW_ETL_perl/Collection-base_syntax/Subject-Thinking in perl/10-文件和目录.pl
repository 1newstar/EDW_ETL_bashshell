use strict;
use utf8;
binmode(STDIN,  ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');
##写
open(MYOUTFILE,'>E:\TmpStudy\wirte_1.txt');
print MYOUTFILE qq(name\tage\tjob\n);
print MYOUTFILE localtime(time()); 
print MYOUTFILE qq(\n);
print MYOUTFILE <<"MyLable";
clark	28	it
saber	27	test
MyLable
close(MYOUTFILE);

##读-单行
open(MYOUTFILE,'<E:\TmpStudy\wirte_1.txt');
while(<MYOUTFILE>)
{
	my($line)=$_;
	chomp($line);#去掉换行符
	$line=~tr/[a-z]/[A-Z]/;#转换大写
	print "$line*****";
}
print qq(\n);
close(MYOUTFILE);
##读-多行
open(MYOUTFILE,'<E:\TmpStudy\wirte_1.txt');
my @lines=<MYOUTFILE>;
@lines=sort(@lines);
foreach my $line (@lines){
	print $line;
}
print qq(\n);
close(MYOUTFILE);
##删除文件:
# rename('E:\TmpStudy\wirte_1.txt','E:\TmpStudy\wirte_2.txt'); #成功了
# unlink 'E:\TmpStudy\wirte_1.txt'; #成功了
# unlink('E:\TmpStudy\wirte_1.txt','E:\TmpStudy\wirte_2.txt','E:\TmpStudy\1.txt');
# mkdir('E:\TmpStudy\tmp',0777);
# rmdir('E:\TmpStudy\tmp');