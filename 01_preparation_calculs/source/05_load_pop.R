#1. read files
population2017_meta <- read_csv2(unz("01_preparation_calculs/input/RP/base-ccc-evol-struct-pop-2017.zip", "meta_base-cc-evol-struct-pop-2017.CSV"))
close(unz("01_preparation_calculs/input/RP/base-ccc-evol-struct-pop-2017.zip", "meta_base-cc-evol-struct-pop-2017.CSV"))

population2017 <- read_csv2(unz("01_preparation_calculs/input/RP/base-ccc-evol-struct-pop-2017.zip", "base-cc-evol-struct-pop-2017.CSV"),
                            col_types = cols(.default = "c"))
close(unz("01_preparation_calculs/input/RP/base-ccc-diplomes-formation-2017.zip", "base-cc-evol-struct-pop-2017.CSV"))


#2. data manipulation
##2.1 selecting columns of interest
col_to_select <- c("P17_POP", #Population en 2017
                   "P12_POP", #Population en 2012
                   "P07_POP" #Population en 2007
                   )

population2017_short <- population2017 %>%
  select(CODGEO, all_of(col_to_select)) 

##2.2 changing characters to numeric values
population2017_short <- population2017_short %>%
  mutate(across(.cols = all_of(col_to_select), as.numeric))

#3. cleaning working space
rm(population2017)
