# set working directory
setwd("~/git/geoScripting/LESSON6 EXCERCISE")
getwd()
# required libraries
library(sp)
library(rgdal)
library(rgeos)
#download required files and unzip them
download.file(url = 'http://www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip', destfile = './data/plces.zip', method = 'auto')
unzip(zipfile='./data/plces.zip',exdir = './data')
download.file(url = 'http://www.mapcruzin.com/download-shapefile/netherlands-railways-shape.zip', destfile = './data/railways.zip', method = 'auto')
unzip(zipfile='./data/railways.zip',exdir = './data')
# read the railway and places shap files
dsn = file.path("data","railways.shp")
railway <- readOGR(dsn, layer = ogrListLayers(dsn))
names(railway)
dsn = file.path("data","places.shp")
places <- readOGR(dsn, layer = ogrListLayers(dsn))
names(places)
# define CRS object for RD projection
prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")
# perform the coordinate transformation from WGS84 to RD
railwayRD <- spTransform(railway, prj_string_RD)
placesRD <- spTransform(places, prj_string_RD, byid=TRUE)
#Selects the "industrial" railways
railwayRD_industrial <- subset(railwayRD, type == "industrial")
railwayRD_industrial
#Buffers the "industrial" railways with a buffer of 1000m
buff_railway_indus <- gBuffer(railwayRD_industrial, width=1000, byid=TRUE)
plot(buff_railway_indus)
buff_railway_indus
#Find the place (i.e. a city) that intersects with this buffer.
plac_buff_intersection <- gIntersection(placesRD, buff_railway_indus,byid=TRUE,drop_lower_td=TRUE)
plac_buff_intersection
head(placesRD)
 city <- placesRD$name[5973]
 city

 population <- placesRD$population[5973]
 population
 plot(buff_railway_indus)
 plot(plac_buff_intersection, add = TRUE, lty = 3, lwd = 2, col = "blue",title=city)
 
 