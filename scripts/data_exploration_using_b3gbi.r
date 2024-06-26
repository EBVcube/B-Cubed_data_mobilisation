rm(list=ls())
gc()

library(b3gbi) # for csv occurrence cubes
library(purrr) # for data summary and grouping
library(here)
library(dplyr)
library(lubridate) # for dates
library(terra) # for raster

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



min_max_dates <- function(cin, gridin, coorin, fundates){
  # find number of species
  spskey <- unique(cin[["data"]][["taxonKey"]])

  # create empty raster
  r <- rast(ext(gridin), resolution=res(gridin), nlyrs=length(spskey), crs=crs(gridin))
  values(r) <- NA

# if (fundates =! "earliest dates"){
#     print('This metric is not included')
# } else {
  for (i in 1:5){ #length(spskey)
    # subset one species
    spsi <- cin[["data"]][cin[["data"]]$taxonKey == spskey[i], ]

    # add a new column for decimal dates
    spsi$decimalDate <- format(ym(spsi$yearMonth), "%Y%m")
    spsi$decimalDate <- as.numeric(spsi$decimalDate)

    if (fundates == "earliest dates"){
    # find metric. In this example earliest date of record
    metricx <- spsi %>%
      group_by(cellCode) %>%
      slice_min(decimalDate, with_ties = FALSE) %>%
      ungroup()
    metricx
    } else if (fundates == "latest dates") {
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
    } else {
          print('This metric is not included')
    }

  # print(i)
  # print(dim(metriccoor))
  
  # rasterize data
  r[[i]]  <- rast(metriccoor[,c("x", "y", "decimalDate")], type="xyz", crs=crs(gridin), extent=ext(gridin))
  }

  return(r)
}

# }



min_dates <- min_max_dates(cin, gridin, coorin, "earliest dates")
max_dates <- min_max_dates(cin, gridin, coorin, "latest dates")

test_dates <- min_max_dates(cin, gridin, coorin, "hi")
