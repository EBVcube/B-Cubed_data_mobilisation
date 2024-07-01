rm(list=ls())
gc()

library(ebvcube)
library(here)
library(terra)

# Notes
# What is the difference between the dictionary and taxonomy files?
# error producing ebv_create_taxonomy


#paths
id <- 1 #modify
# root <- paste0('I:\\biocon\\Quoss_Luise\\netcdf\\netcdf_creation\\ebv_portal\\', id)
json <- file.path(here("input/ebvformat/json/metrics_dates.json")) #root, 'metadata_v2.json')
# csv <- file.path(root, paste0('entities_',id,'.csv'))
out <- file.path(here("output/datacubes/nc/IAS_dates_metrics.nc")) # modify

#tifs
tif_root <- here("output/datacubes/tiff_metrics/")
# tif_folders <- file.path(list.dirs(tif_root, recursive = F), 'AOH_land_use_only')
# dict <- file.path(root, 'dictionary.csv')
tax <- file.path(here("input/data/ias_10/List87IAS_EU_match_gbif_synonyms.csv"))
dict <- tax

# define raster settings
r <- rast(here("output/datacubes/tif_metrics/ias_earliest_date_records.tif")) # reference raster
extent <- c(ext(r)[1], ext(r)[2], ext(r)[3], ext(r)[4])
res <- res(r)
fillvalue <- NA
prec <- 'INT4U'
epsg <- 3035 #crs(r)
sep <- ','

#create empty file
ebv_create_taxonomy(jsonpath = json,
           outputpath = out,
           taxonomy = tax,
           epsg = epsg,
           extent = extent,
           resolution = res,
           fillvalue = fillvalue,
           prec = 'float',
           sep = sep
)
# lsid = FALSE,
#            force_4D = TRUE,
#            overwrite = TRUE,
#            verbose = TRUE)

ebv_datacubepaths(out)
ebv_properties(out, 'scenario_1/metric')

#add data -----
#read dictionary with taxon keys
dict_data <- read.csv(dict)

#get entity names
entity_names <- ebv_properties(out, verbose=F)@general$entity_names