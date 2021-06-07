#1. read files
education2017_meta <- read_csv2(unz("01_preparation_calculs/input/RP/base-ccc-diplomes-formation-2017.zip", "meta_base-cc-diplomes-formation-2017.CSV"))
close(unz("01_preparation_calculs/input/RP/base-ccc-diplomes-formation-2017.zip", "meta_base-cc-diplomes-formation-2017.CSV"))

education2017 <- read_csv2(unz("01_preparation_calculs/input/RP/base-ccc-diplomes-formation-2017.zip", "base-cc-diplomes-formation-2017.CSV"),
                           col_types = cols(.default = "c"))
close(unz("01_preparation_calculs/input/RP/base-ccc-diplomes-formation-2017.zip", "base-cc-diplomes-formation-2017.CSV"))

#2. data manipulation
##2.1 selecting columns of interest
col_to_select <- c("P17_SCOL1517", #Pop scolarisÃ©e 15-17 ans en 2017 (princ)
                   "P17_POP1517", #Pop 15-17 ans en 2017 (princ)
                   "P12_SCOL1517", #Pop scolarisÃ©e 15-17 ans en 2012 (princ)
                   "P12_POP1517", # Pop 15-17 ans en 2012 (princ)
                   "P07_SCOL1517", #Pop scolarisÃ©e 15-17 ans en 2007 (princ)
                   "P07_POP1517" #Pop 15-17 ans en 2007 (princ)
                   )

education2017_short <- education2017 %>%
  select(CODGEO, all_of(col_to_select)) 

##2.2 changing characters to numeric values
education2017_short <- education2017_short %>%
  mutate(across(.cols = all_of(col_to_select), as.numeric))

#3. cleaning working space
rm(education2017)
