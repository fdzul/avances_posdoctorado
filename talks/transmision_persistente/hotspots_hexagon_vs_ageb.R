
# Step 1. load the dataset ####
load("/Users/fdzul/Dropbox/hotspots_2023/8.RData/denmex.RData")

# Step 2.1 extract the locality ####
agebs <- rgeomex::extract_ageb(locality = c("Guadalajara", "Zapopan", 
                                        "Tlaquepaque", "Tonalá"), 
                           cve_edo = "14")

# Step 2.2 extract the hexagons ####
hex <- popmex::hdx_pop2023[agebs$locality,]


# Step 3.1 count cases by AGEB ####
c_agebs <- denhotspots::point_to_polygons(x = xy,
                                          y = agebs$ageb,
                                          ids = names(agebs$ageb)[-10],
                                          time = ANO,
                                          coords = c("long", "lat"),
                                          crs = 4326,
                                          dis = "DENV") 

# Step 3.2 Count the cases by hexágons ####
library(magrittr)
c_hex <- denhotspots::point_to_polygons(x = xy,
                                        y = hex, ##
                                        ids = c("h3","population"), ###
                                        time = ANO,
                                        coords = c("long", "lat"),
                                        crs = 4326,
                                        dis = "DENV")
sf::st_geometry(c_hex) <- "geometry"


# Step 4.1 Calculate the hotspots by hexagon ####
hotspots_hex <- denhotspots::gihi(x = c_hex,
                                    id = c("h3","population"), 
                                    time = "year",
                                    dis = "DENV",
                                    gi_hi = "gi",
                                    alpha = 0.95)

# Step 4.2 hotspots ####
hotspots_agebs <- denhotspots::gihi(x = c_agebs,
                                    id = names(c_agebs)[c(1:9)], 
                                    time = "year",
                                    dis = "DENV",
                                    gi_hi = "gi",
                                    alpha = 0.95)

# Step 5.1 Interactive Map ####
a <- mapview::mapview(hotspots_agebs,
                 zcol = "intensity_gi",
                 layer.name = "Intensidad",
                 label = FALSE,
                 color = "white",
                 lwd = 0.5, 
                 col.regions =  rcartocolor::carto_pal(n = max(hotspots_agebs$intensity_gi), 
                                                       name = "OrYel"))

# Step 5.2 Interactive Map ####
b <- mapview::mapview(hotspots_hex,
                 zcol = "intensity_gi",
                 layer.name = "Intensidad",
                 label = FALSE,
                 color = "white",
                 lwd = 0.5, 
                 col.regions =  rcartocolor::carto_pal(n = max(hotspots_hex$intensity_gi), 
                                                       name = "OrYel"))


leafsync::sync(a,b)

