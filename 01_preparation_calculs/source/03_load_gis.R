#1. read files
code_geo <- foreign::read.dbf("01_preparation_calculs/input/geodata/communes2020.dbf") 

france_region <- sf::st_read("01_preparation_calculs/input/geodata/regions/regions-20180101.shp") %>%
  sf::st_simplify(dTolerance = .1)

france_dep <- sf::st_read("01_preparation_calculs/input/geodata/departements/departements-20180101.shp") %>%
  sf::st_simplify(dTolerance = .001)

#pour les communes telecharger les shapefiles ici; le fichier est trop gros pour être héberger sur github.
#http://osm13.openstreetmap.fr/~cquest/openfla/export/communes-20210101-shp.zip
france_communes <- sf::st_read("01_preparation_calculs/input/geodata/communes/communes-20210101.shp") %>%
  sf::st_simplify(dTolerance = .001)

#2. adding names of the régions
short_reg <- select(france_region, code_insee, nom) %>% 
  as.data.frame() %>% 
  select(-geometry)

code_geo <- code_geo %>% 
  left_join(short_reg, by = c("REG" = "code_insee")) %>% 
  rename(nom_region = nom)

#3. adding names of the départements
#3.1 Département Rhône est divisé en Rhône et Lyon 69D et 69M
france_dep_69DetM <- france_dep #to keep the initial file

france_dep$code_insee[france_dep$code_insee %in% c("69D", "69M")] <- "69"
france_dep <- france_dep %>%
  group_by(code_insee) %>%
  summarise(do_union = T) %>%
  left_join(select(as.data.frame(france_dep_69DetM), -geometry))

france_dep[france_dep$code_insee  == "69", "nom"] <- "Rhône"
france_dep[france_dep$code_insee  == "69", "surf_km2"] <- 2720
france_dep[france_dep$code_insee  == "69", "wikipedia"] <- "fr:Rhône (département)"

#3.2 adding names of the départements
short_dep <- select(france_dep, code_insee, nom) %>% 
  as.data.frame() %>% 
  select(-geometry)

code_geo <- code_geo %>% 
  left_join(short_dep, by = c("DEP" = "code_insee")) %>% 
  rename(nom_departement = nom)

#4. cleaning working space
rm(short_dep, short_reg)
