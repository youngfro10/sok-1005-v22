library(jsonlite)
library(tidyverse)
library(ggrepel)
library(rvest)
library(countrycode)

# Jeg valgte å bruke pakken jsonlite for å få inn json urlen som vi skulle bruke.
# lastet så inn Tidyverse fordi den inneholder pakker som kan være nødvendige.
# Og ggrepel fordi den har funksjoner som jeg kan bruke på labeler statene.
# Countrycode pakken gir oss statene, der vi kan forkorte de.


#Henter data fra sidekilder
# Henter inn datasett fra Json og mutater en ny variabel med forkortelse av stater.

Jsondata <- fromJSON("https://static01.nyt.com/newsgraphics/2021/12/20/us-coronavirus-deaths-2021/ff0adde21623e111d8ce103fedecf7ffc7906264/scatter.json")

Jsondata <- Jsondata %>% 
  mutate(states = state.abb[match(name,state.name)])

Jsondata[is.na(Jsondata)] = "D.C."


# Plotter deretter datasettet, bruker label funksjonen og 
# text funksjonen til ggrepel pakken som gir meg navnene på statene ovennfor.

ggplot(Jsondata, aes(x = fully_vaccinated_pct_of_pop, y = deaths_per_100k)) + 
  geom_point(colour = "palegreen3") + 
  geom_text(aes(label = states),hjust=0, vjust=-1.5, size = 3) +
  labs(title = "Andel av befolkning fullvaksinert","Antall døde per 100k") +
  ggtitle("20 måndelige døde i gjennomsnitt per 100k") + 
  scale_x_continuous(labels = scales::percent, limits=c(0.45, 0.80), breaks=seq(0.45, 0.80, by = 0.05)) + 
  theme_bw() + 
  xlab("Andel av befolkning fullvaksinert") + 
  ylab("Antall døde per 100k") +
  annotate("text", x=0.50, y=15, 
           label= "Lavere vaksinasjonsrate,\n høyere dødsrate") +
  annotate("segment", x = 0.49, 
           xend = 0.48, y = 15.5, 
           yend = 17, colour = "black", arrow = arrow())+
  annotate("text", x=0.75, y=9, 
           label= "Høyere vaksinasjonsrate,\n lavere dødsrate") +
  annotate("segment", x = 0.75, 
           xend = 0.78, y = 8, 
           yend = 6, colour = "black", arrow = arrow())



## Oppgave 2

# En linjær funksjon har likningen Y = a + bX, 
# hvor verdien av Y er den avhengige variabelen. 
# Der verdien av y når x = 0.

# Modellen sier oss at temperaturen er den avhengige variabelen (y), 
# som blir forklart av en fullvaksinert prosent av populasjonen. 
# Der 1 enhets endring i variabelen x gir β endring i variabelen y. 
# Ved å sette inn en (lm) funksjon som er linær funksjon, 
# får vi korrelasjonen mellom Dødsfall per 100k og Fullvaksinert prosentandel. 
# der den har en stigningstall på -36,66.

lm(deaths_per_100k ~ fully_vaccinated_pct_of_pop, data = Jsondata)

# Ved å plotte geom_smooth med funksjonen av "lm" ser vi tallene i en plot,
# vi ser at den linjære funksjonen "faller" og har en negativ sammenheng. 
ggplot(Jsondata, aes(x = fully_vaccinated_pct_of_pop, y = deaths_per_100k)) + 
  geom_point(colour = "palegreen3") + 
  geom_text(aes(label = states),hjust=0, vjust=0, size = 3) +
  geom_smooth(method = lm)+
  xlab("Andel av befolkning fullvaksinert") + 
  ylab("Antall døde per 100k") +
  ggtitle("20 måndelige døde i gjennomsnitt pr 100k") + 
  theme(plot.title = element_text(hjust = 0.5, size = 15)) +
  theme(axis.title.x = element_text(hjust = 0.5, size = 10)) +
  theme(axis.title.y = element_text(hjust = 0.5, size = 10)) +
  scale_x_continuous(labels = scales::percent, limits=c(0.45, 0.80), breaks=seq(0.45, 0.80, by = 0.05)) + 
  theme_bw() + 
  annotate("text", x=0.50, y=15, 
           label= "Lavere vaksinasjonsrate,\n høyere dødsrate") +
  annotate("segment", x = 0.49, 
           xend = 0.45, y = 15.5, 
           yend = 17, colour = "black", arrow = arrow())+
  annotate("text", x=0.75, y=9, 
           label= "Høyere vaksinasjonsrate,\n lavere dødsrate") +
  annotate("segment", x = 0.75, 
           xend = 0.78, y = 8, 
           yend = 6, colour = "black", arrow = arrow())


# Oppgave 2 uten 95% koffdiens linje

ggplot(Jsondata, aes(x = fully_vaccinated_pct_of_pop, y = deaths_per_100k)) + 
  geom_point(colour = "palegreen3") + 
  geom_text(aes(label = states),hjust=0, vjust=0, size = 3) +
  geom_smooth(method = "lm", se = FALSE)+
  xlab("Andel av befolkning fullvaksinert") + 
  ylab("Antall døde per 100k") +
  ggtitle("20 måndelige døde i gjennomsnitt pr 100k") + 
  theme(plot.title = element_text(hjust = 0.5, size = 15)) +
  theme(axis.title.x = element_text(hjust = 0.5, size = 10)) +
  theme(axis.title.y = element_text(hjust = 0.5, size = 10)) +
  scale_x_continuous(labels = scales::percent, limits=c(0.45, 0.80), breaks=seq(0.45, 0.80, by = 0.05)) + 
  theme_bw() + 
  annotate("text", x=0.50, y=15, 
           label= "Lavere vaksinasjonsrate,\n høyere dødsrate") +
  annotate("segment", x = 0.49, 
           xend = 0.45, y = 15.5, 
           yend = 17, colour = "black", arrow = arrow())+
  annotate("text", x=0.75, y=9, 
           label= "Høyere vaksinasjonsrate,\n lavere dødsrate") +
  annotate("segment", x = 0.75, 
           xend = 0.78, y = 8, 
           yend = 6, colour = "black", arrow = arrow())
