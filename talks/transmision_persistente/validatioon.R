

x <- hot_agebs_gua
names(x)

x$risk <- factor(x$risk)
x$risk <- relevel(x$risk, ref = " Riesgo Bajo")
levels(x$risk)
# Logistic Regression
x <- x |>
    sf::st_drop_geometry() |>
    dplyr::mutate(total = DENV_2008 + DENV_2009 + DENV_2010 +
                      DENV_2011 + DENV_2012 + DENV_2013 + DENV_2014 +
                      DENV_2015 +  DENV_2016 + DENV_2017 +
                      DENV_2018 +  DENV_2019 + DENV_2020 +  DENV_2021 +
                      DENV_2022 +  DENV_2023) |>
    dplyr::mutate(DENV_2008_2010 = DENV_2008 + DENV_2009 + DENV_2010) |>
    plyr::mutate(DENV_2011_2014 = DENV_2011 + DENV_2012 + DENV_2013 + DENV_2014) |>
    dplyr::mutate(DENV_2015_2017 = DENV_2015 +  DENV_2016 + DENV_2017) |>
    dplyr::mutate(DENV_2018_2019 = DENV_2018 +  DENV_2019) |>
    dplyr::mutate(DENV_2020_2021 = DENV_2020 +  DENV_2021) |>
    dplyr::mutate(DENV_2022_2023 = DENV_2022 +  DENV_2023) 


# Logistic Regression
glm.fit <- glm(risk ~ DENV_2008_2010 + DENV_2011_2014 +
                   DENV_2015_2017 + DENV_2018_2019 +
                   DENV_2020_2021 + DENV_2022_2023 + total,
               data = x, 
               family = binomial)

summary(glm.fit)
ggstats::ggcoef_table(glm.fit,
                      #significance_labels = c("Significativo", 
                       #                       "No singificativo"),
                      stripped_rows = TRUE,
                      exponentiate = TRUE) 

####
source("~/Dropbox/r_developments/r_talks/2024/avances_posdoctorado/talks/transmision_persistente/risk_validation.R")

risk_validation(hot_agebs_gua) 

models <- list("AGEB" = risk_validation(hot_agebs_gua),
               "Hexágon" = risk_validation(hot_hex_gua))

ggstats::ggcoef_compare(models, type = "faceted")
