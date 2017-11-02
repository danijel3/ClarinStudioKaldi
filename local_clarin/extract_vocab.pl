#!/usr/bin/perl
# Copyright 2017 Jim O'Regan
# Apache 2.0

use warnings;
use strict;
use utf8;
use PerlIO::gzip;
use Getopt::Long;

my $order = 1;


open(IN, '<', $ARGV[0]);
binmode(IN, ":gzip(autopop)");

BEGIN{
	# SRI's ngram tool adds this
	print "-pau-\n";
}

my $reading = 0;
while(<IN>) {
	chomp;
	next if(/^$/);
	if(!$reading) {
		if(/^\\1-grams:$/) {
			$reading = 1;
		} else {
			next;
		}
	} else {
		if(/^\\[2-9]-grams:$/) {
			exit;
		} else {
			my @line = split/\t/;
			print $line[1] . "\n";
		}
	}
}
