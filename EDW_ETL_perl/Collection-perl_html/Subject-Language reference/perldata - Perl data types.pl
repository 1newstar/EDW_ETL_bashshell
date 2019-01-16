perldata - Perl data types

Perl has three built-in data types: scalars, arrays of scalars, and associative arrays of scalars, known as "hashes"

Scalar values are always named with '$', even when referring to a scalar that is part of an array or a hash. The '$' symbol works semantically like the English word "the" in that it indicates a single value is expected.

    $days		# the simple scalar value "days"
    $days[28]		# the 29th element of array @days
    $days{'Feb'}	# the 'Feb' value from hash %days
    $#days		# the last index of array @days

Entire arrays (and slices of arrays and hashes) are denoted by '@', which works much as the word "these" or "those" does in English, in that it indicates multiple values are expected.

    @days		# ($days[0], $days[1],... $days[n])
    @days[3,4,5]	# same as ($days[3],$days[4],$days[5])
    @days{'a','c'}	# same as ($days{'a'},$days{'c'})

In addition, subroutines are named with an initial '&', though this is optional when unambiguous, just as the word "do" is often redundant in English.

There are two package separators in Perl: A double colon (:: ) and a single quote.That is, $'foo and $foo'bar are legal

一.标量
    if ($str == 0 && $str ne "0")  {
	warn "That doesn't look like a number";
    }

The length of an array is a scalar value.You may find the length of array @days by evaluating $#days 
	@whatever = ();
    $#whatever = -1;
 	$temp = join($", @ARGV);

 assigns the value of variable $bar to the scalar variable $foo. Note that the value of an actual array in scalar context is the length of the array; the following assigns the value 3 to $foo:

 	$foo = ('cc', '-E', $bar);
    @foo = ('cc', '-E', $bar);
    $foo = @foo;                # $foo gets 3