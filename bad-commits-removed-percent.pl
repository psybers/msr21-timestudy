#!/usr/bin/perl

use strict;
use warnings;

my %years;
my $cumulative_commits = 0;
my $year_min = 2020;

open(my $inputfile, "<", "bad-commits-by-year.txt") || die;

foreach my $line(<$inputfile>) {
    chomp($line);
    $line =~ s/^\s+//;
    my ($commits, $year) = split / /, $line;
    $years{$year} = $commits;
    $cumulative_commits += $commits;
    if ($year < $year_min) {
        $year_min = $year;
    }
}

print "Year\tPercent Removed\n";

for (my $year = 2020; $year >= $year_min; $year--) {
    my $commits_removed = 0;
    for (my $other_year = $year; $other_year >= $year_min; $other_year--) {
        if (exists $years{$other_year}) {
            $commits_removed += $years{$other_year};
        }
    }
    my $commits_removed_percent = ($commits_removed / $cumulative_commits) * 100;
    printf "\$\\leq %s\$ & %1.2f\\%%\n", $year, $commits_removed_percent;
}

