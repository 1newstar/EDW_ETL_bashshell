use strict;
use utf8;
binmode(STDIN,  ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

use Win32::OLE;
##system
	my $cmd_tree='tree /f';
	my $ret=system($cmd_tree);
	print qq(system返回值为:$ret\n);
	if($ret!=0){
		print "error during execute \'$cmd_tree\'\n extend_error=$^E\nnerrorno=$!\n ";
	}
	##$^E  $!

##反小点` 操作符qx,返回值是改命令的输出
	my $this_output=qx($cmd_tree);
	print ($this_output);

##Wscript.Shell
	my $WshShell=Win32::OLE->new("Wscript.Shell");
	$WshShell->RUN('msgbox.vbs');##msgbox "hello world!"

##