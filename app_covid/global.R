# Cargo el archivo de covid filtrado por municipios y armo las tablas para la app
library(readr)
library(dplyr)
library(lubridate)
library(tictoc)
library(shinydashboard)
library(tidyverse)
# Leo archivo filtrado ----
tic()
# Para correr localmente----

#path.file <- "~/Nextcloud2/Personal/covid_guido/app_covid/covid19.filtrado.zip" 
#covid19 <- read_csv(path.file)

# Para correr en Shinyapps.io comentar linea 11 y 12, y descomentar 14 y 15----

name.file <- "covid19.filtrado.zip" #Para correr en shinyapps.io
covid19 <- read_csv(name.file)

# Limpianding ----


covid19 <- covid19[!is.na(covid19$fecha_diagnostico),]
covid19 <- covid19 %>%
  mutate(fecha_diagnostico = as.Date(fecha_diagnostico)) %>%
  complete(fecha_diagnostico = seq.Date(as.Date(min(covid19$fecha_diagnostico)),as.Date(max(covid19$fecha_diagnostico)),
                                                        by = "day"),
           residencia_departamento_nombre,clasificacion_resumen)
covid19 <- covid19[!is.na(covid19$id_evento_caso),]
covid19$casosuma <- ifelse(is.na(covid19$id_evento_caso),0,1)
covid19$month <- month(covid19$fecha_diagnostico,label=FALSE) #abbreviate = TRUE
covid19$month <- ifelse(covid19$month<10,paste0(0,covid19$month),
                        covid19$month)
covid19$day_number <- day(covid19$fecha_diagnostico)
covid19$week <- week(covid19$fecha_diagnostico)
covid19$week <- ifelse(covid19$week < 10,
                       paste0(0,covid19$week),
                       covid19$week)
covid19$year <- year(covid19$fecha_diagnostico)
filter_year <- tail(unique(covid19$year),2)
covid19 <- covid19[covid19$year %in% filter_year,]
covid19$year_month <- paste0(covid19$year,covid19$month)
covid19$edad <- ifelse(covid19$edad_años_meses == "Meses",0,covid19$edad) #Conviero meses a menor de 1 año
covid19$year_week <- paste0(covid19$year,covid19$week)
covid19$rango_edad <- ifelse(covid19$edad<10,"0 a 9",
                             ifelse(covid19$edad<20,"10 a 19",
                                    ifelse(covid19$edad<30,"20 a 29",
                                           ifelse(covid19$edad<40,"30 a 39",
                                                  ifelse(covid19$edad<50,"40 a 49",
                                                         ifelse(covid19$edad<60,"50 a 59",
                                                                ifelse(covid19$edad<70,"60 a 69",
                                                                       ifelse(covid19$edad<80,"70 a 79",
                                                                              ifelse(covid19$edad>=80,"80+","Ver")))))))))
# Primeros datos ----
max_date <- max(as.Date(unique(covid19$fecha_diagnostico)))

# Filtro Municipio

filtro.municipios <- sort(unique(covid19$residencia_departamento_nombre))
filtro.meses <- sort(unique(covid19$month))


# Valores Acumulados por Municipio
tabla.acumulados <- covid19 %>%
  group_by(residencia_departamento_nombre,clasificacion_resumen) %>%
  summarise("casos" = sum(casosuma))%>% #reemplace n() por casosuma porque agregue los dias sin reporte para que sea reporte continuo en fechas
  group_by(residencia_departamento_nombre)%>%
  mutate("casos_porcentaje" = round(casos/sum(casos),4))

# Valores por mes por municipio
tabla.mes <- covid19 %>%
  group_by(residencia_departamento_nombre,year,month,year_month,clasificacion_resumen) %>%
  summarise("casos" = sum(casosuma))%>%
  group_by(residencia_departamento_nombre,month)%>%
  mutate("casos_porcentaje" = round(casos/sum(casos),4))

# Valores por semana por municipio
tabla.semana <- covid19 %>%
  group_by(residencia_departamento_nombre,year,week,year_week,clasificacion_resumen) %>%
  summarise("casos" = sum(casosuma))%>%
  group_by(residencia_departamento_nombre,week)%>%
  mutate("casos_porcentaje" = round(casos/sum(casos),4))


# Confirmados por edad por municipio por dia
tabla.diario.confirmados <- covid19 %>%
  group_by(residencia_departamento_nombre,fecha_diagnostico,month,day_number,clasificacion_resumen)%>%
  summarise("casos" = sum(casosuma))
# Confirmados por edad por municipio por semana
tabla.semana.confirmados <- covid19 %>%
  group_by(residencia_departamento_nombre,year,week,year_week,clasificacion_resumen)%>%
  summarise("casos" = sum(casosuma))


# Confirmados por rango de edad por municipio
tabla.rango.confirmados <- covid19[!is.na(covid19$rango_edad),] %>%
  group_by(residencia_departamento_nombre,year_week,rango_edad,clasificacion_resumen)%>%
  summarise("casos" = sum(casosuma))
toc()