rm(list=ls())
gc()

library(ebvcube)
library(here)
library(terra)

# Notes
# What is the difference between the dictionary and taxonomy files?
# error producing ebv_create_taxonomy

#paths
json <- file.path(here("input/ebvformat/json/metrics_dates.json"))
out <- file.path(here("output/datacubes/nc/IAS_dates_metrics.nc")) # modify
#tifs
tif_root <- here("output/datacubes/tiff_metrics/")
#taxonomy file
tax <- file.path(here("input/data/ias_10/List87IAS_EU_match_gbif_synonyms_ebvcube.csv"))

# define raster settings
r <- rast(here("output/datacubes/tif_metrics/ias_earliest_date_records.tif")) # reference raster
extent <- c(ext(r)[1], ext(r)[2], ext(r)[3], ext(r)[4])
res <- res(r)
fillvalue <- NaN
prec <- 'integer'
epsg <- 3035
sep <- ','

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

#i don't know which layer belongs to which species so the data is is not mapped correctly to the entity names (species)!! 
for(i in 1:77){
  ebv_add_data(filepath_nc = out,
               data = terra::as.matrix(r[[i]], wide=T),
               band = i,
               metric = 1,
               entity = i,
               timestep = 1,
               ignore_RAM = T)
}

