
# --- Long subset, Rural - Urban Divide --- #
rur_urb_long <- df %>% filter(`Series Name` %in% c("Rural population", "Urban population", "Population, total")) %>% 
  mutate(`Series Name` = case_when(`Series Name` == "Rural population" ~ "Rural Population", 
                                   `Series Name` == "Urban population" ~ "Urban Population", 
                                   `Series Name` == "Population, total" ~ "Total Population")) %>% 
  mutate(`Series Name` = as.factor(`Series Name`),
         Year = as.numeric(Year))


# --- Wide Subset --- #
rur_urb_wide <- rur_urb_long %>% pivot_wider(names_from = `Series Name`, values_from = value) %>% 
  mutate(`Total Population` = `Rural Population` + `Urban Population`,)

# Modify Long to add percentages
rur_urb_long <- rur_urb_wide %>% mutate(Rural = `Rural Population`/`Total Population`,
                                        Urban = `Urban Population`/`Total Population`) %>% 
  pivot_longer(8:9, names_to = "Series Name", values_to = "value")


# ------------------- #




# --- Line plot with long --- #
rur_urb_plot_shiny <- function(country){
  rur_urb_long %>% group_by(`Series Name`) %>%  
    filter(`Country Name` == country) %>% 
    ggplot(aes(x = Year, y = value, fill = `Series Name`)) +
    geom_area(alpha=0.5, color="white") +
    geom_point(aes(text = paste0(Year, "<br>", "Rural Population: ", format(`Rural Population`, big.mark = ","), " (", percent(`Rural Population`/`Total Population`, accuracy = 4), ")",
                                 "<br>", "Urban Population: ", format(`Urban Population`, big.mark = ","), " (", percent(`Urban Population`/`Total Population`, accuracy = 4), ")"),
                   y = value), color = "#3d3d3d", alpha = 0) +
    scale_y_continuous(label = scales::percent) + 
    scale_x_continuous(breaks = c(1960, 1970, 1980, 1990, 2000, 2010, 2020)) +
    labs(title = "Rural-Urban Divide", x = "Year", y = "Percentage of Population") +
    scale_fill_manual(name = "", values = c("Rural" = "red", "Urban" = "blue")) +
    theme(plot.title = element_text(color = "white", hjust = 0.5, size = 22),
          plot.background = element_rect(fill = "#3d3d3d"),
          panel.background = element_rect(fill = "#3d3d3d",
                                          colour = "white",
                                          linewidth = 1, 
                                          linetype = "solid"),
          axis.text = element_text(color = "white", face = "bold"),
          axis.title = element_text(color = "white", face = "bold"),
          legend.title = element_blank(),
          legend.text = element_text(color = "white", size = 10, face = "bold"),
          legend.key = element_blank(),
          legend.background = element_rect(fill = "#3d3d3d",
                                           colour = "white",
                                           linewidth = 0.5, 
                                           linetype = "solid"),
          legend.position = "bottom"
          
    )
}


