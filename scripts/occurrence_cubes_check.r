rm(list=ls())
gc()

library(here)
library(ggplot2)
library(dplyr)

c1 <- read.csv(here(paste0("output/datacubes/csv/","0077925-240506114902167.csv")),  sep = "\t")
c2 <- read.csv(here(paste0("output/datacubes/csv/","0063029-240506114902167.csv")),  sep = "\t")

c1keys <- unique(c1$specieskey)
c2keys <- unique(c2$specieskey)

length(c1keys)
length(c2keys)

# list of all IAS species key in GBIF
allspnames <- read.csv(here("input/data/ias_10/ias_gbif_key_vertical.txt"), header=FALSE)
unique(allspnames)

exc1 <- setdiff(allspnames$V1, c1$specieskey)
exc2 <- setdiff(allspnames$V1, c2$specieskey)

exc1x <- setdiff(c1$specieskey, allspnames$V1)
exc2x <- setdiff(c2$specieskey, allspnames$V1)

# 