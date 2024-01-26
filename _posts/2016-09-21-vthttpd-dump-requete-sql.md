---
layout: post
title: vthttpd -dump et requêtes SQL - tlist ameliore - vtexport.xml to csv
date: 2016-09-21 22:00
author: Virtual Thom
categories: [vthttpd, dump,SQL, Visual TOM, VTOM, tlist, java, XSL, XML, vtexport, vtexport.xml, csv]
---
&lt;Article mis à jour&gt; J'ai rajouté pas mal de petites astuces sur cet article qui date de l'année dernière (filtre XSL - merci Joey pour l'inspiration !, parsing java, utilisation de Panda Python)

Une autre astuce avec le Webaccess VTOM vthttpd : on peut dump tout le contenu de la base VTOM en un fichier exploitable par SQLITE !

L'utilisation principale est de lister tous les jobs, à la manière d'un `tlist`mais avec beaucoup plus d'informations (dont les paramètres et le script)

Voici un petit exemple :

```
vthttpd -dump /var/tmp/vthttpd.dat
sqlite3 /var/tmp/vthttpd.dat
>
.tables  -- liste toutes les tables
pragma table_info(JOBS) ; -- liste les champs de la table JOBS
.schema JOBS ; -- idem mais avec le type de la colonne (varchar(35) par ex.)
```

On peut exécuter un script .sql :

```bash
sqlite3 /var/tmp/vthttpd.dat < /var/tmp/monfichier.sql
```

Et on grep sur ce qu'on souhaite

```sql
select j.JOB_SID, e.NAME, a.NAME, j.NAME, j.COMMENT, j.FAMILY, j.SCRIPT, h.NAME, u.NAME, q.NAME, d.NAME, GROUP_CONCAT(p.VALUE,'|')
from jobs j
left join applications a on j.APP_SID = a.APP_SID
left join environments e on a.ENV_SID = e.ENV_SID
left join hosts h on j.HOST_SID = h.HOST_SID or (ifnull(j.HOST_SID,'') = '' and ( a.HOST_SID = h.HOST_SID or (ifnull(a.HOST_SID,'') = '' and e.HOST_SID = h.HOST_SID) ) )
left join users u on j.USER_SID = u.USER_SID or (ifnull(j.USER_SID,'') = '' and ( a.USER_SID = u.USER_SID or (ifnull(a.USER_SID,'') = '' and e.USER_SID = u.USER_SID) ) )
left join queues q on j.QUEUE_SID = q.QUEUE_SID or (ifnull(j.QUEUE_SID,'') = '' and ( a.QUEUE_SID = q.QUEUE_SID or (ifnull(a.QUEUE_SID,'') = '' and e.QUEUE_SID = q.QUEUE_SID) ) )
left join dates d on j.DATE_SID = d.DATE_SID or (ifnull(j.DATE_SID,'') = '' and ( a.DATE_SID = d.DATE_SID or (ifnull(a.DATE_SID,'') = '' and e.DATE_SID = d.DATE_SID) ) )
left join job_parameters p on j.JOB_SID = p.JOB_SID
group by j.JOB_SID
;
```

ex.

```
root@acf59c2005cf:/mnt/workspace/temp# sqlite3 vthttpd.dat < all_jobs.sql
JOBac1100030a411a8d570cf93000000004|exploitation|appli_test|job2|||jobok.bat|client_local|vtom|queue_ksh|date_exp|
JOBac1100033f6aedb3570cf93000000002|exploitation|appli_test|job1|||jobok.bat|client_local|vtom|queue_ksh|date_exp|param1|param2|param3
JOBac1100036f024b9d570cf93000000006|exploitation|appli_test|job3|||jobok.bat|client_local|vtom|queue_ksh|date_exp|
```

(exemple en Java, P.I je ne suis pas expert en Java - je suis tombé sur des machines qui n'avaient pas sqlite3 ... Ca ne suit surement pas les bonnes pratiques JAva mais ça fonctionne)

```java
package top100_vthttpd_jobs_to_csv;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class Top100Main {

	public static void main(String[] args) {
		Connection c = null;
		Statement stmt = null;
		String sepCSV = "," ;
		
		try {
			Class.forName("org.sqlite.JDBC");
			c = DriverManager.getConnection("jdbc:sqlite:D:\\workspace\\java\\top100_vthttpd_jobs_to_csv\\vthttpd.dat");
			c.setAutoCommit(false);
			stmt = c.createStatement();
			
			String allJobs = "select j.JOB_SID, e.NAME, a.NAME, j.NAME, j.COMMENT, j.FAMILY, j.SCRIPT, h.NAME, u.NAME, q.NAME, d.NAME, GROUP_CONCAT(p.VALUE,'|')"
					+ " from jobs j"
					+ " left join applications a on j.APP_SID = a.APP_SID"
					+ " left join environments e on a.ENV_SID = e.ENV_SID"
					+ " left join hosts h on j.HOST_SID = h.HOST_SID or (ifnull(j.HOST_SID,'') = '' and ( a.HOST_SID = h.HOST_SID or (ifnull(a.HOST_SID,'') = '' and e.HOST_SID = h.HOST_SID) ) )"
					+ " left join users u on j.USER_SID = u.USER_SID or (ifnull(j.USER_SID,'') = '' and ( a.USER_SID = u.USER_SID or (ifnull(a.USER_SID,'') = '' and e.USER_SID = u.USER_SID) ) )"
					+ " left join queues q on j.QUEUE_SID = q.QUEUE_SID or (ifnull(j.QUEUE_SID,'') = '' and ( a.QUEUE_SID = q.QUEUE_SID or (ifnull(a.QUEUE_SID,'') = '' and e.QUEUE_SID = q.QUEUE_SID) ) )"
					+ " left join dates d on j.DATE_SID = d.DATE_SID or (ifnull(j.DATE_SID,'') = '' and ( a.DATE_SID = d.DATE_SID or (ifnull(a.DATE_SID,'') = '' and e.DATE_SID = d.DATE_SID) ) )"
					+ " left join job_parameters p on j.JOB_SID = p.JOB_SID"
					+ " group by j.JOB_SID"
				//	+ " limit 10"
					+ " ;"
			;

			ResultSet rs = stmt.executeQuery( allJobs );
			
			
			while ( rs.next() ) {
			   String jSID = rs.getString(1);
			   String eName = rs.getString(2);
			   String aName = rs.getString(3);
			   String jName = rs.getString(4);
			   String jComment = rs.getString(5);
			   String jFamily = rs.getString(6);
			   String jScript = rs.getString(7);
			   String hName = rs.getString(8);
			   String uName = rs.getString(9);
			   String qName = rs.getString(10);
			   String dName = rs.getString(11);
			   String pValue = rs.getString(12);
			   System.out.print( 
					   //jSID + sepCSV + 
					   eName + sepCSV + aName + sepCSV + jName + sepCSV + jComment + sepCSV +
					   jFamily + sepCSV + jScript + sepCSV +hName + sepCSV + uName + sepCSV +
					   qName + sepCSV + dName + sepCSV + pValue
					);
			   System.out.println();
			}
		
			rs.close();
			stmt.close();
			c.close();
			
		}catch ( Exception e ) {
		  System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		  System.exit(0);
		}

	}
}
```

### Filtrer directement un fichier XML avec un fichier XSL et sortie en texte (pour du csv)

J'avais déjà utilisé ce langage de transformation XSL mais il m'était complétement sorti de la tête. Merci à JOEY de m'avoir inspriré ! :)

Fichier XSL de transformation (à adapter selon vos besoin)

```xml
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="utf-8" />
  
  <!-- j'utilise cette sortie pour constituer mon fichier CSV utilisé en tant que data pour load dans Oracle une table avec SQLLDR et un fichier de controle .ctl -->
  <!--
  sqlldr do not set OPTIONALLY ENCLOSED BY '"' because this char appears in comments and params 

        LOAD DATA APPEND
        INTO TABLE nom_dela_table_oracle
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
  
  <xsl:param name="delimCSV" select="'£'" /><!-- j'utilise ce char car il n'est pas utilisé dans mon référentiel VTOM -->
  <xsl:param name="delimParam" select="'§'" />
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
    <xsl:value-of select="$break" />
  </xsl:template>

  <!-- All Parameter node for Job node -->
  <xsl:template match="Parameters/Parameter">
    <xsl:value-of select="text()" /><xsl:value-of select="$delimParam" />                       <!-- Parameter -->
  </xsl:template>  

</xsl:stylesheet>
```

Pour appliquer le fichier XSL au fichier XML vtexport VTOM, on peut faire ça assez simplement avec une class Java (Stylizer) fournie par Oracle.

Si vous voulez plus d'information sur la classe et la télécharger, voici le lien Oracle [Transforming XML Data with XSLT](https://docs.oracle.com/javase/tutorial/jaxp/xslt/transformingXML.html).

```bash
# Compiler le code source java pour créer votre class Stylizer.class, A ne faire qu'une fois. La classe doit se trouver dans votre CLASSPATH (variable d'environnement)
javac Stylizer.java

# Lancer la commande pour transformer votre XML avec le fichier XSL
java Stylizer votrefichier.xsl vtorefichier.xml
```

### Parser le vtexport XML VTOM en "pur" Java (un peu long)

```java
package vtexport_xml_to_csv;

import java.io.File;
import java.io.FileWriter ;
import java.io.IOException;
import java.util.Date;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathConstants ;
import javax.xml.xpath.XPathExpressionException;

import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

public class VtexportXML {
	private static String xmlPath ;
	private static Document document;
	private static final String separateurCSV = "£" ;
	private static final String separateurEscape = "§" ;
	private static String domainName;
	
	public static void main(String[] args) throws ParserConfigurationException, SAXException, IOException, XPathExpressionException {
		if (args.length == 1) {
			setXmlPath(args[0]);
		}else{
			System.err.println("Usage : 1 paramètre nécessaire");
			System.err.println("1 : chemin complet du fichier xml");
	        System.exit(1);
		}

        final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();    	
        final DocumentBuilder builder = factory.newDocumentBuilder();
	    setDocument( builder.parse( new File( getXmlPath() ) ) );
    	listAllJobs();
	}

	public static String getXmlPath() {
		return xmlPath;
	}

	public static void setXmlPath(String xmlPath) {
		VtexportXML.xmlPath = xmlPath;
	}
	
	public static Document getDocument() {
		return document;
	}

	public static void setDocument(Document document) {
		VtexportXML.document = document;
	}
	
	public static void listAllJobs() throws XPathExpressionException, IOException{
		System.out.println(new Date()) ;
		
		File file = new File(getXmlPath() + ".txt");
		// creates the file
		file.createNewFile();
		// creates a FileWriter Object
		FileWriter writer = new FileWriter(file); 
		
		// xPath instance
		XPath xPath =  XPathFactory.newInstance().newXPath();
		// set DomainName 
		setDomainName((String) xPath.compile("/Domain/@name").evaluate( getDocument() ) );
		
		// get all nodelist job
		NodeList nodeList = (NodeList) xPath.compile("/Domain/Environments/Environment/Applications/Application/Jobs/Job").evaluate(getDocument(),XPathConstants.NODESET);	
		
		int percentDone = 1 ;
		System.out.print("0%.");
		
		// loop over nodelist job
		for(int i = 0; i < nodeList.getLength() ; i++){
			
			// print evolution running script %
			if(! ( (i * 100 / nodeList.getLength()) < percentDone ) ){
				percentDone++ ;
				if(percentDone % 10 == 0){
					System.out.print(percentDone + "%");
				}else{
					System.out.print(".");
				}
			}
			
			// job node
			Node jobNode = (Node) nodeList.item(i) ;
			
			// nodelist parameters
			NodeList parametersNodes = (NodeList) xPath.evaluate("Parameters/Parameter",jobNode,XPathConstants.NODESET) ;
			String[] parameters = new String [ parametersNodes.getLength() ] ;
			
			// all parameters as an Array
			for(int j = 0 ; j < parametersNodes.getLength() ; j++){
				parameters[j] = ((Node) parametersNodes.item(j)).getTextContent() ;
			}
			
			writer.write(
				
				separateurEscape + xPath.evaluate("../../../../@name", jobNode) + separateurEscape + separateurCSV +	// envName
				separateurEscape + xPath.evaluate("../../@name", jobNode) + separateurEscape + separateurCSV +			// appName
				separateurEscape + xPath.evaluate("@name", jobNode) + separateurEscape + separateurCSV +				// jobName
				separateurEscape + xPath.evaluate("../../@mode", jobNode) + separateurEscape + separateurCSV +			// AppMode
				separateurEscape + xPath.evaluate("@mode", jobNode) + separateurEscape + separateurCSV +				// JobMode
				separateurEscape + xPath.evaluate("../../@onDemand", jobNode) + separateurEscape + separateurCSV +		// AppOnDemand
				separateurEscape + xPath.evaluate("@onDemand", jobNode) + separateurEscape + separateurCSV +			// JobOnDemand
				separateurEscape + xPath.evaluate("Script",jobNode) + separateurEscape + separateurCSV +				// Script
				separateurEscape + String.join("|", parameters) + separateurEscape + separateurCSV + 					// Parameters
				separateurEscape + getDomainName() + separateurEscape + separateurCSV									// DomainName
				+ "\n"
			);
			
		}

		// Flush the content to the file
		writer.flush();
		writer.close();
		
		// print prompt running script
		System.out.println();
		System.out.println("Fichier en sortie : " + file.getAbsolutePath());
		System.out.println(new Date() + " The end");
	}

	public static String getDomainName() {
		return domainName;
	}

	public static void setDomainName(String domainName) {
		VtexportXML.domainName = domainName;
	}

}
```

### Autre pour moi

Reminder pour moi : consolidation des statistiques VTOM (en attendant que tout soit dans la base postgres, je passe par le vthttpd dump)

```bash
plateforme=up2
vthttpdDat=vthttpd_${plateforme}.dat
allJobsSQL=all_jobs.sql
allJobs1to1=all_jobsSID_1to1Param_${plateforme}.txt
allJobsManyTo1=all_jobsSID_manyTo1Param_${plateforme}.txt
outputStats=stats_${plateforme}
vtsgbdPort=30509
hostFilter=HOST1

test -f $vthttpdDat && rm $vthttpdDat
vthttpd -dump $vthttpdDat
sqlite3 $vthttpdDat < $allJobsSQL |  awk 'BEGIN{ FS="|" ; OFS="|" } { l=length($10) ; if(l == 2) { $10="0"$10 ;} ;  if(l == 1){ $10="00"$10 }  ; print}' | sort -g  >  $allJobs1to1

### All jobs manyto1 parameters
awk -F "|" 'BEGIN{ job_sid=null;} {if($1 == job_sid){ printf "|%s",$11 }else{ if(job_sid != null){ printf "\n" } ; printf "%s|%s|%s|%s|%s|%s|%s|%s|%s|%s",$1,$2,$3,$4,$5,$6,$7,$8,$9,$11 } ; job_sid=$1 ;}' $allJobs1to1 | sort > $allJobsManyTo1

# get stats with filters (modify where clauses)   
# select vtobjectsid,vtenvname, vtapplname, vtjobname, vtbegin, (vtend::timestamp - vtbegin::timestamp), vtend, vtexpdatevalue, vthostname, vtusername, vtbqueuename, vtdatename,vtstatus, vterrmess  
~/sgbd/bin/psql -d vtom -p $vtsgbdPort << EOF
\pset tuples_only
\pset footer off
\a
\o $outputStats
select vtobjectsid,vtbegin,(vtend::timestamp - vtbegin::timestamp),vtend,vtexpdatevalue,vtstatus,vterrmess
from vt_stats_job 
where vthostname = '$hostFilter' 
and (vtend::timestamp - vtbegin::timestamp) >= '00:10:00'
order by (vtend::timestamp - vtbegin::timestamp) 
;
EOF
```

Très long avec Awk (beaucoup d'itération :x)

```
awk -v fic=$allJobsManyTo1 'BEGIN{
    OFS="|";FS="|";
    i=0 ;
    while ((getline line < fic ) > 0){
        tAllJobsManyTo1[i]=line ;
        i++ ;
    }
    close (fic) ;
    
}{
    if($1 ~ /^APP/){
      print $0;
      next
    }
    jobSID=$1 ;
    lineStats=$0 ;
    
    for (i in tAllJobsManyTo1){
        split(tAllJobsManyTo1[i],tLine,"|");
   
        if( tLine[1] == jobSID ){
          script=tLine[5] ;
          printf "%s|%s\n",lineStats,script ;
          delete  tAllJobsManyTo1[i] ;
          break; 
        }
    }
    
}' /var/tmp/stats
```


Beaucoup plus rapide avec Pandas - Python :

```python
import pandas

my_cols_csv1 = [ "vtobjectsid","vtbegin","vtduration","vtend","vtexpdatevalue","vtstatus","vterrmess" ]
csv1 = pandas.read_csv('stats_up2',delimiter=r"|",names=my_cols_csv1)
my_cols=["vtobjectsid","env","app","job","script","host","user","queue","vtdatename","param"]
my_cols=my_cols + range(150)
csv2 = pandas.read_csv('all_jobsSID_manyTo1Param_up2.txt',names=my_cols, sep="|")
merge = pandas.merge(csv1,csv2, on='vtobjectsid')
merge.to_csv("output.csv")
```

```
	vtobjectsid	vtbegin	vtduration	vtend	vtexpdatevalue	vtstatus	vterrmess	env	app	job	script	host	user	queue	vtdatename	param
0	JOB7ef5b39400006ad956a6113e00014e22	19/03/2016 03:58	00:10:00	19/03/2016 04:08	19/03/2016	3	Termine a 04:08:30	ENV1	poz12daj1	p800ostp1	PATH_DWH_SHELL/OSEF_odi.ksh	HOST1	prdwh12	queue_ksh	ENV1J_12_rdwh	
1	JOB7ef5b39400006ad956a6113e00014e22	03/03/2016 03:29	00:12:24	03/03/2016 03:42	03/03/2016	3	Termine a 03:42:17	ENV1	poz12daj1	p800ostp1	PATH_DWH_SHELL/OSEF_odi.ksh	HOST1	prdwh12	queue_ksh	ENV1_12_rdwh	
```
