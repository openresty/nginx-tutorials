#!/usr/bin/env perl

use strict;
use warnings;
use encoding 'utf8';

my $infile = shift or
    die "No input file specified.\n";

open my $in, "<:encoding(UTF-8)", $infile
or
    die "cannot open $infile for reading: $!\n";

my $hanc = 0;
my $c = 0;

while (<$in>) {
    $hanc++ while /\p{Han}/g;
    $c += length($_);
}

close $in;

print "$hanc han chars found.\n";
print "$c chars found.\n";

