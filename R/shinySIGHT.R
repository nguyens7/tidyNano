#' @export
#'
#'
#'
#'


shinySIGHT <- function() {

  library(shiny)
  library(tidyverse)
  library(shinythemes)
  library(plotly)



  # UI ----------------------------------------------------------------------
  # Increase Size Upload
  options(shiny.maxRequestSize=30*1024^2)

  ui <- fluidPage(
    theme = shinytheme("flatly"),

    # Application title
    titlePanel("shinySIGHT"),

    sidebarLayout(

      sidebarPanel(
        # Input: Select a file ----
        fileInput("file1", "Choose Rdata File",
                  # multiple = FALSE,
                  accept = c(".rds")),
        tags$hr(),
        sliderInput("range", "Range Particle Size (nm):",
                    min = 0, max = 1000,
                    value = c(0,500)),
        selectInput('filt','Sample', c(None = '.'), selected = "None"),
        selectInput('xvar', 'X Variable', c(None = '.'), selected = "particle_size"),
        selectInput('yvar', 'Y Variable', c(None = '.'), selected = "True_count"),
        selectInput('color', 'Color Variable', c(None = '.'), selected = "None"),
        selectInput('facet_row', 'Facet Row', c(None = '.'), selected = "None"),
        selectInput('facet_col', 'Facet Column', c(None = '.'), selected = "None")

      ),

      mainPanel(
        img(src = "https://github.com/nguyens7/tidyNano/blob/master/man/figures/tidyNano.png?raw=true", width = "90px", align = "right"),
        helpText("This is a R Shiny application that allows users to upload files
                 .Rds files (from tidyNano analysis) and interactively visualize data."),
        # textOutput("selected_facets"),

        br(),

        tabsetPanel(type = "tabs",
                    tabPanel("Plot", plotOutput("nanoPlot", width = "100%")),
                    tabPanel("Interactive Plot", plotlyOutput("nanoPlotly", width = "100%")),
                    fluidRow(DT::dataTableOutput("table"))

        )
        )
    ))


  # Server ------------------------------------------------------------------

  server <- function(input, output, session) {


    mydata <- reactive({

      inFile <- input$file1

      if (is.null(inFile))
        return(NULL)

      data <- readRDS(file = inFile$datapath)
      data

    })

    outVar <-  reactive({

      inFile <- input$file1

      if (is.null(inFile))
        return(NULL)

      data <- readRDS(file = inFile$datapath)
      unique(data$Sample)

    })


    observe({
      choices <- names(mydata())
      updateSelectInput(session,"xvar", choices = c("None", choices), selected = "particle_size")
      updateSelectInput(session,"yvar", choices = c("None", choices), selected = "True_count")
      updateSelectInput(session,"color", choices = c("None", choices))
      updateSelectInput(session,"facet_row", choices = c(None = ".", choices))
      updateSelectInput(session,"facet_col", choices = c(None = ".", choices))
      updateSelectInput(session, "filt", choices =  outVar())
    })



    output$table <- DT::renderDataTable(DT::datatable({

      sampfilt <- input$filt

      if (is.null(sampfilt)) {
        return(NULL)
      } else {

        mydata() %>%
          filter(Sample == sampfilt)
      }
    })

    )

    output$nanoPlot <- renderPlot({

      if (is.null(mydata())) {
        return(NULL)
      } else {

        min_range <- input$range[1]
        max_range <- input$range[2]
        user_sample <-  input$samples
        # line_size <- input$line
        sampfilt <- input$filt
        xvar <- input$xvar
        yvar <- input$yvar
        colorvar <- input$color
        facets <- paste(input$facet_row, '~', input$facet_col)



        p <- mydata() %>%
          filter(
            particle_size >= min_range,
            particle_size <= max_range,
            Sample == sampfilt
          ) %>%
          ggplot(aes_string(x = xvar, y = yvar, color = colorvar )) +
          geom_line() +
          scale_y_continuous(expand = c(0,0)) +
          # facet_wrap(facets) +
          theme_bw()

      }

      if (facets == '. ~ .') {
        return(p)

      } else {

        facet_p <- p + facet_wrap(facets)

        return(facet_p)
      }

    })


    # output$selected_facets <- renderText({
    #   paste(input$facet_row, '~', input$facet_col)
    #
    # })

    output$nanoPlotly <- renderPlotly({

      if (is.null(mydata())) {
        return(NULL)
      } else {

        min_range <- input$range[1]
        max_range <- input$range[2]
        user_sample <-  input$samples
        # line_size <- input$line
        sampfilt <- input$filt
        xvar <- input$xvar
        yvar <- input$yvar
        colorvar <- input$color
        # facets <- paste(input$facet_row, '~', input$facet_col)

        p <- mydata() %>%
          filter(
            particle_size >= min_range,
            particle_size <= max_range,
            Sample == sampfilt
          ) %>%
          ggplot(aes_string(x = xvar, y = yvar, color = colorvar )) +
          geom_line() +
          scale_y_continuous(expand = c(0,0)) +
          # facet_wrap(facets) +
          theme_bw()

        p %>%
          ggplotly()

      }

    })

  }

  # Run the application
  shinyApp(ui = ui, server = server,
           options = list(display.mode = "showcase"))

}





