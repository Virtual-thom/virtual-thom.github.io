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


  <xsl:param name="delimCSV" select="'¤'" />
  <xsl:param name="delimParam" select="'£'" />
  <xsl:param name="delimCom" select="' '" />
  <xsl:param name="break" select="'&#xA;'" />

  <!--
  <xsl:value-of select="$delimCSV" />
   -->

  <xsl:template match="/">
    <xsl:text>vtenvname</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>vtapplname</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>vtjobname</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>vtcomment</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>vtscript</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>vtparam</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>vtdomain</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>vthostname</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>vtdate</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>Hmin</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>Hmax</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>ressourcesapp</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>ressources</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>alarmes</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>restart</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>queue</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>famille</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>appmode</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>jobmode</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>appd</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:text>jobd</xsl:text>
    <xsl:value-of select="$delimCSV" />
    <xsl:value-of select="$break" />
    <xsl:apply-templates select="Domain/Environments/Environment/Applications/Application/Jobs/Job" />
  </xsl:template>

  <!-- All Job node for root node -->
  <xsl:template match="Domain/Environments/Environment/Applications/Application/Jobs/Job">
    <xsl:value-of select="../../../../@name" />
    <xsl:value-of select="$delimCSV" />              <!-- EnvironmentName -->
    <xsl:value-of select="../../@name" />
    <xsl:value-of select="$delimCSV" />                    <!-- ApplicationName -->
    <xsl:value-of select="@name" />
    <xsl:value-of select="$delimCSV" />                          <!-- JobName -->
    <xsl:value-of select="../../@comment" />
    <xsl:value-of select="$delimCom" />
    <xsl:value-of select="@comment" />
    <xsl:value-of select="$delimCSV" />                       <!-- Comment -->
    <xsl:value-of select="Script/text()" />
    <xsl:if test="@jobType = 'TRANSFER'">
        <xsl:value-of select="@jobApplicationServer" />
    </xsl:if>
    <xsl:value-of select="$delimCSV" />                       <!-- script -->
    <xsl:choose>
      <xsl:when test="Parameters/Parameter">
        <xsl:apply-templates select="Parameters/Parameter" />
      </xsl:when>
      <xsl:when test="Parameters/@format = 'json'">
        <xsl:value-of select="Parameters/text()" />
      </xsl:when>
    </xsl:choose>                                                 
    <xsl:value-of select="$delimCSV" />                             <!-- Parameters --> 
    <xsl:value-of select="../../../../../../@name" />
    <xsl:value-of select="$delimCSV" />        <!-- DomainName -->
    <xsl:choose>                                                                                <!-- Host -->
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
    <xsl:value-of select="$delimCSV" />
    <xsl:choose>
      <xsl:when test="../../@date">
        <xsl:value-of select="../../@date" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="../../../../@date" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$delimCSV" />                                            <!-- DateExpName -->
    <xsl:value-of select="@minStart" />
    <xsl:value-of select="$delimCSV" />                        <!-- Hmin -->
    <xsl:value-of select="@maxStart" />
    <xsl:value-of select="$delimCSV" />                        <!-- Hmax -->
    <xsl:apply-templates select="../../ExpectedResources/ExpectedResource" />
    <xsl:value-of select="$delimCSV" />
    <xsl:apply-templates select="ExpectedResources/ExpectedResource" />
    <xsl:value-of select="$delimCSV" />
    <xsl:apply-templates select="/Domain/ObjectAlarms/ObjectAlarm">
      <xsl:with-param name="currentJob"
        select="concat(../../../../@name, '/', ../../@name,  '/', @name)" />
    </xsl:apply-templates>
    <xsl:value-of select="$delimCSV" />
    <xsl:value-of
      select="concat('restartType=',@restartType, ' restartMax=', @restartMax, ' restartDelay=', @restartDelay )" />
    <xsl:value-of select="$delimCSV" />
    <xsl:value-of select="@queue" />
    <xsl:value-of select="$delimCSV" />                    <!-- queue -->
    <xsl:value-of select="@family" />
    <xsl:value-of select="$delimCSV" />                    <!-- Family -->
    <xsl:value-of select="../../@mode" />
    <xsl:value-of select="$delimCSV" />                    <!-- ApplicationMode -->
    <xsl:value-of select="@mode" />
    <xsl:value-of select="$delimCSV" />                          <!-- JobMode -->
    <xsl:value-of select="../../@onDemand" />
    <xsl:value-of select="$delimCSV" />                <!-- ApplicationOnDemand -->
    <xsl:value-of select="@onDemand" />
    <xsl:value-of select="$delimCSV" />                      <!-- JobOnDemand -->

    <xsl:value-of select="$break" />
  </xsl:template>


  <!-- All Parameter node for Job node -->
  <xsl:template match="Parameters/Parameter">
    <!--<xsl:value-of
    select="translate(text(), '&#10;', '')" />-->
    <xsl:value-of select="normalize-space()" />
    <xsl:if test="position() != last()">
      <xsl:value-of select="$delimParam" />                       <!-- Parameter -->
    </xsl:if>
  </xsl:template>


  <xsl:template match="ExpectedResources/ExpectedResource">
    <xsl:value-of select="@resource" />
    <xsl:text> </xsl:text>
    <xsl:value-of select="@operator" />
    <xsl:text> </xsl:text>
    <xsl:value-of select="normalize-space(Value/text())" />
    <xsl:value-of select="$delimParam" />
  </xsl:template>

  <xsl:template match="/Domain/ObjectAlarms/ObjectAlarm">
    <xsl:param name="currentJob" />
    <xsl:if test="$currentJob = @objectName">
      <xsl:apply-templates select="Alarm" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="Alarm">
    <xsl:value-of select="@name" />
    <xsl:value-of select="$delimParam" />
  </xsl:template>

</xsl:stylesheet>
