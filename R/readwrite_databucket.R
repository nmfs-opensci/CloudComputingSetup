# R code to read and write data to a Google bucket
# Current code links to a data bucket set up by SEFSC located at...
# https://console.cloud.google.com/storage/browser/mollystevens-gcwpilot;tab=objects?inv=1&invt=Ab4Pyw&pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22))&prefix=&forceOnObjectsSortingFiltering=false
# Permissions to view, read, and write to this data bucket must be amended by SEFSC IT
# Author: Molly Stevens

##List files in the entire bucket
list.files("~/my_gcs_bucket")

##List files in the desired folder 
list.files(path = "~/my_gcs_bucket/CloudComputingSetup")

## read in .RData from data bucket
load('~/my_gcs_bucket/CloudComputingSetup/bsh_agg.RData') 

## read in .csv from data bucket
data <- read.csv("~/my_gcs_bucket/CloudComputingSetup/sampdata.csv")

## amend .csv, test write.csv
library(tidyverse)
data2 <- data %>% mutate(testvar=1)
write.csv(data2,"~/my_gcs_bucket/CloudComputingSetup/sampdata3.csv")
