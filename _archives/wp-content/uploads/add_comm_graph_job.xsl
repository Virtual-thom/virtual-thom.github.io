<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:ex="http://exslt.org/dates-and-times" extension-element-prefixes="ex" >

<xsl:output method="xml" version="1.0" encoding="UTF-8" 
     indent="yes" cdata-section-elements="Value Script Parameter Formula" /> 
	<xsl:variable name="gaucheAccolade">{</xsl:variable>
	<xsl:variable name="droiteAccolade">}</xsl:variable>
	
   <!-- Identity transform -->
   <xsl:template match="@* | node()">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
   </xsl:template>

   <xsl:template match="Job/Node/Properties/Property[1]">
     <xsl:copy-of select="."/>
      <Property key="content" value="&lt;html&gt;&#10;{$gaucheAccolade}prefix{$droiteAccolade}&lt;b&gt;{$gaucheAccolade}name{$droiteAccolade}&lt;/b&gt;{$gaucheAccolade}suffix{$droiteAccolade}&lt;br&gt;{$gaucheAccolade}comment{$droiteAccolade}&#10;&lt;/html&gt;"/>
   </xsl:template>
   
</xsl:stylesheet>
