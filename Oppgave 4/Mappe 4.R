# Laster inn nødvendige pakker for oppgaven.
library(rvest)
library(tidyverse)
library(rlist)
library(purrr)

#Får inn de url lenkene til forskjellige emnene jeg har dette semesteret.
url1 <-"https://timeplan.uit.no/emne_timeplan.php?sem=22v&module%5B%5D=SOK-1005-1&week=1-20&View=list"
url2 <-"https://timeplan.uit.no/emne_timeplan.php?sem=22v&module%5B%5D=BED-2032-1&View=list"
url3 <-"https://timeplan.uit.no/emne_timeplan.php?sem=22v&module%5B%5D=SOK-2050-1&View=list"

#Lager en liste som legger sammen de forskjellige url lenkene.
url_list <- list(url1, url2, url3)


#Lager så en funksjon ut av de url lenkene og kodene som ble gitt.
skrap <- function(url) {
  side <- read_html(url)
  
  table <- html_nodes(side, 'table') 
  table <- html_table(table, fill=TRUE) 
  
  dframe <- list.stack(table)
  
  colnames(dframe) <- dframe[1,]
  
  dframe <- dframe %>% filter(!Dato=="Dato")
  
  dframe <- dframe %>% separate(Dato, 
                                into = c("Dag", "Dato"), 
                                sep = "(?<=[A-Za-z])(?=[0-9])")
  
  dframe$Dato <- as.Date(dframe$Dato, format="%d.%m.%Y")
  
  dframe$Uke <- strftime(dframe$Dato, format = "%V")
  
  dframe <- dframe %>% select(Dag,Dato,Uke,Tid,Rom,Emnekode,Lærer)
  
  return(dframe)
  
}

#Bruker map funksjonen til å få listen og skrapingen sammen så binder de sammen
#for å få en slutt funksjon.

timeplan <- map(url_list, skrap)
timeplan <- bind_rows(timeplan)


#Fjerner så NA og forelesninger fra andre campuser med andre Lærere 
#for at det ikke skal dukke opp funksjonen senere.
timeplan <- subset(timeplan, Lærer != "K. Støre")
timeplan <- subset(timeplan, Lærer != "O.R. Schjølberg")
timeplan <- subset(timeplan, Rom != "ALTA_BT3 A105-AUD")
timeplan <- subset(timeplan, Lærer != "A.Mikkelsen")
timeplan <- na.omit(timeplan)

#Ordner slik at timeplanen er sortert etter dato.
timeplan <- timeplan[order(timeplan$Dato),]

#Sluttproduktet
timeplan
