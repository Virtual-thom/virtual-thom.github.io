---
layout: post
title: FAQ VTOM Dates - Dec
date: 2016-12-23 20:45
author: Virtual Thom
categories: [vtom, tchkdate, tlist, xsl, xml, date, vtexport]
---
Des fois, j'ai des questions en direct par e-mail. Je me dis que ça pourrait être bien de poster les questions / réponses.

# unlock a locked date

Unlock a locked date in command line is not possible, and should stay a human action.
If you ask yourself how to automate and unlock a locked date (or all) without an human action, may be your job(s) should not lock the date in the first place (in jobs's definition).

Of course you can always unlock a locked date by setting all jobs which are blocking this date to OK.

You can list all locked date with this command :
`tlist blocage`

Or check the status of a date : 
`tchkdate /nom="your_datename"`

Then loop over all blocking jobs and set to OK :

```
vtom@044d119e1768:/mnt/workspace$ vtaddjob /nom="exploitation/appli_test/job1" /status="te"
Modification du traitement exploitation/appli_test/job1 terminee (27ms).
```

# retrieve corresponding environment/application for a specific date? 

`tlist [-f <env>[/<app>[/<job>]]] jobs` should do the trick.

Something like that :

```
tlist jobs | sort -k"2,2" -u | grep -w "your_date"
sort -k"2,2" -u to sort on applications and get unique row for an application
grep -w "your_date" to filter with your specific date


vtom@044d119e1768:~$ tlist -f exploitation jobs | sort -k"2,2" -u | grep -w "date_exp"
exploitation            appli_test              job1                    client_local            date_exp
```

Also, you can do a csv list of whatever column you want  with a vtexport and an preformatted xsl file.

First compile the [Stylizer.java]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/Stylizer.java) class : `javac Stylizer.java`

Export your VTOM base in XML :

```
vtexport -x [-f <env>[/<app>[/job]]] > /somepath/your_vtexport.xml
```

Filter the XML with the [XSL file]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/filter_env_app_date.xsl) : `java Stylizer filter_env_app_date.xsl your_vtexport.xml`

```
vtom@044d119e1768:/mnt/workspace$ javac Stylizer.java
vtom@044d119e1768:/mnt/workspace$ ls
Stylizer.class  Stylizer.java
vtom@044d119e1768:/mnt/workspace$ java Stylizer filter_env_app_date.xsl /var/tmp/vtexport.xml
exploitation£appli_test£date_exp£
```
