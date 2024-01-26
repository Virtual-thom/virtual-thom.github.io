<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="utf-8" />

  <xsl:param name="csv" select="';'" />
  <xsl:param name="intercsv" select="','" />
  <xsl:param name="break" select="'&#xA;'" />

  <xsl:template match="/">
          <xsl:apply-templates select="Domain/Resources/Resource" />
  </xsl:template>

  <xsl:template match="Domain/Resources/Resource">
        <xsl:value-of select="@name" />
        <xsl:value-of select="$csv" />
        <xsl:value-of select="normalize-space(Value/text())" /> <!-- normalize-space remove leading and trailing space and breaklines -->
        <xsl:value-of select="$csv" />
        <xsl:value-of select="@type" />
        <xsl:value-of select="$csv" />
        <xsl:choose>
          <xsl:when test="@type = 'F'">
            <xsl:value-of select="@host" />
            <xsl:value-of select="$csv" />
          </xsl:when>
          <xsl:when test="@type = 'D'">
            <xsl:value-of select="@date" />
            <xsl:value-of select="$csv" />
            <xsl:value-of select="@calendar" />
            <xsl:value-of select="$csv" />
            <xsl:value-of select="@format" />
            <xsl:value-of select="$csv" />
          </xsl:when>
          <xsl:when test="@type = 'W'">
            <xsl:value-of select="@current" />
            <xsl:value-of select="$csv" />
          </xsl:when> 
        </xsl:choose>
        <xsl:value-of select="$break" />
  </xsl:template>

</xsl:stylesheet>
