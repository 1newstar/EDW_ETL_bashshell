  package MyMaths;
  use warnings;
  use strict;
  use myint();
  use overload '+' => sub {
      my ($l, $r) = @_;
# Pass 1 to check up one call level from here
      if (myint::in_effect(1)) {
          int($$l) + int($$r);
       } else {
           $$l + $$r;
       }
   };

   sub new {
       my ($class, $value) = @_;
       bless \$value, $class;
   }

   1;
