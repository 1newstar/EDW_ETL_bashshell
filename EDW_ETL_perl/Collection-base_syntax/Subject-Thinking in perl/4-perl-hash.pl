#Wide character in print
	use utf8;
	binmode(STDIN,  ':encoding(utf8)');
	binmode(STDOUT, ':encoding(utf8)');
	binmode(STDERR, ':encoding(utf8)');
	# use utf8::all;

# perl中的哈希表用来存储键值对,也叫关联数组.
#定义hash表方法1
	my %info_salery = (  
	"name" => "clark",  
	"part" => "BI",
	"salery" => 10000
	); 
	# print join(':',%info_salery);
#定义hash表方法2:
	$info_salery2{"name"}="clark";
	$info_salery2{"part"}="BI";
	$info_salery2{"salery"}=10000;
# keys ARRAY --返回键值的数组
	my @salery_keys=keys(%info_salery);
	# print join(':',@salery_keys),qq(\n);
# values ARRAY --返回值得数组
	my @salery_values=values(%info_salery);
	# print join(':',@salery_values),qq(\n);
# foreach--遍历哈希表
    foreach $salery_key (keys(%info_salery))
    {
    	print qq($salery_key : $info_salery{$salery_key}\t);
    }
    print qq(\n);
#each + while 
	while(($mykey,$myvalue)=each(%info_salery)){
		# print qq(| $mykey | $myvalue \n);
		printf "| %10s | %10s\n",$mykey,$myvalue;
	} 
#each + $_
    while (each %info_salery) {
	print "$_=$info_salery{$_}\t";
    }
    print qq(\n);
#delete exsits
	$delete_pop=delete $info_salery{'part'};
	print "delete part and its value, its value=",$delete_pop,"\n";
	print qq(存在"part"\n) if exists $info_salery{'part'};
	print qq(不存在"part"\n) if not exists $info_salery{'part'};

