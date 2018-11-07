#!/usr/bin/perl -w
###check the user has supplied an argument for
###1) the name fo the file containing the data
###2) the name of the site to search for

die "Usage:scanmegadata <datafile> <site name> \n"
unless @ARGV ==2

my $datafile 	= $ARGV[0];
my $sitename			= $ARGV[1];

###< 读取模式
###> 写入模式
###>> 追加
open(MEGADATA,"<$megalithfile")
	or die "can't open $megalithfile";

