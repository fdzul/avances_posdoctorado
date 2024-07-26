####
# Step 1. calculate the risk ####
load("~/Dropbox/projects/ETV/dengue/spatio_temporal_analysis_eggs/8.RData/hotspots_eggs/tuxtla_eggs_hotspots.RData")
a <- denhotspots::risk_ageb(betas = tuxtla$betas,
                       hotspots = denmex::den_hotspots,
                       intensity_perc = 10,
                       locality = "Tuxtla Gutierrez",
                       cve_edo = "07") |>
    denhotspots::map_risk(staticmap = FALSE)


load("~/Dropbox/projects/ETV/dengue/spatio_temporal_analysis_eggs/8.RData/hotspots_cases/tuxtla_hotspots_h3.RData")
b <- denhotspots::risk_h3(betas = tuxtla$betas,
                     hotspots = hotspots_h3,
                     intensity_perc = 20,
                     locality = "Tuxtla Gutierrez",
                     cve_edo = "07") |>
    denhotspots::map_risk(staticmap = FALSE)

# Guadalajara ####
a <- denhotspots::risk_ageb(betas = denmex::eggs_betas_14_jalisco,
                            hotspots = denmex::den_hotspots,
                            intensity_perc = 10,
                            locality = c("Guadalajara", "Zapopan", 
                                         "Tlaquepaque", "Tonalá"),
                            cve_edo = "14") |>
    denhotspots::map_risk(staticmap = FALSE)

b <- denhotspots::risk_h3(betas = denmex::eggs_betas_14_jalisco,
                     hotspots = hotspots_h3,
                     intensity_perc = 20,
                     locality = c("Guadalajara", "Zapopan", 
                                  "Tlaquepaque", "Tonalá"),
                     cve_edo = "14") |>
    denhotspots::map_risk(staticmap = FALSE)
