





# Rahmen - Teil 1

In diesem Skript geht es um die Praxis der Datenanalyse. Mit Rahmen ist das "Drumherum" der eigentlichen Datenanalyse gemeint. Dazu gehören einige praktische Vorbereitungen und ein paar Überlegungen. Zum Beispiel brauchen wir einen Überblick über das Thema. Voila:

<img src="images/Prozess.pdf" width="70%" style="display: block; margin: auto;" />


Datenanalyse, praktisch betrachtet, kann man in fünf Schritte einteilen [@r4ds]. Zuerst muss man die Daten *einlesen*, die Daten also in R (oder einer anderen Software) verfügbar machen (laden). Fügen wir hinzu: In *schöner Form* verfügbar machen; man nennt dies auch *tidy data*[^1]. Sobald die Daten in geeigneter Form in R geladen sind, folgt das *Aufbereiten*. Das beinhaltet Zusammenfassen, Umformen oder Anreichern je nach Bedarf. Ein nächster wesentlicher Schritt ist das *Visualisieren* der Daten. Ein Bild sagt bekanntlich mehr als viele Worte. Schließlich folgt das *Modellieren* oder das Hypothesen prüfen: Man überlegt sich, wie sich die Daten erklären lassen könnten. Zu beachten ist, dass diese drei Schritte - Aufbereiten, Visualisieren, Modellieren - keine starre Abfolge sind, sondern eher ein munteres Hin-und-Her-Springen, ein aufbauendes Abwechseln. Der letzte Schritt ist das *Kommunizieren* der Ergebnisse der Analyse - nicht der Daten. Niemand ist an Zahlenwüsten interessiert; es gilt, spannende Einblicke zu vermitteln.

Der Prozess der Datenanalyse vollzieht sich nicht im luftleeren Raum, sondern ist in einem *Rahmen* eingebettet. Dieser beinhaltet praktische Aspekte - wie Software, Datensätze - und grundsätzliche Überlegungen - wie Ziele und Grundannahmen. 




## Software


Als Haupt-Analysewerkzeug nutzen wir R; daneben wird uns die sog. "Entwicklungsumgebung" RStudio einiges an komfortabler Funktionalität bescheren. Eine Reihe von R-Paketen ("Packages"; d.h. Erweiterungen) werden wir auch nutzen. R ist eine recht alte Sprache; viele Neuerungen finden in Paketen Niederschlag, da der "harte Kern" von R lieber nicht so stark geändert wird. Stellen Sie sich vor: Seit 29 Jahren nutzen Sie eine Befehl, der Ihnen einen Mittelwert ausrechnet, sagen
wir die mittlere Anzahl von Tassen Kaffee am Tag. Und auf einmal wird der Mittelwert anders berechnet?! Eine Welt stürzt ein! Naja, vielleicht nicht ganz so tragisch in dem Beispiel, aber grundsätzlich sind Änderungen in viel benutzen Befehlen potenziell problematisch. Das ist wohl ein Grund, warum sich am "R-Kern" nicht so viel ändert. Die Innovationen in R passieren in den Paketen. Und es gibt viele davon; als ich diese Zeilen schreibe, sind es fast schon 10.000! Genauer: 9937 nach dieser Quelle: <https://cran.r-project.org/web/packages/>.


### R and Friends installieren


Setzt natürlich voraus, dass R installiert ist. Sie können R unter <https://cran.r-project.org> herunterladen und installieren (für Windows, Mac oder Linux). RStudio finden Sie auf der gleichnamigen Homepage: <https://www.rstudio.com>; laden Sie die "Desktop-Version" für Ihr Betriebssystem herunter.



### Hilfe! R tut nicht so wie ich das will

>    Manntje, Manntje, Timpe Te,  
     Buttje, Buttje inne See,  
     myne Fru de Ilsebill  
     will nich so, as ik wol will. 
     
*Gebrüder Grimm, Märchen vom Fischer und seiner Frau[^2]*
     
   


Ihr R startet nicht oder nicht richtig? Die drei wichtigsten Heilmittel sind:

  1. Schließen Sie die Augen für eine Minute. Denken Sie an etwas Schönes und was Rs Problem sein könnte.
  2. Schalten Sie den Rechner aus und probieren Sie es morgen noch einmal.
  3. Googeln.

Sorry für die schnottrigen Tipps. Aber: Es passiert allzu leicht, dass man Fehler wie diese macht:

- `install.packages(dplyr)`
- `install.packages("dliar")`
- `install.packages("derpyler")`
- `install.packages("dplyr")  # dependencies vergessen`
- Keine Internet-Verbindung
- `library(dplyr)  # ohne vorher zu installieren`


Wenn R oder RStudio dann immer noch nicht starten oder nicht richtig laufen, probieren Sie dieses:


- Sehen Sie eine Fehlermeldung, die von einem fehlenden Paket spricht (z.B. "Package 'Rcpp' not available") oder davon spricht, dass ein Paket nicht installiert werden konnte (z.B. "Package 'Rcpp' could not be installed" oder "es gibt kein Paket namens ‘Rcpp’" oder "unable to move temporary installation XXX to YYY"), dann tun Sie folgendes:

    - Schließen Sie R und starten Sie es neu.
    - Installieren Sie das oder die angesprochenen Pakete mit `install.packages("name_des_pakets", dependencies = TRUE)` oder mit dem entsprechenden Klick in RStudio.
    - Starten Sie das entsprechende Paket mit `library(paket_name)`.


- Gerade bei Windows 10 scheinen die Schreibrechte für R (und damit RStudio oder RComannder) eingeschränkt zu sein. Ohne Schreibrechte kann R aber nicht die Pakete ("packages") installieren, die Sie für bestimmte R-Funktionen benötigen. Daher schließen Sie R bzw. RStudio und suchen Sie das Icon von R oder wenn Sie RStudio verwenden von RStudio. Rechtsklicken Sie das Icon und wählen Sie "als Administrator ausführen". Damit geben Sie dem Programm Schreibrechte. Jetzt können Sie etwaige fehlende Pakete installieren.

- Ein weiterer Grund, warum R bzw. RStudio die Schreibrechte verwehrt werden könnnten (und damit die Installation von Paketen), ist ein Virenscanner. Der Virenscanner sagt, nicht ganz zu Unrecht: "Moment, einfach hier Software zu installieren, das geht nicht, zu gefährlich". Grundsätzlich gut, in diesem Fall unnötig. Schließen Sie R/RStudio und schalten Sie dann den Virenscanner *komplett* (!) aus. Öffnen Sie dann R/RStudio wieder und versuchen Sie fehlende Pakete zu installieren.

- Läuft der RCommander unter Mac nicht, dann prüfen Sie, ob Sie X11 (synonym: XQuartz) installiert haben. X11 muss installiert sein, damit der RCommander unter Mac läuft.

- Die "app nap" Funktion beim Mac kann den RCommander empfindlich ausbremsen. Schalten Sie diese Funktion aus z.B. im RCommander über `Tools - Manage Mac OS X app nap for R.app`.



### Die Denk- und Gefühlswelt von R

- Wenn Sie RStudio starten, startet R automatisch auch. Starten Sie daher, wenn Sie RStudio gestartet haben, *nicht* noch extra R. Damit hätten Sie sonst zwei Instanzen von R laufen, was zu Verwirrungen (bei R und beim Nutzer) führen kann.

- Ein neues R-Skript im RStudio können Sie z.B. öffnen mit `File-New File-R Script`.

- R-Skripte können Sie speichern (`File-Save`) und öffnen.

- R-Skripte sind einfache Textdateien, die jeder Texteditor verarbeiten kann. Nur statt der Endung `txt`, sind R-Skripte stolzer Träger der Endung `R`. Es bleibt aber eine schnöde Textdatei.

- Bei der Installation von Paketen mit `install.packages("name_des_pakets")` sollte stets der Parameter `dependencies = TRUE` angefügt werden. Also  `install.packages("name_des_pakets", dependencies = TRUE)`. Hintergrund ist: Falls das zu installierende Paket seinerseits Pakete benötigt, die noch nicht installiert sind (gut möglich), dann werden diese sog. "dependencies" gleich mitinstalliert (wenn Sie  `dependencies = TRUE` setzen).

- Hier finden Sie weitere Hinweise zur Installation des RCommanders: <http://socserv.socsci.mcmaster.ca/jfox/Misc/Rcmdr/installation-notes.html>.

- Sie müssen online sein, um Packages zu installieren.

- Die "app nap" Funktion beim Mac kann den RCommander empfindlich ausbremsen. Schalten Sie diese Funktion aus z.B. im RCommander über `Tools - Manage Mac OS X app nap for R.app`.


Verwenden Sie möglichst die neueste Version von R, RStudio und Ihres Betriebssystems. Ältere Versionen führen u.U. zu Problemen; je älter, desto Problem... Updaten Sie Ihre Packages regelmäßig z.B. mit `update.packages()` oder dem Button "Update" bei RStudio (Reiter `Packages`).

R zu lernen kann hart sein. Ich weiß, wovon ich spreche. Wahrscheinlich eine spirituelle Prüfung in Geduld und Hartnäckigkeit... Tolle Gelegenheit, sich in diesen Tugenden zu trainieren :-)




### Pakete installieren - Beispiel `dplyr`

Ein R-Paket, welches für die praktische Datenanalyse praktisch ist, heißt `dplyr`. Wir werden viel mit diesem Paket arbeiten. Bitte installieren Sie es schon einmal, sofern noch nicht geschehen:


```r
install.packages("dplyr", dependencies = TRUE)
```

Übrigens, das `dependencies = TRUE` sagt sinngemäß "Wenn das Funktionieren von dplyr noch von anderen Paketen abhängig ist (es also Abhängigkeiten (dependencies) gibt), dann installiere die gleich mal mit".



\BeginKnitrBlock{rmdcaution}<div class="rmdcaution">Beim Installieren von R-Paketen könnten Sie gefragt werden, welchen "Mirror" Sie verwenden möchten. Das hat folgenden Hintergrund: R-Pakete sind in einer Art "App-Store", mit Namen CRAN (Comprehense R Archive Network) gespeichert. Damit nicht ein armer, kleiner Server überlastet wird, wenn alle Studis dieser Welt just gerade beschließen, ein Paket herunterzuladen, gibt es viele Kopien dieses Servers - die "Mirrors", Spiegelbilder. Suchen Sie sich einfach einen aus, der in der Nähe ist.
</div>\EndKnitrBlock{rmdcaution}


Nicht vergessen: Installieren muss man eine Software *nur einmal*; *starten* (laden) muss man sie jedes Mal, wenn man sie vorher geschlossen hat und wieder nutzen möchte:


```r
library(dplyr)
```

Der Befehl bedeutet sinngemäß: "Hey R, geh in die Bücherei (library) und hole das Buch (package) dplyr!".


\BeginKnitrBlock{rmdcaution}<div class="rmdcaution">Wann benutzt man bei R Anführungszeichen? Das ist etwas verwirrend im Detail, aber die Grundegel lautet: wenn man Text anspricht. Im Beispiel oben "library(dplyr)" ist "dplyr" hier erst mal für R nichts Bekanntes, weil noch nicht geladen. Demnach müssten *eigentlich* Anführungsstriche stehen. Allerdings meinte ein Programmierer, dass es doch so bequemer ist. Hat er Recht. Aber bedenken Sie, dass es sich um die Ausnahme einer Regel handelt. Sie können also auch schreiben: library("dplyr") oder library('dplyr'); geht beides.
</div>\EndKnitrBlock{rmdcaution}



Das Installieren und Starten anderer Pakete läuft genauso ab.



### R-Pakete für dieses Buch
In diesem Buch verwenden wir die folgenden R-Pakete; diese müssen installiert sein und geladen:





```r
Pakete
#>  [1] "tidyverse"    "readr"        "knitr"        "stringr"     
#>  [5] "car"          "nycflights13" "ISLR"         "pdftools"    
#>  [9] "downloader"   "ggdendro"     "gridExtra"    "tm"          
#> [13] "tidytext"     "lsa"          "SnowballC"    "wordcloud"   
#> [17] "RColorBrewer" "okcupiddata"  "reshape2"     "wesanderson" 
#> [21] "GGally"       "titanic"      "compute.es"
```

Anstelle alle einzeln zu laden (`library` verdaut nur ein Paket auf einmal), können wir mit etwas R-Judo alle auf einen Haps laden:


```r
lapply(Pakete, require, character.only = TRUE)
#> [[1]]
#> [1] TRUE
#> 
#> [[2]]
#> [1] TRUE
#> 
#> [[3]]
#> [1] TRUE
#> 
#> [[4]]
#> [1] TRUE
#> 
#> [[5]]
#> [1] TRUE
#> 
#> [[6]]
#> [1] TRUE
#> 
#> [[7]]
#> [1] TRUE
#> 
#> [[8]]
#> [1] TRUE
#> 
#> [[9]]
#> [1] TRUE
#> 
#> [[10]]
#> [1] TRUE
#> 
#> [[11]]
#> [1] TRUE
#> 
#> [[12]]
#> [1] TRUE
#> 
#> [[13]]
#> [1] TRUE
#> 
#> [[14]]
#> [1] TRUE
#> 
#> [[15]]
#> [1] TRUE
#> 
#> [[16]]
#> [1] TRUE
#> 
#> [[17]]
#> [1] TRUE
#> 
#> [[18]]
#> [1] TRUE
#> 
#> [[19]]
#> [1] TRUE
#> 
#> [[20]]
#> [1] TRUE
#> 
#> [[21]]
#> [1] TRUE
#> 
#> [[22]]
#> [1] TRUE
#> 
#> [[23]]
#> [1] TRUE
```

Der Befehl heißt auf Deutsch: "Wende auf jedes Element von `Pakete` den Befehl `library` an"[^3].



### Datensätze

Name des Datensatzes  Quelle            Beschreibung  
--------------------  -----------       -----------------
`profiles`            {okcupiddata}     Daten von einer Online-Singlebörse  
`Wage`                {ISLR}            Gehaltsdaten von US-amerikanischen Männern  
`inf_test_short`      Hier[^10]         Ergebnisse einer Statistikklausur 
`flights`             {nycflights13}    Abflüge von den New Yorker Flughäfen
`wo_men`              Hier[^11]         Größe von Studierenden
`tips`                {reshape2}        Trinkgelder in einem Restaurant
`extra`               Hier[^12]         Umfrage zu Extraversion






## Was ist Statistik? Wozu ist sie gut?

Zwei Fragen bieten sich sich am Anfang der Beschäftigung mit jedem Thema an: Was ist die Essenz des Themas? Warum ist das Thema (oder die Beschäftigung damit) wichtig?

Was ist Stististik? *Eine* Antwort dazu ist, dass Statistik die Wissenschaft von Sammlung, Analyse, Interpretation und Kommunikation mithilfe mathematischer Verfahren ist und zur Entscheidungshilfe beitragen solle [@oxford; @sep-statistics]. Damit hätten wir auch den Unterschied zur schnöden Datenanalyse (ein Teil der Statistik) herausgemeiselt. Statistik wird häufig in die zwei Gebiete *deskriptive* und *inferierende* Statistik eingeteilt. Erstere fasst viele Zahlen zusammen, so dass wir den Wald statt vieler Bäume sehen. Letztere verallgemeinert von den vorliegenden (sog. "Stichproben-")Daten auf eine zugrunde liegende Grundmenge (Population). Dabei spielt die Wahrscheinlichkeitsrechnung und Zufallsvariablen eine große Rolle.

Auch wenn die gerade genannte Diskussion die häufigste oder eine typische ist, mehren sich doch Stimmen, die Statstik anders akzentuieren. So schreibt Briggs in einem aktuellen Buch [@uncertainty], dass es in der Statistik darum ginge, die Wahrscheinlichkeit zukünftiger Ereignisse vorherzusagen: "Wie wahrscheinlichi ist es, dass - gegeben einem statistischen Modell, allerlei Annahmen und einem Haufen Daten - Kandidat X der neue Präsident wird"[^9]? Das schöne an dieser Idee ist, dass das "Endprodukt" etwas sehr Weltliches und damit praktisches ist: Die Wahrscheinlichkeit einer interessanten (und unbekannten) Aussage. Nebenbei ruht diese Idee auf dem sicheren Fundament der Wahrscheinlichkeitstheorie.



Abgesehen von philosophischen Überlegungen zum Wesen der Statistik kann man sagen, dass Vorhersagen von Ereignissen etwas sehr praktisches sind. Sie nehmen daher aus praktischen Überlegungen einen zentralen Platz in diesem Buch an. Die philosophische Relevanz des prädiktiven Ansatzes ist gut bei Briggs [@uncertainty; @breaking] nachzulesen.

Traditionell ist die Statistik stark daran interessiert, Parameter von Populationen vorherzusagen. Ein Beispiel dazu wäre die mittlere Größe (Parameter) aller Deutschen (Population). Leider sind Populationen häufig ziemlich abstrakt. Nehmen wir als Beispiel an, ein Dozent der FOM (Prof. S.) wie sich der Lernerfolg ändert, wenn die Stoffmenge pro Stunde verdoppelt. Zu seiner Überraschung ist der Lernerfolg geringer als in einem Kontrollkurs. Auf welche Population ist jetzt die Studie bzw. die Daten seiner Stichprobe zu verallgemeinern? Alle Menschen? Alle Studierenden? Alle deutschen Studierenden? Alle Studierenden der FOM? Alle Studierenden aller Zeiten?

- Statistik meint Methoden, die das Ziel haben, Ereignisse präzise vorherzusagen
- Statistik soll sich um Dinge dieser Welt drehen, nicht um Parameter
- Statt einer Frage "ist µ_1 größer als µ_2?" besser "Wie viel Umsatz erwarte ich von diesem Kunden?", "Wie viele Saitensprünge hatte er wohl?", "Wie groß ist die Wahrscheinlichkeit für sie zu überleben?" und dergleichen.
- Der Nutzen von Vorhersagen liegt auf der Hand: Vorhersagen sind praktisch; eine nützliche Angelegenheit (wenn auch schwierig).




[^1]: hört sich cooler an.
[^2]: <https://de.wikipedia.org/wiki/Vom_Fischer_und_seiner_Frau>
[^3]: http://stackoverflow.com/questions/8175912/load-multiple-packages-at-once 

[^9]: Eine Vorhersage, die bei vielen Vorhersagemodellen komplett in die Grütze ging, wenn man sich die US-Präsidentenwahl 2016 anschaut.
[^10]: https://sebastiansauer.github.io/data/test_inf_short.csv
[^11]: https://sebastiansauer.github.io/data/wo_men.csv 
[^12]: https://osf.io/meyhp/?action=download


