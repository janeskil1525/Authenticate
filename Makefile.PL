use strict;
use warnings;

use ExtUtils::MakeMaker;
use File::ShareDir::Install qw{install_share};

install_share  'share';

WriteMakefile(
	NAME          => 'Authenticate',
	VERSION   => '0.2.0',
	PREREQ_PM => {'Mojolicious' => '8.09'},
	test      => {TESTS => 't/*.t'},
	EXE_FILES     => [ qw{
		script/authenticate
	} ],
);


package MY;
use File::ShareDir::Install qw(postamble);
