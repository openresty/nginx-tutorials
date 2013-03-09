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

my $res = <<_EOC_;
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zh">
    <head>
        <title>agentzh 的 Nginx 教程（版本 $ver）</title>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8">
        <script type="text/javascript">

          var _gaq = _gaq || [];
          _gaq.push(['_setAccount', 'UA-24724965-1']);
          _gaq.push(['_trackPageview']);

          (function() {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
          })();

        </script>
    </head>
    <body><h2>agentzh 的 Nginx 教程（版本 $ver）</h2>
    <h3>目录</h3>
_EOC_

$res .= "<ul>\n";
for my $infile (@ARGV) {
    (my $base = $infile) =~ s{.*/|\.html$}{}g;

    if ($infile =~ /Foreword(\d+)/) {
        my $n = $1;
        if ($n eq '01') {
        $res .= <<_EOC_;
    <li><a href="#$base">缘起</a></li>
_EOC_
        } elsif ($n eq '02') {
        $res .= <<_EOC_;
    <li><a href="#$base">Nginx 教程的连载计划</a></li>
_EOC_
        } else {
            die "unknown infile: $infile";
        }

    } elsif ($infile =~ /NginxVariables(\d+)/) {
        my $num = +$1;
        my $n = $nums[$num];
        #$infile =~ s{.*/}{}g;
        $res .= <<_EOC_;
    <li><a href="#$base">Nginx 变量漫谈（$n）</a></li>
_EOC_

    } elsif ($infile =~ /DirectiveExecOrder(\d+)/) {
        my $num = +$1;
        my $n = $nums[$num];
        #$infile =~ s{.*/}{}g;
        $res .= <<_EOC_;
    <li><a href="#$base">Nginx 配置指令的执行顺序（$n）</a></li>
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

