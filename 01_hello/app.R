library(shiny)

# Define UI for app that draws a histogram ----
ui <- fluidPage(

  # App title ----
  titlePanel("Hello Shiny!"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      # Input: Slider for the number of bins ----
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)

    ),

    # Main panel for displaying outputs ----
    mainPanel(

      ## tags$div(
      ##   uiOutput("hdrList")
      ## ),
      tags$div(textOutput("ticktock"), style = "display: none;"),
      tags$div(
        textOutput("user"),
        tags$a("Logout", href=paste0("/oidcCallback?logout=", utils::URLencode("https://docker-shiny-test.herokuapp.com")))
      ),
      ## verbatimTextOutput("reqObj"),
      # Output: Histogram ----
      plotOutput(outputId = "distPlot")

    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output, session) {

  user <- reactive({
    if (!exists("HTTP_OIDC_CLAIM_EMAIL", envir = session$request)){
      return("NULL")
    }
    get("HTTP_OIDC_CLAIM_EMAIL", envir = session$request)
  })

  output$user <- renderText({user()})

  output$hdrList <- renderUI({
    tags$ul(
      lapply(ls(env = session$request),
             function(.x){
               tagList(tags$li(
                 tags$strong(.x),
                 tags$span(print(get(.x, envir = session$request)))
               ))}
             )
    )
  })

  output$reqObj <- renderPrint({
    as.list(session$request)
  })
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$distPlot <- renderPlot({

    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")

    })

  output$ticktock <- renderText({
    invalidateLater(10000, session)
    Sys.time()
  })

  outputOptions(output, "ticktock", suspendWhenHidden = FALSE)

}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
