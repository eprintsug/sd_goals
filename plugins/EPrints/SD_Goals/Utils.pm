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
    # and check sdgs haven't already been approved if there is an eprint 
    elsif( $eprint->value( 'sd_goals_checked', 'TRUE' ) )
    {
       $repo->log("SDGs already confirmed by staff for $eprint\n");
        return 0;
    }
    # array to store SDGs we find
    my @sdg_values;

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
		        push @sdg_values, substr($dir, rindex($dir, '/')+1);
                last; # we've found the SDG, no need to try other queries
	        }
        }
        closedir $sdg_dir;
    }

    # now we've done our searching, set the SDGs
    $eprint->set_value( "sd_goals", \@sdg_values );
    $eprint->commit;

    return 0;

}

1;

