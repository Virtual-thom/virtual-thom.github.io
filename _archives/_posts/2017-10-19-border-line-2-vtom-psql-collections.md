---
layout: post
title: Border Line (n°2 !!!) VTOM V6
date: 2017-10-19 22:03
author: Virtual Thom
categories: [ordonnancement, vtom, vtexport, psql, python, collections]
---
Si vous lisez ces mots, c'est que le côté obscur vous a déjà envahi et que le border line ne vous fait pas peur ! :smiling_imp:

Par conséquent, ce qui va suivre ne vous effraiera point et pourrait même vous intéresser :scream:

<small>(mais quand même, attention à vos prod, ne jouez que sur vos bacs à sable !)</small>

# Les collections VTOM V6 (et les clichés ou snaphots pour les intimes)

Comme promis dans ce post [V6 VTOM Full PostgreSQL](/V6-VTOM-full-postgresql/), j'ai poussé un peu le bouchon (comme Maurice) sur les collections. 

C'est vraiment pas mal. Quelque fois, l'affichage est long ou bug. Mais ça promet d'être très fort.

Je n'ai pas trouvé de "bouton magique" pour exporter les clichés au format XML mais je vous dévoile, ci-après, une astuce border line (CQFD).

## Intro

Un p'tit mot quand même sur les collections et ce que j'en comprends (car pour moi, c'est un avant goût du versioning qu'on attend depuis moultes générations - sisi) :

Je créé une "collection", un genre de conteneur, et j'y glisse les objets qui m'intéressent (ici mon environnement VTOM env1)

![Collections - ajout d'env]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/collection_1.jpg)

Je créé un cliché (snapshot) à un instant T. Appelons le v1710.

![Collections - cliché v1710]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/collection_2.jpg)

Je fais une modification sur mon référentiel. Je créé un autre cliché v1801. (En gros, je fais mes versions)

![Collections - modif v1801]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/collection_3.jpg)
![Collections - cliché v1801]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/collection_4.jpg)

Je clique sur mon cliché v1801 et je le compare avec le v1801. VTOM me pointe tous les changements entre les deux versions. C'est juste génial.

![Collections - différence entre les clichés]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/collection_5.jpg)

## Extraire les clichés au format XML (tiens ça me rappelle les consignes ça !)

Instruction SQL :

```sql
-- /var/tmp/luke.sql
\pset tuples_only
\pset footer off
\a
select vtcontent from vt_col_snapshots ;
```

J'exécute avec `psql` :

```
# sous mon user d'admin vtom
sgbd/bin/psql -U"vtom" -p 30009 -d"vtom" -f /var/tmp/luke.sql > /var/tmp/luke
```

```
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
```

Hey! mais ça ne ressemblerait pas aux consignes ça, par hasard ?!

Je mets ça dans une variable text en python, et je décode base64, puis zlib.

```python
import encodings
import base64
import zlib
>>> text
'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'

>>> base64.b64decode(text)
b'x\x9c\xed\x9c\x7fs\xa3\xb8\x19\xc7\xff\xbfWA\xbd3\x9d\xbbN\xbb\xe67f\xeb\xdd\x1bb\x93\xc4[\xc7\xf6\xd9N\xf6nnn2\x02D\xcc\xae\x03.\xe0\xdd\xe4:}=}!}c\x95\xc4o\xe1\xac0p\xd3vZ_6g\x84\xf8\xf0\xe8y\xa4\xaf\x1e\x04a\xfc\xfd\xd3\xe3\x9e\xfb\x0c\xc3\xc8\x0b\xfc\xb7\x03\xe15?\
xe0\xa0o\x07\x8e\xe7?\xbc\x1d\xdcn/\xff4\x1a|\xff\xee\x9b\xf14x\x04\x9e\xcf\xf9\xe0\x11\xbe\x1dX\x9a\xe0\x8a\xee\xc8\xb6\x05\xd5\x1apQ\x0c\x1e\x0fo\x07w[\xf3\xc7\xd5r\xbd\xe5\xdep\xeak\xe1\xb5\xc4]\xae\xb9\xf9lq\xfb\xe3\xfd\x8f\xaa\xcc\x89\xbc\xa0\rye\xc8K\xdc\x9d\x17\x1
d\xc1\x9e\xdb\x06\x8f\xdc\xb7\xf6w\x9caE\xcfQ4(l G\x0f\xb8\x07\xe8\xc3\x10\xc4\xa8h\nbt\xd2\xed\xee\xc8-\xed\x98\x13tN\x10\xdf\xc8\xfa\x1byD\xa8\x83w\xdfp\xdcx\x15\x06\x07\x18\xc6\x1e\x8c\x86d{\x02\xf6\xd0w@\x18\xe1\xad\xd26\xe79o\x07\x13c.\x0c\xd2\xb6\xd8\x03\xee\x19\x8
2\xf0\xed\x80\xb0\xb8\xc3\xd1\xda{\xf6u\xb0\xf7\x1c\xf0\x1c!\x87\xa0\xf6\x1d\xa0\xed\xb9\x9e=%\x05\xc8?\xae\x17F\xf1\xcc\xff\x00\xe1\'\xb2\xbd\x07\x95\xcdt\xf75\xd8\xbb7\x81\x1f\xefJu\xaaeiE\xbaR\xad\xc2O\xc4\xbe|\x7f\xbe\x89-\xcc\xce\xfb\x05\x7fv\xbb\xac0\xa93\xe0viC\xa
e\xc2\xe0x\xd8\xccP\xdb7\xd7W\xfc\xd7?\xc2 q\xe1\xb0\xe2\xc31\x8eB\xe6M\xfc\x9dxrjlsO:\x03.~>\xa0/\x06\n&\xd8\x1fa\xe2\xd3\xa1\xc0\x0f\x05}\xc0\x85\xd0\x0eP\x8c\x9f\x89\xe9\xd6>\xb0?A\x87|\x8f\x7f%\xff\x8b\xbex\xb1\xbd\xdbz\x18%\xcaox\x1e\xfdd\x96\xe4\xe7\x1e\xaf`\xe8\x0
5N\x1a\xe4\xeb \x8a#\xcer\x00|\x0c\xfcU\x10\xc6o\x07\x12j\x80<\xe0\x1e\x81\x0f\x1e`X\x94\xf1\x83\xd4t|\x0c1\xfdz\xb9\xc9MG\xd6\x80\xfd\x0e\xed\x19pv\xf0\xf8\x08\xfd8q^\x14\xd7\xf6{\x87\xcf2\xea\x16\xa2\xf6\x9aG\xff\t\xa4@\xc5\xb5\x03\xd49\xe6\x9e\x7f|\xe2\x9eT\xb9\xd4\x9
d/\xa6\x86y\xb3\\\xb4\x1b\x16\xbf\x7f%\xf0\x7fF\xcd\x81Q\x84\xda\x83OSi-\x9foob\x10\x1f\x91\x05k\xaa\xed|\xbe\x9d\xd5\xd8$\xfd\xe8\xf6\xe0\x90a%(\xfcH\x92DY\xd4EQK\x9dT\x19OYQQ\xf8\\\xf2\xdf\'\x88\x02zc\xdc\x19\xeb\xed\xf2\x06\xfd\xe4\xa1\xbf\x08\xfc\x8f\xc11\xe4\xfe\xf9
\x0f\x80\x8a\xb8\xef\x93P\x12\xcc\x90\x86\x8f\x878*I\xa8IL\x8b\xe8\x92\x8e\x1b\x95b\x97\x94$\x16\\\xad\x19\x11|\x0c\x1c\x88[\x9c\x9f:\xa7\x97\xb6\x8b\xd6\x94L\xacT\xa4\xd5%\xaf@l)\xd9]X;\xfe\xe1\x08\x8fy\xfb\xc8\x069\xcf\x0f\xb7fn\xf3_q\xe9\xfd\xa7hW\xb69\xed\xf1\xc5\xe1
\xe3\xdb\x08\xe62\x86\xbf\x13\xce\xed\xa6\xe0|\x8e\x83\xc7\x13\x88\xfc\xb8\xf1\x1aF(\x14vnN\xb6MHk\xb3\x18\x07\xae\x90\x8d\xe1\xcb\xa4\xfbW\x1c\x8b\x7f\x13\r!\xce\xca\x9ds\x87\x03\xfen\xfc\xbb\x9f\'H\r\x8c\x9f\x87\x9fA8\x8c\x1f\x0f\xc3\x18\x0f\xda\xf8\xfe\x0f\xaf\xe3\xa7
\xf8\x97_\xde\x8d\x87I\xc5\xd4\x7f\x99\r/\x98$\xe6&\x89=\x9a\xe4x!\xb6\xe9\xeb\xd6\x14[\x89\xf7&H\x8f\xe1S\x9cj\x8e\xe9\x7f\xf6\xc2\xc0\xc7\xae\xce\xdcY*"\xe6\x9b\x8b;`\x0b\x02\x12\x1dQ\xd1Ty\xe4H\x8a\xa2CM\x91\x80\x96K,\xf7\x94\xd6\xcc}\x0f\xfd\xcfx\xb2\xb1C\xef\x10GS\x
8f\xc8\xb7\x9d*p6e%C6\x11\xdd]\xde\xe1\xb2\x91@\xfaS\xd6\xc5\x8e(\xfaY7\x81\xfe\x83\xe7\xc3\x15>\xa3 \xeb\xc9\xf87\xa2OK\xd7|:\xec\x03/&\xb3l&\x05\x12\xaf\xa4V\x9e\x12\n\xbcW\xd0JB\x81z\x99\x93O\x14\xa8\xf9Qj\xeb\xb0R\x83\x08x\xb2\x97X_\xdd[\x1a;I\x1d\xd2\x9ej\x9dd@$\xbb
I\x0b\xab\xbb\xf3\x90%5p\xa7\xe6H7\xaaV#c"\xa9B\\S\xdd[\x9e\\\x8a\xc6\x95\xc3OJ\x8d\xc3\x01\xe5\x08\xc4ie-)\x15\x93n`\xacVY7PUI\xd7P_H\xba\x81\xa5S\xdd\x00\xd5\xcc\xbb\x018\x1c\x04<Y\xc6(\xddJ\'\xc8|d\x1b~\x10\xef\x90\x00Lv\xc0\x7f\x80Y9\xf0B\x88r\x85\x10\xa2\xf8\xfb6\x9
2\xe3)\x9a\x8c\xfc)D\xba\x9f\x1c\xefE(\xd8\x19\xeb\xd9\xdeC\xd3\x07\xd6\xbe\\\x80\xbe\xf1\xe9\x8c\xcb=zx2!sGQ\x06\x9e\xd22Qz\xa3\xe8\xe8\'\xd3\xd6\xf7$\xff#\x13\x0b\x1a\x9f\x0e\x8c\xec\xa5o\x86!I\x9c`\xd2\xbb\xf0\x89\xccA\xe1(\xac\xa7{\xe0\xfb(\xc3\xe4\x0e\xe9\x17R\xdf\r
\xc2\xc7\xe3\x1e\xd4r\x9b\x0f\xc9\'+L\xf3\xa3\x8b\xaf\x7f\x06\xdc\x17tpQ]\xc0\x1fl5\xda\xca\x13$\xa1\xf4)\xfa\x021\xf1}`E\xe5\x82\xa4\x88\x04\xf6\xfd\xf2"\x0b\xac(+#}\xa4H$\xb0\xb2(\xa5\x81\x15\xd3\xc0\xa2\x9a\xb9\x90}\x0c\xac{:\xb2\x9e\x8f\xdb\x9c\x0e\xbfm\x08\x90\xb3\x
88\x8a\xc40Da\x80\xdc\xb7\xfcw\xff\xb6\xc8\x9a\xc4V\x9b|\xe7+QF]t\x96\x07\xb9\x1ar\x92\xd7%\xf9:ik\x84\xd9["\xdf7\xf9\xf6$8\xfaIj\x92\x16\xdc\x80\xa7r\xfd9\xb0\xe0>I\rQ6x\x01\x91x\xa5\xf2\xa3\t"\x1e4\xb8\xd8\xc4.\xc8\x0be\x9c\x87yI\xbb_\xecv$\x88\x1b"\xb0\'\xe6\x86 \x82\
xee\xebhG\xe6\x86\xb4\x12}\xec\n\x84(\x94q>\x1d\x9f\xdeY\xb0\xff\xe6\n\x7f\xbc\x9c\xcd\xcd\x85qc\xfe\x9d\x80\x8bJ4{\xf82|\x8cd\x1a\xdaqI\xe4N\x9c\x9e\xae\x83\x9dI\xbe`\rC\x82x\xbbI\x1cL\xca\xb2Y\x1fg5 \x0eP\xecVh\xbc\xa0\xee\x97\\\xf0\xe0 \x18n\x0c\x93\xcb\x0c\xd4\xffH8\
xeb\'-f\xda\xf2lZm\x16mW\xbd\xe1\xcc\xd6\x8d\x17\xa8\x13r>\xfaE\xa6\xfa\xab\xc52\x1b~\xbc,\xaaP\xd7`\xa2\xabP.\x86\xdfC\x08\x0e\xbb\xa4\xfa\xda\xc8gc\t\xaa\xda\xc8\x16)\x19F\xd5\x03\xeb#\xb2!\xe9\xa8h\xa0f\x05\x04\xd0h\xb8\xef\x93>\x8b\x8e\xc5\xa2\x8eF\x93\x88\n\xd1\x88\
x15T\xb5*,\xb8\xc5HH\xd8\xd2\xc2\xeb\x8em\x011\x993\x14\x90M\xcar!-rYZ\xc4\xffK\xcb\xff\x96\xb4\x88\xffA\xd2"Q\xd2"\xfe\xf7K\x8b\x08\x01\xb4\x1c\x85\x1e~\xd2o%-/\x0f\xf7\x92\xb4\xdc\'\xe2"\xeb|cq!\x05\x95v\x8f\xafp\x03\xda5\x83\xd4o\x94\xd8\x96\xb2\xd9jb\xf5\xb2\xc7\x15\
x04\x1bY\x19K(X\xa7MUTU\x15\x81X\xbf\xb4*{\x1c\x19p\xbe\xed\xa9\xc7\x93T\x1c\x8b\xb9\xaa$\xfe\xe6\x95rc\xc6\xc3R\xca_,\x1d\x9c\xba<\xf8\xaa\xcf\x19\r!\xf5\x1b]S\x96.$\xf3u\x8a\xd2\xc5irqK_\xc0\x8e\xd7\xde\xc3.\xbf\x96%\x1b\xc9E\xf8\xec*;\xa3&\xca\x96\xa2\x8a#EWQ\xdft\x14
\xfa\x8ck\xd3\x98\xdeO\x977\xf7H\x9a\xcc\xfc\xd4\'Q\x92(\x00\xd5\xb5\x01\x85\xca\xb3\xe4\x0f\xeb\xd9\xd6l\xc8\x12l\xd1\xb2U\xc7\xa6XR\xcd,tAj.\xa6\xc6\x9a\x81\x13\xa0\xad(\xc8\xbfU\x9c\\7\xad\x19O\xd1l[\xb7,H\xf1\x94\x9ay+s=[N\xbf\x0e\x93G#Ur\x04\x8b\x82\xa9u\xe3\x9a\xd0
\x14\x00\xf1\xcc&Q4\xadf\x1a\xd2\xf2\xe5\xedz\xc2\x08\x84\xe8H<\n\xabN\xe1Fu\xe3\x9a\xf1\x14A\xd4mI\xa0;\x89^3\x0f]\xc33\x82\xa0\n\xb2,\xa9\x0e\xed7P7\x8d\xcd\x12,Y\xd7\x1d\x8dfY5\xb3\xae\x97\x9b-\xc3,\x1b\x8cFPP)\x94]7\xab\x01K\xb1dWV\xe8`:\'\xcd\xda\xdc_\xad\x97\xb7+\x
06\x11\xe5\xd5#\x1d\xd0\xf1\x84\xa7\xadk\x84\xd4$\xd4\x835H\x0f.\xb7f\xe4\x0f\xb7\xe6-k\xdc\x03\xd9\xd1\x14\x87\x1aX\x02_7\xaf\t\xcc\x06\xba\xad9<\x05\xabk\x1bR`\x06I\x03\x8a\xad*T\xaf\x15NH\x1b\x13%\x8d\x04y\x84aUT]\xd9\xb6\xcb\xbf\x98\x0b\xc6\xe0\x04\xd2H\xd7%\x97b\x9d
\x90\xb5\x060\xcd\xb1$\t\xb8\xb4auM\x9b,\x17[\xf3GF\xcfEr&;b\xad\x99\'D\xad\x11NE\xa9\x8b.\xdb\xd4| \xd4U\xcd\x98L\x96\xb7\x0b\x06M\x96d\x91\xd7\\:\x9c\'D\xad\x11N\x1d\x89\xa2\x8e\x9aK\xe1\xea\x9af\xcc\x8d\xf5\r\xc34G\x81\xb6\xeaRB$\x9c\x10\xb5\x060\xa4\xd3\x82\n\x1c:\x0
8uU\x9b-6\xdb\xf5\xedd;[\xb2:\x89\xea\xb8\x9a\xe5\xd0=\xee\x84\xb85F\xaa\x8a\xaci\x82\xa4Q\xc8\xba\xc6\xdd\xcd\xcc\x0f\x8c\xb1\xa5\x02\xd1\x82.\x1d\x88\x13\xe2\xc6f\xa9h:\x90\xa1D\x8bG]\xd5P\xda9\x9fM\x0c\xdc\xd0{4\xcf\xdc\xb1\xa6\x1aE\xd3E[S(\x17\x8a\'$\xee\\\xb2:\xb2\x
1c\x11\xdaT.\'\xd6\xf5n\xb2\x9c\xcf\xcd\x06\xa1\xe1U^B\x17\xcb\xd9\xa8SS\xe0\t\xd9kJTu\xcd\x15lU\xa0\x88\xb9\xfa]N\xb6$6\xf7\xab\xd9|\xc9\x1a\xc5\xfcHGs\xadJ\xb1\xe42\xcb@\xff\x9a\xa0\xe0HWDQ\xa3PJ\x195A\xeeC\xad\xbd\x99^2X2\xf2\x1a\xca\x82)\x96J\x9b\xd5\xa0\x0b:\x96\x0e
e\xe8R$\xadL\x9a\x1b\xb7\x8b\xc95\x9av\xaef\x0b\xd6t\xe8Z(\x9a\xb2H\xe1Fe\xdcf\xbb\\5\x82\xa1<S\xd6\xa4\x11O\xc1\xf4Z 7\x93\xf5l\xc5p?\xaf\xf3\xd2HT\x01\x05\x03e\x989\x9dm\x9b\xc1l\xc5\x02\x922\xa2`V\xcd\xb2\xf9\xf2\x8aA"*\xecH\x14\xc9\xae\x91\x9ak\x9d\x8e:\x87-\xd0D\xa7
\x1a\x024\xe27\xdb\xd9d\xc3\x90b\x17\xc8\xa2%\xd1N\x83e\xd65\x02-\xd7\xb3\t3\x96\xaa\xe3Xt\xc7p+\xee\xbf3\x17[<Wo\x96sF\xd7\xe0\x15$\xc1\x12\xa4\x1a)\xf1e\xdc\xda\xbcY\xa2\xc1\xb4]\x1b\x8b\xcd\xa5\xb9f%\x13\x9a\xac\xbb\x82.SD\xa1L\xdcN/\xefWscq\x7fa^.\xd7\x8d\xd1\x8acY\x
aa\xa4Q\xbdE\x12\xcb\xe8\x9b\xdb\xf9v\x86T\xce\x981\xc2+\xa1\xd1\xa4:"\xddr\xa9\xdar\xfc$\x15\xa3\xbd\xb2\x8br\xa7\x11\x15ZI\xae\xca\x11\xca\x9b\x8c\x0bF\x1f\xd1\x05^R%H\x81*\xba65W\xf3\xe5O7&+\xcbA\x99\x84\x80\xe6RJ\x8d\xa4\x8a\xaea\xcfO\x8c\r\x1e\xa8\xd7\xe6\xf4\x96\xd
5S\x10Q\xd0EK\x7fi\xb9\x83LX(\xa3\xbeG\xc7\\o\xcf_4\x81\xc5z\xc8\xa2\xbe~rZ\xbd\x05\x94E8\xfa\x89\x15\x9b\xf2\x94\xf7\xdb\xd84\x1e\x16\xeb5c\xc3\xb6\xf1\x82w\xb6x\x93n&w\x9f\'\x93\xfc<#\xc9E\x97_\xd4\xc8(\xcc%\x8f\xed\x94\x9e\x9a9\xe2\x07\x91\x16\xc5\xae\x03\x88\xa2/A\x8
8\x97\xc0E\xdb\xc5\x99\xe11\x82\xf3\xa9\xb1\xc2k\xb8\'\x9e\x91)\xad\x90U\x9e\x18jd\x12y\xa0h\n]p\xdc\xc7S/:\xec\xc13Y\xb4\xc7\xcby\xafQ\xb2\x93?`47.\xcc\xf9\xfd\xf2\xe2=J)\xee\xf12\xf8\xd7\x9f0J}\x93\xb8\xb0\xec7l\xa3\xeb\xed\xf3\x9a\xe9&\xb1x\xb5\xceW\'UA\x12mkd\x7f\xc5
\x89\xf7\x87\xd0-;\xb2\xec\x1a\x8c\xacF\xeb\xc4\x9e\xe6^r\x12\x07\x915\xf5"\x88U\x07\x9c:ev\xc2\xf2\x9a_\xad\xbc\xcf+\x046\xbc\xc3D\xc0\x86w\xc8M\xd9\xf0v\t\t\x9b\xdb!\xa3`\xc3[$>Lh\xfb\x95S6\xfa\xfcY\x8e\xcd\xec2I\xb1\xe9}\xe4!\r\xce\xd2b\xb1\x89Mm\xb7\xb2\xc6\xe6\xb6Y9
m@m\xb9|\xc4&\xb7\xbd\xb3\xd0\x80|\xfer#\x1b\xda\xee\xa2\x8d\xc9my\xfd\xd6\x84\xdb\xeeZ\x82Mn\xb7\xd8\xc9\xe6\xb6\xbe\xc3\xc1D\x9f\x7f=\xc0F\xb6\xba\xc9\xc6\xc6\xb6Z9cc[-v3\xb1\xadV~\xd8\xd4\xf3R\xffa\xf9b\x82\ro\xbb\xe4\xcc&\xb7XobC[\xde\x93d\x83\xdb\xado\xb3\xb9\xadV\x
f0\x98\xd8V\xb7+\xd9\xd4\x1e\x96\x80\x1b\x9c\xa4\xd5=j6\xb7\xed\rf6\xb9\xddZ\x0c\x93\xdb\xe9\x9e\'\x9b\xde\xea64\x1b\xdb\xe6\xb6H\x03j\xfb\x1b\xcalx\xcb\x9btlp\xab\x1bl\r\xb0\xad\xef\x97\xb0\xd9\xadVz\x1b`\xdb\xdc?i\x80\xed|\xb3\x8b}\x8e\xb3\x16\xfb\xce\x9b]\xdb=s\xc1\xc
6\xb6\xbd\x01\xc3$\xb7z\xec\x8aMm\xf5$\x06\x1b\xdb\xe5\xa6/\x9b\xdej\x8d\x9a\x8dm\xf98\x03\x1b\xdc\xe2\xbeKi\xd9\xae\xf2H^V\x98,]\x96W+\xc7s\xcf\xff\x94\xfe]Z\xf2\x07\xda\xe9\x86\xb1\x07\xe1c\xfa}I\xd6\x9e\xcb%\xe9\xea*y$\xb1\xb6Pzb\xe7s\xb2(\x8b\x9f\xd9|\x1d\xed\xc0\x01
\xe6k\xb0!"\x03\xffa\x0f\xf3\xf5\xf2&\x87\xdfy\x91g\xed\x0bJ\x1c\x1e\x1b\x03\xac t`\xd8\x85\x80\xff\x98\xab\xbb\x05\xf9\xa1\x11\xfe\x0bk\xa1\xf1\xc1\xc0\xfe\xf4\x10\x06G\xdf\xc9\x01\xafDM6/\x1a\x13\xdc \x844\xe1\x92|\xcek\xc0$\xd8\x07E+^%\x1d\xb4)\xe2\x8b\xe7\xc4\xbb\xfc
`Ao|\xe0\x0e\xe2\x9e\x9d\x1f\xa96>\xd0\r\xfc\xe2\xb0-\xd8\xa1\xde\xfeJ\x10^\xb9`\x1f\xc1\xe4wc\x13\x82\xd0\xfb\x15\xd1\xc0\xde\xd8{\x0f\xe4\x1eK\x0en\xde\x8e\x1c\xb2E\xddi\x15D\x1e~\xdc\xf7|\x8eg\x07>\xdd\x19\xcfj\xcdg<x\xedNm\xc9\x10\xddZ\x92\xde\xf6\xe8*\x10\x15L\'\xcf
d\xa4\xd3\x8a\xd1\n\xd5U:\xaa&\xb5\x94\x90\x1c\xd2YJ2\xd2)I9O\x0f\xaa\r\xeb$-\x19\xaa\xb5\xc4d\x80\xd6RS\xb8\xa5/\xc9\xc9M\xeaCz\xea\xb0~\x06ng)\xca@=H\x12\x8d\xea\xd6\xc2\xa7=J\x93\xba\nS\t\xd2E\x02\x12L\xf7,&\xe1t\x15\xa4\xb25-\xe5(E\x9c\x10\xa3\xcb\xcbs\xc6}\xc2\xe9.E
\xe5&u\x12\xa2\x04\xd4Z\x86\x92\xc3)\x11\x92\xcevG_\x12\x94\x9a\xd3\x87\x00\xd1\xa8>\x06gg\xf1I0=HO\x15\xd4\xadm\xe0p\xe8*;9\xa2\xcb0\xc7\x90\xee\x92\x83)]\x05\xa7\xb0\xa4\xa5\xdc\x10@\xe7\xcc\x07S\xba_H\x15\x8d\xe9$4\x18\xd3Zf\xf0\xc1\xad3\x9d\xc4\r}I\x0c1\xa5\x0f\x81\x
a9\x82\xba\x0f\xc1\xce\xe2\x82!=HK\x19\xd3\xbdU\xf8o\xaa=\xff\xe1\xf4\xd4;\xb94y\xb9\r\xad\xfb\x04\x8ci\xe1\x91\xbc\xd5\xe5\xa4m\xbc|i^N\xda\xd0\xfa\xb1\xcd\xf5|/\xdaA\xe7E\xe3\xces\\\x8e\xeb\xc7:\x18\x86A\xf8BL\xf1\xfb.\xceg\xf5c\x17~\x17\x03j\xe5q\xff\x82\xe3&\xf2D\x9c
\x9ce]\x99\xd8\x8f\x8dG\xff\xeb6\xe2Qq^\xcf+\x13{\xf2\xa3\xe7\xba\x9e\x8d*y0z!k\x9e\x8c: \xfb\xf2\xa4\x03]\xfc*\x91\x9e\xd4\xa5\xe0u\xb7\xefc`uM\xaarD\x97T\x06C\xba\'U\x98\xd25\xa9*,i\x99T\x11@\xe7\xa4\nS\xba\'UEc:%U\x18\xd3:\xa9\xc2\x07\xb7N\xaa\x127\xf4\x95T\x11S\xfaH\
xaa\xaa\xa0n\xe9\x07fuN\xaa0\xa4\x87\xa4\xaa\x8c\xe9\xde\xaa\xfe\x92\xaa2\xad\x1f\xd1\xeb/\xa9*\xd3\xfa\xb1\xad\xc7\xa4\xaa\x82\xeb\xc7\xba\xbe\x92\xaa\x82\xd5\x8f]\xfd&U4\xb1\x1f\x1b\xfbM\xaahbO~\xec7\xa9\xaa!\xfb\xf2d\x7fIU\x95\xd7\xc9>\xb2\xde\x85~\xc1\x0f\x95\xe92}s\
xeax\xf8\xf2\xd3\x02\xe3\x99\x1f\xa1<\xc5&o:*?lP/\xcf^\xa8^\xddJ^\xf9\x9a\x94\xcd\xec\xbc\xf2\xfb\xc0*\xbdCi\x03C\xfc.m\xb4\x0b\xd9B\x1erx\xf7\xcd\xbf\x00\x17\xff\xd2\x94'
>>> ziptext = base64.b64decode(text)



>>> ziptext.decode('zlib')
ou
>>> zlib.decompress(ziptext)
b'<?xml version="1.0" encoding="UTF-8"?>\n<Domain name="b71f2f8cc16b" stamp="VTEXPORT : 6.1.3 FR LINUX_X64 2017/05/03 Visual Tom (c) Absyss" version="6.1.3" generationDate="Thu Oct 19 12:49:48 2017">\n  <Properties/>\n  <Calendars>\n    <Calendar id="CAL1" name="c" year=
"2017" publicHolidays="1" specificDays="0" firstInWeek="0" lastInWeek="0" firstInHalfMonth="0" lastInHalfMonth="0" firstInMonth="0" lastInMonth="0" firstInYear="0" lastInYear="0" daysInWeek="wwwwwhh" daysInYear="" holidaysGroupSId="SHG00000000000000000000000000000001"/>\
n  </Calendars>\n  <Dates>\n    <Date id="DAT1" name="d" type="A" value="2017/10/19" recovery="0" blocked="0" tz="0" switchTime="24:00:00"/>\n  </Dates>\n  <Periods/>\n  <Hosts bdaemonPort="30004" managerPort="30000">\n    <Host id="HOS1" name="localhost" comment="" host
name="localhost" ipv4="127.0.0.1" ipv6="" os="Linux x64" version="BDAEMON : 6.1.3 FR LINUX_X64 2017/05/03 Visual Tom (c) Absyss&#10;" message="" bdaemonPort="0" bdaemonStatus="R" managerPort="0" managerStatus="S" lastUpdate="1508332429227">\n      <Properties>\n        <
Property id="HOS1" key="MAVARTOMTOM" value="Bonjour \xc3\xa7a va ?"/>\n      </Properties>\n    </Host>\n  </Hosts>\n  <HostsGroups>\n    <HostsGroup id="HGR1" name="localhost" comment="" mode="S">\n      <Hosts>\n        <Host id="HOS1"/>\n      </Hosts>\n      <Propert
ies/>\n    </HostsGroup>\n  </HostsGroups>\n  <Queues>\n    <Queue id="QUE1" name="queue_ksh" comment=""/>\n  </Queues>\n  <Users>\n    <User id="USE1" name="vtom" comment=""/>\n  </Users>\n  <Resources>\n    <Resource id="RES1" name="f1" type="F" host="localhost" hostSI
d="HOS1">\n      <Value><![CDATA[/var/tmp/tatest_*.txt]]></Value>\n    </Resource>\n    <Resource id="RES2" name="f2" type="F" host="localhost" hostSId="HOS1">\n      <Value><![CDATA[/var/tmp/dirtest]]></Value>\n    </Resource>\n  </Resources>\n  <Contexts/>\n  <Environm
ents>\n    <Environment id="ENVac11000257648d3559e753a700000001" xid="ENV1" name="env1" scriptsDir="" calendar="CAL1" date="DAT1" hostsGroup="HGR1" queue="QUE1" user="USE1" enginePid="149" lastAskOfExploitation="1508333050000000" lastUpdate="1508333050177">\n      <UsedC
alendars ids="CAL1"/>\n      <UsedDates ids="DAT1"/>\n      <UsedHostsGroups ids="HGR1"/>\n      <UsedQueues ids="QUE1"/>\n      <UsedResources ids="RES1 RES2"/>\n      <UsedUsers ids="USE1"/>\n      <UsedPeriods/>\n      <UsedContexts/>\n      <Applications>\n        <A
pplication id="APPac1100026639757659e753b900000001" xid="APP1" name="app1" retained="0" comment="Another Change commentaire" frequency="D" onDemand="0" isAsked="0" cycleEnabled="0" cycle="00:00:00" minStart="00:00:00" maxStart="23:59:59" mode="J" status="F" descOnErr="1"
 exploited="E">\n          <Planning planning="1" formula="0" daysInWeek="WWWWWWW" daysInMonth="BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB" weeksInMonth="11111" monthsInYear="111111111111"/>\n          <Jobs>\n            <Job id="JOBac1100022458985359e7542300000002" xid="JOB2" nam
e="job_1" retained="0" information="Traitement termine (0)" frequency="D" onDemand="0" isAsked="0" cycleEnabled="0" cycle="00:00:00" minStart="00:00:00" maxStart="23:59:59" mode="E" retcode="0" status="F" appInErr="1" descOnErr="1" blockDate="1" restartType="M" restartCo
unt="0" restartMax="1" restartLabel="0" timeBegin="1508371201" timeEnd="1508371204" ipid="0" exploited="E">\n              <Script><![CDATA[/var/tmp/osef.sh]]></Script>\n              <Parameters>\n                <Parameter><![CDATA[{f1,FILENAME}]]></Parameter>\n
       </Parameters>\n              <ExpectedResources>\n                <ExpectedResource resourceUsed="RUS1" resource="RES1" operator="P" wait="1" startAfter="0" free="1">\n                  <Value></Value>\n                </ExpectedResource>\n              </Expected
Resources>\n              <Node nodeSId="GNOac1100020426e97e59e753e400000002" graphSId="GRAac11000253e678c259e753b900000002" objectType="job" objectSId="JOBac1100022458985359e7542300000002" label="job1" x="222" y="166"/>\n            </Job>\n            <Job id="JOBac110
00209dcba2659e755a500000004" xid="JOB4" name="job_2" retained="0" information="Traitement termine (0)" frequency="D" onDemand="0" isAsked="0" cycleEnabled="0" cycle="00:00:00" minStart="00:00:00" maxStart="23:59:59" mode="E" retcode="0" status="F" appInErr="1" descOnErr=
"1" blockDate="1" restartType="M" restartCount="0" restartMax="1" restartLabel="0" timeBegin="1508371201" timeEnd="1508371204" ipid="0" exploited="E">\n              <Script><![CDATA[/var/tmp/osef.sh]]></Script>\n              <Parameters>\n                <Parameter><![
CDATA[{f2,FILENAME}]]></Parameter>\n              </Parameters>\n              <ExpectedResources>\n                <ExpectedResource resourceUsed="RUS3" resource="RES2" operator="P" wait="1" startAfter="0" free="1">\n                  <Value></Value>\n                </
ExpectedResource>\n              </ExpectedResources>\n              <Node nodeSId="GNOac1100022eaebd5659e755a500000003" graphSId="GRAac11000253e678c259e753b900000002" objectType="job" objectSId="JOBac11000209dcba2659e755a500000004" label="job1_1" x="490" y="166"/>\n
        </Job>\n          </Jobs>\n          <Graph graphSId="GRAac11000253e678c259e753b900000002" objectSId="APPac1100026639757659e753b900000001" name="app1"/>\n          <Node nodeSId="GNOac110002256398b659e753b100000001" graphSId="GRAac110002556662a259e753a700000001"
objectType="app" objectSId="APPac1100026639757659e753b900000001" label="app1" x="265" y="105"/>\n        </Application>\n      </Applications>\n      <Graph graphSId="GRAac110002556662a259e753a700000001" objectSId="ENVac11000257648d3559e753a700000001" name="env1"/>\n
</Environment>\n  </Environments>\n  <Rights>\n    <Right id="RIGac110002724b5628596755d500000001" name="READ_DOM_DATE"/>\n    <Right id="RIGac110002321a6fca596755d500000002" name="WRITE_DOM_DATE"/>\n    <Right id="RIGac1100021c2bc6dc596755d500000003" name="READ_DOM_CALE
NDAR"/>\n    <Right id="RIGac11000211ec5502596755d500000004" name="WRITE_DOM_CALENDAR"/>\n    <Right id="RIGac11000257cc9bbe596755d500000005" name="READ_DOM_PERIOD"/>\n    <Right id="RIGac11000248863d1b596755d500000006" name="WRITE_DOM_PERIOD"/>\n    <Right id="RIGac1100
025ae12043596755d500000007" name="READ_DOM_RESOURCE"/>\n    <Right id="RIGac1100022d301a69596755d500000008" name="WRITE_DOM_RESOURCE"/>\n    <Right id="RIGac1100025129c31a596755d500000009" name="READ_DOM_USER"/>\n    <Right id="RIGac110002614436db596755d50000000a" name="
WRITE_DOM_USER"/>\n    <Right id="RIGac1100021b499d7b596755d50000000b" name="READ_DOM_HOST"/>\n    <Right id="RIGac1100026ca88e16596755d50000000c" name="WRITE_DOM_HOST"/>\n    <Right id="RIGac11000265b4f453596755d50000000d" name="READ_DOM_HOSTS_GROUP"/>\n    <Right id="R
IGac110002604289a9596755d50000000e" name="WRITE_DOM_HOSTS_GROUP"/>\n    <Right id="RIGac110002734887e2596755d50000000f" name="READ_DOM_QUEUE"/>\n    <Right id="RIGac1100021a4d75de596755d500000010" name="WRITE_DOM_QUEUE"/>\n    <Right id="RIGac1100021ca9c7d0596755d5000000
11" name="READ_DOM_ENV"/>\n    <Right id="RIGac11000217a5c65a596755d500000012" name="WRITE_DOM_ENV"/>\n    <Right id="RIGac110002381485c6596755d500000013" name="READ_DOM_TOKEN"/>\n    <Right id="RIGac1100022a38993f596755d500000014" name="WRITE_DOM_TOKEN"/>\n    <Right id
="RIGac1100027db33af6596755d500000015" name="READ_DOM_CONTEXT"/>\n    <Right id="RIGac1100021b54d2c6596755d500000016" name="WRITE_DOM_CONTEXT"/>\n    <Right id="RIGac110002667894cc596755d500000017" name="READ_DOM_ACCOUNT"/>\n    <Right id="RIGac110002434207fa596755d50000
0018" name="WRITE_DOM_ACCOUNT"/>\n    <Right id="RIGac1100026822954d596755d500000019" name="READ_DOM_ALARM"/>\n    <Right id="RIGac1100024d5ec6fb596755d50000001a" name="WRITE_DOM_ALARM"/>\n    <Right id="RIGac11000200816ad6596755d50000001b" name="READ_DOM_INSTRUCTION"/>\
n    <Right id="RIGac11000276df7bdf596755d50000001c" name="WRITE_DOM_INSTRUCTION"/>\n    <Right id="RIGac11000265477137596755d50000001d" name="READ_DOM_VIEW"/>\n    <Right id="RIGac11000236a2befd596755d50000001e" name="WRITE_DOM_VIEW"/>\n    <Right id="RIGac11000269d74e3
0596755d50000001f" name="READ_DOM_APPLICATION_SERVER"/>\n    <Right id="RIGac1100025792c75f596755d500000020" name="WRITE_DOM_APPLICATION_SERVER"/>\n    <Right id="RIGac11000268bd2ec8596755d500000021" name="READ_DOM_COLLECTION"/>\n    <Right id="RIGac1100020603150c596755d
600000022" name="WRITE_DOM_COLLECTION"/>\n    <Right id="RIGac110002697f1c61596755d600000023" name="FCT_VIEW_PILOT"/>\n    <Right id="RIGac1100024089ca86596755d600000024" name="FCT_ACT_PILOT"/>\n    <Right id="RIGac1100024e895227596755d600000025" name="FCT_CREATE_MDF"/>\
n    <Right id="RIGac11000244603ca5596755d600000026" name="FCT_ACT_VIEW"/>\n    <Right id="RIGac1100026db9e4ef596755d600000027" name="FCT_LAUNCH_ENGINE"/>\n    <Right id="RIGac1100021fb31542596755d600000028" name="FCT_STOP_ENGINE"/>\n    <Right id="RIGac11000225a47380596
755d600000029" name="FCT_VIEW_SCRIPT"/>\n    <Right id="RIGac1100020903826a596755d60000002a" name="FCT_EDIT_SCRIPT"/>\n    <Right id="RIGac1100020c5ba358596755d60000002b" name="FCT_VIEW_LOG"/>\n    <Right id="RIGac1100020b5967d3596755d60000002c" name="FCT_VIEW_INSTRUCTIO
N"/>\n    <Right id="RIGac11000269460c13596755d60000002d" name="FCT_STATISTICS"/>\n    <Right id="RIGac1100027fa42b3a596755d60000002e" name="FCT_HISTORIC"/>\n    <Right id="RIGac11000225a6ddb2596755d60000002f" name="FCT_EVENT_CONSOLE"/>\n    <Right id="RIGac11000205efd3e
3596755d600000030" name="FCT_REMOTE_TRANSFERT"/>\n    <Right id="RIGac1100021749f194596755d600000031" name="FCT_TDF_PLAN_BEFORE_TRANSFERT"/>\n    <Right id="RIGac1100025dbb6378596755d600000032" name="FCT_MULTIDOMAIN"/>\n    <Right id="RIGac11000230286d23596755d600000033"
 name="FCT_REPORT"/>\n    <Right id="RIGac11000214fd2c8a596755d600000034" name="FCT_CRONTAB"/>\n    <Right id="RIGac1100027910363e596755d600000035" name="FCT_DEPLOYMENT"/>\n    <Right id="RIGac11000216a101ef596755d600000036" name="FCT_FORECAST_SCHEDULE"/>\n    <Right id=
"RIGac1100026a1192b959e753a700000001" name="READ_ENV_RIGHT" objectSId="ENVac11000257648d3559e753a700000001" environmentName="env1"/>\n    <Right id="RIGac11000241236d9259e753a700000001" name="WRITE_ENV_RIGHT" objectSId="ENVac11000257648d3559e753a700000001" environmentNam
e="env1"/>\n  </Rights>\n  <Accounts>\n    <Account id="ACCac110002583f3484596755d600000001" name="TOM" comment="" usualName="TOM" password="02cf1b" useLDAP="0">\n      <Properties>\n        <Property id="ACCac110002583f3484596755d600000001" key="DefaultDisplayLabelType.
APP" value="LABEL_OBJECT_NAME"/>\n      </Properties>\n    </Account>\n  </Accounts>\n  <Profiles>\n    <Profile id="PROac1100026132cb8c596755d600000001" name="TOM_prf" comment="">\n      <ProfileAccounts>\n        <ProfileAccount id="ACCac110002583f3484596755d600000001"
 default="1" name="TOM"/>\n      </ProfileAccounts>\n      <ProfileRights>\n        <ProfileRight id="RIGac11000200816ad6596755d50000001b" name="READ_DOM_INSTRUCTION"/>\n        <ProfileRight id="RIGac11000205efd3e3596755d600000030" name="FCT_REMOTE_TRANSFERT"/>\n
 <ProfileRight id="RIGac1100020603150c596755d600000022" name="WRITE_DOM_COLLECTION"/>\n        <ProfileRight id="RIGac1100020903826a596755d60000002a" name="FCT_EDIT_SCRIPT"/>\n        <ProfileRight id="RIGac1100020b5967d3596755d60000002c" name="FCT_VIEW_INSTRUCTION"/>\n
       <ProfileRight id="RIGac1100020c5ba358596755d60000002b" name="FCT_VIEW_LOG"/>\n        <ProfileRight id="RIGac11000211ec5502596755d500000004" name="WRITE_DOM_CALENDAR"/>\n        <ProfileRight id="RIGac11000214fd2c8a596755d600000034" name="FCT_CRONTAB"/>\n        <
ProfileRight id="RIGac11000216a101ef596755d600000036" name="FCT_FORECAST_SCHEDULE"/>\n        <ProfileRight id="RIGac1100021749f194596755d600000031" name="FCT_TDF_PLAN_BEFORE_TRANSFERT"/>\n        <ProfileRight id="RIGac11000217a5c65a596755d500000012" name="WRITE_DOM_ENV
"/>\n        <ProfileRight id="RIGac1100021a4d75de596755d500000010" name="WRITE_DOM_QUEUE"/>\n        <ProfileRight id="RIGac1100021b499d7b596755d50000000b" name="READ_DOM_HOST"/>\n        <ProfileRight id="RIGac1100021b54d2c6596755d500000016" name="WRITE_DOM_CONTEXT"/>\
n        <ProfileRight id="RIGac1100021c2bc6dc596755d500000003" name="READ_DOM_CALENDAR"/>\n        <ProfileRight id="RIGac1100021ca9c7d0596755d500000011" name="READ_DOM_ENV"/>\n        <ProfileRight id="RIGac1100021fb31542596755d600000028" name="FCT_STOP_ENGINE"/>\n
    <ProfileRight id="RIGac11000225a47380596755d600000029" name="FCT_VIEW_SCRIPT"/>\n        <ProfileRight id="RIGac11000225a6ddb2596755d60000002f" name="FCT_EVENT_CONSOLE"/>\n        <ProfileRight id="RIGac1100022a38993f596755d500000014" name="WRITE_DOM_TOKEN"/>\n
  <ProfileRight id="RIGac1100022d301a69596755d500000008" name="WRITE_DOM_RESOURCE"/>\n        <ProfileRight id="RIGac11000230286d23596755d600000033" name="FCT_REPORT"/>\n        <ProfileRight id="RIGac110002321a6fca596755d500000002" name="WRITE_DOM_DATE"/>\n        <Prof
ileRight id="RIGac11000236a2befd596755d50000001e" name="WRITE_DOM_VIEW"/>\n        <ProfileRight id="RIGac110002381485c6596755d500000013" name="READ_DOM_TOKEN"/>\n        <ProfileRight id="RIGac1100024089ca86596755d600000024" name="FCT_ACT_PILOT"/>\n        <ProfileRight
 id="RIGac11000241236d9259e753a700000001" name="WRITE_ENV_RIGHT/env1"/>\n        <ProfileRight id="RIGac110002434207fa596755d500000018" name="WRITE_DOM_ACCOUNT"/>\n        <ProfileRight id="RIGac11000244603ca5596755d600000026" name="FCT_ACT_VIEW"/>\n        <ProfileRight
 id="RIGac11000248863d1b596755d500000006" name="WRITE_DOM_PERIOD"/>\n        <ProfileRight id="RIGac1100024d5ec6fb596755d50000001a" name="WRITE_DOM_ALARM"/>\n        <ProfileRight id="RIGac1100024e895227596755d600000025" name="FCT_CREATE_MDF"/>\n        <ProfileRight id=
"RIGac1100025129c31a596755d500000009" name="READ_DOM_USER"/>\n        <ProfileRight id="RIGac1100025792c75f596755d500000020" name="WRITE_DOM_APPLICATION_SERVER"/>\n        <ProfileRight id="RIGac11000257cc9bbe596755d500000005" name="READ_DOM_PERIOD"/>\n        <ProfileRi
ght id="RIGac1100025ae12043596755d500000007" name="READ_DOM_RESOURCE"/>\n        <ProfileRight id="RIGac1100025dbb6378596755d600000032" name="FCT_MULTIDOMAIN"/>\n        <ProfileRight id="RIGac110002604289a9596755d50000000e" name="WRITE_DOM_HOSTS_GROUP"/>\n        <Profi
leRight id="RIGac110002614436db596755d50000000a" name="WRITE_DOM_USER"/>\n        <ProfileRight id="RIGac11000265477137596755d50000001d" name="READ_DOM_VIEW"/>\n        <ProfileRight id="RIGac11000265b4f453596755d50000000d" name="READ_DOM_HOSTS_GROUP"/>\n        <Profile
Right id="RIGac110002667894cc596755d500000017" name="READ_DOM_ACCOUNT"/>\n        <ProfileRight id="RIGac1100026822954d596755d500000019" name="READ_DOM_ALARM"/>\n        <ProfileRight id="RIGac11000268bd2ec8596755d500000021" name="READ_DOM_COLLECTION"/>\n        <Profile
Right id="RIGac11000269460c13596755d60000002d" name="FCT_STATISTICS"/>\n        <ProfileRight id="RIGac110002697f1c61596755d600000023" name="FCT_VIEW_PILOT"/>\n        <ProfileRight id="RIGac11000269d74e30596755d50000001f" name="READ_DOM_APPLICATION_SERVER"/>\n        <P
rofileRight id="RIGac1100026a1192b959e753a700000001" name="READ_ENV_RIGHT/env1"/>\n        <ProfileRight id="RIGac1100026ca88e16596755d50000000c" name="WRITE_DOM_HOST"/>\n        <ProfileRight id="RIGac1100026db9e4ef596755d600000027" name="FCT_LAUNCH_ENGINE"/>\n        <
ProfileRight id="RIGac110002724b5628596755d500000001" name="READ_DOM_DATE"/>\n        <ProfileRight id="RIGac110002734887e2596755d50000000f" name="READ_DOM_QUEUE"/>\n        <ProfileRight id="RIGac11000276df7bdf596755d50000001c" name="WRITE_DOM_INSTRUCTION"/>\n        <P
rofileRight id="RIGac1100027910363e596755d600000035" name="FCT_DEPLOYMENT"/>\n        <ProfileRight id="RIGac1100027db33af6596755d500000015" name="READ_DOM_CONTEXT"/>\n        <ProfileRight id="RIGac1100027fa42b3a596755d60000002e" name="FCT_HISTORIC"/>\n      </ProfileRi
ghts>\n    </Profile>\n  </Profiles>\n  <Links/>\n  <Domains/>\n  <Alarms/>\n  <ObjectAlarms/>\n  <DefaultGraphProperties>\n    <DefaultGraphProperty key="node.shape" value="rectangle"/>\n    <DefaultGraphProperty key="node.shapeVisible" value="true"/>\n    <DefaultGraph
Property key="node.borderVisible" value="true"/>\n    <DefaultGraphProperty key="node.textVisible" value="true"/>\n    <DefaultGraphProperty key="node.border" value="solid1"/>\n    <DefaultGraphProperty key="node.background" value="#274EB1"/>\n    <DefaultGraphProperty k
ey="node.foreground" value="#FFFFFF"/>\n    <DefaultGraphProperty key="node.borderColor" value="#000000"/>\n    <DefaultGraphProperty key="node.width" value="190"/>\n    <DefaultGraphProperty key="node.height" value="60"/>\n    <DefaultGraphProperty key="node.font" value
="Tahoma#11#false#false"/>\n    <DefaultGraphProperty key="node.horizontalAlignment" value="0"/>\n    <DefaultGraphProperty key="node.horizontalTextPosition" value="0"/>\n    <DefaultGraphProperty key="node.iconVisible" value="false"/>\n    <DefaultGraphProperty key="nod
e.verticalAlignment" value="0"/>\n    <DefaultGraphProperty key="node.verticalTextPosition" value="0"/>\n    <DefaultGraphProperty key="node.comment.shape" value="rectangle"/>\n    <DefaultGraphProperty key="node.comment.shapeVisible" value="false"/>\n    <DefaultGraphPr
operty key="node.comment.borderVisible" value="false"/>\n    <DefaultGraphProperty key="node.comment.textVisible" value="true"/>\n    <DefaultGraphProperty key="node.comment.border" value="solid1"/>\n    <DefaultGraphProperty key="node.comment.background" value="#274EB1"
/>\n    <DefaultGraphProperty key="node.comment.foreground" value="#000000"/>\n    <DefaultGraphProperty key="node.comment.borderColor" value="#000000"/>\n    <DefaultGraphProperty key="node.comment.width" value="190"/>\n    <DefaultGraphProperty key="node.comment.height
" value="60"/>\n    <DefaultGraphProperty key="node.comment.font" value="Tahoma#11#false#false"/>\n    <DefaultGraphProperty key="node.comment.horizontalAlignment" value="0"/>\n    <DefaultGraphProperty key="node.comment.horizontalTextPosition" value="0"/>\n    <DefaultG
raphProperty key="node.comment.iconVisible" value="false"/>\n    <DefaultGraphProperty key="node.comment.verticalAlignment" value="0"/>\n    <DefaultGraphProperty key="node.comment.verticalTextPosition" value="0"/>\n    <DefaultGraphProperty key="node.xlink.shape" value=
"rectangle"/>\n    <DefaultGraphProperty key="node.xlink.shapeVisible" value="true"/>\n    <DefaultGraphProperty key="node.xlink.borderVisible" value="true"/>\n    <DefaultGraphProperty key="node.xlink.textVisible" value="true"/>\n    <DefaultGraphProperty key="node.xlin
k.border" value="solid1"/>\n    <DefaultGraphProperty key="node.xlink.background" value="#FF0000"/>\n    <DefaultGraphProperty key="node.xlink.foreground" value="#000000"/>\n    <DefaultGraphProperty key="node.xlink.borderColor" value="#000000"/>\n    <DefaultGraphProper
ty key="node.xlink.width" value="190"/>\n    <DefaultGraphProperty key="node.xlink.height" value="30"/>\n    <DefaultGraphProperty key="node.xlink.font" value="Tahoma#11#false#false"/>\n    <DefaultGraphProperty key="node.xlink.horizontalAlignment" value="0"/>\n    <Defa
ultGraphProperty key="node.xlink.horizontalTextPosition" value="0"/>\n    <DefaultGraphProperty key="node.xlink.iconVisible" value="false"/>\n    <DefaultGraphProperty key="node.xlink.verticalAlignment" value="0"/>\n    <DefaultGraphProperty key="node.xlink.verticalTextP
osition" value="0"/>\n    <DefaultGraphProperty key="node.app.shape" value="rectangle"/>\n    <DefaultGraphProperty key="node.app.shapeVisible" value="true"/>\n    <DefaultGraphProperty key="node.app.borderVisible" value="true"/>\n    <DefaultGraphProperty key="node.app.
textVisible" value="true"/>\n    <DefaultGraphProperty key="node.app.border" value="solid1"/>\n    <DefaultGraphProperty key="node.app.background" value="#274EB1"/>\n    <DefaultGraphProperty key="node.app.foreground" value="#FFFFFF"/>\n    <DefaultGraphProperty key="nod
e.app.borderColor" value="#000000"/>\n    <DefaultGraphProperty key="node.app.width" value="190"/>\n    <DefaultGraphProperty key="node.app.height" value="60"/>\n    <DefaultGraphProperty key="node.app.font" value="Tahoma#11#false#false"/>\n    <DefaultGraphProperty key=
"node.app.horizontalAlignment" value="0"/>\n    <DefaultGraphProperty key="node.app.horizontalTextPosition" value="0"/>\n    <DefaultGraphProperty key="node.app.iconVisible" value="false"/>\n    <DefaultGraphProperty key="node.app.verticalAlignment" value="0"/>\n    <Def
aultGraphProperty key="node.app.verticalTextPosition" value="0"/>\n    <DefaultGraphProperty key="node.app.waiting.background" value="#FCFE04"/>\n    <DefaultGraphProperty key="node.app.waiting.foreground" value="#000000"/>\n    <DefaultGraphProperty key="node.app.runnin
g.background" value="#04FEFC"/>\n    <DefaultGraphProperty key="node.app.running.foreground" value="#000000"/>\n    <DefaultGraphProperty key="node.app.finished.background" value="#04FE04"/>\n    <DefaultGraphProperty key="node.app.finished.foreground" value="#000000"/>\
n    <DefaultGraphProperty key="node.app.error.background" value="#FC0204"/>\n    <DefaultGraphProperty key="node.app.error.foreground" value="#000000"/>\n    <DefaultGraphProperty key="node.app.descheduled.background" value="#C4C2C4"/>\n    <DefaultGraphProperty key="no
de.app.descheduled.foreground" value="#000000"/>\n    <DefaultGraphProperty key="node.app.unscheduled.background" value="#FCFEFC"/>\n    <DefaultGraphProperty key="node.app.unscheduled.foreground" value="#000000"/>\n    <DefaultGraphProperty key="node.app.difficulties.ba
ckground" value="#FFC800"/>\n    <DefaultGraphProperty key="node.app.difficulties.foreground" value="#000000"/>\n    <DefaultGraphProperty key="node.app.undefined.background" value="#FCFE04"/>\n    <DefaultGraphProperty key="node.app.undefined.foreground" value="#000000"
/>\n    <DefaultGraphProperty key="node.job.shape" value="rectangle"/>\n    <DefaultGraphProperty key="node.job.shapeVisible" value="true"/>\n    <DefaultGraphProperty key="node.job.borderVisible" value="true"/>\n    <DefaultGraphProperty key="node.job.textVisible" value
="true"/>\n    <DefaultGraphProperty key="node.job.border" value="solid1"/>\n    <DefaultGraphProperty key="node.job.background" value="#274EB1"/>\n    <DefaultGraphProperty key="node.job.foreground" value="#FFFFFF"/>\n    <DefaultGraphProperty key="node.job.borderColor"
 value="#000000"/>\n    <DefaultGraphProperty key="node.job.width" value="190"/>\n    <DefaultGraphProperty key="node.job.height" value="60"/>\n    <DefaultGraphProperty key="node.job.font" value="Tahoma#11#false#false"/>\n    <DefaultGraphProperty key="node.job.horizont
alAlignment" value="0"/>\n    <DefaultGraphProperty key="node.job.horizontalTextPosition" value="0"/>\n    <DefaultGraphProperty key="node.job.iconVisible" value="false"/>\n    <DefaultGraphProperty key="node.job.verticalAlignment" value="0"/>\n    <DefaultGraphProperty
key="node.job.verticalTextPosition" value="0"/>\n    <DefaultGraphProperty key="node.job.waiting.background" value="#FCFE04"/>\n    <DefaultGraphProperty key="node.job.waiting.foreground" value="#000000"/>\n    <DefaultGraphProperty key="node.job.running.background" valu
e="#04FEFC"/>\n    <DefaultGraphProperty key="node.job.running.foreground" value="#000000"/>\n    <DefaultGraphProperty key="node.job.finished.background" value="#04FE04"/>\n    <DefaultGraphProperty key="node.job.finished.foreground" value="#000000"/>\n    <DefaultGraph
Property key="node.job.error.background" value="#FC0204"/>\n    <DefaultGraphProperty key="node.job.error.foreground" value="#000000"/>\n    <DefaultGraphProperty key="node.job.descheduled.background" value="#C4C2C4"/>\n    <DefaultGraphProperty key="node.job.descheduled
.foreground" value="#000000"/>\n    <DefaultGraphProperty key="node.job.unscheduled.background" value="#FCFEFC"/>\n    <DefaultGraphProperty key="node.job.unscheduled.foreground" value="#000000"/>\n    <DefaultGraphProperty key="node.job.difficulties.background" value="#
FFC800"/>\n    <DefaultGraphProperty key="node.job.difficulties.foreground" value="#000000"/>\n    <DefaultGraphProperty key="node.job.undefined.background" value="#FCFE04"/>\n    <DefaultGraphProperty key="node.job.undefined.foreground" value="#000000"/>\n    <DefaultGr
aphProperty key="link.lineWidth" value="2"/>\n  </DefaultGraphProperties>\n  <Instructions/>\n  <ObjectInstructions/>\n  <Holidays/>\n  <HolidaysGroups/>\n  <Icons/>\n  <JobApplicationServers/>\n</Domain>\n'
```

Amaziiiing ! y a plus qu'à mettre ça dans un fichier.xml.




