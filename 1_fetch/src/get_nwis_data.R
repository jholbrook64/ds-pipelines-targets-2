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
  for (data in repoFiles){
    download_nwis_site_data(data, parameterCd = '00010')
    these_data <- read_csv(data, col_types = 'ccTdcc')      
    finalDf <- bind_rows(data_out, these_data)
  }
  return(finalDf)
}

# download_nwis_data <- function(site_nums,  parameterCD = '00010')  # site_nums = c("01427207", "01432160", "01435000", "01436690", "01466500")
# {
#   # create the file names that are needed for download_nwis_site_data
#   # tempdir() creates a temporary directory that is wiped out when you start a new R session; 
#   # replace tempdir() with "1_fetch/out" or another desired folder if you want to retain the download
#   download_files <- file.path("1_fetch/out", paste0('nwis_', site_nums, '_data.csv'))
#   data_out <- data.frame(agency_cd = c(), site_no = c(), dateTime = c(),          
#                          X_00010_00000 = c(), X00010_00000_cd = c(), tz_cd = c())
#   # include dates
#   plzStart <- "2014-05-01"
#   plzStop  <- "2015-05-01" 
#   
#   # loop through files to download 
#   for (download_file in download_files){
#     download_nwis_site_data(download_file, parameterCd = '00010', plzStart, plzStop)
#     # read the downloaded data and append it to the existing data.frame
#     these_data <- read_csv(download_file, col_types = 'ccTdcc')
#     data_out <- bind_rows(data_out, these_data)
#   }
#   return(data_out)
# }

nwis_site_info <- function(fileout, site_data){
  site_no <- unique(site_data$site_no)
  site_info <- dataRetrieval::readNWISsite(site_no)
  write_csv(site_info, fileout)
  return(fileout)
}


# # optional function
# checkExsits <- function(download_files, endDate, filepath){
#   for (data in download_files) {
#     these_data <- read_csv(download_file, col_types = 'ccTdcc')    # actually I shouldn't use this
#     if (!dir.exists(data) & !data$dateTime.tail() == endDate) {
#       write.csv(data, filepath)
#     }
#     else 
#       download_nwis_site_data(data, parameterCd = '00010', startDate="2014-05-01", endDate="2015-05-01")
#   } 
# }


# 2nd function
nwis_site_info <- function(fileout, site_data){
  site_no <- unique(site_data$site_no)
  site_info <- dataRetrieval::readNWISsite(site_no)
  write_csv(site_info, fileout)
  return(fileout)
}
                   

# 3rd funciton
# filepaths look something like directory/nwis_01432160_data.csv,     check that the source is in this format
# remove the directory with basename() and extract the 01432160 with the regular expression match
download_nwis_site_data <- function(filepath, parameterCd = '00010', startDate="2014-05-01", endDate="2015-05-01")
  {  
  site_num <- basename(filepath) %>% 
    stringr::str_extract(pattern = "(?:[0-9]+)")  # this gets the number from the csv identifier
  
  if (dir.exists(file.path("1_fetch/out", paste0('nwis_', site_num, '_data.csv')))) # tar_make wasn't skipping succsesfully, so I included this if/else
    {
    # # readNWISdata is from the dataRetrieval package
    # data_out <- readNWISdata(sites=site_num, service="iv", 
    #                          parameterCd = parameterCd, startDate = startDate, endDate = endDate)
    # write_csv(data_out, file = filepath)
    data_out <- read_csv(file.path("1_fetch/out", paste0('nwis_', site_num, '_data.csv')))
    return(data_out)
  }
  else {
    data_out <- readNWISdata(sites=site_num, service="iv", 
                             parameterCd = parameterCd, startDate = startDate, endDate = endDate)
    # -- simulating a failure-prone web-sevice here, do not edit --
    set.seed(Sys.time())
    if (sample(c(T,F,F,F), 1)){
    stop(site_num, ' has failed due to connection timeout. Try tar_make() again')    # does this means it stops at time 1000?
    }
    # -- end of do-not-edit block
    write_csv(data_out, file = filepath)
    return(data_out)
  }
  
}

