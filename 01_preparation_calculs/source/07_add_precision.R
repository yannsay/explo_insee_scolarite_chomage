#source https://www.insee.fr/fr/statistiques/fichier/2383177/fiche-precision.pdf [accessed 07/05/2021]
#rajout des intervalles de précision pour les communes de moins 10 000 habitants.

#1. Rajout des indicateurs communes de moins 10 000
population2017_short <- population2017_short %>%
  mutate(P17_moins10000 = P17_POP < 10000,
         P12_moins10000 = P12_POP < 10000,
         P07_moins10000 = P07_POP < 10000)

master_list$CODGEO <- master_list$CODGEO %>%
  left_join(population2017_short)

table_coefficient_variation <- 
  data.frame(trances = c("50 000 ou plus",
                         "20 000 - 49 999", 
                         "10 000 - 19 999", 
                         "6 000 - 9 999",
                         "3000 - 5999", 
                         "2000 - 2999", 
                         "1000 - 1999", 
                         "500 - 999",   
                         "250 - 499", 
                         "Moins de 250"), 
             cv = c(.01,
                    .015,
                    .02,
                    .025,
                    .03,
                    .035,
                    .045,
                    .06,
                    .08,
                    .08),
             limite_basse = c(50000,
                              20000,
                              10000,
                              6000,
                              3000,
                              2000,
                              1000,
                              500,
                              250,
                              0), 
             limite_haute = c(Inf,
                              50000,
                              20000,
                              10000,
                              6000,
                              3000,
                              2000,
                              1000,
                              500,
                              250))

return_interval_coef <- function(numerateur, denominateur = NULL){
  if(is.null(denominateur)){
    cv <- table_coefficient_variation$cv[which(numerateur >= table_coefficient_variation$limite_basse & 
                                                 numerateur < table_coefficient_variation$limite_haute)]
    interval <- 2 * numerateur * cv
    return(data.frame(cv, interval))
  } else {
    cv_num <- table_coefficient_variation$cv[which(numerateur >= table_coefficient_variation$limite_basse & 
                                                     numerateur < table_coefficient_variation$limite_haute)]
    cv_den <- table_coefficient_variation$cv[which(denominateur >= table_coefficient_variation$limite_basse & 
                                                     denominateur < table_coefficient_variation$limite_haute)]
    cv_pourcentage <- sqrt(cv_num^2 + cv_den^2)
    
    interval_num <- 2 * numerateur * cv_num
    interval_den <- 2 * denominateur * cv_den
    interval_pourcentage <- (numerateur/denominateur) * cv_pourcentage * 2 * 100
    return(data.frame(cv_num, cv_den, cv_pourcentage, interval_num, interval_den, interval_pourcentage))
  }
}

apply_calcul_precision <- function(numerateur_nom, denominateur_nom, pourcentage_nom, 
                                   dataset, moins10000nom) {
  mapply(return_interval_coef, 
         numerateur = dataset[[numerateur_nom]], 
         denominateur = dataset[[denominateur_nom]],
         SIMPLIFY = F)  %>%
    do.call(rbind, .) %>%
    as.data.frame() -> aa
  names(aa) <- gsub("num", numerateur_nom, names(aa)) %>%
    gsub("den", denominateur_nom, .) %>%
    gsub("pourcentage", pourcentage_nom, .)
  
  aa[which(dataset[[moins10000nom]]),] <- 0
  return(aa)
} 
pourcentage_list <- c("prop_scolarise15_17_2017", "prop_scolarise15_17_2012", "prop_scolarise15_17_2007",
                      # "prop_active_2017", "prop_active_2012", "prop_active_2007",
                      "prop_chomeur_2017", "prop_chomeur_2012", "prop_chomeur_2007",
                      "taux_emploi_2017", "taux_emploi_2012", "taux_emploi_2007")

numerateur_list <- c("P17_SCOL1517","P12_SCOL1517", "P07_SCOL1517", 
                     # "P17_ACTOCC1564", "P12_ACTOCC1564", "P07_ACTOCC1564",
                     "P17_CHOM1564", "P12_CHOM1564", "P07_CHOM1564",
                     "P17_ACTOCC1564", "P12_ACTOCC1564", "P07_ACTOCC1564")
denominateur_list <- c("P17_POP1517" , "P12_POP1517", "P07_POP1517" ,
                       # "P17_ACT1564", "P12_ACT1564", "P07_ACT1564",
                       "P17_ACT1564", "P12_ACT1564","P07_ACT1564", 
                       "P17_POP1564", "P12_POP1564", "P07_POP1564")
pop10000_list <- rep(c("P17_moins10000", "P12_moins10000", "P07_moins10000"), 3)

table_precision <- data.frame(numerateur_list, denominateur_list, pourcentage_list, pop10000_list) 

#Ca va prendre du temps
colones_precisions <- mapply(FUN = apply_calcul_precision,
             numerateur_nom = table_precision$numerateur_list,
             denominateur_nom = table_precision$denominateur_list,
             pourcentage_nom = table_precision$pourcentage_list,
             MoreArgs = list(dataset =master_list$CODGEO),
             moins10000nom = table_precision$pop10000_list,
             SIMPLIFY = F)

colones_precisions <- colones_precisions %>%
  do.call(bind_cols, .) %>%
  bind_cols(CODGEO = master_list$CODGEO$CODGEO)

master_list$CODGEO <- master_list$CODGEO %>%
  left_join(colones_precisions)
