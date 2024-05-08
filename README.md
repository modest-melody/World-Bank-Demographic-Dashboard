# Global Population Demographics Dashboard

[**Click Here for Dashboard**](https://d9n1ei-michael-mcgee.shinyapps.io/Dashboard_Final/) - *Deployed with shinyapps.io*

This project is a `flexdashboard` with `Shiny` implementations that allow the user to navigate through 217 countries and view important demographic data about global populations from 1960 - 2021. All plots are made interactive with `plotly`.

## Data Sources

[**World Bank Open Data**](https://data.worldbank.org/?intcid=ecr_hp_BeltD_en_ext)

The World Bank is a development bank, which makes loans to developing countries. The World Bank performs thousands of [developmental projects](https://projects.worldbank.org/en/projects-operations/projects-list?os=0) throughout the globe and also collects a plethora of data on 217 nations which we will analyze for this project.

The data for this project will specifically be coming from their [**World Development Indicators Data Bank**](https://databank.worldbank.org/source/world-development-indicators/preview/on). 

The [WDI Sources & Methods page](https://datatopics.worldbank.org/world-development-indicators/sources-and-methods.html) does not specify how each of the 1,600 indicators are collected and instead focuses mainly on statistical methods. However, according to the [World Development Indicator's own Wikipedia page](https://en.wikipedia.org/wiki/World_Development_Indicators), the data is collected by a variety of sources such as United Nations Agencies, research organizations, academic studies, and even the private sector.

***

## Description of the Data

There are 1,600 indicators available in the WDI database with development categories ranging from economics, social, gender, health, and wealth. We will be exploring 13 variables related to population and demographic developments and creating a 14th variable comprised of a population growth model built from 3 of the 13 selected variables. 

The variables cover 217 economies across the globe and is in a yearly time series format ranging from 1960 - 2021.

The data is tabular with a separate table for each indicator with rows for each of the 217 countries, and columns for each year from 1960 - 2021. The 13 tables will be compiled into a list object to work with throughout the project.

***

## Table of Contents

* `Import/import_V2.R` - Data import and wrangling.
* `Shiny_Plots/Age_Dependency_line_shiny.R` - Data subsetting, transforming, and plotting of variables related to age group dependencies.
* `Shiny_Plots/Age_Distribution_area_shiny.R` - Data subsetting, transforming, and plotting of variables containing 3 bins of age groups.
* `Shiny_Plots/Population_Growth_Model_shiny.R` - Data subsetting, transforming, plotting, and additional calculated variable of variables related to yearly net population growth. 
* `Shiny_Plots/Rural_Urban_areaStacked_shiny.R` - Data subsetting, transforming, and plotting of variables containing rural and urban populations.
* `Shiny_Plots/pop_density_ggplotly_shiny.R` - Data subsetting, transforming, and plotting of population density variable.
* `dashboard.RMD` - Sources above 6 files and creates flexdashboard layout with Shiny inputs.

***

## Data Visualizations

### Country Plots

#### Population Growth Model

Three variables were selected for this plot: `birth_rate`, `death_rate`, and `net_migration`. First the birth/death rates were converted from a per/1,000 ratio to total number of persons via scaling the `population_total` by 1,000 and factoring the birth/death rate. Then, since all 3 variables now represent a number of persons, a new metric can be created, the `population_growth_model`.

`population_growth_model` $=$ `birth_rate` $-$ `death_rate` $+$ `net_migration`

The model and its 3 components are plotted for a specific country with their values on the y axis and yearly increments along the x axis.


#### Age Group Distribution

The World Bank's broadest categories for age groups that are relevant to the economy are: children (0-14), working age adults (15-64), and the elderly (65+). 

This area plot shows the total number of persons in each of these 3 age groups for a specific country. The population values are labeled on the y axis and the yearly values are along the x axis.


#### Age Dependency Rates

This line plot takes the 3 age groups mentioned above and classifies children and elderly as a "dependent age" and their ratios to working age adults are then plotted in yearly along the x axis, and those percentage ratios are plotted along the y axis. There is also a third line which adds both children and elderly populations and divides by the working age adult population to arrive at a `Total Dependency Rate`.


#### Rural-Urban Divide

The `Rural Population` and the `Urban Population` are taken and grouped by year and country and are then transformed to ratios by dividing their values by the total population. The result is 2 ratios equaling 1 for every country and every year. 

These percentages are placed on an area plot using `position_fill` to display a total of 1 for each year and the rural and urban percentage ratio.


### World Population Density

#### Yearly Population Density Choropleth

Population per square kilometer of land area are plotted in a choropleth map of the world. `Shiny` input is a vertical numeric slider from years 1961-2020. Extreme dispersion in values from < 1 in Greenland to 80,000+ in Hong Kong make fluctuations from year to year hard to visualize, but `plotly` allows the user to hover over any nation in any year to get exact value. 

***

## Dependencies
* `tidyverse`
* `plotly`
* `RColorBrewer`
* `maps`
* `flexdashboard`
* `shiny`
* `shinyWidgets`
* `plotly`
* `tidyverse`
* `scales`
* `DT`
