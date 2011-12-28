#!/usr/bin/env perl

use strict;
use warnings;
use encoding 'utf8';

use Getopt::Std;
my %opts;
getopts('o:', \%opts) or usage();

my $outfile = $opts{o};

my %links = (
    order =>  {
        '一' => 'http://blog.sina.com.cn/s/blog_6d579ff40100xm7t.html',
    },
    var => {
        '一' => 'http://blog.sina.com.cn/s/blog_6d579ff40100wi7p.html',
        '二' => 'http://blog.sina.com.cn/s/blog_6d579ff40100wk2j.html',
        '三' => 'http://blog.sina.com.cn/s/blog_6d579ff40100wm63.html',
        '四' => 'http://blog.sina.com.cn/s/blog_6d579ff40100woyb.html',
        '五' => 'http://blog.sina.com.cn/s/blog_6d579ff40100wqn7.html',
        '六' => 'http://blog.sina.com.cn/s/blog_6d579ff40100wsip.html',
        '七' => 'http://blog.sina.com.cn/s/blog_6d579ff40100wu5t.html',
        '八' => 'http://blog.sina.com.cn/s/blog_6d579ff40100wvxn.html',
    },
);

my $infile = shift or
    usage();

open my $in, "<:encoding(UTF-8)", $infile
    or die "cannot open $infile for reading: $!\n";

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

    if ($src =~ /(?:\p{Han}|[”“）（，；：？。！…])$/s
        && /^(?:\p{Han}|[“”）（，；：？。！…])/)
    {
        $src .= $_;

    } else {
        $src .= " $_";
    }

} continue {
    $prev = $_;
}

close $in;

open $in, "<:encoding(UTF-8)", \$src;

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

    s{\bL<(\w+)tut/([^>（）]*?（([^>]+?)）)>}{
        my $tag = $1;
        my $n = $2;
        my $key = $3;
        my $link = $&;
        my $map = $links{$tag} or die "Tag $tag not found in links table";
        my $url = $map->{$key};
        #warn "URL: $url";
        if (!defined $url) {
            die "Bad link $link\n";
        }
        "[$url $n]"
    }ge;

    s{\bL<(ngx_devel_kit)>}{[https://github.com/simpl/ngx_devel_kit $1]}g;

    s{\bL<ngx_(\w+)>}{
        my $n = $1;
        if ($n eq 'http_core') {
            "[http://nginx.org/en/docs/http/ngx_http_core_module.html ngx_$n]"

        } elsif ($n eq 'auth_request') {
            "[http://mdounin.ru/hg/ngx_http_auth_request_module/ ngx_$n]"

        } else {
            my @n;
            if ($n eq 'srcache') {
                @n = 'SRCache';
            } else {
                @n = map \{ ucfirst \} split /_/, $n;
            }
            "[[Http" . join("", @n) . "Module|ngx_$n]]"
        }
    }ge;

    s{\bL<error_log>}{[[CoreModule#error_log|error_log]]}g;

    s{\bL<(Nginx 变量漫谈系列)>}{[http://blog.sina.com.cn/s/articlelist_1834459124_1_1.html $1]}g;

    s{\bL<(Nginx 配置指令的执行顺序系列)>}{[http://blog.sina.com.cn/s/articlelist_1834459124_2_1.html $1]}g;

    s{\bL<ngx_(\w+)/(\S+)>}{
        my $n = $1;
        my $d = $2;

        if ($n eq 'auth_request') {
            "<code>$d</code>"

        } else {
            my @n = map \{ ucfirst \} split /_/, $n;
            "[[Http" . join("", @n) . "Module#$d|$d]]"
        }
    }ge;

    s{\bL<(\$arg_XXX)>}{[[HttpCoreModule\#\$arg_PARAMETER|$1]]}g;
    s{\bL<(\$cookie_XXX)>}{[[HttpCoreModule\#\$cookie_COOKIE|$1]]}g;
    s{\bL<(\$http_XXX)>}{[[HttpCoreModule\#\$http_HEADER|$1]]}g;
    s{\bL<(\$sent_http_XXX)>}{[[HttpCoreModule\#\$sent_http_HEADER|$1]]}g;

    s{\bL<([^\|>]+)\|([^\|>]+)>}{[$2 $1]}g;

    s{\bL<(http[^\|\>\s]+)>}{[$1 $1]}g;

    s{\b[FC]<(.*?)>}{<code>$1</code>}g;

} continue {
    $prev = $orig;
    $wiki .= $_;
}

close $in;

if ($wiki =~ /\bL<.*?>/) {
    die "Found unresolved link $&\n";
}

$wiki =~ s/^\s+|\s+$//sg;

if ($outfile) {
    open my $out, ">:encoding(UTF-8)", $outfile
        or die "Cannot open $outfile for writing: $!\n";

    print $out $wiki;

    close $out;

} else {
    print $wiki;
}

#warn "wrote $outfile.\n";

sub usage {
    die "Usage: $0 [-o <outfile>] <infile>\n";
}

