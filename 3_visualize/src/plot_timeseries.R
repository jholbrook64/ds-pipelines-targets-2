plot_nwis_timeseries <- function(fileout, site_data_styled, width = p_width, height = p_height, units = p_units){
  
  ggplot(data = site_data_styled, aes(x = dateTime, y = water_temperature, color = station_name)) +
    geom_line() + theme_bw()
  ggsave(fileout, width = width, height = height, units = units)
  
  return(fileout)
}