#' ---
#' title: "Café du mRcredi"
#' author: "Samuel BARRETO"
#' date:
#' output:
#'   html_document:
#'     highlight: tango
#'     theme: flatly
#' ---

### ---------- include = FALSE ---------------------------------------------
library(knitr)
opts_chunk$set(
  cache = FALSE, dev = 'png', include = TRUE,
  fig.path  = "graphics/", echo = TRUE, warning = FALSE,
  error = FALSE, message = FALSE, global.par = TRUE
)

## /*
rmarkdown::render("/Users/samuelbarreto/prof/cafe-du-mRcredi/index.R",
                  encoding = "UTF-8")
## */

#' - premier cours sur le tidyverse et tout ça :
#'   [ici](https://sam217pa.github.io/cafe-du-mRcredi/01-session-chauffe.html) -
#'   second cours sur la grammaire des graphiques :
#'   [ici](https://sam217pa.github.io/cafe-du-mRcredi/02-premiers-graphiques.html)
#'   - troisième cours sur l'importation et le nettoyage de données :
#'   [ici](https://sam217pa.github.io/cafe-du-mRcredi/03-data-import-and-clean.html)
#'   - quatrième cours sur la combinaison de données et l'analyse depuis
#'   l'import aux premiers graphiques :
#'   [ici](https://sam217pa.github.io/cafe-du-mRcredi/04-recapitulatif.html)
