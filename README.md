# sd_goals
UN Sustainable Development Goals plugin for EPrints

Add this to the workflow (with show_help configured to your preference): 
    <component show_help="always">
      <field ref="sd_goals"/>
    </component>

Choose which whether you want text links or icons for the summary pages.
For text you need
    sd_goals_description_{sd goal string}
For icons you need
    sd_goals_summary_{sd goal string}
