#!/usr/bin/env perl

use strict;
use warnings;
no autovivification;

use Data::Dumper qw( Dumper );
use JSON qw( decode_json );
use List::MoreUtils qw( uniq );
use Perl6::Slurp qw( slurp );

my $exercise = shift;

my @valid_exercises;
my $found;
my @sets;

foreach my $f ( glob( "*.*.json" ) )
{
    eval
    {
        my $json = slurp $f;
        my $perl = decode_json $json;

        foreach my $ex ( @{ $perl->{exercises} } )
        {
            if ( $exercise )
            {
                next unless $ex->{label} eq $exercise;
                $found = 1;
                push @sets, map { { %$_, date => $perl->{start_date} } } @{ $ex->{sets} };
            }
            else
            {
                push @valid_exercises, $ex->{label};
             }
        }

        1;
    }
    or print "Error reading/decoding $f: $@";
}

@valid_exercises = sort { $a cmp $b } uniq @valid_exercises;

if ( ! $exercise )
{
    print "Valid exercises: ", join( ", ", @valid_exercises ), "\n";
    exit;
}

die "Could not find $exercise" if ! $found;

my $now = time;
foreach my $set ( @sets )
{
    print join( "\t", int( ($now - ($set->{date}/1000)) / 86400 ), $set->{weight}, $set->{reps} ), "\n"
}
