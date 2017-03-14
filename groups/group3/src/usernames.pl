#!/usr/bin/perl

# Based on: http://hawkee.com/snippet/10215/
use warnings; use strict;
use LWP::Simple;

my $limit=1000;

my $fname = 'http://deron.meranda.us/data/popular-both-first.txt';
my $lname = 'http://deron.meranda.us/data/popular-last.txt';
my @lastn = split('\n', get($lname));
my @firstn = split('\n', get($fname));

my $count=0;
while ($count++ < $limit){
	my $indexF = int(rand(scalar @firstn));
	my $indexL = int(rand(scalar @lastn));
	print ucfirst(lc($firstn[$indexF]))  . "." . ucfirst(lc($lastn[$indexL])) . "\n";
}