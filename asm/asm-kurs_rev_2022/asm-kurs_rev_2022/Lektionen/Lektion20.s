
ASSEMBLERKURS - LEKTION 20 (unfertige Lektion)
( 20 Lektionen - sieht einfach besser aus! )

1. Diskette
1.1 Demo (Programm) direkt von Diskette starten

In Listing20a.s wird eine einfache Methode gezeigt, wie wir eine Demo 
(Programm) direkt von Diskette starten können.

1.2 Allgemeine Infos zu Disketten:

Die normale Amiga 3,5"-Diskette (2DD), 2 steht für "double-sided" und DD für
"double-density" hat zwei Speicherseiten, eine obere und eine untere.

Jede Seite hat 80 Tracks (Spuren). Wobei sich Track 0 auf dem äußersten
konzentrischen Ring und Track 79 auf dem innersten befindet. Die Tracks
mit der gleichen Tracknummer auf beiden Seiten der Diskette werden Zylinder
genannt. Jeder Track teilt sich in 11 Sektoren. Jeder Sektor hat eine
Speichergröße von 512kB.

Zusammengefasst:
Jede Diskette hat 2 Seiten.
Jede Diskette hat 80 Tracks auf beiden Seiten.
Jede Diskette hat 80 Zylinder.
Jeder Track hat 11 Sektoren. 
Jeder Sektor speichert 512 Bytes (Nutzdaten).
Jede Diskette hat somit 2*80*11=1760 Sektoren.
Damit ermittelt sich die Speichergröße einer Diskette zu 
1760 * 512 Bytes= 901120 Bytes, oder 901120 Bytes/1024=880 kBytes

Einfachheithalber wird später von Blöcken bzw. Blocknummern gesprochen und zwar
sind alle 1760 Sektoren die 1760 Blöcke. 

Die Formel zur Berechnung der Blocknummer ist dabei wie folgt:
Block = 2*ll*Zylinder + ll*Seite + Sektor 
(obere Seite = 0, untere Seite =1)

Blocknummer:	Adresse:
0							; Bootblock (bzw. Bootsektor)
1							; Bootblock (bzw. Bootsektor)
2
...
880							; root-block
...

Das Diskettenlaufwerk hat zwei Leseköpfe auf beiden Seiten die immer 
parallel den gleichen Sektor lesen oder schreiben. 

; Listing20b.s 		RT - Read Track von Diskette mit ASMone
;					WT - Write Track auf Diskette mit ASMone

; Listing20b2.s 	RS - Read Sector von Diskette mit ASMone
;					WS - Write Sector

1.3 Bootblock

Der Bootblock ist zwei Sektoren lang (1024 Bytes) und startet bei Sektor 0.

; Listing20b3.s		Bootloader-Programm mit Betriebssystem-Funktionen
