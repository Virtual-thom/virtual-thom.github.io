---
layout: post
title: Opérateurs binaire exemple concret
date: 2024-01-15 09:00:00
author: Virtual Thom
---
Une vidéo de Grafikart m'a inspiré pour un besoin que j'avais en javascript pour stocker en base les horaires cron des utilisateurs pour déclencher des alarmes.  

```javascript
// ex. Le nombre binaire 000000000000000001000000 est équivalent à l'entier 64.
// getChoices(64) donnera donc [ 7 ]
// Le nombre binaire 000000000000000001000001 est équivalent à l'entier 65.
// getChoices(65) donnera donc [ 1, 7 ]
function getChoices(number) {
    let choices = [];
    let position = 1;

    while (number > 0) {
        // Si le bit de poids faible est 1, ajoutez la position à la liste des choix
        if ((number & 1) === 1) {
            choices.push(position);
        }

        // Décalez les bits vers la droite et passez à la position suivante
        number >>= 1;
        position++;
    }

    return choices;
}
// fonction inverse, on donne le tableau en entrée pour donner l'entier correspondants des heures
// getNumber( [1, 7] ) donnera 65
function getNumber(choices) {
    let number = 0;
    for (let i = 0; i < choices.length; i++) {
        let position = choices[i];
        // Définir le bit à la position spécifiée à 1
        number |= 1 << (position - 1);
    }
    return number;
}
```

Les sources :  

<a href="https://developer.mozilla.org/fr/docs/Web/JavaScript/Guide/Expressions_and_operators">Lien MDN Javascript</a>
<a href="https://grafikart.fr/tutoriels/binary-operator-flag-2171">Grafikart opérateurs binaires</a>

<section aria-labelledby="opérateurs_binaires"><h2 id="opérateurs_binaires"><a href="#opérateurs_binaires">Opérateurs binaires</a></h2><div class="section-content"><p>Un opérateur binaire traite les opérandes comme des suites de 32 bits (des zéros ou des uns) plutôt que comme des nombres décimaux, hexadécimaux et octaux. Ainsi, le nombre décimal 9 se représente en binaire comme 1001. Les opérateurs binaires effectuent leur opération sur des représentations binaires et renvoient des valeurs numériques.</p>
<p>Le tableau qui suit détaille les opérateurs binaires JavaScript.</p>
<figure class="table-container"><table>
  <thead>
    <tr>
      <th>Opérateur</th>
      <th>Utilisation</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><a href="/fr/docs/Web/JavaScript/Reference/Operators/Bitwise_AND">ET binaire</a></td>
      <td><code>a &amp; b</code></td>
      <td>Renvoie un à chaque position pour laquelle les bits des deux opérandes valent un.</td>
    </tr>
    <tr>
      <td><a href="/fr/docs/Web/JavaScript/Reference/Operators/Bitwise_OR">OU binaire</a></td>
      <td><code>a | b</code></td>
      <td>Renvoie un zéro à chaque position pour laquelle les bits des deux opérandes valent zéro.</td>
    </tr>
    <tr>
      <td><a href="/fr/docs/Web/JavaScript/Reference/Operators/Bitwise_XOR">OU exclusif binaire</a></td>
      <td><code>a ^ b</code></td>
      <td>Renvoie un zéro à chaque position pour laquelle les bits sont les mêmes. [Renvoie un à chaque position où les bits sont différents.]</td>
    </tr>
    <tr>
      <td><a href="/fr/docs/Web/JavaScript/Reference/Operators/Bitwise_NOT">NON binaire</a></td>
      <td><code>~ a</code></td>
      <td>Inverse les bits de l'opérande.</td>
    </tr>
    <tr>
      <td><a href="/fr/docs/Web/JavaScript/Reference/Operators/Left_shift">Décalage à gauche</a></td>
      <td><code>a &lt;&lt; b</code></td>
      <td>Décale la représentation binaire de <code>a</code> de <code>b</code> bits vers la gauche, en ajoutant des zéros à droite.</td>
    </tr>
    <tr>
      <td><a href="/fr/docs/Web/JavaScript/Reference/Operators/Right_shift">Décalage à droite avec propagation du signe</a></td>
      <td><code>a &gt;&gt; b</code></td>
      <td>Décale la représentation binaire de <code>a</code> de <code>b</code> bits vers la droite, enlevant les bits en trop.</td>
    </tr>
    <tr>
      <td><a href="/fr/docs/Web/JavaScript/Reference/Operators/Unsigned_right_shift">Décalage à droite avec remplissage à zéro</a></td>
      <td><code>a &gt;&gt;&gt; b</code></td>
      <td>Décale la représentation binaire de <code>a</code> de <code>b</code> bits vers la droite, enlevant les bits en trop et en ajoutant des zéros à gauche.</td>
    </tr>
  </tbody>
</table></figure></div></section>

<section aria-labelledby="opérateurs_binaires_logiques"><h3 id="opérateurs_binaires_logiques"><a href="#opérateurs_binaires_logiques">Opérateurs binaires logiques</a></h3><div class="section-content"><p>Les opérateurs logiques binaires fonctionnent de la façon suivante&nbsp;:</p>
<ul>
  <li>Les opérandes sont convertis en entiers sur 32 bits. Pour les nombres dont la valeur binaire dépasse 32 bits, les bits les plus hauts sont abandonnés. Ainsi, l'entier suivant sur plus de 32 bits sera converti en entier sur 32 bits&nbsp;:
    <pre class="notranslate">Avant : 1110 0110 1111 1010 0000 0000 0000 0110 0000 0000 0001
Après :                1010 0000 0000 0000 0110 0000 0000 0001
</pre>
  </li>
  <li>Chaque bit du premier opérande est associé au bit correspondant du second opérande&nbsp;: le premier bit avec le premier bit, le second avec le second et ainsi de suite.</li>
  <li>L'opérateur est appliqué sur chaque paire ainsi constituée et le résultat est construit en binaire.</li>
</ul>
<p>Par exemple, la représentation binaire du nombre décimal <code>9</code> est <code>1001</code>, et celle du nombre décimal <code>15</code> est <code>1111</code>. Aussi, quand on utilise les opérateurs binaires sur ces valeurs, on a les résultats suivants&nbsp;:</p>
<figure class="table-container"><table>
  <thead>
    <tr>
      <th>Expression</th>
      <th>Résultat</th>
      <th>Description binaire</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>15 &amp; 9</code></td>
      <td><code>9</code></td>
      <td><code>1111 &amp; 1001 = 1001</code></td>
    </tr>
    <tr>
      <td><code>15 | 9</code></td>
      <td><code>15</code></td>
      <td><code>1111 | 1001 = 1111</code></td>
    </tr>
    <tr>
      <td><code>15 ^ 9</code></td>
      <td><code>6</code></td>
      <td><code>1111 ^ 1001 = 0110</code></td>
    </tr>
    <tr>
      <td><code>~15</code></td>
      <td><code>-16</code></td>
      <td><code>~ 0000 0000 … 0000 1111 = 1111 1111 … 1111 0000</code></td>
    </tr>
    <tr>
      <td><code>~9</code></td>
      <td><code>-10</code></td>
      <td><code>~ 0000 0000 … 0000 1001 = 1111 1111 … 1111 0110</code></td>
    </tr>
  </tbody>
</table></figure>
<p>On notera que tous les 32 bits sont inversés lors de l'utilisation de l'opérateur NON binaire et que les valeurs avec le bit le plus à gauche à 1 représentent des valeurs négatives (représentation en complément à deux). Aussi, l'évaluation de <code>~x</code> fournira la même valeur que <code>-x - 1</code>.</p></div></section>
<section aria-labelledby="opérateurs_de_décalage_binaire"><h3 id="opérateurs_de_décalage_binaire"><a href="#opérateurs_de_décalage_binaire">Opérateurs de décalage binaire</a></h3><div class="section-content"><p>Les opérateurs de décalage binaire utilisent deux opérandes&nbsp;: celui de gauche est la quantité sur laquelle effectuer le décalage et celui de droite indique le nombre de bits à décaler. La direction de l'opération de décalage dépend de l'opérateur utilisé.</p>
<p>Les opérateurs de décalage convertissent leurs opérandes en entiers sur 32 bits et renvoient un résultat de type <a href="/fr/docs/Web/JavaScript/Reference/Global_Objects/Number"><code>Number</code></a> ou <a href="/fr/docs/Web/JavaScript/Reference/Global_Objects/BigInt"><code>BigInt</code></a> selon la règle suivante&nbsp;: si l'opérande gauche est de type <a href="/fr/docs/Web/JavaScript/Reference/Global_Objects/BigInt"><code>BigInt</code></a>, la valeur de retour sera de type <a href="/fr/docs/Web/JavaScript/Reference/Global_Objects/BigInt"><code>BigInt</code></a> et sinon, la valeur de retour sera de type <a href="/fr/docs/Web/JavaScript/Reference/Global_Objects/Number"><code>Number</code></a>.</p>
<p>Les opérateurs de décalage sont listés dans le tableau suivant.</p>
<figure class="table-container"><table class="fullwidth-table">
  <caption>Opérateurs de décalage binaire</caption>
  <thead>
    <tr>
      <th scope="col">Opérateur</th>
      <th scope="col">Description</th>
      <th scope="col">Exemple</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><a href="/fr/docs/Web/JavaScript/Reference/Operators/Left_shift">Décalage à gauche</a> (<code>&lt;&lt;</code>)</td>
      <td>Cet opérateur décale la valeur du premier opérande du nombre de bits indiqué vers la gauche. Les bits en trop sont abandonnés et des bits à 0 sont ajoutés sur la droite.</td>
      <td><code>9&lt;&lt;2</code> donne <code>36</code>, car <code>1001</code>, décalé de 2 bits à gauche vaut <code>100100</code> en binaire, ce qui correspond à <code>36</code> en décimal.</td>
    </tr>
    <tr>
      <td><a href="/fr/docs/Web/JavaScript/Reference/Operators/Right_shift">Décalage à droite avec propagation du signe</a> (<code>&gt;&gt;</code>)</td>
      <td>Cet opérateur décale la valeur du premier opérande du nombre de bits indiqué vers la droite. Les bits en trop à droite sont abandonnés. Des copies du bit le plus à gauche sont ajoutés sur la gauche.</td>
      <td><code>9&gt;&gt;2</code> donne <code>2</code>, car <code>1001</code> décalé de 2 bits à droite vaut <code>10</code> en binaire, ce qui correspond à <code>2</code> en décimal. De même, <code>-9&gt;&gt;2</code> donne <code>-3</code>, car le signe est conservé.</td>
    </tr>
    <tr>
      <td><a href="/fr/docs/Web/JavaScript/Reference/Operators/Unsigned_right_shift">Décalage à droite avec remplissage à zéro</a> (<code>&gt;&gt;&gt;</code>)</td>
      <td>Cet opérateur décale la valeur du premier opérande du nombre de bits indiqué vers la droite. Les bits en trop à droite sont abandonnés. Des bits à zéro sont ajoutés sur la gauche.</td>
      <td><code>19&gt;&gt;&gt;2</code> donne <code>4</code>, car <code>10011</code> décalé de deux bits à droite devient <code>100</code> en binaire, ce qui vaut <code>4</code> en décimal. Pour les valeurs positives, le décalage à droite avec remplissage à zéro et le décalage à droite avec propagation du signe fourniront le même résultat.</td>
    </tr>
  </tbody>
</table></figure></div></section>
