
# Step 1. load the geocoded dataset ####
load("/Users/fdzul/Dropbox/hotspots_2023/8.RData/denmex.RData")

# Step 2. Load the locality ####
x <- popmex::extract_pop(year = 2022, 
                         cve_edo = "14",
                         locality = c("Guadalajara", "Zapopan", 
                                      "Tlaquepaque", "Tonalá"))

# Step 3. Count the cases by hexágons ####
library(magrittr)
z <- denhotspots::point_to_polygons(x = xy,
                                    y = x, ##
                                    ids = c("h3","population"), ###
                                    time = ANO,
                                    coords = c("long", "lat"),
                                    crs = 4326,
                                    dis = "DENV")
sf::st_geometry(z) <- "geometry"

# Step 4. Calculate the hotspots ####
hotspots_h3 <- denhotspots::gihi(x = z,
                              id = c("h3","population"), 
                              time = "year",
                              dis = "DENV",
                              gi_hi = "gi",
                              alpha = 0.95)
save(hotspots_h3,
     file = "talks/transmision_persistente/hotspots_h3.RData")

# Step 5. Vizualization of hotspots ####
denhotspots::risk_h3(betas = denmex::eggs_betas_14_jalisco,
                          hotspots = hotspots_h3,
                          intensity_perc = 20,
                          locality = c("Guadalajara", "Zapopan", 
                                       "Tlaquepaque", "Tonalá"),
                          cve_edo = "14") |>
    denhotspots::map_risk(staticmap = FALSE)
