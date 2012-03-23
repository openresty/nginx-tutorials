#!/usr/bin/env perl

use strict;
use warnings;
use List::MoreUtils qw(first_index);

sub shell ($);

my @chapters = qw(
    Foreword
    NginxVariables
    NginxDirectiveExecOrder
);

my $suffix = ".tut";

chdir "zh-cn/" or die "cannot cd to zh-cn/\n";

my @files = glob "*$suffix";
for my $file (@files) {
    if ($file =~ /^ (?:(\d+)-)? (\w+?) (?: (\d+))? \Q$suffix\E $/x) {
        my ($old_serial, $chapter, $order) = ($1, $2, $3);

        my $serial = scalar first_index { $_ eq $chapter } @chapters;
        if ($serial < 0) {
            die "Bad chapter name: $chapter\n";
        }

        $serial = sprintf("%02d", $serial);
        warn "serial: $serial\n";

        if (defined $old_serial && $serial eq $old_serial) {
            warn "$file already ok\n";
            next;
        }

        my $new_file;
        if (defined $order) {
            $new_file = "$serial-$chapter$order$suffix";

        } else {
            $new_file = "$serial-$chapter$suffix";
        }

        shell "git mv $file $new_file";

    } else {
        die "unknown file $file\n";
    }
}

chdir "..";

sub shell ($) {
    my $cmd = shift;
    print "$cmd\n";
    system($cmd) == 0
        or die "Cannot run command: $cmd. Abort.";
}

