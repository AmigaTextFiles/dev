
; Listing2l.s

Anfang:
	lea	$dff000,a0			; gib $dff000 in a0
Waitmouse:
	move.w	#$20,$1dc(a0)	; BEAMCON0 (ECS+) Auflösung video PAL
	bsr.s	Blinken			; Bringt den Bildschirm dazu zu blinken
	bsr.s	ZeigerFarbe		; Bringt den Mauspointer zu blinken
	btst	#2,$16(a0)		; POTINP - Rechte Maustaste gedrückt?
							; (bit 2 im $dff016)
	bne.s	nichtgedrueckt	; Wenn nicht, springe zu VollesChaos
	bsr.s	VollesChaos		;
nichtgedrueckt:
	btst	#6,$bfe001		; Linke Maustaste gedrückt?
	bne.s	Waitmouse		; wenn nicht, zurück zu Waitmouse
	rts						; Ende


ZeigerFarbe:
	moveq	#-1,d1			; Also moveq #$FFFFFFFF,d1
	moveq	#20-1,d0		; Anzahl der ZeigerFarbe-Zyklen
flash:
	subq.w	#8,d1			; Ändere die Farbe, die in $dff1a4 kommt
	move.w	d1,$1a4(a0)		; COLOR18 - gib den Wert von d1 in $dff1a4
							; (Die Farbe des Mauspointers!)
	dbra	d0,flash
	rts

Blinken:
	move.w	6(a0),$180(a0)	; Gib den .w-Wert von $dff006 in COLOR0
	move.b	6(a0),$182(a0)	; Gib den .b-Wert von $dff006 in COLOR1
	rts

VollesChaos:
	move.w	#0,$1dc(a0)		; BEAMCON0 (ECS+) Auflösung video NTSC
	rts

	END

Dieses Programm ist nur seiner Struktur wegen interessant, denn es hat ein
Hauptprogramm, das von Anfang: bis zum RTS, das SubRoutinen aufruft  (also
Unterprogramme,  die nichts anderes sind als Teile des Programmes, die mit
einem Label versehen wurden und einem RTS enden). Mit  dem  Debugger  (AD)
könnt  ihr  versuchen,  den  Ablauf  des  Programmes zu verfolgen: um alle
SubRoutinen durchzugehen,  drückt  die  Pfeil-nach-Rechts-Taste,  und  ihr
werdet  in  der  Routine  Zeigerfarbe  sehen,  wie  d1  in Einserschritten
heruntergezählt wird.

Das fundamentale Problem der BSR/BEQ/BNE/RTS - Strukturen liegt darin, daß
alles  durch Sprünge geregelt ist, bei denen man nach Abarbeitung entweder
mit einem RTS zur Zeile unter  dem  BSR  zurückkehrt,  oder  einen  Sprung
macht,  der  einer  Weiche  ähnelt, bei der man entweder links oder rechts
geht, an deren Ende man aber nicht zurück kann.

Ast 1
		   _______ _ _ ect ect _ _ _  RTS, Ausstieg von diesem Weg
   Weiche beq/bne /
   ______________/
		 \ Ast 2
		  \______ _ _ etc etc _ _ _ _ RTS, Ausstieg von diesem Weg

Ein BEQ/BNE-Sprung ist wie die Entscheidung,  ob  man  nach  München  oder
Hamburg  fahren  soll, man wird andere Straßen befolgen und einmal am Ziel
angekommen, wird man dort die Nacht verbringen, wenn man das RTS  erreicht
hat. Es wurden aber andere Wege genommen.

Wenn wir aber ein BSR.w München antreffen, dann springen wir nach München,
führen die Befehle aus, die wir dort antreffen, und  wenn  wir  einem  RTS
begegnen,  dann  "beamen"  wir uns auf magische Art und Weise zur Kreuzung
zurück, an der wir nach München abgebogen sind. Es ist, als würden wir ein
Zauberbuch  lesen, bei der auf jeder Seite eine Landschaft abgebildet ist,
und wenn wir ein AbraCadaBSR aussprechen, werden wir  in  diese  Zeichnung
katapultiert, wir verbringen dort eine Zeit lang, dann treffen wir auf ein
SimsalaRTS  und  wir  sitzen  vor  dem  Buch,  bereit   auf   Seite   zwei
einzusteigen, mit einem erneutem AbraCadaBSR.

Bemerkung1:   Durch  Drücken  der  rechten  Maustaste  wird  eine  Routine
ausgeführt, die sonst übersprungen wird:

	btst	#2,$16(a0)		; POTINP - Rechte Maustaste gedrückt?
							; (bit 2 im $dff016
	bne.s	nichtgedrueckt  ; Wenn nicht, springe zu VollesChaos
	bsr.s	VollesChaos		;
nichtgedrueckt: 

Erinnert euch gut an diese Art, um eine Routine nur auszuführen, wenn eine
bestimmte  Kondition  gegeben  ist,  in  diesem  Beispiel  ob  die  rechte
Maustaste gedrückt ist. Beim Programmieren treten solche  Dinge  oft  auf.
Das  Register, das dazu verwendet wird, "VollesChaos" zu bereiten, ist das
$dff1dc, in dem Bit 5 dazu dient, zwischen der  europäischen  PAL  und der
amerikanischen NTSC -Videonorm umzuschalten. Dieses Register existiert nur
in Computern, die nach 1989 gebaut wurden, bei jemanden, der  einen  recht
alten  Computer  hat,  könnte  es  nicht  funktionieren. Wenn es euch aber
funktioniert, dann werdet  ihr  bemerken,  daß  bei  Tastendruck  (rechter
Mausknopf)  der  Bildschirm  quasi  zu  "explodieren"  scheint, da er sehr
schnell zwischen  den  Videonormen  PAL/NTSC  umschaltet.  Wenn  ihr  zwei
Programme  schreiben  möchtet, die zwischen PAL/NTSC umschalten, dann müßt
ihr nur folgendes tun:

	move.w	#0,$dff1dc		; BEAMCON0
	rts

Assembliert es mit a, und speichert ab mit WO  (also  als  File,  den  ihr
ausführen  könnt),  gebt ihm ev. den Namen NTSC. Dann assembliert folgende
zwei Zeilen:

	move.w	#$20,$dff1dc	; BEAMCON0
	rts

Speichert es als PAL ab. Von der Shell aus könnt ihr so zwischen  PAL  und
NTSC umschalten, indem ihr einfach eines der zwei Programme startet.

Wenn ihr bei diesem Programm schon Orientierungsschwierigkeiten habt, dann
bedenkt,  daß  ECHTE  Programme  tausend  mal  komplizierter   sind,   mit
verschiedensten BSR, also versucht, dieses zu 100% zu verstehen, bevor ihr
zu LEKTION3.TXT übergeht, die auch den Untertitel trägt "WIR KÖNNTEN  EUCH
MIT  SPEZIALEFFEKTEN VERWUNDERN, SCHAFFEN ES ABER NOCH NICHT". (A.d.Ü.: In
Orginalton klingt dieser Spruch sehr viel witziger..!)
