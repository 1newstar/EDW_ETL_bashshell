# perldsc - Perl Data Structures Cookbook
 for my $x (1 .. 10) {
        for my $y (1 .. 10) {
            for my $z (1 .. 10) {
                $AoA[$x][$y][$z] =
                    $x ** $y + $z;
            }
        }
    }

    $array[7][12]                       # array of arrays
    $array[7]{string}                   # array of hashes
    $hash{string}[7]                    # hash of arrays
    $hash{string}{'another string'}     # hash of hashes

    $AoA[$i] = [ @array ];     # usually best
    $AoA[$i] = \@array;        # perilous; just how my() was that array?
    @{ $AoA[$i] } = @array;    # way too tricky for most programmers


# an array to a scalar

    for my $i (1..10) {
        my @array = somefunc($i);
        $counts[$i] = scalar @array;
    }

    for my $i (1..10) {
        @array = somefunc($i);
        $AoA[$i] = [ @array ];
    }

   # Either without strict or having an outer-scope my @array;
    # declaration.
    for my $i (1..10) {
        @array = 0 .. $i;
        @{$AoA[$i]} = @array;
    }


    $aref->[2][2]       # clear
    $$aref[2][2]        # confusing


    # one element
 $AoA[0][0] = "Fred";
 # another element
 $AoA[1][1] =~ s/(\w)/\u$1/;
 # print the whole thing with refs
 for $aref ( @AoA ) {
     print "\t [ @$aref ],\n";
 }
 # print the whole thing with indices
 for $i ( 0 .. $#AoA ) {
     print "\t [ @{$AoA[$i]} ],\n";
 }
 # print the whole thing one at a time
 for $i ( 0 .. $#AoA ) {
     for $j ( 0 .. $#{ $AoA[$i] } ) {
         print "elt $i $j is $AoA[$i][$j]\n";
     }
 }

 