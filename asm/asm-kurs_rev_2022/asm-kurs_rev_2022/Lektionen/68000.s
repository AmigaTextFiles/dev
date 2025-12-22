
; REFERENZTABELLE FÜR DIE 68000er PROGRAMMIERUNG

Synthetisch zusammengefaßt: Die Adressierungen:

 move.l #123,xxxx	  ; Immediate: die Zahl 123 kommt sofort ins xxxx
 move.l xxxx,$50000	  ; Absolut long
 move.l xxxx,$500.w	  ; Absolut kurz (weniger als $7FFF)
 move.l xxxx,D0		  ; Datenregister direkt
 move.l xxxx,A0		  ; Adressregister direkt
 move.l xxxx,(A0)	  ; Datenregister indirekt
 move.l xxxx,(A0)+	  ; Adressregister indirekt mit Post-Inkrement
 move.l xxxx,-(A0)	  ; Adressregister indirekt mit Pre-Dekrement
 move.l xxxx,$123(A0)	  ; Adressregister indirekt mit Offset (Adressdistanz)
 move.l xxxx,$12(a0,d0.w)    ; Adressregister indirekt mit Offset und Index
 move.l Offset(PC),xxxx	     ; Relativ zum PC mit Offset
 move.l Offset(PC,d0.w),xxxx ; Relativ zum PC mit OFFSET

			-	-	-

*  Die  verschiedensten  Adressierungsarten  kann  man  in  Befehlen   mit
Datenquelle und Datenziel "mischen", z.B. "move.l -(A0),12(a0,d3.l)".

			-	-	-

* Die Dezimalzahlen werden von keinem Symbol  angeführt  (z.B.  123),  die
Hexadezimalzahlen  von  einem  $ (z.B. $1a0). Hexzahlen enthalten auch die
Buchstaben von A bis F. Binärzahlen werden von  einem  %  angeführt,  z.B.
%10010110,  sie bestehen nur aus 0 und 1 (Strom oder nicht im Draht!). Die
Konvertierung  untereinander  der  drei   Zahlensysteme   bereitet   keine
Probleme,  da  es unter dem ASMONE den "?"-Befehl gibt, gefolgt von der zu
konvertierenden Zahl. Als Resultat erhält man das Äquivalente in  Dezimal,
Hexadezimal  und  ASCII,  also  CHARAKTERN:  denn  auch die Buchstaben wie
"ABCDabcde..." sind nur durch ein Byte dargestellt. So ist  z.B.  das  "Z"
$5a   (Probiert   ?"z").  Um  Charakter  anzugeben  setzt  man  sie  unter
Gänsefüßchen ("" oder ´´), und man kann sie mit den  Befehlen  kombinieren
(z.B.  MOVE.B  #"a",Label1) oder mit dem DC.B direkt in den Speicher geben
(DC.B "Ein Text im Speicher").

			-	-	-

* In Assembler wird die Multiplikation durch * dargestellt,  die  Division
durch  /,  und  man  kann runde Klammern verwenden, wieviel man will, z.B:
move.l #(100/2*(12+$41-32)+%01101010),RESULTAT

* 1 byte = 8 bit ($00 = %00000000; $FF = %11111111)
  1 word = 16 bit ($0000 = %0000000000000000; $FFFF = %1111111111111111)
  1 long = 32 bit, ossia 2 words ($00000000 = %000000000000000000000000000000)

			-	-	-

Bei Bits zählt man folgens: von 0 rechts nach links: z.B.  ein  Byte,  das
Bit  5 auf 1 hat (oder High): $00100000. Bei einem Byte gehen die Bits von
0 (niederwertigsten) zum siebten (höchstwertigsten), ein Word  von  0  bis
15,  ein Longword von 0 bis 31. Um Bits leicht numerieren zu können, könnt
ihr diesen Trick verwenden:

		; 5432109876543210	- ein word
	move.l  #%1000010000110000,d0   ; bit 15,10,5 e 4 High (auf 1)

			-	-	-

*Adressen werden per Konvention durch Hexzahlen dargestellt.

			-	-	-

*  Befehle  mit  dem "#"-Symbol, wie etwa MOVE.L #123,d0, CMP.L #10,LABEL1
etc. betrachten die Zahl nach dem Lattenzaun (#) wie eine konstante  Zahl,
also wirklich als "Nummer", nicht als Adresse, zum Unterschied wenn kein #
vorhanden ist: move.b $12,$45 kopiert das Byte aus Adresse $12 in  Adresse
$45, während move.b #$12,$45 die Zahl $12 in Adresse $45 kopiert.

			-	-	-

* Die DATENREGISTER und die ADRESSREGISTER sind alle 32 Bit lang, also ein
Longword.  Auf Adressregistern kann man nur mit .W oder .L arbeiten, nicht
mit .B.

			-	-	-

* Auf ungeraden Adressen kann  man  nicht  mit  .W  oder  .L-Instruktionen
arbeiten,  nur  mit .B. Ein move.l #1,$10001 schickt den computer in GURU,
während ein move.b #1,$10001 keine Probleme verursacht.

			-	-	-

*  Ein Byte kann eine Zahl zwischen $00 und $FF (255) enthalten, wenn dann
noch etwas addiert wird, startet die Zahl wieder  bei  NULL.  Das  gleiche
gilt  für  das  Word, bei dem $FFFF die größte, darstellbare Zahl ist, und
für das Longword. Dies hat max. $FFFFFFFF.

			-	-	-

* Das LABEL,  die  KOMMENTARE  nach  den  ";"  und  die  DC.x  sind  keine
68000erBefehle,  aber  Assemblerbefehle, die es uns ermöglichen, Punkte im
Listing (z.B. Daten oder Routinen) zu markieren, Kommentare einzufügen, um
das  Listing klarer und verständlicher zu gestalten oder Bytes, Words oder
Longwords direkt an einen bestimmten Punkt im Speicher  zu  geben  (DC.x).
Das  kann  verifiziert  werden,  indem  man den Speicher mit dem Befehl "D
$xxxx" oder "D LABEL" disassembliert.


**  **  **  **  **  **  **  **  **  **  **  **  **  **  **  **

; ADRESSIERUNGEN DES 68000 (Beispiele)

; Adressierungen mit absoluten Adressen, .L (Longword)

 move.l #$123,$50000	; wir geben $00000123 in $50000. Die Nullen links sind
			; Optional, denn move.l #$00000123,xxx unterscheidet
			; sich nicht von move.l #$123,xxx, im Speicher werden
			; die Nullen immer trotzdem angehängt.
			; ZU BEACHTEN ist, daß mit diesem .L-Befehl vier
			; Bytes im Speicher verändert werden, also die Bytes an
			; Adresse $50000, $50001, $50002 und $50003, die
			; folgende Werte erhalten:
			; $50000 = $00
			; $50001 = $00
			; $50002 = $01
			; $50003 = $23

			-	-	-

; Adressierungen mit absoluten Adressen, .W (Word)

 move.w #$123,$50000	; Wir geben $0123 in Adresse $50000 - Mit dieser
			; .W - Instruktion haben wir zwei Bytes verändert,
			; da ein Word 2 Bytes lang ist, und zwar die
			; Adressen $50000 und $50001:
			; $50000 = $01
			; $50001 = $23

			-	-	-

; Adressierungen mit absoluten Adressen, .B (Byte)

 move.B #$12,$50000	; Wir geben $12 in Adresse $50000. Mit diesem .b-Befehl
			; haben wir 1 Byte modifiziert, und zwar das an
			; Adresse $50000 = $12.
			; PASST GUT AUF DIE UNTERSCHIEDE AUF, DIE EINTRETEN,
			; WENN IHR EINFACH .L, .W UND .B VERTAUSCHT. In der Tat
			; liegen oft Fehler der Anfänger darin, diese drei
			; Typen zu vertauschen oder ihrer falschen Einschätzung
			; Verwendet den Debugger ("AD"), dann die > Taste um
			; auch die letztn Zweifel auszuschalten.

 move.l $40000,$50000	; In diesem Fall geben wir den Inhalt aus Byte
			; $40000, $40001, $40002 und $40003 in die vier
			; Bytes ab $50000, also in das Byte $50000, $50001,
			; $50003 und $50004. Wenn z.B. $40000 = 00102305 war:
			; $50000 = $00
			; $50001 = $10
			; $50002 = $23
			; $50003 = $04
			; Auf die gleiche Weise kopieren wir mit einem
			; .W oder .B von einer Adresse zu anderen jeweils
			; zwei Bytes oder eines.

			-	-	-
							  
BEMERKUNG: Wenn wir LABEL verwenden, um Daten im  Speicher  zu  verändern,
werden  sie  vom Assembler in die EFFEKTIVEN ADRESSEN umgewandelt, die sie
darstellen. Da Label ja Punkte im Speicher markieren, wie  Etiketten  oder
Schildchen,  werden wir uns auf genau diesen Punkt beziehen, wenn wir eine
in irgend einer Art ansprechen oder aufrufen. Befehle  wie  die  folgenden
sind dann auch bei der absoluten Adressierung mit beinhaltet:

	MOVE.L	LABEL1,$50000
	MOVE.W	#$123,LABELBLAU
	MOVE.B	LABELHUND,LABELKATZE

Diese werden im Speicher dann immer in ähnlicher Weise dastehen:

	MOVE.L	$64230,$50000	; angenommen LABEL1 sei auf $64230
	MOVE.W	#$123,$726e0	; angenommen LABEL1 sei auf $726e0
	MOVE.B	$23450,$3a010	; wie oben...

Also, mit Bytes, Words oder Longwords, die mit Labels gekennzeichnet sind,
müßt  ihr umgehen, als seien es Adressen, den, einmal ASSEMBLIERT, SIND ES
ADRESSEN!!!

Deswegen wird bei folgendem Befehl

	MOVE.L	#LABEL1,$dff080	; Verwendet, um unsere Copperlist
				; "anzupeilen"

in $dff080 die Adresse von LABEL1 gegeben, und nicht die vier  Bytes,  die
ab  LABEL1  stehen:  weil  LABEL1  in ihre äquivalente Adresse konvertiert
wird, und da es nach einem # steht, wird diese Adresse  als  ("konstante")
Zahl  betrachtet, und somit wird diese Zahl in $dff080 kopiert. Machen wir
ein Beispiel:

	MOVE.L	#LABEL1,LABEL2
	MOVE.L	LABEL1,LABEL2

Werden  so  assembliert:  (Für  das  Label  werden  hypotetische  Adressen
angenommen)

	MOVE.L	#$42300,$53120	; In $53120 kommt die Zahl $42300,
				; also die Adresse des Label
	MOVE.L	$42300,$53120	; In $53120 wird das Longword kopiert,
				; das sich ab Adresse $42300 befindet


			-	-	-
							  
Es ist möglich,  sich  auf  elegantere  Weise  auf  absolute  Adressen  zu
beziehen, wenn sie kleiner als das Word sind, also $7FFF, indem man ein .W
nach der Adresse anhängt: das ist z.B. der Fall bei Move.L 4.w,A6, das die
ExecBase  in  A6  ladet,  aber  jede Instruktion, die mit Adressen mit der
Länge des Word operieren, können so abgekürzt werden.  Die  Ersparnis  der
linken  vier  Nullen wirkt sich Geschwindigkeitssteigernd aus. Schauen wir
uns den Unterschied an:

				(assembliert)
	MOVE.B	#10,$123	-> MOVE.B #10,$00000123
	MOVE.B	#10,$123.w	-> MOVE.B #10,$0123	-OHNE ÜBERFLÜSSIGEN
							 NULLEN

Der Effekt des Befehles ÄNDERT SICH NICHT! Es ändert sich nur die  "Form",
die  schlanker  und  schneller erscheint. Wenn man vergißt, das .w bei den
"kurzen" Befehlen anzuhängen, dann produziert man  nur  Code,  der  einige
Word länger ist, nicht mehr.

**    **    **    **    **    **    **    **    **    **    **
 
; Datenregister, .L (Longword)

 move.l #$123,d0	; Datenregister direkt (wir geben $123 in D0)

 move.l d1,d0		; Datenregister direkt, wir geben den Wert, der in
			; d1 enthalten ist, in d0)

; Datenregister, .W (Word)	(Bemerkung: Man nennt die rechte Hälfte des
				Long das "niederwertige Word", die linke
				das "höherwertige Word": $HOCH+NIEDER, 
				.L = 4 Byte = 2 Word)

 move.w #$123,d0	; In diesem Fall haben wir nur das niederwertige
			; Word von d0 verändert: wenn d0 $0012fe3c war, und
			; wir nur auf dem niederwertigen Word agieren, also
			; $fe3c, dann wird d0 danach so aussehen: $00120123

 move.w d1,d0		; Das Gleiche, wir kopieren das niederwertige Word
			; von d1 ins niederwertige Word von d0. Wenn d1
			; $12345678 enthält, und d0 $9abcdef0, dann wird nach
			; diesem Befehl d0 folgendes enthalten: $9abc5678
								     ^^^^ WORD!

; Datenregister, .B (Byte)

 move.b #$12,d0		; In diesem Fall ändern wir nur das Byte ganz rechts,
			; wenn d0 z.B. $0012fe3c war, nur auf dem ersten
			; Byte zugreifend, wird es so verändert: d0=$0012fe12

 move.b d1,d0		; Das Gleiche, wir kopieren das erste Byte von d1
			; in das erste Byte von d0. Wenn d1 $12345678 enthält,
			; während d0 $9abcdef0, dann wird nach dieser Instr.
			; d0 so aussehen: $9abcde78
						 ^^ Byte!

Die  Adressregister  a0,a1,a2,a3,a4,a5 und a6 (VERWENDET NICHT A7, auch SP
genannt - Stack Pointer) verhalten sich wie die  Datenregister,  nur  kann
man  auf  ihnen  NICHT  mit .B zugreifen. Man kann darin auch Daten geben,
auch wenn sie für Adressen vorgesehen sind.


**    **    **    **    **    **    **    **    **    **    **
  
; INDIREKTE ADRESSIERUNGEN MITTELS ADRESSREGISTERN

 move.w #123,(a0)	; Bei diesem Move wird die Zahl 123 in das Word
			; kopiert, das sich ab der Adresse befindet, die
			; in a0 steht. Man sagt indirekt dazu, weil die
			; Zieladresse nicht direkt angegeben ist, sondern
			; Mittels Register, das die Adresse enthält. Das
			; geschieht nur, wenn das Adressregister in Klammern
			; geschrieben steht, ansonsten würde man 123 in das
			; Register selbst schreiben. Ein DATENREGISTER kann
			; NICHT dazu verwendet werden, eine indirekte
			; Adressierung zu verrichten.
			; Man kann sagen, daß das Ragister a0 als ZEIGER
			; auf eine Speicherzelle verwendet wurde, es ZEIGT
			; also wie der Mauspointer oder ein Spürhund in
			; Richtung der Beute: man nennt eine Adresse oder
			; ein Register "ZEIGER", wenn dessen Inhalt eine Adres.
			; von irgend etwas enthält,auf das man zugreift,
			; indem man den Zeiger fragt, wo sich dieses befindet.
			; Zeiger werden meist auch als "POINTER" bezeichnet.
			; Z.B. die Copperlist hat ein Pointerregister, das
			; $dff080, in das die Adresse der Copperlist gegeben
			; wird. Der Copper schaut bei jedem Fotogramm in
			; $dff080 nach, wo sich die Copperlist befindet.

 move.l (a0),(a1)	; In diesem Fall wird das Long, das sich ab Adresse a0
			; befindet, in Adresse a1 kopiert. Wenn vor der
			; Ausführung dieses Befehles in a0 die Adresse $100
			; gestanden hätte, und in a1 $200, dann wäre dieser
			; gleichwertig mit einem
			; MOVE.L $100,$200, oder, noch raffinierter, 
			; MOVE.L $100.w,$200.w...

			-	-	-
  
; INDIREKTE ADRESSIERUNG MIT POST-INKREMENTIERUNG (Erhöhung der Adresse NACH
						    Ausführung)

 move.w #123,(a0)+	; Auf diese Art wird die Zahl 123 in das Word kopiert,
			; das sich ab Adresse a0 befindet, und DANACH wird
			; a0 um ein WORD INKREMENTIERT. Wenn die Anweisung ein
			; .B gewesen wäre, dann würde nach dem Move a0 um nur
			; ein Byte erhöht, bei einem .L um 4 Bytes, also ein
			; Long.

 move.l (a0)+,(a1)+	; Mit dieser Anordnung kopieren wir das Long, das sich
			; ab Adresse a0 befindet, in Adresse a1 und folgende,
			; und danach werden beide Register, a0 und a1, um
			; jeweils vier Byte erhöht (Long).
			; Praktisch bewegen wir uns auf die darauffolgenden
			; Longword im Speicher. Mit einer Serie solcher
			; Instruktionen könnte man ein Stück Speicher kopieren:

	lea	$50000,a0	; Quell-Adressee
	lea	$60000,a1	; Ziel-Adresse
	move.l  (a0)+,(a1)+
	move.l  (a0)+,(a1)+
	move.l  (a0)+,(a1)+
	move.l  (a0)+,(a1)+
	move.l  (a0)+,(a1)+
				; Jetzt haben wir 5 Longwords von $50000 nach
				; $60000 kopiert.

			-	-	-
			
; INDIREKTE ADRESSIERUNG MIT PRE-DEKREMENT (Adresse wird VOR Ausführung
					     erniedrigt)

 move.w #123,-(a0)	; ALS ERSTES WIRD A0 UM 2 BYTES DEKREMENTIERT
			; (verringert, abgezogen), ALSO UM EIN WORD,
			; und DANACH wird 123 in das Word kopiert, das 
			; sich ab der Adresse, die in a0 steht, befindet.
			; Wenn die Anweisung eine .B gewesen wäre, dann
			; würde dem a0 nur 1 Byte abgezogen, bei einem
			; .L hingegen 4 Byte (Long).

 move.l -(a0),-(a1)	; a0 und a1 werden beide um jeweils 4 Bytes
			; dekrementiert (Long), und dann wird der Inhalt,
			; der sich ab der nun resultierenden Adresse a0
			; befindet, in die jetzt resultierende Adresse a1
			; kopiert.

		; Mit einer Reihe solcher Befehle könnte man, wie im vorigen
		; Fall, ein Stück Speicher kopieren, aber mit dem
		; Unterschied, daß man rückwärts vorgehen würde, so
		; wie Krebse. Wir müßten bei der Adresse starten, die
		; das Ende der Kopie ist, und nach hinten gehen, bis
		; wir den Anfang erreicht haben, im Beispiel $50000 und
		; $60000. Setzten wir also $50014 und $60014 als Startwert,
		; und dann kopieren wir solange ein Long "nach hinten", bis
		; wir bei $50000 bzw. $60000 angekommen sind: um die Adresse
		; zu berechnen, bei der wir starten müssen, habe ich zum
		; Anfangswert (5*4) dazugezählt, also = $14, praktisch
		; 5 Longwords * 4 Bytes pro Long. Zu Beachten, daß im Speicher
		; $50000+(5*4) als $50014 assembliert wird, denn während der
		; Assemblierfase werden auch eventuelle mathematische
		; Operationen durchgeführt.

	lea	$50000+(5*4),a0	; Quelladresse am ENDE
	lea	$60000+(5*4),a1	; Zieladresse am ENDE
	move.l  -(a0),-(a1)
	move.l  -(a0),-(a1)
	move.l  -(a0),-(a1)
	move.l  -(a0),-(a1)
	move.l  -(a0),-(a1)

		; In diesem Fall haben wir 5 Longwords von $50000
		; nach $60000 kopiert, aber sind bei $50014 gestartet
		; und bis $50000 nach "hinten" gegangen. Der Unter-
		; schied zum vorigen Beispiel ist wie der Unterschied,
		; der darin besteht, den Flur von Links oder von
		; Rechts her zu putzen: in beiden Fällen "kopieren" wir
		; den Schmutz in den Eimer, aber in zwei verschiedenen
		; Richtungen.

			-	-	-
	
; INDIREKTE ADRESSIERUNG MIT ADRESSIERUNGSDISTANZ (OFFSET) UND INDEX

 move.w #12,5(a0,d0.w)  ; Bei dieser Anweisung wird 12 in das Word kopiert,
			; das sich ab der Adresse befindet, die sich aus
			; der Summe von 5 + a0 + Word in d0 bildet. Wenn z.B.
			; in a0 $50000 stehen würde, und in d0 $1000, dann
			; würde 12 auf die Adresse $51005 kopiert.
			; Das Offset kann hier aber nur zwischen -128 und +127
			; variieren.
			; Praktisch wird zur Summe, die die Adresse ergibt,
			; auch noch ein Register hinzugezogen,das sowohl
			; DATEN- wie auch ADRESSREGISTER sein kann, bei dem
			; der ganze Inhalt verwendet werden kann (.L) wie auch
			; nur ein Word (.W).
			; Byteweise ist es nicht verwendbar. Man nennt dieses
			; zusätzliche Register INDEX.

		  EINIGE BEISPIELE:
	
	lea	$50000,a3
	move.w  #$6000,d2
	move.l  #123,$30(a3,d2.w)	; kopiert 123 in $56030
*
	lea	$33000,a1
	move.w  #$2000,a2
	move.l  #123,$10(a1,a2.w)	; kopiert 123 in $35010
*
	lea	$33000,a1
	lea	$20010,a2
	move.l  #123,-$10(a1,a2.l)	; kopiert 123 in $53000

**    **    **    **    **    **    **    **    **    **    **
  
; ADRESSIERUNGEN RELATIV ZUM PC (mit automatischem Offset)

Diese Art der Adressierungen werden  vom  ASMONE  automatisch  in  Ordnung
gebracht,   sie   werden   unbemerkt  übergangen:  z.B.  schaut  euch  den
Unterschied zwischen diesen beiden Anweisungen an:

	MOVE.L  LABEL1,d0		; ABSOLUTE ADRESSE
	MOVE.L  LABEL1(PC),d0		; ADRESSE RELATIV ZUM PC

Diese beiden Anweisungen tun das Geliche, aber die mit dem (PC) ist kürzer
und  schneller als die Erste. Sie ist relativ zum PC, denn die basiert auf
einer Adressierungs-Distanz (Offset) in Bezug  auf  das  PC-Register,  dem
PROGRAM  COUNTER, das ist das Register, in dem der 68000 Buch führt, wo er
gerade mit der Ausführung ist. Das Offset wird automatisch  von  Assembler
errechnet,  und  im Speicher landet dann gleich schon das richtige Offset,
um sich zwischen den Label und anderen Anweisungen richtig zu orientieren.
Die  Instruktion enthält nun nicht mehr die Adresse der Label, sondern die
Anzahl der Bytes, die die Entfernung davon nach vorne/hinten angeben.  Der
Unterschied   ist   klar:   wenn  wir  den  ganzen  Code  in  eine  andere
Speicherregion verlegen, dann verschieben sich die absoluten Adressen, die
Distanzen  zwischen  den  Labels  und den (PC)-Befehlen aber bleibt gleich
groß, deswegen "funktioniert" diese Methode immer, während ein  nicht  zum
PC-relatives  Programm,  wenn  an  einen anderen Ort im Speicher versetzt,
alles in Chaos stürzt. Denn ein move.l  LABEL1,d0  wird  als  (angenommen)
MOVE.L  $23000,d0  übersetzt,  also  befindet  sich  das Label auf Adresse
$23000. Wenn wir nun das ganze Programm, das z.B. bei $20000 startete  und
bei  $25000  endete, um $10000 nach vorne verschieben, dann werden bei der
Ausführung  nicht  indifferente  Fehler  auftreten,  da  sich  ein  MOVE.L
$23000,d0  nicht  mehr  auf LABEL1 bezieht, das liegt jetzt ja auf $33000!
Aber wenn der Code vollständig relativ zum PC erstellt wurde,  dann  hätte
sich  das  MOVE  immer auf das Label bezogen, also auf $33000, da es die -
immer gleichbelibende -Distanz zum Label berechnet hätte. Auch Befehle wie
BRA,  BSR,  BNE,  BEQ  sind  relativ  zum  PC,  ein BSR.W ROUTINE1 wird im
Speicher z.B. als BSR (50 Bytes weiter vorne) assembliert, und  nicht  BSR
$30000.  Adressen  werden von Befehlen assembliert, die äquivalent zum BSR
sind, wie etwa JSR: ein  JSR  LABEL1  wird  mit  der  Adresse  von  Label1
assembliert,  genauso  ein wird JMP (SPRINGE-Äquivalent zum BRA) die REALE
ADRESSE von LABLE1 bekommen. Aber wieso  wird  nicht  immer  einfach  eine
Adressierung  relativ  zum PC vorgezogen, also ein BSR einem JSR? Weil die
Adressierungen mit PC das Limit haben, sich nur auf Adressen  beziehen  zu
können,  die  maximal 32767 Bytes nach vorne oder -32768 Bytes nach hinten
liegen. Für weiter entfernte Label müssen Move mit absoluter Adresse  oder
JSR/JMP  eingesetzt  werden.  Aber,  wie  schon  gesagt,  werden all diese
Rechenaufgaben vom Assembler übernommen, deswegen  interessieren  sie  uns
nicht,  wir müssen  uns  nur  erinnern,  DAß  WENN MÖGLICH, IMMER ein (PC)
gesetzt werden sollte, und BSR und BRA an Stelle von JSR und JMP verwendet
werden sollten. Sollte die Distanz zu groß sein, dann meldet der Assembler
einen Fehler, und wir müssen das (PC) entfernen oder schlimmstenfalls  das
BRA/BSR  durch  JMP/JSR  ersetzen,  das die größten Entfernungen erreichen
kann. Man könnte auch nur mit JMP/JSR und ohne  (PC)  programmieren,  aber
der  Code  würde  länger  und  um  einen  Augenblick langsamer erscheinen,
deswegen ist immer besser, alles so  gut  als  möglich  zu  machen!!!  Das
Problem  der  RELOCATION,  also  des  Verschiebens  im  Speicher, wird vom
Betriebssystem übernommen: wenn wir unser Programm mit WO als Ausführbares
abspeichern,  dann  speichern  wir  ein  File  ab,  das  von der Shell aus
aufgerufen werden kann, indem man seinen Namen eingibt. Das Betriebssystem
kümmert  sich  dann  darum, es an einen freien Platz im Speicher zu geben,
der irgendwo sein kann, und reallociert (A.d.Ü: tut mir  leid,  mir  fällt
für  ALLOCATE kein deutsches Wort ein. Es bedeutet soviel wie "ansiedeln",
"zuteilen",  "anweisen".  Wer  einen  Deutsche   Ausdruck   kennt,   bitte
"Readme.Deutsch"  lesen!) das Programm, es passt also die Adressen der JSR
und der nicht zum PC relativen Move an, um den neuen Gegebenheiten (andere
Adressen)  zu  entprechen. Deswegen kann man auch programmieren, ohne sich
den Kopf darüber zu zerbrechen, überall die (PC) für Labels zu setzen, die
sich  in  anderen  SECTIONS befinden: z.B. die COPPERLIST befindet sich in
einer anderen SECTION, und sie kann nur geändert  werden,  wenn  man  ohne
(PC)  arbeitet,  weil das Betriebssystem die Sektionen auf unvorhersehbare
Distanzen setzt (allocate...), die vielleicht sogar größer sind als 32768,
also dem LIMIT der RC-Realtiven Adressierung.


	BEISPIELE FÜR PC-RELATIVE ADRESSIERUNGEN:

	MOVE.L  LABEL1(PC),LABEL2	; Bemerkung: man kann das (PC) nicht
					; für Labels verwenden, die als Ziel
					; stehen!
					; move.l a0,LABEL(PC) ist ein Fehler!
	ADD.L	LABELBAU(PC),d0		; Geht weil das Label die QUELLE ist
	SUB.L	#500,LABEL		; KEIN PC, WEIL HIER DAS LABEL
					; EIN ZIEL IST
	CLR.L	LABEL			; hier kann kein PC gesetzt werden.
					; Praktisch kann man ein (PC) nur
					; einsetzen, wenn es vor einem
					; Beistrich steht!

; ADRESSIERUNGEN RELATIV ZUM PC MIT OFFSET UND INDEX

Diese Adressierung ist das Gleiche wie vorhin, nur mit INDEX,  also  einem
Register,  das  zum (PC) und zum Offset summiert wird, genauso wie es beim
Offset+Index mit Adressregistern geschieht:

	MOVE.L	LABEL1(PC,d0.w),LABEL2  ; Wie die PC-Adressierung, nur muß
					; noch das Word in d0 dazugezählt
					; werden, wir beziehen uns also nicht
					; auf LABEL1, sondern auf ein Label,
					; das d0 von LABEL1 entfernt ist.
	ADD.L	LABELWAU(PC,a0.l),d0	; Wie vorher, a0.l wird als Index
					; verwendet.

Das ist alles, was die Adressierungen angeht.

**    **    **    **    **    **    **    **    **    **    **
  
GEBRÄUCHLICHSTEN BEFEHLE:

	MOVE.x	QUELLE,ZIEL	; Kopiert ein Byte, ein Word oder
				; ein Longword

	LEA	Adresse,Ax	; Ladet eine Adresse: Diese Anweisung
				; kann nur mit Adressregistern verwendet
				; werden. Sie dient dazu, die entsprechende
				; Adresse (sei sie nun in Form eines Label
				; oder einer Zahl gegeben, z.B. $50000)
				; ins Register zu geben.
				; Das gleiche wie : MOVE.L #Adresse,a0
				; aber schneller!

	CLR.x	Ziel		; Dieser Befehl löscht das Ziel 
				; (setzt es auf 0) CLR = CLEAR = "REINIGE"

BEDINGTE SPRÜNGE MIT EINEM TST, BTST, CMP

	CMP.x	Quelle, Ziel	; Vergleicht zwei Operanden, die ein
				; Label oder ein Register sein können, oder
				; sonst eine absolute Zahl (#)  mit einem
				; Register uvm. POITIVES Ergebnis, wenn die
				; zwei Operanden GLEICH sind (für folgende
				; BEQ/BNE)

	TST.x	Register.Label/Adresse  ; Kontrolliert, ob der fragliche
					; Operand gleich NULL ist, wenn ja,
					; Positives Ergebnis

	BTST	#x,Adresse/Dx	; Kontrolliert, ob Bit x der Adresse
				; auf NULL steht; wenn ja POSITIVES
				; Ergebnis. Man kann ein BTST auch auf
				; ein Datenregister ausführen, in diesem
				; Fall ist ein Test auf einem der 32 möglichen
				; Bits (0-31) erlaubt. Wird das BTST auf eine
				; Speicherzelle angewandt, so muß man sich mit
				; einem Byte (0-7) begnügen.

Sofort nach dem CMP, TST oder BTST steht immer ein BNE, ein BEQ  oder  ein
anderer,  ähnlicher  Befehl.  Im  Falle  des  BNE  oder  des  BEQ kann man
Verzweigungen oder konditionierte Sprünge  vom  TST/CMP  aus  machen.  DIE
BEW/BNE/BSR/BRA können sowohl .w wie auch .b sein, jenachdem, wie weit die
Routine vom Aufrufenden Befehl entfernt ist. Wenn sie  sehr  nahe  liegen,
kann auch ein .b verwendet werden, das oft als .s geschrieben wird. Es ist
das Gleiche (s= SHORT, -> KURZ).

	BSR.x	label		; Führe die Routine LABEL aus, und wenn
				; du auf ein RTS am Ende der Routine stößt,
				; dann kehre zurück.

	BEQ.x	label		; Wenn das Resultat der vorherigen Abfrage
				; POSITIV war, dann springe zum Label
				; (DANACH ABER KEHRE NICHT ZURÜCK, WIE IM
				; FALLE DES BSR, HIER WIRD GEWÄHLT ZWISCHEN
				; SPRINGEN ODER NICHT

	BNE.x	label		; Wenn das Resultat NICHT positiv war,
				; dann springe zum Label
				; (DANACH ABER KEHRE NICHT ZURÜCK, WIE IM
				; FALLE DES BSR, HIER WIRD GEWÄHLT ZWISCHEN
				; SPRINGEN ODER NICHT
  
	BRA.x	label		; Springe IMMER zum Label (wie JMP)

	ADD.x	Operand1,Ziel	; Mit diesem Befehl wird ein Wert zum
				; Ziel addiert

	SUB.x	Operand1,Ziel	; Mit diesem Befehl wird ein Wert
				; von Ziel subtrahiert

	SWAP	Dx		; Vertauscht die 2 Words des Longwords
				; in einem DATENREGISTER, braucht kein
				; .B, .W oder .L

SWAP  kommt aus dem Englichen (Wunder, Wunder), und bedeutet "Vertausche",
in der Tat vertauscht es die zwei Words, aus dem ein Longword besteht:

	MOVE.L	#HUNDMAUS,d0	; in d0 kommt das Longword HUNDMAUS

	SWAP	d0		; Wir vertauschen die Words: in d0
				; steht jetzt MAUSHUND !!!!

				*

Bemerkung: Es existieren Anweisungen,  die  den  Adressregistern  gewidmet
sind: z.B. müssen wir CMPA.W d0,a0 schreiben und nicht CMP.W d0,a0,auf die
gleiche Art und Weise ADDA.W a2,a0 und nicht ADD.W a2,a0.  Für  Konstanten
hingegen  (#xxxx)  müssen wir  CMPI.x  #10,d0  verwenden,  und nicht CMP.x
#10,d0. Genauso SUBI.x #123,d2 und nicht SUB.x #123,d2,  aber  der  ASMONE
assembliert  immer  AUTOMATISCH  die richtige Anweisung, auch wenn wir nur
cmp/add/sub schreiben. Also, keine Sorgen, wenn in  einem  Listing  einmal
CMPI auftaucht, weiter unten dann CMP alleine, oder adda und add, weil der
ASMONE immer alles zum Rechten biegt. Zum Testen assembliert die folgenden
Zeilen  und  disassembliert mit "D PROBE", der ASMONE wird nach den Regeln
assemblieren.

PROBE:
	CMP.W	d0,a0
	ADD.W	a1,a2
	SUB.L	#123,$10000
	CMP.b	#20,d4

Wird so assembliert werden:

	CMPA.W	D0,A0
	ADDA.W	A1,A2
	SUBI.L	#$0000007B,$00010000
	CMPI.B	#$14,D4


			-	-	-
	  
Bemerkung2:  Gewisse  Instruktionen,  die  das  gleiche  tun,  können  auf
verschiedene  Weise  geschrieben werden: z.B. hat der 68000er Befehle, die
bestimmten Situationen angepasst sind, und dort schneller sind:

1)	ADDQ.x	#Zahl,Ziel	; Der Befehl ADDQ.x kann für Additionen
				; verwendet werden, dessen Zahlen kleiner
				; sind als 8 (Q = Quick, "Schnell")

2)	SUBQ.x	#Zahl,Ziel	; Der Befehl SUBQ.x kann für Subtraktionen
				; mit Zahlen von 1 bis 8 verwendet werde,
				; (wie oben...)

3)	MOVEQ	#Zahl,dx	; Das MOVEQ kann dazu verwendet werden, um
				; das MOVE.L #Zahl,d0 zu ersetzen, wobei
				; Zahl zwischen -128 und +127 liegen muß.
				; Das MoveQ ist immer .L, deswegen braucht
				; es kein .B, .W oder .L.

