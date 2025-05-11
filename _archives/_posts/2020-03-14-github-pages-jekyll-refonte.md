---
layout: post
title: Github Pages et Jekyll - On se met au vert !
date: 2020-03-14 09:00
author: Virtual Thom
comments: true
categories: [github-pages, jekyll]
---
On change de vie et on plaque tout pour aller vivre à la campagne avec ma femme. Par conséquent, les billets se feront plus rares dans les prochains mois à venir.

C'est l'occasion pour moi de modifier deux, trois trucs sur le site (en vert forcément) et de vous proposer d'écrire des articles (VTOM) en tant que collaborateur de mon repo github (partie _posts).  
Très facile, en [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet), si ça dit quelqu'un, n'hésitez pas, on regarde ça ensemble ;)

Je sais notamment que la v6.4 contient son lot de nouveautés et (le truc de fou) les API SOUTENUES ET DOCUMENTéES !!! enfin  
Et ça serait bien d'y consacrer un article !

Tout le code source du site est ici : [github-pages jekyll du blog https://github.com/virtual-thom](https://github.com/virtual-thom)

<!--more-->

# Installer Jekyll sur PC avec WSL (linux sous Windows 10)
Pour plus de détails sur comment installer Jekyll sur son Windows 10 : [Billet de ScottDorman](https://scottdorman.blog/2019/02/27/running-jekyll-on-wsl/). Pour ma part, il m'a fallu rajouter ces deux modules pour que le bundle install fonctionne :  `sudo apt install zlib1g-dev ruby-dev`

et pour résumer : 
```
# Powershell en admin
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
# reboot
# Powershell en admin
wsl
sudo apt update
sudo apt upgrade
sudo apt install ruby zlib1g-dev ruby-dev build-essential
sudo gem install bundler
cd rep_source_jekyll/
bundle install --path vendor/bundle
# rajouter du coup ce path dans .gitignore
# vendor/
# .bundle
# rajouter aussi ce path dans exclude du _config.yml ...
# exclude: [...blabla, "vendor"]
bundle exec jekyll serve
# si vous avez ce message : jekyll 3.8.5 | Error:  wrong number of arguments (given 2, expected 1)
# un fix consiste à installer un autre gem module à l'heure où j'écris ces lignes dans Gemfile : gem "sprockets", "~> 3.7", puis `bundle update` et refaire un `bundle exec jekyll servce --trace`
```

# les fichiers "importants" pour [github-pages et jekyll](https://jekyllrb.com/docs/github-pages/)
Gemfile 
```ruby
source 'https://rubygems.org'
require 'json'
require 'open-uri'
versions = JSON.parse(open('https://pages.github.com/versions.json').read)

gem 'github-pages', versions['github-pages']
gem "jekyll-assets", group: :jekyll_plugins
```

_config.yml
```yml
# Site settings
title: Virtual Thom | Blog-notes VTOM et informatique
email: virtual-thom@protonmail.com
description: "Blog-notes VTOM, informatique, industrialisation, ordonnancement, DevOps"
baseurl: "" # the subpath of your site, e.g. /blog/
url: "{{ site.baseurl | prepend: site.url }}" # the base hostname & protocol for your site
github_username:  Virtual-thom
github_url: "https://github.com/virtual-thom"
permalink: /:title/

#timezone: FR
#locale: fr_FR

# Build settings
markdown_ext: "markdown,mkdown,mkdn,mkd,md"
markdown: kramdown

kramdown:
  input: GFM
  
highlighter: rouge
  
include: [".htaccess"]
exclude: ["bower.json", "package.json", "node_modules", "Gemfile", "Gemfile.lock","_build", "vendor", ".bundle"]

excerpt_separator: '<!--more-->'

paginate: 30

compression: true

gzip: true

sass:
  style: compressed
  sass_dir: _sass

plugins:
  - jekyll-sitemap
  - jekyll-paginate
  - jekyll-redirect-from
  - jekyll-coffeescript
  - jemoji
  - jekyll-seo-tag
```

Les articles se trouvent dans _posts/

Le nom doit être sous la forme : yyyy-mm-jj-mots-cles.md

ex. d'un post : 
```markdown
---
layout: post
title: Github Pages et Jekyll - On se met au vert !
date: 2020-03-14 09:00
author: Virtual Thom
comments: true
categories: [github-pages, jekyll]
---
blabla
```

Le simple fait de commit va redéployer le site.

# Les p'tits trucs sympas
Dans [_data](https://jekyllrb.com/docs/datafiles/), on peut mettre des info's "stockées" dans des json ou yml, genre database.  
Après, on y accède facilement dans les articles .md avec les moustaches {{ site.data.nomdufichierjson.cle }}.

Avoir des commentaires sur un site statique pour toutes les pages/articles (mettre un permalink: /:title/ dans _config.yml ) : [https://disqus.com/](https://disqus.com/).
