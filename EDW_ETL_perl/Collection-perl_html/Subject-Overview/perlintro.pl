# Whitespace is irrelevant:
print
     "Hello, world"
     ;
# except inside quoted strings:
 # this would print with a linebreak in the middle
 print "Hello
  world";
# Double quotes or single quotes may be used around literal strings:
 print "Hello, world";
 print 'Hello, world';
 # However, only double quotes "interpolate" variables and special characters such as newlines (\n ):
 my $name='Clark';
 print "Hello, $name\n";     # works fine
 print 'Hello, $name\n';     # prints $name\n literally
 # You can use parentheses for functions' arguments or omit them according to your personal taste.
 print("Hello, world\n");
 print "Hello, world\n";

 # Perl variable types
# Perl has three main variable types: scalars, arrays, and hashes.
#标量
# Scalar values can be strings, integers or floating point numbers, and Perl will automatically convert between them as required
# my keyword the first time you use them. (This is one of the requirements of use strict;
