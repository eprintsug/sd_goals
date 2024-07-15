# To disaply the SDGs on your item pages, you can either add them to your summary_page.xml citation
# file, or uncomment the 'render_value' line below, and add 'sd_goals' to the list of EPrint fields
# in the eprint_render.pl configuration.

push @{$c->{fields}->{eprint}},
{
    name => 'sd_goals',
    type => 'namedset',
    set_name => 'sd_goals',
    multiple => 1,
#    render_value => 'sd_goals_render',
};

$c->{sd_goals_render} = sub {
    my( $session, $field, $value ) = @_;

    my $frag = $session->make_doc_fragment;
    return $frag if !defined $value;

    my $ul = $session->make_element( "ul", class => "sd_goals" );
    $frag->appendChild( $ul );

    foreach my $sdg ( @$value )
    {
        my $li = $session->make_element( "li" );
        $li->appendChild( $session->html_phrase( "sd_goals_summary_$sdg" ) ); #renders icon
        # $li->appendChild( $session->html_phrase( "sd_goals_description_$sdg" ) ); #would render text link
        $ul->appendChild( $li );
    }

    return $frag;
};


push @{$c->{browse_views}},
{
    id => "sd_goals",
    menus => [
        {
            fields => [ "sd_goals" ],
            allow_null => 0,
        },
    ],
    order => "creators_name/title",
    variations => [
        "date;truncate=4,reverse",
        "creators_name;first_letter",
        "type",
        "DEFAULT",
    ],
};
