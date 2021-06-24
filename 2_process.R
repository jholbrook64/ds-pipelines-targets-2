#library(targets)

# source file from script
source("2_process/src/process_and_style.R")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

p2_targets_list <- list(
  tar_target(
    #dir.create("2_process/out/"),
    site_data_clean_csv, 
    process_data(fileout = "2_process/out/cleanData.csv", site_data),
    format = "file"
  ),
  tar_target(
    site_data_annotated,
    annotate_data(site_data_clean = site_data_clean_csv, site_filename = site_info_csv)
  ),
  tar_target(
    site_data_styled,             # this is used to create the plot, this is why there is no out folder in process
    style_data(site_data_annotated)    
  )
)