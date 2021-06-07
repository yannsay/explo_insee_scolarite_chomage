#1. join emploi, education et geocodes.
master_table <- emploi2017_short %>%
  left_join(education2017_short) %>%
  #enlève les DEP NA qui sont des doublons 
  left_join(filter(code_geo, !is.na(DEP)), by = c("CODGEO" = "COM"))
  
#2. removing 14666 Sannerville as it is only NA
master_table <- master_table %>%
  filter(CODGEO != "14666")
# 31/12/2019 : Sannerville est rétablie.
# 01/01/2017 : Sannerville devient commune déléguée au sein de Saline (14712) (commune nouvelle).
#Source https://www.insee.fr/fr/metadonnees/cog/commune/COM14666-sannerville [accessed 07/05/2021]

#55138 (Culey) and 76601 (Saint-Lucien) ont été rétablies 2014 et 2017 respectivement
#Source https://www.insee.fr/fr/metadonnees/cog/commune/COM55138-culey [accessed 07/05/2021]
#Source https://www.insee.fr/fr/metadonnees/cog/commune/COM76601-saint-lucien [accessed 07/05/2021]


#3. list prop active 
aggregation_list <- c("REG", "DEP", "CODGEO")

aggregation_chomage <- lapply(aggregation_list, calc_proportion_chomeur_generale, dataset = master_table)

aggregation_chomage[[4]] <- calc_proportion_chomeur_generale(master_table, NULL)
aggregation_chomage[[4]]$NAT <- "NAT"

names(aggregation_chomage)  <- c(aggregation_list, "NAT")

#4. list proportion scolarite 
aggregation_education <- lapply(aggregation_list, calc_proportion_scolarisation_generale, dataset = master_table)

aggregation_education[[4]] <- calc_proportion_scolarisation_generale(master_table, NULL)
aggregation_education[[4]]$NAT <- "NAT"

names(aggregation_education)  <- c(aggregation_list, "NAT")

#5. master list - tous calculs
master_list <- mapply(left_join,
                      x = aggregation_chomage,
                      y = aggregation_education, 
                      SIMPLIFY = F
                     )
#6. rajout des nom regions et départements.
master_list$REG <- master_list$REG %>% left_join(unique(select(code_geo, REG, nom_region)))
master_list$DEP <- master_list$DEP %>% left_join(unique(select(code_geo, DEP, nom_departement)))

#7. cleaning working space
rm(master_table, aggregation_chomage, aggregation_education)
