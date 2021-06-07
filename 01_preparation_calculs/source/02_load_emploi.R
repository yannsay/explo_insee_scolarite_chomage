#1. read files
emploi_meta <- read_csv2(unz("01_preparation_calculs/input/RP/base-ccc-emploi-pop-active-2017.zip", "meta_base-cc-emploi-pop-active-2017.CSV"))
close(unz("01_preparation_calculs/input/RP/base-ccc-emploi-pop-active-2017.zip", "meta_base-cc-emploi-pop-active-2017.CSV"))

emploi2017 <- read_csv2(unz("01_preparation_calculs/input/RP/base-ccc-emploi-pop-active-2017.zip", "base-cc-emploi-pop-active-2017.CSV"),
                        col_types = cols(.default = "c"))
close(unz("01_preparation_calculs/input/RP/base-ccc-emploi-pop-active-2017.zip", "base-cc-emploi-pop-active-2017.CSV"))

#2. data manipulation
##2.1 selecting columns of interest
col_to_select <- c("P17_POP1564", #nb de personnes de 15 à 64 ans -- 2017
                   "P17_ACT1564", #nb de personnes actives de 15 à 64 ans -- 2017
                   "P17_ACTOCC1564", #nb de personnes actives occupées -- 2017
                   "P17_CHOM1564", #nb de chômeurs -- 2017
                   
                   "P12_POP1564", #nb de personnes de 15 à 64 ans -- 2012
                   "P12_ACT1564", #nb de personnes actives de 15 à 64 ans -- 2012
                   "P12_ACTOCC1564", #nb de personnes actives occupées -- 2012
                   "P12_CHOM1564", #nb de chômeurs -- 2012
                   
                   "P07_POP1564", #nb de personnes de 15 à 64 ans -- 2012
                   "P07_ACT1564", #nb de personnes actives de 15 à 64 ans -- 2012
                   "P07_ACTOCC1564", #nb de personnes actives occupées -- 2012
                   "P07_CHOM1564") #nb de chômeurs -- 2017

emploi2017_short <- emploi2017 %>%
  select(all_of(c("CODGEO", all_of(col_to_select)))) 

##2.2 changing characters to numeric values
emploi2017_short <- emploi2017_short %>%
  mutate(across(.cols = all_of(col_to_select), as.numeric))

#3. cleaning working spakce
rm("emploi2017")

