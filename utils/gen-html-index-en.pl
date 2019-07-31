#!/usr/bin/env perl

use v5.10.1;
use utf8;
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

my $res = <<_EOC_;
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
        <title>agentzh's Nginx Tutorials (version $ver)</title>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="tutorial.css"/>
        <script type="text/javascript">

          var _gaq = _gaq || [];
          _gaq.push(['_setAccount', 'UA-24724965-1']);
          _gaq.push(['_setDomainName', 'openresty.org']);
          _gaq.push(['_trackPageview']);

          var _gaf = (function() {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
          });
          setTimeout(_gaf, 0);

        </script>
    </head>
    <body><h1 class="page-title">agentzh's Nginx Tutorials (version $ver)</h1>
    <section class="toc">
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
$res .= "</section>\n";

$res .= "<section class=\"content\">\n";

for my $infile (@ARGV) {
    open my $in, "<:encoding(utf-8)", $infile
        or die "Cannot open $infile for reading: $!\n";
    $res .= "<article>\n";
    my $c = do { local $/; <$in> };
    $c =~ s/<(h[1-6]) id="([^"]+)">(.+?)<\/\1>/<$1 class="con-title" id="$2">$3 <a class="anchor" href="#$2">&#61532;<\/a><\/$1>/g;
    $res .= $c;
    $res .= "</article>\n";
    close $in;
}

$res .= "</section>\n";

$res .= <<_EOC_;
<script>
function init_back_top() {
    function _fn() {
        var t = Math.max(document.documentElement.scrollTop, document.body.scrollTop);
        if (t > 5) {
            if (! show) {
                show = true;
                r.className = 'backtop-box-show';
            }
        } else {
            if (show) {
                show = false;
                r.className = '';
            }
        }
    }

    var r = document.createElement('div');
    document.body.appendChild(r);
    r.innerHTML = '<div class="backtop-box"><b title="Jump to Top of Page">Top</b></div>';

    var show = false;
    r.onclick = function() {
        window.scrollTo(0, 0);
    };

    window.onscroll = _fn;
    window.onresize = _fn;
}

init_back_top();
</script>
_EOC_

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

