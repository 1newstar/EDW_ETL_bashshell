use utf8;
binmode(STDIN,  ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

#创建数组
	$mul_dim_array=[[1,2,3],[4,5,6],[7,8,9]];
#使用数组
$sum = int($mul_dim_array->[0][0]) + int($mul_dim_array->[2][2]) + int($mul_dim_array->[1][1]);
print $sum,qq(\n);
