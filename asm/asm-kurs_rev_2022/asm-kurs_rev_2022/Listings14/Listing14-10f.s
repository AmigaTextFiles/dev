
; Listing14-10f.s	Verwenden der Routine player6.1a für ein komprimiertes Modul

; Routine P61_Music die vom interrupt VERTB ($6c) Level 3 aufgerufen wird

; Weiterhin ist die Sprungroutine an den verschiedenen Punkten des Moduls aktiviert.
; Für die Funktion einfach jump = 1 setzen und rufen Sie die Routine P61_SetPosition 
; mit der Position in d0.l auf.

; Drücken Sie abwechselnd die linke und die rechte Taste, aber denken sie daran,
; dass die Änderungen am Ende des Patterns nicht sofort stattfinden !!!

	SECTION	Usoplay61a,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s" ; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001010000000	; nur copper DMA

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:

;­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­
;­ Call P61_Init to initialize the playroutine	­
;­ D0 --> Timer detection (for CIA-version)	­
;­ A0 --> Address to the module			­
;­ A1 --> Address to samples/0			­
;­ A2 --> Address to sample buffer		­
;­ D0 <-- 0 if succeeded			­
;­ A6 <-- $DFF000				­
;­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­

	movem.l	d0-d7/a0-a6,-(SP)
	lea	P61_data,a0				; Adresse des Moduls in a0
	lea	$dff000,a6				; wir merken uns $dff000 in a6!
	sub.l	a1,a1				; die samples sind nicht getrennt, wir setzen Null
	lea	samples,a2				; Modul komprimiert! Zeiger auf Zielpuffer für
								; die samples (in chip ram) !
	bsr.w	P61_Init			; Hinweis: das Dekomprimieren dauert einige Sekunden!
	movem.l	(SP)+,d0-d7/a0-a6

	lea	$dff000,a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - nur copper aktivieren
								; + bitplane und sprites (%1000001111000000)

	move.l	BaseVBR(PC),a0
	move.l	#Myint6c,$6c(a0)	; meine interrupt routine

	move.w	#$e020,$9a(a5)		; INTENA - aktivieren Master und lev6
								; und VERTB (lev3).

	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse

	clr.w	ModPos				; Von vorn anfangen
	st.b	CambiaPos

mouse2:
	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse2

	move.w	#16,ModPos			; gehe zu pos 16
	st.b	CambiaPos

mouse3:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse3

	move.w	#30,ModPos			; Gehe zu Position 30 
	st.b	CambiaPos			; (dies ist die letzte).

mouse4:
	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse4

;­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­
;­ Call P61_End to stop the music		­
;­   A6 --> Customchip baseaddress ($DFF000)	­
;­		Uses D0/D1/A0/A1/A3		­
;­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­

	lea	$dff000,a6				; wir merken uns $dff000 in a6!
	bsr.w	P61_End

	rts

*****************************************************************************
*		Routine in interrupt livello 3 ($6c)								*
*****************************************************************************

MyInt6c:
	btst	#5,$dff01f			; INTREQR - int VERTB?
	beq.s	noint				; wenn nein, exit!

	movem.l	d0-d7/a0-a6,-(SP)
	lea	$dff000,a6				; wir merken uns $dff000 in a6!
	tst.b	CambiaPos			; müssen wir zur pos springen?
	beq.s	NonCambiarPos
	cmp.w	#63,P61_Crow		; sind wir am Ende des Patterns?
	bne.s	NonCambiarPos		; Wenn noch nicht, fange nicht von vorne an!
	clr.b	CambiaPos
	moveq	#0,d0
	move.w	ModPos(PC),d0		; zu welcher pos. springen wir?
	bsr.w	P61_SetPosition		; Position ändern
NonCambiarPos:
	bsr.w	P61_Music			; wir spielen
	movem.l	(SP)+,d0-d7/a0-a6
noint:	
	move.w	#$70,$dff09c		; INTENAR
	rte

ModPos:
	dc.w	0
CambiaPos:
	dc.w	0

*****************************************************************************
*		 The Player 6.1A for Asm-One 1.09 and later 						*
*****************************************************************************

fade  = 0	; 0 = Normal, NO master volume control possible
			; 1 = Use master volume (P61_Master)

jump = 1	; 0 = do NOT include position jump code (P61_SetPosition)
			; 1 = Include

system = 0	; 0 = killer
			; 1 = friendly

CIA = 0		; 0 = CIA disabled
			; 1 = CIA enabled

exec = 1	; 0 = ExecBase destroyed
			; 1 = ExecBase valid

opt020 = 0	; 0 = MC680x0 code
			; 1 = MC68020+ or better

use = $b55a	; Usecode (Setzen Sie den von p61con angegebenen Wert zum Speichern
			; für jedes Modul unterschiedlich!)

*****************************************************************************
	include	"/Sources/play.s"	; die wahre Routine!
*****************************************************************************


*****************************************************************************
;	Copperlist
*****************************************************************************

	SECTION	COP,DATA_C

COPPERLIST:
	dc.w	$100,$200			; bplcon0 - keine bitplanes
	DC.W	$180,$003			; color0 schwarz
	dc.W	$FFFF,$FFFE			; Ende copperlist

*****************************************************************************
;	Musikmodul in P61-Format konvertiert, KOMPRIMIERT! (Option pack!)
*****************************************************************************

	Section	modulozzo,data	; Es muss nicht im Chip-RAM sein, weil es ist
							; komprimiert ist und woanders entpackt wird!

; Modul von Jester/Sanity. Original 153676, gepackt 71950

P61_data:
	incbin	"/Sources/P61.stardust"	; komprimiert, (Option PACK SAMPLES)
				; Sie können es auch in den FAST RAM legen: es wird verwendet
				; zum Entpacken der Samples in den Puffer Samples
				; und wird nicht direkt "gespielt".
				; Es geht also nicht direkt über die Audio DMA-Kanäle
				; sondern nur über die Depack-Routine durch den Prozessor.
				; Also nur DATEN (nicht _C!)


*****************************************************************************
;	Wo die Samples entpackt werden werden (section bss in chip ram!)
*****************************************************************************

	section	smp,bss_c

samples:
	ds.b	132112	; Länge gemeldet von p61con

	end

Seien Sie vorsichtig, wenn Sie die Überspringroutine hier und da im Modul verwenden!
Wenn Sie in die Mitte eines Patterns springen, ist zunächst alles nicht mehr synchron.
Ich weiß nicht, ob es sich um einen Playerfehler oder etwas anderes handelt. Also müssen
Sie auf das Ende des aktuellen Patterns warten, bevor Sie zu einem anderen springen. Wir
können zu jedem Zeitpunkt durch lesen dieser 3 Variablen wissen wo wir im Modul sind:
 
	P61_Pos: 	Current song position
	P61_Patt:	Current pattern
	P61_CRow:	Current row in pattern

Die Nützlichkeit dieser Routine kann nur gefunden werden, wenn sie in einer Form
durchgeführt wird, in der Sie freiwillig niemals eine bestimmte Position erreichen,
die wir mit dieser Routine überspringen sollten. Zum Beispiel für ein Spiel können Sie
einfache die Musik "leise" machen, die sich immer wiederholt und die ersten 
40 Positionen besetzen. An den Positionen 40 bis 50 gibt es jedoch einen anderen Grund:
dramatischer, auf die nur zugegriffen werden kann, wenn Sie springen.
Hier ist also unser Ort, bei der wir mit Musik und einem sorgenfreien Hintergrund um
die Welt gehen... dann finden wir den Bösewicht und springen zu einer anderen Melodie,
die von selbst in einer eigenen Schleife spielt... ist das Monster getötet, 
kehren wir zur ruhigen Musik zurück.