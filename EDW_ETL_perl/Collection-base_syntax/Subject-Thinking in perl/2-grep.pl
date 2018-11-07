use utf8;
# my $bar=qq(#/usr/bin/perl -w;
# 	use utf8;
# #output
# 	print hello;);
# my $mygrep=grep(!/^#/,$bar);
# print qq($bar\n);
# print qq($mygrep);#0

my @bar=(qq(#/usr/bin/perl -w;\n),
qq(  use utf8;\n),
qq(#output\n),
qq(  print hello;\n));
my @mygrep=grep(!/^#/,@bar);
my @mygrep2=grep {!/^#/} @bar;
print qq(@bar);
print qq(-----------------\n);
print qq(@mygrep);
print qq(-----------------\n);
print qq(@mygrep2);
			# #/usr/bin/perl -w;
			#    use utf8;
			#  #output
			#    print hello;
			# -----------------
			#   use utf8;
			#    print hello;
