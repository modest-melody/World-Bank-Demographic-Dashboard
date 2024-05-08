
# --- Wide subset - Age Distributions --- #
pop_ages_df <- df %>% 
  filter(`Series Name` %in% c("Population ages 0-14, total", 
                              "Population ages 15-64, total", 
                              "Population ages 65 and above, total" )) %>% 
  pivot_wider(names_from = `Series Name`, values_from = value) %>% 
  select(1:4, 6, 5, 7) 

# Rename age columns
names(pop_ages_df)[5:7] <- c("Ages 0-14", "Ages 15-64", "Ages 65+")

# Change Year to numeric
pop_ages_df[ , "Year"] <- as.numeric(unlist(pop_ages_df["Year"]))



# --- Line plot with wide --- #
age_dist_plot_shiny <- function(country){
  pop_ages_df %>% 
  filter(`Country Name` == country) %>% 
  ggplot(aes(x = Year)) +
  geom_area(aes(y = `Ages 15-64`, fill = "Ages 15-64"), color = "white", alpha = 0.5) +
  geom_area(aes(y = `Ages 0-14`, fill = "Ages 0-14"), color = "white", alpha = 0.5) +
  geom_area(aes(y = `Ages 65+`, fill = "Ages 65+"), color = "white", alpha = 0.5) +
  geom_point(aes(text = paste0(Year, "<br>", "Ages 15-64: ", format(`Ages 15-64`, big.mark = ",")),
                 y = `Ages 15-64`), color = "yellow", alpha = 0) +
  geom_point(aes(text = paste0(Year, "<br>", "Ages 0-14: ", format(`Ages 0-14`, big.mark = ",")),
                 y = `Ages 0-14`), color = "blue", alpha = 0) +
  geom_point(aes(text = paste0(Year, "<br>", "Ages 65+: ", format(`Ages 65+`, big.mark = ",")),
                 y = `Ages 65+`), color = "red", alpha = 0) +
  labs(x = "Year", y = "Population", fill = "Age Group", title = "Population Age Distribution") +
  scale_fill_manual(values = c("Ages 0-14" = "blue", "Ages 15-64" = "yellow", "Ages 65+" = "red")) +
  scale_y_continuous(label = scales::comma, n.breaks = 6) +
  scale_x_continuous(breaks = c(1960, 1970, 1980, 1990, 2000, 2010, 2020)) +
  theme(plot.title = element_text(color = "white", hjust = 0.5, size = 22),
        plot.background = element_rect(fill = "#3d3d3d"),
        panel.background = element_rect(fill = "#3d3d3d",
                                        colour = "white",
                                        linewidth = 1, 
                                        linetype = "solid"),
        panel.grid.minor = element_blank(),
        axis.text = element_text(color = "white"),
        axis.title = element_text(color = "white", face = "bold"),
        legend.title = element_blank(),
        legend.background = element_rect(fill = "#3d3d3d",
                                         colour = "white",
                                         linewidth = 0.5, 
                                         linetype = "solid"),
        legend.position = "bottom",
        legend.text = element_text(color = "white", size = 10, face = "bold")
  )
}

