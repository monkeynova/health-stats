#!/usr/bin/env perl

use strict;
use warnings;
no autovivification;

use DateTime;
use Getopt::Long;
use JSON;
use LWP::Simple;

my $all;

GetOptions( 'all' => \$all ) or die;

my $fh;

my $username = "monkeynova";

my $user_url = "http://api.gymheroapp.com/usernames/$username";

my $user_json = get( $user_url );
open $fh, ">", "$username.json" or die;
print {$fh} JSON->new->pretty->encode( from_json( $user_json ) );
close $fh;

my $user_perl = from_json( $user_json );

foreach my $workout ( @{ $user_perl->{workouts} } )
{
    my ( $name, $workout_id, $start, $end, undef, undef, undef, undef, $exercises_aref ) = @$workout;
    my $ymd = DateTime->from_epoch( epoch => $start / 1000 )->ymd;
    my $fname = "$username.$ymd.$workout_id.json";
    next if -f $fname && ! $all;
    print "fetching $fname\n";
    my $workout_url = "http://api.gymheroapp.com/workouts/$workout_id";
    my $workout_json = get( $workout_url );
    open $fh, ">", $fname or die;
    print {$fh} JSON->new->pretty->encode( from_json( $workout_json ) );
    close $fh;
}
