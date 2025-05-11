---
layout: post
title: Recherche dans un site Jekyll statique en JS hébergé sur Github
date: 2019-08-18 09:14
author: Virtual Thom
categories: [jekyll, javascript, pages Github]
---

<edit 2019>
Puisque je vois que ça peut intéresser des personnes, vous trouverez ci-après un bout de code beaucoup plus synthétique (et moderne :p) que celui utilisé dans le post original (sans jQuery mais le principe est le même)

Voici le code complet : [https://github.com/virtual-thom/blob/master/search.html](https://github.com/virtual-thom/blob/master/search.html)

<!--more-->

```js
// l'idée c'est de récupérer le contenu du fichier /feed.xml que vous construisez dans votre template Jekyll 
// on parse le contenu en XML et on va chercher le mot clé (ici par exemple "jekyll") dans le noeud qui contient tout le contenu des _posts, chez moi c'est le noeud "item" mais vous mettez ce que vous avez définit dans le template feed.xml de votre site
// là pour l'exemple je ne fais que l'affichage en console.log des noeuds qui contiennent le mot clé, mais l'idée ça va être de récupérer par exemple l'url du post avec la baslise <link> du flux RSS"

fetch("/feed.xml")
  .then(r => r.text())
  .then(xmlAsText => {
    let responseDoc = new DOMParser().parseFromString(xmlAsText, 'application/xml')
    console.log(
      Array.from(responseDoc.getElementsByTagName('item'))
        .filter(item => item.textContent.match("jekyll")
     )
    )
   })
```

![Résultat]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/resultat_console_log_js.JPG)

exemple de template de `feed.xml`, on retrouve le contenu du post dans le noeud <item>
  
```
{% raw %}
---
layout: null
---
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>{{ site.title | xml_escape }}</title>
    <description>{{ site.description | xml_escape }}</description>
    <link>{{ site.url }}{{ site.baseurl }}/</link>
    <atom:link href="{{ "/feed.xml" | prepend: site.baseurl | prepend: site.url }}" rel="self" type="application/rss+xml"/>
    <pubDate>{{ site.time | date_to_rfc822 }}</pubDate>
    <lastBuildDate>{{ site.time | date_to_rfc822 }}</lastBuildDate>
    <generator>Jekyll v{{ jekyll.version }}</generator>
    {% for post in site.posts %}
      <item>
        <title>{{ post.title | xml_escape }}</title>
        <description>{{ post.content | xml_escape }}</description>
        <pubDate>{{ post.date | date_to_rfc822 }}</pubDate>
        <link>{{ post.url | prepend: site.baseurl | prepend: site.url }}</link>
        <guid isPermaLink="true">{{ post.url | prepend: site.baseurl | prepend: site.url }}</guid>
        {% for tag in post.tags %}
        <category>{{ tag | xml_escape }}</category>
        {% endfor %}
        {% for cat in post.categories %}
        <category>{{ cat | xml_escape }}</category>
        {% endfor %}
      </item>
    {% endfor %}
  </channel>
</rss>
{% endraw %}
```

fin de l'édit 2019 :)


J'utilise [Jekyll](http://jekyllrb.com) pour générer les pages statiques que vous êtes en train de lire.

Le problème d'un site statique, c'est qu'on ne peut pas interroger son serveur web (php, node js ou autre) pour obtenir des informations.

En PHP, par exemple, si l'on veut rajouter un module de recherche sur son site, il suffit d'interroger un contrôleur qui va se charger d'aller chercher dans un modèle les mots recherchés en POST.

Mais qu'à cela ne tienne. Avec un peu de javascript / ajax, c'est facile.

Je ne dis pas que ma solution est la meilleure, mais elle fonctionne. Le principe est de générer un fichier xml avec tous les mots de mon blog et de pouvoir récupérer le titre et l'url du post en question.

J'ai trouvé que le plus simple était d'étoffer un peu le feed.xml proposé par défaut. Après, il est vrai que mon blog n'est pas bien gros, et je me suis permis de mettre tout le contenu dans feed.xml. Mais on peut se restreindre aux mots clés et à un excerpt par exemple.

## [Exemple feed.xml](https://github.com/virtual-thom/blob/master/feed.xml)

Ensuite, l'idée est de charger avec ajax le fichier feed.xml et de chercher les mots. Puis je rajoute les éléments dans le DOM avec javascript (jQuery).

Voici ma fonction. L'avantage de la fonction, c'est que je peux créer ensuite plusieurs events (recherche par menu, par click sur les catégories, etc.)

## Fonction de recherche de mots dans un site statique Jekyll

```javascript
function searchSite(words){
  $.ajax({
    type:'GET',
    url:'/feed.xml',
    dataType: 'xml',
    success:function(xml){
    var heading = $('.page-heading');
    if(heading.length > 0){
      var items = $(xml).find('item:contains('+words+')') ;
      $('.post-list').remove();
      $('.pagination').remove();
      
      
      if(items.length > 0){
        var postListHtml = '<ul class="post-list">';
        items.each(function(index){
          var categoriesButtons = '' ;
          var categories = $(items[index]).find('category') ;
          categories.each(function(indexCat){
            categoriesButtons += '<button type="button" class="btn btn-default btn-xs btn-categories hidden-xs">\
            <span class="glyphicon glyphicon-asterisk"></span>'+$(categories[indexCat]).text()+'</button> ' ;
            ; 
          });

          postListHtml += '\
<li>\
<h3><a class="post-link" href="'+ $(items[index]).find('link').text() +'">'+ $(items[index]).find('title').text() +'</a></h3>\
<footer class="post-footer">'+categoriesButtons+'\
</footer>\
</li>\
          ';
        });
        postListHtml += '</ul>';
        heading.after(postListHtml);
      }else{
        heading.after('<div class="post-list">Aucun Résultat</div>');
      }
    
    
    }else{
      window.location.href = '/#!'+words ;
    }
    
    }
  });
} /* searchSite(words) */
```

## Exemples d'events qui trigger la fonction

```javascript
$(document).on('click','#exec-search',function(){
  searchSite($(this).siblings('input').val());
});
$('#exec-search ~ input').keypress(function (e) {
 var key = e.which;
 if(key == 13)  // the enter key code
  {
    searchSite($(this).val());
  }
});
$(document).on('click','.btn-categories',function(){
  searchSite($(this).text().trim());
});
var slug = window.location.href.split("#!")[1] ;
if(slug){
  searchSite(slug);
}
```

