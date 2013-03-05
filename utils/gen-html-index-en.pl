#!/usr/bin/env perl

use encoding 'utf8';
use strict;
use warnings;

use Getopt::Std;

my %opts;
getopts('o:v:', \%opts) or usage();

my $outfile = $opts{o};
my $ver = $opts{v} or usage();

my @nums = qw(
   00 01 02 03 04 05 06 07 08 09
   10 11 12 13 14 15 16 17 18 19
   20
);

my @infiles = @ARGV;

my $res = <<_EOC_;
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
        <title>agentzh's Nginx Tutorials (version $ver)</title>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    </head>
    <body><h2>agentzh's Nginx Tutorials (version $ver)</h2>
    <h3>Table of Contents</h3>
_EOC_

$res .= "<ul>\n";
for my $infile (@ARGV) {
    (my $base = $infile) =~ s{.*/|\.html$}{}g;
    my $id = lc($base);

    if ($infile =~ /Foreword(\d+)/) {
        my $n = $1;
        if ($n eq '01') {
        $res .= <<_EOC_;
    <li><a href="#$id">Foreword</a></li>
_EOC_
        } elsif ($n eq '02') {
        $res .= <<_EOC_;
    <li><a href="#$id">Writing Plan for the Tutorials</a></li>
_EOC_
        } else {
            die "unknown infile: $infile";
        }

    } elsif ($infile =~ /NginxVariables(\d+)/) {
        my $num = +$1;
        my $n = $nums[$num];
        #$infile =~ s{.*/}{}g;
        $res .= <<_EOC_;
    <li><a href="#$id">Nginx Variables ($n)</a></li>
_EOC_

    } elsif ($infile =~ /DirectiveExecOrder(\d+)/) {
        my $num = +$1;
        my $n = $nums[$num];
        #$infile =~ s{.*/}{}g;
        $res .= <<_EOC_;
    <li><a href="#$id">Nginx Directive Execution Order ($n)</a></li>
_EOC_

    } else {
        die "Unknown file $infile";
    }
}

$res .= "</ul>\n";

for my $infile (@ARGV) {
    open my $in, $infile
        or die "Cannot open $infile for reading: $!\n";
    $res .= do { local $/; <$in> };
    close $in;
}

$res .= "</body></html>";

if ($outfile) {
    open my $out, ">:encoding(UTF-8)", $outfile
        or die "Cannot open $outfile for writing: $!\n";

    print $out $res;
    close $out;

} else {
    print $res;
}

sub usage {
    die "Usage: $0 -v <version> [-o <outfile>] <infile>\n";
}

