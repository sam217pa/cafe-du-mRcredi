#' ---
#' title: "Premiers graphiques avec ggplot2"
#' author: "Samuel BARRETO"
#' date: 2017-01-10
#' output:
#'   html_document:
#'     highlight: tango
#'     theme: flatly
#'     code_folding: show
#'     toc: true
#'     toc_depth: 2
#'     toc_float: true
#'     fig_width: 10
#'     fig_height: 6.18
#' ---

### ---------- include = FALSE ---------------------------------------------
library(knitr)
opts_chunk$set(
  cache = FALSE, dev = 'png', include = TRUE,
  fig.path  = "graphics/", echo = TRUE, warning = FALSE,
  error = FALSE, message = FALSE, global.par = TRUE
)

## /*
rmarkdown::render("/Users/samuelbarreto/prof/cafe-du-mRcredi/02-premiers-graphiques.R",
                  encoding = "UTF-8")
## */

### ---------- Setup -------------------------------------------------------

#' # Apprendre à représenter les données
#'
#' R est un excellent outil pour représenter des données complexes. On peut
#' faire des choses très belles simplement avec R. La plupart des graphiques
#' produit dans les publications scientifiques de qualité le sont avec R (ou
#' Python). Pour autant, les graphes produits par défaut par R peuvent être très
#' très sales, comme le sont ceux produits par Excel ou autre maléfice du genre.
#'
#' L'idée du cours d'aujourd'hui est d'apprendre à utiliser le package
#' `ggplot2`. Ce package implémente la Grammaire des Graphiques dans R. Ce
#' concept repose sur l'idée qu'un graphique est constitué d'une correspondance
#' entre une dimension du jeu de donnée et les propriétés esthétiques de formes
#' géométriques.
#'
#' C'est une façon de penser les graphiques qui permet de construire assez
#' facilement des graphiques complexes à partir d'idées simples :
#'
#' 1. on attribue des données à des propriétés esthétiques.
#' 2. on superpose des couches graphiques
#' 3. on construit des graphes de façon itérative (essai - interprétation - modification - essai)
#'
#' Ce cours s'appuie fortement sur [ce post de
#' blog](http://sharpsightlabs.com/blog/r-package-think-about-visualization/).
#'
#'
#' # Mapping

library(tidyverse)

#' On va créer un jeu de donnée fictif, qui contient trois variables, foo, bar et baz.

df <- data_frame(
  foo = c(-122.419416,-121.886329,-71.05888,-74.005941,-118.243685,-117.161084,-0.127758,-77.036871,116.407395,-122.332071,-87.629798,-79.383184,-97.743061,121.473701,72.877656,2.352222,77.594563,-75.165222,-112.074037,37.6173),
  bar = c( 37.77493,37.338208,42.360083,40.712784,34.052234,32.715738,51.507351,38.907192,39.904211,47.60621,41.878114,43.653226,30.267153,31.230416,19.075984,48.856614,12.971599,39.952584,33.448377,55.755826),
  baz = c(6471,4175,3144,2106,1450,1410,842,835,758,727,688,628,626,510,497,449,419,413,325,318)
)

#' Le but du jeu est de comprendre les relations qui existent entre ces trois
#' variables. C'est souvent ça quand on découvre un nouveau jeu de donnée.
#' Certaines variables sont complètement inconnues, et on essaye de comprendre
#' en quoi elles sont liées aux autres.

(df)

#' Quand on regarde uniquement les chiffres, on ne comprend pas grand chose.
#' D'où l'intérêt de la visualisation et de la représentation graphique.

df %>%                                  # on se souvient de cet opérateur ?
  ggplot(mapping = aes(x = foo, y = bar)) +
  geom_point()

#' Voilà la syntaxe d'un scatterplot, un nuage de point, avec ggplot2. Ça n'a
#' pas l'air très sorcier, mais le mécanisme sous-jacent est plutôt complexe.
#' Lorsqu'on en comprend le principe, on pense les représentations graphiques
#' différemment (et on devient bien meilleur avec ggplot2 ;) ).
#'
#' Quand on a créé ce graphique, on a attribué des dimensions du jeu de données
#' à des attributs esthétiques.
#'
#' Super.
#'
#' Les "points" dans le nuage de point sont des objets géométriques qu'on
#' dessine. Ce sont donc des `geom_` selon ggplot2. Plus spécifiquement, ce sont
#' des `geom_point`, une classe d'objet géométrique. Il en existe beaucoup plus,
#' des rectangles, des barres, des lettres.

df %>%
  ggplot(mapping = aes(x = foo, y = bar)) +
  geom_text(mapping = aes(label = baz))

#' Tous les objets géométriques ont des attributs esthétiques (qui varient selon
#' l'objet). Souvent, ils ont au moins :
#'
#' - la position en x,
#' - la position en y,
#' - la couleur,
#' - la taille,
#' - la forme,
#' - la transparence,
#' - la rmistice.
#' - la lalie.
#' - ...
#'
#' Dans l'exemple précédent, l'objet géométrique `text` requiert un attribut
#' esthétique : l'étiquette ou label. Autrement dit le texte représenté.
#'
#' Quand on crée un graphique avec ggplot2, en fait on crée une représentation
#' entre les dimensions du jeu de donnée et les attributs `aes`thétiques des
#' objets géométriques dans notre graphique.
#'
#' ![](http://sharpsightlabs.com/wp-content/uploads/2017/01/2_ggplot2-scatter_mapping-vars.png)
#'
#' Bon on peut aussi faire ça dans Excel. Mais pas si facilement que ça. Rien
#' que le nuage de point précédent, avec du texte à la place des points, pas si facile dans Excel ?
#'
#' En fait, en théorie, les objets géométriques n'ont pas uniquement leurs
#' coordonnées x et y comme attributs esthétiques. Donc si on peut attribuer des
#' dimensions à leurs attributs `x` et `y`, on devrait pouvoir attribuer
#' d'autres dimensions à d'autres attributs non ?
#'
#' Si.
#'
#' Dans `ggplot2`, le nombre de variables qu'on peut attribuer à des attributs
#' n'est pas limité à `x` et `y`. On commence à voir en quoi c'est puissant ?
#'
#' Créons donc un diagramme en bulle (?), un bubble chart. Comment ? En créant
#' une représentation de la variable `baz` par la taille de l'objet géométrique
#' `point`.

df %>%
  ggplot(mapping = aes(x = foo, y = bar)) +
  geom_point(mapping = aes(size = baz))

#' Donc il vient de se passer ça :
#'
#' ![](http://sharpsightlabs.com/wp-content/uploads/2017/01/4_bubble-chart_mapping-vars.png)
#'
#' On vient d'attribuer la variable `baz` à un autre attribut esthétique de
#' l'objet géométrique `point`, la taille du point.
#'
#' > C'est simple, mais très important. N'importe quel graphique peut être
#' > décomposé en spécifications d'objets géométriques et d'attributions
#' > de représentations entre les variables du jeu de données et les
#' > attributs esthétiques desdits objets.
#'
#' Quand on comprend ça, on comprend comment construire des représentations
#' complexes.
#'
#' # Layers
#'
#' `ggplot2` permet également de construire ses graphiques couches (layer) après
#' couches. C'est un principe important, qui permet de représenter dans un même graphique :
#'
#' - plusieurs jeu de données
#' - des transformations statistiques de données brutes
#'   (courbes de tendance, résumés comme la moyenne, l'écart type...).
#'
#' Pour comprendre ce que ça implique, on va modifier le bubble chart :
#'
#' 1. trouver des informations supplémentaires.
#' 2. les stocker dans une nouvelle table.
#' 3. les représenter dans une nouvelle couche, sous celle des bulles.
#'
## MOAR DATA, I NEED MOAR DATAAAA
## install.packages("maps")
library(maps)

(df_more_data <- as_tibble(map_data("world")))

df %>%
  ggplot(aes(x = foo, y = bar)) +
  geom_polygon(data = df_more_data, aes(x = long, y = lat, group = group)) +
  geom_point(aes(size = baz), color = "red")

#' # Iterate, over and over again
#'
#' On construit souvent des graphiques en modifiant progressivement les éléments
#' qui nous intéressent. Pour ça, c'est bien pratique de sauvegarder le
#' graphique dans un objet. On va l'appeler `p`.

df %>%
  ggplot(aes(x = foo, y = bar)) +
  geom_polygon(data = df_more_data, aes(x = long, y = lat, group = group)) +
  geom_point(aes(size = baz), color = "red")

#' Il semblerait que des points se superposent. On perd du coup de
#' l'information. On va donc changer leur niveau de transparence global. C'est
#' différent d'attribuer des dimensions du jeu de données à des attributs
#' esthétiques, puisque ça se passe en dehors de l'argument `mapping = `.
#'
#' Pour modifier le niveau de transparence d'un objet géométrique — les points
#' par exemple, on utilise l'argument `alpha`. (C'est aussi un attribut
#' esthétique qui peut servir à représenter des données).

df %>%
  ggplot(aes(x = foo, y = bar)) +
  geom_polygon(data = df_more_data, aes(x = long, y = lat, group = group)) +
  geom_point(aes(size = baz), color = "red", alpha = 0.3)

#' Là on voit déjà mieux les points qui se superposent. Cependant, les points
#' sont un poil petits, il faut qu'on modifie l'échelle de taille. On veut que
#' les points représentant une valeur élevée de `baz` soient plus gros que ceux
#' représentant une valeur faible.
#'
#' Pour modifier les échelles dans `ggplot2`, on utilise les fonctions
#' `scale_*`. Il en existe autant que d'attributs esthétiques.

df %>%
  ggplot(aes(x = foo, y = bar)) +
  geom_polygon(data = df_more_data, aes(x = long, y = lat, group = group)) +
  geom_point(aes(size = baz), color = "red", alpha = 0.3) +
  scale_size_continuous(                # l'échelle de taille est continue
    # sa portée est de 1 à 20 (les gros # points sont 20 fois plus gros que les
    # petits) :
    range = c(1, 20),
    # les cassures qu'on veut représenter dans la légende :
    breaks = c(500, 2000, 6000),
    # le nom de l'échelle (autrement dit le nom de la variable attribuée) :
    name = "Investissements risqués\n(en millions d'USD)\n"
  )

#' Bon la carte commence à ressembler à quelque chose. Maintenant on peut jouer
#' sur différents paramètres pour que le graphique soit un peu plus joli.
#'
#' La grande majorité des petits "trucs" de décoration dans `ggplot2` passent
#' par des appels à la fonction `theme()`.
#'
#' Elle a _beaucoup_ d'arguments, on va jouer avec quelques uns d'entre eux.


df %>%
  ggplot(aes(x = foo, y = bar)) +
  geom_polygon(data = df_more_data, aes(x = long, y = lat, group = group)) +
  geom_point(aes(size = baz), color = "red", alpha = 0.3) +
  scale_size_continuous(
    range = c(1, 20),
    breaks = c(500, 2000, 6000),
    name = "Investissements risqués\n(en millions d'USD)\n"
  ) +
  theme(
    text = element_text(color = "white"),
    panel.background = element_rect(fill = "black"),
    panel.grid = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid.major = element_blank(),
    legend.position = c(0.17, 0.3),
    legend.background = element_blank(),
    legend.key = element_blank()
  )

#' Super, on a fait une jolie carte dans R, avec ggplot2. On a appris pleins de
#' trucs sur le fonctionnement de ggplot2. On a surtout appris à raisonner à
#' propos d'une représentation graphique, et ça c'est super important !
#'
#' L'idée de la suite est de faire pleins de petits graphiques qu'on fait
#' couramment sur Excel ou dans la vie (à la boulangerie, quand on fait ses
#' courses ou son ménage, dans les transports, tout ça tout ça.)
#'
#' # Diagrammes en barres !

library(babynames)

#' Un diagramme en barre ne demande qu'une seule attribution à l'attribut
#' esthétique `x`. En fait on représente en `y` le nombre de fois que la
#' variable attribuée à `x` prend une valeur dans un intervalle donné.

babynames %>%
  ggplot(aes(x = n)) +
  geom_histogram()

#' Super on voit bien rien.
#'
#' La grande majorité des valeurs que prend `n` est autour de 0. Ce serait bien
#' de représenter les valeurs de comptage en `y` sur une échelle logarithmique,
#' pour — attention nouveau mot : — désécraser les fortes valeurs de `n`.
#'
#' On l'a dit, tout ce qui est question d'échelle passe par des fonctions qui
#' commencent par `scale_`.

babynames %>%
  ggplot(aes(x = n)) +
  geom_histogram() +
  scale_y_log10()

#' Un histogramme n'est pas _fondamentalement_ la même chose qu'un diagramme en
#' barre.

babynames %>%
  ggplot(aes(x = n)) +
  geom_bar() +
  scale_y_log10()

#' Vu ? Pas de `binning`, c'est à dire que les comptages se font valeur par
#' valeur. Ça correspond à représenter ça graphiquement :

head(table(babynames$n), n = 20)

#' On peut construire des "camemberts" dans ggplot2, même si ça n'est pas très
#' [conseillé](http://www.businessinsider.fr/us/pie-charts-are-the-worst-2013-6/).
#'
#' Pour ça, il faut comprendre qu'on camembert n'est qu'un diagramme en barre,
#' représenté en coordonnées polaires.
#'
#' Pour représenter le sex ratio d'un échantillon de 100 lignes dans le jeu de
#' donnée :

babynames %>%
  # échantillone 100 lignes aléatoirement
  sample_n(100) %>%
  ggplot(aes(
    # ne représente rien en x, juste 1
    x = 1,
    # et représente par la couleur de la barre le nombre de cas d'un sexe donné
    fill = sex)) +
  geom_bar()

#' Bon chouette.
#'
#' Ça c'est en coordonnées cartésiennes comme on a bien l'habitude. Mais si on
#' projette dans un plan polaire, on a quelque chose d'intéressant :

babynames %>%
  # échantillone 100 lignes aléatoirement
  sample_n(100) %>%
  ggplot(aes(
    # ne représente rien en x, juste 1
    x = 1,
    # et représente par la couleur de la barre le nombre de cas d'un sexe donné
    fill = sex)) +
  geom_bar() +
  # on attribue l'angle à la variable `y` (l'axe des y en coordonnées cartésiennes.)
  coord_polar(theta = "y")

#' # Lignes
#'
#' Souvent on a besoin de lignes pour représenter des séries.

babynames %>%
  # garde uniquement les cas où on a plus de 75000 prénoms par an.
  filter(n > 7.5e4) %>%
  ggplot(aes(x = year, y = n, color = name)) +
  geom_line()
