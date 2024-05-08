


# --- Long Subset - Age Dependency Rates --- #
age_dep_df <- df %>% 
  filter(`Series Name` %in% c("Age dependency ratio (% of working-age population)",
                              "Age dependency ratio, old (% of working-age population)",
                              "Age dependency ratio, young (% of working-age population)")) %>% 
  rename("Age Dependency Ratio" = "Series Name") %>% 
  mutate(`Age Dependency Ratio` = 
           case_when(`Age Dependency Ratio` == "Age dependency ratio (% of working-age population)" ~ "Total Dependency Rate ((0-14 + 65+) / 15-64)",
                     `Age Dependency Ratio` == "Age dependency ratio, old (% of working-age population)" ~ "Elderly Rate (65+ / 15-64)",
                     `Age Dependency Ratio` == "Age dependency ratio, young (% of working-age population)" ~ "Child Rate (0-14 / 15-64)"
           ),
         Year = as.numeric(unlist(Year)),
         value = value/100)

# Convert % ratio to a percent value
dem_list[["Age dependency ratio (% of working-age population)"]][,"value"] <- dem_list[["Age dependency ratio (% of working-age population)"]][,"value"] %>% 
  mutate(value = value/100)




# --- Line plot with long --- #
age_dep_plot_shiny <- function(country){
  age_dep_df %>% filter(`Country Name` == country) %>% 
    ggplot() +
    geom_line(data = dem_list[["Age dependency ratio (% of working-age population)"]] %>% filter(`Country Name` == country),
              mapping = aes(x = Year, y = value, group = `Country Name`), color = "yellow",
              size = 2.2, alpha = 0.8) +
    geom_line(data = dem_list[["Age dependency ratio (% of working-age population)"]] %>% filter(`Country Name` == country),
              mapping = aes(x = Year, y = value, group = `Country Name`), color = "yellow",
              size = 4, alpha = 0.4) +
    geom_line(aes(x = Year, y = value, color = `Age Dependency Ratio`, group = `Age Dependency Ratio`,
                  text = paste0(Year, "<br>", `Age Dependency Ratio`, "<br>", percent(value, accuracy = 0.1))),
              size = 0.5) +
    scale_color_manual(values = c("Total Dependency Rate ((0-14 + 65+) / 15-64)" = "yellow", 
                                  "Elderly Rate (65+ / 15-64)" = "red",
                                  "Child Rate (0-14 / 15-64)" = "green")) +
    scale_x_continuous(n.breaks = 10) +
    scale_y_continuous(label = scales::percent) +
    labs(y = "Persons", title = "Dependent Ages to Working Age Ratios", 
         subtitle = "Dependent Age Population / Working Age Population") +
    theme(axis.title = element_text(color = "white", face = "bold"),
          panel.background = element_rect(fill = "#3d3d3d",
                                          colour = "white",
                                          linewidth = 1, 
                                          linetype = "solid"),
          plot.background = element_rect(fill = "#3d3d3d"),
          plot.title = element_text(hjust = 0.5, color = "white", size = 22),
          plot.subtitle = element_text(hjust = 0.5, color = "white", face = "italic"),
          legend.text = element_text(color = "white", face = "bold"),
          legend.title = element_blank(),
          axis.text = element_text(color = "white", face = "bold"),
          panel.grid = element_line(color = "#bdbdbd"),
          panel.grid.minor = element_blank(),
          legend.key = element_blank(),
          legend.background = element_rect(fill = "#3d3d3d",
                                           colour = "white",
                                           linewidth = 0.5, 
                                           linetype = "solid"),
          legend.position = "bottom"
    )
}



