# Integration with Pure

The MODS-to-Eprints xslt can be updated to map the SDGs as store in Pure into the format supported by this extension.

1) Add `<sd_goals>` element in main `<eprint>` block of stylesheet

```xml
<xsl:if test="v3:classification[@authority='pure/sustainabledevelopmentgoals']">
  <sd_goals>
    <xsl:for-each select="v3:classification[@authority='pure/sustainabledevelopmentgoals']">
      <xsl:variable name="sdgToken"> 
        <xsl:call-template name="find-last-token"> 
          <xsl:with-param name="uri" select="."/> 
        </xsl:call-template> 
      </xsl:variable>  
      <xsl:call-template name="sustainableDevelopmentGoals"> 
        <xsl:with-param name="uriToken" select="$sdgToken"/> 
      </xsl:call-template>
    </xsl:for-each>
  </sd_goals>
</xsl:if>
```

1) Add a template to map Pure URI values to EPrints namedset values. This can be placed at the end of the stylesheet.

```xml
<xsl:template name="sustainableDevelopmentGoals">
  <xsl:param name="uriToken"/>
  <xsl:choose>
    <xsl:when test="$uriToken='no_poverty'">
      <item>01np</item>
    </xsl:when>
    <xsl:when test="$uriToken='zero_hunger'">
      <item>02zh</item>
    </xsl:when>
    <xsl:when test="$uriToken='good_health_and_well_being'">
      <item>03ghwb</item>
    </xsl:when>
    <xsl:when test="$uriToken='quality_education'">
      <item>04qe</item>
    </xsl:when>
    <xsl:when test="$uriToken='gender_equality'">
      <item>05ge</item>
    </xsl:when>
    <xsl:when test="$uriToken='clean_water_and_sanitation'">
      <item>06cws</item>
    </xsl:when>
    <xsl:when test="$uriToken='affordable_and_clean_energy'">
      <item>07ace</item>
    </xsl:when>
    <xsl:when test="$uriToken='decent_work_and_economic_growth'">
      <item>08dweg</item>
    </xsl:when>
    <xsl:when test="$uriToken='industry_innovation_and_infrastructure'">
      <item>09iii</item>
    </xsl:when>
    <xsl:when test="$uriToken='reduced_inequalities'">
      <item>10ri</item>
    </xsl:when>
    <xsl:when test="$uriToken='sustainable_cities_and_communities'">
      <item>11scc</item>
    </xsl:when>
    <xsl:when test="$uriToken='responsible_consumption_and_production'">
      <item>12rcp</item>
    </xsl:when>
    <xsl:when test="$uriToken='climate_action'">
      <item>13ca</item>
    </xsl:when>
    <xsl:when test="$uriToken='life_below_water'">
      <item>14lbw</item>
    </xsl:when>
    <xsl:when test="$uriToken='life_on_land'">
      <item>15lol</item>
    </xsl:when>
    <xsl:when test="$uriToken='peace_justice_and_strong_institutions'">
      <item>16pjsi</item>
    </xsl:when>
    <xsl:when test="$uriToken='partnerships'">
      <item>17pfg</item>
    </xsl:when>
    <xsl:otherwise>
      <!-- nothing? -->
    </xsl:otherwise> 
  </xsl:choose>
</xsl:template>
```

1) If you map any other values from Pure classification schema, you may need to exclude the SDGs from this mapping. Search your XSLT for 'v3:classification'.

```xml
<xsl:if test="v3:classification[@authority!='pure/sustainabledevelopmentgoals']"> 
  <subjects> 
    <xsl:for-each select="v3:classification[@authority!='pure/sustainabledevelopmentgoals']"> 
      <item> 
        <xsl:call-template name="find-last-token"> 
          <xsl:with-param name="uri" select="."/> 
        </xsl:call-template> 
      </item> 
    </xsl:for-each> 
  </subjects> 
</xsl:if>
```
