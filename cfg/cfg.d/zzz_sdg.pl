push @{$c->{fields}->{eprint}},
{
    name => 'sd_goals',
    type => 'namedset',
    set_name => 'sd_goals',
    multiple => 1,
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
