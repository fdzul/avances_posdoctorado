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

# Step 5.1 add the cases i####
hot_hex_gua <- dplyr::bind_cols(hotspots_hex |> sf::st_drop_geometry(),
                                c_hex |> dplyr::select(dplyr::starts_with("DENV"))) |>
    sf::st_set_geometry("geometry")

class(hot_hex_gua)
names(hot_ageb_gua)
# Step 5.1 add the cases i####
hot_ageb_gua <- dplyr::bind_cols(hotspots_agebs |> sf::st_drop_geometry(),
                                c_agebs |> dplyr::select(dplyr::starts_with("DENV"))) |>
    sf::st_set_geometry("geometry")


# Step 6.1 add the risk in hexagon ####
hot_hex_gua <- denhotspots::risk_h3(betas = denmex::eggs_betas_14_jalisco,
                                    hotspots = hot_hex_gua,
                                    intensity_perc = 20,
                                    locality = c("Guadalajara", "Zapopan", 
                                                 "Tlaquepaque", "Tonalá"),
                                    cve_edo = "14") 
# Step 6.2 add the risk in agebs ####
hot_agebs_gua <- denhotspots::risk_ageb(betas = denmex::eggs_betas_14_jalisco,
                                        hotspots = hot_ageb_gua,
                                        intensity_perc = 20,
                                        locality = c("Guadalajara", "Zapopan", 
                                                     "Tlaquepaque", "Tonalá"),
                                        cve_edo = "14")


save(hot_hex_gua,
     hot_agebs_gua,
     file = "talks/transmision_persistente/risk.RData")


load("~/Dropbox/r_developments/r_talks/2024/avances_posdoctorado/talks/transmision_persistente/risk.RData")
source("~/Dropbox/r_developments/r_talks/2024/avances_posdoctorado/talks/transmision_persistente/risk_validation.R")

risk_validation(hot_agebs_gua) 

models <- list("AGEB" = risk_validation(hot_agebs_gua),
               "Hexágon" = risk_validation(hot_hex_gua))

ggstats::ggcoef_compare(models, 
                        type = "faceted",
                        exponentiate = TRUE)

