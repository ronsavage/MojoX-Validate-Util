#!/usr/bin/env perl

use 5.018;
use warnings;
use strict;

use Mojolicious;
use Mojolicious::Validator;
use Mojolicious::Validator::Validation;

# ------------------------------------------------

sub hashref2string
{
	my($hashref) = @_;
	$hashref ||= {};

	return '{' . join(', ', map{defined($$hashref{$_}) ? qq|$_ => "$$hashref{$_}"| : "$_ => undef"} sort keys %$hashref) . '}';

} # End of hashref2string.

# ------------------------------------------------

say "Mojolicious::VERSION: $Mojolicious::VERSION";

# These topics are keys into the hashref within @data.

my(@topics)		= ('a', 'b', 'c', 'd', 'e', 'f');
my(@data)		=
(
	# This hashref deliberately does not contain the key 'a'.

	{b => undef, c => '', d => 0, e => 'e', f => 'x', x => 'x'},
);

my($errors);
my($output);
my($params);
my($validator, $validation);

for my $i (0 .. $#data)
{
	$params = $data[$i];

	say 'params:   ', hashref2string($params);

	for my $topic (@topics)
	{
		for my $kind (qw/required optional/)
		{
			$validator	= Mojolicious::Validator -> new;
			$validation	= Mojolicious::Validator::Validation->new(validator => $validator);

			$validation -> input($params); # Not a required call with MojoX::Validate::Util.

			say "i: @{[$i + 1]}: topic: $topic. Using $kind(): ";

			if ($topic =~ /[ef]/)
			{
				say "$topic == x:    ", $validation -> $kind($topic) -> equal_to('x') -> is_valid;
			}
			else
			{
				say 'required:  ', $validation -> $kind($topic) -> is_valid;
			}

			$errors	= $validation -> error($topic);
			$errors	= defined($errors) ? join(', ', @$errors) : '';
			$output	= $validation -> output;
			$output	= defined($output) ? hashref2string($output) : '';

			say 'has_error: ', defined($validation -> has_error) ? 1 : 0;
			say "errors:    $errors";
			say "output:    $output";
			say 'failed:    ', join(', ', @{$validation -> failed});
			say 'passed:    ', join(', ', @{$validation -> passed});
			say '-' x 15;
		}
	}
}

