# Step 1. load dengue dataset the current week ####
x_2023 <- data.table::fread("/Users/fdzul/Library/CloudStorage/OneDrive-Personal/datasets/DGE/denv/2023/DENGUE2_.txt", 
                       header = TRUE, 
                       quote = "", 
                       #select = vect_cols, 
                       fill = TRUE, 
                       encoding = "Latin-1") |>
    dplyr::filter(ESTATUS_CASO %in% c(2)) |>
    dplyr::filter(DES_EDO_RES %in% c("DISTRITO FEDERAL")) |>
    dplyr::group_by() |>
    dplyr::summarise(n = dplyr::n())



names(x_2023)

# Step 1. load the dataset ####
load("~/Library/CloudStorage/OneDrive-Personal/automatic_read_sinave/8.RData/den/den2008_2023.RData")



# Step 2. extract the dengue cases of cdmx and mexico ####
y <- den2008_2015 |>
    dplyr::filter(VEC_EST %in% c(2)) |>
    dplyr::filter(DES_EDO.x %in% c("DISTRITO FEDERAL")) |>
    dplyr::group_by(ANO, SEROTIPO_PCR ) |>
    dplyr::summarise(n = dplyr::n(), .groups = "drop") |>
    dplyr::mutate(SEROTIPO = SEROTIPO_PCR) |>
    dplyr::select(ANO, SEROTIPO, n)

table(y$SEROTIPO_PCR)
sum(y$n)

x <- den2016_2023 |>
    dplyr::filter(ESTATUS_CASO %in% c(2)) |>
    dplyr::filter(DES_EDO_RES %in% c("DISTRITO FEDERAL")) |>
    dplyr::group_by(ANO, DENGUE_SER_TRIPLEX) |>
    dplyr::summarise(n = dplyr::n(), .groups = "drop") |>
    dplyr::mutate(SEROTIPO =  ifelse(DENGUE_SER_TRIPLEX %in% c(0, 5, 9, 13),
                                     NA, DENGUE_SER_TRIPLEX)) |>
    dplyr::select(ANO, SEROTIPO, n)
table(x$DENGUE_SER_TRIPLEX)
table(x$SEROTIPO)



xy <- dplyr::bind_rows(y, x) |>
    dplyr::mutate(serotype = dplyr::case_when(SEROTIPO == 1 ~ "Serotipo 1",
                                              SEROTIPO == 2 ~ "Serotipo 2",
                                              SEROTIPO == 3 ~ "Serotipo 3",
                                              SEROTIPO == 4 ~ "Serotipo 4"))




imp_den <- ggplot2::ggplot() +
    ggplot2::geom_col(data = xy,
                      ggplot2::aes(x = ANO,
                                   y = n)) +
    ggplot2::ylab("Casos Importados en CDMX") +
    ggplot2::xlab("") +
    ggplot2::scale_x_continuous(breaks = seq(from = 2008,
                                             to = 2023, 
                                              by = 1))


ggplot2::ggplot(data = xy,
                ggplot2::aes(fill = serotype, 
                             y = n, 
                             x = ANO)) + 
    ggplot2::geom_bar(position = "fill", 
                      stat="identity") +
    ggplot2::scale_x_continuous(breaks = seq(from = 2008,
                                             to = 2023, 
                                             by = 1))

ggplot2::ggsave(filename = "serotype.png",
                dpi = 300)

img <- png::readPNG("serotype.png")
imp <- grid::rasterGrob(img, interpolate=TRUE)


cowplot::ggdraw() +
    cowplot::draw_plot(imp_den, 0, 0, 1, 1) +
    cowplot::draw_plot(imp,
                       x = .08,
                       y = .47,
                       0.5, 0.5,
                       scale = 1)
