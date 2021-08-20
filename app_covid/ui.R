library(shiny)
library(shinydashboard)
library(plotly)
# Define UI for application that draws a histogram
shinyUI(
    dashboardPage(
        dashboardHeader(title = "Covid Municipios"),
        dashboardSidebar(
            disable = FALSE,
            #Filtro Municipio
            selectInput(
                inputId = "municipio_id",
                label = "Seleccione municipio",
                choices = filtro.municipios,
                multiple = FALSE,
                selectize = TRUE,
                selected = "La Plata"
                ),
            #Filtro Meses
            #selectInput(
            #    inputId = "meses_id",
            #    label = "Seleccione meses",
            #    choices = filtro.meses,
            #    multiple = TRUE,
            #    selectize = TRUE,
            #    selected = filtro.meses
            #) ,
            strong("Fuente: Ministerio de Salud de la Nacion"),
            uiOutput(outputId = "link_fuente"), #Agrego link desde donde se descarga información,
            br(),
            strong("Código de la app:"),
            uiOutput(outputId = "link_github"),
            br(),
            strong("Autor: Santiago Bonavita"),
            uiOutput(outputId = "link_linkedin")
            ),
        dashboardBody(
            fluidRow(
                 valueBox(max_date,
                          "Ultima fecha reportada",
                          icon = icon("calendar"),
                          width = 3), 
                 valueBoxOutput("casos_analizados_acumulados",width = 3),
                 valueBoxOutput("casos_confirmados_acumulados",width = 2),
                 valueBoxOutput("casos_descartados_acumulados",width = 2),
                 valueBoxOutput("casos_sospechosos_acumulados",width = 2)
                 ),
            fluidRow(
                 plotlyOutput("grafico1.a")
                 ),
            fluidRow(
                splitLayout(
                 plotlyOutput("grafico2"),
                 plotlyOutput("grafico3")
                 )
            )
            )
        )
    )

