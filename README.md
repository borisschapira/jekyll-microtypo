# Jekyll microtypo plugin tag

[![Gem Version](https://badge.fury.io/rb/jekyll-microtypo.svg)](https://badge.fury.io/rb/jekyll-microtypo)
[![Gem Downloads](https://img.shields.io/gem/dt/jekyll-microtypo.svg?style=flat)](http://rubygems.org/gems/jekyll-microtypo)

## Table of contents / Table des matières

- [Jekyll microtypo plugin tag](#jekyll-microtypo-plugin-tag)
  - [Table of contents / Table des matières](#table-of-contents--table-des-mati%C3%A8res)
  - [English](#english)
    - [en_US fixings](#enus-fixings)
    - [Installation](#installation)
    - [Global use](#global-use)
    - [Configuration](#configuration)
    - [Ignore code sections](#ignore-code-sections)
  - [Français](#fran%C3%A7ais)
    - [Corrections fr_FR](#corrections-frfr)
    - [Installation](#installation)
    - [Utilisation générique](#utilisation-g%C3%A9n%C3%A9rique)
    - [Configuration](#configuration)
    - [Ignorer des portions de code](#ignorer-des-portions-de-code)

## English

`jekyll-microtypo` is a [Jekyll](http://jekyllrb.com/) plugin that attempts to fix microtypography for french and english languages.

It provides a new filter which takes into parameter the locale of the text to be improved:

```
{{ content | microtypo: 'en_US' }}
```

For the moment, `jekyll-microtypo` only sypports fr_FR and en_US.

### en_US fixings

- Removal of unnecessary spaces before certain punctuation marks
- Use of opening and closing single quotation marks
- Removing unnecessary spaces between amount and currency
- Replacement of "..." with "..."

### Installation

Add `gem 'jekyll-microtypo'` to the `jekyll_plugin` group in your `Gemfile`:

```ruby
source 'https://rubygems.org'

gem 'jekyll'

group :jekyll_plugins do
  gem 'jekyll-microtypo'
end
```

Then run `bundle` to install the gem.

### Global use

A simple way to use `jekyll-microtypo` is to use it into a master layout.

Add a `microtypo.html` file to your `_layouts` folder, containing the following snippet:

```liquid
{{ content | microtypo: page.locale  }}
```

Then, modify all your top-level layouts to inherit from this one. For example, if your only previous top-level layout was `default.html`, add this header:

```
---
layout: microtypo
---

… The previous content of default.html …
```

### Configuration

There is no configuration needed for **en_US**.  
For **fr_FR**, you can add a configuration **if you want to hide the inclusive median point abbreviation to screen readers**.

Add `microtypo` to your `_config.yml`:

```yaml
microtypo:
  median: true
```
* Before : `Il·Elle est intéressé·e.`
* After : `Il<span aria-hidden="true">·Elle</span> est intéressé<span aria-hidden="true">·e</span>.`

### Ignore code sections

It is possible to tell `jekyll-microtypo` to ignore one or more sections of code in its corrective operation. To do this, just place the code to ignore between these two comments:

```html
This content will be fixed.

<!-- nomicrotypo -->
This content will not be fixed
<!-- endnomicrotypo -->

This content will be fixed.
```

## Français

`jekyll-microtypo` est un plugin [Jekyll](http://jekyllrb.com/) qui permet de corriger la microtypographie de contenus rédigés en anglais ou en français.

Il fournit un nouveau filtre qui prend en paramètre la locale du texte à corriger:

```
{{ content | microtypo: 'en_US' }}
```

Pour le moment, `jekyll-microtypo` ne supporte que fr_FR et en_US.

### Corrections fr_FR

- Remplacement des ordinnaux "1er, 2e" par "1<sup>er</sup>, 2<sup>e</sup>"
- Remplacement de "n°3" par "n<sup>o</sup>&#8239;3"
- Utilisation des guillemets à la français
- Utilisation des guillemets simples ouvrants et fermants
- Remplacement des pontuations spéciales "?!", "!?", "!!" par les signes adaptés "&#8264;", "&#8265;", "&#8252;"
- Ajout d'une espace insécable ou fine insécable devant les signes de ponctuation qui le nécessitent
- Remplacement de l'espace entre des chiffres et certaines unités par une espace fine insécable (attention, l'espace doit être présente à l'origine)
- Ajout d'une espace insécable avant le montant et les signes "€" ou "$"
- Ajout d'une espace insécable après un tiret long
- Remplacement du "x" par un "&times;" dans les multiplications
- Remplacement de "..." par une vrai éllipse "..."
- **Si configuré** : masquage de la notation abbréviative à base de point médian pour les lecteurs d'écran 

### Installation

Ajoutez `gem 'jekyll-microtypo'` au groupe `jekyll_plugin` de votre `Gemfile`:

```ruby
source 'https://rubygems.org'

gem 'jekyll'

group :jekyll_plugins do
  gem 'jekyll-microtypo'
end
```

Puis exécutez `bundle` pour installer la gem.

### Utilisation générique

Une manière simple d'utiliser `jekyll-microtypo` est de l'appliquer sur un *layout* de plus haut niveau.

Ajoutez un fichier `microtypo.html` à votre dossier `_layouts`, contenant la portion de code suivante:

```liquid
{{ content | microtypo: page.locale  }}
```

Puis modifier vos autres *layout* de plus haut niveau pour qu'ils héritent de ce *layout*. Par exemple, si votre *layout* de plus haut niveau était `default.html`, ajoutez-lui cet en-tête:

```
---
layout: microtypo
---

… Le contenu de default.html avant intervention …
```

### Configuration

Aucune configuration n'est nécessaire pour la locale **en_US**.  
Pour la locale **fr_FR**, vous pouvez ajouter une configuration dans le seul cas où vous voudriez **masquer la syntaxe abbréviative à base de point médian aux lecteurs d'écran**.

Dans ce cas, ajoutez `microtypo` à votre `_config.yml`:

```yaml
microtypo:
  median: true
```

* Avant : `Il·Elle est intéressé·e.`
* Après : `Il<span aria-hidden="true">·Elle</span> est intéressé<span aria-hidden="true">·e</span>.`

### Ignorer des portions de code

Il est possible d'indiquer à `jekyll-microtypo` d'ignorer une ou plusieurs portions de code dans son opération de correction. Pour cela, il suffit de placer la portion de code entre deux commentaires :

```html
Ce contenu sera corrigé.

<!-- nomicrotypo -->
Celui-ci ne sera pas corrigé.
<!-- endnomicrotypo -->

Ce contenu sera corrigé.
```
