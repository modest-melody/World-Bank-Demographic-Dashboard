library(maps)
library(RColorBrewer)

# --- Combining World Map & Population Density Data --- #

# Create world data coordinates
world <- map_data("world")

# Quick draw map data
# ggplot(data = world, mapping = aes(x= long, y= lat, group = group)) + geom_polygon(fill="white",color="black")


# Some country names are different in World Map data and World Bank data

# Countries in dem_list not matched to world map data
anti <- dem_list[["Population density (people per sq. km of land area)"]] %>% 
  anti_join(world, by = c("Country Name" = "region"))

# Country in world map data not matched to dem_list
anti2 <- world %>% 
  anti_join(dem_list[["Population density (people per sq. km of land area)"]], by = c("region" = "Country Name"))

anti_list1 <- unique(anti$`Country Name`)
anti_list2 <- unique(anti2$region)


# Manually change world map data names to match dem_list (World Bank) names
world2 <- world %>% mutate(region = case_when(
  region == "Bahamas" ~ "Bahamas, the",
  region == "Virgin Islands" ~ "British Virgin Islands",
  region == "Brunei" ~ "Brunei Darussalam",
  region == "Cape Verde" ~ "Cabo Verde",
  region == "Republic of Congo" ~ "Congo, Rep.",
  region == "Democratic Republic of the Congo" ~ "Congo, Dem. Rep.",
  region == "Ivory Coast" ~ "Cote d'Ivoire",
  region == "Czech Republic" ~ "Czechia",
  region == "Egypt" ~ "Egypt, Arab Rep.",
  region == "Swaziland" ~ "Eswatini",
  region == "Gambia" ~ "Gambia, The",
  region == "Iran" ~ "Iran, Islamic Rep.",
  region == "North Korea" ~ "Korea, Dem. People's Rep.",
  region == "South Korea" ~ "Korea, Rep.",
  region == "Kyrgyzstan" ~ "Kyrgyz Republic",
  region == "Laos" ~ "Lao PDR",
  region == "Micronesia" ~ "Micronesia, Fed. Sts.",
  region == "Russia" ~ "Russian Federation",
  region == "Slovakia" ~ "Slovak Republic",
  region == "Saint Kitts" ~ "St. Kitts and Nevis",
  region == "Saint Lucia" ~ "St. Lucia",
  region == "Saint Martin" ~ "St. Martin (French part)",
  region == "Grenadines" ~ "St. Vincent and the Grenadines",
  region == "Saint Vincent" ~ "St. Vincent and the Grenadines",
  region == "Syria" ~ "Syrian Arab Republic",
  region == "Trinidad" ~ "Trinidad and Tobago",
  region == "Tobago" ~ "Trinidad and Tobago",
  region == "Turkey" ~ "Turkiye",
  region == "UK" ~ "United Kingdom",
  region == "USA" ~ "United States",
  region == "Venezuela" ~ "Venezuela, RB",
  region == "Virgin Islands" ~ "Virgin Islands (U.S.)",
  region == "Palestine" ~ "West Bank and Gaza",
  region == "Yemen" ~ "Yemen, Rep.",

  TRUE ~ region # If it's not on this list, keep it the same
))


# Join new world map table to dem_list table
world2 <- left_join(world2, dem_list[["Population density (people per sq. km of land area)"]],
          by = c("region" = "Country Name"))

# ----------------- #


# --- Population Density Choropleth (DONE) --- #

# ! Remove legend title and add it as a subtitle. Have to add it through plotly, if possible

pop_density_map_shiny <- function(yearinput){
  world2 %>% filter(Year == yearinput) %>% 
  ggplot(aes(x = long, y = lat, group = group, fill = value, 
             frame = Year, text = paste0(Year, "<br>", region, "<br>", "Pop. Density: ", 
                                         format(round(value), big.mark = ",")))) +
    geom_polygon(color = "white", linewidth = 0.2) +
    scale_fill_gradientn(colors = rev(brewer.pal(8, "Spectral")) , 
                         breaks = c(0, 1, 10, 100, 1000, 10000, 20000),
                         trans = "log10",
                         oob = scales::squish) +
    labs(title = paste0(yearinput, " Population Density Map"), fill = "People per\nsq. km of\nLand Area") +
    theme_minimal() +
    theme(axis.title = element_blank(),
          plot.title = element_text(size = 16, color = "white", face = "bold", hjust = 0.5),
          panel.background = element_rect(fill = "#3d3d3d",
                                          colour = "white",
                                          linewidth = 1, 
                                          linetype = "solid"),
          plot.background = element_rect(fill = "#3d3d3d"),
          legend.position = "left",
          legend.key.height = unit(2.25,"cm"),
          legend.text = element_text(color = "white", face = "bold"),
          legend.title = element_text(color = "white", face = "bold", hjust = 0.5),
          axis.text = element_text(color = "white"),
          panel.grid.minor = element_blank()
  )
}



