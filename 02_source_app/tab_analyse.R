tab_analyse <- tabPanel("Analyse", 
         titlePanel("Intro"),
         fluidRow(p("Depuis le premier confinement, l'accès à l'éducation a été affecté de différentes 
                          manières et à différent niveaux mettant encore au jour une France avec plusieurs niveaux. 
                          Accès en présentiel limité, accès à l'apprentissage à distance plus difficile, 
                          capacités des enseignants, des parents et des élèves à s'adapter, perte de 
                          motivation et d'accompagnement, baisse de moral, etc, autant de facteur qui
                          font que la lutte contre le décrochage scolaire devient de plus en plus difficile."),
                  p("Cette analyse utilise deux jeux de données de L'INSEE, l'Enquête Emploi et 
                          le Recencement de la Population. Elle essaye de mettre en lumière que le fait
                          que l'accès au marché de l'emploi se fait de plus en plus avec des diplômes,
                          ainsi qu'il exisite une corrélation entre le chômage et le décrochage scolaire.
                          Et cela indépendement de la Covid-19, car les chiffres disponnibles vont jusqu'à
                          2017 pour le recencement."),
                  p("Elle utilise comme proxy pour le décrochage scolaire le taux de scolarité des
                          jeunes de 15 à 17 ans."),
                  p("Il est important de noter qu'une corrélation entre deux variables ne signifie pas
                          une causalité. Le but de cette analyse n'est pas de tirer une conclusion générale,
                          mais d'attirer l'attention dans le but de commencer une discussion. Elle a pour but 
                          d'être le point départ pour des personnes intéréssés par ce sujet et qui aimeraient
                          humaniser ces chiffres car ces derniers sont disponnibles jusqu'au niveau des communes.")),
         p(),
         titlePanel("Analyse"),
         fluidRow(
           p("Selon les Enquêtes Emploi de 2007 à 2017 le taux d'emploi* en France reste 
                   constant pour les femmes (47%). Le taux d'emploi pour les hommes a diminué de 57 à 
                   55%**. Les personnes ayant un dipôme bac/brevet professionel, bac +2 ou diplôme
                   supérieur occupent une part des emplois de plus en plus grande (47.9% en 2007 
                   et 60.4% en 2017). Ces derniers montrent aussi une augmentation du nombre d'emploi 
                   (3,676 millions d'emploi en plus entre 2017 et 2007) alors que le nombre d'emplois 
                   des sans diplômes, niveau brevet ou CAP/BEP a diminué (2,467 millions d'emplois en moins
                   entre 2017 et 2007)"),
           h6(em("*Emploi selon la définition BIT.")),
           h6(em("**Résultat indicatif, pas de marge d'erreur disponnible dans le jeu de données"))),
         p(),
         fluidRow(
           tabBox(
             title = "Enquête Emploi",
             width = 12,
             tabPanel("Taux emploi 2007 - 2017", tableOutput("table_taux_emploi")),
             tabPanel("Proportion de la répartition des emplois 2007 - 2017", plotlyOutput("plot_repartition_emplois")),
             tabPanel("Différence du nombre d'emplois entre 2007 et 2017", plotlyOutput("plot_difference_emplois"))
           )
         ),
         p(),
         fluidRow(
           p("En 2017, le taux de scolarité pour les jeunes de 15 à 17 ans* est resté le même (96%) 
                     au niveau national par rapport à 2007. "),
           tags$li("Pour, les région, il varie entre 97% (Bretagne, Ile-de-France, et Pays de la Loire) et 86%
                           (en Guyanne) ou 95% en France métropolitaine (Hauts-de-France, Provence-Alpes-Côte-d'Azur, et Corse)."),
           tags$li("Pour les départements, il varie entre 98% (Haute-Loire et Hauts-de-Seine) et 86% 
                   (Guyane) ou 93% (Allier et Pyrénées-Orientales)."),
           h6(em("Recensement de la population: 2007, 2012 et 2017")),
           h6(em("*Taux de scolarité pour les jeunes de 15 à 17 ans : Nombre de personnes scolarisées de 15 à 17 ans en 2017 / Nombre de personnes de 15 à 17 ans"))
         ),
         p(),
         fluidRow(
           tabBox(
             title = "Recensement de la population",
             width = 12,
             tabPanel("Taux de scolarité des 15 - 17 ans - National", tableOutput("table1")),
             tabPanel("Taux de scolarité des 15 - 17 ans - Région", plotlyOutput("plot_regions_col")),
             tabPanel("Taux de scolarité des 15 - 17 ans - Région", leafletOutput("map_scol_region")),
             tabPanel("Taux de scolarité des 15 - 17 ans - Région", DTOutput("table31")),
             tabPanel("Taux de scolarité des 15 - 17 ans - Département", leafletOutput("map_scol_departement")),
             tabPanel("Taux de scolarité des 15 - 17 ans - Département", DTOutput("table3"))
           )
         ),
         p(),
         fluidRow(
           p("En 2017, la proportion des chomeurs de 15 à 64 ans* quant à elle",
             tags$li("pour les régions, varie de 12% (Ile-de-France, Pays de la Loire, Bretage, 
                   Auvergne-Rhône-Alpes, et Corse) à 36% (Guyane) ou 17% en France métropolitaine (Hauts-de-France)."),
             tags$li("Pour les départements, elle varie de 9% (le Cantal, la Mayenne et la Savoie) à 36% (Guyane)
                           ou 20% en France métropolitaine (Pyrénées-Orientales)")),
           h6(em("Recensement de la population: 2007, 2012 et 2017")),
           h6(em("*Nombre de chômeurs de 15 à 64 ans  / Nombre de personnes actives de 15 à 64 ans"))
         ),
         p(),
         fluidRow(
           tabBox(
             title = "Recensement de la population",
             width = 12,
             
             tabPanel("Proportion des chomeurs - Région", leafletOutput("map_chomage_region")),
             tabPanel("Proportion des chomeurs - Région", DTOutput("table4")),
             tabPanel("Proportion des chomeurs - Département", leafletOutput("map_chomage_departement")),
             tabPanel("Proportion des chomeurs - Département", DTOutput("table5"))
           )
         ),
         p(),
         fluidRow(
           p("Pour les 3 années dont les jeux de données pour le rencensement sont disponibles,
               il existe une forte corrélation négative entre le taux de scolarité des 15-17 ans et
               le taux de chômage."),
           h6(em("Recensement de la population: 2007, 2012 et 2017"))
         ),
         p(),
         fluidRow(
           tabBox(
             title = "Corrélation",
             width = 12,
             tabPanel("Proportion chômeur ~ Taux de scolarité 15 - 17 ans", plotlyOutput("plot5")),
             tabPanel("Coefficient de corrélation - Département", tableOutput("table_cor"))
           )
         ),
         p(),
         titlePanel("Conclusion"),
         fluidRow(
           p("Une", strong("corrélation"), "ne signifie pas une causalité et cette analyse n'a pas 
               pour but de prouver un lien entre le décrochage scolaire et l'emploi. Il est aussi 
               un peu question de paradoxe de l'oeuf et la poule. De plus, lorsque cette analyse est
               poussée au sein d'un département (entre ses différentes communes), 
               la corrélation entre ces deux indicateurs varie et peut même devenir nulle dans 
               certains cas. Ce qui rend d'autant plus une généralisation difficile."),
           p(strong("Cependant"), ", il est flagrant que la part de l'emploi pour les personnes 
                 n'ayant pas le bac (ou équivalent) se réduit d'année en année, que le taux de 
                 décrochage scolaire varie grandement au sein de la France avec une corrélation 
                 avec le taux de chômage. 
                 Avec la conjoncture actuelle:"),
           tags$li("Casiment une année et demi de cours à distance ou en places limitées,"),
           tags$li("Capicité limitée pour le suivi et l'accompagnement des jeunes en classe,"),
           tags$li("Difficulté de l'apprentissage à distance (lieu non adapté, famille sur place, internet et matériel,etc),"),
           tags$li("Un arret casi complet de certains secteurs d'activité et recours au chômage partiel
                 pour cette même période,"),
           p("Il n'est pas impossible d'envisager le départ dans la vie active de certaines personnes
                     sera plus difficile.")
         ),
         actionLink("link_to_tabpanel_explore", "Si tu veux en savoir plus vers chez toi, explore ta région")
         
)
