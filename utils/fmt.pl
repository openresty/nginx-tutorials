#!/usr/bin/env perl

use strict;
use warnings;
use encoding 'utf8';

my $infile = shift or
    die "No input file specified.\n";

open my $in, "<:encoding(UTF-8)", $infile
or
    die "cannot open $infile for reading: $!\n";

my $changes = 0;

my $res;
while (<$in>) {
    if (/^\s|^\s*$/) { # verbatim
        next;
    }

    my $orig = $_;
    s/.{39}.*?(?:[ \t”“，。！？]|\p{Han})/$&\n/gso;
    s/\s*\n\s*/\n/gms;
    $changes++ if $orig ne $_;

} continue {
    $res .= $_;
}

close $in;

warn "$changes changes\n";

if ($changes && $res) {
    open my $out, ">:encoding(UTF-8)", $infile or
        die "Cannot open $infile for writing: $!\n";
    print $out $res;
    close $out;
    warn "$infile wrote.\n";
}

