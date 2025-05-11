<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="utf-8" />
  
  <xsl:param name="sepCSV" select="'£'" /><!-- I use this separator because not use in my VTOM base -->
  <xsl:param name="break" select="'&#xA;'" />

  <xsl:template match="/">
	  <xsl:apply-templates select="Domain/Environments/Environment/Applications/Application" />
  </xsl:template>

  <xsl:template match="Domain/Environments/Environment/Applications/Application">
    <xsl:value-of select="../../@name" /><xsl:value-of select="$sepCSV" />              <!-- EnvironmentName -->
    <xsl:value-of select="@name" /><xsl:value-of select="$sepCSV" />                    <!-- ApplicationName -->
    <xsl:choose>                                                                        <!-- DateName -->
      <xsl:when test="@date">
        <xsl:value-of select="@date" /><xsl:value-of select="$sepCSV" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="../../@date" /><xsl:value-of select="$sepCSV" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$break" />
  </xsl:template>

</xsl:stylesheet>