# Remove all objects from the workspace (memory) of the R session
rm(list=ls())
gc()

# load the required packages
#library(ggmap)
library(here)
library(jsonlite)
library(httr)
#library(httr2)
library(rstudioapi)

# Download data cube from GBIF

api_url <- 'http://api.gbif.org/v1/occurrence/download/request/' #use GBIF API

# set gbif_user, gbif_pwd and gbif_email in your '.Renviron' https://discourse.gbif.org/t/setting-up-your-rgbif-environment-with-username-and-password/3017
gbif_info <- read.csv("C:/gitrepo/credentials.txt", header = FALSE);
gbif_user <- gbif_info[1,1];
gbif_pwd <- gbif_info[2,1];

path_out <- here("output/datacubes/csv/")

# Request data using GBIF API and your saved query
req <- request(api_url) |> 
  req_auth_basic(username = gbif_user, password = gbif_pwd) |> 
  req_headers("Content-Type" = "application/json") |> 
  req_retry(max_tries = 5) |>
  req_body_file(here("input/queries/query_exam3.json"), type = NULL)
#str(req)

# Perform the request and return the response (the response is a download ID)
response <- req |> req_perform()  |> resp_body_string()
response

response2 <- "0063029-240506114902167"

# Download the cube
download.file(paste0(data_url,response2,".zip"), destfile=paste0(path_out, response, ".zip"))
# or download manually from 
paste0(data_url,response2)

# Unzip
unzip(paste0(path_out,"/", response,".zip"), exdir=paste0(path_out,"/"))

# Load GBIF data cube
cin <- read.csv(paste0(path_out,"/",response,".csv"))




# Yaninas' query "0003342-240506114902167"
# Marteen's query "0007985-240506114902167"
# Marteen's query data =>2000  "0008022-240506114902167"
# Three species "0008059-240506114902167"

# from https://data-blog.gbif.org/post/gbif-api-beginners-guide/

POST(url = 'http://api.gbif.org/v1/occurrence/download/0003342-240506114902167',
config = authenticate(gbif_user, gbif_pwd), 
add_headers("Content-Type: application/json"),
body = upload_file(here("input/queries/query_exam2.json")), # path to your local file
encode = 'json') %>% 
content(as = "text")

