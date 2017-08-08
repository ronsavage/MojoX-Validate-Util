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

# These topics are keys into the hashref within @data.

my(@topics)		= ('a', 'b', 'c', 'd', 'e', 'f');
my(@data)		=
(
	# This hashref deliberately does not contain the key 'a'.

	{b => undef, c => '', d => 0, e => 'e', f => 'x', x => 'x'},
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
		say "i: @{[$i + 1]}: topic: $topic. Using required(): ";

		if ($topic eq 'e')
		{
			say 'e == x:   ', $validation -> required($topic) -> equal_to('x') -> is_valid;
		}
		else
		{
			say 'required: ', $validation -> required($topic) -> is_valid;
		}

		say 'errors:   ', Dumper($validation -> error($topic) );
		say 'failed:   ', join(', ', @{$validation -> failed});
		say 'passed:   ', join(', ', @{$validation -> passed});
		say '-' x 15;
		say "i: @{[$i + 1]}: topic: $topic. Using optional(): ";

		if ($topic eq 'e')
		{
			say 'e == x:   ', $validation -> optional($topic) -> equal_to('x') -> is_valid;
		}
		else
		{
			say 'required: ', $validation -> optional($topic) -> is_valid;
		}

		say 'errors:   ', Dumper($validation -> error($topic) );
		say 'failed:   ', join(', ', @{$validation -> failed});
		say 'passed:   ', join(', ', @{$validation -> passed});

		say '-' x 30;
	}
}
