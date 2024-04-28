library(bslib)
library(shiny)
library(tidyverse)
library(broom)  # For tidy() function to extract regression results

# Read data
uwgpa <- read_csv(file = "data/uwgpa.csv", col_types = cols(
  Quarter = col_character(),
  Class = col_character(),
  Title = col_character(),
  Instructor = col_character(),
  Year = col_double(),
  Students = col_double(),
  AverageGPA = col_double(),
  A = col_double(),
  `A-` = col_double(),
  `B+` = col_double(),
  B = col_double(),
  `B-` = col_double(),
  `C+` = col_double(),
  C = col_double(),
  `C-` = col_double(),
  `D+` = col_double(),
  D = col_double(),
  `D-` = col_double(),
  F = col_double(),
  W = col_double()
))

# Define order for grades
order_grade <- c("A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F", "W")

# Define UI
ui <- navbarPage(
  theme = bs_theme(bootswatch = "cerulean", base_font = font_google("Righteous")),
  title = "University of Illinois Seattle GPA", 
  tabPanel(
    title = "Input / Visualization",
    titlePanel(title = "University of Illinois Seattle GPA Data: 2010 - 2015"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = "year", 
          label = "Year:", 
          choices = sort(unique(uwgpa$Year)),
          selected = 2010),
        selectInput(
          inputId = "class", 
          label = "Class:", 
          choices = sort(unique(uwgpa$Class))),
        selectInput(
          inputId = "instructor", 
          label = "Instructor:", 
          choices = sort(unique(uwgpa$Instructor))),
        checkboxInput(inputId = "course", 
                      label = "Filter Table to Course", 
                      value = FALSE),
      ), 
      mainPanel(
        plotOutput("Plot1", height = "300px"), # First plot
        plotOutput("Plot2", height = "300px"), # Second plot
        plotOutput("Plot3", height = "300px")  # Third plot
      )
    )
  ), 
  tabPanel(title = "Table", DT::DTOutput("table")), 
  tabPanel(title = "About", includeMarkdown("about.Rmd"))
)

# Define server logic
server <- function(input, output, session) {
  uwgpa_year <- reactive({
    uwgpa %>%
      filter(Year == input$year)
  })
  
  observeEvent(input$year, {
    updateSelectInput(
      session, "class", 
      choices = sort(unique(uwgpa_year()$Class)),
      selected = sort(unique(uwgpa_year()$Class))[1]
    )
    updateSelectInput(
      session, "instructor", 
      choices = sort(unique(uwgpa_year()$Instructor)),
      selected = sort(unique(uwgpa_year()$Instructor))[1]
    )
  })
  
  uwgpa_year_class <- reactive({
    uwgpa_year() %>%
      filter(Class == input$class)
  })
  
  observeEvent(input$class, {
    updateSelectInput(
      session, "instructor", 
      choices = sort(unique(uwgpa_year_class()$Instructor)),
      selected = sort(unique(uwgpa_year_class()$Instructor))[1]
    )
  })
  
  output$Plot1 <- renderPlot({
    uwgpa %>%
      filter(Year == input$year, Class == input$class, Instructor == input$instructor) %>%
      pivot_longer(A:W, names_to = "Letter", values_to = "Count") %>%
      group_by(Letter) %>%
      summarise(Count = sum(Count)) %>%
      mutate(Letter = factor(Letter, levels = order_grade)) %>%
      ggplot() +
      aes(x = Letter, y = Count, fill = Letter) +
      geom_bar(stat = "identity") +
      theme_bw()
  })
  
  output$Plot2 <- renderPlot({
    # Example second plot (you can customize this plot as needed)
    uwgpa %>%
      filter(Year == input$year) %>%
      ggplot(aes(x = Quarter, y = AverageGPA, fill = Quarter)) +
      geom_boxplot() +
      labs(x = "Quarter", y = "Average GPA") +
      theme_bw()
  })
  
output$Plot3 <- renderPlot({
  if (!is.null(input$class) && !is.null(input$instructor)) {
    data <- uwgpa %>%
      filter(Class == input$class, Instructor == input$instructor, Year >= 2010, Year <= 2015) %>%
      group_by(Year) %>%
      summarise(AverageGPA = mean(AverageGPA))
    
    lm_model <- lm(AverageGPA ~ Year, data = data)
    regression_line <- predict(lm_model, newdata = data)
    
    ggplot(data, aes(x = Year, y = AverageGPA)) +
      geom_point() +
      geom_line(aes(y = regression_line), color = "red") +
      ggtitle(paste("Linear Regression for Class", input$class, "and Instructor", input$instructor)) +
      theme_bw() +
      scale_x_continuous(breaks = seq(2010, 2015, by = 1))  # Set x-axis breaks to integers from 2010 to 2015
  } else {
    plot(NULL, xlim = c(2010, 2015), ylim = c(2.5, 4), xlab = "Year", ylab = "Average GPA")
  }
})


  
  output$table <- DT::renderDT({
    tab <- uwgpa_year()
    if (input$course) {
      tab <- tab %>%
        filter(Class == input$class)
    }
    tab
  })
}

# Run the application
shinyApp(ui = ui, server = server)

