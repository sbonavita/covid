# Librerias ---
library(dplyr)
library(readr)
library(tictoc)

# Descargo y leo covid ----
tic()
link_covid <- "https://sisa.msal.gov.ar/datos/descargas/covid-19/files/Covid19Casos.zip"
path_save <- "~/Nextcloud2/Personal/covid_guido/"
download.file(link_covid,paste0(path_save,Sys.Date(),"covid19.zip"))

covid19 <- read_csv("~/Nextcloud2/Personal/Covid19Casos.zip")

# Limpieza ----

filtro.provincia <- "Buenos Aires"
filtro.municipios <- c("General Guido","Maipú","La Plata","General La Madrid","Necochea","Dolores","Almirante Brown","General Alvarado",
                       "General Juan Madariaga","Lincoln")
covid19.filtrado <- covid19[covid19$residencia_departamento_nombre %in% filtro.municipios &
                              covid19$residencia_provincia_nombre %in% filtro.provincia,]
  rm(covid19)

# Guardo archivo filtrado ----
write.csv(covid19.filtrado,"~/Nextcloud2/Personal/covid_guido/app_covid/covid19.filtrado.csv", row.names = FALSE)
toc()
