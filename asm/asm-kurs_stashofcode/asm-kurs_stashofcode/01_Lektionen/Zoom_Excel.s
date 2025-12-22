
Grundsätzlich beträgt die Breite eines Bildes, das durch Zoomen verkleinert
werden kann, während es auf dem Bildschirm zentriert bleibt, 306 (siehe zoom.s
für Erklärungen).

Beim horizontalen Zoomen wird das letzte Pixel in jeder Gruppe von 16 Pixeln
durch Hardware-Zoom verborgen. Was hier in jeder Zeile berechnet wird, ist die
Anzahl der Gruppen, die das Bild enthält, wenn es eine bestimmte Breite 
erreicht hat, um daraus die Anzahl der Spalten abzuleiten, die man in diesen
Gruppen durch Hardware-Zoom verbergen kann.

Daraus wird die Breite des nächsten Bildes berechnet, wenn alle Spalten, die
versteckt werden konnten, versteckt wurden und das Bild durch Software-Zoom 
aktualisiert werden muss, indem diese Spalten wirklich entfernt werden.

Die Aktualisierung des Bildes ist nicht auf das Entfernen der Spalten
beschränkt. Wenn die Möglichkeiten des Hardware-Zooms ausgeschöpft sind, wird
die Bitplane, in der M <= 15 Spalten in zoombaren Gruppen verborgen wurden, um
N Pixel nach rechts verschoben. Das neue Bild muss nun in einer Bitplane
angezeigt werden, in der keine Spalten verborgen sind, und die um 7 Pixel nach
rechts verschoben ist. Um also im Bild das zu reproduzieren, was auf dem 
Bildschirm zu sehen ist, müssen wir nicht nur die Spalten entfernen, sondern
auch das Bild um N - 7 Pixel nach rechts in die Bitplane verschieben.

Um also von einem Schritt I zu I + 1 einem anderen zu gelangen, muss man:

1/ Löschen Sie im Bild die Anzahl der Spalten, die unter "Gezoomte Gruppen" 
   in Zeile I angegeben ist.

2/ Verschieben Sie das so reduzierte Bild in der Bitplane um die unter 
   "Verschieben" in Zeile I + 1 angegebene Anzahl von Pixeln nach rechts.

3/ Hardware-Zoom zurücksetzen, indem Sie alle Änderungen an BPLCON1 in der 
  Zeile löschen und die Initialisierung von BPLCON1 am Zeilenanfang auf den
  Wert setzen, der unter "BPLCON1 initial" in Zeile I + 1 angegeben ist, also
  immer 7.

Daraus ergibt sich, dass Sie 57 Schritte durchlaufen müssen, um ein 306 Pixel
breites Bild auf 15 Pixel zu verkleinern (ab diesem Wert kann es nicht mehr
verkleinert werden).

Beachten Sie, dass in jedem Schritt zwischen belegter, zoombarer und gezoomter
Gruppe unterschieden wird :

- Eine Gruppe ist belegt, wenn die Zeichnung mindestens 1 Pixel dieser Gruppe
  belegt.

- Eine Gruppe ist zoombar, wenn diese Gruppe belegt ist und das Bild 
  insbesondere seinen 16. Pixel belegt (den, den man durch Hardware-Zoom 
  verbergen kann).

- Eine Gruppe ist gezoomt, wenn sie zoombar ist und das Bild durch Hardware-
  Zoom tatsächlich seinen 16. Pixel verdeckt (denn durch Hardware-Zoom lassen
  sich höchstens 15 Spalten verdecken).


Beschreibung der vorberechneten Daten :

Für jeden Schritt, an dessen Ende ein Software-Zoom angewendet werden muss, weil
die Möglichkeiten des Hardware-Zooms ausgeschöpft sind:

1/ Der Rechtsversatz, der auf das Bild in der Bitplane angewendet werden soll, 
   ausgedrückt als Linksversatz im DESC-Modus (dies ist der Versatz der ersten
   Gruppe, der Versatz der nachfolgenden Gruppen kann größer sein, während 
   Pixel entfernt werden und das Bild daher nach links gequetscht werden muss).

2/ Der Index der ersten Gruppe in der Bitplane, die Pixel des Bildes enthält
  (dies ist also die erste der Gruppen, die durch Verschieben nach rechts in
  die Bitplane kopiert werden soll).

3/ Die Anzahl der nicht gezoomten Gruppen links von den gezoomten Gruppen 
 (dies ist also die Anzahl der Gruppen, die kopiert werden müssen, ohne ihr
 letztes Pixel zu löschen, indem sie einfach nach rechts in die Bitplane
 verschoben werden).

4/ Die Anzahl der gezoomten Gruppen (das ist also die Anzahl der Gruppen, deren
 letztes Pixel beim Kopieren entfernt werden muss, was dazu führt, dass der 
 Rechtsversatz in der Bitplane bei jeder Gruppe dekrementiert wird).

5/ Die Anzahl der nicht gezoomten Gruppen rechts von den gezoomten Gruppen 
(das ist also die Anzahl der Gruppen, die man kopieren muss, ohne ihr letztes
Pixel zu löschen, indem man sie einfach nach rechts in der Bitplane verschiebt).

Diese Daten werden in Form einer BYTE-Deklaration in der Reihenfolge 
4-1-2-3-5 zusammengestellt. Diese Deklaration endet mit einem BYTE 0.

