#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
# Define server logic required to draw a histogram
shinyServer( function(input, output) {
    #Link para descargar archivo origen
    output$link_fuente <- renderUI({
        tagList(
                a("Click para descargar fuente",href="https://sisa.msal.gov.ar/datos/descargas/covid-19/files/Covid19Casos.zip")) #Hiperlink
    })
    
    #Link a Github
    output$link_github<- renderUI({
      tagList(
        a("Click para ver el código",href="https://github.com/sbonavita/covid_guido")
      )
    })
    
    #Link Linkdein
    output$link_linkedin <- renderUI({
      tagList(
        a("Perfil Linkedin",href="https://ar.linkedin.com/in/santiago-bonavita")
      )
    })
    
    #Casos Analizados
    output$casos_analizados_acumulados <- renderValueBox({
        valueBox(
            format(as.numeric(nrow(covid19[covid19$residencia_departamento_nombre == input$municipio_id,])),big.mark = "."),
            "Casos analizados acumulados",
            color = "teal",
            icon = icon("users")
            )
        })
    #Casos Confirmados
    output$casos_confirmados_acumulados <- renderValueBox({
        valueBox(
            format(as.numeric(nrow(covid19[covid19$residencia_departamento_nombre == input$municipio_id
                         & covid19$clasificacion_resumen == "Confirmado",])),big.mark = "."),
            "Casos confirmados acumulados",
            color = "fuchsia",
            icon = icon("user-plus")
        )
    })
    #Casos descartados
    output$casos_descartados_acumulados <- renderValueBox({
        valueBox(
            format(as.numeric(nrow(covid19[covid19$residencia_departamento_nombre == input$municipio_id
                         & covid19$clasificacion_resumen == "Descartado",])),big.mark = "."),
            "Casos descartados acumulados",
            color = "olive",
            icon = icon("user-minus")
        )
    })    
    
    #Casos sospechosos
    output$casos_sospechosos_acumulados <- renderValueBox({
      valueBox(
        format(as.numeric(nrow(covid19[covid19$residencia_departamento_nombre == input$municipio_id
                                       & covid19$clasificacion_resumen == "Sospechoso",])),big.mark = "."),
        "Casos sospechosos acumulados",
        color = "blue",
        icon = icon("people-arrows")
      )
    })
    
    #Gráfico evolucion diaria confirmados y descartados
    
    output$grafico1 <- renderPlotly({
        base.grafico1 <- tabla.diario.confirmados[tabla.diario.confirmados$residencia_departamento_nombre == input$municipio_id &
                                                      tabla.diario.confirmados$clasificacion_resumen == "Confirmado",] #input$municipio_id
        ggplotly(
            ggplot(base.grafico1[base.grafico1$month %in% input$meses_id,], #
                            aes(x=fecha_diagnostico,
                                y=casos))+
            theme(panel.background = element_blank(),
                  panel.grid.major.y = element_line(color = "grey"))+
            geom_bar(stat = "identity")
        )%>%
        config('displayModeBar' = FALSE)%>%
            layout(title = list(text = "Casos confirmados por día",y=0.95,x=0.01))
    })
    #Grafico evolucion semanal
    output$grafico1.a <- renderPlotly({
      base.grafico1.a <- tabla.semana.confirmados[tabla.semana.confirmados$residencia_departamento_nombre == input$municipio_id & #input$municipio_id &
                                        tabla.semana.confirmados$clasificacion_resumen == "Confirmado",]
      ggplotly(
        ggplot(base.grafico1.a,
               aes(x=year_week,
                   y=casos,group=1))+
        geom_area(fill="#EC1D9E",alpha=.7)+
        geom_line(color="#A20667")+
        geom_point(color="#A20667")+
        theme_minimal()+
        theme(
          panel.grid.major.x = element_blank(),
          axis.text.x = element_text(angle = 45)
          )+
        labs(x="Número de semana (YYYY-WW)",
             y="Casos confirmados")) %>%
          config('displayModeBar' = FALSE)%>%
          layout(title = list(text = "Casos confirmados por semana",y=0.95,x=0.01)) 
    })
    
    #Grafico confirmados por rango de edad
        
    output$grafico2 <- renderPlotly({
        base.grafico2 <- tabla.rango.confirmados[tabla.rango.confirmados$residencia_departamento_nombre == input$municipio_id &
                                                   tabla.rango.confirmados$clasificacion_resumen == "Confirmado",] #input$municipio_id
        ggplotly(
            ggplot(base.grafico2,aes(
                x=year_week,
                y=casos,
                group=rango_edad))+
            geom_line(aes(color=rango_edad))+
           # geom_point(aes(color=rango_edad),size=2)+
            theme_minimal()+
            labs(x="Número de semana (YYYYMM)",
                 y="Casos")+
            theme(
              panel.grid.major.x = element_blank(),
              axis.text.x = element_text(angle=45),
              legend.title = element_blank()
            )
            )%>%
            config('displayModeBar' = FALSE)%>%
          layout(title = list(text = "Casos confirmados por semana por edad",y=0.95,x=0.01))
        })
    #Grafico por mes    
    output$grafico3 <- renderPlotly({
        base.grafico3 <- tabla.mes[tabla.mes$residencia_departamento_nombre == input$municipio_id &
                                     tabla.mes$clasificacion_resumen != "Sospechoso",] #input$municipio_id
        ggplotly(
            ggplot(base.grafico3,aes(
                x=year_month,
                y=casos,
                fill=clasificacion_resumen))+
                geom_bar(stat = "identity",position = position_dodge(),alpha=.8)+
              scale_fill_manual(values= c("#EC1D9E","#0699A2"))+
              theme_minimal()+
              labs(x= "Año y Mes")+
              theme(panel.grid.major.x = element_blank(),
                    axis.text.x = element_text(angle=45),
                    legend.title = element_blank())
            )%>%
            config('displayModeBar' = FALSE)%>%
          layout(title = list(text = "Casos analizados por mes",y=0.95,x=0.01))
        })
    })#Linea final de cierre

    
