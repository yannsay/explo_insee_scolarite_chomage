tab_explo <- tabPanel("Explorateur",
         fluidRow(
           selectInput("region", "Région:",
                       choices = unique(code_geo$nom_region)[!is.na(unique(code_geo$nom_region))]),
           selectInput("departement", "Département :", choices = NULL)
         ),
         fluidRow(
           box(title = "Proportions de chômeurs de 15 à 64 ans - 2017", width = 6,
               leafletOutput("map_chomage_commune")),
           box(title = "Proportions de scolarisé 15 à 17 ans", width = 6,
               leafletOutput("map_scol_commune"))
         ),
         titlePanel("Chiffres - National"),
         fluidRow(
           DTOutput("table_NAT")
         ),
         titlePanel("Chiffres - Région"),
         fluidRow(
           DTOutput("table_REG")
         ),
         titlePanel("Chiffres - Département"),
         fluidRow(
           DTOutput("table_DEP")
         ),
         titlePanel("Chiffres - Communes"),
         fluidRow(
           DTOutput("table_CODEGEO")
         ),
         titlePanel("Télécharger"),
         fluidRow(
           p(downloadLink('downloadDataNAT', 'Chiffres - National'),
             downloadLink('downloadDataREG', 'Chiffres - Région'),
             downloadLink('downloadDataDEP', 'Chiffres - Département'),
             downloadLink('downloadDataCODGEO', 'Chiffres - Communes'))
         )
)