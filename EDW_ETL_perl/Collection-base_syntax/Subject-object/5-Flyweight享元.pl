use strict;
use utf8;
binmode(STDIN,  ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

#########################################################
# Memoize - Make functions faster by trading space for time
# This is the documentation for Memoize 1.03
use Memoize;
memoize('slow_function');
slow_function(arguments);    # Is faster than it was before

# 'Memoizing' a function makes it faster by trading space for time. 
# It does this by caching the return values of the function in a table. 
# If you call the function again with the same arguments, memoize jumps in and 
# gives you the value out of the table, instead of letting the function compute the value all over again.

#########################################################
