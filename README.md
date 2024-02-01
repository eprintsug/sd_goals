# sd_goals
UN Sustainable Development Goals plugin for EPrints

Add this to the workflow (with show_help configured to your preference):
```
<component show_help="always">
<field ref="sd_goals"/>
</component>
```
 
Choose which whether you want text links or icons for the summary pages.
For text you need:
```
<epc:foreach expr="sd_goals" iterator="goal">
<li><epc:phrase ref="sd_goals_description_{$goal.as_string()}" />  </li>
</epc:foreach>
```
For icons you need:
```
<epc:foreach expr="sd_goals" iterator="goal">
<li><epc:phrase ref="sd_goals_summary_{$goal.as_string()}" />  </li>
</epc:foreach>
```
