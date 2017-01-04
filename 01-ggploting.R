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
  fig.path  = "graphics/", echo = TRUE, warning = FALSE,
  error = FALSE, message = FALSE, global.par = TRUE
)

## /*
rmarkdown::render("/Users/samuelbarreto/prof/cafe-du-mRcredi/01-ggploting.R", encoding = "UTF-8")
## */

### ---------- Setup -------------------------------------------------------


#' # Installation et chargement des packages
#'
#' On fait appel a des extensions dans R avec la fonction `library`.
#'
#' R n'est rien sans ses extensions.
#'
#' Un petit package maison :
library(samuer)

#' Ça un package pour charger un jeu de donnée :
library(babynames)

#' Pour installer un package dans R :
## install.packages("babynames")

#' S'il est sur le CRAN, chouette. Sinon, il est peut être dans un répertoire privé du développeur.

## install.packages("devtools")
## devtools::install_github("karthik/wesanderson")

#' Ça c'est le package avec lequel on va bosser pendant un bon moment :
library(tidyverse) # install.packages("tidyverse")

#' Ça c'est un package qui permet de rajouter des palettes de couleur à certains graphiques.
library(wesanderson) # install.packages("wesanderson")

#' Ça aussi. Plus jamais des heatmaps dégueulasses.
library(viridis) # install.packages("viridis")

#' Ça c'est chelou, mais on verra en temps voulu.
library(forcats) # install.packages("forcats")

#' ---
#'
#' # Exploration des données
#'
#' Pour l'instant on commence avec des données simples, pour pouvoir faire des
#' beaux graphiques dans l'heure. Dans la suite, on apprendra à importer ses
#' données dans R, et à faire des graphiques à partir de ses propres données.
#'
#' Un vecteur auquel on attribue une liste de participants :

participants <- c("Samuel", "Lise", "Benjamin", "Yoan", "Yoann",
                 "Morgane", "Laura", "Marine", "William", "Quentin",
                 "Rosa", "Aurelie", "Jordan")

#' Une fonction simple pour connaître la longueur de ce vecteur :
length(participants)

babynames %>%
  mutate(name = gsub("^Sam$", "Samuel", name),
         name = gsub("^Yoan$", "Yoann", name)) %>%
  filter(name %in% participants) %>%
  group_by(name, year) %>%
  summarise(n = sum(n)) %>%
  ggplot(aes(x = year, y = n)) +
  geom_smooth(se = FALSE, color = "gray") +
  geom_point(aes(color = name), alpha = 1/2) +
  facet_wrap(~name, scales = "free_y") +
  scale_color_viridis(discrete = TRUE, begin = 0.1, end = 0.9) +
  guides(color = "none")

babynames %>%
  filter(name %in% participants) %>%
  arrange(desc(n)) %>%
  mutate(name = fct_inorder(name)) %>%
  ggplot(aes(n)) +
  geom_point(aes(color = name), stat = "bin") +
  facet_wrap(~name, scales = "free") +
  scale_color_viridis(discrete = TRUE, begin = 0.1, end = 0.9) +
  guides(color = "none")


babynames %>%
  filter(name %in% c("Osama", "Beyonce", "Vladimir", "Donald", "Thibault")) %>%
  group_by(name, year) %>%
  summarise(n = sum(n)) %>%
  ggplot(aes(x = year, y = n)) +
  geom_line(color = "gray") +
  geom_point() +
  facet_wrap(~name, scales = "free") +
  labs(x = "Year", y = "", title = "Nombre de prénoms") +
  theme(axis.title.x = element_text(hjust = 0.7))

babynames %>%
  filter(name %in% participants) %>%
  arrange(desc(n)) %>%
  mutate(name = fct_inorder(name)) %>%
  group_by(name, year) %>%
  summarise(n = sum(n)) %>%
  ggplot(aes(x = year, y = name)) +
  geom_jitter(aes(color = n, fill = n, size = n), shape = 22, height = 0.1) +
  scale_color_viridis(trans = "log10", begin = 1, end = 0) +
  scale_fill_viridis(trans = "log10", begin = 1, end = 0) +
  guides(size = "none", color = guide_legend(title = "Nombre"))
