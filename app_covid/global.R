# Cargo el archivo de covid filtrado por municipios y armo las tablas para la app
library(readr)
library(dplyr)
library(lubridate)
library(tictoc)
# Leo archivo filtrado ----
tic()
path.file <- "/home/santiago/Nextcloud2/Personal/covid_guido/app_covid/covid19.filtrado.csv"
covid19 <- read_csv(path.file)
covid19 <- covid19[!is.na(covid19$fecha_diagnostico),]
covid19$month <- month(covid19$fecha_diagnostico,label=FALSE) #abbreviate = TRUE
covid19$edad <- ifelse(covid19$edad_años_meses == "Meses",0,covid19$edad) #Conviero meses a menor de 1 año
# Primeros datos ----
max_date <- max(as.Date(unique(covid19$fecha_diagnostico)))

# Filtro Municipio

filtro.municipios <- unique(covid19$residencia_departamento_nombre)


# Valores Acumulados por Municipio
tabla.acumulados <- covid19 %>%
  group_by(residencia_departamento_nombre,clasificacion_resumen) %>%
  summarise("test" = n())%>%
  group_by(residencia_departamento_nombre)%>%
  mutate("test_porcentaje" = round(test/sum(test),4))

# Valores por mes por municipio
tabla.mes <- covid19 %>%
  group_by(residencia_departamento_nombre,month,clasificacion_resumen) %>%
  summarise("test" = n())%>%
  group_by(residencia_departamento_nombre,month)%>%
  mutate("test_porcentaje" = round(test/sum(test),4))

# Confirmados por edadpor municipio
tabla.edades.confirmados <- covid19 %>%
  group_by(residencia_departamento_nombre,month,clasificacion_resumen,edades)

toc()