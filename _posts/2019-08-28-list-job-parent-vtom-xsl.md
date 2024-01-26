---
layout: post
title: Lister des jobs VTOM avec un vtexport xml et un filtre XSL (another one)
date: 2019-08-28 08:14
author: Virtual Thom
categories: [vtexport, xml, xsl]
---

Besoin (comme un autre :relaxed:) : Lister tous les jobs dont le script est 'xxx', ses parents directs, et son unité de soumission
<!--more-->

## XSL 

```xslt
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="utf-8" />

  <xsl:param name="csv" select="';'" />
  <xsl:param name="delimParam" select="'|'" />
  <xsl:param name="break" select="'&#xA;'" />

  <xsl:template match="/">
    <xsl:apply-templates select="Domain/Environments/Environment/Applications/Application/Jobs/Job" />
  </xsl:template>

  <xsl:template match="Domain/Environments/Environment/Applications/Application/Jobs/Job"> <!-- xpath sur tous les jobs -->

    <xsl:if test="contains(Script/text(), 'xxx')"> <!-- changer xxx pour le script rechercher ou enlever la condition if pour tous les jobs -->
      <xsl:choose>                                        <!-- Unite de soumission -->
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
      <xsl:param name="fulljobname" select="concat($env,'/',$app,'/',$job)" /> <!-- Job -->
      <xsl:value-of select="$fulljobname" />
      <xsl:value-of select="$csv" />
      <xsl:for-each select="/Domain/Links/Link[@parent=$fulljobname]">         <!-- Parents du Job -->
        <xsl:value-of select="@child" />
        <xsl:value-of select="$csv" />
      </xsl:for-each>
      <xsl:value-of select="$break" />
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
```

## vtexport et filtre xsl

Pour plus de détails sur le filtre XSL appliqué à un export XML, ça se passe par [ici](https://virtual-thom.github.io/filtre-xsl-vtexport-xml/)

```
vtexport -x > vtexport.xml
java -Xms512m -Xmx1g Stylizer GetParentJob.xsl vtexport.xml
UNITESOUMISSION1;env/app1/job2;env/app1/job1
UNITESOUMISSION2;env/app2/job2;env/app2/job1
...
```
