library(bslib)
library(shiny)
library(tidyverse)

uwgpa = read_csv(file = "data/uwgpa.csv")

order_grade = c("A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F", "W")

ui = navbarPage(
  theme = bs_theme(bootswatch = "cerulean", base_font = font_google("Righteous")),
  title = "University of Washington Seattle GPA", 
  tabPanel(
    title = "Input / Visualization",
    titlePanel(title = "University of Washington Seattle GPA Data: 2010 - 2015"),
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
                      value = FALSE)
      ), 
      mainPanel(plotOutput("Plot")))
    ), 
  tabPanel(title = "Table", dataTableOutput("table")), 
  tabPanel(title = "About", includeMarkdown("about.Rmd"))
)

server = function(input, output) {
    uwgpa_year = reactive({
      uwgpa |>
        filter(Year == input$year)
    })
    
    observeEvent(
      eventExpr = input$year, 
      handlerExpr = {
        updateSelectInput(inputId = "class", 
                          choices = sort(unique(uwgpa_year()$Class)),
                          selected = sort(unique(uwgpa_year()$Class)))
        updateSelectInput(inputId = "instructor", 
                          choices = sort(unique(uwgpa_year_class()$Instructor)),
                          selected = sort(unique(uwgpa_year_class()$Instructor))[1])
      }
    )
    
    uwgpa_year_class = reactive({
      uwgpa_year() |>
        filter(Class == input$class)
    })
    
    observeEvent(
      eventExpr = input$class, 
      handlerExpr = {
        updateSelectInput(inputId = "instructor", 
                          choices = sort(unique(uwgpa_year_class()$Instructor)),
                          selected = sort(unique(uwgpa_year_class()$Instructor))[1])
      }
    )
    
    output$Plot = renderPlot({
      uwgpa |>
        filter(Year == input$year) |>
        filter(Class == input$class) |>
        filter(Instructor == input$instructor) |>
        pivot_longer(A:W, names_to = "Letter", values_to = "Count") |>
        group_by(Letter) |>
        summarise(Count = sum(Count)) |>
        mutate(Letter = factor(Letter, levels = order_grade)) |>
        ggplot() +
        aes(x = Letter, y = Count, fill = Letter) |>
        geom_bar(stat = "identity") +
        theme_bw()
    })
    
    output$table = renderDataTable({
      tab = uwgpa_year() ##|>
        ##gpa_calc() ## (Somehow doesn't work when running the app but there's an Average GPA column already though)
      
      if (input$course) {
        tab = tab |>
          filter(Class == input$class)
      }
      tab
    })
}

shinyApp(ui = ui, server = server)