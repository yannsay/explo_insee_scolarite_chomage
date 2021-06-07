#metadata 
enquete_emploi_metadata <- read_csv2(unz("01_preparation_calculs/input/enquete_emploi/metadonnees_irsocmartra19.zip", "metadonnees_irsocmartra19.csv"))
close(unz("01_preparation_calculs/input/enquete_emploi/metadonnees_irsocmartra19.zip", "metadonnees_irsocmartra19.csv"))

enquete_emploi_t206_raw <- read.csv2(unz("01_preparation_calculs/input/enquete_emploi/T206.zip", "t206.csv"))
close(unz("01_preparation_calculs/input/enquete_emploi/T206.zip", "t206.csv"))

enquete_emploi_t208_raw <- read.csv2(unz("01_preparation_calculs/input/enquete_emploi/T208.zip", "t208.csv"))
close(unz("01_preparation_calculs/input/enquete_emploi/T208.zip", "t208.csv"))

#ajouter les libelles
#T206 – Emploi et part dans l'emploi selon le plus haut diplôme obtenu, par sexe et âge regroupé, en moyenne annuelle de 1982 à 2019
enquete_emploi_t206 <- enquete_emploi_t206_raw %>%
  change_with_metadata(metadata = enquete_emploi_metadata, variable = "DDIPL") %>%
  change_with_metadata(metadata = enquete_emploi_metadata, variable = "AGEREG") 

enquete_emploi_t206$PARTEMPBIT <- as.numeric(enquete_emploi_t206$PARTEMPBIT)
#t206 part dans l'emploi
#PARTTEMPBIT: part dans l'emploi au sens du BIT
#EMPBIT: nombre d'emplois en milliers


#T208 – Taux d'emploi selon le plus haut diplôme obtenu, par sexe et âge regroupé, en moyenne annuelle de 1982 à 2019
enquete_emploi_t208 <- enquete_emploi_t208_raw %>%
  change_with_metadata(metadata = enquete_emploi_metadata, variable = "DDIPL") %>%
  change_with_metadata(metadata = enquete_emploi_metadata, variable = "AGEREG") 

enquete_emploi_t208$TXEMPBIT <- as.numeric(enquete_emploi_t208$TXEMPBIT)
#t208  taux emploi BIT

#cleaning working space
rm("enquete_emploi_metadata","enquete_emploi_t206_raw", "enquete_emploi_t208_raw")

