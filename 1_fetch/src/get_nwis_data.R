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
##     ~  this holds 2 separate functions that download data from leaky server
## ---------------------------


# 1st fubncitonl
download_nwis_data <- function(site_nums, parameterCd = '00010')
{
repoFiles <- file.path("1_fetch/out", paste0('nwis_', site_nums, '_data.csv'))
browser()
data_out <- data.frame(agency_cd = c(), site_no = c(), dateTime = c(),           # standard to dataRetrieval library
                       X_00010_00000 = c(), X00010_00000_cd = c(), tz_cd = c())
for (data in repoFiles){
  these_data <- read_csv(data, col_types = 'ccTdcc')                  # set the return inside here
  finalDf <- bind_rows(data_out, these_data)
  }
return(finalDf)
}

# 1.5st function (is not being used)
download_nwis_data2 <- function(site_nums, parameterCd = '00010') # c("01432160", "01436690") <- simple vector that works without changing dates
{
  # create the file names that are needed for download_nwis_site_data
  # tempdir() creates a temporary directory that is wiped out when you start a new R session;           # changed 
  # replace tempdir() with "1_fetch/out" or another desired folder if you want to retain the download
  download_files <- file.path("1_fetch/out", paste0('nwis_', site_nums, '_data.csv'))
  ?browser()
  data_out <- data.frame(agency_cd = c(), site_no = c(), dateTime = c(),           # standard to dataRetrieval library
                         X_00010_00000 = c(), X00010_00000_cd = c(), tz_cd = c())
  
  # loop through files to download 
  plzStart <- "2014-05-01"
  plzStop  <- "2015-05-01"                # paramters modifiable: dcreasing the expanse of time had no affect on build/fail
  
  checkExists(download_files, plzStop)      # used to check if we need to update the or not
  
  for (download_file in download_files){                               # set start and end dates in here
    download_nwis_site_data(download_file, parameterCd =  parameterCd, plzStart, plzStop)
    # read the downloaded data and append it to the existing data.frame
    
    these_data <- read_csv(download_file, col_types = 'ccTdcc')                  # set the return inside here
    data_out <- bind_rows(data_out, these_data)
  }
  return(data_out)
}

# optional function
checkExsits <- function(download_files, endDate, filepath){
  for (data in download_files) {
    these_data <- read_csv(download_file, col_types = 'ccTdcc')    # actually I shouldn't use this
    if (!dir.exists(data) & !data$dateTime.tail() == endDate) {
      write.csv(data, filepath)
    }
    else 
      download_nwis_site_data(data, parameterCd = '00010', startDate="2014-05-01", endDate="2015-05-01")
  } 
}


# 2nd function
nwis_site_info <- function(fileout, site_data){
  site_no <- unique(site_data$site_no)
  site_info <- dataRetrieval::readNWISsite(site_no)
  write_csv(site_info, fileout)
  return(fileout)
}
                   

# 3rd funciton
download_nwis_site_data <- function(filepath, parameterCd = '00010', startDate="2014-05-01", endDate="2015-05-01")
  {  # changed this function signature too
  # remove the directory with basename() and extract the 01432160 with the regular expression match
  site_num <- basename(filepath) %>% 
    stringr::str_extract(pattern = "(?:[0-9]+)")  # this gets the number from the csv identifier
  
  if (!dir.exists(file.path("1_fetch/out", paste0('nwis_', site_nums, '_data.csv')))) # this produces warning, but the warning is only about the length of the input, since there is an input vector that is iterated through
    {
    # readNWISdata is from the dataRetrieval package
    data_out <- readNWISdata(sites=site_num, service="iv", 
                             parameterCd = parameterCd, startDate = startDate, endDate = endDate)
    write_csv(data_out, file = filepath)
  }

  # -- simulating a failure-prone web-sevice here, do not edit --
  set.seed(Sys.time())
  if (sample(c(T,F,F,F), 1)){
    stop(site_num, ' has failed due to connection timeout. Try tar_make() again')    # does this means it stops at time 1000?
  }
  # -- end of do-not-edit block
  
  return(filepath)
}

