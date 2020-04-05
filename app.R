library(shiny)
library(shinyWidgets)
library(png)
library(shinyjs)
library(tibble)
library(dplyr)
library(shinydashboard)
library(shinythemes)
library(knitr)
library(kableExtra)
library(waffle)
library(DiagrammeR)
library(htmlwidgets)
library(plotly)
library(tidyr)

## Run before push just in case something fails:
knitr::knit("readme.Rmd")

## ui ----
ui <- fluidPage(theme = shinytheme("flatly"),
                tags$head(
                    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
                ),
                navbarPage("Concurso de Monty Hall",
                           id = "apartados",
                           ## . intro ----
                           tabPanel("Introducción",
                                    h2(em("Let's make a deal")),
                                    tabsetPanel(
                                        tabPanel("Descripción",
                                                 box(
                                                     br(),
                                                     includeMarkdown("intro.md")
                                                 )),
                                        tabPanel("Frecuencias",
                                                 box(
                                                     br(),
                                                     withMathJax(
                                                         includeMarkdown("freqs.md")   
                                                     ))),
                                        tabPanel("Enumeración posibilidades",
                                                 box(
                                                     br(),
                                                     includeMarkdown("laplace.md"),
                                                     br()),
                                                 grVizOutput("diagrama")),
                                        tabPanel("Fórmula de Bayes",
                                                 box(
                                                     br(),
                                                     includeMarkdown("bayes.md")))
                                    )),
                           ## . juego ----
                           tabPanel("¡Juega!",
                                    fixedRow(
                                        actionBttn(
                                            inputId = "btnEmpezar",
                                            label = "Jugar",
                                            style = "bordered",
                                            icon = icon("play-circle"),
                                            color = "primary"
                                        )
                                    ),
                                    br(),
                                    fixedRow(uiOutput("uipuerta")),
                                    br(),
                                    fixedRow(uiOutput("uibtnMuestra")),
                                    br(),
                                    fluidRow(
                                        column(imageOutput("puerta1", height = "auto"), class="col-xs-4", width = 2),
                                        column(imageOutput("puerta2", height = "auto"), class="col-xs-4", width = 2),
                                        column(imageOutput("puerta3", height = "auto"), class="col-xs-4", width = 2)
                                    ),
                                    br(),
                                    fixedRow(column(width=12, uiOutput("uicambio"))),
                                    p(uiOutput("uibtnPremio")),
                                    div(tableOutput("tpremios")),
                                    textOutput("resumen"),
                                    plotOutput("grafico")),
                           ## · Simulación ----
                           tabPanel("Simulación",
                                    sliderInput("nsim", "Número de partidas",
                                                min = 100, max = 1000,
                                                step = 100,
                                                value = 10),
                                    actionBttn(
                                        inputId = "btnSimular",
                                        label = "Empezar",
                                        style = "material-flat",
                                        icon = icon("play-circle"),
                                        color = "royal"
                                    ),
                                    tableOutput("spremios"),
                                    uiOutput("sresumen"),
                                    plotlyOutput("sanim"),
                                    plotOutput("sgrafico")),
                           tabPanel(span(icon("creative-commons", class = "fa-lg"), "Créditos"),
                                    box(includeMarkdown("creditos.md")))
                ),
                div("©",
                    a("Emilio López Cano", href="http://emilio.lcano.com"),
                    " 2020",
                    style='position:relative;
                           height:2em;
                           bottom: 0;
                           margin-left:15px;
                           margin-top:15px;
                           width: 100%;'))
## server ----
server <- function(input, output, session) {
    ## reactivevals ----
    premios <- reactiveVal()
    fase <- reactiveVal(0)
    mostrar <- reactiveVal(0)
    cambiar <- reactiveVal(FALSE)
    premio <- reactiveVal()
    partidas <- reactiveVal(tibble())
    spartidas <- reactiveVal(tibble())
    ## Observers ----
    observeEvent(input$btnEmpezar,
                 {
                     premios(sample(c("coche", "cabra", "cabra")))
                     fase(1)
                     mostrar(0)
                     cambiar(FALSE)
                 })
    observeEvent(input$btnMuestra,
                 {
                     fase(3)
                     seleccion <- rep(FALSE, 3)
                     seleccion[as.numeric(input$puerta)] <- TRUE
                     mostrar(sample(rep(which(premios() == "cabra" & !seleccion), 2), 1))
                     
                 })
    observeEvent(input$btnPremio,
                 {
                     fase(4)
                     if(cambiar()){
                         if (premios()[as.numeric(input$puerta)] == "cabra"){
                             premio("coche")
                         } else{
                             premio("cabra")
                         }
                     } else{
                         if (premios()[as.numeric(input$puerta)] == "coche"){
                             premio("coche")
                         } else{
                             premio("cabra")
                         }
                     }
                     partidas(partidas() %>% 
                                  bind_rows(tibble(premio = premio(),
                                                   cambio = cambiar())))
                 })
    observeEvent(input$btnSimular,
                 {
                     spartidas(tibble())
                     for (cambiar in 0:1){
                         for (partida in 1:input$nsim){
                             puerta <- sample(c("cabra", "cabra", "coche"), 1)
                             if(cambiar){
                                 if (puerta == "cabra"){
                                     premio <- "coche"
                                 } else{
                                     premio <- "cabra"
                                 }
                             } else{
                                 if (puerta == "coche"){
                                     premio <- "coche"
                                 } else{
                                     premio <- "cabra"
                                 }
                             }
                             spartidas(spartidas() %>% 
                                           bind_rows(tibble(partida = partida,
                                                            cambio = cambiar,
                                                            premio = premio
                                           )))
                         }
                     }
                 })
    observe({
        req(input$puerta)
        if(input$puerta > 0) fase(2)
    })
    observe({
        req(input$cambio)
        if(input$cambio) {
            cambiar(TRUE)
        } 
    })
    ## oJuego ----
    output$uipuerta <- renderUI({
        req(fase() == 1)
        radioGroupButtons(
            inputId = "puerta",
            individual = TRUE,
            selected = 0,
            label = "Elige puerta",
            choiceValues = 1:3,
            choiceNames = c("Puerta 1", 
                            "Puerta 2", "Puerta 3"),
            status = "primary",
            checkIcon = list(
                yes = icon("door-open"),
                no = icon("door-closed"))
        )
    })
    output$uibtnMuestra <- renderUI({
        req(fase() == 2)
        actionBttn(
            inputId = "btnMuestra",
            label = "Muestra una Monty",
            style = "jelly", 
            color = "warning"
        )
    })
    output$uicambio <- renderUI({
        req(fase() == 3)
        switchInput(
            inputId = "cambio",
            label = "¿Cambias?",
            onStatus = "success", 
            offStatus = "danger",
            onLabel = "Sí",
            offLabel = "No",
            value = FALSE
        )
    })
    output$uibtnPremio <- renderUI({
        req(fase() == 3)
        actionBttn(
            inputId = "btnPremio",
            label = "Ver premio",
            style = "jelly", 
            color = "success"
        )
    })
    output$puerta1 <- renderImage({
        req(fase() >= 2)
        if(input$puerta == 1){
            if (fase() >= 4 & !cambiar()){
                str_puerta <- paste0(premios()[1], "_premio")
            } else if(cambiar() & fase() >= 4){
                str_puerta <-  paste0(premios()[1], "_cambiada")
            }else{
                str_puerta <- "elegida"
            }
        } else if(mostrar() == 1){
            str_puerta <- "cabra"
        } else if(fase() >= 4 & cambiar()){
            str_puerta <- paste0(premios()[1], "_premio")
        } else if(fase() >= 4 & !cambiar()){
            str_puerta <- paste0(premios()[1])
        } else{
            str_puerta <- "cerrada"
        }
        return(list(
            src = paste0("img/puerta_", str_puerta, ".png"),
            contentType = "image/png",
            width = "100%",
            alt = "Puerta 1"
        ))
    }, deleteFile = FALSE)
    output$puerta2 <- renderImage({
        req(fase() >= 2)
        if(input$puerta == 2){
            if (fase() >= 4 & !cambiar()){
                str_puerta <- paste0(premios()[2], "_premio")
            } else if(cambiar() & fase() >= 4){
                str_puerta <-  paste0(premios()[2], "_cambiada")
            }else{
                str_puerta <- "elegida"
            }
        } else if(mostrar() == 2){
            str_puerta <- "cabra"
        } else if(fase() >= 4 & cambiar()){
            str_puerta <- paste0(premios()[2], "_premio")
        } else if(fase() >= 4 & !cambiar()){
            str_puerta <- paste0(premios()[2])
        } else{
            str_puerta <- "cerrada"
        }
        return(list(
            src = paste0("img/puerta_", str_puerta, ".png"),
            contentType = "image/png",
            width = "100%",
            alt = "Puerta 1"
        ))
    }, deleteFile = FALSE)
    output$puerta3 <- renderImage({
        req(fase() >= 2)
        if(input$puerta == 3){
            if (fase() >= 4 & !cambiar()){
                str_puerta <- paste0(premios()[3], "_premio")
            } else if(cambiar() & fase() >= 4){
                str_puerta <-  paste0(premios()[3], "_cambiada")
            }else{
                str_puerta <- "elegida"
            }
        } else if(mostrar() == 3){
            str_puerta <- "cabra"
        } else if(fase() >= 4 & cambiar()){
            str_puerta <- paste0(premios()[3], "_premio")
        } else if(fase() >= 4 & !cambiar()){
            str_puerta <- paste0(premios()[3])
        } else{
            str_puerta <- "cerrada"
        }
        return(list(
            src = paste0("img/puerta_", str_puerta, ".png"),
            contentType = "image/png",
            width = "100%",
            alt = "Puerta 3"
        ))
    }, deleteFile = FALSE)
    
    output$tpremios <- function(){
        req(nrow(partidas()) > 0)
        partis <- partidas() %>% 
            mutate(cambio = ifelse(cambio, "Cambiada", "No Cambiada"))
        kable(prop.table(table(partis$cambio, partis$premio), margin = 1), 
              format = "html", caption = "Frecuencias relativas",
              digits = 2) %>% 
            kable_styling(bootstrap_options = "striped", full_width = F, position = "left")
        # prop.table(table(partidas()$cambio, partidas()$premio))
    }
    output$resumen <- renderText({
        req(nrow(partidas()) > 0)
        partidas <- nrow(partidas())
        cambiadas <- partidas() %>% filter(cambio) %>% count()
        nocambiadas <- partidas - cambiadas
        cochecambiadas <- partidas() %>% filter(cambio, premio == "coche") %>% count()
        cochenocambiadas <- partidas() %>% filter(!cambio, premio == "coche") %>% count()
        str <- paste0("Has jugado ", partidas, " partidas.")
        if (cambiadas > 0){
            str <- c(str, paste0("En ", cambiadas, 
                                 " has cambiado de puerta y el ", 
                                 round(100*cochecambiadas/cambiadas, 1), 
                                 "% de las veces has ganado el coche."))
        }
        if (nocambiadas > 0){
            str <- c(str, paste0("En ", nocambiadas, 
                                 " NO has cambiado de puerta y el ", 
                                 round(100*cochenocambiadas/nocambiadas, 1), 
                                 "% de las veces has ganado el coche."))
        }
    })
    output$grafico <- renderPlot({
        req(nrow(partidas()) > 0)
        dcambiadas <- partidas() %>%
            filter(cambio) %>%
            arrange(premio) %>%
            select(premio) %>%
            pull()
        dnocambiadas <- partidas() %>%
            filter(!cambio) %>%
            arrange(premio) %>%
            select(premio) %>%
            pull()
        req(length(dcambiadas) >  0 & length(dnocambiadas) > 0)
        maxjugadas <- max(length(dcambiadas), length(dnocambiadas))
        pcambio <- waffle(table(dcambiadas),
                          title = "Partidas en las que cambiaste",
                          colors = c("orange", "lightgrey"),
                          rows = ifelse(maxjugadas > 10, 4, 2))
        pnocambio <- waffle(table(dnocambiadas),
                            title = "Partidas en las que NO cambiaste",
                            colors = c("orange", "lightgrey"),
                            rows = ifelse(maxjugadas > 10, 4, 2))
        iron(pcambio, pnocambio)
        
    })

    output$diagrama <- renderGrViz({
        grViz(readLines("diagram.gv"))
    })
    ## oSimulación ----
    output$spremios <- function() {
        req(nrow(spartidas()) > 0)
        partis <- spartidas() %>%
            mutate(cambio = ifelse(cambio, "Cambiada", "No Cambiada"))
        kable(prop.table(table(partis$cambio, partis$premio), margin = 1),
              format = "html", caption = "Frecuencias relativas",
              digits = 2) %>%
            kable_styling(bootstrap_options = "striped", full_width = F, position = "left")
        
        # kable(spartidas())
    }
    output$sresumen <- renderUI({
        req(nrow(spartidas()) > 0)
        # saveRDS(spartidas(), "_temp.rds")
        partidas <- nrow(spartidas())
        cambiadas <- spartidas() %>% filter(cambio == 1) %>% count()
        nocambiadas <- partidas - cambiadas
        cochecambiadas <- spartidas() %>% filter(cambio, premio == "coche") %>% count()
        cochenocambiadas <- spartidas() %>% filter(!cambio, premio == "coche") %>% count()
        str <- paste0("Se han jugado ", partidas, " partidas.")
        if (cambiadas > 0){
            str <- c(str, paste0("En ", cambiadas,
                                 " se ha cambiado de puerta y el ",
                                 round(100*cochecambiadas/cambiadas, 1),
                                 "% de las veces se ha ganado el coche. "))
        }
        if (nocambiadas > 0){
            str <- c(str, paste0("En ", nocambiadas,
                                 " NO se ha cambiado de puerta y el ",
                                 round(100*cochenocambiadas/nocambiadas, 1),
                                 "% de las veces se ha ganado el coche. Pulsa <b>Play</b> para animar el gráfico."))
        }
        HTML(paste(str,collapse = " "))
        
    })
    output$sgrafico <- renderPlot({
        req(nrow(spartidas()) > 0)
        dcambiadas <- spartidas() %>%
            filter(cambio == 1) %>%
            arrange(premio) %>%
            select(premio) %>%
            pull()
        dnocambiadas <- spartidas() %>%
            filter(cambio == 0) %>%
            arrange(premio) %>%
            select(premio) %>%
            pull()
        req(length(dcambiadas) >  0 & length(dnocambiadas) > 0)
        # maxjugadas <- max(length(dcambiadas), length(dnocambiadas))
        pcambio <- waffle(table(dcambiadas),
                          title = "Partidas en las que se cambió",
                          colors = c("orange", "lightgrey"),
                          # rows = ifelse(maxjugadas > 10, 4, 2))
                          rows = 10)
        pnocambio <- waffle(table(dnocambiadas),
                            title = "Partidas en las que NO se cambió",
                            colors = c("orange", "lightgrey"),
                            rows = 10)
        iron(pcambio, pnocambio)

    })
    output$sanim <- renderPlotly({
        req(nrow(spartidas()) > 0)
        accumulate_by <- function(dat, var) {
            var <- lazyeval::f_eval(var, dat)
            lvls <- plotly:::getLevels(var)
            dats <- lapply(seq_along(lvls), function(x) {
                cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
            })
            dplyr::bind_rows(dats)
        }
        spartidas() %>% 
            mutate(cambio = factor(cambio, levels = 1:0, labels = c("Cambiada", "No cambiada"))) %>%
            group_by(cambio) %>% 
            mutate(grupo = rep(seq(1:(n()/10)), each = 10)) %>% 
            mutate(cocheacum = cumsum(premio == "coche")/partida) %>% 
            ungroup %>% 
            accumulate_by(~grupo) %>% 
            plot_ly(x = ~partida,
                    y = ~cocheacum,
                    split = ~cambio,
                    frame = ~frame,
                    mode = "lines",
                    type = "scatter") %>% 
            layout(title = "Convergencia de la probabilidad de obtener el coche",
                   xaxis = list(title = "Partidas"),
                   yaxis = list (title = "Probabilidad acumulada de coche")) %>%
            layout(legend = list(x = 0.7, y = 1,
                                 title = list(text='<b>Puerta</b>')),
                   yaxis = list(range = c(0, 1))) 
        # %>% 
        #     animation_slider(hide=TRUE) %>% 
        #     animation_button(xanchor = "left", yanchor = "top")
    })
    
    # output$test <- renderUI({
    #     div(p("Elegida: ", input$puerta),
    #         p("Premios:", paste(premios(), collapse = "; ")), 
    #         p("Fase: ", fase()),
    #         p("Mostrar: ", mostrar()),
    #         p("Cambiar: ", cambiar()))
    # })
}

# Run the application 
shinyApp(ui = ui, server = server)



