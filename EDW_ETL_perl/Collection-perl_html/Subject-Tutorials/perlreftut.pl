# perlreftut - Mark's very short tutorial about references


# 一.Making References
# 1.Make Rule 1
    $aref = \@array;         # $aref now holds a reference to @array
    $href = \%hash;          # $href now holds a reference to %hash
    $sref = \$scalar;        # $sref now holds a reference to $scalar
    
    $xy = $aref;             # $xy now holds a reference to @array
    $p[3] = $href;           # $p[3] now holds a reference to %hash
    $z = $p[3];              # $z now holds a reference to %hash

#2.Make Rule 2
    $aref = [ 1, "foo", undef, 13 ];
    # $aref now holds a reference to an array
    $href = { APR => 4, AUG => 8 };
    # $href now holds a reference to a hash

	# This:
	$aref = [ 1, 2, 3 ];
	# Does the same as this:
	@array = (1, 2, 3);
	$aref = \@array;

#二.Using References
# Use Rule 1
	@a				@{$aref}				An array
	reverse @a		reverse @{$aref}		Reverse the array
	$a[3]			${$aref}[3]				An element of the array
	$a[3] = 17;		${$aref}[3] = 17		Assigning an element

	%h				%{$href}	      		A hash
	keys %h			keys %{$href}	      	Get the keys from the hash
	$h{'red'}		${$href}{'red'}	      	An element of the hash
	$h{'red'} = 17	${$href}{'red'} = 17  	Assigning an element

#Use Rule 2
	${$aref}[3] 	 	$aref->[3] instead.
	${$href}{red}  		$href->{red} instead.

# 三.例子:二维数组
#$a[ROW]->[COLUMN],@a
@a = ( [1, 2, 3],
       [4, 5, 6],
	   [7, 8, 9]
      );

@a is an array with three elements, and each one is a reference to another array.
$a[1] is one of these references. It refers to an array, the array containing (4, 5, 6) ,
Use Rule 2 says that we can write $a[1]->[2] to get the third element from that array. $a[1]->[2] is the 6. 
you can write $a[ROW]->[COLUMN] to get or set the element in any row and any column of the array.

#数组引用
Instead of $a[1]->[2] , we can write $a[1][2] ; 
it means the same thing. Instead of $a[0]->[1] = 23 , we can write $a[0][1] = 23 ; it means the same thing.

# ${$a[1]}[2] instead of $a[1][2]
# $x[2][3][5] instead of the unreadable ${${$x[2]}[3]}[5] .

