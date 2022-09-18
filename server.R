

# server <- function(input, output, session) {
shinyServer(function(input, output, session) {

  show_select <- reactive({
    input$show_input
  })


  output$plot1 <- renderPlot({

    input$rgen

    plot_dat <- get_plot_data(show_select(), get_seed())
    plot_card(plot_dat)

  })


  # outputOptions(output, "audit", suspendWhenHidden = FALSE)


  # ---- close_app_action ----

  # Close the R session when browser closes
  session$onSessionEnded(function() {
    stopApp()
  })



})


