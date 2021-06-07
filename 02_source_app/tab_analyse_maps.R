#colors for palettes
scol_bin <-c(0, 90, 95, 99,100)
orange_palette_4bin <- c('#cc4c02', '#fe9929','#fed98e','#ffffd4')  
pal_col_scol <- colorBin(orange_palette_4bin, bins = scol_bin, right = T)

chom_bin <- france_commune_data$prop_chomeur_2017 %>% quantile(na.rm=T)
blue_palette_4bin <- c('#f1eef6','#bdc9e1','#74a9cf','#0570b0')
pal_col_chom <- colorBin(blue_palette_4bin, bins = chom_bin, right = T)
map_scol_region_leaflet <- leaflet() %>%
        addProviderTiles("Esri.WorldShadedRelief") %>%
        addPolygons(data = france_region_data,
                    weight = 1,
                    fillOpacity = 1,
                    color = ~pal_col_scol(prop_scolarise15_17_2017),
                    label = ~paste0(nom, ", Proportion de scolarises 2017: ", prop_scolarise15_17_2017, " %"),
                    highlight = highlightOptions(weight = 3,
                                                 color = "red",
                                                 bringToFront = T)) %>%
        addLegend(position = "bottomright",
                  colors = c(orange_palette_4bin, "#808080"),
                  labels = c("0 - 90 % scolarisés", "90 - 95 % scolarisés",
                             "96 99 % scolarisés" ,"100 % scolarisés" , "NA"),
                  opacity = 1,
                  title = "Proportions de scolarisés 15 - 17 ans")


map_scol_departement_leaflet <- leaflet() %>%
        addProviderTiles("Esri.WorldShadedRelief") %>%
        addPolygons(data = france_departement_data,
                    weight = 1,
                    fillOpacity = 1,
                    color = ~pal_col_scol(prop_scolarise15_17_2017),
                    label = ~paste0(nom, ", Proportion de scolarises 2017: ", prop_scolarise15_17_2017, " %"),
                    highlight = highlightOptions(weight = 3,
                                                 color = "red",
                                                 bringToFront = T)) %>%
        addLegend(position = "bottomright", 
                  colors = c(orange_palette_4bin, "#808080"), 
                  labels = c("0 - 90 % scolarisés", "90 - 95 % scolarisés", 
                             "96 99 % scolarisés" ,"100 % scolarisés" , "NA"),
                  opacity = 1, 
                  title = "Proportions de scolarisés 15 - 17 ans")

map_chomage_region_leaflet <- leaflet() %>%
        addProviderTiles("Esri.WorldShadedRelief") %>%
        addPolygons(data = france_region_data,
                    weight = 1,
                    fillOpacity = 1,
                    color = ~pal_col_chom(prop_chomeur_2017),
                    label = ~paste0(nom, ", Proportion de chômeurs 2017: ", prop_chomeur_2017, " %"),
                    highlight = highlightOptions(weight = 3,
                                                 color = "blue",
                                                 bringToFront = T)) %>%
        addLegend(position = "bottomright",
                  colors = c(blue_palette_4bin, "#808080"),
                  labels = c("0 - 7,6% (1er quartile - communes)", "7,6 - 10,1% (2ème quartile - communes)",
                             "10,1 - 13,3% (3ème quartile - communes)", "13,3% - 100%(4ème quartile - communes)","Non-Applicable"),
                  title = "Taux de chômeurs 15 - 64 ans",
                  opacity = 1)

map_chomage_departement_leaflet <- leaflet() %>%
        addProviderTiles("Esri.WorldShadedRelief") %>%
        addPolygons(data = france_departement_data,
                    weight = 1,
                    fillOpacity = 1,
                    color = ~pal_col_chom(prop_chomeur_2017),
                    label = ~paste0(nom, ", Proportion de chômeurs 2017: ", prop_chomeur_2017, " %"),
                    highlight = highlightOptions(weight = 3,
                                                 color = "blue",
                                                 bringToFront = T)) %>%
        addLegend(position = "bottomright", 
                  colors = c(blue_palette_4bin, "#808080"), 
                  labels = c("0 - 7,6% (1er quartile - communes)", "7,6 - 10,1% (2ème quartile - communes)", 
                             "10,1 - 13,3% (3ème quartile - communes)", "13,3% - 100%(4ème quartile - communes)","Non-Applicable"),
                  title = "Taux de chômeurs 15 - 64 ans",
                  opacity = 1)