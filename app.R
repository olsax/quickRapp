ui <- fluidPage(
    titlePanel("Guz złośliwy jajników"),
    
    sidebarLayout(
        sidebarPanel(
            sliderInput("wiek",
                        label = "Wiek pacjentki:",
                        min = 14, max = 100, value = 14),
            selectInput("wodobrzusze", h4("Obecność wodobrzusza"),
                        choices = list("nie" = 0, "tak" = 1), selected = 0),
            selectInput("przeplyw_krwi", h4("Obecność przepływu krwi w obrębie wyrostków brodawkowatych"),
                        choices = list("nie" = 0, "tak" = 1), selected = 0),
            sliderInput("element_lity",
                         h4("Największa średnica elementu litego w mm"),
                         min = 0, max = 50, value = 0),
            selectInput("nieregularna_sciana", h4("Nieregularna ściana wewnętrzna cysty"),
                        choices = list("nie" = 0, "tak" = 1), selected = 0),
            selectInput("cienie_akustyczne", h4("Obecność cieni akustycznych "),
                        choices = list("nie" = 0, "tak" = 1), selected = 0),
            actionButton("action", "Oblicz"),
    ),
        mainPanel(
            textOutput("selected_wiek"),
            textOutput("selected_wodobrzusze"),
            textOutput("selected_przeplyw_krwi"),
            textOutput("selected_element_lity"),
            textOutput("selected_nieregularna_sciana"),
            textOutput("selected_cienie_akustyczne"),
            br(),
            p("regresja logistyczna modelu IOTA LR2"),
            verbatimTextOutput("fz_value"),
            verbatimTextOutput("typ_raka"),
            plotOutput("plot")
            
        )
    )
)
server <- function(input, output) {
    
    v <- reactiveValues(data = NULL)
    
    output$selected_wiek <- renderText({ 
        paste("Wiek pacjentki:", input$wiek)
    })
    output$selected_wodobrzusze <- renderText({ 
        paste("Obecność wodobrzusza:", input$wodobrzusze)
    })
    output$selected_przeplyw_krwi <- renderText({ 
        paste("Obecność przepływu krwi w obrębie wyrostków brodawkowatych:", input$przeplyw_krwi)
    })
    output$selected_element_lity <- renderText({ 
        paste("Największa średnica elementu litego w mm:", input$element_lity)
    })
    output$selected_nieregularna_sciana <- renderText({ 
        paste("Nieregularna ściana wewnętrzna cysty:", input$nieregularna_sciana)
    })
    output$selected_cienie_akustyczne <- renderText({ 
        paste("Obecność cieni akustycznych:", input$cienie_akustyczne)
    })
    
    observeEvent(input$action, {
        v$data <- input$wiek
    })

    calc_z<- reactive({
        z <- -5.3718 + 0.0354 * input$wiek + 1.6159 * as.numeric(input$wodobrzusze) + 1.1768 * as.numeric(input$przeplyw_krwi) + 0.0697 * input$element_lity + 0.9586 * as.numeric(input$nieregularna_sciana) - 2.9486 * as.numeric(input$cienie_akustyczne)
        z
    })
    calc_fz<- reactive({
        zz <- calc_z()
        fz <- 1/(1 + exp(-zz))
        fz
    })
    show_cancer_type<- reactive({
        fz <- calc_fz()
        if(fz > 0.1)
            wiadomosc <- "Nowotwór złośliwy"
        else
            wiadomosc <- "Nowotwór niezłośliwy"
        wiadomosc
    })
    output$fz_value = renderPrint({
        fzz <- calc_fz()
        message <- show_cancer_type()
        if (!is.null(v$data)) {
            sprintf("f(z) = %.5f, %s", fzz, message)
        }
            
    })
    output$plot <- renderPlot({
        zz <- calc_z()
        fz <- calc_fz()
        z_plot <- seq(-8, 8, 0.1)
        zz_temp <- calc_z()
        fz_temp <- 1/(1 + exp(-z_plot))
        if (is.null(v$data)) return()
        plot(z_plot, fz_temp, xlab = "z", ylab="f(z)", xlim = range(-8, 8), ylim = range(0, 1.0), type = "l", col = "black")
        abline(h=0.1, col="blue", lwd = 1, lty = 5)
        points(zz, fz, pch = 16, cex = 2, col = "red")
        text(6, 0.12, "punkt odcięcia", col = "blue")
    })

}

shinyApp(ui = ui, server = server)
