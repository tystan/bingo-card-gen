
ui <- fluidPage(

  tags$head(
    tags$style(HTML("

     .multicol {

       -webkit-column-count: 2; /* Chrome, Safari, Opera */

       -moz-column-count: 2; /* Firefox */

       column-count: 2;

     }

   "))

  ),

  sidebarLayout(

    sidebarPanel(
      width = 3,

      selectInput(
        "show_input",
        "Please select a show",
        show_nms,
        selected = "90day"
      ),

      br(),

      selectInput(
        "grid_size",
        "Grid size",
        as.character(paste0(3:4, "x", 3:4)),
        selected = "4x4"
      ),


      br(),

      # wellPanel(

        actionButton("rgen", "New card"),

      # ),

      br(),
      br(),

      p(
        "For best graphical display window width >1000px",
        style = "font-size: 9pt;"
      )



    ),


    mainPanel(


      tabsetPanel(
        type = "tabs",


        tabPanel(
          "Randomly permuted bingo card",
          plotOutput("plot1", height = px_h_plot, width = px_w_plot)
        )


      )


    )


  )


)
