#!/usr/bin/env perl

use strict;
use warnings;
use encoding 'utf8';

local $/;
my $src = <>;

$src =~ s{(<pre.*?)(>.*?<)(/pre>)}{$1.fmt($2).$3}ges;
$src =~ s!</p><p>!</p><br><p>&nbsp; &nbsp; !gs;
$src =~ s!^<p>!<p>&nbsp; &nbsp; !g;
$src =~ s!href="/!href="http://wiki.nginx.org/!g;
print $src;

sub fmt {
    my $a = shift;
    $a =~ s{>([^><]+)<}{
        my $n = $1;
        $n =~ s!\n+!<br/>!gs;
        $n =~ s! !\&nbsp;!gs;
        '>'. $n . '<'
    }gse;
    $a;
}

