## we are R
library("ggplot2")
library("tidyverse")
library("ggpubr")

spanV <- 0.5

## PKW spierniczyła Teryt w 2023/2024 roku ############################

#pe24 <- read.csv("2024_pe_gminy.csv", sep = ';', dec=',',
#                 header=T, na.string="NA",
#                 colClasses = c('TERYT.Gminy'= 'character')) %>%
#  filter ( TERYT.Gminy == '')
#  select ( teryt=TERYT.Gminy,  
#           gmina=Gmina,
#           pis=KOMITET.WYBORCZY.PRAWO.I.SPRAWIEDLIWOŚĆ,
#           po = KOALICYJNY.KOMITET.WYBORCZY.KOALICJA.OBYWATELSKA
#           #sld=KOALICYJNY.KOMITET.WYBORCZY.LEWICA
#           ) %>% mutate (typ = 'PE', year = '2024') 


pe24 <- read.csv("pe2024_by_gmina.csv", sep = ';', dec='.',
                 header=T, na.string="NA",  
                 colClasses = c('teryt'= 'character') ) |>
        ## statki/zagranica out
        filter ( teryt != '') |> 
        filter (! teryt %in% c('149901', '149801', '229801')) |> 
       select ( teryt,
          pis=pis.p,
          po = po.p   ) %>% mutate (typ = 'PE', year = '2024') 



pe19 <- read.csv("2019_pe_gminy.csv", sep = ';',  dec=',',
                 header=T, na.string="NA",
                 colClasses = c('TERYT'= 'character')) %>%
  select ( teryt=TERYT,
           gmina = 'Jednostka.terytorialna',
           pis='KOMITET.WYBORCZY.PRAWO.I.SPRAWIEDLIWOŚĆ...ZPOW.603.5.19',
           po = 'KOALICYJNY.KOMITET.WYBORCZY.KOALICJA.EUROPEJSKA.PO.PSL.SLD..N.ZIELONI...ZPOW.603.7.19'
  ) |>
  filter (teryt != '') |> 
  filter (! teryt %in% c('149901', '149801', '229801')) |> 
  mutate (typ = 'PE', year = '2019')

### statki i zagranica jako pseudo-teryty
pl23 <- read.csv("2023_pl_gminy.csv", sep = ';', dec=',',
                 header=T, na.string="NA",
                   colClasses = c('TERYT.Gminy'= 'character')) |>
  select ( teryt=TERYT.Gminy,  
           gmina=Gmina,
           pis='KOMITET.WYBORCZY.PRAWO.I.SPRAWIEDLIWOŚĆ',
           po = 'KOALICYJNY.KOMITET.WYBORCZY.KOALICJA.OBYWATELSKA.PO..N.IPL.ZIELONI'
           #sld=KOALICYJNY.KOMITET.WYBORCZY.LEWICA
  ) |>
  mutate(teryt = ifelse( nchar(teryt) == 5, sprintf ("0%s", teryt), teryt)) |>
  filter (teryt != '') |> 
  ## statki/zagranica out
  filter ( ! teryt %in% c('149901', '149801', '229801')) |> 
  mutate (typ = 'PL', year = '2023')

##str(pl23)

pl19 <- read.csv("2019_pl_gminy.csv", sep = ';',  header=T, dec=',',
                 na.string="NA",
                 colClasses = c('Kod.TERYT'= 'character')) %>%
  select ( teryt='Kod.TERYT',  
           gmina=Gmina,
           pis ='KOMITET.WYBORCZY.PRAWO.I.SPRAWIEDLIWOŚĆ...ZPOW.601.9.19',
           po  = 'KOALICYJNY.KOMITET.WYBORCZY.KOALICJA.OBYWATELSKA.PO..N.IPL.ZIELONI...ZPOW.601.6.19'
           #sld=KOALICYJNY.KOMITET.WYBORCZY.LEWICA
  ) |>
  filter (teryt != '') |> 
  filter (! teryt %in% c('149901', '149801', '229801')) |> 
  mutate (typ = 'PL', year = '2019')
#str(pl19)

#d0w <- dplyr::bind_rows(pe19, pl19, pl23, pe24)


d0 <- left_join(pe24, pe19, by='teryt') |>
  left_join(pl23, by='teryt') |>
  left_join(pl19, by='teryt')  %>%
  select (teryt, 
          pis.pe24=pis.x,
          pis.pe19=pis.y,
          pis.pl23=pis.x.x,
          pis.pl19=pis.y.y,
          po.pe24=po.x,
          po.pe19=po.y,
          po.pl23=po.x.x,
          po.pl19=po.y.y
          )



##
## Values from `pis` are not uniquely identified; output will contain list-cols.
#pis <- d0w %>% select (-po) |> 
#  mutate ( typ = sprintf("%s%s", typ, year),
#           terytYr=sprintf("%s%s%s", teryt, year, typ)
#           ) |>
#  select (pis, typ ) %>%
#  #select (-teryt) %>%
#  pivot_wider(names_from = 'typ', values_from = 'pis'  )
## https://stackoverflow.com/questions/59639039/r-long-to-wide-with-pair-of-columns
# pivot_wider(names_from = T, values_from = V, values_fill = list(V = 0))

#d0 |> 
#  mutate ( typ = sprintf("%s%s", typ, year),
#           ##terytYr=sprintf("%s%s%s", teryt, year, typ)
#  ) |>
#  dplyr::group_by(typ) %>%
#  dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
#  dplyr::filter(n > 1L) 

d0 |> select(
  pis.pe24,
  pis.pe19,
  pis.pl23,
  pis.pl19 ) |> pairs()

d0 |> select(
  po.pe24,
  po.pe19,
  po.pl23,
  po.pl19 ) |> pairs()

stitle <- 'wyniki % w gminach (bez zagranicy)'

p1pe.pis <- ggplot(d0, aes(y=pis.pe24, x=pis.pe19)) +
 #geom_smooth(method="loess", se=F, span=spanV, size=.4) +
 ggtitle("PiS wybory do PE 2024 vs 2019",  subtitle = stitle) +
 ##labs(caption="Eurostat: DEMO_MLIFETABLE") +
 geom_point(size=.8, alpha=.5) +
 geom_abline(intercept = 0, slope = 1, color='red') +
 expand_limits(x = 0, y = 0)

p1pe.pis

p1pe.po <- ggplot(d0, aes(y=po.pe24, x=po.pe19)) +
  #geom_smooth(method="loess", se=F, span=spanV, size=.4) +
  ggtitle("PO wybory do PE 2024 vs 2019",  subtitle = stitle) +
  ##labs(caption="Eurostat: DEMO_MLIFETABLE") +
  geom_point(size=.8, alpha=.5) +
  geom_abline(intercept = 0, slope = 1, color='red') +
  expand_limits(x = 0, y = 0)

p1pe.po

p1pl.pis <- ggplot(d0, aes(y=pis.pl23, x=pis.pl19)) +
  #geom_smooth(method="loess", se=F, span=spanV, size=.4) +
  ggtitle("PiS wybory do Sejmu 2023 vs 2019",  subtitle = stitle) +
  ##labs(caption="Eurostat: DEMO_MLIFETABLE") +
  geom_point(size=.8, alpha=.5) +
  geom_abline(intercept = 0, slope = 1, color='red') +
  expand_limits(x = 0, y = 0)

p1pl.pis

p1pl.po <- ggplot(d0, aes(x=po.pl19, y=po.pl23)) +
  #geom_smooth(method="loess", se=F, span=spanV, size=.4) +
  ggtitle("PO wybory do Sejmu 2023 vs 2019",  subtitle = stitle) +
  ##labs(caption="Eurostat: DEMO_MLIFETABLE") +
  geom_point(size=.8, alpha=.5) +
  geom_abline(intercept = 0, slope = 1, color='red') +
  expand_limits(x = 0, y = 0)
p1pl.po

####

p1pepl.pis <- ggplot(d0, aes(y=pis.pe24, x=pis.pl23)) +
  #geom_smooth(method="loess", se=F, span=spanV, size=.4) +
  ggtitle("PiS wybory do PE 2024 vs Sejm 2023",  subtitle = stitle) +
  ##labs(caption="PKW") +
  geom_point(size=.8, alpha=.5) +
  geom_abline(intercept = 0, slope = 1, color='red') +
  expand_limits(x = 0, y = 0)

p1pepl.pis

p1pepl.po <- ggplot(d0, aes(y=po.pe24, x=po.pl23)) +
  #geom_smooth(method="loess", se=F, span=spanV, size=.4) +
  ggtitle("PO wybory do PE 2024 vs Sejm 2023", subtitle = stitle ) +
  ##labs(caption="PKW") +
  geom_point(size=.8, alpha=.5) +
  geom_abline(intercept = 0, slope = 1, color='red') +
  expand_limits(x = 0, y = 0)

p1pepl.po

p00 <- ggarrange(p1pe.pis, p1pe.po,
          p1pl.pis, p1pl.po,
          p1pepl.pis, p1pepl.po, ncol = 2, nrow = 3
          )
p00


ggsave(plot = p00, filename = "xyPlot.png", width = 10, height = 12)
##
##
#library(scatterPlotMatrix)
##install.packages('scatterPlotMatrix')
#d01 <- d0 |> select(
#  po.pe24,
#  po.pe19,
#  po.pl23,
#  po.pl19 ) 
#scatterPlotMatrix (d01)
