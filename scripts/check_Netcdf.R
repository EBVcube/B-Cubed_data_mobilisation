library(ncdf4)
library(ebvcube)
library(terra)
library(here)



c <- rast(here("output/datacubes/nc/IAS_all_metrics.nc"))

test <- c[,,385]
unique(test)
