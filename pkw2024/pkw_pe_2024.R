## we are R
library("ggplot2")
library("tidyverse")


spanV <- 0.5

pe24.00 <- read.csv("2024_pe_protokoly_po_obwodach.csv", sep = ';', dec=',',
                 header=T, na.string="NA",
                 colClasses = c('Teryt.Gminy'= 'character',
                                'Powiat'='character',
                                'Województwo'='character'
                                )) %>%
  mutate(Teryt.Gminy = ifelse( nchar(Teryt.Gminy) == 5, sprintf ("0%s", Teryt.Gminy), Teryt.Gminy))

names(pe24.00)

## looks OK
pe24.empty <- pe24.00 |> filter ( Teryt.Gminy == '')


pe24 <- pe24.00 |>
  select ( teryt=Teryt.Gminy,  
           okreg = 'Nr.okręgu',
           gmina=Gmina,
           Powiat,
           Województwo,
           lgw='Liczba.głosów.ważnych.oddanych.łącznie.na.wszystkie.listy.kandydatów..z.kart.ważnych.',
           o01.po="Okreg.1...Głosy.na.listę.nr.5...KKW.KOALICJA.OBYWATELSKA",
	         o02.po="Okreg.2...Głosy.na.listę.nr.5...KKW.KOALICJA.OBYWATELSKA",
           o03.po="Okreg.3...Głosy.na.listę.nr.5...KKW.KOALICJA.OBYWATELSKA",
	         o04.po="Okreg.4...Głosy.na.listę.nr.5...KKW.KOALICJA.OBYWATELSKA",
           o05.po="Okreg.5...Głosy.na.listę.nr.5...KKW.KOALICJA.OBYWATELSKA",
	         o06.po="Okreg.6...Głosy.na.listę.nr.5...KKW.KOALICJA.OBYWATELSKA",
           o07.po="Okreg.7...Głosy.na.listę.nr.5...KKW.KOALICJA.OBYWATELSKA",
           o08.po="Okreg.8...Głosy.na.listę.nr.5...KKW.KOALICJA.OBYWATELSKA",
	         o09.po="Okreg.9...Głosy.na.listę.nr.5...KKW.KOALICJA.OBYWATELSKA",
           o10.po="Okreg.10...Głosy.na.listę.nr.5...KKW.KOALICJA.OBYWATELSKA",
           o11.po="Okreg.11...Głosy.na.listę.nr.5...KKW.KOALICJA.OBYWATELSKA",
           o12.po="Okreg.12...Głosy.na.listę.nr.5...KKW.KOALICJA.OBYWATELSKA",
	         o13.po="Okreg.13...Głosy.na.listę.nr.5...KKW.KOALICJA.OBYWATELSKA",
	   ##
           o01.pis="Okreg.1...Głosy.na.listę.nr.7...KW.PRAWO.I.SPRAWIEDLIWOŚĆ",
           o02.pis="Okreg.2...Głosy.na.listę.nr.7...KW.PRAWO.I.SPRAWIEDLIWOŚĆ",
           o03.pis="Okreg.3...Głosy.na.listę.nr.7...KW.PRAWO.I.SPRAWIEDLIWOŚĆ",
           o04.pis="Okreg.4...Głosy.na.listę.nr.7...KW.PRAWO.I.SPRAWIEDLIWOŚĆ",
           o05.pis="Okreg.5...Głosy.na.listę.nr.7...KW.PRAWO.I.SPRAWIEDLIWOŚĆ",
           o06.pis="Okreg.6...Głosy.na.listę.nr.7...KW.PRAWO.I.SPRAWIEDLIWOŚĆ",
           o07.pis="Okreg.7...Głosy.na.listę.nr.7...KW.PRAWO.I.SPRAWIEDLIWOŚĆ",
           o08.pis="Okreg.8...Głosy.na.listę.nr.7...KW.PRAWO.I.SPRAWIEDLIWOŚĆ",
           o09.pis="Okreg.9...Głosy.na.listę.nr.7...KW.PRAWO.I.SPRAWIEDLIWOŚĆ",
           o10.pis="Okreg.10...Głosy.na.listę.nr.7...KW.PRAWO.I.SPRAWIEDLIWOŚĆ",
           o11.pis="Okreg.11...Głosy.na.listę.nr.7...KW.PRAWO.I.SPRAWIEDLIWOŚĆ",
           o12.pis="Okreg.12...Głosy.na.listę.nr.7...KW.PRAWO.I.SPRAWIEDLIWOŚĆ",
           o13.pis="Okreg.13...Głosy.na.listę.nr.7...KW.PRAWO.I.SPRAWIEDLIWOŚĆ",
	   ##
           o01.3d = "Okreg.1...Głosy.na.listę.nr.1...KKW.TRZECIA.DROGA.PSL.PL2050.SZYMONA.HOŁOWNI",
           o02.3d = "Okreg.2...Głosy.na.listę.nr.1...KKW.TRZECIA.DROGA.PSL.PL2050.SZYMONA.HOŁOWNI",
           o03.3d = "Okreg.3...Głosy.na.listę.nr.1...KKW.TRZECIA.DROGA.PSL.PL2050.SZYMONA.HOŁOWNI",
           o04.3d = "Okreg.4...Głosy.na.listę.nr.1...KKW.TRZECIA.DROGA.PSL.PL2050.SZYMONA.HOŁOWNI",
           o05.3d = "Okreg.5...Głosy.na.listę.nr.1...KKW.TRZECIA.DROGA.PSL.PL2050.SZYMONA.HOŁOWNI",
           o06.3d = "Okreg.6...Głosy.na.listę.nr.1...KKW.TRZECIA.DROGA.PSL.PL2050.SZYMONA.HOŁOWNI",
           o07.3d = "Okreg.7...Głosy.na.listę.nr.1...KKW.TRZECIA.DROGA.PSL.PL2050.SZYMONA.HOŁOWNI",
           o08.3d = "Okreg.8...Głosy.na.listę.nr.1...KKW.TRZECIA.DROGA.PSL.PL2050.SZYMONA.HOŁOWNI",
           o09.3d = "Okreg.9...Głosy.na.listę.nr.1...KKW.TRZECIA.DROGA.PSL.PL2050.SZYMONA.HOŁOWNI",
           o10.3d = "Okreg.10...Głosy.na.listę.nr.1...KKW.TRZECIA.DROGA.PSL.PL2050.SZYMONA.HOŁOWNI",
           o11.3d = "Okreg.11...Głosy.na.listę.nr.1...KKW.TRZECIA.DROGA.PSL.PL2050.SZYMONA.HOŁOWNI",
           o12.3d = "Okreg.12...Głosy.na.listę.nr.1...KKW.TRZECIA.DROGA.PSL.PL2050.SZYMONA.HOŁOWNI",
           o13.3d = "Okreg.13...Głosy.na.listę.nr.1...KKW.TRZECIA.DROGA.PSL.PL2050.SZYMONA.HOŁOWNI"    
	   ) |>
     ## https://www.geeksforgeeks.org/how-to-replace-na-with-zero-in-dplyr/
     mutate(across(where(is.numeric), ~replace_na(., 0))) |>
     ##
	   mutate (
           pis = o01.pis + o02.pis + o03.pis + o04.pis + o05.pis + o06.pis + o07.pis + o08.pis + o09.pis +
	         o10.pis + o11.pis + o12.pis + o13.pis,
           po = o01.po + o02.po + o03.po + o04.po + o05.po + o06.po + o07.po + o08.po + o09.po +
	         o10.po + o11.po + o12.po + o13.po,
	         d3 = o01.3d + o02.3d + o03.3d + o04.3d + o05.3d + o06.3d + o07.3d + o08.3d + o09.3d +
	         o10.3d + o11.3d + o12.3d + o13.3d
           ) |>
     select (
       teryt,
       okreg,
       gmina,
       Powiat,
       Województwo,
       lgw,
       pis,
       po,
       d3
     ) |>
  mutate (
    pis.p = pis/lgw * 100,
    po.p = po/lgw * 100,
    d3.p = d3/lgw * 100,
  )

## Zbiorcze wyniki
lgw.total <- sum(pe24$lgw)
lgw.total
## 11,761,948
po.total <- sum(pe24$po)
po.total
##4,359,433 != 4,359,443 (pkw)
po.total.p <- po.total /lgw.total * 100

pis.total <- sum(pe24$pis)
pis.total
##4,253,161 != 4,253,169 (pkw)
pis.total.p <- pis.total/lgw.total * 100

####
total.by.okreg <- pe24 |>
  group_by(okreg) |>
  summarise(
    lgw = sum(lgw),
    pis = sum(pis),
    po = sum(po),
    d3 = sum(d3),
    ) |>
  mutate (
    pis.p = pis/lgw * 100,
    po.p = po/lgw * 100,
    d3.p = d3/lgw * 100,
  )

###
total.by.woj <- pe24 |>
  group_by(Województwo) |>
  summarise(
    lgw = sum(lgw),
    pis = sum(pis),
    po = sum(po),
    d3 = sum(d3),
  ) |>
  mutate (
    pis.p = pis/lgw * 100,
    po.p = po/lgw * 100,
    d3.p = d3/lgw * 100,
  )

###
total.by.gmina <- pe24 |>
  group_by(teryt) |>
  summarise(
    lgw = sum(lgw),
    pis = sum(pis),
    po = sum(po),
    d3 = sum(d3),
  ) |>
  mutate (
    pis.p = pis/lgw * 100,
    po.p = po/lgw * 100,
    d3.p = d3/lgw * 100,
  )

#######################
### Wyniki wyglądają ok
########################

write.table(total.by.gmina, "pe2024_by_gmina.csv", sep = ';', row.names = F)
###
### Zagranica i statki łącznie bez numeru