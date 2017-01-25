#' ---
#' title: "Importer ses données et les nettoyer"
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
rmarkdown::render("/Users/samuelbarreto/prof/cafe-du-mRcredi/03-data-import-and-clean.R",
                  encoding = "UTF-8")
## */

### ---------- Setup -------------------------------------------------------

#' # Data Analysis
#'
#' L'analyse de données est souvent constituée des mêmes étapes.
#'
#' ![](graphics/03-data-science.png)
#'
#' Dans ce café, on verra uniquement les deux premières étapes. Dans les deux
#' cafés précédents, on a commencé à voir les étapes de transformation et de
#' visualisation / communication.
#'
#'

#' # Data importing
#'
#' L'une des étapes les plus importantes dans l'analyse est l'étape de
#' l'importation de donnée. Selon moi, c'est l'un des principaux freins à
#' l'utilisation de R "par le plus grand nombre."
#'
#' Les fonctions de base de `R` peuvent déjà vous emmener loin. (Voir les
#' fonctions `read.table()`, `read.csv()` ou `read.delim()` par exemple).
#'
#' Souvent par contre, R se trompe de type de données (confond les facteurs et
#' les caractères, n'infère pas les bonnes valeurs manquantes, se trompe de
#' caractère délimitant etc…). Heureusement, il existe un package inclus dans le
#' tidyverse qui permet de s'affranchir de ce genre d'erreurs courantes, le
#' package `readr`.
#'
#' Pour illustrer l'importation de donnée, j'ai utilisé un échantillon d'un de
#' mes grand tableur (la sortie d'un programme d'alignement de génomes
#' bactériens entiers, qui est un poil dégueulasse dans ses choix de sorties…).
#' Il est disponible à l'adresse suivante :
#' https://figshare.com/articles/2017-01-13-cafe-du-mercredi-shuffled_vcf/4546888
#'
#' Pour illustrer les bonnes pratiques d'analyse d'un jeu de donnée avec R, on
#' va créer la structure de dossier qui convient bien (en tout cas ça marche
#' bien avec moi).
#'
#' Dans un nouveau dossier que vous pouvez baptiser sobrement `cafe3` — les
#' meilleurs noms sont les plus courts — (sans accent, R n'aime pas trop ce
#' genre de caractères spéciaux), créez deux autres dossiers.
#'
#' - `data-raw` contiendra les donneés brutes, celles que vous avez téléchargées
#' depuis _figshare_.
#' - `analysis` contiendra les différents scripts d'analyse. Souvent les petits
#' projets n'ont besoin que d'un seul script R, mais parfois vous avez besoin de
#' plus. C'est considéré comme une bonne pratique de rassembler tous les scripts
#' d'analyse dans un seul et même dossier qui porte ce nom.
#'
#' Si vous n'avez pas encore téléchargé les données
#' [là](https://figshare.com/articles/2017-01-13-cafe-du-mercredi-shuffled_vcf/4546888), faites le
#' et placer les dans le dossier `data-raw`.
#'
#' Maintenant naviguez avec l'onglet `Files` de RStudio jusqu'au dossier
#' `cafe3/analysis`.
#'
#' ![](graphics/03-rstudio-file.png)
#'
#' Avec la petite molette, cliquez sur `set as working directory`.
#'
#' ![](graphics/03-rstudio-file-1.png)
#'
#' Quelque chose qui commence par `setwd` devrait apparaître dans votre console R.
#'
#' Le fichier de donnée se trouve dans le répertoire
#' `../data-raw/2017-01-13-café-du-mercedi-03.vcf`. (En notation UNIX, `../`
#' signifie "répertoire parent" et `./` "repértoire courant". Donc si le
#' répertoire courant est "analysis", on peut désigner le dossier `data-raw` par
#' "../data-raw").
#'
## ------- include = FALSE
data_file <- "https://ndownloader.figshare.com/files/7364320"
metadata_file <- "https://ndownloader.figshare.com/files/7365016"

## ------- eval = FALSE
data_file <- "../data-raw/2017-01-13-café-du-mercredi-03.vcf"
metadata_file <- "../data-raw/experimental_id.csv"

#' Donc là on vient d'indiquer à R où était notre fichier de donnée, qu'il nous
#' intéresse d'importer dans R.
#'
#' Maintenant il faut qu'on l'importe avec la fonction `read_delim`, et qu'on
#' sauvegarde le résultat de la fonction `read_delim()` dans un objet qui nous
#' permettra de conserver le jeu de donnée dans la session courante.

library(tidyverse)

df <- read_delim(file = data_file, # où chercher le fichier à lire ?
                delim = "\t" # quel est le caractère qui délimite les champs ?
                # \t veut dire "tabulation"
                )
head(df)

#' Maintenant importons la table `experimental_id`, que j'ai volontairement
#' exporté depuis Excel avec des paramètres pas très pertinents.
#'
#' Vu que c'est censé être un fichier `csv` (Comma Separated Value, le standard
#' que VOUS DEVEZ absolument utiliser), les champs sont censés être séparés par
#' des fucking virgule. Mais Excel, dans sa grande mansuétude, utilise parfois
#' des fucking point-virgule. Donc si on fait simplement `read_csv()` :

read_csv(file = metadata_file)

#' Ça ne marche pas. Donc là on rage, on ferme R et on jure de ne plus jamais
#' mettre les pieds dans une console de RStudio.
#'
#' L'alternative, c'est d'utiliser `read_delim()` bien sagement, en indiquant à
#' R en quoi Excel est bête :

read_delim(
  file = metadata_file, # où est le fichier ?
  delim = ";", # quel est le caractère qui délimite les champs ?
  locale = locale(decimal_mark = ",") # quel est le caractère qui sépare les
  # entières des décimales
)

#' Et là ça marche ! Il y a plein de petites astuces comme ça, mais globalement
#' il y a toujours un moyen d'importer ses données. Quand on n'y arrive pas du
#' premier coup, c'est — souvent normal — mais souvent de notre faute, pas celle
#' de R ;)
#'
#' Sauvegardons le dans un objet `meta_df`.

meta_df <- read_delim(file = metadata_file, delim = ";",
                     locale = locale(decimal_mark = ","))

#' Chouette, on a importé les données dans R !
#'
#' Mais si on jette un œil à `df`, pleins de trucs ne vont pas.
#'
#' 1. il y a des caractères spéciaux dans les noms de colonne, type `# . - `.
#' 2. il y a des colonnes dont on n'a pas besoin.
#' 3. il y a énormément de colonnes.
#'
#' # Data Cleaning
#'
#' Commencons par traiter le premier point.
#'
#' Comme c'est relativement fréquent que les colonnes aient des noms bien
#' pourris, on imagine bien qu'il existe un package pour nettoyer les noms de
#' colonne.

library(janitor)

df <- clean_names(df)

colnames(df)

#' Cette fonction fait gagner beaucoup de temps, et convertit tout les noms de
#' colonnes en caractères uniquement composés de lettres en minuscule, de nombre
#' et de `_`.
#'
#' Chouette.
#'
#' Les noms de colonne sont vachement long par contre, notamment pour les
#' échantillons. Surtout que seules les cinq premières lettres servent à quelque
#' chose.
#'
#' On va donc supprimer les caractères qui ne servent à rien à l'aide d'un truc
#' super utile qu'on appelle les expressions régulières.

colnames(df) %>%
  #                     || .+ signifie "n'importe quel caractère autant de fois
  #                     || que vous voulez"
  gsub(pattern = "010000.+", replacement = "", x = .)

#' Ok ça a l'air de marcher (surprise surprise).
#'
#' Par contre il faut sauvegarder ce changement.

colnames(df) <-
  colnames(df) %>%
  gsub(pattern = "010000.+", replacement = "", x = .) %>%
  gsub(pattern = "_.+a$",    replacement = "", x = .) # essayer de deviner ce que cette ligne fait ?

colnames(df)

#' Chouette, on a l'air d'avoir des bons noms de colonne.
#'
#' Maintenant éliminons les colonnes qui ne servent à rien.

## pour comprendre la fonction unique :
unique(c(1, 2, 2, 3, 3, 3))
## maintenant on l'applique à un "vrai" vecteur :
unique(df$format)

#' Ok on n'a une seule valeur dans toute la colonne, on peut oublier celle là,
#' elle n'apporte rien.

unique(df$x_chrom)
unique(df$info)
unique(df$qual)

#' Idem pour ces trois là.
#'
#' On va les supprimer du jeu de donnée via la fonction `select()` du package
#' `dplyr` inclus dans le tidyverse.

df %>%
  select(-x_chrom, -format, -info, -qual)

#' Les colonnes inutiles ont été supprimées. Par contre il faut qu'on le
#' sauvegarde dans l'objet `df`.

df <- df %>%
  select(-x_chrom, -format, -info, -qual)

#' Super, on a traité les deux premiers points.
#'
#' Par contre, le troisième point — il y a énormément de colonnes — demande
#' qu'on se penche sur le problème d'un peu plus près.
#'
#' Il est symptomatique d'une erreur courante de "table design": les noms de
#' colonnes contiennent des valeurs. Ce qui signifie que notre table n'est pas
#' "rangée."
#'
#' # Tidy Data
#'
#' Dans R, il est préférable que les données soient rangées.
#'
#' Des données sont rangées quand :
#'
#' > 1. Chaque **variable** est une **colonne**.
#'
#' > 2. Chaque **observation** est une **ligne**.
#'
#' > 3. Chaque **valeur** est une **cellule**.
#'
#' ## Pourquoi ?
#'
#' Pour comprendre en quoi c'est important, on va regarder quatre petits jeux de
#' données qui sont présents dans le package `tidyr`.



#' Dans la table suivante, les données sont effectivement rangées.
#'
#' Chaque ligne correspond bien à une observation, toutes les colonnes sont des
#' variables et les cellules ne contiennent qu'une seule valeur mesurée à chaque
#' fois.

table1 %>% kable()

#' La table suivante n'est pas rangée, puisque la colonne type contient deux
#' types de valeur. Ça ne paraît pas très grave, mais c'est bien pénible quand
#' on est dans ce cas de figure.

table2 %>% kable()

#' La table suivante n'est pas rangée non plus, puisque les cellules de la
#' colonne `rate` contiennent deux types de valeurs. Il faut séparer les valeurs
#' de la colonne pour que la table soit rangée.

table3 %>% kable()

#' Les deux tables suivantes véhiculent la même info que les trois précédentes,
#' l'une contient le nombre de cas, l'autre la population.

table4a %>% kable()
table4b %>% kable()

#' Pour que vous compreniez en quoi c'est important — du moins pratique — que
#' les données soient rangées, on va calculer la fréquence de cas dans la
#' population.
#'
#' Commençons par les tables 4.

c(table4a[["1999"]], table4a[["2000"]]) /
  c(table4b[["1999"]], table4b[["2000"]]) * 1000


#' Pas super pratique, on est obligé d'extraire les bonnes colonnes quasiment à
#' la main. Il existe d'autre moyen de faire ça, en combinant les deux tables
#' par exemple. Peut-être dans un autre café ;) .
#'
#' Avec la table 3, comment on s'y prendrait ? Les valeurs qui nous intéressent
#' sont dans une seule colonne ?
#'
#' Pour faire court, on ne peut pas — du moins pas facilement — avec la syntaxe
#' classique de R.
#'
#' Avec la table 2, il faut qu'on démèle les valeurs de cas des valeurs de
#' population de la dernière colonne `count`.

table2$count[  c(1, 3, 5, 7, 9, 11) ]  /
  table2$count[c(2, 4, 6, 8, 10, 12)]

#' Ça marche pour une petite table, mais si la table fait 1M de lignes, ça va
#' pas le faire…
#'
#' Pour la table 1, easy peasy.

table1$cases / table1$population

#' OK j'espère que ce petit exemple simple vous a permis de comprendre en quoi
#' c'est important et pratique que les données soient rangées.
#'
#' Pour en comprendre plus sur les données rangées, aller donc voir [ce post de
#' blog](http://garrettgman.github.io/tidying/) par l'un des développeurs de
#' RStudio, il est vraiment bien fait.
#'
#' Vous pouvez essayer de calculer la moyenne des populations pour les quatre
#' tables. Vous verrez que c'est beaucoup plus pratique avec la table1.
#'
#' ## Comment ?
#'
#' Maintenant que vous avez compris que c'est important, on va voir comment
#' rendre les tables propres avec le package `tidyr`, qui est inclus dans le
#' package `tidyverse`.
#'
#' Commençons par nettoyer la table 2.
#'
#' Pour ça, il faut qu'on utilise la fonction `spread()`, qui "étale" une paire
#' key/value sur deux colonnes.
#'
#' Ici la "clé" est contenue dans la colonne `type`, et la "valeur" dans la
#' colonne `count`.

table2 %>%
  spread(key = type, value = count)

#' Easy peasy.
#'
#' Il se passe ça :
#'
#' ![](graphics/03-tidy-8.png)
#'
#' Maintenant on a bien une observation par ligne, une valeur par
#' cellule, une variable par colonne.
#'
#' Maintenant attaquons nous à la table 3.
#'
#' Pour ça, il faut qu'on utilise la fonction `separate()`, qui sépare une
#' colonne en deux, sur la base du ou des caractères qu'on précise dans
#' l'argument `sep`.
#'
#' Il faut donc qu'on précise 1) quelle colonne séparer, 2) le noms des deux (ou
#' plus) colonnes formées après la séparation et 3) le caractère qui sépare les
#' deux valeurs.

table3

table3 %>%
  separate(col = rate,                         # sépare la colonne rate
           into = c("cases", "population"),    # en deux colonnes
           sep = "/")                          # au niveau du caractère /

#' Easy peasy too.
#'
#' On a bien retrouvé une structure de table rangée.
#'
#' Maintenant la fonction qui est selon moi **la plus importante** et la plus
#' utile du package : `gather()`. Elle peut vous changer la vie. No fucking
#' kidding. Ask Theo.
#'
#' On va illustrer son rôle sur la table 4a et 4b.
#'
#' Le problème des tables 4 est qu'elles contiennent des valeur dans les noms de
#' colonne.
#'
#' C'est vraiment _vraiment_ **vraiment** VRAIMENT très courant.
#'
#' La fonction `gather()` permet de rectifier ça. Elle combine plusieurs
#' colonnes en paires de clé - valeur. C'est pas très parlant mais c'est très
#' utile quand on se rend compte qu'on a des colonnes qui ne sont pas des
#' variables.

table4a %>%
  gather(key = year, # les noms de colonne actuels représentent l'année
         value = cases, # les valeurs dans la table représentent le nombre de cas
         -country) # la colonne country contient déjà une seule valeur, donc on l'exclut

#' COOOOOOOOOOOOOOL !
#'
#' Hum.
#'
#' Il vient de se passer ça :
#'
#' ![](graphics/03-tidy-9.png)
#'
#' Maintenant revenons à nos données `df`.

df %>%
  gather(key = sample, value = genotype, -pos, -id, -ref, -alt, -filter)

#' Magique ! Maintenant notre table est rangée. Toutes les colonnes contiennent
#' bien une seule variable, chaque observation est une ligne, chaque valeur est
#' une cellule.
#'
#' On n'a juste pas sauvegardé le résultat de la fonction.

df <- df %>%
  gather(key = sample, value = genotype, -pos, -id, -ref, -alt, -filter)

#' ## Data Combining
#'
#' Souvent on a des données qui sont réparties dans plusieurs tables, pour plein
#' de raison. Il y a des moyens de fusionner des tables bien pratiques dans le
#' package `dplyr`.
#'
#' Par exemple, on peut fusionner la table `meta_df`, qui contient des
#' informations expérimentales sur les échantillons de la table `df`, avec la
#' table `df.

inner_join(
  x = df, # la première table
  y = meta_df, # la seconde table
  by = "sample" # par quelle colonne faire le joint ?
)

#' Ça marche pas. Parce que R est sensible à la casse (minuscules / MAJUSCULES).
#'
#' Il faut donc qu'on change la colonne `sample` de la table `meta_df`. On
#' pourrait le faire à part, mais pourquoi se compliquer la vie à créer un
#' nouvel objet ? On peut directement faire appel à la fonction `mutate` au sein
#' de l'appel à `inner_join()`. Oui, c'est un poil compliqué, mais c'est fait
#' exprès.


inner_join(
  x = df, # la première table
  # tolower veut dire "conversion en minuscules"
  y = mutate(meta_df, sample = tolower(sample)),
  # par quelle colonne faire le joint ?
  by = "sample"
)

#' Bon le join a fonctionné. Pour en comprendre plus sur les joints (pas de
#' vanne), je vous conseille [cette
#' page](https://cran.r-project.org/web/packages/dplyr/vignettes/two-table.html)
#' qui est rudement bien faite.
#'
#' Sauvegardons le résultat du joint dans notre table `df` de base.


df <- inner_join(
  x = df, # la première table
  # tolower veut dire "conversion en minuscules"
  y = mutate(meta_df, sample = tolower(sample)),
  # par quelle colonne faire le joint ?
  by = "sample"
)


#' Maintenant on est près à réaliser des figures bien WTF avec ggplot2 !
#'
#' # Transform and visualize !

df %>%
  filter(genotype != 0) %>%
  ggplot(aes(x = pos, y = sample)) +
  geom_point(aes(color = type), alpha = 0.2) +
  coord_polar() +
  labs(x = "", y = "", title = "Conversion hotspots in helicobacter genome") +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank())

#' Oh la belle figure !
