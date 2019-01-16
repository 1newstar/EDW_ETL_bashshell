use strict;
use utf8;
binmode(STDIN,  ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');
# use Switch;

print "if statement sample,result is \t";
if (1>2) {
	print q(1>2);
}
elsif (1==2) {
	print q(1=2);
}
else 
{
	print q(1<2);
}
print qq(\t end of the if statement\n);

unless (1>2) {
	# body...
	print "总是..除了 (1>2) 之外\n";
}
# AND LATER...
# %special = ( woohoo => 1,  oh => 1 );
# while (<>) {
#     switch ($_) {
#         case (%special) { print "homer\n"; }      # if $special{$_}
#         case /a-z/i     { print "alpha\n"; }      # if $_ =~ /a-z/i
#         case [1..9]     { print "small num\n"; }  # if $_ in [1..9]
#         case { $_[0] >= 10 } {                    # if $_ >= 10
#             my $age = <>;
#             switch (sub{ $_[0] < $age } ) {
#                 case 20  { print "teens\n"; }     # if 20 < $age
#                 case 30  { print "twenties\n"; }  # if 30 < $age
#                 else     { print "history\n"; }
#             }
#         }
#         print "must be punctuation\n" case /\W/;  # if $_ ~= /\W/
# }
#### if unless
####while until
for my $i (1..5){
	print qq($i\t);
}
my $j=1;
for($j=1;$j<=5;$j++){
	print qq($j\t);
}
print qq(\n);
###for each
	# foreach $salery_key (keys(%info_salery))
	#    {
	#    	print qq($salery_key : $info_salery{$salery_key}\t);
	#    }

my @list=1..5;
my $sum=0;
foreach my $item (@list){
	$sum+=$item;
}
print qq(sum=$sum\n);

##跳出循环:last类似break
##调到当前循环末尾,进行下一次循环next 类似continue
		# last if($i==5);
		# next unless ($i%2);
