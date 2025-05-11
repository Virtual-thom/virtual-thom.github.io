<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="utf-8" />

  <xsl:param name="csv" select="';'" />
  <xsl:param name="intercsv" select="','" />
  <xsl:param name="break" select="'&#xA;'" />

  <xsl:template match="/">
          <xsl:apply-templates select="Domain/Environments/Environment/Applications/Application" />
  </xsl:template>

  <xsl:template match="Domain/Environments/Environment/Applications/Application">
    <xsl:if test="ExpectedResources/ExpectedResource">

        <xsl:variable name="isResStartWithOk">         
            <xsl:apply-templates select="ExpectedResources/ExpectedResource" />
        </xsl:variable>

        <xsl:if test="$isResStartWithOk != ''">
            <xsl:value-of select="../../@name" />
            <xsl:value-of select="$csv" />
            <xsl:value-of select="@name" />
            <xsl:value-of select="$csv" />
            <xsl:value-of select="$isResStartWithOk" />
            <xsl:value-of select="$csv" />
            <xsl:value-of select="$break" />
        </xsl:if>

    </xsl:if>
  </xsl:template>

  <xsl:template match="ExpectedResources/ExpectedResource">
    <xsl:value-of select="@resource" />
    <xsl:value-of select="@operator" />
    <xsl:value-of select="normalize-space(Value/text())" />
    <xsl:value-of select="$intercsv" />
 </xsl:template>

</xsl:stylesheet>
