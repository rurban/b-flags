package B::Flags;

use B;

require 5.005_62;
use strict;
use warnings;

require DynaLoader;
our @ISA = qw(DynaLoader);

our $VERSION = '0.01';

bootstrap B::Flags $VERSION;

# Preloaded methods go here.

1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

B::Flags - Friendlier flags for B

=head1 SYNOPSIS

  use B::Flags;
  print B::main_root->flagspv;
  print B::main_root->privatepv;
  print $some_b_sv_object->flagspv;

=head1 DESCRIPTION

By default, C<$foo-E<gt>flags> when passed an object in the C<B> class
will produce a relatively meaningless number, which one would need to
grovel through the Perl source code in order to do anything useful with.
This module adds C<flagspv> to the SV and op classes and C<privatepv> to
the op classes, which makes them easier to understand.

B<Warning>: This module is not I<guaranteed> compatible with any version
of Perl below 5.7.0; however, I'd like to make it so compatible, so if
it fails to compile, mail me. There's probably an C<#ifdef> I need to
add somewhere...

=head1 AUTHOR

Simon Cozens, simon@cpan.org

=head1 SEE ALSO

perl(1).

=head1 LICENSE

AL&GPL.
Copyright 2001 Simon Cozens

=cut
