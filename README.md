# sd_goals
UN Sustainable Development Goals plugin for EPrints

## Examples
To see the Sustainable Development Goals in action head to:
* [White Rose Research Online (browse view)](https://eprints.whiterose.ac.uk/view/sd_goals/)
* [London Business School (cgi screen)](https://lbsresearch.london.edu/cgi/sd_goals/)

## Installing

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

## Integration with Symplectic Elements

Symplectic Elements supports the UN SDGs using a 'label scheme'.

Values applied to a publication that is sent to the repository via RT2 can populate the EPrint fields that this extension adds.

The following three aspects need to be added to the deposit crosswalk:

1) A field mapping. This could be added to a 'standard map' so it applies to all item types.
```xml
<!-- Maps ELements labels into fields supported by the 'SD Goals' extension. See: https://github.com/eprintsug/sd_goals/ -->
<xwalk:field-mapping to="sd_goals" is-list="true" distinct="true">
  <xwalk:field-source from="object.labels" format="keyword:with-scheme" value-map="sdg-labels-only">
    <xwalk:field-source from="keyword:value" value-map="translate-sdg-to-sd_goals" />
  </xwalk:field-source>
</xwalk:field-mapping>
```
1) A filter to allow selection of only the SDG labels, added to the `<xwalk:value-maps>` section of the deposit crosswalk.
```xml
<!-- filter labels for only SDG -->
<xwalk:value-map name="sdg-labels-only" data-part="keyword:scheme">
  <xwalk:value-mapping from="sdg" action="continue" />
  <xwalk:otherwise-mapping action="ignore-this-value" />
</xwalk:value-map>
```
1) A value translation for the Elements label values to the EPrints namedset values. This is also added to the `<xwalk:value-maps>` element.
```xml
<!-- translate Elements label values into EPrints namedset values - see https://github.com/eprintsug/sd_goals/ -->
<xwalk:value-map name="translate-sdg-to-sd_goals">
  <xwalk:value-mapping from="1 No Poverty"                              to="01np" />
  <xwalk:value-mapping from="2 Zero Hunger"                             to="02zh" />
  <xwalk:value-mapping from="3 Good Health and Well Being"              to="03ghwb" />
  <xwalk:value-mapping from="4 Quality Education"                       to="04qe" />
  <xwalk:value-mapping from="5 Gender Equality"                         to="05ge" />
  <xwalk:value-mapping from="6 Clean Water and Sanitation"              to="06cws" />
  <xwalk:value-mapping from="7 Affordable and Clean Energy"             to="07ace" />
  <xwalk:value-mapping from="8 Decent Work and Economic Growth"         to="08dweg" />
  <xwalk:value-mapping from="9 Industry, Innovation and Infrastructure" to="09iii" />
  <xwalk:value-mapping from="10 Reduced Inequalities"                   to="10ri" />
  <xwalk:value-mapping from="11 Sustainable Cities and Communities"     to="11scc" />
  <xwalk:value-mapping from="12 Responsible Consumption and Production" to="12rcp" />
  <xwalk:value-mapping from="13 Climate Action"                         to="13ca" />
  <xwalk:value-mapping from="14 Life Below Water"                       to="14lbw" />
  <xwalk:value-mapping from="15 Life on Land"                           to="15lol" />
  <xwalk:value-mapping from="16 Peace, Justice and Strong Institutions" to="16pjsi" />
  <xwalk:value-mapping from="17 Partnerships for the Goals"             to="17pfg" />
</xwalk:value-map>

Any questions regarding the Symplectic Elements integration should be directed to the SYMPLECTIC-USERS@JISCMAIL.AC.UK mailing list.
