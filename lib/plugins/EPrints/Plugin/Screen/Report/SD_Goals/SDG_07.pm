package EPrints::Plugin::Screen::Report::SD_Goals::SDG_07;

use EPrints::Plugin::Screen::Report;
our @ISA = ( 'EPrints::Plugin::Screen::Report::SD_Goals' );

use strict;
use Data::Dumper;

sub new
{
    my( $class, %params ) = @_;

    my $self = $class->SUPER::new( %params );

    $self->{datasetid} = 'eprint';
    $self->{custom_order} = '-title';
    $self->{report} = 'sdg_07';
    $self->{searchdatasetid} = 'eprint';
    $self->{show_compliance} = 0;

    $self->{labels} = {
        outputs => "EPrints"
    };

    $self->{sconf} = 'sdg_07';
    $self->{export_conf} = 'sdg_report';
    $self->{sort_conf} = 'eprint_report';
    $self->{group_conf} = 'eprint_report';

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
sub filters
{
        my( $self ) = @_;

        my @filters = @{ $self->SUPER::filters || [] };
        push @filters, { meta_fields => [ 'sd_goals' ], value => '07ace', match => 'IN' };
        push @filters, { meta_fields => [ 'sd_goals_checked' ], value => 'FALSE', match => 'EX' };

        return \@filters;
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
        my( $self, $eprint, $session ) = @_;

        my $repo = $self->{repository};
        
        my $all_sdgs_frag = $repo->xml->create_document_fragment();
        my $icon_div = $all_sdgs_frag->appendChild( $repo->make_element( "div", class => "sdg_report" ) );

        my @bullets;

        foreach my $sdg( @{ $eprint->value( "sd_goals" ) } )
        {
            my $image_address = "/images/".$sdg.".png";
            my $alt_text = "sd_goals_alt_".$sdg;

            $icon_div->appendChild( $repo->make_element( "img", src=>$image_address, class=> "sdg_reports_icon", alt=>$repo->html_phrase( $alt_text ) ) );
        }

        push @bullets, EPrints::XML::to_string( $all_sdgs_frag );

        #create a button for approving all SDGs for this EPrint
        my $approve_sdgs_frag = $repo->xml->create_document_fragment();
        my $approve_sdgs_div = $approve_sdgs_frag->appendChild( $repo->make_element( "div", class => "approve_sdgs" ) );

        $approve_sdgs_div->appendChild( $repo->render_hidden_field( "eprintid", $eprint->id ) );
        
        my $all_sdgs_label = $approve_sdgs_div->appendChild( $repo->make_element( "label" ) );
        $all_sdgs_label->appendChild( $repo->html_phrase( "approve_sdgs" ) ); 
        my $all_sdgs_checkbox = $all_sdgs_label->appendChild( $repo->make_element( "input",
            type => "checkbox",
            name => "approve_sdgs",
            value => "false"
        ) );

        push @bullets, EPrints::XML::to_string( $approve_sdgs_frag );
        
        #And another for editing this eprint
    	my $sdg_frag = $repo->xml->create_document_fragment();

        my $eprintid = $eprint->get_value( "eprintid" );

        my $sdg_div = $sdg_frag->appendChild( $repo->make_element( "div", class => "approve_sdgs" ) );
        
        $sdg_div->appendChild( $repo->render_hidden_field( "eprintid", $eprint->id ) );
        
        my $sdg_edit_link = $sdg_div->appendChild( $repo->make_element( "a", href=>"/cgi/users/home?screen=EPrint%3A%3AEdit&eprintid=".$eprintid."&stage=core" ) );
        $sdg_edit_link->appendChild( $repo->html_phrase( "edit_sdg" ) );

        push @bullets, EPrints::XML::to_string( $sdg_frag );


        return @bullets;
}
