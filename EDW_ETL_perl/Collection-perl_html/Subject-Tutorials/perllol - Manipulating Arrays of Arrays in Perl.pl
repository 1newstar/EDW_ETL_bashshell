# perllol - Manipulating Arrays of Arrays in Perl
use 5.010;  # so we can use say()
    # assign to our array, an array of array references
    @AoA = (
	   [ "fred", "barney", "pebbles", "bambam", "dino", ],
	   [ "george", "jane", "elroy", "judy", ],
	   [ "homer", "bart", "marge", "maggie", ],
    );
say $AoA[2][1];

    # assign a reference to array of array references
    $ref_to_AoA = [
	[ "fred", "barney", "pebbles", "bambam", "dino", ],
	[ "george", "jane", "elroy", "judy", ],
	[ "homer", "bart", "marge", "maggie", ],
    ];
say $ref_to_AoA->[2][1];


use strict;
my(@AoA, @tmp);

while (<>) {
	@tmp = split;
	push @AoA, [ @tmp ];
}

while (<>) {
	push @AoA, [ split ];
}


######################################################
my (@AoA, $i, $line);
for $i ( 0 .. 10 ) {
	$line = <>;
	$AoA[$i] = [ split " ", $line ];
}

my (@AoA, $i);
for $i ( 0 .. 10 ) {
$AoA[$i] = [ split " ", <> ];
}

