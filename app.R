# Purpose: Interactive dashboard for exploring NHANES health survey data
# Author: Angela Halasey
# Date: Sept. 15, 2025
# Description: Allows users to visualize and analyze relationships between health variables (BMI, BP, cholesterol) and demographic factors

library(shiny)
library(NHANES)
library(dplyr)
library(ggplot2)
library(DT)
library(plotly)

# UI
ui <- fluidPage(
  titlePanel(
    div(
      h1("NHANES Data Explorer: National Health and Nutrition Examination Survey"),
      h4("Interactive analysis of US population health data (2009-2012)", style = "color: gray;"),
      h5(
        "Package info: ", 
        a("NHANES Documentation", 
          href = "https://cran.r-project.org/web/packages/NHANES/refman/NHANES.html",
          target = "_blank"),
        style = "color: gray;"
      )
    )
  ),
  
  # Side bar panel
  sidebarLayout(
    sidebarPanel(
      
      # Choose which health measure to analyze (dependent variable)
      selectInput("variable", 
                  "Select Variable:",
                  choices = c("Age (years)" = "Age",
                              "BMI (kg/m²)" = "BMI", 
                              "Height (cm)" = "Height",
                              "Weight (kg)" = "Weight",
                              "Total Cholesterol (mmol/L)" = "TotChol",
                              "Systolic BP (mmHg)" = "BPSysAve",
                              "Diastolic BP (mmHg)" = "BPDiaAve"),
                  selected = "BMI"),
      
      # Grouping variable selection
      selectInput("group_by",
                  "Group By:",
                  choices = c("Gender" = "Gender",
                              "Race/Ethnicity" = "Race1",
                              "Education" = "Education",
                              "Current Smoking Status" = "SmokeNow",
                              "Diabetes Status" = "Diabetes",
                              "BMI Category (WHO standards)" = "BMI_WHO",
                              "Age Group (by decade)" = "AgeDecade"),
                  selected = "Gender"),
      
      # Option to exclude entries with missing values
      checkboxInput("remove_na", "Remove Missing Values", TRUE),
      
      # Age range filter
      sliderInput("age_range",
                  "Age Range:",
                  min = 0, max = 80,
                  value = c(18, 65))
      # Update function (commented out)
      #actionButton("update", "Update Analysis", class = "btn-primary")
    ),
    
    # Main panel
    mainPanel(
      tabsetPanel(
        #Tab 1: Summary statistics
        tabPanel("Summary", 
                 h3("Data Summary"),
                 verbatimTextOutput("summary"),
                 br(),
                 h3("Group Statistics"),
                 DT::dataTableOutput("group_stats")),
        
        #Tab 2: Visualizations
        tabPanel("Visualization",
                 h3("Distribution Plot"),
                 plotlyOutput("dist_plot", height = "400px"),
                 br(),
                 h3("Box Plot by Group"),
                 plotlyOutput("box_plot", height = "400px")),
        
        #Tab 3: Raw data
        tabPanel("Data Table",
                 h3("Filtered Data"),
                 DT::dataTableOutput("data_table"))
      )
    )
  )
)

# Server
server <- function(input, output) {
  
  # Data filtering (reactive means it automatically updates when inputs change)
  filtered_data <- reactive({
    # Load NHANES data
    data(NHANES)
    
    # Apply age range filter
    df <- NHANES %>%
      filter(Age >= input$age_range[1] & Age <= input$age_range[2])
    
    # Remove missing values (if box is checked)
    if(input$remove_na) {
      df <- df %>%
        # Filter out rows with missing values
        filter(!is.na(.data[[input$variable]]) & !is.na(.data[[input$group_by]]))
    }
    
    # Return the filtered data
    df
  })
  
  # Summary statistics output
  output$summary <- renderPrint({
    df <- filtered_data()
    if(nrow(df) > 0 && input$variable %in% names(df)) {
      # R's built-in summary statistics
      summary(df[[input$variable]])
    } else {
      "No data available for selected criteria"
    }
  })
  
  # Group statistics table
  output$group_stats <- DT::renderDataTable({
    df <- filtered_data()
    if(nrow(df) > 0 && input$variable %in% names(df) && input$group_by %in% names(df)) {
      # Calculate statistics by group
      stats <- df %>%
        group_by(across(all_of(input$group_by))) %>%
        summarise(
          Count = n(),
          Mean = round(mean(.data[[input$variable]], na.rm = TRUE), 2),
          Median = round(median(.data[[input$variable]], na.rm = TRUE), 2),
          `Standard Deviation` = round(sd(.data[[input$variable]], na.rm = TRUE), 2),
          .groups = 'drop'
        )
      stats
    }
  }, options = list(pageLength = 10))
  
  # Distribution histogram
  output$dist_plot <- renderPlotly({
    df <- filtered_data()
    if(nrow(df) > 0 && input$variable %in% names(df)) {
      # Create ggplot histogram
      p <- ggplot(df, aes_string(x = input$variable)) +
        geom_histogram(bins = 30, fill = "steelblue", alpha = 0.7) +
        theme_minimal() +
        labs(title = paste("Distribution of", input$variable),
             x = input$variable,
             y = "Count")
      ggplotly(p)
    }
  })
  
  # Box plot by group
  output$box_plot <- renderPlotly({
    df <- filtered_data()
    # Validate data exists and variable is available (checks for rows and for variable and grouping variable)
    if(nrow(df) > 0 && input$variable %in% names(df) && input$group_by %in% names(df)) {
      # Create ggplot box plot for group comparisons
      p <- ggplot(df, aes_string(x = input$group_by, y = input$variable)) +
        geom_boxplot(fill = "lightblue", alpha = 0.7) +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        labs(title = paste(input$variable, "by", input$group_by),
             x = input$group_by,
             y = input$variable)
      # Convert to interactive plotly chart
      ggplotly(p)
    }
  })
  
  # Data table output
  output$data_table <- DT::renderDataTable({
    df <- filtered_data()
    if(nrow(df) > 0) {
      df %>% 
        select(ID, Age, Gender, Race1, Education, BMI, Diabetes, all_of(input$variable), all_of(input$group_by)) %>% # Include key demographics and selected dependent and grouping variables
        distinct() # Remove duplicate rows
    }
  }, options = list(pageLength = 15, scrollX = TRUE)) # Shows 15 rows per page, enable horizontal scrolling
}

# Launches the Shiny app
shinyApp(ui = ui, server = server)