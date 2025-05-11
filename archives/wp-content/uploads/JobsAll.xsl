<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="utf-8" />
  
  <!--  sqlldr do not set OPTIONALLY ENCLOSED BY '"' because this char appears in comments and params 

        LOAD DATA APPEND
        INTO TABLE TOP100_JOBS_PROD
        FIELDS TERMINATED BY "£"
        
        (
          "VTENVNAME"                     CHAR,
          "VTAPPLNAME"                    CHAR,
          "VTJOBNAME"                     CHAR,
          "APPMODE"                     CHAR,
          "JOBMODE"                     CHAR, 
          etc...
        )
  -->
  <xsl:param name="delimCSV" select="'£'" />
  <xsl:param name="delimParam" select="';'" />
  <xsl:param name="delimCom" select="' '" />
  <xsl:param name="break" select="'&#xA;'" />
  <!--
  <xsl:value-of select="$delimCSV" />
   -->

  <xsl:template match="/">
	  <xsl:apply-templates select="Domain/Environments/Environment/Applications/Application/Jobs/Job" />
  </xsl:template>

  <!-- All Job node for root node -->
  <xsl:template match="Domain/Environments/Environment/Applications/Application/Jobs/Job">
    <xsl:value-of select="../../../../@name" /><xsl:value-of select="$delimCSV" />              <!-- EnvironmentName -->
    <xsl:value-of select="../../@name" /><xsl:value-of select="$delimCSV" />                    <!-- ApplicationName -->
    <xsl:value-of select="@name" /><xsl:value-of select="$delimCSV" />                          <!-- JobName -->
    <xsl:value-of select="../../@mode" /><xsl:value-of select="$delimCSV" />                    <!-- ApplicationMode -->
    <xsl:value-of select="@mode" /><xsl:value-of select="$delimCSV" />                          <!-- JobMode -->
    <xsl:value-of select="../../@onDemand" /><xsl:value-of select="$delimCSV" />                <!-- ApplicationOnDemand -->
    <xsl:value-of select="@onDemand" /><xsl:value-of select="$delimCSV" />                      <!-- JobOnDemand -->
    <xsl:value-of select="Script/text()" /><xsl:value-of select="$delimCSV" />                  <!-- Script -->
    <xsl:apply-templates select="Parameters/Parameter" /><xsl:value-of select="$delimCSV" />    <!-- Parameters -->
    <xsl:value-of select="../../../../../../@name" /><xsl:value-of select="$delimCSV" />        <!-- DomainName -->
   <xsl:choose>
      <xsl:when test="../../@date">
        <xsl:value-of select="../../@date" />
      </xsl:when>
      <xsl:otherwise>
      	<xsl:value-of select="../../../../@date" />
      </xsl:otherwise>
    </xsl:choose><xsl:value-of select="$delimCSV" />                                            <!-- DateExpName -->
    <xsl:value-of select="../../@comment" /><xsl:value-of select="$delimCom" />
    <xsl:value-of select="@comment" /><xsl:value-of select="$delimCSV" />                       <!-- Comment -->
    <xsl:value-of select="$break" />
  </xsl:template>

  <!-- All Parameter node for Job node -->
  <xsl:template match="Parameters/Parameter">
    <xsl:value-of select="text()" /><xsl:value-of select="$delimParam" />                       <!-- Parameter -->
  </xsl:template>  

</xsl:stylesheet>
