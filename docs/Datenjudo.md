





# Daten explorieren

Den Ablauf des Datenexplorierens kann man so darstellen:

<img src="./images/Datenjudo_Prozess.pdf" width="70%" style="display: block; margin: auto;" />


Zuerst müssen die Daten für die Analyse(software) verfügbar gemacht werden. Sprich, die Daten müssen *eingelesen* werden. Dann beginnt das eigentliche Explorieren; dieses kann man wiederum in drei Schritte einteilen, die keine Abfolge sind, sondern sich wild abwechseln können. Diese sind: Daten *aufbereiten*, Daten *zusammenfassen* und Daten *visualisieren*.

Unter Daten aufbereiten im engeren Sinne ist gemeint, die Daten einer "Grundreinigung" zu unterziehen, dass sie für weitere Analysen in geeigneter Form sind. Daten zusammenfassen meint die deskriptive Statistik; Daten visualisieren ist das Erstellen von Diagrammen. Im Anschluss kann man die Daten modellieren.

Ist das Explorieren von Daten auch nicht statistisch anspruchsvoll, so ist es trotzdem von großer Bedeutung und häufig recht zeitintensiv, vor allem das Daten aufbereiten. Eine Anekdote zur Relevanz der Exploration, die (so will es die Geschichte) mir an einer Bar nach einer einschlägigen Konferenz erzählt wurde (daher keine Quellenangebe, Sie verstehen...). Eine Computerwissenschaftlerin aus den USA (deutschen Ursprungs) hatte einen beeindruckenden "Track Record" an Siegen in Wettkämpfen der Datenanalyse. Tatsächlich hatte sie keine besonderen, raffinierten Modellierungstechniken eingesetzt; klassische Regression war ihre Methode der Wahl. Bei einem Wettkampf, bei dem es darum ging, Krebsfälle aus Krankendaten vorherzusagen (z.B. Röntgenbildern) fand sie nach langem Datenjudo heraus, dass in die "ID-Variablen" Information gesickert war, die dort nicht hingehörte und die sie nutzen konnte für überraschend (aus Sicht der Mitstreiter) gute Vorhersagen zu Krebsfällen. Wie war das möglich? Die Daten stammten aus mehreren Kliniken, jede Klinik verwendete ein anderes System, um IDs für Patienten zu erstellen. Überall waren die IDs stark genug, um die Anonymität der Patienten sicherzustellen, aber gleich wohl konnte man (nach einigem Judo) unterscheiden, welche ID von welcher Klinik stammte. Was das bringt? Einige Kliniken waren reine Screening-Zentren, die die Normalbevölkerung versorgte. Dort sind wenig Krebsfälle zu erwarten. Andere Kliniken jedoch waren Onkologie-Zentren für bereits bekannte Patienten oder für Patienten mit besonderer Risikolage. Wenig überraschen, dass man dann höhere Krebsraten vorhersagen kann. Eigentlich ganz einfach; besondere Mathe steht hier (zumindest in dieser Geschichte) nicht dahinter. Und, wenn man den Trick kennt, ganz einfach. Aber wie so oft ist es nicht leicht, den Trick zu finden. Sorgfältiges Datenjudo hat hier den Schlüssel zum Erfolg gebracht.


## Daten einlesen

In R kann man ohne Weiteres verschiedene, gebräuchliche (Excel) oder weniger gebräuchliche (Feather) Datenformate einlesen. In RStudio lässt sich dies z.B. durch einen schnellen Klick auf `Import Dataset` im Reiter `Environment` erledigen. Dabei wird im Hintergrund das Paket `readr` verwendet [@readr] (die entsprechende Syntax wird in der Konsole ausgegeben, so dass man sie sich anschauen und weiterverwenden kann).

Es ist für bestimmte Zwecke sinnvoll, nicht zu klicken, sondern die Syntax einzutippen. Zum Beispiel: Wenn Sie die komplette Analyse als Syntax in einer Datei haben (eine sog. "Skriptdatei"), dann brauchen Sie (in RStudio) nur alles auszuwählen und auf `Run` zu klicken, und die komplette Analyse läuft durch! Die Erfahrung zeigt, dass das ein praktisches Vorgehen ist.

Die gebräuchlichste Form von Daten für statistische Analysen ist wahrscheinlich das CSV-Format. Das ist ein einfahes Format, basierend auf einer Textdatei. Schauen Sie sich mal diesen Auszug aus einer CSV-Datei an.

```
"ID","time","sex","height","shoe_size"
"1","04.10.2016 17:58:51",NA,160.1,40
"2","04.10.2016 17:58:59","woman",171.2,39
"3","04.10.2016 18:00:15","woman",174.2,39
"4","04.10.2016 18:01:17","woman",176.4,40
"5","04.10.2016 18:01:22","man",195.2,46
```

Erkenenn Sie das Muster? Die erste Zeile gibt die "Spaltenköpfe" wieder, also die Namen der Variablen. Hier sind es 5 Spalten; die vierte heißt "shoe_size". Die Spalten sind offenbar durch Komma `,` voneinander getrennt. Dezimalstellen sind in amerikanischer Manier mit einem Punkt `.` dargestellt. Die Daten sind "rechteckig"; alle Spalten haben gleich viele Zeilen und umgekehrt alle Spalten gleich viele Zeilen. Man kann sich diese Tabelle gut als Excel-Tabelle mit Zellen vorstellen, in denen z.B. "ID" (Zelle oben links) oder "46" (Zelle unten rechts) steht.

An einer Stelle steht `NA`. Das ist Errisch für "fehlender Wert". Häufig wird die Zelle auch leer gelassen, um auszudrücken, dass ein Wert hier fehlt (hört sich nicht ganz doof an). Aber man findet alle möglichen Ideen, um fehlende Werte darzustellen. Ich rate von allen anderen ab; führt nur zu Verwirrung.

Lesen wir diese Daten jetzt ein:

```r
daten <- read.csv("https://sebastiansauer.github.io/data/wo_men.csv")
head(daten)
#>                  time   sex height shoe_size
#> 1 04.10.2016 17:58:51 woman    160        40
#> 2 04.10.2016 17:58:59 woman    171        39
#> 3 04.10.2016 18:00:15 woman    174        39
#> 4 04.10.2016 18:01:17 woman    176        40
#> 5 04.10.2016 18:01:22   man    195        46
#> 6 04.10.2016 18:01:53 woman    157        37
```

Der Befehl `read.csv` liest eine CSV-Datei, was uns jetzt nicht übermäßig überrascht. Aber Achtung: Wenn Sie aus einem Excel mit deutscher Einstellung eine CSV-Datei exportieren, wird diese CSV-Datei als Trennzeichen `;` (Strichpunkt) und als Dezimaltrennzeichen `,` verwenden. Da der Befehl `read.csv` als Standard mit Komma und Punkt arbeitet, müssen wir die deutschen Sonderlocken explizit angeben, z.B. so:


```r
# daten_deutsch <- read.csv("daten_deutsch.csv", sep = ";", dec = ".")
```

Dabei steht `sep` (separator) für das Trennzeichen zwischen den Spalten und `dec` für das Dezimaltrennzeichen.

Übrigens: Wenn Sie keinen Pfad angeben, so geht R davon aus, dass die Daten im aktuellen Verzeichnis liegen. Das aktuelle Verzeichnis kann man mit `getwd()` erfragen und mit `setwd()` einstellen. Komfortabler ist es aber, das aktuelle Verzeichnis per Menü zu ändern. In RStudio: `Session > Set Working Directory > Choose Directory ...` (oder per Shortcut, der dort angezeigt wird).

## Datenjudo (Daten aufbereiten)

Bevor man seine Statistik-Trickkiste so richtig schön aufmachen kann, muss man die Daten häufig erst noch in Form bringen. Das ist nicht schwierig in dem Sinne, dass es um komplizierte Mathe ginge. Allerdings braucht es mitunter recht viel Zeit und ein paar (oder viele) handwerkliche Tricks sind hilfreich. Hier soll das folgende Kapitel helfen.

Mit "Datenjudo" (ein Fachbegriff aus der östlichen Zahlentheorie) ist gemeint, die Daten so "umzuformen", "aufzubereiten", oder "reinigen" , dass sie passend für statistische Analysen sind. 

Typische Probleme, die immer wieder auftreten sind:

- Fehlende Werte: Irgend jemand hat auf eine meiner schönen Fragen in der Umfrage nicht geantwortet!
- Unerwartete Daten: Auf die Frage, wie viele Facebook-Freunde er oder sie habe, schrieb die Person "I like you a lot". Was tun???
- Daten müssen umgeformt werden: Für jede der beiden Gruppen seiner Studie hat Joachim einen Google-Forms-Fragebogen aufgesetzt. Jetzt hat er zwei Tabellen, die er "verheiraten" möchte. Geht das?
- Neue Spalten berechnen: Ein Student fragt nach der Anzahl der richtigen Aufgaben in der Statistik-Probeklausur. Wir wollen helfen und im entsprechenden Datensatz eine Spalte erzeugen, in der pro Person die Anzahl der richtig beantworteten Fragen steht.


### Überblick


### Normalform einer Tabelle
Tabellen in R werden als `data frames` (oder moderner: als `tibble`, kurz für "Table-df") bezeichnet. Tabellen sollten in "Normalform" vorliegen, bevor wir weitere Analysen starten. Unter Normalform verstehen sich folgende Punkte:

- Es handelt sich um einen data frame, also Spalten mit Namen und gleicher Länge; eine Datentabelle in rechteckiger Form
- In jeder Zeile steht eine Beobachtung, in jeder Spalte eine Variable
- Fehlende Werte sollten sich in *leeren* Tabellen niederschlagen
- Daten sollten nicht mit Farkbmarkierungen o.ä. kodiert werden
- keine Leerzeilen, keine Leerspalten
- am besten keine Sonderzeichen verwenden und keine Leerzeichen in Variablennamen und -werten, am besten nur Ziffern und Buchstaben und Unterstriche
- Variablennamen dürfen nicht mit einer Zahl beginnen


Der Punkt "Jede Zeile eine Beobachtung, jede Spalte eine Variable" verdient besondere Beachtung. Betrachen Sie dieses Beispiel:


```r
knitr::include_graphics("./images/breit_lang.pdf")
```

<img src="./images/breit_lang.pdf" width="70%" style="display: block; margin: auto;" />


In der rechten Tabelle sind die Variablen `Quartal` und `Umsatz` klar getrennt; jede hat ihre eigene Spalte. In der linken Tabelle hingegen sind die beiden Variablen vermischt. Sie haben nicht mehr ihre eigene Spalte, sondern sind über vier Spalten verteilt. Die rechte Tabelle ist ein Beispiel für eine Tabelle in Normalform, die linke nicht.

Eine der ersten Aktionen einer Datenanalyse sollte also die "Normalisierung" Ihrer Tabelle sein. In R bietet sich dazu das Paket `tidyr` an, mit dem die Tabelle von Breit- auf Langformat (und wieder zurück) geschoben werden kann.

Ein Beispiel dazu:


```r
meindf <- read.csv("http://stanford.edu/~ejdemyr/r-tutorials/data/unicef-u5mr.csv")

df_lang <- gather(meindf, year, u5mr, U5MR.1950:U5MR.2015)

df_lang <- separate(df_lang, year, into = c("U5MR", "year"), sep = ".")
```

- Die erste Zeile liest die Daten aus einer CSV-Datei ein; praktischerweise direkt von einer Webseite.   
- Die zweite Zeile formt die Daten von breit nach lang um. Die neuen Spalten, nach der Umformung heißen dann `year` und `u5mr` (Sterblichkeit bei Kindern unter fünf Jahren). In die Umformung werden die Spalten `U5MR 1950` bis `U5MR 2015` einbezogen.
- Die dritte Zeile "entzerrt" die Werte der Spalte `year`; hier stehen die ehemaligen Spaltenköpfe. Man nennt sie auch `key` Spalte daher. Steht in einer Zelle von `year` bspw. `U5MR 1950`, so wird `U5MR` in eine Spalte mit Namen `U5MR` und `1950` in eine Spalte mit Namen `year` geschrieben.

Im Cheatsheet von RStudio zum Thema Datenimport finden sich nützliche Hinweise [^3].
[^3]: https://www.rstudio.com/resources/cheatsheets/




### Daten aufbereiten mit `dplyr`

Es gibt viele Möglichkeiten, Daten mit R aufzubereiten; `dplyr` ist ein populäres Paket dafür. Die Philosophie dabei ist, dass es ein paar wenige Grundbausteine geben sollte, die sich gut kombinieren lassen. Sprich: Wenige grundlegende Funktionen mit eng umgrenzter Funktionalität. Der Autor, Hadley Wickham, sprach einmal in einem Forum (citation needed), dass diese Befehle wenig können, das Wenige aber gut. Ein Nachteil dieser Konzeption kann sein, dass man recht viele dieser Bausteine kombinieren muss, um zum gewünschten Ergebnis zu kommen. Außerdem muss man die Logik des Baukastens gut verstanden habe - die Lernkurve ist also erstmal steiler. Dafür ist man dann nicht darauf angewiesen, dass es irgendwo "Mrs Right" gibt, die genau das kann, so wie ich das will. Außerdem braucht man sich auch nicht viele Funktionen merken. Es reicht einen kleinen Satz an Funktionen zu kennen (die praktischerweise konsistent in Syntax und Methodik sind). 

`dplyr` hat seinen Namen, weil es sich ausschließlich um *D*ataframes bemüht; es erwartet einen Dataframe als Eingabe und gibt einen Dataframe zurück[^1].

[^1]: zumindest bei den meisten Befehlen.

Diese Bausteine sind typische Tätigkeiten im Umgang mit Daten; nichts Überraschendes. Schauen wir uns diese Bausteine näher an.


```r
library(dplyr)  # muss installiert sein
```


#### Zeilen filtern mit `filter`

Häufig will man bestimmte Zeilen aus einer Tabelle filtern. Zum Beispiel man arbeitet für die Zigarettenindustrie und ist nur an den Rauchern interessiert (die im Übrigen unser Gesundheitssystem retten [@kraemer2011wir]), nicht an Nicht-Rauchern; es sollen die nur Umsatzzahlen des letzten Quartals untersucht werden, nicht die vorherigen Quartale; es sollen nur die Daten aus Labor X (nicht Labor Y) ausgewertet werden etc.

Ein Sinnbild:

<img src="./images/filter.pdf" width="70%" style="display: block; margin: auto;" />

Merke:
>    Die Funktion `filter` filtert Zeilen aus einem Dataframe.

Schauen wir uns einige Beispiel an; zuerst die Daten laden nicht vergessen. Achtung: "Wohnen" die Daten in einem Paket, muss dieses Paket installiert sein, damit man auf die Daten zugreifen kann.


```r
data(profiles, package = "okcupiddata")  # Das Paket muss installiert sein
```



```r
df_frauen <- filter(profiles, sex == "f")  # nur die Frauen
df_alt <- filter(profiles, age > 70)  # nur die alten
df_alte_frauen <- filter(profiles, age > 70, sex == "f")  # nur die alten Frauen, d.h. UND-Verknüpfung
df_nosmoke_nodrinks <- filter(profiles, smokes == "no" | drinks == "not at all") 
# liefert alle Personen, die Nicht-Raucher *oder* Nicht-Trinker sind
```

Gar nicht so schwer, oder? Allgemeiner gesprochen werden diejenigen Zeilen gefiltert (also behalten bzw. zurückgeliefert), für die das Filterkriterium `TRUE` ist. 



\BeginKnitrBlock{rmdcaution}<div class="rmdcaution">Manche Befehle wie `filter` haben einen Allerweltsnamen; gut möglich, dass ein Befehl mit gleichem Namen in einem anderen (geladenen) Paket existiert. Das kann dann zu Verwirrungen führen - und kryptischen Fehlern. Im Zweifel den Namen des richtigen Pakets ergänzen, und zwar zum Beispiel so: `dplyr::filter(...)`.
</div>\EndKnitrBlock{rmdcaution}

Einige fortgeschrittene Beispiele für `filter`:

Man kann alle Elemente (Zeilen) filtern, die zu einer Menge gehören und zwar mit diesem Operator: `%in%`:


```r
filter(profiles, body_type %in% c("a little extra", "average"))
```

Besonders Textdaten laden zu einigen Extra-Überlegungen ein; sagen wir, wir wollen alle Personen filtern, die Katzen bei den Haustieren erwähnen. Es soll reichen, wenn `cat` ein Teil des Textes ist; also `likes dogs and likes cats` wäre OK (soll gefiltert werden). Dazu nutzen wir ein Paket zur Bearbeitung von Strings (Textdaten):


```r
library(stringr)  # muss installiert sein
filter(profiles, str_detect(pets, "cats"))
```


Ein häufiger Fall ist, Zeilen *ohne* fehlende Werte (`NA`s) zu filtern. Das geht einfach:


```r
profiles_keine_nas <- na.omit(profiles)

```

Aber was ist, wenn wir nur bei bestimmten Spalten wegen fehlender Werte besorgt sind? Sagen wir bei `income` und bei `sex`:


```r
filter(profiles, !is.na(income) | !is.na(sex))
```


#### Spalten wählen mit `select`

Das Gegenstück zu `filter` ist `select`; dieser Befehl liefert die gewählten Spalten zurück. Das ist häufig praktisch, wenn der Datensatz sehr "breit" ist, also viele Spalten enthält. Dann kann es übersichtlicher sein, sich nur die relevanten auszuwählen. Das Sinnbild für diesen Befehl:

<img src="./images/select.pdf" width="70%" style="display: block; margin: auto;" />


Merke:

>    Die Funktion select wählt Spalten aus einem Dataframe aus.


```r
if (!file.exists("./data/test_inf_short.csv")) {
  stats_test <- read.csv("https://sebastiansauer.github.io/data/test_inf_short.csv") 
} else {
  stats_test <- read.csv("./data/test_inf_short.csv")
}
```

Hier haben wir erst geprüft, ob die Datei `test_inf_short.csv` existiert; falls nein, laden wir sie herunter. Andernfalls lesen wir sie aus dem lokalen Verzeichnis.


```r
select(stats_test, score)  # Spalte `score` auswählen
select(stats_test, score, study_time)  # Splaten `score` und `study_time` auswählen
select(stats_test, score:study_time) # dito
select(stats_test, 5:6) Spalten 5 bis 6 auswählen
```

Tatsächlich ist der Befehl `select` sehr flexibel; es gibt viele Möglichkeiten, Spalten auszuwählen. Im `dplyr`-Cheatsheet findet sich ein guter Überblick dazu[^2].

[^2]: <https://www.rstudio.com/resources/cheatsheets/>


#### Zeilen sortieren mit `arrange`

Man kann zwei Arten des Umgangs mit R unterscheiden: Zum einen der "interaktive Gebrauch" und zum anderen "richtiges Programmieren". Im interaktiven Gebrauch geht es uns darum, die Fragen zum aktuell vorliegenden Datensatz (schnell) zu beantworten. Es geht nicht darum, eine allgemeine Lösung zu entwickeln, die wir in die Welt verschicken können und die dort ein bestimmtes Problem löst, ohne dass der Entwickler (wir) dabei Hilfestellung geben muss. "Richtige" Software, wie ein R-Paket oder Microsoft Powerpoint, muss diese Erwartung erfüllen; "richtiges Programmieren" ist dazu vonnöten. Natürlich sind in diesem Fall die Ansprüche an die Syntax (der "Code", hört sich cooler an) viel höher. In dem Fall muss man alle Eventualitäten voraussehen und sicherstellen, dass das Programm auch beim merkwürdigsten Nutzer brav seinen Dienst tut. Wir haben hier, beim interaktiven Gebrauch, niedrigere Ansprüche bzw. andere Ziele. 

Beim interaktiven Gebrauch von R (oder beliebigen Analyseprogrammen) ist das Sortieren von Zeilen eine recht häufige Tätigkeit. Typisches Beispiel wäre der Lehrer, der eine Tabelle mit Noten hat und wissen will, welche Schüler die schlechtesten oder die besten sind in einem bestimmten Fach. Oder bei der Prüfung der Umsätze nach Filialen möchten wir die umsatzstärksten sowie -schwächsten Niederlassungen kennen. 

Ein R-Befehl hierzu ist `arrange`; einige Beispiele zeigen die Funktionsweise am besten:


```r
arrange(stats_test, score)  # liefert die *schlechtesten* Noten zurück
#>       X                 V_1 study_time self_eval interest score
#> 1   234 23.01.2017 18:13:15          3         1        1    17
#> 2     4 06.01.2017 09:58:05          2         3        2    18
#> 3   131 19.01.2017 18:03:45          2         3        4    18
#> 4   142 19.01.2017 19:02:12          3         4        1    18
#> 5    35 12.01.2017 19:04:43          1         2        3    19
#> 6    71 15.01.2017 15:03:29          3         3        3    20
#> 7    97 17.01.2017 21:51:05          3         3        5    20
#> 8   206 22.01.2017 18:42:49         NA        NA       NA    20
#> 9   235 23.01.2017 18:26:20         NA        NA       NA    20
#> 10  300 27.01.2017 02:14:27          2         3        2    20
#> 11   33 12.01.2017 18:53:43          1         3        2    21
#> 12  102 18.01.2017 12:48:04          3         3        3    21
#> 13  129 19.01.2017 17:58:02          2         4        3    21
#> 14  186 21.01.2017 16:24:44          2         5        3    21
#> 15  216 23.01.2017 07:54:17          4         2        5    21
#> 16  223 23.01.2017 12:53:02          3         1        3    21
#> 17   13 09.01.2017 09:51:37          1         2        2    22
#> 18   19 10.01.2017 17:16:48         NA        NA       NA    22
#> 19   36 12.01.2017 19:09:14          1         7        3    22
#> 20   55 14.01.2017 15:15:38          3         4        5    22
#> 21   65 15.01.2017 12:41:27          3         6        6    22
#> 22  220 23.01.2017 11:27:11          3         5        3    22
#> 23  266 25.01.2017 15:39:13          2         4        4    22
#> 24  269 25.01.2017 16:31:46          3         3        3    22
#> 25   31 12.01.2017 14:09:10          4         8        5    23
#> 26   45 13.01.2017 16:57:26          1         2        3    23
#> 27   72 15.01.2017 15:30:15          4         4        4    23
#> 28   86 16.01.2017 15:31:38          2         4        2    23
#> 29  167 20.01.2017 19:17:44          4         5        4    23
#> 30  195 22.01.2017 13:24:51         NA        NA       NA    23
#> 31  221 23.01.2017 11:40:30          1         1        1    23
#> 32  230 23.01.2017 16:27:49          1         1        1    23
#> 33  283 26.01.2017 10:39:44         NA        NA       NA    23
#> 34    8 06.01.2017 17:24:53          2         5        3    24
#> 35   16 09.01.2017 15:52:12          2         5        3    24
#> 36   28 11.01.2017 22:44:23          2         6        2    24
#> 37   30 12.01.2017 13:36:07          3         5        2    24
#> 38   37 12.01.2017 19:20:25          3         3        4    24
#> 39   67 15.01.2017 13:30:48         NA        NA       NA    24
#> 40   92 17.01.2017 17:18:55          1         1        1    24
#> 41  107 18.01.2017 16:01:36          3         2        1    24
#> 42  130 19.01.2017 17:58:35          3         1        4    24
#> 43  217 23.01.2017 11:18:51          2         6        3    24
#> 44  232 23.01.2017 16:50:14          3         2        4    24
#> 45  246 24.01.2017 15:09:44         NA        NA       NA    24
#> 46    9 07.01.2017 10:11:17          2         3        5    25
#> 47   25 11.01.2017 20:30:43          2         1        1    25
#> 48   32 12.01.2017 18:47:45          1         5        3    25
#> 49   51 14.01.2017 13:55:30          2         5        2    25
#> 50   69 15.01.2017 14:10:13          3         6        5    25
#> 51  123 19.01.2017 12:36:03          1         3        4    25
#> 52  161 20.01.2017 18:00:00          2         1        1    25
#> 53  164 20.01.2017 18:17:03          3         4        2    25
#> 54  209 22.01.2017 19:39:51          4         4        4    25
#> 55  295 26.01.2017 16:18:27          1         3        1    25
#> 56  302 27.01.2017 08:44:41          1         5        1    25
#> 57   20 10.01.2017 18:33:15          3         5        2    26
#> 58   26 11.01.2017 20:38:16          1         3        1    26
#> 59   50 14.01.2017 10:53:38          1         3        2    26
#> 60   53 14.01.2017 15:04:05          1         2        3    26
#> 61   54 14.01.2017 15:14:50          3         5        2    26
#> 62  105 18.01.2017 15:46:15          3         6        4    26
#> 63  112 18.01.2017 19:41:09          3         5        5    26
#> 64  120 19.01.2017 10:17:15          3         7        4    26
#> 65  140 19.01.2017 18:37:53          3         7        4    26
#> 66  151 20.01.2017 11:27:08          2         4        1    26
#> 67  187 21.01.2017 16:27:32         NA        NA       NA    26
#> 68  205 22.01.2017 18:29:17          2         2        1    26
#> 69  228 23.01.2017 14:53:46          3         5        4    26
#> 70  256 25.01.2017 10:39:53          2         2        3    26
#> 71  273 25.01.2017 17:11:34          3         4        3    26
#> 72   66 15.01.2017 13:28:29          1         3        1    27
#> 73   81 15.01.2017 20:59:54          3         3        4    27
#> 74   95 17.01.2017 20:52:29          2         4        5    27
#> 75  109 18.01.2017 17:47:57          2         4        5    27
#> 76  154 20.01.2017 13:38:19          4         5        1    27
#> 77  200 22.01.2017 16:21:18          2         5        4    27
#> 78  203 22.01.2017 17:22:06          3         4        5    27
#> 79  208 22.01.2017 18:58:58          1         2        2    27
#> 80  222 23.01.2017 12:06:58          3         6        5    27
#> 81  227 23.01.2017 14:30:40          3         8        3    27
#> 82  236 23.01.2017 18:48:02          3         2        3    27
#> 83  237 23.01.2017 19:07:33          3         2        3    27
#> 84  238 23.01.2017 19:53:10         NA        NA       NA    27
#> 85  243 24.01.2017 14:15:59          4         4        2    27
#> 86  251 24.01.2017 20:02:38          1         1        2    27
#> 87   24 11.01.2017 19:38:20          3         2        3    28
#> 88   59 14.01.2017 16:26:40          2         6        3    28
#> 89   61 14.01.2017 17:27:31          3         6        3    28
#> 90   70 15.01.2017 15:01:12          3         4        2    28
#> 91   80 15.01.2017 20:39:10          3         6        3    28
#> 92   82 15.01.2017 21:05:53          3         2        5    28
#> 93   98 17.01.2017 21:59:36          2         2        2    28
#> 94  145 19.01.2017 19:29:43          4         5        3    28
#> 95  147 19.01.2017 20:36:23          4         4        2    28
#> 96  173 20.01.2017 21:13:25          2         3        3    28
#> 97  190 22.01.2017 11:19:10          3         6        2    28
#> 98  207 22.01.2017 18:56:56         NA        NA       NA    28
#> 99  210 22.01.2017 19:45:33          3         5        3    28
#> 100 215 22.01.2017 22:00:29          1         2        2    28
#> 101 224 23.01.2017 12:57:00          2         4        1    28
#> 102 239 23.01.2017 20:00:46          3         4        1    28
#> 103 242 24.01.2017 14:09:33         NA        NA       NA    28
#> 104 245 24.01.2017 14:56:24         NA        NA       NA    28
#> 105 247 24.01.2017 15:37:27         NA        NA       NA    28
#> 106 270 25.01.2017 16:35:41         NA        NA       NA    28
#> 107 288 26.01.2017 13:36:14         NA        NA       NA    28
#> 108   1 05.01.2017 13:57:01          5         8        5    29
#> 109   2 05.01.2017 21:07:56          3         7        3    29
#> 110  47 13.01.2017 20:52:32          1         4        4    29
#> 111  73 15.01.2017 15:49:52          4         3        4    29
#> 112  87 16.01.2017 16:51:20          3         7        2    29
#> 113  91 17.01.2017 15:19:36         NA        NA       NA    29
#> 114 127 19.01.2017 14:20:15          2         1        2    29
#> 115 152 20.01.2017 13:02:50          2         4        2    29
#> 116 176 20.01.2017 23:18:18          3         5        3    29
#> 117 213 22.01.2017 21:47:06         NA        NA       NA    29
#> 118 255 25.01.2017 10:05:00         NA        NA       NA    29
#> 119 261 25.01.2017 12:13:25          2         5        1    29
#> 120 262 25.01.2017 12:49:57          1         2        1    29
#> 121 276 25.01.2017 18:54:30          3         6        1    29
#> 122 277 25.01.2017 20:06:34          3         4        1    29
#> 123 282 26.01.2017 10:19:49          5         8        5    29
#> 124 287 26.01.2017 11:56:19          4         8        3    29
#> 125  15 09.01.2017 15:23:15         NA        NA       NA    30
#> 126  23 11.01.2017 14:17:26          3         4        3    30
#> 127  27 11.01.2017 20:49:19          2         4        5    30
#> 128  44 13.01.2017 14:39:57          1         6        2    30
#> 129  48 13.01.2017 21:50:03          2         4        5    30
#> 130  57 14.01.2017 15:39:12          2         6        2    30
#> 131  74 15.01.2017 16:12:54         NA        NA       NA    30
#> 132 101 18.01.2017 12:32:04          4         7        2    30
#> 133 114 18.01.2017 22:20:33          1         4        3    30
#> 134 125 19.01.2017 13:03:26         NA        NA       NA    30
#> 135 149 20.01.2017 09:02:45          3         5        4    30
#> 136 182 21.01.2017 11:29:16          3         2        2    30
#> 137 192 22.01.2017 11:52:16          2         5        2    30
#> 138 198 22.01.2017 15:07:48          3         7        3    30
#> 139 219 23.01.2017 11:24:30          2         7        5    30
#> 140 265 25.01.2017 13:14:00         NA        NA       NA    30
#> 141  12 08.01.2017 19:17:20          4         7        4    31
#> 142  60 14.01.2017 17:14:18          2         7        2    31
#> 143  78 15.01.2017 18:31:00          3         6        4    31
#> 144 121 19.01.2017 11:29:43          1         1        1    31
#> 145 139 19.01.2017 18:35:56         NA        NA       NA    31
#> 146 157 20.01.2017 17:34:48         NA        NA       NA    31
#> 147 183 21.01.2017 12:20:37         NA        NA       NA    31
#> 148 193 22.01.2017 12:17:32          4         5        4    31
#> 149 194 22.01.2017 12:27:59          4         6        3    31
#> 150 201 22.01.2017 17:03:55          3         6        4    31
#> 151 204 22.01.2017 17:45:23          1         3        2    31
#> 152 214 22.01.2017 21:57:36          2         6        6    31
#> 153 229 23.01.2017 15:20:08          5         7        4    31
#> 154 241 24.01.2017 10:28:57          3         4        4    31
#> 155 260 25.01.2017 11:59:11          3         6        4    31
#> 156 263 25.01.2017 13:04:33          3         8        5    31
#> 157 280 26.01.2017 03:01:08          4         7        4    31
#> 158 289 26.01.2017 14:19:14         NA        NA       NA    31
#> 159  11 08.01.2017 12:56:43          1         2        4    32
#> 160  18 09.01.2017 22:57:38          3         3        5    32
#> 161  46 13.01.2017 18:34:25          3         7        2    32
#> 162  52 14.01.2017 14:46:16          1         9        2    32
#> 163  76 15.01.2017 18:00:15          3         7        4    32
#> 164  77 15.01.2017 18:21:19          4         5        5    32
#> 165  90 17.01.2017 14:34:13          3         7        2    32
#> 166 100 18.01.2017 11:29:13          4         7        4    32
#> 167 124 19.01.2017 12:51:10         NA        NA       NA    32
#> 168 150 20.01.2017 09:53:47         NA        NA       NA    32
#> 169 168 20.01.2017 20:04:38          1         1        1    32
#> 170 178 20.01.2017 23:54:46          3         6        4    32
#> 171 184 21.01.2017 14:20:14          2         4        4    32
#> 172 212 22.01.2017 21:34:56          4         5        4    32
#> 173 250 24.01.2017 18:56:35          3         6        3    32
#> 174 304 27.01.2017 09:18:26          3         8        2    32
#> 175  10 07.01.2017 18:10:05          4         5        5    33
#> 176  17 09.01.2017 20:49:48          2         5        3    33
#> 177  21 10.01.2017 21:17:52          4         7        2    33
#> 178  63 15.01.2017 11:41:07          2         5        3    33
#> 179  68 15.01.2017 13:46:04          2         5        2    33
#> 180 118 19.01.2017 08:54:43         NA        NA       NA    33
#> 181 156 20.01.2017 17:28:23          4         7        5    33
#> 182 199 22.01.2017 15:26:55          3         5        3    33
#> 183 233 23.01.2017 17:03:10          2         9        2    33
#> 184 254 25.01.2017 09:33:37          3         7        3    33
#> 185 267 25.01.2017 16:08:48          3         6        3    33
#> 186 297 26.01.2017 19:07:14          3         6        1    33
#> 187 301 27.01.2017 08:17:59          4         8        6    33
#> 188   5 06.01.2017 14:13:08          4         8        6    34
#> 189  85 16.01.2017 13:56:29          3         6        5    34
#> 190  88 16.01.2017 19:03:39          2         7        4    34
#> 191  89 16.01.2017 21:18:05         NA        NA       NA    34
#> 192  94 17.01.2017 19:47:11          3         7        3    34
#> 193 115 18.01.2017 23:00:36          4         5        5    34
#> 194 122 19.01.2017 11:30:57          2         2        1    34
#> 195 141 19.01.2017 18:44:32         NA        NA       NA    34
#> 196 143 19.01.2017 19:15:36          3         6        2    34
#> 197 159 20.01.2017 17:57:26         NA        NA       NA    34
#> 198 160 20.01.2017 17:59:19         NA        NA       NA    34
#> 199 166 20.01.2017 19:03:10          4         6        3    34
#> 200 170 20.01.2017 20:09:15          2         1        3    34
#> 201 172 20.01.2017 20:42:46          5        10        6    34
#> 202 177 20.01.2017 23:37:45          4         7        5    34
#> 203 218 23.01.2017 11:21:21          3         5        3    34
#> 204 240 24.01.2017 10:19:25          3         6        3    34
#> 205 259 25.01.2017 11:37:19          5         7        5    34
#> 206 271 25.01.2017 16:53:17         NA        NA       NA    34
#> 207 275 25.01.2017 18:06:36         NA        NA       NA    34
#> 208 285 26.01.2017 10:54:41         NA        NA       NA    34
#> 209 294 26.01.2017 15:51:56         NA        NA       NA    34
#> 210  14 09.01.2017 12:15:48          4         9        3    35
#> 211  38 13.01.2017 07:55:14          3         8        3    35
#> 212  62 14.01.2017 17:52:29          2         8        2    35
#> 213  75 15.01.2017 17:31:06          1         2        1    35
#> 214  79 15.01.2017 19:54:00          3         4        3    35
#> 215  84 16.01.2017 13:51:51          4         8        5    35
#> 216  93 17.01.2017 19:28:51          3         7        2    35
#> 217 103 18.01.2017 13:32:09          4         7        5    35
#> 218 148 19.01.2017 21:19:10          4         2        3    35
#> 219 162 20.01.2017 18:00:53         NA        NA       NA    35
#> 220 174 20.01.2017 22:58:35          5         8        5    35
#> 221 231 23.01.2017 16:32:32          1         1        1    35
#> 222 244 24.01.2017 14:38:56          3         5        3    35
#> 223 305 27.01.2017 09:52:59          3         8        2    35
#> 224  43 13.01.2017 14:14:16          4         8        6    36
#> 225 128 19.01.2017 14:29:41          3         6        3    36
#> 226 158 20.01.2017 17:53:16         NA        NA       NA    36
#> 227 163 20.01.2017 18:04:21         NA        NA       NA    36
#> 228 165 20.01.2017 18:57:33          2         8        5    36
#> 229 188 21.01.2017 19:01:18          4         8        4    36
#> 230 191 22.01.2017 11:31:27         NA        NA       NA    36
#> 231 202 22.01.2017 17:13:02         NA        NA       NA    36
#> 232 226 23.01.2017 14:17:10         NA        NA       NA    36
#> 233 272 25.01.2017 17:03:21         NA        NA       NA    36
#> 234 278 25.01.2017 21:08:40          5         6        5    36
#> 235 279 25.01.2017 23:19:16          4         8        4    36
#> 236 284 26.01.2017 10:46:10          4         5        4    36
#> 237 290 26.01.2017 14:34:23         NA        NA       NA    36
#> 238 293 26.01.2017 15:17:47         NA        NA       NA    36
#> 239  96 17.01.2017 20:55:48          4         7        5    37
#> 240  99 18.01.2017 09:04:30         NA        NA       NA    37
#> 241 110 18.01.2017 18:53:02          5         8        6    37
#> 242 111 18.01.2017 19:24:49         NA        NA       NA    37
#> 243 117 19.01.2017 08:06:05         NA        NA       NA    37
#> 244 126 19.01.2017 13:42:49          2         8        4    37
#> 245 146 19.01.2017 20:08:34          4         7        2    37
#> 246 153 20.01.2017 13:03:25          3         7        3    37
#> 247 169 20.01.2017 20:05:13          3         5        1    37
#> 248 171 20.01.2017 20:29:52          4         9        5    37
#> 249 189 21.01.2017 20:05:54          4         6        2    37
#> 250 274 25.01.2017 17:38:36         NA        NA       NA    37
#> 251 299 26.01.2017 23:10:18          5         4        2    37
#> 252  22 11.01.2017 13:32:30          4         9        5    38
#> 253  34 12.01.2017 18:57:47          4         7        1    38
#> 254  42 13.01.2017 14:08:08         NA        NA       NA    38
#> 255 106 18.01.2017 15:52:04         NA        NA       NA    38
#> 256 113 18.01.2017 21:44:02          5         8        5    38
#> 257 133 19.01.2017 18:22:38         NA        NA       NA    38
#> 258 181 21.01.2017 08:26:17          4         9        5    38
#> 259 211 22.01.2017 20:28:43         NA        NA       NA    38
#> 260 252 25.01.2017 08:56:16          5         7        3    38
#> 261 258 25.01.2017 11:25:38          5         9        5    38
#> 262 268 25.01.2017 16:15:57          4         7        4    38
#> 263 281 26.01.2017 10:13:05          4         7        4    38
#> 264 286 26.01.2017 11:19:10         NA        NA       NA    38
#> 265 296 26.01.2017 17:12:37          3         6        3    38
#> 266 298 26.01.2017 20:41:21          2         5        3    38
#> 267 303 27.01.2017 08:50:31          5         8        3    38
#> 268   6 06.01.2017 14:21:18         NA        NA       NA    39
#> 269  39 13.01.2017 08:54:17          3        10        3    39
#> 270  40 13.01.2017 09:31:06          4         9        3    39
#> 271  49 14.01.2017 07:02:39         NA        NA       NA    39
#> 272  56 14.01.2017 15:27:10          3         8        2    39
#> 273  64 15.01.2017 11:49:03          3         8        3    39
#> 274 104 18.01.2017 13:42:20         NA        NA       NA    39
#> 275 108 18.01.2017 16:38:36          5         8        5    39
#> 276 134 19.01.2017 18:22:43          1         4        4    39
#> 277 135 19.01.2017 18:22:55          3         3        4    39
#> 278 136 19.01.2017 18:22:57          3         1        6    39
#> 279 137 19.01.2017 18:22:58          4        10        5    39
#> 280 138 19.01.2017 18:23:23          3         9        3    39
#> 281 144 19.01.2017 19:23:57          4         8        3    39
#> 282 155 20.01.2017 15:33:55         NA        NA       NA    39
#> 283 180 21.01.2017 08:04:17         NA        NA       NA    39
#> 284 225 23.01.2017 13:24:22         NA        NA       NA    39
#> 285 253 25.01.2017 09:32:55         NA        NA       NA    39
#> 286 264 25.01.2017 13:11:14          4        10        5    39
#> 287 291 26.01.2017 14:55:17         NA        NA       NA    39
#> 288 292 26.01.2017 15:00:29          4         8        3    39
#> 289   3 05.01.2017 23:33:47          5        10        6    40
#> 290   7 06.01.2017 14:25:49         NA        NA       NA    40
#> 291  29 12.01.2017 09:48:16          4        10        3    40
#> 292  41 13.01.2017 12:07:29          4        10        3    40
#> 293  58 14.01.2017 15:43:01          3         8        2    40
#> 294  83 16.01.2017 10:16:52         NA        NA       NA    40
#> 295 116 18.01.2017 23:07:32          4         8        5    40
#> 296 119 19.01.2017 09:05:01         NA        NA       NA    40
#> 297 132 19.01.2017 18:22:32         NA        NA       NA    40
#> 298 175 20.01.2017 23:03:36          5        10        5    40
#> 299 179 21.01.2017 07:40:05          5         9        1    40
#> 300 185 21.01.2017 15:01:26          4        10        5    40
#> 301 196 22.01.2017 13:38:56          4        10        5    40
#> 302 197 22.01.2017 14:55:17          4        10        5    40
#> 303 248 24.01.2017 16:29:45          2        10        2    40
#> 304 249 24.01.2017 17:19:54         NA        NA       NA    40
#> 305 257 25.01.2017 10:44:34          2         9        3    40
#> 306 306 27.01.2017 11:29:48          4         9        3    40
arrange(stats_test, -score) # liefert die *besten* Noten zurück
#>       X                 V_1 study_time self_eval interest score
#> 1     3 05.01.2017 23:33:47          5        10        6    40
#> 2     7 06.01.2017 14:25:49         NA        NA       NA    40
#> 3    29 12.01.2017 09:48:16          4        10        3    40
#> 4    41 13.01.2017 12:07:29          4        10        3    40
#> 5    58 14.01.2017 15:43:01          3         8        2    40
#> 6    83 16.01.2017 10:16:52         NA        NA       NA    40
#> 7   116 18.01.2017 23:07:32          4         8        5    40
#> 8   119 19.01.2017 09:05:01         NA        NA       NA    40
#> 9   132 19.01.2017 18:22:32         NA        NA       NA    40
#> 10  175 20.01.2017 23:03:36          5        10        5    40
#> 11  179 21.01.2017 07:40:05          5         9        1    40
#> 12  185 21.01.2017 15:01:26          4        10        5    40
#> 13  196 22.01.2017 13:38:56          4        10        5    40
#> 14  197 22.01.2017 14:55:17          4        10        5    40
#> 15  248 24.01.2017 16:29:45          2        10        2    40
#> 16  249 24.01.2017 17:19:54         NA        NA       NA    40
#> 17  257 25.01.2017 10:44:34          2         9        3    40
#> 18  306 27.01.2017 11:29:48          4         9        3    40
#> 19    6 06.01.2017 14:21:18         NA        NA       NA    39
#> 20   39 13.01.2017 08:54:17          3        10        3    39
#> 21   40 13.01.2017 09:31:06          4         9        3    39
#> 22   49 14.01.2017 07:02:39         NA        NA       NA    39
#> 23   56 14.01.2017 15:27:10          3         8        2    39
#> 24   64 15.01.2017 11:49:03          3         8        3    39
#> 25  104 18.01.2017 13:42:20         NA        NA       NA    39
#> 26  108 18.01.2017 16:38:36          5         8        5    39
#> 27  134 19.01.2017 18:22:43          1         4        4    39
#> 28  135 19.01.2017 18:22:55          3         3        4    39
#> 29  136 19.01.2017 18:22:57          3         1        6    39
#> 30  137 19.01.2017 18:22:58          4        10        5    39
#> 31  138 19.01.2017 18:23:23          3         9        3    39
#> 32  144 19.01.2017 19:23:57          4         8        3    39
#> 33  155 20.01.2017 15:33:55         NA        NA       NA    39
#> 34  180 21.01.2017 08:04:17         NA        NA       NA    39
#> 35  225 23.01.2017 13:24:22         NA        NA       NA    39
#> 36  253 25.01.2017 09:32:55         NA        NA       NA    39
#> 37  264 25.01.2017 13:11:14          4        10        5    39
#> 38  291 26.01.2017 14:55:17         NA        NA       NA    39
#> 39  292 26.01.2017 15:00:29          4         8        3    39
#> 40   22 11.01.2017 13:32:30          4         9        5    38
#> 41   34 12.01.2017 18:57:47          4         7        1    38
#> 42   42 13.01.2017 14:08:08         NA        NA       NA    38
#> 43  106 18.01.2017 15:52:04         NA        NA       NA    38
#> 44  113 18.01.2017 21:44:02          5         8        5    38
#> 45  133 19.01.2017 18:22:38         NA        NA       NA    38
#> 46  181 21.01.2017 08:26:17          4         9        5    38
#> 47  211 22.01.2017 20:28:43         NA        NA       NA    38
#> 48  252 25.01.2017 08:56:16          5         7        3    38
#> 49  258 25.01.2017 11:25:38          5         9        5    38
#> 50  268 25.01.2017 16:15:57          4         7        4    38
#> 51  281 26.01.2017 10:13:05          4         7        4    38
#> 52  286 26.01.2017 11:19:10         NA        NA       NA    38
#> 53  296 26.01.2017 17:12:37          3         6        3    38
#> 54  298 26.01.2017 20:41:21          2         5        3    38
#> 55  303 27.01.2017 08:50:31          5         8        3    38
#> 56   96 17.01.2017 20:55:48          4         7        5    37
#> 57   99 18.01.2017 09:04:30         NA        NA       NA    37
#> 58  110 18.01.2017 18:53:02          5         8        6    37
#> 59  111 18.01.2017 19:24:49         NA        NA       NA    37
#> 60  117 19.01.2017 08:06:05         NA        NA       NA    37
#> 61  126 19.01.2017 13:42:49          2         8        4    37
#> 62  146 19.01.2017 20:08:34          4         7        2    37
#> 63  153 20.01.2017 13:03:25          3         7        3    37
#> 64  169 20.01.2017 20:05:13          3         5        1    37
#> 65  171 20.01.2017 20:29:52          4         9        5    37
#> 66  189 21.01.2017 20:05:54          4         6        2    37
#> 67  274 25.01.2017 17:38:36         NA        NA       NA    37
#> 68  299 26.01.2017 23:10:18          5         4        2    37
#> 69   43 13.01.2017 14:14:16          4         8        6    36
#> 70  128 19.01.2017 14:29:41          3         6        3    36
#> 71  158 20.01.2017 17:53:16         NA        NA       NA    36
#> 72  163 20.01.2017 18:04:21         NA        NA       NA    36
#> 73  165 20.01.2017 18:57:33          2         8        5    36
#> 74  188 21.01.2017 19:01:18          4         8        4    36
#> 75  191 22.01.2017 11:31:27         NA        NA       NA    36
#> 76  202 22.01.2017 17:13:02         NA        NA       NA    36
#> 77  226 23.01.2017 14:17:10         NA        NA       NA    36
#> 78  272 25.01.2017 17:03:21         NA        NA       NA    36
#> 79  278 25.01.2017 21:08:40          5         6        5    36
#> 80  279 25.01.2017 23:19:16          4         8        4    36
#> 81  284 26.01.2017 10:46:10          4         5        4    36
#> 82  290 26.01.2017 14:34:23         NA        NA       NA    36
#> 83  293 26.01.2017 15:17:47         NA        NA       NA    36
#> 84   14 09.01.2017 12:15:48          4         9        3    35
#> 85   38 13.01.2017 07:55:14          3         8        3    35
#> 86   62 14.01.2017 17:52:29          2         8        2    35
#> 87   75 15.01.2017 17:31:06          1         2        1    35
#> 88   79 15.01.2017 19:54:00          3         4        3    35
#> 89   84 16.01.2017 13:51:51          4         8        5    35
#> 90   93 17.01.2017 19:28:51          3         7        2    35
#> 91  103 18.01.2017 13:32:09          4         7        5    35
#> 92  148 19.01.2017 21:19:10          4         2        3    35
#> 93  162 20.01.2017 18:00:53         NA        NA       NA    35
#> 94  174 20.01.2017 22:58:35          5         8        5    35
#> 95  231 23.01.2017 16:32:32          1         1        1    35
#> 96  244 24.01.2017 14:38:56          3         5        3    35
#> 97  305 27.01.2017 09:52:59          3         8        2    35
#> 98    5 06.01.2017 14:13:08          4         8        6    34
#> 99   85 16.01.2017 13:56:29          3         6        5    34
#> 100  88 16.01.2017 19:03:39          2         7        4    34
#> 101  89 16.01.2017 21:18:05         NA        NA       NA    34
#> 102  94 17.01.2017 19:47:11          3         7        3    34
#> 103 115 18.01.2017 23:00:36          4         5        5    34
#> 104 122 19.01.2017 11:30:57          2         2        1    34
#> 105 141 19.01.2017 18:44:32         NA        NA       NA    34
#> 106 143 19.01.2017 19:15:36          3         6        2    34
#> 107 159 20.01.2017 17:57:26         NA        NA       NA    34
#> 108 160 20.01.2017 17:59:19         NA        NA       NA    34
#> 109 166 20.01.2017 19:03:10          4         6        3    34
#> 110 170 20.01.2017 20:09:15          2         1        3    34
#> 111 172 20.01.2017 20:42:46          5        10        6    34
#> 112 177 20.01.2017 23:37:45          4         7        5    34
#> 113 218 23.01.2017 11:21:21          3         5        3    34
#> 114 240 24.01.2017 10:19:25          3         6        3    34
#> 115 259 25.01.2017 11:37:19          5         7        5    34
#> 116 271 25.01.2017 16:53:17         NA        NA       NA    34
#> 117 275 25.01.2017 18:06:36         NA        NA       NA    34
#> 118 285 26.01.2017 10:54:41         NA        NA       NA    34
#> 119 294 26.01.2017 15:51:56         NA        NA       NA    34
#> 120  10 07.01.2017 18:10:05          4         5        5    33
#> 121  17 09.01.2017 20:49:48          2         5        3    33
#> 122  21 10.01.2017 21:17:52          4         7        2    33
#> 123  63 15.01.2017 11:41:07          2         5        3    33
#> 124  68 15.01.2017 13:46:04          2         5        2    33
#> 125 118 19.01.2017 08:54:43         NA        NA       NA    33
#> 126 156 20.01.2017 17:28:23          4         7        5    33
#> 127 199 22.01.2017 15:26:55          3         5        3    33
#> 128 233 23.01.2017 17:03:10          2         9        2    33
#> 129 254 25.01.2017 09:33:37          3         7        3    33
#> 130 267 25.01.2017 16:08:48          3         6        3    33
#> 131 297 26.01.2017 19:07:14          3         6        1    33
#> 132 301 27.01.2017 08:17:59          4         8        6    33
#> 133  11 08.01.2017 12:56:43          1         2        4    32
#> 134  18 09.01.2017 22:57:38          3         3        5    32
#> 135  46 13.01.2017 18:34:25          3         7        2    32
#> 136  52 14.01.2017 14:46:16          1         9        2    32
#> 137  76 15.01.2017 18:00:15          3         7        4    32
#> 138  77 15.01.2017 18:21:19          4         5        5    32
#> 139  90 17.01.2017 14:34:13          3         7        2    32
#> 140 100 18.01.2017 11:29:13          4         7        4    32
#> 141 124 19.01.2017 12:51:10         NA        NA       NA    32
#> 142 150 20.01.2017 09:53:47         NA        NA       NA    32
#> 143 168 20.01.2017 20:04:38          1         1        1    32
#> 144 178 20.01.2017 23:54:46          3         6        4    32
#> 145 184 21.01.2017 14:20:14          2         4        4    32
#> 146 212 22.01.2017 21:34:56          4         5        4    32
#> 147 250 24.01.2017 18:56:35          3         6        3    32
#> 148 304 27.01.2017 09:18:26          3         8        2    32
#> 149  12 08.01.2017 19:17:20          4         7        4    31
#> 150  60 14.01.2017 17:14:18          2         7        2    31
#> 151  78 15.01.2017 18:31:00          3         6        4    31
#> 152 121 19.01.2017 11:29:43          1         1        1    31
#> 153 139 19.01.2017 18:35:56         NA        NA       NA    31
#> 154 157 20.01.2017 17:34:48         NA        NA       NA    31
#> 155 183 21.01.2017 12:20:37         NA        NA       NA    31
#> 156 193 22.01.2017 12:17:32          4         5        4    31
#> 157 194 22.01.2017 12:27:59          4         6        3    31
#> 158 201 22.01.2017 17:03:55          3         6        4    31
#> 159 204 22.01.2017 17:45:23          1         3        2    31
#> 160 214 22.01.2017 21:57:36          2         6        6    31
#> 161 229 23.01.2017 15:20:08          5         7        4    31
#> 162 241 24.01.2017 10:28:57          3         4        4    31
#> 163 260 25.01.2017 11:59:11          3         6        4    31
#> 164 263 25.01.2017 13:04:33          3         8        5    31
#> 165 280 26.01.2017 03:01:08          4         7        4    31
#> 166 289 26.01.2017 14:19:14         NA        NA       NA    31
#> 167  15 09.01.2017 15:23:15         NA        NA       NA    30
#> 168  23 11.01.2017 14:17:26          3         4        3    30
#> 169  27 11.01.2017 20:49:19          2         4        5    30
#> 170  44 13.01.2017 14:39:57          1         6        2    30
#> 171  48 13.01.2017 21:50:03          2         4        5    30
#> 172  57 14.01.2017 15:39:12          2         6        2    30
#> 173  74 15.01.2017 16:12:54         NA        NA       NA    30
#> 174 101 18.01.2017 12:32:04          4         7        2    30
#> 175 114 18.01.2017 22:20:33          1         4        3    30
#> 176 125 19.01.2017 13:03:26         NA        NA       NA    30
#> 177 149 20.01.2017 09:02:45          3         5        4    30
#> 178 182 21.01.2017 11:29:16          3         2        2    30
#> 179 192 22.01.2017 11:52:16          2         5        2    30
#> 180 198 22.01.2017 15:07:48          3         7        3    30
#> 181 219 23.01.2017 11:24:30          2         7        5    30
#> 182 265 25.01.2017 13:14:00         NA        NA       NA    30
#> 183   1 05.01.2017 13:57:01          5         8        5    29
#> 184   2 05.01.2017 21:07:56          3         7        3    29
#> 185  47 13.01.2017 20:52:32          1         4        4    29
#> 186  73 15.01.2017 15:49:52          4         3        4    29
#> 187  87 16.01.2017 16:51:20          3         7        2    29
#> 188  91 17.01.2017 15:19:36         NA        NA       NA    29
#> 189 127 19.01.2017 14:20:15          2         1        2    29
#> 190 152 20.01.2017 13:02:50          2         4        2    29
#> 191 176 20.01.2017 23:18:18          3         5        3    29
#> 192 213 22.01.2017 21:47:06         NA        NA       NA    29
#> 193 255 25.01.2017 10:05:00         NA        NA       NA    29
#> 194 261 25.01.2017 12:13:25          2         5        1    29
#> 195 262 25.01.2017 12:49:57          1         2        1    29
#> 196 276 25.01.2017 18:54:30          3         6        1    29
#> 197 277 25.01.2017 20:06:34          3         4        1    29
#> 198 282 26.01.2017 10:19:49          5         8        5    29
#> 199 287 26.01.2017 11:56:19          4         8        3    29
#> 200  24 11.01.2017 19:38:20          3         2        3    28
#> 201  59 14.01.2017 16:26:40          2         6        3    28
#> 202  61 14.01.2017 17:27:31          3         6        3    28
#> 203  70 15.01.2017 15:01:12          3         4        2    28
#> 204  80 15.01.2017 20:39:10          3         6        3    28
#> 205  82 15.01.2017 21:05:53          3         2        5    28
#> 206  98 17.01.2017 21:59:36          2         2        2    28
#> 207 145 19.01.2017 19:29:43          4         5        3    28
#> 208 147 19.01.2017 20:36:23          4         4        2    28
#> 209 173 20.01.2017 21:13:25          2         3        3    28
#> 210 190 22.01.2017 11:19:10          3         6        2    28
#> 211 207 22.01.2017 18:56:56         NA        NA       NA    28
#> 212 210 22.01.2017 19:45:33          3         5        3    28
#> 213 215 22.01.2017 22:00:29          1         2        2    28
#> 214 224 23.01.2017 12:57:00          2         4        1    28
#> 215 239 23.01.2017 20:00:46          3         4        1    28
#> 216 242 24.01.2017 14:09:33         NA        NA       NA    28
#> 217 245 24.01.2017 14:56:24         NA        NA       NA    28
#> 218 247 24.01.2017 15:37:27         NA        NA       NA    28
#> 219 270 25.01.2017 16:35:41         NA        NA       NA    28
#> 220 288 26.01.2017 13:36:14         NA        NA       NA    28
#> 221  66 15.01.2017 13:28:29          1         3        1    27
#> 222  81 15.01.2017 20:59:54          3         3        4    27
#> 223  95 17.01.2017 20:52:29          2         4        5    27
#> 224 109 18.01.2017 17:47:57          2         4        5    27
#> 225 154 20.01.2017 13:38:19          4         5        1    27
#> 226 200 22.01.2017 16:21:18          2         5        4    27
#> 227 203 22.01.2017 17:22:06          3         4        5    27
#> 228 208 22.01.2017 18:58:58          1         2        2    27
#> 229 222 23.01.2017 12:06:58          3         6        5    27
#> 230 227 23.01.2017 14:30:40          3         8        3    27
#> 231 236 23.01.2017 18:48:02          3         2        3    27
#> 232 237 23.01.2017 19:07:33          3         2        3    27
#> 233 238 23.01.2017 19:53:10         NA        NA       NA    27
#> 234 243 24.01.2017 14:15:59          4         4        2    27
#> 235 251 24.01.2017 20:02:38          1         1        2    27
#> 236  20 10.01.2017 18:33:15          3         5        2    26
#> 237  26 11.01.2017 20:38:16          1         3        1    26
#> 238  50 14.01.2017 10:53:38          1         3        2    26
#> 239  53 14.01.2017 15:04:05          1         2        3    26
#> 240  54 14.01.2017 15:14:50          3         5        2    26
#> 241 105 18.01.2017 15:46:15          3         6        4    26
#> 242 112 18.01.2017 19:41:09          3         5        5    26
#> 243 120 19.01.2017 10:17:15          3         7        4    26
#> 244 140 19.01.2017 18:37:53          3         7        4    26
#> 245 151 20.01.2017 11:27:08          2         4        1    26
#> 246 187 21.01.2017 16:27:32         NA        NA       NA    26
#> 247 205 22.01.2017 18:29:17          2         2        1    26
#> 248 228 23.01.2017 14:53:46          3         5        4    26
#> 249 256 25.01.2017 10:39:53          2         2        3    26
#> 250 273 25.01.2017 17:11:34          3         4        3    26
#> 251   9 07.01.2017 10:11:17          2         3        5    25
#> 252  25 11.01.2017 20:30:43          2         1        1    25
#> 253  32 12.01.2017 18:47:45          1         5        3    25
#> 254  51 14.01.2017 13:55:30          2         5        2    25
#> 255  69 15.01.2017 14:10:13          3         6        5    25
#> 256 123 19.01.2017 12:36:03          1         3        4    25
#> 257 161 20.01.2017 18:00:00          2         1        1    25
#> 258 164 20.01.2017 18:17:03          3         4        2    25
#> 259 209 22.01.2017 19:39:51          4         4        4    25
#> 260 295 26.01.2017 16:18:27          1         3        1    25
#> 261 302 27.01.2017 08:44:41          1         5        1    25
#> 262   8 06.01.2017 17:24:53          2         5        3    24
#> 263  16 09.01.2017 15:52:12          2         5        3    24
#> 264  28 11.01.2017 22:44:23          2         6        2    24
#> 265  30 12.01.2017 13:36:07          3         5        2    24
#> 266  37 12.01.2017 19:20:25          3         3        4    24
#> 267  67 15.01.2017 13:30:48         NA        NA       NA    24
#> 268  92 17.01.2017 17:18:55          1         1        1    24
#> 269 107 18.01.2017 16:01:36          3         2        1    24
#> 270 130 19.01.2017 17:58:35          3         1        4    24
#> 271 217 23.01.2017 11:18:51          2         6        3    24
#> 272 232 23.01.2017 16:50:14          3         2        4    24
#> 273 246 24.01.2017 15:09:44         NA        NA       NA    24
#> 274  31 12.01.2017 14:09:10          4         8        5    23
#> 275  45 13.01.2017 16:57:26          1         2        3    23
#> 276  72 15.01.2017 15:30:15          4         4        4    23
#> 277  86 16.01.2017 15:31:38          2         4        2    23
#> 278 167 20.01.2017 19:17:44          4         5        4    23
#> 279 195 22.01.2017 13:24:51         NA        NA       NA    23
#> 280 221 23.01.2017 11:40:30          1         1        1    23
#> 281 230 23.01.2017 16:27:49          1         1        1    23
#> 282 283 26.01.2017 10:39:44         NA        NA       NA    23
#> 283  13 09.01.2017 09:51:37          1         2        2    22
#> 284  19 10.01.2017 17:16:48         NA        NA       NA    22
#> 285  36 12.01.2017 19:09:14          1         7        3    22
#> 286  55 14.01.2017 15:15:38          3         4        5    22
#> 287  65 15.01.2017 12:41:27          3         6        6    22
#> 288 220 23.01.2017 11:27:11          3         5        3    22
#> 289 266 25.01.2017 15:39:13          2         4        4    22
#> 290 269 25.01.2017 16:31:46          3         3        3    22
#> 291  33 12.01.2017 18:53:43          1         3        2    21
#> 292 102 18.01.2017 12:48:04          3         3        3    21
#> 293 129 19.01.2017 17:58:02          2         4        3    21
#> 294 186 21.01.2017 16:24:44          2         5        3    21
#> 295 216 23.01.2017 07:54:17          4         2        5    21
#> 296 223 23.01.2017 12:53:02          3         1        3    21
#> 297  71 15.01.2017 15:03:29          3         3        3    20
#> 298  97 17.01.2017 21:51:05          3         3        5    20
#> 299 206 22.01.2017 18:42:49         NA        NA       NA    20
#> 300 235 23.01.2017 18:26:20         NA        NA       NA    20
#> 301 300 27.01.2017 02:14:27          2         3        2    20
#> 302  35 12.01.2017 19:04:43          1         2        3    19
#> 303   4 06.01.2017 09:58:05          2         3        2    18
#> 304 131 19.01.2017 18:03:45          2         3        4    18
#> 305 142 19.01.2017 19:02:12          3         4        1    18
#> 306 234 23.01.2017 18:13:15          3         1        1    17
arrange(stats_test, interest, score)
#>       X                 V_1 study_time self_eval interest score
#> 1   234 23.01.2017 18:13:15          3         1        1    17
#> 2   142 19.01.2017 19:02:12          3         4        1    18
#> 3   221 23.01.2017 11:40:30          1         1        1    23
#> 4   230 23.01.2017 16:27:49          1         1        1    23
#> 5    92 17.01.2017 17:18:55          1         1        1    24
#> 6   107 18.01.2017 16:01:36          3         2        1    24
#> 7    25 11.01.2017 20:30:43          2         1        1    25
#> 8   161 20.01.2017 18:00:00          2         1        1    25
#> 9   295 26.01.2017 16:18:27          1         3        1    25
#> 10  302 27.01.2017 08:44:41          1         5        1    25
#> 11   26 11.01.2017 20:38:16          1         3        1    26
#> 12  151 20.01.2017 11:27:08          2         4        1    26
#> 13  205 22.01.2017 18:29:17          2         2        1    26
#> 14   66 15.01.2017 13:28:29          1         3        1    27
#> 15  154 20.01.2017 13:38:19          4         5        1    27
#> 16  224 23.01.2017 12:57:00          2         4        1    28
#> 17  239 23.01.2017 20:00:46          3         4        1    28
#> 18  261 25.01.2017 12:13:25          2         5        1    29
#> 19  262 25.01.2017 12:49:57          1         2        1    29
#> 20  276 25.01.2017 18:54:30          3         6        1    29
#> 21  277 25.01.2017 20:06:34          3         4        1    29
#> 22  121 19.01.2017 11:29:43          1         1        1    31
#> 23  168 20.01.2017 20:04:38          1         1        1    32
#> 24  297 26.01.2017 19:07:14          3         6        1    33
#> 25  122 19.01.2017 11:30:57          2         2        1    34
#> 26   75 15.01.2017 17:31:06          1         2        1    35
#> 27  231 23.01.2017 16:32:32          1         1        1    35
#> 28  169 20.01.2017 20:05:13          3         5        1    37
#> 29   34 12.01.2017 18:57:47          4         7        1    38
#> 30  179 21.01.2017 07:40:05          5         9        1    40
#> 31    4 06.01.2017 09:58:05          2         3        2    18
#> 32  300 27.01.2017 02:14:27          2         3        2    20
#> 33   33 12.01.2017 18:53:43          1         3        2    21
#> 34   13 09.01.2017 09:51:37          1         2        2    22
#> 35   86 16.01.2017 15:31:38          2         4        2    23
#> 36   28 11.01.2017 22:44:23          2         6        2    24
#> 37   30 12.01.2017 13:36:07          3         5        2    24
#> 38   51 14.01.2017 13:55:30          2         5        2    25
#> 39  164 20.01.2017 18:17:03          3         4        2    25
#> 40   20 10.01.2017 18:33:15          3         5        2    26
#> 41   50 14.01.2017 10:53:38          1         3        2    26
#> 42   54 14.01.2017 15:14:50          3         5        2    26
#> 43  208 22.01.2017 18:58:58          1         2        2    27
#> 44  243 24.01.2017 14:15:59          4         4        2    27
#> 45  251 24.01.2017 20:02:38          1         1        2    27
#> 46   70 15.01.2017 15:01:12          3         4        2    28
#> 47   98 17.01.2017 21:59:36          2         2        2    28
#> 48  147 19.01.2017 20:36:23          4         4        2    28
#> 49  190 22.01.2017 11:19:10          3         6        2    28
#> 50  215 22.01.2017 22:00:29          1         2        2    28
#> 51   87 16.01.2017 16:51:20          3         7        2    29
#> 52  127 19.01.2017 14:20:15          2         1        2    29
#> 53  152 20.01.2017 13:02:50          2         4        2    29
#> 54   44 13.01.2017 14:39:57          1         6        2    30
#> 55   57 14.01.2017 15:39:12          2         6        2    30
#> 56  101 18.01.2017 12:32:04          4         7        2    30
#> 57  182 21.01.2017 11:29:16          3         2        2    30
#> 58  192 22.01.2017 11:52:16          2         5        2    30
#> 59   60 14.01.2017 17:14:18          2         7        2    31
#> 60  204 22.01.2017 17:45:23          1         3        2    31
#> 61   46 13.01.2017 18:34:25          3         7        2    32
#> 62   52 14.01.2017 14:46:16          1         9        2    32
#> 63   90 17.01.2017 14:34:13          3         7        2    32
#> 64  304 27.01.2017 09:18:26          3         8        2    32
#> 65   21 10.01.2017 21:17:52          4         7        2    33
#> 66   68 15.01.2017 13:46:04          2         5        2    33
#> 67  233 23.01.2017 17:03:10          2         9        2    33
#> 68  143 19.01.2017 19:15:36          3         6        2    34
#> 69   62 14.01.2017 17:52:29          2         8        2    35
#> 70   93 17.01.2017 19:28:51          3         7        2    35
#> 71  305 27.01.2017 09:52:59          3         8        2    35
#> 72  146 19.01.2017 20:08:34          4         7        2    37
#> 73  189 21.01.2017 20:05:54          4         6        2    37
#> 74  299 26.01.2017 23:10:18          5         4        2    37
#> 75   56 14.01.2017 15:27:10          3         8        2    39
#> 76   58 14.01.2017 15:43:01          3         8        2    40
#> 77  248 24.01.2017 16:29:45          2        10        2    40
#> 78   35 12.01.2017 19:04:43          1         2        3    19
#> 79   71 15.01.2017 15:03:29          3         3        3    20
#> 80  102 18.01.2017 12:48:04          3         3        3    21
#> 81  129 19.01.2017 17:58:02          2         4        3    21
#> 82  186 21.01.2017 16:24:44          2         5        3    21
#> 83  223 23.01.2017 12:53:02          3         1        3    21
#> 84   36 12.01.2017 19:09:14          1         7        3    22
#> 85  220 23.01.2017 11:27:11          3         5        3    22
#> 86  269 25.01.2017 16:31:46          3         3        3    22
#> 87   45 13.01.2017 16:57:26          1         2        3    23
#> 88    8 06.01.2017 17:24:53          2         5        3    24
#> 89   16 09.01.2017 15:52:12          2         5        3    24
#> 90  217 23.01.2017 11:18:51          2         6        3    24
#> 91   32 12.01.2017 18:47:45          1         5        3    25
#> 92   53 14.01.2017 15:04:05          1         2        3    26
#> 93  256 25.01.2017 10:39:53          2         2        3    26
#> 94  273 25.01.2017 17:11:34          3         4        3    26
#> 95  227 23.01.2017 14:30:40          3         8        3    27
#> 96  236 23.01.2017 18:48:02          3         2        3    27
#> 97  237 23.01.2017 19:07:33          3         2        3    27
#> 98   24 11.01.2017 19:38:20          3         2        3    28
#> 99   59 14.01.2017 16:26:40          2         6        3    28
#> 100  61 14.01.2017 17:27:31          3         6        3    28
#> 101  80 15.01.2017 20:39:10          3         6        3    28
#> 102 145 19.01.2017 19:29:43          4         5        3    28
#> 103 173 20.01.2017 21:13:25          2         3        3    28
#> 104 210 22.01.2017 19:45:33          3         5        3    28
#> 105   2 05.01.2017 21:07:56          3         7        3    29
#> 106 176 20.01.2017 23:18:18          3         5        3    29
#> 107 287 26.01.2017 11:56:19          4         8        3    29
#> 108  23 11.01.2017 14:17:26          3         4        3    30
#> 109 114 18.01.2017 22:20:33          1         4        3    30
#> 110 198 22.01.2017 15:07:48          3         7        3    30
#> 111 194 22.01.2017 12:27:59          4         6        3    31
#> 112 250 24.01.2017 18:56:35          3         6        3    32
#> 113  17 09.01.2017 20:49:48          2         5        3    33
#> 114  63 15.01.2017 11:41:07          2         5        3    33
#> 115 199 22.01.2017 15:26:55          3         5        3    33
#> 116 254 25.01.2017 09:33:37          3         7        3    33
#> 117 267 25.01.2017 16:08:48          3         6        3    33
#> 118  94 17.01.2017 19:47:11          3         7        3    34
#> 119 166 20.01.2017 19:03:10          4         6        3    34
#> 120 170 20.01.2017 20:09:15          2         1        3    34
#> 121 218 23.01.2017 11:21:21          3         5        3    34
#> 122 240 24.01.2017 10:19:25          3         6        3    34
#> 123  14 09.01.2017 12:15:48          4         9        3    35
#> 124  38 13.01.2017 07:55:14          3         8        3    35
#> 125  79 15.01.2017 19:54:00          3         4        3    35
#> 126 148 19.01.2017 21:19:10          4         2        3    35
#> 127 244 24.01.2017 14:38:56          3         5        3    35
#> 128 128 19.01.2017 14:29:41          3         6        3    36
#> 129 153 20.01.2017 13:03:25          3         7        3    37
#> 130 252 25.01.2017 08:56:16          5         7        3    38
#> 131 296 26.01.2017 17:12:37          3         6        3    38
#> 132 298 26.01.2017 20:41:21          2         5        3    38
#> 133 303 27.01.2017 08:50:31          5         8        3    38
#> 134  39 13.01.2017 08:54:17          3        10        3    39
#> 135  40 13.01.2017 09:31:06          4         9        3    39
#> 136  64 15.01.2017 11:49:03          3         8        3    39
#> 137 138 19.01.2017 18:23:23          3         9        3    39
#> 138 144 19.01.2017 19:23:57          4         8        3    39
#> 139 292 26.01.2017 15:00:29          4         8        3    39
#> 140  29 12.01.2017 09:48:16          4        10        3    40
#> 141  41 13.01.2017 12:07:29          4        10        3    40
#> 142 257 25.01.2017 10:44:34          2         9        3    40
#> 143 306 27.01.2017 11:29:48          4         9        3    40
#> 144 131 19.01.2017 18:03:45          2         3        4    18
#> 145 266 25.01.2017 15:39:13          2         4        4    22
#> 146  72 15.01.2017 15:30:15          4         4        4    23
#> 147 167 20.01.2017 19:17:44          4         5        4    23
#> 148  37 12.01.2017 19:20:25          3         3        4    24
#> 149 130 19.01.2017 17:58:35          3         1        4    24
#> 150 232 23.01.2017 16:50:14          3         2        4    24
#> 151 123 19.01.2017 12:36:03          1         3        4    25
#> 152 209 22.01.2017 19:39:51          4         4        4    25
#> 153 105 18.01.2017 15:46:15          3         6        4    26
#> 154 120 19.01.2017 10:17:15          3         7        4    26
#> 155 140 19.01.2017 18:37:53          3         7        4    26
#> 156 228 23.01.2017 14:53:46          3         5        4    26
#> 157  81 15.01.2017 20:59:54          3         3        4    27
#> 158 200 22.01.2017 16:21:18          2         5        4    27
#> 159  47 13.01.2017 20:52:32          1         4        4    29
#> 160  73 15.01.2017 15:49:52          4         3        4    29
#> 161 149 20.01.2017 09:02:45          3         5        4    30
#> 162  12 08.01.2017 19:17:20          4         7        4    31
#> 163  78 15.01.2017 18:31:00          3         6        4    31
#> 164 193 22.01.2017 12:17:32          4         5        4    31
#> 165 201 22.01.2017 17:03:55          3         6        4    31
#> 166 229 23.01.2017 15:20:08          5         7        4    31
#> 167 241 24.01.2017 10:28:57          3         4        4    31
#> 168 260 25.01.2017 11:59:11          3         6        4    31
#> 169 280 26.01.2017 03:01:08          4         7        4    31
#> 170  11 08.01.2017 12:56:43          1         2        4    32
#> 171  76 15.01.2017 18:00:15          3         7        4    32
#> 172 100 18.01.2017 11:29:13          4         7        4    32
#> 173 178 20.01.2017 23:54:46          3         6        4    32
#> 174 184 21.01.2017 14:20:14          2         4        4    32
#> 175 212 22.01.2017 21:34:56          4         5        4    32
#> 176  88 16.01.2017 19:03:39          2         7        4    34
#> 177 188 21.01.2017 19:01:18          4         8        4    36
#> 178 279 25.01.2017 23:19:16          4         8        4    36
#> 179 284 26.01.2017 10:46:10          4         5        4    36
#> 180 126 19.01.2017 13:42:49          2         8        4    37
#> 181 268 25.01.2017 16:15:57          4         7        4    38
#> 182 281 26.01.2017 10:13:05          4         7        4    38
#> 183 134 19.01.2017 18:22:43          1         4        4    39
#> 184 135 19.01.2017 18:22:55          3         3        4    39
#> 185  97 17.01.2017 21:51:05          3         3        5    20
#> 186 216 23.01.2017 07:54:17          4         2        5    21
#> 187  55 14.01.2017 15:15:38          3         4        5    22
#> 188  31 12.01.2017 14:09:10          4         8        5    23
#> 189   9 07.01.2017 10:11:17          2         3        5    25
#> 190  69 15.01.2017 14:10:13          3         6        5    25
#> 191 112 18.01.2017 19:41:09          3         5        5    26
#> 192  95 17.01.2017 20:52:29          2         4        5    27
#> 193 109 18.01.2017 17:47:57          2         4        5    27
#> 194 203 22.01.2017 17:22:06          3         4        5    27
#> 195 222 23.01.2017 12:06:58          3         6        5    27
#> 196  82 15.01.2017 21:05:53          3         2        5    28
#> 197   1 05.01.2017 13:57:01          5         8        5    29
#> 198 282 26.01.2017 10:19:49          5         8        5    29
#> 199  27 11.01.2017 20:49:19          2         4        5    30
#> 200  48 13.01.2017 21:50:03          2         4        5    30
#> 201 219 23.01.2017 11:24:30          2         7        5    30
#> 202 263 25.01.2017 13:04:33          3         8        5    31
#> 203  18 09.01.2017 22:57:38          3         3        5    32
#> 204  77 15.01.2017 18:21:19          4         5        5    32
#> 205  10 07.01.2017 18:10:05          4         5        5    33
#> 206 156 20.01.2017 17:28:23          4         7        5    33
#> 207  85 16.01.2017 13:56:29          3         6        5    34
#> 208 115 18.01.2017 23:00:36          4         5        5    34
#> 209 177 20.01.2017 23:37:45          4         7        5    34
#> 210 259 25.01.2017 11:37:19          5         7        5    34
#> 211  84 16.01.2017 13:51:51          4         8        5    35
#> 212 103 18.01.2017 13:32:09          4         7        5    35
#> 213 174 20.01.2017 22:58:35          5         8        5    35
#> 214 165 20.01.2017 18:57:33          2         8        5    36
#> 215 278 25.01.2017 21:08:40          5         6        5    36
#> 216  96 17.01.2017 20:55:48          4         7        5    37
#> 217 171 20.01.2017 20:29:52          4         9        5    37
#> 218  22 11.01.2017 13:32:30          4         9        5    38
#> 219 113 18.01.2017 21:44:02          5         8        5    38
#> 220 181 21.01.2017 08:26:17          4         9        5    38
#> 221 258 25.01.2017 11:25:38          5         9        5    38
#> 222 108 18.01.2017 16:38:36          5         8        5    39
#> 223 137 19.01.2017 18:22:58          4        10        5    39
#> 224 264 25.01.2017 13:11:14          4        10        5    39
#> 225 116 18.01.2017 23:07:32          4         8        5    40
#> 226 175 20.01.2017 23:03:36          5        10        5    40
#> 227 185 21.01.2017 15:01:26          4        10        5    40
#> 228 196 22.01.2017 13:38:56          4        10        5    40
#> 229 197 22.01.2017 14:55:17          4        10        5    40
#> 230  65 15.01.2017 12:41:27          3         6        6    22
#> 231 214 22.01.2017 21:57:36          2         6        6    31
#> 232 301 27.01.2017 08:17:59          4         8        6    33
#> 233   5 06.01.2017 14:13:08          4         8        6    34
#> 234 172 20.01.2017 20:42:46          5        10        6    34
#> 235  43 13.01.2017 14:14:16          4         8        6    36
#> 236 110 18.01.2017 18:53:02          5         8        6    37
#> 237 136 19.01.2017 18:22:57          3         1        6    39
#> 238   3 05.01.2017 23:33:47          5        10        6    40
#> 239 206 22.01.2017 18:42:49         NA        NA       NA    20
#> 240 235 23.01.2017 18:26:20         NA        NA       NA    20
#> 241  19 10.01.2017 17:16:48         NA        NA       NA    22
#> 242 195 22.01.2017 13:24:51         NA        NA       NA    23
#> 243 283 26.01.2017 10:39:44         NA        NA       NA    23
#> 244  67 15.01.2017 13:30:48         NA        NA       NA    24
#> 245 246 24.01.2017 15:09:44         NA        NA       NA    24
#> 246 187 21.01.2017 16:27:32         NA        NA       NA    26
#> 247 238 23.01.2017 19:53:10         NA        NA       NA    27
#> 248 207 22.01.2017 18:56:56         NA        NA       NA    28
#> 249 242 24.01.2017 14:09:33         NA        NA       NA    28
#> 250 245 24.01.2017 14:56:24         NA        NA       NA    28
#> 251 247 24.01.2017 15:37:27         NA        NA       NA    28
#> 252 270 25.01.2017 16:35:41         NA        NA       NA    28
#> 253 288 26.01.2017 13:36:14         NA        NA       NA    28
#> 254  91 17.01.2017 15:19:36         NA        NA       NA    29
#> 255 213 22.01.2017 21:47:06         NA        NA       NA    29
#> 256 255 25.01.2017 10:05:00         NA        NA       NA    29
#> 257  15 09.01.2017 15:23:15         NA        NA       NA    30
#> 258  74 15.01.2017 16:12:54         NA        NA       NA    30
#> 259 125 19.01.2017 13:03:26         NA        NA       NA    30
#> 260 265 25.01.2017 13:14:00         NA        NA       NA    30
#> 261 139 19.01.2017 18:35:56         NA        NA       NA    31
#> 262 157 20.01.2017 17:34:48         NA        NA       NA    31
#> 263 183 21.01.2017 12:20:37         NA        NA       NA    31
#> 264 289 26.01.2017 14:19:14         NA        NA       NA    31
#> 265 124 19.01.2017 12:51:10         NA        NA       NA    32
#> 266 150 20.01.2017 09:53:47         NA        NA       NA    32
#> 267 118 19.01.2017 08:54:43         NA        NA       NA    33
#> 268  89 16.01.2017 21:18:05         NA        NA       NA    34
#> 269 141 19.01.2017 18:44:32         NA        NA       NA    34
#> 270 159 20.01.2017 17:57:26         NA        NA       NA    34
#> 271 160 20.01.2017 17:59:19         NA        NA       NA    34
#> 272 271 25.01.2017 16:53:17         NA        NA       NA    34
#> 273 275 25.01.2017 18:06:36         NA        NA       NA    34
#> 274 285 26.01.2017 10:54:41         NA        NA       NA    34
#> 275 294 26.01.2017 15:51:56         NA        NA       NA    34
#> 276 162 20.01.2017 18:00:53         NA        NA       NA    35
#> 277 158 20.01.2017 17:53:16         NA        NA       NA    36
#> 278 163 20.01.2017 18:04:21         NA        NA       NA    36
#> 279 191 22.01.2017 11:31:27         NA        NA       NA    36
#> 280 202 22.01.2017 17:13:02         NA        NA       NA    36
#> 281 226 23.01.2017 14:17:10         NA        NA       NA    36
#> 282 272 25.01.2017 17:03:21         NA        NA       NA    36
#> 283 290 26.01.2017 14:34:23         NA        NA       NA    36
#> 284 293 26.01.2017 15:17:47         NA        NA       NA    36
#> 285  99 18.01.2017 09:04:30         NA        NA       NA    37
#> 286 111 18.01.2017 19:24:49         NA        NA       NA    37
#> 287 117 19.01.2017 08:06:05         NA        NA       NA    37
#> 288 274 25.01.2017 17:38:36         NA        NA       NA    37
#> 289  42 13.01.2017 14:08:08         NA        NA       NA    38
#> 290 106 18.01.2017 15:52:04         NA        NA       NA    38
#> 291 133 19.01.2017 18:22:38         NA        NA       NA    38
#> 292 211 22.01.2017 20:28:43         NA        NA       NA    38
#> 293 286 26.01.2017 11:19:10         NA        NA       NA    38
#> 294   6 06.01.2017 14:21:18         NA        NA       NA    39
#> 295  49 14.01.2017 07:02:39         NA        NA       NA    39
#> 296 104 18.01.2017 13:42:20         NA        NA       NA    39
#> 297 155 20.01.2017 15:33:55         NA        NA       NA    39
#> 298 180 21.01.2017 08:04:17         NA        NA       NA    39
#> 299 225 23.01.2017 13:24:22         NA        NA       NA    39
#> 300 253 25.01.2017 09:32:55         NA        NA       NA    39
#> 301 291 26.01.2017 14:55:17         NA        NA       NA    39
#> 302   7 06.01.2017 14:25:49         NA        NA       NA    40
#> 303  83 16.01.2017 10:16:52         NA        NA       NA    40
#> 304 119 19.01.2017 09:05:01         NA        NA       NA    40
#> 305 132 19.01.2017 18:22:32         NA        NA       NA    40
#> 306 249 24.01.2017 17:19:54         NA        NA       NA    40
```


Einige Anmerkungen. Die generelle Syntax lautet `arrange(df, Spalte1, ...)`, wobei `df` den Dataframe bezeichnet und `Spalte1` die erste zu sortierende Spalte; die Punkte `...` geben an, dass man weitere Parameter übergeben kann. Am wichtigsten ist hier, dass man weitere Spalten übergeben kann. Dazu gleich mehr.

Standardmäßig sortiert `arrange` *aufsteigend*  (weil kleine Zahlen im Zahlenstrahl vor den großen Zahlen kommen). Möchte man diese Reihenfolge umdrehen (große Werte zuert), so kann man ein Minuszeichen vor den Namen der Spalte setzen.

Gibt man *zwei oder mehr* Spalten an, so werden pro Wert von `Spalte1` die Werte von `Spalte2` sortiert etc; man betrachte den Output des Beispiels oben dazu.

Merke:

>    Die Funktion arrange sortiert die Zeilen eines Datafames.

Ein Sinnbild zur Verdeutlichung:


```r
knitr::include_graphics("./images/arrange.pdf")
```

<img src="./images/arrange.pdf" width="70%" style="display: block; margin: auto;" />



Ein ähnliches Ergebnis erhält mit man `top_n()`, welches die `n` kleinsten *Ränge* widergibt:


```r
top_n(stats_test, 3)
#> Selecting by score
#>      X                 V_1 study_time self_eval interest score
#> 1    3 05.01.2017 23:33:47          5        10        6    40
#> 2    7 06.01.2017 14:25:49         NA        NA       NA    40
#> 3   29 12.01.2017 09:48:16          4        10        3    40
#> 4   41 13.01.2017 12:07:29          4        10        3    40
#> 5   58 14.01.2017 15:43:01          3         8        2    40
#> 6   83 16.01.2017 10:16:52         NA        NA       NA    40
#> 7  116 18.01.2017 23:07:32          4         8        5    40
#> 8  119 19.01.2017 09:05:01         NA        NA       NA    40
#> 9  132 19.01.2017 18:22:32         NA        NA       NA    40
#> 10 175 20.01.2017 23:03:36          5        10        5    40
#> 11 179 21.01.2017 07:40:05          5         9        1    40
#> 12 185 21.01.2017 15:01:26          4        10        5    40
#> 13 196 22.01.2017 13:38:56          4        10        5    40
#> 14 197 22.01.2017 14:55:17          4        10        5    40
#> 15 248 24.01.2017 16:29:45          2        10        2    40
#> 16 249 24.01.2017 17:19:54         NA        NA       NA    40
#> 17 257 25.01.2017 10:44:34          2         9        3    40
#> 18 306 27.01.2017 11:29:48          4         9        3    40
top_n(stats_test, 3, interest)
#>     X                 V_1 study_time self_eval interest score
#> 1   3 05.01.2017 23:33:47          5        10        6    40
#> 2   5 06.01.2017 14:13:08          4         8        6    34
#> 3  43 13.01.2017 14:14:16          4         8        6    36
#> 4  65 15.01.2017 12:41:27          3         6        6    22
#> 5 110 18.01.2017 18:53:02          5         8        6    37
#> 6 136 19.01.2017 18:22:57          3         1        6    39
#> 7 172 20.01.2017 20:42:46          5        10        6    34
#> 8 214 22.01.2017 21:57:36          2         6        6    31
#> 9 301 27.01.2017 08:17:59          4         8        6    33
```

Gibt man *keine* Spalte an, so bezieht sich `top_n` auf die letzte Spalte im Datensatz.



#### Datensatz gruppieren mit `group_by`

Einen Datensatz zu gruppieren ist ebenfalls eine häufige Angelegenheit: Was ist der mittlere Umsatz in Region X im Vergleich zu Region Y? Ist die Reaktionszeit in der Experimentalgruppe kleiner als in der Kontrollgruppe? Können Männer schneller ausparken als Frauen? Man sieht, dass das Gruppieren v.a. in Verbindung mit Mittelwerten oder anderen Zusammenfassungen sinnvol ist; dazu im nächsten Abschnitt mehr.


```r
knitr::include_graphics("./images/group_by.pdf")
```

<img src="./images/group_by.pdf" width="70%" style="display: block; margin: auto;" />

In der Abbildung wurde der Datensatz anhand der Spalte `Fach` in mehrere Gruppen geteilt. Wir könnten uns als nächstes z.B. Mittelwerte pro Fach - d.h. pro Gruppe (pro Ausprägung von `Fach`) - ausgeben lassen; in diesem Fall vier Gruppen (Fach A bis D).


```r
test_gruppiert <- group_by(stats_test, interest)
test_gruppiert
#> Source: local data frame [306 x 6]
#> Groups: interest [7]
#> 
#>       X                 V_1 study_time self_eval interest score
#>   <int>              <fctr>      <int>     <int>    <int> <int>
#> 1     1 05.01.2017 13:57:01          5         8        5    29
#> 2     2 05.01.2017 21:07:56          3         7        3    29
#> 3     3 05.01.2017 23:33:47          5        10        6    40
#> 4     4 06.01.2017 09:58:05          2         3        2    18
#> 5     5 06.01.2017 14:13:08          4         8        6    34
#> 6     6 06.01.2017 14:21:18         NA        NA       NA    39
#> # ... with 300 more rows
```

Schaut man sich nun den Datensatz an, sieht man erstmal wenig Effekt der Gruppierung. R teilt uns lediglich mit `Groups: interest [7]`, dass es die Gruppen gibt, aber es gibt keine extra Spalte oder sonstige Anzeichen der Gruppierung. Aber keine Sorge, wenn wir gleich einen Mittelwert ausrechnen, bekommen wir den Mittelwert pro Gruppe!



Merke:
>    Mit *group_by*  teilt man einen Datensatz in Gruppen ein, entsprechend der Werte einer mehrerer Spalten.


