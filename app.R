library(tidyverse)
library(RColorBrewer)
library(plotly)
library(leaflet)
library(DT)
library(scales)
library(shiny)
library(shinydashboard)

source("02_source_app/load_files.R")

source("02_source_app/tab_analyse.R", encoding = "UTF-8")
source("02_source_app/tab_explo.R", encoding = "UTF-8")
source("02_source_app/tab_ensavoirplus.R", encoding = "UTF-8")
source("02_source_app/tab_analyse_maps.R", encoding = "UTF-8")


ui <- {
  body <- dashboardBody(
    fluidPage(
      tabsetPanel(
        id = "main",
        tab_analyse,
        tab_explo,
        tab_ensavoirplus
        
      )
    )
  )
  
  
  dashboardPage(
    dashboardHeader(disable = T),
    dashboardSidebar(disable = T),
    body
  )
}
  


server <- function(input, output, session) {
  #colors for palettes
  scol_bin <-c(0, 90, 95, 99,100)
  orange_palette_4bin <- c('#cc4c02', '#fe9929','#fed98e','#ffffd4')  
  pal_col_scol <- colorBin(orange_palette_4bin, bins = scol_bin, right = T)
  
  chom_bin <- france_commune_data$prop_chomeur_2017 %>% quantile(na.rm=T)
  blue_palette_4bin <- c('#f1eef6','#bdc9e1','#74a9cf','#0570b0')
  pal_col_chom <- colorBin(blue_palette_4bin, bins = chom_bin, right = T)
  
  
  output$table_taux_emploi <- renderTable({
    enquete_emploi_t208 %>% 
      filter(DDIPL == "T", AGEREG == "T", ANNEE5 %in%c(2007,2012,2017)) %>%
      pivot_wider(names_from = ANNEE5, values_from = TXEMPBIT) %>%
      cbind(taux = c("Taux emploi pour les hommes",
                     "Taux emploi pour les femmes", 
                     "Taux emploi ensemble")) %>%
      select(taux, `2007`, `2012`, `2017`) %>%
      arrange(taux) %>%
      mutate(`2007` = label_percent()(`2007`/100),
             `2012` = label_percent()(`2012`/100),
             `2017` = label_percent()(`2017`/100))
  })
  
  output$plot_repartition_emplois <- renderPlotly({
    plotly1 <- enquete_emploi_t206 %>% 
      mutate(DDIPL_LIB = as_factor(DDIPL_LIB)) %>%
      filter(DDIPL != "T", AGEREG == "T", SEXE == "E", ANNEE5 >= 2007, ANNEE5 <= 2017) %>%
      ggplot() +
      geom_bar(aes(x = ANNEE5, y = PARTEMPBIT, fill = DDIPL_LIB,
                   text = paste("</br>Année:", ANNEE5, "</br>%:", PARTEMPBIT, "</br>Diplome:", DDIPL_LIB)), 
               position = "stack", stat = "identity"
      ) +
      scale_fill_brewer(palette = "RdYlBu") +
      labs(title = "Proportion de la répartition des emplois par diplomes et par années", 
           x = "Année", 
           y = "%",
           fill = "Diplome")
    plotly1 <- ggplotly(plotly1, tooltip="text")
  })
  
  output$plot_difference_emplois <- renderPlotly({
    enquete_emploi_t206 %>% 
      filter(DDIPL != "T", AGEREG == "T", SEXE == "E", ANNEE5 %in% c(2007,2017)) %>%
      select(ANNEE5, DDIPL, EMPBIT) %>%
      pivot_wider(names_from = c(ANNEE5),  values_from = EMPBIT) %>%
      mutate(diff_2007_2017 = `2017` - `2007`) %>%
      left_join(unique(select(enquete_emploi_t206, DDIPL, DDIPL_LIB))) %>%
      mutate(DDIPL_LIB = as_factor(DDIPL_LIB)) %>%
      ggplot() +
      geom_col(aes(x = reorder(DDIPL_LIB, desc(DDIPL_LIB)) , y = diff_2007_2017, fill = DDIPL_LIB,
                   text = paste("</br>Diplome: ", DDIPL_LIB, "</br>Différence: ", diff_2007_2017))) +
      coord_flip() +
      scale_fill_brewer(palette = "RdYlBu") +
      labs(title = "Différence du nombre d'emplois\n par diplomes entre 2007 et 2017", 
           x = "Diplome", 
           y = "Nbr en milliers") +
      theme(legend.position = "bottom")
    ggplotly(tooltip="text")
  })
  
  output$table1 <- renderTable({
    master_list$NAT %>%
      select(starts_with("prop_scolarise")) %>%
      pivot_longer(cols = starts_with("prop_scolarise")) %>%
      mutate(annee = gsub("prop_scolarise15_17_", "", name)) %>%
      select(-name) %>%
      pivot_wider(names_from = annee, values_from = value) %>%
      mutate(titre = "Part des scolarisés de 15 à 17 ans") %>%
      select(titre, `2007`, `2012`, `2017`) %>%
      mutate(`2007` = label_percent(accuracy = 1L, trim = F)(`2007`/100),
             `2012` = label_percent(accuracy = 1L, trim = F)(`2012`/100),
             `2017` = label_percent(accuracy = 1L, trim = F)(`2017`/100))
  })
  
  output$plot_regions_col <- renderPlotly({
    master_list$REG %>%
      select(starts_with("prop_scolarise"), nom_region) %>%
      pivot_longer(cols = starts_with("prop_scolarise")) %>%
      mutate(annee = gsub("prop_scolarise15_17_", "", name) %>% as.numeric(),
             value = round(value)) %>%
      filter(annee == 2017) %>%
      arrange(value) %>%
      ggplot() +
      geom_col(aes(x = nom_region, y = value,
                   text = paste("</br>", nom_region, ":", value, "%")),
               fill = "#00abff") +
      labs(title = "Taux de scolarités des 15-17ans en 2017 par régions",
           x = "Régions",
           y = "Taux de scolarité des 15-17ans en %") +
      theme(axis.line=element_blank(),axis.text.x=element_blank(),axis.ticks=element_blank())
    ggplotly(tooltip="text")
    
  })
  
  
  
  output$table31 <- renderDT({
    master_list$REG %>%
      select(starts_with("prop_scolarise15_17_"), nom_region) %>%
      select(nom_region, prop_scolarise15_17_2007, prop_scolarise15_17_2012, prop_scolarise15_17_2017) %>%
      rename(`Région` = nom_region,
             `2007` = prop_scolarise15_17_2007,
             `2012` = prop_scolarise15_17_2012,
             `2017` = prop_scolarise15_17_2017) %>%
      mutate(`2007` = label_percent(accuracy = 1L, trim = F)(`2007`/100),
             `2012` = label_percent(accuracy = 1L, trim = F)(`2012`/100),
             `2017` = label_percent(accuracy = 1L, trim = F)(`2017`/100))
  }, rownames = F)
  
  output$table3 <- renderDT({
    master_list$DEP %>%
      select(starts_with("prop_scolarise15_17_"), nom_departement) %>%
      select(nom_departement, prop_scolarise15_17_2007, prop_scolarise15_17_2012, prop_scolarise15_17_2017) %>%
      rename(`Département` = nom_departement,
             `2007` = prop_scolarise15_17_2007,
             `2012` = prop_scolarise15_17_2012,
             `2017` = prop_scolarise15_17_2017) %>%
      mutate(`2007` = label_percent(accuracy = 1L, trim = F)(`2007`/100),
             `2012` = label_percent(accuracy = 1L, trim = F)(`2012`/100),
             `2017` = label_percent(accuracy = 1L, trim = F)(`2017`/100))
  }, rownames = F)
  

  
  output$map_scol_region <- renderLeaflet({
    map_scol_region_leaflet

  })

  output$map_scol_departement <- renderLeaflet({
    map_scol_departement_leaflet

  })
  
  
  
  
  #### chomage
  output$table4 <- renderDT({
    master_list$REG %>%
      select(starts_with("prop_chomeur"), nom_region) %>%
      select(nom_region, prop_chomeur_2007, prop_chomeur_2012, prop_chomeur_2017) %>%
      rename(`Région` = nom_region, 
             `2007` = prop_chomeur_2007,
             `2012` = prop_chomeur_2012,
             `2017` = prop_chomeur_2017) %>%
      mutate(`2007` = label_percent(accuracy = 1L, trim = F)(`2007`/100),
             `2012` = label_percent(accuracy = 1L, trim = F)(`2012`/100),
             `2017` = label_percent(accuracy = 1L, trim = F)(`2017`/100)) 
  }, rownames = F)
  
  
  
  output$table5 <- renderDT({
    master_list$DEP %>%
      select(starts_with("prop_chomeur"), nom_departement) %>%
      mutate(across(starts_with("prop_chomeur"), function(x) { x /100})) %>%
      select(nom_departement, prop_chomeur_2007, prop_chomeur_2012, prop_chomeur_2017) %>%
      rename(`Département` = nom_departement, 
             `2007` = prop_chomeur_2007,
             `2012` = prop_chomeur_2012,
             `2017` = prop_chomeur_2017) %>%
      mutate(`2007` = label_percent(accuracy = 1L, trim = F)(`2007`),
             `2012` = label_percent(accuracy = 1L, trim = F)(`2012`),
             `2017` = label_percent(accuracy = 1L, trim = F)(`2017`))
  }, rownames = F)

  output$map_chomage_region <- renderLeaflet({
    map_chomage_region_leaflet

  })

  output$map_chomage_departement <- renderLeaflet({
    map_chomage_departement_leaflet

  })

  ####core
  prop_chomage_dep <- master_list$DEP %>%
    select(starts_with("prop_chomeur"), nom_departement) %>%
    pivot_longer(cols = starts_with("prop_chomeur")) %>%
    mutate(annee = gsub("prop_chomeur_", "", name),
           value = round(value)) %>%
    select(-name) %>%
    rename(prop_chomeur = value)
  prop_scol_dep <- master_list$DEP %>% 
    select(starts_with("prop_scolarise"), nom_departement) %>%
    pivot_longer(cols = starts_with("prop_scolarise")) %>% 
    mutate(annee = gsub("prop_scolarise15_17_", "", name)) %>%
    select(-name) %>%
    rename(prop_scolarise15_17 = value)
  prop_chomage_scol_dep <- prop_chomage_dep %>%
    left_join(prop_scol_dep, by = c("nom_departement", "annee"))
  

  output$plot5 <- renderPlotly({
    prop_chomage_scol_dep %>%
      filter(annee == 2017) %>%
      ggplot(aes(x = prop_scolarise15_17, y = prop_chomeur, 
                 text = paste("</br>", nom_departement, "</br> Proportion chômeur: ", prop_chomeur, 
                              "</br>Proportion scolarisé: ", prop_scolarise15_17))) +
      geom_point() +
      labs(title = "Taux de scolarités des 15-17ans en 2017 et proportion de chômeurs, en 2017",
           x = "Taux de scolarités des 15-17ans en %",
           y = "proportion de chômeurs en %")
    ggplotly(tooltip="text")
  })
  
  output$table_cor <- renderTable({
    prop_chomage_scol_dep %>% 
      split(prop_chomage_scol_dep$annee) %>% 
      lapply(function(x) {cor(x$prop_chomeur, x$prop_scolarise15_17)}) %>%
      do.call(cbind,.) %>% 
      as.data.frame() %>%
      mutate(nom = "Coefficient de corrélation",
             across(all_of(c("2007", "2012", "2017")), round, 2)) %>%
      select(nom, `2007`, `2012`, `2017`)
    
  })
  observeEvent(input$link_to_tabpanel_explore, {
    newvalue <- "Explorateur"
    updateTabsetPanel(session, "main", newvalue)
  })
  ## tab explo
  #choices input
  observe({
    code_geo_for_dep <- code_geo %>% filter(nom_region == input$region)
    
    departement_list <- code_geo_for_dep$nom_departement %>% unique()
    
    updateSelectInput(session, inputId = "departement", choices = departement_list)
    
  })

  
  
  output$map_chomage_commune <- renderLeaflet({
    france_commune_data_for_map <- france_commune_data %>%
      filter(!is.na(prop_chomeur_2017),
             insee %in% code_geo$COM[code_geo$nom_departement == input$departement])
    
    leaflet() %>%
      addProviderTiles("Esri.WorldShadedRelief") %>%
      addPolygons(data = france_commune_data_for_map,
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
    
  })
  
  output$map_scol_commune <- renderLeaflet({
    france_commune_data_for_map <- france_commune_data %>%
      filter(!is.na(prop_chomeur_2017),
             insee %in% code_geo$COM[code_geo$nom_departement == input$departement])
    
    
    leaflet() %>%
      addProviderTiles("Esri.WorldShadedRelief") %>%
      addPolygons(data = france_commune_data_for_map,
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
    
  })
  
  output$table_NAT <- renderDT({
    master_list$NAT
  },rownames = F, options = list(scrollX = TRUE))
  output$downloadDataNAT <- downloadHandler(
    filename = function() {
      paste('data-nat', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
      write.csv2(master_list$NAT, con)
    }
  )
  
  output$table_REG <- renderDT({
    master_list$REG %>%
      filter(nom_region %in% input$region)
  },rownames = F, options = list(scrollX = TRUE))
  
  output$downloadDataREG <- downloadHandler(
    filename = function() {
      paste('data-reg', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
      master_list$REG %>%
        filter(nom_region %in% input$region) %>%
        write.csv2(con)
    }
  )
  
  output$table_DEP <- renderDT({
    master_list$DEP %>%
      filter(nom_departement %in% input$departement)
  },rownames = F, options = list(scrollX = TRUE))
  
  output$downloadDataDEP <- downloadHandler(
    filename = function() {
      paste('data-dep', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
      master_list$DEP %>%
        filter(nom_departement %in% input$departement) %>%
        write.csv2(con)
    }
  )
  
  output$table_CODEGEO <- renderDT({
    master_list$CODGEO %>%
      filter(CODGEO %in% code_geo$COM[code_geo$nom_departement == input$departement])
  },rownames = F, options = list(scrollX = TRUE))
  
  output$downloadDataCODGEO <- downloadHandler(
    filename = function() {
      paste('data-CODGEO', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
      master_list$CODGEO %>%
        filter(CODGEO %in% code_geo$COM[code_geo$nom_departement == input$departement]) %>%
        write.csv2(con)
    }
  )


  
  
}


shinyApp(ui, server)