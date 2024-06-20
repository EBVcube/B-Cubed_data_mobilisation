# Load necessary libraries
rm(list=ls())
gc()

library(here)
library(sf)
library(terra)
library(dplyr)


# Load eea grid vector file
resx <- "100K" # "10K" or "100K" # define vector file spatial resolution
#gridin <- st_read("C:/data/grid/eea_v_3035_10_km_eea-ref-grid-europe_p_2011_v01_r00/Grid_ETRS89-LAEA_10K.shp")
gridin <- st_read("C:/data/grid/eea_v_3035_100_km_eea-ref-grid-europe_p_2011_v01_r00/Grid_ETRS89-LAEA_100K.shp")


crs(gridin)

eo <- length(unique(gridin$EofOrigin))
no <- length(unique(gridin$NofOrigin))

# Create raster from vector file
eear <- rast(gridin, nrows=no, ncols=eo, nlyrs=1, crs(gridin), vals=gridin$NofOrigin) #, extent, resolution, vals, names, time, units)
plot(eear)

# Write raster
#writeRaster(eear, here(paste0("input/grid/eeagrid_", resx, ".tif")), datatype = 'INT4S', overwrite=TRUE)


# Subset of the eea grid centroids
gridxy <- st_coordinates(st_centroid(gridin))
gridin$x <- gridxy[,1]
gridin$y <- gridxy[,2]
eeax <- as.data.frame(gridin)
head(eeax)
eeacoor <- data.frame(eeax[,1], eeax[,5], eeax[,6])
colnames(eeacoor) <- c("eeacellcode", "x", "y")
dim(eeacoor)
eeacoor[1:5,]

write.csv(eeacoor, here(paste0("input/grid/centroids/eeagrid_centroids_", resx, ".csv")))#, overwrite=TRUE,  datatype = 'INT4S', )