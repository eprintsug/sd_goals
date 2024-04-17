package EPrints::Plugin::Screen::Report::SD_Goals::All_Goals;

use EPrints::Plugin::Screen::Report;
our @ISA = ( 'EPrints::Plugin::Screen::Report::SD_Goals' );

use strict;

sub new
{
    my( $class, %params ) = @_;

    my $self = $class->SUPER::new( %params );

    $self->{datasetid} = 'eprint';
    $self->{custom_order} = '-title';
    $self->{report} = 'sd_all_goals';
    $self->{searchdatasetid} = 'eprint';
    $self->{show_compliance} = 0;

    $self->{labels} = {
        outputs => "EPrints"
    };

    $self->{sconf} = 'sd_all_goals';
    $self->{export_conf} = 'sd_all_goals';
    $self->{sort_conf} = 'sd_all_goals';
    $self->{group_conf} = 'sd_all_goals';

    return $self;
}

sub render
{
    my( $self ) = @_;

    my $repo = $self->repository;    
    my $chunk = $self->SUPER::render();

    $chunk->appendChild( $repo->make_javascript( <<JS ) );
Event.observe(window, 'load', function() {
    var checkboxes = document.querySelectorAll("input[type=checkbox][name=approve_sdgs]");
    checkboxes.forEach(function(checkbox) {
        checkbox.addEventListener('change', function() {
            // get eprintid from hidden sibling input element
            var div = this.parentNode;
            var input = div.querySelector("input[type=hidden]");

            // update the user record
            new Ajax.Request( '/cgi/sd_goals/approve_goals', {
                parameters: "eprintid="+input.value+"&checked="+this.checked,
                method: "POST",
                onSuccess: function() {
                    console.log( "flagged!" );
                }
            });
        });
    });
});
JS

    return $chunk;
}

sub items
{
    my( $self ) = @_;

    my $list = $self->SUPER::items();
    if( defined $list )
    {
        my @ids = ();

        $list->map(sub{
            my( $session, $dataset, $eprint ) = @_;

	    if( $eprint->is_set( "sd_goals" ) )
            {
                push @ids, $eprint->id;
            }
        });
        
        my $ds = $self->{session}->dataset( $self->{datasetid} );
        my $results = $ds->list(\@ids);
        return $results;
    }
    
    # we can't return an EPrints::List if {dataset} is not defined
    return undef;
}

sub ajax_eprint
{
    my( $self ) = @_;

    my $repo = $self->repository;

    my $json = { data => [] };
    $repo->dataset( "eprint" )
        ->list( [$repo->param( "eprint" )] )
        ->map(sub {
            (undef, undef, my $eprint) = @_;

            return if !defined $eprint; # odd

            my $frag = $eprint->render_citation_link;
            push @{$json->{data}}, {
                datasetid => $eprint->dataset->base_id,
                dataobjid => $eprint->id,
                summary => EPrints::XML::to_string( $frag ),
                #grouping => sprintf( "%s", $user->value( SOME_FIELD ) ),
                problems => [ $self->validate_dataobj( $eprint ) ],
		bullets => [ $self->bullet_points( $eprint ) ],
            };
        });
    print $self->to_json( $json );
}

sub validate_dataobj
{
        my( $self, $eprint ) = @_;

        my $repo = $self->{repository};

        my @problems;

        return @problems;
}


sub bullet_points
{
        my( $self, $eprint ) = @_;

        my $repo = $self->{repository};

        my @bullets;

        foreach my $sdg( @{ $eprint->value( "sd_goals" ) } )
        {
  	      push @bullets, $repo->make_text($sdg);
        }

	my $frag = $repo->xml->create_document_fragment();

        $frag->appendChild( $repo->html_phrase( "approve_sdgs" ) );

        my $div = $frag->appendChild( $repo->make_element( "div", class => "approve_sdgs" ) );

        $div->appendChild( $repo->render_hidden_field( "eprintid", $eprint->id ) );

        my $checkbox = $div->appendChild( $repo->make_element( "input",
            type => "checkbox",
            name => "approve_sdgs",
            value => "false"
        ) );
        push @bullets, EPrints::XML::to_string( $frag );


        return @bullets;
}
