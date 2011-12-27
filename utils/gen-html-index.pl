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
   零 一 二 三 四 五 六 七 八 九
   十 十一 十二 十三 十四 十五 十六 十七 十八 十九
   二十
);

my @infiles = @ARGV;

my $res = <<_EOC_;
<html>
    <head>
        <title>agentzh 的 Nginx 教程（版本 $ver）</title>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    </head>
    <body><h2>agentzh 的 Nginx 教程（版本 $ver）</h2>
    <h3>目录</h3>
_EOC_

$res .= "<ul>\n";
for my $infile (@ARGV) {
    if ($infile =~ /Foreword/) {
        $res .= <<_EOC_;
    <li><a href="$infile">缘起</a></li>
_EOC_

    } elsif ($infile =~ /NginxVariables(\d+)/) {
        my $num = +$1;
        my $n = $nums[$num];
        #$infile =~ s{.*/}{}g;
        $res .= <<_EOC_;
    <li><a href="$infile">Nginx 变量漫谈（$n）</a></li>
_EOC_

    } elsif ($infile =~ /DirectiveExecOrder(\d+)/) {
        my $num = +$1;
        my $n = $nums[$num];
        #$infile =~ s{.*/}{}g;
        $res .= <<_EOC_;
    <li><a href="$infile">Nginx 配置指令的执行顺序（$n）</a></li>
_EOC_

    } else {
        die "Unknown file $infile";
    }
}

$res .= "</ul></body></html>";

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

