library(tidyverse)
library(DT)

# Import CSV with all 13 variables for this analysis
dem_data <- read_csv("Data/demographic_data_all.csv")


# Create new object for meta data and remove from table
dem_meta <- dem_data[seq(from = nrow(dem_data)-13, to = nrow(dem_data), by = 1), 1:15]

names(dem_meta) <- as.vector(dem_meta[1, ])

dem_meta <- dem_meta[-1,colSums(is.na(dem_meta))<nrow(dem_meta)]

dem_data <- dem_data[1:3458, ]



# Coerce all yearly values to numeric
dem_data[ ,3:64] <- lapply(dem_data[ ,3:64], as.numeric)



# There are a lot of rows under `Country Name` that are not countries. Identify them and leave them there for now.

# 49 "groups" that are not countries
country_groups <- dem_data[2822:nrow(dem_data), ]$`Country Name` %>% unique() %>% tibble()


# 217 unique countries
countries <- dem_data$`Country Name`[1:2821] %>% unique()

# I have a table of every country's region and income group. Join it to df and transpose the year columns to be longer.
regions_and_income <- read_csv("Data/regions_and_income.csv") %>% 
  rename("Income Group" = "Income group")

regions_and_income_dt <- regions_and_income %>% select(1,3,2) %>% 
  datatable(selection = list(mode = 'single', selected = 204, target = 'row', selectable = NULL), 
            rownames = FALSE,
            options = list(iDisplayLength = 217,
                           lengthChange = FALSE,
                           dom = "lBfrt"))

df <- dem_data %>% left_join(regions_and_income, by = c("Country Name" = "Country")) %>% 
  select(1, 66, 65, 2:64) %>% pivot_longer(5:66, names_to = "Year")


# Split `Series Name` into list elements
dem_list <- split(df, df$`Series Name`)

# Convert year columns to numeric in dem_list
dem_list <- lapply(dem_list, function(x) {
  x$Year <- as.numeric(x$Year)
  return(x)
})