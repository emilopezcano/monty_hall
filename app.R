#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

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

ui <- fluidPage(theme = shinytheme("flatly"),
                tags$head(
                    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
                ),
                navbarPage("Concurso de Monty Hall",
                           # fluid = FALSE,
                           id = "apartados",
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
                                    uiOutput("uicambio"),
                                    # htmlOutput("test")),
                                    p(uiOutput("uibtnPremio")),
                                    div(tableOutput("tpremios")),
                                    textOutput("resumen"),
                                    plotOutput("grafico")),
                           tabPanel("Simulación"),
                           tabPanel(span(icon("creative-commons", class = "fa-lg"), "Créditos"),
                                    box(includeMarkdown("creditos.md")))
                ),
                p("©", a("Emilio López Cano", href="http://emilio.lcano.com"),  " 2020"))

server <- function(input, output, session) {
    
    premios <- reactiveVal()
    fase <- reactiveVal(0)
    mostrar <- reactiveVal(0)
    cambiar <- reactiveVal(FALSE)
    premio <- reactiveVal()
    partidas <- reactiveVal(tibble())
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
        } else if(mostrar() == 3){
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
    
    output$test <- renderUI({
        div(p("Elegida: ", input$puerta),
            p("Premios:", paste(premios(), collapse = "; ")), 
            p("Fase: ", fase()),
            p("Mostrar: ", mostrar()),
            p("Cambiar: ", cambiar()))
    })
    output$diagrama <- renderGrViz({
        grViz(readLines("diagram.gv"))
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
