#!/usr/bin/env perl

use strict;
use warnings;
use encoding 'utf8';

if (!@ARGV) {
    die "No input file specified.\n";
}

my $hanc = 0;
my $wc = 0;
my $c = 0;
my $lc = 0;

for my $infile (@ARGV) {
    open my $in, "<:encoding(UTF-8)", $infile
    or
        die "cannot open $infile for reading: $!\n";

    while (<$in>) {
        $lc++;
        $hanc++ while /\p{Han}/g;
        while (1) {
            if (/\G\s+/gc) {
                next;
            } elsif (/\G(?:\p{Han}|[”“，；：？。！…]|[,;.])/gc) {
                $wc++;
                next;

            } elsif (/\G[A-Za-z0-9_]+/gc) {
                $wc++;
                next;
            } elsif (/\G./gc) {
                next;
            }

            last;
        }

        $c += length($_);
    }

    close $in;
}

my $rough_wc = int($wc * 1.2);

print "$hanc han chars found.\n";
print "$wc words found.\n";
print "$rough_wc rough words found.\n";
print "$lc lines found.\n";
print "$c chars found.\n";

