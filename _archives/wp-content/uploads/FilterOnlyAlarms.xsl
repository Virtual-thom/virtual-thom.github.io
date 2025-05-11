<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ex="http://exslt.org/dates-and-times" extension-element-prefixes="ex" >

<xsl:output method="xml" version="1.0" encoding="UTF-8"
     indent="yes" cdata-section-elements="Value Script Parameter Formula" />

    <!-- Copy everything -->

    <xsl:template match="node() | @*">

        <xsl:copy>

            <xsl:apply-templates select="node() | @*"/>

        </xsl:copy>

    </xsl:template>



    <!-- Match elements which need to be filtered and do not copy them to the output -->

    <xsl:template match="/Domain/*[not(self::Alarms)]"/>

</xsl:stylesheet>
