library(ggplot2)
library(ggthemes)
library(viridis) # devtools::install_github("sjmgarnier/viridis)
library(ggmap)
library(scales)
library(grid)
library(dplyr)
library(gridExtra)
library(leaflet.extras)

setwd('/Users/fsmoura/Documents/R-files/semaforos/')
list.files()
semaforos = read.csv('semaforos_jul18.csv', header = TRUE, sep = ";")
head(semaforos, 10)
class(semaforos$Longitude)

endpoints = read.csv('/Users/fsmoura/Documents/R-files/endpoints.csv', header = TRUE, sep = ";")
head(endpoints, 10)
sub( '(?<=.{3})', '.', endpoints$LONGITUDE[1], perl=TRUE )
endpoints$LONGITUDE = sub( '(?<=.{3})', '.', endpoints$LONGITUDE, perl=TRUE )
endpoints$LATITUDE = sub( '(?<=.{3})', '.', endpoints$LATITUDE, perl=TRUE )
head(endpoints)
class(endpoints$LONGITUDE)
endpoints$LONGITUDE = as.numeric(as.character(endpoints$LONGITUDE))
endpoints$LATITUDE = as.numeric(as.character(endpoints$LATITUDE))

library(wesanderson)

pal <- colorFactor(
  #palette = 'Darjeeling', #topo.colors(5),
  palette =  c("black", "yellow","Blue", "green","red"),
  domain = semaforos$TIPO
)


#utilizando dados2 de mapa_acidentes.R
leaflet(semaforos) %>%
  addTiles(group="OSM") %>%
  addCircles(~Longitude, ~Latitude, popup=~paste("ID: ", ID,  
                                                 "<br>Local: ", LOG1, "Nº: ", PREDIAL,  
                                                 "<br>Tipo: ", TIPO, 
                                                 "<br>ObsS: ", OBSERVACAO, 
                                                 sep = ""),  
             weight = 1, radius=20, color= 'red', stroke = TRUE, fillOpacity = 0.8) %>% 
  addCircles(~endpoints$LONGITUDE, ~endpoints$LATITUDE, weight = 1, radius=8, color= 'green', stroke = TRUE, fillOpacity = 0.8) %>% 
  #addHeatmap(group=dados2$LOG1, lng=dados2$LONGITUDE, lat=dados2$LATITUDE, radius = 10 , max=10, blur = 10, intensity  =1) %>%
  addLegend("bottomright", colors= "#ffa500", labels="jULHO 2018", title="SEMÁFOROS:")




#https://www.rdocumentation.org/packages/leaflet.extras/versions/0.2/topics/addHeatmap
# Install
#install.packages("wesanderson")
# Load
library(wesanderson)

pal <- colorFactor(
  #palette = 'Darjeeling', #topo.colors(5),
  palette =  c("black", "yellow","Blue", "green","red"),
  domain = semaforos$TIPO
)



leaflet(semaforos) %>%
  addTiles(group="OSM") %>%
  addHeatmap(group=dados2$LOG1, lng=dados2$LONGITUDE, lat=dados2$LATITUDE, radius = 10 , max=30, blur = 10, intensity  =1) %>%
  addCircles(~Longitude, ~Latitude, popup=~paste("ID: ", ID,  
                                                 "<br>Local: ", LOG1, "Nº: ", PREDIAL,  
                                                 "<br>Tipo: ", TIPO, 
                                                 "<br>ObsS: ", OBSERVACAO, 
                                                 sep = ""),  
             weight = 1, radius=20, color= ~pal(TIPO), stroke = TRUE, fillOpacity = 0.8) %>% 
  addLegend("bottomright", colors= "#ffa500", labels="jULHO 2018", title="SEMÁFOROS:")




pal2 <- colorFactor(
  palette = c('red', 'blue', 'green', 'orange'),
  domain = semaforos$TIPO
)

leaflet(semaforos) %>%
  addTiles(group="OSM") %>%
  addCircles(~Longitude, ~Latitude, popup=~paste("ID: ", ID,  "<br>Local: ", CDL1,  "<br>Tipo: ", TIPO,   sep = " "),  
             weight = 1, radius=20, color= ~pal2(TIPO), stroke = TRUE, fillOpacity = 0.8) %>% 
  addLegend("bottomright", colors= "#ffa500", labels="jULHO 2018", title="SEMÁFOROS:")



#https://github.com/bhaskarvk/leaflet.extras/blob/master/inst/examples/search.R
leaflet(semaforos) %>%
  addProviderTiles(providers$OpenStreetMap) %>%
  addWebGLHeatmap(lng = ~Longitude, lat = ~Latitude, size = 60) %>%
  addCircles(lng = ~Longitude, lat = ~Latitude, weight = 1, fillOpacity = 0.5,
           radius = 10, color= ~pal(TIPO), group = "cities")

