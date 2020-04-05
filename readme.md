El problema de Monty Hall
=========================

Aplicación Shiny para simular el popular concurso de Monty Hall para
ilustrar la importancia de la probabilidad condicionada. La simulación
se puede hacer partida a partida o en un bloque de partidas.

Puedes ver una versión funcionando en el siguiente enlace:

https://shiny.uclm.es/apps/montyhall/

Envía un _issue_ si algo no te funciona, o _pull request_ si tienes alguna sugerencia de mejora. Verifica primero que tienes las versiones de los paquetes necesarios. Puede que sea necesario instalar una versión distinta de la que hay en CRAN.


```r
sessionInfo()
```

```
## R version 3.6.2 (2019-12-12)
## Platform: x86_64-apple-darwin15.6.0 (64-bit)
## Running under: macOS Catalina 10.15.4
## 
## Matrix products: default
## BLAS:   /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib
## LAPACK: /Library/Frameworks/R.framework/Versions/3.6/Resources/lib/libRlapack.dylib
## 
## locale:
## [1] es_ES.UTF-8/es_ES.UTF-8/es_ES.UTF-8/C/es_ES.UTF-8/es_ES.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] tidyr_1.0.2           plotly_4.9.2          htmlwidgets_1.5.1     DiagrammeR_1.0.5.9000
##  [5] waffle_0.7.0          ggplot2_3.3.0         kableExtra_1.1.0      knitr_1.28           
##  [9] shinythemes_1.1.2     shinydashboard_0.7.1  dplyr_0.8.5           tibble_3.0.0         
## [13] shinyjs_1.1           png_0.1-7             shinyWidgets_0.5.1    shiny_1.4.0.2        
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_1.0.4         visNetwork_2.0.9   assertthat_0.2.1   digest_0.6.25     
##  [5] packrat_0.5.0      mime_0.9           R6_2.4.1           evaluate_0.14     
##  [9] highr_0.8          httr_1.4.1         pillar_1.4.3       rlang_0.4.5       
## [13] lazyeval_0.2.2     rstudioapi_0.11    data.table_1.12.8  extrafontdb_1.0   
## [17] rmarkdown_2.1      webshot_0.5.2      extrafont_0.17     readr_1.3.1       
## [21] stringr_1.4.0      munsell_0.5.0      compiler_3.6.2     httpuv_1.5.2      
## [25] xfun_0.12          pkgconfig_2.0.3    htmltools_0.4.0    tidyselect_1.0.0  
## [29] gridExtra_2.3      fansi_0.4.1        viridisLite_0.3.0  crayon_1.3.4      
## [33] withr_2.1.2        later_1.0.0        grid_3.6.2         jsonlite_1.6.1    
## [37] xtable_1.8-4       Rttf2pt1_1.3.8     gtable_0.3.0       lifecycle_0.2.0   
## [41] magrittr_1.5       scales_1.1.0       cli_2.0.2          stringi_1.4.6     
## [45] promises_1.1.0     xml2_1.2.5         ellipsis_0.3.0     vctrs_0.2.4       
## [49] RColorBrewer_1.1-2 tools_3.6.2        glue_1.3.2         markdown_1.1      
## [53] purrr_0.3.3        hms_0.5.3          rsconnect_0.8.16   fastmap_1.0.1     
## [57] yaml_2.2.1         colorspace_1.4-1   rvest_0.3.5
```

