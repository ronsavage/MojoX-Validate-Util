#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use MojoX::Validate::Util;

# ------------------------------------------------

my($test_count)	= 0;
my($checker)	= MojoX::Validate::Util -> new;
my(@data)		=
(
	{},				# Fail.
	{x => undef},	# Fail.
	{x => ''},		# Pass.
	{x => '0'},		# Pass.
	{x => 0},		# Pass.
	{x => 'a'},		# Pass.
);

my($expected);
my($infix);
my($message);
my($params);

for my $i (0 .. $#data)
{
	$params		= $data[$i];
	$expected	= ($i == 0) ? 0 : 1;
	$infix		= $expected ? '' : 'not ';
	$message	= (defined($$params{x}) ? "'$$params{x}'" : 'undef') . " does ${infix}satisfy a key exists check";

	ok($checker -> check_key_exists($params, 'x') == $expected, $message); $test_count++;
}

@data =
(
	{x => '',	y => 'x'},		# Fail. Value can't be empty.
	{x => 'x',	y => 'x'},		# Pass.
	{x => 'pw',	y => 'wp'},		# Fail.
	{x => 99,	y => 99},		# Pass.
);

for my $i (0 .. $#data)
{
	$params		= $data[$i];
	$expected	= ( ($i == 0) || ($i == 2) ) ? 0 : 1;
	$infix		= $expected ? '' : 'not ';
	$message	= (defined($$params{x}) ? "'$$params{x}'" : 'undef') . " does ${infix}satisfy an equal_to check";

	ok($checker -> check_equal_to($params, 'x', 'y') == $expected, $message); $test_count++;
}

@data =
(
	{},				# Fail.
	{x => undef},	# Fail.
	{x => ''},		# Fail.
	{x => '0'},		# Pass.
	{x => 0},		# Pass.
	{x => 'x'},		# Pass.
);

for my $i (0 .. $#data)
{
	$params		= $data[$i];
	$expected	= ($i <= 2) ? 0 : 1;
	$infix		= $expected ? '' : 'not ';
	$message	= (defined($$params{x}) ? "'$$params{x}'" : 'undef') . " is ${infix}a required parameter";

	ok($checker -> check_required($params, 'x') == $expected, $message); $test_count++;
}

print "# Internal test count: $test_count\n";

done_testing($test_count);
