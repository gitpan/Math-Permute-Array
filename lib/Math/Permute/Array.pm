package Math::Permute::Array;

use 5.009000;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Math::Permute::Array ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw()],
                     'Permute' => [ qw(Permute) ],
                     'Permute_func' => [ qw(Permute_func) ]
                   );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
 Permute
 Permute_func
);

our $VERSION = '0.02';


sub new
{
  my $class = shift;
  my $self = {};
  $self->{array}    = shift;
  $self->{iterator} = 0;
  $self->{cardinal} = undef;
  bless($self, $class);
  return $self;
}

#nice implementation from the cookbook
#but mine seems lightly more efficient
#sub N2Permute
#{
#  my $rank = shift;
#  my $size = shift;
#  my @res;
#
#  my $i=1;
#  while($i<=$size){
#    push @res, $rank % ($i);
#    $rank = int($rank / ($i));
#    $i++;
#  }
#  return @res;
#}

sub Permute
{
  my $rest = shift;
  my $array = shift;
  my @array = @{$array};
  my @res;

#  my $size = $#$array+1;
# my @perm = N2Permute($k,$size);
#push @res, splice(@array, (pop @perm), 1 )while @perm;

  my $i = 0;
  while($rest != 0){
    $res[$i] = splice @array, $rest % ($#array + 1), 1;
    $rest = int($rest / ($#array + 2));
    $i++;
  }
  push @res, @array;

  return \@res;
}

sub permutation
{
  my $self = shift;
  my $rest = shift;
  my @array = @{$self->{array}};
  my @res;
  my $i = 0;
  while($rest != 0){
    $res[$i] = splice @array, $rest % ($#array + 1), 1;
    $rest = int($rest / ($#array + 2));
    $i++;
  }
  push @res, @array;
  return \@res;
}

sub Permute_func(&@)
{
  my $func = shift;
  my $array = shift;
  my $rest;
  my $i;
  my $j;
  my @array = @{$array};
  my $size = $#array+1;
  my $card =factorial($size);
  my @res;
  for($j=0;$j<$card;$j++){
    @res = ();
    $rest = $j;
    $i = 0;
    while($rest != 0){
      $res[$i] = splice @array, $rest % ($#array + 1), 1;
      $rest = int($rest / ($#array + 2));
      $i++;
    }
    push @res, @array;
    &$func(@res);
    @array = @{$array};
  }
  return;
}

sub cur
{
  my $self = shift;
  return Math::Permute::Array::Permute($self->{iterator},$self->{array});
}

sub prev
{
  my $self = shift;
  return undef if($self->{iterator} <= 0);
  $self->{iterator}--;
  return Math::Permute::Array::Permute($self->{iterator},$self->{array});
}

sub next
{
  my $self = shift;
  return undef if($self->{iterator} == $self->cardinal());
  $self->{iterator}++;
  return Math::Permute::Array::Permute($self->{iterator},$self->{array});
}

sub cardinal
{
  my $self = shift;
  unless(defined $self->{cardinal}){
    my @array=@{$self->{array}};
    $self->{cardinal} = factorial($#array+1);
  }
  return $self->{cardinal};
}

#this part come from:
# www.theperlreview.com/SamplePages/ThePerlReview-v5i1.p23.pdf
# Author: Alberto Manuel Simões
sub factorial {
  my $v = shift;
  my $res = 1;
  while ($v > 1) {
    $res *= $v;
    $v--;
  }
  return $res;
}

1;

__END__

=head1 NAME

Math::Permute::Array - Perl extension for computing any permutation of an
array.
The permutation could be access by an index in [0,cardinal] or by
iterating with prev, cur and next.


=head1 SYNOPSIS

    use Math::Permute::Array;

    print "permutation with direct call to Permute\n";
    my $i;
    foreach $i (0..6){
      my @tmp = Math::Permute::Array::Permute($i,(1,2,3));
      print "@tmp\n";
    }

    print "permutation with counter\n";
    my $p = new Math::Permute::Array((1,2,3));
    my $i;
    foreach $i (0..$p->cardinal()){
      my @tmp = $p->permutation($i);
      print "@tmp\n";
    }

    print "permutation with next\n";
    my $p = new Math::Permute::Array((1,2,3));
    my $i;
      my @tmp = $p->cur();
      print "@tmp\n";
    foreach $i (1..$p->cardinal()){
      @tmp = $p->next();
      print "@tmp\n";
    }

the output should be:
    permutation with direct call to Permute
    1 2 3
    2 1 3
    3 1 2
    1 3 2
    2 3 1
    3 2 1
    1 2 3
    permutation with counter
    1 2 3
    2 1 3
    3 1 2
    1 3 2
    2 3 1
    3 2 1
    1 2 3
    permutation with next
    1 2 3
    2 1 3
    3 1 2
    1 3 2
    2 3 1
    3 2 1
    1 2 3


=head1 DESCRIPTION

This module compute the i^{th} permutation of an array recursively.
The main advantage of this module is the fact that you could access to
any permutation in the order that you want.
Moreover this module doesn't use a lot of memory because the permutation
is compute.
the cost for computing one permutation is O(n).

it could be optimize by doing this iteratively but it seems efficient.
Thus this module doesn't need a lot of memory because the permutation
isn't stored.

=head2 EXPORT

Permute [index, @array]
    Returns the index^{th} permutation for the array. This function
    should be called directly as in the exemple.

new [@array]
    Returns a permutor object for the given items.

next
    Called on a permutor, it returns an array contening the next permutation.

prev
    Called on a permutor, it returns an array contening the previous permutation.

cur
    Called on a permutor, it returns an array contening the current permutation.

permutation [index, @array]
    Called on a permutor, it returns the index^{th} permutation for the array.



=head1 SEE ALSO

=item L<Math::Permute::List>

=item L<Algorithm::Permute>

=item L<Algorithm::FastPermute>


=head1 AUTHOR

jean-noel quintin, E<lt>quintin_at___imag_dot___frE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by jean-noel quintin

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.4 or,
at your option, any later version of Perl 5 you may have available.


=cut
