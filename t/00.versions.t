#/usr/bin/env perl

use strict;
use warnings;

# I tried 'require'-ing modules but that did not work.

use MojoX::Validate::Util; # For the version #.

use Test::More;


# ----------------------

pass('All external modules loaded');

my(@modules) = qw
/
/;

diag "TestingMojoX::Validate::Util V $MojoX::Validate::Util::VERSION";

for my $module (@modules)
{
	no strict 'refs';

	my($ver) = ${$module . '::VERSION'} || 'N/A';

	diag "Using $module V $ver";
}

done_testing;
