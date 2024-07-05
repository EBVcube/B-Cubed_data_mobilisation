rm(list=ls())
gc()

library(ebvcube)
library(here)
library(terra)

# Notes
# What is the difference between the dictionary and taxonomy files?
# error producing ebv_create_taxonomy

# paths
json <- file.path(here("input/ebvformat/json/metrics_dates.json"))
out <- file.path(here("output/datacubes/nc/IAS_dates_metrics.nc")) # modify

# tifs
tif_root <- here("output/datacubes/tiff_metrics/")

# taxonomy file
tax <- file.path(here("input/data/ias_10/taxonomy/List77IAS_EU_match_gbif_synonyms_ebvcube.csv"))

# input rasters
r <- rast(here("output/datacubes/tif_metrics/ias_total_occurrences.tif")) # reference raster
r2 <- rast(here("output/datacubes/tif_metrics/ias_earliest_date_records.tif")) # reference raster
r3 <- rast(here("output/datacubes/tif_metrics/ias_latest_date_records.tif")) # reference raster

# define raster settings
extent <- c(ext(r)[1], ext(r)[2], ext(r)[3], ext(r)[4])
res <- res(r)
fillvalue <- NaN
prec <- 'integer'
epsg <- 3035
sep <- ','

# species key to sort the data
spskey <- names(r)
spstax <- read.csv(here("input/data/ias_10/taxonomy/List77IAS_EU_gbif_accepted_ebvcube+key.csv"))
spstax$species == spskey

#create empty file
ebv_create_taxonomy(jsonpath = json,
           outputpath = out,
           taxonomy = tax,
           epsg = epsg,
           extent = extent,
           resolution = res,
           fillvalue = fillvalue,
           prec = prec,
           sep = sep,
           overwrite=T
)


ebv_datacubepaths(out)
ebv_properties(out, metric=1)

#add data -----
#get entity names
entity_names <- ebv_properties(out, verbose=F)@general$entity_names
colnames(spstax)

i <- 1
spstax[["key"]][i]

spskey

#i don't know which layer belongs to which species so the data is is not mapped correctly to the entity names (species)!! 
for(i in 1:77){
spx <- which(spskey == spstax[["key"]][i])
  ebv_add_data(filepath_nc = out,
               data = terra::as.matrix(r[[spx]], wide=T),
               #band = i,
               metric = 1,
               entity = i,
               timestep = 1,
               ignore_RAM = T)

  ebv_add_data(filepath_nc = out,
               data = terra::as.matrix(r2[[spx]], wide=T),
               #band = i,
               metric = 2,
               entity = i,
               timestep = 1,
               ignore_RAM = T)

  ebv_add_data(filepath_nc = out,
               data = terra::as.matrix(r3[[spx]], wide=T),
               #band = i,
               metric = 3,
               entity = i,
               timestep = 1,
               ignore_RAM = T)
}
