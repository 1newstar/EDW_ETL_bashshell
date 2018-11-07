use utf8;
	my @bar=(qq(#/usr/bin/perl -w;),
	qq(use utf8;),
	qq(#output;),
	qq(print hello;));
#大小
	# print scalar @bar,qq(\n);
	#function:清除该位置的元素,但是保留null值得位置
	# delete $bar[1];
	# print join("\n",@bar);
				# result:
								# #/usr/bin/perl -w;

								# #output;
								# print hello;

# exists :判断该元素是否已经删除 unless exists 除了..之外
	# my @array=(0,1,2,3,4,5,6);
	# delete $array[3];
	# print scalar @array,qq(\n);
	# print join(':',@array),"\n" unless exists $array[3];

#splice清楚该元素的位置.splice EXPR, OFFSET, LENGTH 两个参数,从哪个坐标,删几个
	# my @array2=(0,1,2,3,4,5,6);
	# print join(':',@array2),qq(\n);
	# splice(@array2, 3, 2);
	# print scalar @array2,qq(\n);
	# print join(':',@array2),qq(\n) unless exists $array2[6];

#chop每个元素去掉最后一个字符
#chomp去掉每个元素尾部的换行符
	my @bar2=(qq(#/usr/bin/perl -w;\n),
	qq(use utf8;\n),
	qq(#output;\n),
	qq(print hello;\n));
	#此场景下面效果一样的.
	#chomp @bar2;
	chop @bar2;
	print join(':',@bar2),qq(\n);

