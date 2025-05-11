---
layout: post
title: Anchor lien id name dans un mail HTML Outlook
date: 2017-01-11 20:45
author: Virtual Thom
categories: [mail, outlook, html, tag, anchor, id, name]
---
Sur Outlook, pour un mail au format HTML avec des liens anchor de type `<a href="#versid">...` vers `<div id="versid">...` ne fonctionne pas chez moi.

Seul le href `#top` ou `#haut` selon la langue fonctionne (sans même avoir de conteneur avec cet id).

Ce qui fonctionne dans mon contexte, c'est de remplacer (ou d'ajouter) un tag `<a name="versid"></a>` juste avant le conteneur de destination.

Ca donne :

```
<a href="#bonjour">lien classique</a>
<p>du texte</p>
...
<a name="bonjour"></a>
<div id="bonjour">
mon div etc.
</div>
```
