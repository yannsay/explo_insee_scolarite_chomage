#verif chiffre NAN et NA et 0 et 100.
#1. scolarite NAN
master_list$CODGEO$prop_scolarise15_17_2017 %>% is.nan() %>% sum()
master_list$CODGEO$prop_scolarise15_17_2017 %>% is.nan() %>% sum()

master_list$CODGEO %>%
  filter(is.nan(prop_scolarise15_17_2017)) %>% 
  pull(P17_POP1517) %>%
  table(useNA = "ifany")

master_list$CODGEO$prop_scolarise15_17_2012 %>% is.nan() %>% sum()
master_list$CODGEO %>%
  filter(is.nan(prop_scolarise15_17_2012)) %>% 
  pull(P12_POP1517) %>%
  table(useNA = "ifany")

master_list$CODGEO$prop_scolarise15_17_2007 %>% is.nan() %>% sum()
master_list$CODGEO %>%
  filter(is.nan(prop_scolarise15_17_2007)) %>% 
  pull(P07_POP1517) %>%
  table(useNA = "ifany")

#aucun enfants de 15-17ans dans cette période.

#2. chomage NAN
master_list$CODGEO$prop_chomeur_2017 %>% is.nan() %>% sum()
master_list$CODGEO %>%
  filter(is.nan(prop_chomeur_2017)) %>% 
  pull(P17_ACT1564) %>%
  table(useNA = "ifany")

master_list$CODGEO$prop_chomeur_2012 %>% is.nan() %>% sum()
master_list$CODGEO %>%
  filter(is.nan(prop_chomeur_2012)) %>% 
  pull(P12_ACT1564) %>%
  table(useNA = "ifany")

master_list$CODGEO$prop_chomeur_2007 %>% is.nan() %>% sum()
master_list$CODGEO %>%
  filter(is.nan(prop_chomeur_2007)) %>% 
  pull(P07_ACT1564) %>%
  table(useNA = "ifany")

#aucune population active dans ces periodes.

#3. chomage 0%
sum(master_list$CODGEO$prop_chomeur_2017 == 0, na.rm = T)
master_list$CODGEO %>%
  filter(prop_chomeur_2017 == 0) %>% 
  pull(P17_CHOM1564) %>%
  table(useNA = "ifany")

sum(master_list$CODGEO$prop_chomeur_2012 == 0, na.rm = T)
master_list$CODGEO %>%
  filter(prop_chomeur_2012 == 0) %>% 
  pull(P12_CHOM1564) %>%
  table(useNA = "ifany")

sum(master_list$CODGEO$prop_chomeur_2007 == 0, na.rm = T)
master_list$CODGEO %>%
  filter(prop_chomeur_2007 == 0) %>% 
  pull(P07_CHOM1564) %>%
  table(useNA = "ifany")

#0 chomeurs effectivement


#4. chomage 100% 
sum(master_list$CODGEO$prop_chomeur_2017 == 100, na.rm = T)
sum(master_list$CODGEO$prop_chomeur_2012 == 100, na.rm = T)
sum(master_list$CODGEO$prop_chomeur_2007 == 100, na.rm = T)
master_list$CODGEO %>%
  filter(prop_chomeur_2007 == 100) %>% View()


#5. verif master list
  
col_to_select <- c("P17_ACTOCC1564", "P17_ACT1564", "P17_CHOM1564", "P17_POP1564",
                   "P12_ACTOCC1564", "P12_ACT1564", "P12_CHOM1564", "P12_POP1564",
                   "P07_ACTOCC1564", "P07_ACT1564", "P07_CHOM1564", "P07_POP1564", 
                   "P17_SCOL1517", "P17_POP1517", 
                   "P12_SCOL1517", "P12_POP1517", 
                   "P07_SCOL1517", "P07_POP1517"
  )


lapply(master_list, function(x) {
  x %>% 
    summarise(across(all_of(col_to_select), sum))
}  ) %>% do.call(rbind,.) %>% View()



#verif choix coefficient de variation
master_list$CODGEO$P17_ACTOCC1564 %>% 
  lapply(return_interval_coef) %>%
  do.call(rbind, .) %>%
  cbind(master_list$CODGEO$P17_ACTOCC1564) %>%
  as.data.frame() -> aa


aa %>% 
  group_by(cv) %>% 
  summarise(minxx = min(`master_list$CODGEO$P17_ACTOCC1564`), 
            maxx = max(`master_list$CODGEO$P17_ACTOCC1564`))
