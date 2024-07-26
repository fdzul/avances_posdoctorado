
load("~/Dropbox/r_developments/r_talks/2024/avances_posdoctorado/talks/transmision_persistente/risk.RData")
source("~/Dropbox/r_developments/r_talks/2024/avances_posdoctorado/talks/transmision_persistente/risk_validation.R")


models <- list("AGEB Hotspots" = risk_validation(hot_agebs_gua, risk = FALSE),
               "AGEB Escenarios" = risk_validation(hot_agebs_gua, risk = TRUE),
               "Hexágon Hotspots" = risk_validation(hot_hex_gua, risk = FALSE),
               "Hexágon Escenarios" = risk_validation(hot_hex_gua, risk = TRUE))

ggstats::ggcoef_compare(models, 
                        type = "faceted",
                        exponentiate = TRUE)
