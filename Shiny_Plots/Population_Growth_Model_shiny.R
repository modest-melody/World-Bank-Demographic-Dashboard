
# -- Population Growth Model = birth rate - death rate + net migration --- #

# Convert rate to a count. birth/death count = total population / 1000 X rate
birth_count <- round(dem_list[["Population, total"]]$value / 1000 * dem_list[["Birth rate, crude (per 1,000 people)"]]$value)
death_count <- round(dem_list[["Population, total"]]$value / 1000 * dem_list[["Death rate, crude (per 1,000 people)"]]$value)

# Append it to the birth rate table
dem_list[["Birth rate, crude (per 1,000 people)"]]$birth_count <- birth_count
dem_list[["Death rate, crude (per 1,000 people)"]]$death_count <- death_count



# Wide table with the population growth model, years, and country info
`Population Growth` <- tibble(`Country Name` = dem_list[["Net migration"]]$`Country Name`,
                              Region = dem_list[["Net migration"]]$Region,
                              `Income Group` = dem_list[["Net migration"]]$`Income Group`,
                              `Series Name` = "Population Growth Model",
                              value = birth_count - death_count + dem_list[["Net migration"]]$value, # Population growth model
                              Year = dem_list[["Net migration"]]$Year)

# Add the Population Growth table to dem_list
dem_list <- append(dem_list, list("Population Growth Model" = `Population Growth`), after = 6)


# Long table with 4 variables
pop_growth_long <- plyr::rbind.fill(dem_list[["Net migration"]], 
                                    dem_list[["Death rate, crude (per 1,000 people)"]] %>% 
                                      mutate(value = death_count) %>% 
                                      select(-7), 
                                    dem_list[["Birth rate, crude (per 1,000 people)"]] %>% 
                                      mutate(value = birth_count) %>% 
                                      select(-7),
                                    dem_list[["Population Growth Model"]]) %>% 
  rename("Parameter" = "Series Name") %>% 
  mutate(Parameter = case_when(Parameter == "Death rate, crude (per 1,000 people)" ~ "Death Rate",
                               Parameter == "Birth rate, crude (per 1,000 people)" ~ "Birth Rate",
                               Parameter == "Net migration" ~ "Net Migration",
                               TRUE ~ Parameter))

# ------ #




# --- Line plot with long --- #
pop_growth_plot_shiny <- function(country){
  pop_growth_long %>% filter(`Country Name` == country) %>% 
  ggplot() +
  geom_line(data = dem_list[["Population Growth Model"]] %>% filter(`Country Name` == country),
            mapping = aes(x = Year, y = value, group = `Country Name`), color = "purple",
            size = 2.2, alpha = 0.8) +
  geom_line(data = dem_list[["Population Growth Model"]] %>% filter(`Country Name` == country),
            mapping = aes(x = Year, y = value, group = `Country Name`), color = "purple",
            size = 4, alpha = 0.4) +
  geom_line(aes(x = Year, y = value, color = Parameter, group = Parameter,
                text = paste0(Year, "<br>", Parameter, "<br>", format(value, big.mark = ","))),
            size = 0.5) +
  geom_hline(aes(yintercept = 0), color = "#fff199", size = 1.5, linetype = 5) +
  scale_color_manual(values = c("green", "red", "#2eeaff", "#c45eff")) +
  scale_x_continuous(n.breaks = 10) +
  scale_y_continuous(label = scales::comma, n.breaks = 7) +
  labs(y = "Persons", title = "Yearly Net Population Change", 
       subtitle = "Birth Rate - Death Rate + Net Migration") +
  theme(axis.title = element_text(color = "white", face = "bold"),
        panel.background = element_rect(fill = "#3d3d3d",
                                        colour = "white",
                                        linewidth = 1, 
                                        linetype = "solid"),
        plot.background = element_rect(fill = "#3d3d3d"),
        plot.title = element_text(hjust = 0.5, color = "white", size = 22),
        plot.subtitle = element_text(hjust = 0.5, color = "white", face ="italic"),
        legend.text = element_text(color = "white"),
        legend.title = element_blank(),
        axis.text = element_text(color = "white"),
        panel.grid = element_line(color = "#bdbdbd"),
        panel.grid.minor = element_blank(),
        legend.key = element_blank(),
        legend.position = "bottom",
        legend.background = element_rect(fill = "#3d3d3d",
                                         colour = "white",
                                         linewidth = 0.5, 
                                         linetype = "solid")
  )
}





