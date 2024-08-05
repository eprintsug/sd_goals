#!/usr/bin/perl -w

use FindBin;
use lib "$FindBin::Bin/../../../perl_lib";
use EPrints;
use Search::Xapian qw/:standard/;
use strict;

use EPrints::SD_Goals::Utils;

my $repoid = $ARGV[0];
my $session = new EPrints::Session( 1, $repoid );
if( !defined $session )
{
    print STDERR "Failed to load repository: $repoid\n";
    exit 1;
};


my $ds = $session->get_repository->get_dataset( "eprint" );

#get a list of all the eprints in the user workarea/live archive or under review
my $search_exp = EPrints::Search->new(
	session => $session,
	satisfy_all => 0,
	dataset => $ds,
	);

	$search_exp->add_field(
		fields => [ $ds->field( 'eprint_status' ) ], 
		value => "inbox buffer archive",
		match => "EQ",
	);

my $list = $search_exp->perform_search;

#run our Utils sdg search script over that list
$list->map( sub
	{
		my( $session, $dataset, $eprint ) = @_;
        #and print a list of the eprints we're looping over so we can follow the process
		my $eprintid = $eprint->get_value( "eprintid" );
		print STDERR "eprintid = $eprintid\n";
			EPrints::SD_Goals::Utils::sdg_query( $session, $eprint );
	}
)
