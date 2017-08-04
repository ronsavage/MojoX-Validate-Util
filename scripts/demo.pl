#!/usr/bin/env perl

use 5.018;
use warnings;
use strict;

use Data::Dumper::Concise; # For Dumper().

use Mojolicious;
use Mojolicious::Validator;
use Mojolicious::Validator::Validation;

# -------------------------------------

say "Mojolicious::VERSION: $Mojolicious::VERSION";

my(@topics)		= ('a', 'b', 'c', 'd');
my(@data)		=
(
	{},
	{a => undef, b => '', c => 0, d => 'x', x => 'x'},
);

my($params);
my($validator, $validation);

for my $i (0 .. $#data)
{
	$params		= $data[$i];
	$validator	= Mojolicious::Validator -> new;
	$validation	= Mojolicious::Validator::Validation->new(validator => $validator);

	$validation -> input($params);

	say 'params:   ', Dumper($params);

	for my $topic (@topics)
	{
		# When $params = {}, just test 'a'.

		next if ( ($i == 0) && ($topic ne 'a') );

		say "i: @{[$i + 1]}: topic: $topic. Using required(): ";
		say 'required: ', $validation -> required($topic) -> is_valid;
		say 'errors:   ', Dumper($validation -> error($topic) );
		say 'failed:   ', join(', ', @{$validation -> failed});
		say 'passed:   ', join(', ', @{$validation -> passed});
#		say 'x == x:   ', $validation -> required($topic) -> equal_to('x') -> is_valid;
		say '-' x 15;
		say "i: @{[$i + 1]}: topic: $topic. Using optional(): ";
		say 'optional: ', $validation -> optional($topic) -> is_valid;
		say 'errors:   ', Dumper($validation -> error($topic) );
		say 'failed:   ', join(', ', @{$validation -> failed});
		say 'passed:   ', join(', ', @{$validation -> passed});
#		say 'x == x:   ', $validation -> optional($topic) -> equal_to('x') -> is_valid;

		say '-' x 30;
	}
}

