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
#' - second cours sur la grammaire des graphiques :
#'   [ici](https://sam217pa.github.io/cafe-du-mRcredi/02-premiers-graphiques.html)
