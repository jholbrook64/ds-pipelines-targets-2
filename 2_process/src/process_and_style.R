#library(Rcpp)

process_data <- function(fileout, nwis_data)
  {
  nwis_data_clean <- rename(nwis_data, water_temperature = X_00010_00000) %>% 
    select(-agency_cd, -X_00010_00000_cd, -tz_cd)
  
    write_csv(nwis_data_clean, fileout)
  
  return(fileout) # object
}

# Rcpp::sourceCpp(code='
# #include <Rcpp.h>
# using namespace Rcpp;
# 
# // [[Rcpp::export]]
# DataFrame left_joinCpp(DataFrame site_data_clean, DataFrame site_info, Function left_join) {
# return(left_joinCpp(site_data_clean, DataFrame site_info, "site_no"));
# }')

annotate_data <- function(site_data_clean, site_filename)  # this should take a filein arg now. 
  {
  site_info <- read_csv(site_filename)
  site_data_clean <-  read_csv(site_data_clean)
  annotated_data <- left_join(site_data_clean, site_info, "site_no") %>% 
    select(station_name = station_nm, site_no, dateTime, water_temperature, latitude = dec_lat_va, longitude = dec_long_va)
  
  return(annotated_data) # object
}


style_data <- function(site_data_annotated)
  {
  mutate(site_data_annotated, station_name = as.factor(station_name))   # no return 
}