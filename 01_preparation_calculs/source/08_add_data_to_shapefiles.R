#add data to shape files - régions
prop_scol_reg <- master_list$REG %>% 
  select(starts_with("prop_scolarise"), REG) %>%
  pivot_longer(cols = starts_with("prop_scolarise")) %>% 
  mutate(annee = gsub("prop_scolarise15_17_", "", name) %>% as.numeric(),
         value = round(value, 1)) %>%
  select(-name) %>%
  pivot_wider(names_from = annee, values_from = value, names_prefix = "prop_scolarise15_17_")  

prop_chomage_reg <- master_list$REG %>% 
  select(starts_with("prop_chomeur"), REG) %>%
  pivot_longer(cols = starts_with("prop_chomeur")) %>% 
  mutate(annee = gsub("prop_chomeur_", "", name) %>% as.numeric(),
         value = round(value, 1)) %>%
  select(-name) %>%
  pivot_wider(names_from = annee, values_from = value, names_prefix = "prop_chomeur_")  

france_region_data <- france_region %>% 
  left_join(prop_scol_reg, by = c("code_insee" = "REG")) %>% 
  left_join(prop_chomage_reg, by = c("code_insee" = "REG"))

#add data to shape files - départements
prop_scol_dep <- master_list$DEP %>% 
  select(starts_with("prop_scolarise"), DEP) %>%
  pivot_longer(cols = starts_with("prop_scolarise")) %>% 
  mutate(annee = gsub("prop_scolarise15_17_", "", name) %>% as.numeric(),
         value = round(value, 1)) %>%
  select(-name) %>%
  pivot_wider(names_from = annee, values_from = value, names_prefix = "prop_scolarise15_17_")  

prop_chomage_dep <- master_list$DEP %>% 
  select(starts_with("prop_chomeur"), DEP) %>%
  pivot_longer(cols = starts_with("prop_chomeur")) %>% 
  mutate(annee = gsub("prop_chomeur_", "", name) %>% as.numeric(),
         value = round(value, 1)) %>%
  select(-name) %>%
  pivot_wider(names_from = annee, values_from = value, names_prefix = "prop_chomeur_")  

france_departement_data <- france_dep %>% 
  left_join(prop_scol_dep, by = c("code_insee" = "DEP")) %>% 
  left_join(prop_chomage_dep, by = c("code_insee" = "DEP"))

#add data to shape files - communes
prop_scol_com <- master_list$CODGEO %>% 
  select(starts_with("prop_scolarise"), CODGEO) %>%
  pivot_longer(cols = starts_with("prop_scolarise")) %>% 
  mutate(annee = gsub("prop_scolarise15_17_", "", name) %>% as.numeric(),
         value = round(value, 1)) %>%
  select(-name) %>%
  pivot_wider(names_from = annee, values_from = value, names_prefix = "prop_scolarise15_17_")  

prop_chomage_com <- master_list$CODGEO %>% 
  select(starts_with("prop_chomeur"), CODGEO) %>%
  pivot_longer(cols = starts_with("prop_chomeur")) %>% 
  mutate(annee = gsub("prop_chomeur_", "", name) %>% as.numeric(),
         value = round(value, 1)) %>%
  select(-name) %>%
  pivot_wider(names_from = annee, values_from = value, names_prefix = "prop_chomeur_")  

france_commune_data <- france_communes %>% 
  left_join(prop_scol_com, by = c("insee" = "CODGEO")) %>% 
  left_join(prop_chomage_com, by = c("insee" = "CODGEO"))
