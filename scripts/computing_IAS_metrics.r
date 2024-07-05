rm(list=ls())
gc()

library(b3gbi) # for csv occurrence cubes
library(purrr) # for data summary and grouping
library(here)
library(dplyr)
library(lubridate) # for dates
library(terra) # for raster
library(ncdf4)

# load occurrence cube using b3gbi
cin <- process_cube(here(paste0("output/datacubes/csv/","0077925-240506114902167.csv")))

# load precomputed centroids for EEA 10 km grid
coorin <- read.csv(here("input/grid/centroids/eeagrid_centroids_10K.csv"))
colnames(coorin)

# load reference EEA grid in raster format
gridin <- rast(here("input/grid/eeagrid_10K.tif"))
res <- res(gridin)[1] #resolution of reference raster

# replace by corresponding column name of input dataset
colnames(coorin)[colnames(coorin) == "eeacellcode"] <- "cellCode"

# find number of species
spskey <- unique(cin[["data"]][["taxonKey"]])

# create empty raster
r <- rast(ext(gridin), resolution=res(gridin), nlyrs=length(spskey), crs=crs(gridin))
values(r) <- NA



min_max_dates <- function(cin, gridin, coorin, fxdates){
  # find number of species
  spskey <- unique(cin[["data"]][["taxonKey"]])

  # create empty raster
  r <- rast(ext(gridin), resolution=res(gridin), nlyrs=length(spskey), crs=crs(gridin))
  values(r) <- NA

# if (fxdates =! "earliest dates"){
#     print('This metric is not included')
# } else {
  for (i in 1:length(spskey)){  # 
    
    # subset one species
    spsi <- cin[["data"]][cin[["data"]]$taxonKey == spskey[i], ]

    # add a new column for decimal dates
    spsi$decimalDate <- format(ym(spsi$yearMonth), "%Y%m")
    spsi$decimalDate <- as.numeric(spsi$decimalDate)

    if (fxdates == "earliest dates"){
    # find metric. In this example earliest date of record
    metricx <- spsi %>%
      group_by(cellCode) %>%
      slice_min(decimalDate, with_ties = FALSE) %>%
      ungroup()
    metricx
    } else if (fxdates == "latest dates") {
    # find metric. In this example latest date of record
    metricx <- spsi %>%
      group_by(cellCode) %>%
      slice_max(decimalDate, with_ties = FALSE) %>%
      ungroup()
    metricx
    }

    # merge pixel coordinates with the corresponing EEA grid ID
    metriccoor <- merge(metricx[,c("decimalDate", "cellCode")], coorin, by="cellCode")

    # check for a few occurrences. Only 1 occurrence cannot be rasterised, and error extente when they are very few.
    if(length(unique(metriccoor$x)) < 5){
      #add second empty point
      x <- metriccoor$x[1] + res
      y <- metriccoor$y[1] + res
      metriccoor <- rbind(metriccoor, c(NA, NA ,NA, x, y))
    }

  print(i)
  print(dim(metriccoor))
  
  # rasterize data
  r[[i]]  <- rast(metriccoor[,c("x", "y", "decimalDate")], type="xyz", crs=crs(gridin), extent=ext(gridin))
  }

  return(r)
}


min_dates <- min_max_dates(cin, gridin, coorin, "earliest dates")
names(min_dates) <- spskey

max_dates <- min_max_dates(cin, gridin, coorin, "latest dates")
names(min_dates) <- spskey

# plotting data before saving
plot(min_dates[[40]])

plot(max_dates[[40]])

i <- 1
# calculate total number of occurrences per pixel
total_occ <- function(cin, gridin, coorin){
    
  # find number of species
  spskey <- unique(cin[["data"]][["taxonKey"]])

  # create empty raster
  r <- rast(ext(gridin), resolution=res(gridin), nlyrs=length(spskey), crs=crs(gridin))
  values(r) <- NA

   for (i in 1:length(spskey)){ 
  
    # subset one species
    spsi <- cin[["data"]][cin[["data"]]$taxonKey == spskey[i], ]

    # sum up the total number of occurrences per cellCode
    metricx <- spsi %>%
      group_by(cellCode) %>%
       summarize(total_occurrences = sum(obs), cellCode = first(cellCode))
    
    # merge pixel coordinates with the corresponing EEA grid ID
    metriccoor <- merge(metricx[,c("total_occurrences", "cellCode")], coorin, by="cellCode")

    # check for a few occurrences. Only 1 occurrence cannot be rasterised, and error extente when they are very few.
    if(length(unique(metriccoor$x)) < 5){
      #add second empty point
      x <- metriccoor$x[1] + res
      y <- metriccoor$y[1] + res
      metriccoor <- rbind(metriccoor, c(NA, NA ,NA, x, y))
    }

  print(i)
  print(dim(metriccoor))
  
  # rasterize data
  r[[i]]  <- rast(metriccoor[,c("x", "y", "total_occurrences")], type="xyz", crs=crs(gridin), extent=ext(gridin))
    } 
  
  return(r)

}

total_occ_sps <- total_occ(cin, gridin, coorin)
names(total_occ_sps) <- spskey

# saving data sets as separate tiffs
writeRaster(min_dates, here("output/datacubes/tif_metrics/ias_earliest_date_records.tif"), datatype = 'INT4U', overwrite = TRUE)
writeRaster(max_dates, here("output/datacubes/tif_metrics/ias_latest_date_records.tif"), datatype = 'INT4U', overwrite = TRUE)
writeRaster(total_occ_sps, here("output/datacubes/tif_metrics/ias_total_occurrences.tif"), datatype = 'INT4U')

# filter taxonomy file for only species with data
# import file for all IAS taxonomy and following the ebvcube format
tax <- read.csv(here("input/data/ias_10/taxonomy/List87IAS_EU_match_gbif_synonyms_ebvcube.csv"))
# import file for all IAS taxonomy using gbif backbone taxonomy
gbif <- read.csv(here("input/data/ias_10/taxonomy/List87IAS_EU_match_gbif_allaccepted.csv"))
# subset only for species with data occurrences in GBIF
gbif_spx <- gbif %>%
  filter(key %in% spskey)
dim(gbif_spx)

gbif_spx$key
spskey[73:77]

colnames(tax)
gbif_spx2 <- gbif_spx[,c("kingdom", "phylum", "class", "order", "family", "genus", "species", "key")]

write.csv(gbif_spx2, here("input/data/ias_10/taxonomy/List77IAS_EU_gbif_accepted_ebvcube+key.csv"))
