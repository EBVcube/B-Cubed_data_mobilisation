# Load necessary libraries
rm(list=ls())
gc()

library(here)
library(ggplot2)
library(httr)
library(httr2)
library(jsonlite)
library(b3gbi)

# Download data cube from GBIF

# First you need to create the query to build the data cube (follow https://techdocs.gbif.org/en/data-use/data-cubes)
# An example query to get a data cube for all mammals in Europe can be found in data/example_query_file.json

data_url <- 'http://api.gbif.org/v1/occurrence/download/request/' #use GBIF API

# set gbif_user, gbif_pwd and gbif_email
gbif_info <- read.csv("C:/gitrepo/credentials.txt", header = FALSE);
my_username <- gbif_info[1,1]; # 'your_username'
my_password <- gbif_info[2,1]; # 'your_password'

path_out <- here("output/datacubes/csv")
myfile <- "query_IAS_all+gbifnames.json"# "query_reptiles_1sp.json"

# Request data using GBIF API and your saved query
req <-  request(data_url) |> 
  req_auth_basic(username = my_username, password = my_password) |> 
  req_headers("Content-Type" = "application/json") |> 
  req_retry(max_tries = 5) |>
  req_body_file(here(paste0("input/queries/", myfile)), type = NULL)

# Perform the request and return the response (the response is a download ID)
response <- req |> req_perform()  |> resp_body_string()

#response <- "0081452-240506114902167" 20240619

# Download the cube
download.file(paste0(data_url,response,".zip"), destfile=paste0(path_out, response, ".zip"))
# or download manually from 
paste0(data_url,response)

# Unzip
unzip(paste0(path_out,"/", response,".zip"), exdir=paste0(path_out,"/"))


response2 <- "0063029-240506114902167"
# Load GBIF data cube
cin <- read.csv(paste0(path_out,"/",response2,".csv"))
colnames(cin)

path_data <- "input/data/ias_10/"
c <- read.csv(here(paste0(path_data,"0013719-240506114902167.csv")),  sep = "\t")
colnames(c)
dim(c)

# Identify size of the species dimension
nsps <- length(unique(c$specieskey))

# Identify data span 
test <- seq(as.Date("2000/01/01"), by = "month", length.out = 288) # from Jan. 2000 to Dec. 2023
taxis <- as.Date(test, format="%y%m")
nt <- length(taxis)

# Load grid and identity number of pixels by latitude and longitude
latlon <- read.csv(here(paste0("input/grid/eeagrid_10km/lat_lon_centroid_reference_grid_10x10.csv")))
nlat <- length(unique(latlon$latitude_centroid))
nlon <- length(unique(latlon$longitude_centroid))
colnames(latlon)
clatlon <- merge(c, latlon)

# create empty multidimensional array
empty <- array(numeric(),c(nlat,nlon,nsps,nt)) 
dim(empty)

#lapply(all.inc, function(x) split(x, x$pat))

cbysp <- split(clatlon, clatlon$specieskey)
length(cbysp)
tunique <- unique(cbysp[[4]]$yearmonth)

test <- split(cbysp[[4]], cbysp[[4]]$yearmonth)

length(test)

csp <- cbysp[[4]]

# Rasterise eeagrid
library(raster)
?rasterize


# Prepare cube using b3gbi
#sp_data <- process_cube(cube_name, tax_info)
