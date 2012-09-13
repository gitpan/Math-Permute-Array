# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Math::Permute::Array.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More tests => 1;
BEGIN { use_ok('Math::Permute::Array') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $i;
my @array = (1,2,3,4,5,6,7,8);

print "permutation with counter\n";
my $p = new Math::Permute::Array(\@array);
foreach $i (0..$p->cardinal()-1){
  my @tmp = @{$p->permutation($i)};
#  print "@tmp\n";
}
