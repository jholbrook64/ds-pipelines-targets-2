#library(targets)

# source from script
source("1_fetch/src/get_nwis_data.R")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

####            p1_targets_list
site_nums = c("01427207", "01432160", "01435000", "01436690", "01466500")
####

p1_targets_list <- list(
  tar_target(               
    nwis_01427207_data,
    download_nwis_site_data(filepath = '1_fetch/out/nwis_01427207_data.csv'),
  ),
  tar_target(
    nwis_01432160_data,
    download_nwis_site_data(filepath = '1_fetch/out/nwis_01432160_data.csv'),
  ),
  tar_target(
    nwis_01435000_data,
    download_nwis_site_data(filepath = '1_fetch/out/nwis_01435000_data.csv'),
  ),
  tar_target(
    nwis_01436690_data,
    download_nwis_site_data(filepath = '1_fetch/out/nwis_01436690_data.csv'),
  ),
  tar_target(
    nwis_01466500_data,
    download_nwis_site_data(filepath = '1_fetch/out/nwis_01466500_data.csv'),
  ),
  tar_target(
    site_data,
    bind_rows(nwis_01466500_data, nwis_01436690_data, nwis_01435000_data, nwis_01432160_data, nwis_01427207_data)
  ),
  tar_target(
    site_info_csv,
    nwis_site_info(fileout = "1_fetch/out/site_info.csv", site_data),
    format = "file"
  )
)