use ExtUtils::MakeMaker;
WriteMakefile
  (
   'NAME'		=> 'B::Flags',
   'VERSION_FROM'	=> 'Flags.pm',
   'AUTHOR'             => 'Simon Cozens <simon@cpan.org>, Reini Urban <rurban@cpan.org>',
   'ABSTRACT_FROM'      => 'Flags.pm',
   ($ExtUtils::MakeMaker::VERSION gt '6.46' ?
    ('META_MERGE'  =>
     {
      resources =>
      {
       license     => 'http://dev.perl.org/licenses/',
       repository  => 'http://github.com/rurban/b-flags',
      },
     }
    ) : ()),
  );

package MY;

sub depend { "README : Flags.pm\n\tpod2text Flags.pm > README\n"; }

