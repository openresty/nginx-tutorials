#!/usr/bin/env perl

use strict;
use warnings;
use encoding 'utf8';

local $/;
my $src = <>;

$src =~ s{(<pre.*?)(>.*?<)(/pre>)}{$1.fmt($2).$3}ges;
$src =~ s!</p><p>!</p><br><p>&nbsp; &nbsp; !gs;
$src =~ s!^\s*<p>!<p>&nbsp; &nbsp; !g;
$src =~ s!^\s*(\p{Han})!<p>&nbsp; &nbsp; $1!s;
$src =~ s!href="/!href="http://wiki.nginx.org/!g;
$src =~ s!unescape!\&\#117;nescape!gs;
print $src;

sub fmt {
    my $a = shift;
    $a =~ s{>([^><]+)<}{
        my $n = $1;
        $n =~ s!\n+!<br/>!gs;
        $n =~ s! !\&nbsp;!gs;
        $n =~ s!\%!<span>\%</span>!gs;
        '>'. $n . '<'
    }gse;
    $a;
}

