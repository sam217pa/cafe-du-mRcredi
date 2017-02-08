#' ---
#' title: "Et si on arrêtait les graphiques moches ?"
#' author: "Samuel BARRETO"
#' date:
#' output:
#'   html_document:
#'     highlight: tango
#'     theme: flatly
#'     code_folding: hide
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
rmarkdown::render("/Users/samuelbarreto/prof/cafe-du-mRcredi/05-fin-des-barplots.R",
                  encoding = "UTF-8")
## */

### ---------- Setup -------------------------------------------------------

library(readxl)
library(tidyverse)
library(scales)
library(samuer)
library(viridis)

df0 <- read_excel("./tmp/cafe5/data-raw/joris_0.xlsx")
DT::datatable(df0)

#' Supprimer les valeurs manquantes :

(df0 <- na.omit(df0))

df0 %>%
  ggplot(aes(x = Condition, y = Meth)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_errorbar(aes(ymin = Meth - Eceth, ymax = Meth + Eceth), width = 0.2) +
  facet_wrap(~jour, scales = "free_y")

(p1 <-
   df0 %>%
   select(Condition, jour, contains("M")) %>%
   gather(mesure, valeur, -Condition, -jour) %>%
   ggplot(aes(x = jour, y = valeur, fill = Condition)) +
   geom_bar(stat = "identity") +
   facet_grid(mesure~Condition, scales = "free") +
   scale_x_continuous(breaks = c(3, 7, 10, 14)))

#' Ok super, mais on n'a pas encore représenté pour les autres pics ! Il en
#' reste deux. Il n'y a pas beaucoup de données sur ce tableau. On n'a pas
#' d'idées de la variabilité. Est-ce que le plan expérimental est équilibré ?
#' Est-ce qu'il y a des valeurs manquantes ? Est-ce qu'il y ades valeurs
#' aberrantes ? Que cachent ces moyennes ? Est-ce que Joris est bien digne de
#' confiance ? Est-ce un con fini ?
#'
#' On a beaucoup plus de données que ça. Pourquoi se priver de les exploiter ?

df0 %>%
  gather(pic, valeur, -Condition, -jour) %>%
  filter(grepl("M", pic)) %>%
  ggplot(aes(x = jour, y = valeur, color = Condition)) +
  geom_point() +
  geom_line(aes(group = Condition), alpha = 0.3) +
  facet_wrap(~pic, scales = "free_y") +
  scale_y_log10()

#' L'ennui c'est que là on n'a pas d'idées de la variabilité, on ne représente
#' que la moyenne. Which sucks.


df <- read_excel("./tmp/cafe5/data-raw/joris.xlsx")
df <- janitor::clean_names(df)
(df <- df %>% rename(respiration = x_respiration, n = n_tube))
(df <- df %>% select(-n))

DT::datatable(df)

df %>%
  gather(mesure, valeur, -condition, -jour) %>%
  ggplot(aes(x = jour, y = valeur, color = condition)) +
  geom_point(position = position_dodge(width = 1)) +
  facet_wrap(~mesure, scales = "free") +
  scale_y_log10() +
  scale_color_viridis(discrete = TRUE, end = 0.8) +
  scale_x_continuous(breaks = c(3, 7, 10, 14))

#' Much better this :

df %>%
  gather(mesure, valeur, -condition, -jour) %>%
  ggplot(aes(x = jour, y = valeur, color = condition)) +
  geom_point() +
  geom_line(stat = "smooth",  method = "loess", alpha = 0.4) +
  facet_grid(mesure~condition, scales = "free") +
  scale_x_continuous(breaks = c(3, 7, 10, 14)) +
  scale_color_viridis(discrete = TRUE, end = 0.8) +
  guides(color = "none")

#' Than that :

p1 +
  scale_fill_viridis(discrete = TRUE, end = 0.8) +
  guides(fill = "none")
