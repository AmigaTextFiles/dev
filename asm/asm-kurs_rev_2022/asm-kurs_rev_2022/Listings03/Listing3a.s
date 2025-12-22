
; Listing3a.s	- WIE MAN EINE ROUTINE DES BETRIEBSSYSTEMES AUSFÜHRT

Anfang:
	move.l	$4.w,a6			; Execbase in a6
	jsr	-$78(a6)			; Disable - stoppt das multitasking
mouse:
	move.w	$dff006,$dff180	; gib VHPOSR in COLOR00 (Blinken!!)
	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse			; wenn nicht, zurück zu mouse:

	move.l	4.w,a6			; Execbase in a6
	jsr	-$7e(a6)			; Enable - stellt Multitasking wieder her
	rts

	END

Dieses Listing ist das erste, indem wir eine Routine des  Betriebssystemes
aufrufen.  Und,  Ironie  des Schicksals, ist es genau die Routine, die das
Betriebssystem selbst abschaltet! In der Tat werdet ihr  feststellen,  daß
nach ausführen des Programmes der Mauspointer blockiert ist, durch drücken
der  rechten  Maustaste  erscheinen  keine  Menüs  und  die  Disk   Drives
verstummen, kein Click ist mehr zu hören. Und aufgepaßt,auch der Debugger,
"AD", der das Betriebssystem verwendet, wird damit  abgeschaltet,  er  ist
somit  nur  begrenzt  einsetzbar. Probieren wir also ein "AD", und drücken
die Pfeil-nach-rechts-Taste (Mit dieser Taste "steigt" man in die BSR  und
JSR  ein,  während  man  mit  dem Pfeil-nach-unten den Debug diese Befehle
überspringt). Nach dem ersten Befehl, dem MOVE 4.w,a6, wird in Register a6
die  in  dem Long von Speicherzelle $4 enthaltene Adresse erscheinen (also
der Inhalt von Speicherzelle $4, $5, $6 und $7 wird diese Adresse bilden).
Drückt  ESC  und  überprüft  mit einem "M 4", gefolgt von vier Returns: es
wird die gleiche Adresse sein. Diese Adresse wird vom Kickstart nach jedem
Reset  oder Neustart des Amiga an diesen Punkt gelegt. Fahrt mit dem Debug
fort,  geht  beim  MOVE  weiter  und  "steigt"  ins   JSR   -$78(a6)   ein
(Pfeil-nach-rechts):  um  die  Subroutine zu verfolgen, müßt ihr die Zeile
mit dem disassemblierten Code verfolgen (unten  am  Bildschirm),  und  ihr
werdet ein JMP $fcxxxx oder $fcxxxx sehen, jenachdem, ob ihr Kickstart 1.3
oder 2.0/3.0 besitzt. Ihr seid nun an der Adresse, die in $4 enthalten war
minus  $78,  und ihr befindet euch noch im RAM-Speicher des Amiga, wo  ihr
aber einem JMP begegnen werdet, das euch in die ROM führt.  Denn  die  ein
oder  zwei Sekunden, die der Amiga nach einem Reset oder Neustart braucht,
verbringt er damit, eine TABELLE der JMPs im  Ram-Speicher  zu  erstellen,
dessen  letzte  Adresse in $4 landet. Jedes JMP springt zur Adresse dieses
speziellen Kickstarts, wo sich die  Routine  befindet,  die  der  Position
dieses  JMP  gegenüber  seinem  Ende  entspricht.  Z.B. wird mit einem JSR
-$78(a6) das Multitasking außer Kraft gesetzt, sei es nun auf einem  Amiga
mit  Kickstart  1.2,  1.3,  2.0  oder 3.0, genauso wie auf den zukünftigen
Modellen. Wenn z.B. im Kick 1.3 die Routine im  ROM  auf  $fc12345  sitzen
würde,  dann  würde das JMP, das sich $78 unter der Basisadresse befindet,
ein JMP $fc12345 sein, während wenn sie beim Kick 2.0 auf $fc812345  wäre,
dann würde das JMP ein JMP $fc812345. Dieses System erlaubt es auch, einen
Kickstart in die RAM zu laden: es braucht dann nur  die  Tabelle  der  JMP
erzeugt  werden  die  die Routinen anpeilt. Beendet den Debug, nachdem ihr
euch gelangweilt habt, herauszufinden, auf welcher Adresse das JMP war,und
versucht,ein "D dieser Adresse" zu machen (Die Adresse der Instruktion ist
die erste Zahl links unten am Bildschirm! Ihr findet sie auch in der Liste
der Register ganz rechts, es ist das PC-Register, oder ProgramCounter, der
die aktuelle Adresse, die sich in Abarbeitung befindet,  registriert,  ihr
müßt  nur  noch ein $ vorne anfügen). Ihr werdet eine Reihe von JMP sehen;
das ist ein Beispiel:

	JMP	$00F817EA	; -$78(a6), also DISABLE
	JMP	$00F833DC	; -$72(a6) eine andere Routine
	JMP	$00F83064	; -$6c(a6) eine andere Routine...
	JMP	$00F80F74	; ....
	JMP	$00F80F0C
	JMP	$00F81B74
	JMP	$00F81AEC
	JMP	$00F8103A
	JMP	$00F80F3C
	JMP	$00F81444
	JMP	$00F813A0
	JMP	$00F814F8
	JMP	$00F82842
	JMP	$00F812F8
	JMP	$00F812D6
	JMP	$00F80B38
	JMP	$00F82C24
	JMP	$00F82C24
	JMP	$00F82C20
	JMP	$00F82C18

Um Teile des disassemblierten Codes einzufügen, habe ich den  Befehl  "ID"
verwendet,  bei  dem  die Start- und die Endadresse des Bereichs anzugeben
ist, die eingefügt werden soll:

BEG> hier wird die Adresse oder das Label  eingegeben,  probiert  mit  der
     Adresse  des JMP 
	
END> Die Endadresse  eingeben, oder  $xxxxx+$80, mit $xxxxx  meine ich die 
     Startadresse. In diesem Fall wird man das Disassemblierte von Adresse 
     $xxxxx bis zur  Adresse $80 Bytes danach erhalten.

REMOVE UNUSED LABELS) (Y/N)	; HIER EIN "Y" EINGEBEN. Wenn ihr nein sagt,
							; wird ein Label  mit der  Adresse zu jeder
							; Zeile beigefügt,  und nicht  nur dort, wo
							; ein Label gebraucht wird. Probiert ein ID
							; dieses  Listings zu machen  um den Unter-
							; schied zu erfahren.

Beispiel: wenn die Adresse $32123 war

BEG> $31223
END> $32123+$80	; BEMERKUNG: um die alten Adressen wiederzubekommen,
				; drückt einige Male die Pfeil-nach-oben-Taste.
				; Dadurch erscheinen die Dinge, die ihr vorher getippt
				; habt, gleich wie bei der SHELL

Und es wird der disassemblierte Code ab dem Punkt  erscheinen,  indem  ihr
zuletzt mit dem Cursor wart.

Nun  könnt  ihr  euch  vorstellen,  wieviele  JSR  und  JMP  der Prozessor
ausführen muß, wenn ein Programm einige  solcher  Routinen  verlangt.  Und
dieses  ganze  Gespringe  ist  ein  Zeitverlust,  deswegen  werden wir das
Betriebssystem so wenig wie nur möglich benützen.

Wenn ihr mit dem Debug nach dem JMP weitermacht, werdet ihr  euch  in  der
ROM  befinden,  also an der Adresse des JMP: Normalerweise ist das Disable
so :

	MOVE.W	#$4000,$dff09a	; INTERN - Stoppt die interrupt
	ADDQ.B	#1,$126(a6)		; Stoppt das Betriebssystem
	RTS

Wenn ihr in die ROM "einsteigt", indem ihr die Pfeil-rechts Taste  drückt,
werdet  ihr  die  Befehle  sehen,  aber  nicht  ausführen:  das  ist  eine
Sicherheitsmaßnahme des Debug, wenn  er  außerhalb  des  Listings  landet,
meistens  eben  in  der  ROM,  dann  werden die Befehle nur angezeigt. Ihr
werdet euch im Loop der Maus befinden, aber trotzdem den  Pointer  bewegen
und  das unverwechselbares CLICK der Laufwerke hören, ihr führt also diese
beiden  Operationen  nicht  aus.  Ihr  könnt  auch  in  das  JSR  -$7e(a6)
einsteigen und und dann wieder verlassen.

Probiert  aber  im  Debug  mit  der  Pfeil-nach-unten Taste am JSR -78(a6)
vorbeizurauschen: Diesmal wird euch das Programm entwischen, da sie  jetzt
ausgeführt  werden (ohne jedoch angezeigt zu werden). Ihr könnt aber immer
noch mit der linken Taste aussteigen,  danach  ESC,  um  den  Debugger  zu
verlassen.

Probiert diese Änderung:

1) Assembliert, dann macht ein "D Anfang" und ihr werdet folgendes sehen:

	MOVE.L	$0004.w,A6

Probiert das .w nach dem 4 wegzulassen,  assembliert  und  wiederholt  den
Schritt von vorher:

MOVE.L $00000004,A6

Wie ihr seht, werden in diesem Fall alle vier Bytes der Adresse verwendet,
während  mit  dem .w zwei gespart wurden. Die Operation ".W" kann auf alle
Adressen angewandt werden, die nur ein Word oder kürzer sind.

2) Probiert die Zeile

	JSR	-$78(a6)

durch die folgende Zeile zu ersetzen:

	MOVE.W	#$4000,$dff09a	; INTERN - Stoppt die Interrupt
	ADDQ.B	#1,$126(a6)		; Stoppt das Betriebssystem

Oder durch das, was ihr in der ROM nach dem JMP vorfindet  (Ohne  dem  RTS
zum Schluß!).

Ihr werdet bemerken, daß das Resultat das gleiche ist.

Das gleiche gilt für JSR -$7e(a6).


