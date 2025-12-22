
; Listing2c.s

Anfang:
	LEA	HUND,a0
	MOVE.L	#HUND,a1
	MOVE.L	HUND,a2
	move.l	a0,KATZE1
	move.l	a1,KATZE2
	move.l	a2,KATZE3
	rts

HUND:
	dc.l	$12345678

KATZE1:
	dc.l	0

KATZE2:
	dc.l	0

KATZE3:
	dc.l	0

	END


Assembliert, macht ein D Anfang um zu kontrollieren auf  welchen  Adressen
die  Label  liegen, dann führt mit J aus. Ihr werdet feststellen, daß nach
dem J die Liste der Register auch negative Ziffern anführt:

D0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
A0: ZIFFER   ZIFFER   12345678 00000000 00000000 00000000 00000000 ZIFFER (SP)
SSP= ..... USP= SR.....   

Jedes  Mal,  wenn  ein  Listing  ausgeführt  wird,  werden  alle  Register
angezeigt: Die erste Zeile ist die der D0,D1,D2,D3,D4,D5,D6,D7, die zweite
die der a0,a1,a2,a3,a4,a5,a6,a7. Darunter befinden sich Register, über die
wir später reden werden. Die Ziffer in  A7  ist  der  aktuelle  SP  (Stack
Pointer),  er  interessiert uns im Moment nicht. Kontrolliert hingegen die
Ziffern in A0, A1 und A2: die ersten  sind  zwei  identische  Ziffern,  in
diesem Fall die Adresse von HUND:, denn die zwei Befehle

	LEA	HUND,a0			; Schneller als MOVE.L #HUND,A! So ist´s richtig!
	MOVE.L	#HUND,a1

tun das Gleiche, sie kopieren die Adresse der Label in ein Register. In A2
hingegen  ist  ein  12345678 zu finden, also den Inhalt des Longword HUND:
der Befehl MOVE.L HUND,a2 hat den Inhalt  von  HUND  in  a2  gegeben.  Für
weitere  Kontrollen,  macht  ein  M  HUND  nach  dem  J,  und  ihr  werdet
feststellen, daß HUND auf der gleichen Adresse ist wie die, die in a0  und
a1 aufscheint. Danach könnt ihr auch mit M KATZE1 und M KATZE2 prüfen, daß
diese zwei Longword die Adresse von KATZE enthalten, denn die wird mit den
zwei Befehlen

	MOVE.L	a0,KATZE1
	MOVE.L	a1,KATZE2

kopiert. Zum Schluß, mit M KATZE3, kann verifiziert werden,  daß  sie  den
Inhalt des Longword KATZE enthält, $12345678. Um diese drei Kontrollen auf
einmal zu erledigen, könnt ihr ein M KATZE1 tippen und des öfteren  RETURN
drücken:  in den ersten 4 Bytes werdet ihr die Adresse von HUND vorfinden,
in den nächsten 4 die gleiche  Adresse,  in  den  folgenden  4  Bytes  den
.L-Inhalt  von HUND. eben $12345678. Wenn man dieses Spiel fortführt, wird
man Ziffern antreffen, die keinen Sinn ergeben:  entweder  ist  es  leerer
Speicher oder er ist von weiß Gott was besetzt. Wenn ihr einige Änderungen
vornehmen wollt, dann könnt ihr vor dem RTS diese Zeilen einfügen:

	MOVE.L	A0,D0
	MOVE.L	A1,D1
	MOVE.L	A2,D2

Ihr  werdet  nach  dem  J  auch  eine  Änderung   in   den   ersten   drei
DATEN-Registern  erhalten. Bemerkung: Wie ihr gesehen habt, ist es besser,
ein LEA als ein MOVE #LABEL,a0 zu verwenden, aber Achtung!! Lea  kann  nur
dazu  verwendet  werden,  eine Adresse in ein ADRESSREGISTER zu geben!! Es
geht nicht z.B. ein LEA LABEL,d0 zu machen!! Um die Adresse  eines  Labels
in  ein  Datenregister oder ein anderes Label zu geben, müßen nach wie vor
MOVE.L #LABEL,Bestimmungsort verwendet werden!  Bemerkung2:  Normalerweise
gibt  man  in  a0,  a1, a2 Adressen, und in d0, d1, d2 verschiedene Daten,
aber es kann  schon  mal  vorkommen,  daß  Daten  in  Adressregistern  und
Adressen in Datenregistern landen. Um euch eine Idee davon zu verschaffen,
für was sie gut sind: es sind wie Notizzettel, auf denen ihr eine  gewisse
Anzahl  von  Telefonnummern Platz habt und auf denen ihr festhält, wieviel
ihr ausgegeben habt, um euch ein Eis zu kaufen, sie sind also nützlich und
SCHNELL!  Sie  können  verwendet  werden,  wie  man  will, hauptsache, man
erinnert sich, was wo drin ist!!!

