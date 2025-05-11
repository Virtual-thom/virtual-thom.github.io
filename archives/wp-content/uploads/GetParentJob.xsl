<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="utf-8" />

  <xsl:param name="csv" select="';'" />
  <xsl:param name="delimParam" select="'|'" />
  <xsl:param name="break" select="'&#xA;'" />

  <xsl:template match="/">
    <xsl:apply-templates select="Domain/Environments/Environment/Applications/Application/Jobs/Job" />
  </xsl:template>

  <xsl:template match="Domain/Environments/Environment/Applications/Application/Jobs/Job">
  
    <xsl:if test="contains(Script/text(), 'reboot_check')">
      <xsl:choose>
        <xsl:when test="@hostsGroup">
          <xsl:value-of select="@hostsGroup" />
        </xsl:when>
        <xsl:when test="../../@hostsGroup">
          <xsl:value-of select="../../@hostsGroup" />
        </xsl:when>
        <xsl:when test="../../../../@hostsGroup">
          <xsl:value-of select="../../../../@hostsGroup" />
        </xsl:when>
      </xsl:choose>
      <xsl:value-of select="$csv" />
      <xsl:param name="env" select="../../../../@name" />
      <xsl:param name="app" select="../../@name" />
      <xsl:param name="job" select="@name" />
      <xsl:param name="fulljobname" select="concat($env,'/',$app,'/',$job)" />
      <xsl:value-of select="$fulljobname" />
      <xsl:value-of select="$csv" />
      <xsl:for-each select="/Domain/Links/Link[@parent=$fulljobname]">
        <xsl:value-of select="@child" />
        <xsl:value-of select="$csv" />
      </xsl:for-each>
      <xsl:value-of select="$break" />
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
