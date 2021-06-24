library(targets)
source("1_fetch/src/get_nwis_data.R")
source("2_process/src/process_and_style.R")
source("3_visualize/src/plot_timeseries.R")
#tar_option_set(debug = "site_data")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

####            p1_targets_list
site_nums = c("01427207", "01432160", "01435000", "01436690", "01466500")
####

####            p3_targets_list
p_width <- 12
p_height <- 7
p_units <- "in"
####


p1_targets_list <- list(
tar_target(
  nwis_01427207_data_csv,
  download_nwis_site_data(filepath = '1_fetch/out/nwis_01427207_data.csv'),
  format = "file"
),
tar_target(
  nwis_01432160_data_csv,
  download_nwis_site_data(filepath = '1_fetch/out/nwis_01432160_data.csv'),
  format = "file"
),
tar_target(
  nwis_01435000_data_csv,
  download_nwis_site_data(filepath = '1_fetch/out/nwis_01435000_data.csv'),
  format = "file"
),
tar_target(
  nwis_01436690_data_csv,
  download_nwis_site_data(filepath = '1_fetch/out/nwis_01436690_data.csv'),
  format = "file"
  ),
tar_target(
  nwis_01466500_data_csv,
  download_nwis_site_data(filepath = '1_fetch/out/nwis_01466500_data.csv'),
  format = "file"
  ),

  ##### changing this portion to allow return type of object
 
# tar_target(                   # to enable these, change the return type of download_nwis_site_data
#   nwis_01427207_data,
#   download_nwis_site_data(filepath = '1_fetch/out/nwis_01427207_data.csv'),
# ),
# tar_target(
#   nwis_01432160_data,
#   download_nwis_site_data(filepath = '1_fetch/out/nwis_01432160_data.csv'),
# ),
# tar_target(
#   nwis_01435000_data,
#   download_nwis_site_data(filepath = '1_fetch/out/nwis_01435000_data.csv'),
# ),
# tar_target(
#   nwis_01436690_data,
#   download_nwis_site_data(filepath = '1_fetch/out/nwis_01436690_data.csv'),
# ),
# tar_target(
#   nwis_01466500_data,
#   download_nwis_site_data(filepath = '1_fetch/out/nwis_01466500_data.csv'),
# ),

  #####

tar_target(
  site_data,
  concat_nwis_data(site_nums = site_nums), 
  ),
# site_data is the concatenatd dataframe of the seperate csv files, should get this to return
tar_target(
  site_info_csv,
  nwis_site_info(fileout = "1_fetch/out/site_info.csv", site_data),
  format = "file"
    )
  )


p2_targets_list <- list(
  tar_target(
    site_data_clean, 
    process_data(site_data)
  ),
  tar_target(
    site_data_annotated,
    annotate_data(site_data_clean, site_filename = site_info_csv)
  ),
  tar_target(
    site_data_styled,             # this is used to create the plot, this is why there is no out folder in process
    style_data(site_data_annotated)    
  )
)

p3_targets_list <- list(
  tar_target(
    figure_1_png,
    plot_nwis_timeseries(fileout = "3_visualize/out/figure_1.png", site_data_styled,
                         width = p_width, height = p_height, units = p_units),
    format = "file"
  )
)

# Return the complete list of targets
c(p1_targets_list, p2_targets_list, p3_targets_list)
