# Load necessary libraries
rm(list=ls())
gc()

library(sf)
library(terra)
library(dplyr)
library(ncdf4)


# Load precomputed EEA grid in raster format
eear <- rast(here("input/grid/eeagrid_10K.tif"))

# Load occurrence cube
gbifin <- "0063029-240506114902167.csv"
c <- read.csv(here(paste0("output/datacubes/csv/", gbifin)),  sep = "\t")
colnames(c)
typeof(c)
dim(c)

# Load precomputed centroids
eeacoor <- read.csv(here("input/grid/centroids/eeagrid_centroids_10K.csv"))
dim(eeacoor)
c[1:5,]
colnames(eeacoor)


# Merge pixel coordinates with coded EEA grid ID
clatlon <- merge(c, eeacoor, by="eeacellcode")
nspnames <- (unique(clatlon$specieskey))
clatlon[1:5,]
colnames(c)
typeof(clatlon)


# Create an empty raster specifying number of bands based on number of species
r <- rast(ext(eear), resolution=res(eear), nlyrs=length(unique(nspnames)), crs=crs(eear))
values(r) <- NA

spdf2 <- subset(clatlon, specieskey == nspnames[spx])
xyzin <- spdf2[,c("x", "y", "occurrences")]
i <- 5
r[[i]] <- rast(xyzin, type="xyz", crs=crs(eear), extent=ext(eear))

plot(r[[i]])

# Loop trough the raster to spatialize all species in the same stack
for (i in 1:length(unique(nspnames))){
  spdf <- as.matrix(clatlon %>% filter(specieskey == nspnames[i]))
  spdf2 <- subset(clatlon, specieskey == nspnames[i])
  print(i)
  r[[i]]  <- rast(spdf2[,c("x", "y", "occurrences")], type="xyz", crs=crs(eear), extent=ext(eear))
}
