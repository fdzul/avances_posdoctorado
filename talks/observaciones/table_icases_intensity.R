
load("/Users/fdzul/Dropbox/hotspots_2023/8.RData/hotspots_hexagons/hotspots_hexagon_clustering.RData")
# Step 1. extract the localidty
loc <- rgeomex::extract_locality(locality = c("Guadalajara", "Zapopan", 
                                              "Tlaquepaque", "Tonalá"), 
                                 cve_edo = "14")

# Step 2. extract the locality ####
hotspots <- hotspots[loc, ] |>
    dplyr::select(h3, intensity_gi) |>
    sf::st_drop_geometry()


gtExtras::gt_plt_summary(hotspots,
                         title = "Hotspots de Dengue")

reactable::reactable(hotspots,
                     fullWidth = FALSE,
                     #defaultColDef = reactable::colDef(minWidth = 100,
                      #                                 align = "center"),
                     defaultSorted = c("intensity_gi"),
                     defaultPageSize = 9,
                     defaultColDef = reactable::colDef(minWidth = 100,
                                                       align = "center",
                                                       footer = function(values) {
                         if (!is.numeric(values)) return()
                         sparkline::sparkline(values, 
                                              type = "box", 
                                              width = 50*3, 
                                              height = 15*2)
                     }),
                     compact = TRUE,
                     striped = TRUE,
                     outlined = TRUE)


