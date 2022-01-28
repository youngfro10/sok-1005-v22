# Oppgave 1

# For å få tilgang til nettsiden må du registrere deg hos NYT, dette er gratis. 
# Om du ikke ønsker det, kan du finne html fila i Canvas/Filer.
# Når nettsiden er lastet i en browser, kan du se på html koden ved å høyreklikke på musen. 
# Velg vis sidekilde/source.

#Finn JSON lenken med JSON dataene som figuren leser data fra.
#Benytt en pakke i R som leser JSON, og last ned dataene fra lenken.
#Lag deretter et ggplot som repliserer figuren over.




#Oppgave 2

# Det er en klar negativ sammenheng mellom antall døde per 100 000 (y-aksen) 
# og andel av befolkningen som er vaksinert (x-aksen).

#Benytt R sin lm() funksjon. Angi variabelen på y aksen og x aksen
#og spesifiser datasettet.
#lm(<navn på y-variabel> ~ <navn på x-variabel>, data = <navn på datasettet>)
#Etter å ha “kjørt” koden, hvordan tolker du de to verdiene på den tilpassa linja?
#Legg den tilpassede linja til ggplot ved å bruke  + geom_smooth(method = lm).
