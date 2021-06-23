## ---------------------------
##
## Script name: getnwis data
##
## Purpose of script:
##
## Author: Jack Holbrook (USGS)
##
## ---------------------------
## Notes:
##     ~  this holds 2 separate functions that download data from leaky server, and 1 function that creates a 
## ---------------------------


# 1st funciton
download_nwis_data <- function(site_nums, parameterCd = '00010')  
{
  repoFiles <- file.path("1_fetch/out", paste0('nwis_', site_nums, '_data.csv'))
  browser()
  data_out <- data.frame(agency_cd = c(), site_no = c(), dateTime = c(),           
                         X_00010_00000 = c(), X00010_00000_cd = c(), tz_cd = c())
  for (data in repoFiles)
  {
    these_data <- read_csv(data, col_types = 'ccTdcc')      
    data_out <- bind_rows(data_out, these_data)        # all this should do is append for each iteration
  }
  return(data_out)
}


nwis_site_info <- function(fileout, site_data)
{
  site_no <- unique(site_data$site_no)
  site_info <- dataRetrieval::readNWISsite(site_no)
  write_csv(site_info, fileout)
  return(fileout)
}
            

# 3rd function
# filepaths look something like directory/nwis_01432160_data.csv,     check that the source is in this format
# remove the directory with basename() and extract the 01432160 with the regular expression match
download_nwis_site_data <- function(filepath, parameterCd = '00010', startDate="2014-05-01", endDate="2015-05-01")
  {  
  site_num <- basename(filepath) %>% 
    stringr::str_extract(pattern = "(?:[0-9]+)")  # this gets the number from the csv identifier
    
  data_out <- readNWISdata(sites=site_num, service="iv", 
                             parameterCd = parameterCd, startDate = startDate, endDate = endDate)
  # -- simulating a failure-prone web-sevice here, do not edit --
  set.seed(Sys.time())
  if (sample(c(T,F,F,F), 1)){
  stop(site_num, ' has failed due to connection timeout. Try tar_make() again')    # does this means it stops at time 1000?
  }
  # -- end of do-not-edit block
  
  write_csv(data_out, file = filepath)
  return(filepath)
  
}

