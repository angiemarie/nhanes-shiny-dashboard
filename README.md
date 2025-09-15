# Welcome to the NHANES Data Explorer!
<br>

## Why did I build this app?
This Shiny app was built to provide users a way of exploring health patterns and demographic relationships within the US population using data from the [National Health and Nutrition Examination Survey (NHANES)](https://www.cdc.gov/nchs/nhanes/index.htm). But primarily, it was built as a learning project to demonstrate interactive health data visualization techniques. NHANES is a major program of studies designed to assess the health and nutritional status of adults and children in the United States, conducted by the National Center for Health Statistics (NCHS), part of the Centers for Disease Control and Prevention (CDC).

<br>

## Where's the data?
Check out the different tabs to find interactive data visualizations looking at health variables including BMI, blood pressure, cholesterol levels, and demographic factors from the 2009-2012 NHANES survey cycles. The **Summary** tab provides descriptive statistics, **Visualization** shows interactive plots, and **Data Table** allows you to explore the raw filtered data.

<br>

## Features
- **Interactive variable selection**: Choose from 7 health measures including BMI, blood pressure, and cholesterol
- **Demographic comparisons**: Group data by gender, race/ethnicity, education, smoking status, diabetes status, BMI categories, and age groups
- **Age range filtering**: Focus your analysis on specific age demographics
- **Data quality control**: Option to include or exclude missing values
- **Multiple visualization types**: Distribution plots and comparative box plots
- **Summary statistics**: Mean, median, standard deviation, and sample sizes by group
- **Searchable data table**: Browse and filter the underlying survey data

<br>

## Installation & Usage

### Option 1: Run directly from GitHub
```r
# Install dependencies first
install.packages(c("shiny", "NHANES", "dplyr", "ggplot2", "DT", "plotly"))

# Run the app
shiny::runGitHub("nhanes-shiny-dashboard", "angiemarie")
```

### Option 2: Clone and run locally
```bash
git clone https://github.com/angiemarie/nhanes-shiny-dashboard.git
cd nhanes-shiny-dashboard
```
```r
shiny::runApp()
```

<br>

## Data Source
This app uses the [NHANES R package](https://cran.r-project.org/web/packages/NHANES/refman/NHANES.html), which contains a subset of cleaned survey data from the 2009-2010 and 2011-2012 NHANES sample years. The dataset includes 75 variables for 10,000 participants, specifically prepared for educational and research purposes.

<br>

## Technologies Used
- **R Shiny**: Interactive web application framework
- **ggplot2 & plotly**: Data visualization libraries
- **DT**: Interactive data tables
- **dplyr**: Data manipulation and analysis
- **NHANES package**: Survey data source

<br>

## Author
Angela Halasey - September 2025