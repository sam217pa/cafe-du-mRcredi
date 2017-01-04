#' ---
#' title: "Cafe du mRcredi 01"
#' author: "LEM Zeppelin ;)"
#' date: ""
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
  fig.path  = "graphics/", echo = TRUE, warning = TRUE,
  error = FALSE, message = FALSE, global.par = TRUE
)

## /*
rmarkdown::render("/Users/samuelbarreto/prof/cafe-du-mRcredi/01-session-chauffe.R", encoding = "UTF-8")
## */

### ---------- Setup -------------------------------------------------------

#' # Intro
#'
#' L'idée pour cette partie est d'apprendre à utiliser des packages récemment
#' développés dans l'univR, qui permettent de gagner beaucoup de temps par
#' rapport aux commandes de base de R. On verra également certains trucs cool
#' présents dans RStudio qui permettent d'être plus efficace en développant du
#' code R.
#'
#' Pour apprendre à utiliser les packages en question, on va partir d'un jeu de
#' donnée présent dans le package `babynames`. Il contient un tableau d'1.8M de
#' lignes, qui nous permettront d'utiliser plusieurs commandes sur un jeu de
#' donnée simple mais pas anodin.
#'
#' Avant tout ça, il faut déjà pouvoir les installer.
#'
#' # Installation des packages
#'
#' R n'est rien sans ses extensions. Récemment, un groupe de développeur a mis
#' au point un système de packages aux fonctions claires, aux comportements
#' cohérents, qui s'assemblent bien les uns avec les autres.
#'
#' Pour commencer, il faut qu'on installe ces packages.
#'
#' > Installation de `babynames` :
#'
#' Avec la dernière version de R (3.3.2 au 2017-01-04), vous pouvez utiliser :

## install.packages(babynames)
##
## (je met un signe commentaire ## pour que R n'exécute pas la commande alors que
## j'ai déjà le package installé.)

#' Si vous avez une version plus ancienne, soit mettez-là à jour, soit utiliser
#' la commande suivante :

## install.packages("devtools")

#' `devtools` est un package qui permet de se faciliter la vie quand on
#' développe des packages dans R. Entre autre, il permet de télécharger des
#' packages directement depuis le serveur de développement GitHub. Ce qu'on peut
#' faire pour installer le package `babynames` avec la commande suivante :

## devtools::install_github("hadley/babynames")

#' Pour résumer, soit le package est déjà présent sur le CRAN (l'archive de
#' dépôt des packages R) et on peut l'installer avec `install.packages`, soit il
#' est présent uniquement sur le serveur de développement, et on peut sans doute
#' l'installer avec `devtools::install_github`.
#'
#' > Installation de `tidyverse` :
#'
#' Le package tidyverse permet d'appeler les packages qui vont nous intéresser
#' au café du mRcredi. On l'installe donc comme ça :

## install.packages("tidyverse")

#' # Chargement des packages
#'
#' Une fois que les packages sont installés, il faut les charger dans la
#' session.
#'
#' On utilise donc la commande `library`.
#'
#' (NB: il est possible d'utiliser une fonction depuis un package sans avoir à
#' le charger dans la session avec la syntaxe `package::fonction_du_package()`,
#' comme pour `devtools::install_github()`)

library(babynames)
library(tidyverse)

#' Normalement quand on charge le package tidyverse, on voit des messages qui
#' indique que les packages `ggplot2`, `tidyr` et consorts ont été chargés dans
#' la session.
#'
#' L'idée pour cette session c'est d'arriver à comprendre le code suivant, qui
#' produit le graphique suivant :

participants <-
  c("Laura", "Jordan", "Theo", "Lise", "Yoann", "William", "Joris", "Clemence")

babynames %>%
  filter(name %in% participants) %>%
  group_by(name, year) %>%
  summarise(n = sum(n)) %>%
  ggplot(aes(x = year, y = n)) +
  geom_smooth(se = FALSE, color = "gray") +
  geom_point(aes(color = name), alpha = 1/2) +
  facet_wrap(~name, scales = "free_y") +
  guides(color = "none")

#' # Babynames
#'
#' Jettons d'abord un coup d'œil aux données, c'est quand même la base d'une
#' analyse.

babynames

#' Il y a donc cinq colonnes, qui correspondent à l'année, au sexe, au prénom,
#' au nombre d'enfants du sexe donné qui ont été baptisés ainsi au cours de
#' l'année, et la proportion des enfants baptisés par ce nom pour cet année et
#' pour ce sexe.
#'
#' # dplyr::filter
#'
#' La première fonction qui va nous intéresser est la fonction `filter`. Elle
#' permet de filtrer des _lignes_ en fonction de conditions qui nous
#' intéressent.
#'
#' Par exemple, pour ne garder que les lignes où la colonne `n` prend une valeur
#' supérieure à 10000 :

filter(.data = babynames, n > 1e4)

#' Pour ne garder que les lignes où la colonne `name` prend la valeur `"Laura"` :

filter(.data = babynames, name == "Laura")

#' Pour ne garder que les lignes où la colonne `name` prend la valeur `"Laura"`
#' et où le sexe est féminin :

filter(babynames, name == "Laura", sex == "F")

#' (NB: on peut supprimer la mention `.data = `, par défaut toutes les fonctions
#' de `dplyr` attendent en premier argument un jeu de donnée — une propriété
#' bien utilisée ensuite.)
#'
#' **Pour résumer**, la commande `filter` attend un jeu de donnée en premier
#' argument, et des conditions de filtrations pour les différentes colonnes,
#' séparées par des virgules, permettent de ne garder du jeu de donnée initial
#' que les lignes qui nous intéressent.
#'
#' # dplyr::mutate

#' La seconde fonction bien utile du package est la fonction `mutate`. Elle
#' permet de changer la valeur de colonnes existantes, ou d'en créer de
#' nouvelles. Bien utile quand on veut changer l'unité d'une colonne, ou
#' calculer la différence entre deux valeurs présentes dans deux colonnes
#' différentes. Exemples :
#'

## la fonction tibble permet de créer rapidement une table :
(df = tibble(a = c(1, 2, 3), b = c(3, 2, 1)))

mutate(.data = df, sum = a + b)

#' Encore une fois on peut supprimer la mention `.data = ` :

mutate(df, diff = a - b)
mutate(df, paste = paste0(a, b))

#' On vient d'utiliser la fonction `mutate` trois fois pour créer une nouvelle
#' colonne. On peut aussi changer une colonne existante :

mutate(df, a = 2)

#' Change toutes les valeurs de la colonne `name` en `"Laura"` :
mutate(babynames, name = "Laura")

#' Pas très utile, mais beaucoup plus quand on peut faire des choses comme ça :

mutate(babynames, name = ifelse(sex == "F", "Jeanne", "Jean"))

#' Autrement dit en français, la colonne `name` prend la valeur "Jeanne" si la
#' colonne `sex` est égale à "F", "Jean" autrement.
#'
#' > Peut-être que vous l'avez noté mais les commandes se font très rapidement sur
#' > un gros jeu de donnée, c'est aussi l'intérêt du package dplyr (les fonctions
#' > sont codées en C++, un language de programmation très performant).
#' >
#' > L'autre gros intérêt est que le jeu de donnée initial n'est jamais modifié.
#' > `babynames` garde les mêmes valeurs. Donc on ne craint pas de perdre des données
#' > en rentrant une mauvaise commande.
#'
#' # dplyr::group_by & dplyr::summarise
#'
#' Souvent en analyse de données, on a besoin d'effectuer des commandes sur des
#' groupes de données. Par exemple, pour chaque plante dans la colonne "plante",
#' calcule la longueur moyenne de racine. On peut donc grouper les données par
#' valeur dans une colonne.
#'
#' Ça se fait avec la fonction `group_by` et sa copine `summarise`.
#'

group_by(babynames, name)

#' Il ne se passe rien, sinon que le jeu de donnée est découpé en environ 90000
#' groupes, correspondants aux 90000 noms différents dans le jeu de donnée.
#'
#' Maintenant, si on utilise la fonction summarise (ou summarize, c'est au
#' choix) sur ce jeu découpé en groupes :

summarise(group_by(babynames, name), sum_par_prenom = sum(n))

#' Notez qu'il ne peut pas y avoir d'espace dans les noms de colonne, donc on
#' utilise le `_`, l'un des seuls symbole neutre qui n'ait pas de valeur dans R.
#'
#' En français, la commande précédente veut dire : par nom, calcule la somme des
#' n, autrement dit compte le nombre d'invididus portant un nom donné dans le
#' dataset.
#'
#' Peut-être que vous avez vu qu'on pouvait enchâsser des fonctions les unes
#' dans les autres. (C'est une particularité des languages dits fonctionnels,
#' dont R fait partie). Par exemple dans la commande précédente, l'argument
#' `.data = ` prenait la valeur renvoyée par l'application de la fonction
#' `group_by(babynames, name)`.

summarise(group_by(babynames, year), individus_comptes_par_annee = sum(n))

#' En français, compte le nombre d'individus recensés par année.
#'
#' Souvent, on veut compter le nombre de lignes dans un groupe. On peut utiliser
#' la fonction `n()`. Exemple :

summarise(group_by(babynames, year), prenoms_different_par_annee = n())

#' Autrement dit, compte le nombre de prénoms différents par année.
#'
#' À ce moment, on aurait envie de faire des petits graphiques pour voir s'il
#' n'y aurait pas une tendance quelconque dans les analyses qu'on fait.
#'
#' Juste avant, il faut parler de l'opérateur `%>%`, un peu spécial à prendre en
#' main mais très puissant.
#'
#' # dplyr::`%>%`
#'
#' Le but de cet opérateur est d'aider à écrire du code qui est plus clean.
#'
#' Il existe des alternatives qu'on trouve fréquemment dans R. Pour ça on va
#' utiliser ce petit exemple tout pourri, adapté d'un poème pour enfant avec un
#' peu de grand n'importe quoi.
#'
#' > Le petit lapin foofoo
#' > Cours à travers la forêt
#' > Attrape les souris
#' > Et leur écrase la tête.
#'
#' Si on veut raconter l'histoire du petit lapin `foo_foo` avec les trois
#' principales actions `cours()`, `attrape()` et `ecrase()` dans R, on peut :
#'
#' 1. Sauver chaque étape dans un nouvel objet.
#' 2. Écraser l'objet original et remplacer par un nouveau.
#' 3. Enchâsser les fonctions.
#' 4. Utiliser l'opérateur `%>%`.
#'
#' Si on décide de sauver chaque étape du processus dans un nouvel objet :

### ---------- eval = FALSE ------------------------------------------------
foo_foo <- petit_lapin()
foo_foo_1 <- cours(qui = foo_foo, a_travers = la_foret)
foo_foo_2 <- attrape(qui = foo_foo_1, quoi = les_souris)
foo_foo_3 <- ecrase(qui = foo_foo_2, quel_organe = leur_tete)

#' L'inconvénient, c'est qu'on est obligé d'écrire chaque élément intermédiaire.
#' C'est nul parce qu'on perd en mémoire dès lors que le jeu de donnée est
#' conséquent ; on pollue la session avec beaucoup de noms de variables ; on s'y
#' perd ; c'est très dur de nommer des variables de façon cohérente et efficace …
#'
#' On peut donc décider de remplacer chaque étape du processus par le nouveau résultat :

### ---------- eval = FALSE ------------------------------------------------
foo_foo <- petit_lapin()
foo_foo <-   cours(qui = foo_foo, a_travers = la_foret)
foo_foo <- attrape(qui = foo_foo, quoi = les_souris)
foo_foo <-  ecrase(qui = foo_foo, quel_organe = leur_tete)

#' L'inconvénient c'est qu'on ne sait jamais quel étape du processus ne marche
#' pas, quand ça ne marche pas, et qu'on ne sait jamais bien à quel étape du
#' processus on se situe quand ces commandes sont éloignées les unes des autres
#' dans le script.
#'
#' On peut alors décider d'enchâsser les fonctions :

### ---------- eval = FALSE ------------------------------------------------
foo_foo <- petit_lapin()
ecrase(qui = attrape(qui = cours(qui = foo_foo,
                                 a_travers = la_foret),
                     quoi = les_souris),
       quel_organe = leur_tete)

#' L'inconvénient c'est qu'on doit lire depuis l'intérieur, de la droite vers la
#' gauche, et que les arguments sont loins les uns des autres.
#'
#' On peut donc utiliser l'opérateur `%>%` !

### ---------- eval = FALSE ------------------------------------------------
foo_foo %>%
  cours(a_travers = la_foret) %>%
  attrape(quoi = les_souris) %>%
  ecrase(quel_organe = leur_tete)

#' Si on revient à nos exemples dans le monde pseudo-réel :
#'
#' On peut remplacer :

summarise(group_by(babynames, year), count = n())

#' Par :

babynames %>%
  group_by(year) %>%
  summarise(count = n())

#' L'opérateur `%>%` permet de remplacer le premier argument de la fonction
#' suivante par la valeur renvoyée par la fonction précédente.
#'
#' Dans `dplyr`, toutes les fonctions acceptent pour premier argument l'argument
#' `.data`, ce qui nous permet facilement de mettre les fonctions les unes à la
#' suite des autres.
#'
#' # Premiers graphiques !
#'
#' On en était il y a quelque temps à se dire qu'on ferait bien quelques
#' graphiques sur nos données manipulées.
#'
#' Exemple :

babynames %>%
  group_by(year) %>%
  summarise(count = n())

#' Comment covarient le nombre prénoms différents avec l'année ? Notre hypothèse
#' c'est que plus le temps passe, plus il y a de prénoms différents représentés
#' dans le jeu de donnée (a priori il n'y avait que très peu de Titouan et autre
#' Eleona en 1880, surtout aux USA.)

babynames %>%
  group_by(year) %>%
  summarise(count = n()) %>%
  ggplot(aes(x = year, y = count)) +
  geom_point() +
  geom_vline(xintercept = 1917)

#' C'est bien ce qu'on observe. La diminution de diversité notée autour des
#' années 1920 est certainement due aux changements de politique d'immigration
#' observés aux USA à ce moment là.
#'
#' Si on revient à R, on a utilisé des fonctions du package `ggplot2`, un
#' package qui implémente la grammaire des graphiques dans R.
#'
#' Pour faire court, cette grammaire veut qu'on puisse attribuer des dimensions
#' du jeu de données à des aspects `aes`thétiques visuellement représentés sur
#' le graphe. Ce qui est fait dans la ligne `ggplot(aes(x = year, y = count))`,
#' où j'attribue à la dimension ésthétique `x` la dimension du jeu de donnée
#' `year`. Autrement dit, représente en `x` l'année, en `y` le nombre de prénoms
#' différents.
#'
#' La fonction `geom_point` indique qu'on veut représenter ces attributions
#' esthétiques par des figures géométriques en forme de point. Si vous consultez
#' l'aide du package [ici](http://docs.ggplot2.org/current/), vous constaterez
#' qu'il existe toute une tripotée de représentations géométriques disponibles,
#' toutes plus ou moins pertinentes selon le contexte.
#'
#' La fonction `geom_vline` représente une ligne verticale, qui coupe l'axe des
#' `x` en 1917.
#'
#' > On verra le package ggplot2 plus en détail aux prochains cours.
#'
#' # Conclusion
#'
#' Si on combine tout ce qu'on a vu jusqu'à maintenant :
#'

## Ici on crée une liste des gens présents à l'atelier :
participants <-
  c("Laura", "Jordan", "Theo", "Lise", "Yoann", "William", "Joris", "Clemence")

babynames %>%
  # là on filtre pour ne garder que les lignes où le nom a une correspondance
  # dans le vecteur participants
  filter(name %in% participants) %>%
  # ensuite on groupe par année, par prénom et par sexe,
  group_by(year, name, sex) %>%
  # on fait la somme des cas comptés
  summarize(sum = sum(n)) %>%
  # on représente en x l'année, en y la somme des cas comptés et par la couleur
  # le sexe des individus comptés :
  ggplot(aes(x = year, y = sum, color = sex)) +
  # on veut représenter les attributions par une figure géométrique ponctuelle :
  geom_point() +
  # on peut ajouter une courbe de tendance de couleur grise, sans l'écart type (se)
  geom_smooth(se = FALSE, color = "gray") +
  # et on veut le même graphique pour tous les prénoms, donc on démultiplie par
  # petits panneaux (on veut un panneau par prénom). Comme les n varient
  # beaucoup par prénom, on ajuste l'échelle des y en fonction du n max par
  # panneau :
  facet_wrap( ~ name, scales = "free_y")
