package EPrints::SD_Goals::Utils;

use strict;

use Data::Dumper;

sub sdg_query
{
    my( $repo, $eprint ) = @_;

    # check we have an eprint
    if( !$eprint )
    {
      $repo->log("Eprint not found\n");
      return 0;
    }

    my $ds = $repo->get_repository->get_dataset( "eprint" );

    # get our SD Goal Xapian Queries
    # the first folder contains a folder for each SDG
    my $sdg_home_dir = $repo->config( "config_path" )."/sd_goals/";
    my @sdg_dirs = grep { -d } glob $sdg_home_dir."*";

    # loop through each SDG dir
    foreach my $dir ( @sdg_dirs )
    {
        # and get all of the queries in the dir
        opendir my $sdg_dir, $dir or die "Cannot open directory: $!";
        my @sdg_query_files = readdir $sdg_dir;

        foreach my $file ( @sdg_query_files )
        {
            # ignore things which aren't an SDG file
            next if( $file eq "." || $file eq ".." );
            my $query;
            open(my $fh, '<', $dir."/".$file) or die "cannot open file $file";
            {
                local $/;
                $query = <$fh>;
            }
            close($fh);

            # now run the query for this file
	        my $searchexp = $repo->plugin( "Search::Xapian",
                dataset => $ds,
                search_fields => [
                    { 
                        meta_fields => [
                            qw( eprintid title abstract keywords documents )],
                    },   
                ],
                q => 'eprint:'.$eprint->id. ' AND ' . $query
           
            );
            my $list = $searchexp->execute;
	        if( $list->count > 0 )
	        {
		        print STDERR "SUCCESS\n";
	        }
	        else 
	        {
		        print STDERR "failure :( \n";
	        }
        }
        closedir $sdg_dir;
    }


    return 0;

}

1;

