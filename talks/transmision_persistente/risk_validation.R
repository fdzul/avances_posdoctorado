risk_validation <- function(x, risk){
    
    x$risk <- factor(x$risk)
    x$risk <- relevel(x$risk, ref = " Riesgo Bajo")
    
    # Logistic Regression
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
    if(risk == TRUE){
        glm(risk ~ DENV_2008_2010 + DENV_2011_2014 +
                DENV_2015_2017 + DENV_2018_2019 +
                DENV_2020_2021 + DENV_2022_2023 + total,
            data = x, 
            family = binomial)
    } else{
        glm(hotspots_gi ~ DENV_2008_2010 + DENV_2011_2014 +
                DENV_2015_2017 + DENV_2018_2019 +
                DENV_2020_2021 + DENV_2022_2023 + total,
            data = x, 
            family = binomial)
    }

}