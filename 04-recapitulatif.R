#' ---
#' title: "Importer, nettoyer et analyser des vraies données"
#' author: "Samuel BARRETO"
#' date:
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
library(samuer)
library(knitr)
opts_chunk$set(
  cache = FALSE, dev = 'png', include = TRUE,
  fig.path  = "graphics/", echo = TRUE, warning = FALSE,
  error = FALSE, message = FALSE, global.par = TRUE
)

## /*
rmarkdown::render("/Users/samuelbarreto/prof/cafe-du-mRcredi/04-recapitulatif.R",
                  encoding = "UTF-8")
## */

### ---------- Setup -------------------------------------------------------

#' # Objectif
#'
#' L'idée de ce café est de reprendre tout ce qu'on a fait depuis le départ, et
#' de l'appliquer à un nouveau jeu de donnée réel.
#'
#' Ce jeu de donnée a été récolté par Cindy avec le compteur de colonies
#' InterScience. En gros on a transformé une culture d'_Acinetobacter_ à
#' différentes DO600 par le même produit PCR, pour voir si on a un pic
#' d'efficacité de transformation.
#'
#' Donc après transformation on étale en duplicât un même volume sur un milieu
#' sélectif, et en duplicât les dilutions $10^-4$ sur un milieu non sélectif,
#' pour calculer une fréquence de transformation.
#'
#' # Importation des données
#'
#' ## Création de la structure de dossier
#'
#' Le jeu de donnée est disponible — comme la dernière fois — [à cette
#' adresse](https://figshare.com/articles/cafe_recapitulatif/4580563).
#'
#' Créez un nouveau dossier où vous voulez baptisé `cafe4`, contenant un dossier
#' `analysis` et un dossier `data-raw`.
#'
#' Télécharger les données, dézipper l'archive et placer les fichiers dans le
#' dossier data-raw.
#'
#' Maintenant grâce à RStudio ou à la commande `setwd()`, indiquer à `R` que le
#' dossier `analysis` est le répertoire de travail (avec la petite molette de
#' l'explorateur de fichier inclut dans RStudio).
#'
#' Chouette. Vous pouvez vérifier que les fichiers du jeu de donnée sont bien
#' dans le dossier `analysis` avec la commande `list.files("../data-raw/")`.
#' S'il y a un message d'erreur, c'est certainement parce que vous n'êtes pas
#' dans le bon dossier :).
#'
#' Ok maintenant on peut les importer dans R.
#'
#' ## Importation via `read_delim`
#'
#' Commençons par importer les deux fichiers les plus simples, `do.csv` et
#' `id.csv`. Le premier contient la DO des différents réplicâts aux différents
#' temps.

### ---------- include = FALSE ---------------------------------------------
do_file <- "https://ndownloader.figshare.com/files/7417387"

### ---------- eval = FALSE ----------------------------------------------
do_file <- "../data-raw/do.csv"

### ---------- eval = TRUE -------------------------------------------------
library(tidyverse)

df_DO600 <- read_csv(do_file)
df_DO600

#' Chouette, celui là ne pose aucun problème, les données sont formattées
#' correctement.
#'
#' le deuxième — `id.csv` — contient les métadonnées qui ne sont pas
#' présentes dans le fichier exporté par le logiciel InterScience.

### ---------- include = FALSE ---------------------------------------------
id_file <- "https://ndownloader.figshare.com/files/7417390"

### ---------- eval = FALSE ------------------------------------------------
id_file <- "../data-raw/id.csv"

### ---------- eval = TRUE -------------------------------------------------

df_id <- read_csv(id_file)
df_id

#' Pareil, pas d'embrouilles. Celui là se charge facilement.
#'
#' Par contre le dernier va nous poser problème. Si vous l'ouvrez dans un
#' éditeur de texte, on voit ça :
#'
#' ![](graphics/04-messy-csv.png)
#'
#' Ce qui nous indique plusieurs choses :
#'
#' 1. Que les premières lignes ne sont pas des noms de colonnes, on ne doit pas
#' les prendre en compte.
#' 2. Qu'il y a des caractères spéciaux bizarres dans les noms de colonnes, qu'on va devoir éliminer.
#' 3. Qu'il y a beaucoup de colonnes qui ne servent certainement à rien.
#' 4. Que les programmeurs de InterScience ne font pas beaucoup d'analyse de données.
#' 5. Que le caractère pour délimiter les champs est un `;` et pas un `,`, contrairement à ce qui est attendu sous l'appelation `.csv`...

### ---------- include = FALSE ---------------------------------------------
df_file <- "https://ndownloader.figshare.com/files/7417384"

### ---------- eval = FALSE ------------------------------------------------
df_file <- "../data-raw/170118.csv"

#' Ok, éliminons dans un premier temps le problème des premières lignes qui ne
#' sont pas des noms de colonne.

### ---------- error = TRUE ------------------------------------------------
read_delim(df_file, skip = 3, delim = ";")

#' Ok il doit y avoir un caractère bizarre dans les noms de colonne que R ne
#' comprend pas trop trop. En tâtonnant un peu j'ai vu qu'il fallait changer
#' l'encodage du fichier, un truc auquel je ne comprends pas grand chose, mais
#' qui correspond à la façon dont les caractères sont représentés dans la
#' mémoire de l'ordi.

read_delim(df_file, skip = 3, delim = ";", locale = locale(encoding = "LATIN1"))

#' Bon ok ça a l'air de marcher. Sauf que le cractère décimal est mal interprété.

read_delim(df_file, skip = 3, delim = ";",
           locale = locale(encoding = "LATIN1", decimal_mark = ","))

#' C'est mieux.
#'
#' Sauvegardons donc ça.

df <- read_delim(df_file, skip = 3, delim = ";",
                locale = locale(encoding = "LATIN1", decimal_mark = ","))

#' Les noms de colonnes sont tout bonnement — tout bonnement oui — impraticables
#' dans R.

colnames(df)

#' On va donc les nettoyer en un coup avec :

df <- janitor::clean_names(df)

colnames(df)

#' Nettement mieux. Maintenant on va sélectionner les colonnes qui nous
#' intéressent, à savoir le numéro de l'échantillon, le nombre d'ufc et le
#' nombre d'ufc par ml.

df %>% select(n_échantillon, nbre_dufc, ufc_ml)

#' Nickel, on n'a pas besoin de plus. On sauvegarde :

df <- df %>% select(n_échantillon, nbre_dufc, ufc_ml)

#' # Fusion des jeux de données
#'
#' Il faut maintenant qu'on fusionne les infos présentes dans `df` avec celles
#' présentes dans les deux autres.
df
df_id
df_DO600

#' Il faut qu'on fusionne les deux derniers par la colonne réplicât et la
#' colonne `t` ou `temps`.

inner_join(x = df_id, y = df_DO600,
           by = c("t" = "temps", "rep" = "réplicats"))

#' Super, ça a l'air de marcher. Essayez de visualiser ce qu'il s'est passé ?
#'
#' Sauvegardons le résultat.

df_id_DO600 <- inner_join(x = df_id, y = df_DO600,
                         by = c("t" = "temps", "rep" = "réplicats"))

#' Maintenant fusionnons avec le jeu de donnée `df`.

df
df_id_DO600

#' L'ennui c'est qu'il y a des lignes dans la table `df` qui n'ont pas
#' d'équivalent dans la table `df_id_DO600`.

anti_join(x = df, y = df_id_DO600, by = c("n_échantillon" = "id"))

#' La commande précédente veut dire : indiques-moi toutes les lignes de la table
#' `df` qui n'ont pas d'équivalent dans la table `df_id_DO600`.
#'
#' En fait ce sont les lignes qui correspondent aux témoins de transformations.
#' On transforme par de l'eau au lieu d'un produit PCR et on voit si des clones
#' transformants poussent sur LB + antibiotique. Là Cindy a dénombré les milieux
#' non sélectifs, mais pas les sélectifs vu qu'il n'y avait rien dessus. Donc on
#' peut laisser tomber ces lignes, pas d'intérêt de calculer une fréquence là
#' dessus.
#'
#' La commande suivante fait exactement ça, elle `join` les deux tables pour
#' toutes les lignes qui ont des correspondances dans les deux tables, pour les
#' colonnes indiquées dans l'argument `by` :

(df_final <- inner_join(x = df, y = df_id_DO600, by = c("n_échantillon" = "id")))

#' Nickel !
#'
#' On a enfin un jeu de donnée complet. On va pouvoir commencer les analyses !
#'
#' Quoique.
#'
#' # Ranger les données
#'
#' Si on veut calculer une fréquence de transformation, il faut qu'on calcule la
#' moyenne des transformants par mL sur la moyenne des cellules receveuses par
#' mL, pour chaque temps et pour chaque réplicât.

df_final %>%
  group_by(t, rep, media) %>%
  summarise(ufc_moyen = mean(ufc_ml))

#' Et là typiquement on a une table qui n'est pas rangée, ça va être difficile
#' de calculer une fréquence de transformation avec un tableau comme ça. La
#' colonne `media` contient deux types d'infos.
#'
#' On va donc utiliser la fonction `spread` du package `tidyr`.

df_final %>%
  group_by(t, rep, media) %>%
  summarise(ufc_moyen = mean(ufc_ml)) %>%
  spread(key = media, value = ufc_moyen)

#' Nickel.
#'
#' Maintenant c'est facile de calculer un ratio avec la commande `mutate`.

df_final %>%
  group_by(t, rep, media) %>%
  summarise(ufc_moyen = mean(ufc_ml)) %>%
  spread(key = media, value = ufc_moyen) %>%
  mutate(ratio = lbk / lb)

#' Super, on a notre ratio.
#'
#' L'ennui c'est qu'on veut représenter ce ratio comme une fonction de la DO de
#' la culture de base. Il faut donc qu'on fusionne cette table avec la table
#' contenant les informations de DO, `df_DO600`.

df_final %>%
  group_by(t, rep, media) %>%
  summarise(ufc_moyen = mean(ufc_ml)) %>%
  spread(key = media, value = ufc_moyen) %>%
  mutate(ratio = lbk / lb) %>%
  inner_join(x = ., y = df_DO600, by = c("t" = "temps", "rep" = "réplicats"))

#' Ça marche.
#'
#' Maintenant on peut faire des graphiques.
#'
#' # Analyses graphiques
#'
#' Ici je ne présente que la dernière version du graphique, mais naturellement
#' on fait ça de façon itérative, couche après couche.

## le package scales permet d'utiliser différentes échelles, notamment des
## labels scientifiques. 1.5e-04 c'est mieux que 0.00015 non ?
library(scales)
## pour des jolies palettes de couleur
library(viridis)

df_final %>%
  group_by(t, rep, media) %>%
  summarise(ufc_moyen = mean(ufc_ml)) %>%
  spread(key = media, value = ufc_moyen) %>%
  mutate(ratio = lbk / lb) %>%
  inner_join(x = ., y = df_DO600, by = c("t" = "temps", "rep" = "réplicats")) %>%
  ggplot(aes(x = do600, y = ratio)) +
  geom_point(aes(color = factor(rep))) +
  geom_line(aes(group = rep), color = "gray", alpha = 0.4) +
  geom_smooth(method = "lm", se = FALSE, color = "gray") +
  guides(color = "none") +
  ## c'est ici que le package scales intervient
  scale_y_continuous(label = scientific) +
  ## et là que le package viridis intervient
  scale_color_viridis(discrete = TRUE, direction = -1, end = 0.8)

#' Un effet ou bien ?

df_final %>%
  group_by(t, rep, media) %>%
  summarise(ufc_moyen = mean(ufc_ml)) %>%
  spread(key = media, value = ufc_moyen) %>%
  mutate(ratio = lbk / lb) %>%
  inner_join(x = ., y = df_DO600, by = c("t" = "temps", "rep" = "réplicats")) %>%
  lm(data = ., ratio ~ do600) %>%
  summary()

#' Bon bah à priori, il y a un effet significatif de la DO sur l'efficacité de
#' transformation. Donc on peut arrêter de faire pousser nos cellules. On va
#' faire les transfos directement dans le glycérol maintenant.
#'
#' Chouette, on va gagner pas mal de temps.
