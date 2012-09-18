use 5.009000;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
              NAME              => 'Math::Permute::Array',
              VERSION_FROM      => 'lib/Math/Permute/Array.pm', # finds $VERSION
              PREREQ_PM         => {}, # e.g., Module::Name => 1.1
              MIN_PERL_VERSION => '5.6.1',
              ABSTRACT_FROM  => 'lib/Math/Permute/Array.pm', # retrieve abstract from module
               AUTHOR         => 'jean-noel quintin <jnquintin@local>',
  LICENSE           => 'perl',
  );
