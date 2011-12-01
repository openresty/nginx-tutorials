#!/usr/bin/env perl

use strict;
use warnings;
use encoding 'utf8';

my $infile = shift or
    die "No input file specified.\n";

open my $in, "<:encoding(UTF-8)", $infile
or
    die "cannot open $infile for reading: $!\n";

my $prev;
my $src = '';
while (<$in>) {
    if (/^\s+/ || /^\s*$/) {
        $src .= $_;
        next;
    }

    if ($prev && $prev =~ /^\s+|^\s*$/) {
        $src .= $_;
        next;
    }

    chop $src;

    if ($src =~ /(?:\p{Han}|[”“，；？。！…])$/s && /^(?:\p{Han}|[“”，；？。！…])/) {
        $src .= $_;

    } else {
        $src .= " $_";
    }

} continue {
    $prev = $_;
}

close $in;

open $in, '<', \$src;

my $wiki = '';
undef $prev;
my $orig;
my $in_geshi;
while (<$in>) {
    $orig = $_;
    if (/^\s+|^\s*$/) {
        if (/^\s+(.+)/) {
            my $first = $1;
            if (!$in_geshi && $prev && $prev =~ /^$|^\S/) {
                if ($first =~ /^:(\w+)$/) {
                    $in_geshi = 1;
                    $wiki .= qq{<geshi lang="$1">\n};
                    $_ = '';
                    next;
                }

                $in_geshi = 1;
                $wiki .= "<geshi>\n";
                #s/^ {1,4}//;
                next;
            }

            #s/^ {1,4}//;
        }

        next;
    }

    if ($in_geshi) {
        chomp $wiki;
        $wiki .= "</geshi>\n\n";
        undef $in_geshi;
    }

    s{[FC]<(.*?)>}{<code>$1</code>}g;
    s{L<ngx_(\w+)>}{
        my $n = $1;
        "[[Http" . ucfirst($n) . "Module|ngx_$n]]"
    }ge;

    s{L<ngx_(\w+)/(\w+)>}{
        my $n = $1;
        my $d = $2;
        "[[Http" . ucfirst($n) . "Module#$d|$d]]"
    }ge;

} continue {
    $prev = $orig;
    $wiki .= $_;
}

close $in;

$wiki =~ s///g;

print $wiki;

