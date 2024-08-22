# Step 1. load the eggs dataset ####
x <- denmex::eggs_betas_14_jalisco |>
    dplyr::mutate(long = x,
                  lat = y) |>
    sf::st_as_sf(coords = c("long", "lat"),
                 crs = 4326)

# Step 2. load the locality ####
load("/Users/fdzul/Dropbox/hotspots_2023/8.RData/hotspots_hexagons/hotspots_hexagon_clustering.RData")

# Step 3. extract the locality ####
loc <- rgeomex::extract_locality(cve_edo = "14",
                                 locality = c("Guadalajara", "Zapopan",
                                              "Tonalá", "Tlaquepaque"))


loc <- hotspots[loc, ]


# Step 4. extract the ovitraps de guadalajara ####
x <- x[loc, ] |>
    sf::st_drop_geometry()

# Step 1. calculate the intensity
intensity_function <- function(x){
    x |>
        dplyr::mutate(hotspots_binary = ifelse(hotspots == "Hotspots", 1, 0)) |>
        dplyr::select(x, y, week, hotspots_binary) |>
        #dplyr::distinct(x, y, .keep_all = TRUE) |>
        tidyr::pivot_wider(id_cols = c(x, y),
                           names_from = "week",
                           names_prefix = "week_",
                           values_from = "hotspots_binary") |>
        dplyr::mutate(intensity = rowSums(dplyr::across(dplyr::starts_with("week_")), na.rm = TRUE)) |>
        dplyr::mutate(n_week = length(dplyr::across(dplyr::starts_with("week_")))) |>
        dplyr::mutate(per_intensity = round(intensity/n_week, digits = 1)) |>
        dplyr::select(x, y, intensity,n_week, per_intensity) |>
        as.data.frame()
}

x1 <- x |>
    dplyr::group_by(year) |>
    tidyr::nest() |>
    dplyr::mutate(intensity = purrr::map(data,intensity_function)) |>
    dplyr::select(-data) |>
    tidyr::unnest(cols = c(intensity)) |>
    tidyr::pivot_wider(id_cols = c("x", "y"),
                       names_from = year,
                       values_from = intensity) |>
    dplyr::mutate(intensidad = rowMeans(dplyr::across(dplyr::starts_with("2")))) |>
    dplyr::select(x, y, intensidad)


reactable::reactable(x1,
                     fullWidth = FALSE,
                     #defaultColDef = reactable::colDef(minWidth = 100,
                     #                                 align = "center"),
                     defaultSorted = c("intensidad"),
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


gtExtras::gt_plt_summary(x1,
                         title = "Hotspots de Huevos de Ae. aegypti")
