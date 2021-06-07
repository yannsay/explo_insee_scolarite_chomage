calc_proportion_chomeur_generale <- function(dataset, aggregation) {
  col_to_select <- c("P17_ACTOCC1564", "P17_ACT1564", "P17_CHOM1564", "P17_POP1564",
                     "P12_ACTOCC1564", "P12_ACT1564", "P12_CHOM1564", "P12_POP1564",
                     "P07_ACTOCC1564", "P07_ACT1564", "P07_CHOM1564", "P07_POP1564")
  
  if(!is.null(aggregation)) {
    aggregation_sym <- sym(aggregation)
    dataset <- dataset %>%
      group_by(!!aggregation_sym) %>%
      summarise(across(all_of(col_to_select), sum, na.rm = T)) %>% 
      mutate(prop_active_2017 = P17_ACTOCC1564 / P17_ACT1564 * 100,
             #Taux de chômage des 15-64 ans au RP2017 ~ Nombre de chômeurs de 15 à 64 ans  / Nombre de personnes actives de 15 à 64 ans 
             prop_chomeur_2017 = P17_CHOM1564 / P17_ACT1564 * 100,
             prop_active_2012 = P12_ACTOCC1564 / P12_ACT1564 * 100,
             prop_chomeur_2012 = P12_CHOM1564 / P12_ACT1564 * 100,
             prop_active_2007 = P07_ACTOCC1564 / P07_ACT1564 * 100,
             prop_chomeur_2007 = P07_CHOM1564 / P07_ACT1564 * 100, 
             #Taux d'emploi des 15-64 ans au RP2017 ~ Nombre de personnes actives occupées de 15 à 64 ans / Nombre de personnes de 15 à 64 ans 
             taux_emploi_2017 = P17_ACTOCC1564/P17_POP1564 * 100,
             taux_emploi_2012 = P12_ACTOCC1564/P12_POP1564 * 100,
             taux_emploi_2007 = P07_ACTOCC1564/P07_POP1564 * 100
             )
      
    return(dataset)
  }
  
  dataset %>%
    summarise(across(all_of(col_to_select), sum, na.rm = T)) %>% 
    mutate(prop_active_2017 = P17_ACTOCC1564 / P17_ACT1564 * 100,
           prop_chomeur_2017 = P17_CHOM1564 / P17_ACT1564 * 100,
           prop_active_2012 = P12_ACTOCC1564 / P12_ACT1564 * 100,
           prop_chomeur_2012 = P12_CHOM1564 / P12_ACT1564 * 100,
           prop_active_2007 = P07_ACTOCC1564 / P07_ACT1564 * 100,
           prop_chomeur_2007 = P07_CHOM1564 / P07_ACT1564 * 100, 
           taux_emploi_2017 = P17_ACTOCC1564/P17_POP1564 * 100,
           taux_emploi_2012 = P12_ACTOCC1564/P12_POP1564 * 100,
           taux_emploi_2007 = P07_ACTOCC1564/P07_POP1564 * 100)
}

calc_proportion_scolarisation_generale <- function(dataset, aggregation) {
  col_to_select <- c("P17_SCOL1517", "P17_POP1517", 
                     "P12_SCOL1517", "P12_POP1517", 
                     "P07_SCOL1517", "P07_POP1517"
  )
  
  if(!is.null(aggregation)) {
    aggregation_sym <- sym(aggregation)
    
    dataset <- dataset %>%
      group_by(!!aggregation_sym) %>%
      summarise(across(all_of(col_to_select), sum, na.rm = T)) %>% 
      mutate(prop_scolarise15_17_2017 = P17_SCOL1517/P17_POP1517 *100,
             prop_scolarise15_17_2012 = P12_SCOL1517/P12_POP1517 *100,
             prop_scolarise15_17_2007 = P07_SCOL1517/P07_POP1517 *100
             )
    return(dataset)
  }
  
  dataset <- dataset %>%
    summarise(across(all_of(col_to_select), sum, na.rm = T)) %>% 
    mutate(prop_scolarise15_17_2017 = P17_SCOL1517/P17_POP1517 *100,
           prop_scolarise15_17_2012 = P12_SCOL1517/P12_POP1517 *100,
           prop_scolarise15_17_2007 = P07_SCOL1517/P07_POP1517 *100
           )
  
}

change_with_metadata <- function(dataset, metadata, variable) {
  metadata_short <- metadata %>%
    filter(COD_VAR == variable) %>%
    select(COD_MOD, LIB_MOD1)

  dataset %>%
    left_join(metadata_short, by = setNames("COD_MOD", variable)) %>%
    rename(!!sym(paste0(variable, "_LIB")) := LIB_MOD1)
}

