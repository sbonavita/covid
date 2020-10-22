# Librerias ---
library(dplyr)
library(readr)
library(tictoc)

# Descargo y leo covid ----

link_covid <- "https://sisa.msal.gov.ar/datos/descargas/covid-19/files/Covid19Casos.csv"

download.file(link_covid,paste0(Sys.Date(),"covid19.csv"))
file.read <- max(list.files(pattern = "covid19.csv"))
covid19 <-read_csv("covid19.csv")

# Limpieza ----
tic()
filtro.provincia <- "Buenos Aires"
filtro.municipios <- c("General Guido","Maipú","La Plata","General La Madrid")
covid19.filtrado <- covid19[covid19$residencia_departamento_nombre %in% filtro.municipios &
                              covid19$residencia_provincia_nombre %in% filtro.provincia,]
rm(covid19)

# Guardo archivo filtrado ----
write.csv(covid19.filtrado,"/home/santiago/Nextcloud2/Personal/covid_guido/app_covid/covid19.filtrado.csv", row.names = FALSE)
toc()