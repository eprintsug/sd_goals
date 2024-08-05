#enable the various screens
$c->{plugins}{"Screen::SDGoals"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::All_Goals"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::SDG_01"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::SDG_02"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::SDG_03"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::SDG_04"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::SDG_05"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::SDG_06"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::SDG_07"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::SDG_08"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::SDG_09"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::SDG_10"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::SDG_11"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::SDG_12"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::SDG_13"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::SDG_14"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::SDG_15"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::SDG_16"}{params}{disable} = 0;
$c->{plugins}{"Screen::Report::SD_Goals::SDG_17"}{params}{disable} = 0;


#and some options for the reports with generic config as they'll all need the same stuff
$c->{search}->{sdg_report} = $c->{search}->{advanced}; 

$c->{sdg_report}->{exportfields} = {
    sdg_report_core => [ qw(
        eprintid
        sd_goals
        sdg_description
        sd_goals_checked
        title
        creators_name
        abstract
        date
        keywords
        divisions
        subjects
        type
        editors_name
        ispublished
        refereed
        publication
        documents.format
        datestamp
    )],
};

$c->{sdg_report}->{exportfield_defaults} = [ qw(
    eprintid
    sd_goals
    sdg_description
    sd_goals_checked
    title
    creators_name
    abstract
    date
    keywords
    divisions
    subjects
    type
    editors_name
    ispublished
    refereed
    publication
    documents.format
    datestamp
)];

#return the description of the SDG rather than the internal code for ease of use
$c->{sdg_report}->{custom_export} = {
    sdg_description => sub {

        my( $dataobj, $repo ) = @_;
        my @sd_goals;
        foreach my $sdg( @{ $dataobj->value( "sd_goals" ) } )
        {
            push @sd_goals, $repo->phrase( "sd_goals_typename_".$sdg );
        }
        return \@sd_goals;
    },
};


#allow admin users to look at our new screens
push @{ $c->{user_roles}->{admin} }, qw{ SDGoals };

#add a new field for the sd_goals and another for checked by admin
push @{$c->{fields}->{eprint}},
{
    name => 'sd_goals',
    type => 'namedset',
    set_name => 'sd_goals',
    multiple => 1,
},

{
    name => 'sd_goals_checked',
    type => 'boolean',
    input_style => 'checkbox'
};

#generate browse views for sd_goals only where checked by admin is true
push @{$c->{browse_views}},
{
    id => "sd_goals",
    menus => [
        {
            fields => [ "sd_goals" ],
            allow_null => 0,
        },
    ],
    filters    => [ { meta_fields => [qw( sd_goals_checked )], value => 'TRUE' }, ],
    order => "creators_name/title",
    variations => [
        "date;truncate=4,reverse",
        "creators_name;first_letter",
        "type",
        "DEFAULT",
    ],
};
