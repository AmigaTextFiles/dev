
; Listing9i5.s		Bob schneidet nach rechts ab. (von Erra Ugo)
; der Bob wird mit dem Joystick (Port2) bewegt
; Linke Taste zum Verlassen.

	section	CLippaD,code

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/Startup1.s" ; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA


; Wir definieren in diesen Gleichungen die Konstanten relativ zu unserem Bob...

XBob	equ	16*8				; Dimension X des Bobs
YBob	equ	29					; Dimension Y des Bobs
XWord	equ	8					; Anzahl der Wörter des Bobs

; Wir definieren die Grenzen des Bildschirms

XMax	=	320-64				; Rechte horizontale Grenze des Bildschirms
XMin	=	0					; Linke horizontale Grenze des Bildschirms
YMax	=	200-YBob			; Untere vertikale Grenze des Bildschirms
YMin	=	0					; Obere vertikale Grenze des Bildschirms


Start:
	Lea	Screen,a0				; Zeiger Screen
	Move.l	a0,d0				; bitplane
	Move.w	d0,BPLPointer1+6
	Swap	d0
	Move.w	d0,BPLPointer1+2

	Lea	$dff000,a6				; CUSTOM REGISTER in a6
	Move.w	#DMASET,$96(a6)		; DMACON - einschalten bitplane, copper
	Move.l	#CopperList,$80(a6)	; Zeiger COP
	Move.w	d0,$88(a6)			; Start COP
	Move.w	#0,$1fc(a6)			; AGA deaktivieren
	Move.w	#$c00,$106(a6)		; AGA deaktivieren
	Move.w	#$11,$10c(a6)		; AGA deaktivieren

	Moveq	#100,d0				; d0 ist die x-Koordinate
	Move.w	#100,d1				; d1 ist die y-Koordinate
	Moveq	#0,d2				; Wir setzen den Rest der Datenregister zurück
	Moveq	#0,d3				; bla bla bla
	Moveq	#0,d4				; bla bla
	Moveq	#0,d5				; bla
	Moveq	#0,d6		
	Moveq	#0,d7

Loop:
	Cmpi.b	#$ff,$6(a6)
	Bne.s	Loop

	Bsr.w	LeggiJoyst			; Die Routine liest den Joystick-Status
								; und aktualisiert x und y direkt in den 
								; Registern d0 und d1.
	Bsr.w	CheckLimit			; Überprüfen, ob die Routine in den Grenzen liegt
	Bsr.w	CancellaSchermo		; den Bildschirm reinigen
	Bsr.s	ClipBobRight		; legt den Bob auf den Bildschirm
	Btst	#6,$bfe001			; Warten, bis die linke Maustaste gedrückt wird
	Bne.s	Loop				; ...
	Rts

; ****************************************************************************
; Die entschlüsselte Technik wird wie folgt implementiert:
; 1) Wenn die obere rechte Koordinate außerhalb der Maximalgrenze liegt, dann
;   nichts blitten.
; 2) Berechnen Sie auf folgende Weise, wie viele Pixel der Bob herausgekommen 
;   ist Xout=(x+xdim)-XMax
; 3) Es wird dann genau berechnet, aus wie vielen Wörtern der Bob kam und
;   wie viele Pixel, auf folgende Weise XOut / 16 und XOut mod 16.
; 4) An dieser Stelle übernehmen wir den Wert aus der maskright-Tabelle
;   des BLTLWM-Registers durch den XOut-Wert mod 16
; 5) Wir bereiten das A-Modulo des Blitters durch die Operation 
;   (XBob-XOut) / 16 vor
; ****************************************************************************

;	       . . . .
;	      :¦:¦:¦:¦:¦       
;	      ¦    ____l___    
;	      |__  '______/    
;	     _!\____,---.|     
;	.---/___ (¯°) °_||----.
;	|   \ \/\ ¯¯¯¯T  l_   |
;	|  _ \ \/\___,_)__ \  |
;	|  |  \ \/ /| | l/ /  |
;	|  |   \ \/¯T¯T¯/ /T  |
;	|  |    \_¯¯¯¯¯¯_/ |  |
;	|  |     `------'  |  |
;	|  l_______/¯¯)¯¯\_|  |
;	l_______l__  _(_  (___|
;	.. .  .   \___)___/ xCz

ClipBobRight:
	Movem.l	d0-d7/a0,-(a7)
	Cmpi.w	#XMax,d0			; Vergleichen Sie die Koordinate oben links
								; mit XMax
	Bge.w	ExitClipRight		; Wenn es größer ist, ist der Bob komplett
								; raus, also machen wir nichts

	Move.w	#XBob,d7			; d7=Dimension des Bobs
	Add.w	d0,d7				; Die x-Koordinate ist ähnlich wie d7, also
								; entspricht d7 der Koordinate oben rechts.
	Subi.w	#XMax,d7			; Berechnung, aus wie vielen Pixeln der Bob herauskam
	Ble.w	IsInLeft			; Wenn das Ergebnis kleiner als Null ist, dann
								; kam der Bob komplett raus.

	Move.w	d7,d6				; d7=d6=Anzahl der Pixel aus
	Lsr.w	#4,d6				; d6=d6/16 Wort Nummer
	Move.w	#XWord,d2			; d2=Wortnummer des Bob ursprünglich
	Andi.w	#15,d7				; d7=Anzahl der Pixel aus

								; Jetzt berechne ich den neuen Wert von bltsize
	Move.w	d2,d5				; d5=Wortnummer des Bob ursprünglich
	Sub.w	d6,d2				; d2 Anzahl der Wörter in
	Move.w	#YBob,d3			; Dimension vertikal in d3
	Lsl.w	#6,d3				; Multiplizieren Sie d3 mit 64
	Add.w	d2,d3				; d3=bltsize reduziert

								; Wir berechnen das neue Zielmodulo
	Moveq	#40,d4				; Berechnung der neuen Form des
								; Ziels. Wir machen nichts als subtrahieren
								; die restlichen Abmessungen des Bobs bei 40.
	Add.w	d5,d5				; d5=d5*2 Anzahl der Bytes des ursprünglichen Bob.
	Add.w	d6,d6				; d6=d6*2 modulo vonA in byte
	Sub.w	d6,d5				; d5=Anzahl der Bytes aus
	Sub.w	d5,d4				; d4=modulo von D

	Moveq	#-1,d5
	Add.w	d7,d7				; mit d7 nehmen wir den Wert der Maske
	Lea	MaskRight,a0			; in a0 die Adresse der Tabelle
	Move.w	(a0,d7.w),d5		; d5=Maske	

	Mulu	#40,d1				; Ab hier normales Blitting...
	Move.w	d0,d2
	Lsr.w	#3,d0	
	Add.w	d0,d1	
	Lea	Screen,a0
	Adda.l	d1,a0
	Andi.w	#$000f,d2
	Ror.w	#4,d2				; effizienter als LSL #4,d2 und
								; dann LSL #8,D2
	Ori.w	#$09f0,d2		

	Btst	#6,2(a6)
WaitBlit1b:
	Btst	#6,2(a6)			; dmaconr - Warten Sie, bis der Blitter frei ist
	bne.s	WaitBlit1b

	Move.w	d2,$40(a6)			; bltcon0
	Move.l	d5,$44(a6)			; bltafwm
	Move.l	#Bob,$50(a6)		; bltapt
	Move.l	a0,$54(a6)			; bltdpt
	Move.w	d6,$64(a6)			; bltamod
	Move.w	d4,$66(a6)			; bltdmod
	Move.w	d3,$58(a6)			; bltsize
	Movem.l	(a7)+,d0-d7/a0
	Rts

IsInLeft:
	Mulu.w	#40,d1				; In diesem Fall verwenden wir den Blitter
	Move.w	d0,d2				; normalerweise ist da der bob drin
	Lsr.w	#3,d0				; die eingestellten Grenzen.
	Add.w	d0,d1	
	Lea	Screen,a0
	Add.l	d1,a0
	Andi.w	#$000f,d2
	Ror.w	#4,d2
	Ori.w	#$09f0,d2		

	Moveq	#-1,d7
	Clr.w	d7

	Btst	#6,2(a6)
WaitBlit1a:
	Btst	#6,2(a6)			; dmaconr - Warten Sie, bis der Blitter frei ist
	bne.s	WaitBlit1a

	Move.w	d2,$40(a6)			; bltcon0
	Move.w	#0,$42(a6)			; bltcon1
	Move.l	d7,$44(a6)			; bltafwm
	Move.l	#Bob,$50(a6)		; bltapt
	Move.l	a0,$54(a6)			; bltdpt
	Move.w	#-2,$64(a6)			; bltamod
	Move.w	#40-18,$66(a6)		; bltdmod
	Move.w	#(29*64)+(144/16),$58(a6)	; bltsize
ExitClipRight:
	Movem.l	(a7)+,d0-d7/a0
	Rts

; ****************************************************************************
; Diese Routine prüft, dass der Bob die physikalischen Grenzen des Bildschirms 
; nicht verlässt. In der Tat haben wir eine Routine erstellt, die die Teile 
; herausschneidet die rechts herauskommen, aber wir haben nichts getan für 
; die anderen Grenzen des Bildschirms. Diese Routine prüft also, ob die
; Koordinaten immer im richtigen Bereich sind.
; ****************************************************************************

CheckLimit:
	Cmpi.w	#XMin,d0			; Ist es von links gekommen?
	Bge.s	Limit2				; nein, dann siehe oben und unten
	Move.w	#XMin,d0			; ja, dann stecke es wieder in unsere Grenzen
Limit2:
	Cmpi.w	#YMin,d1			; Ist es von oben gekommen?
	Bge.s	Limit3				; ein, dann siehe unten
	Move.w	#YMin,d1			; ja, dann setze es wieder in Grenzen
	Bra.s	End_Limit			; und dann kommst du raus weil unser bob nicht
								; gleichzeitig oben und unten stehen kann.
Limit3:
	Cmpi.w	#YMax,d1			; Wie oben, aber wir überprüfen das Limit
	Blt.s	End_Limit			; vertikal unten.
	Move.w	#YMax,d1
End_Limit
	Rts
	
; ****************************************************************************
; Diese Routine liest den Joystick und aktualisiert die in den 
; sprite_x und sprite_y Variablen enthaltenen Werte
; ****************************************************************************

LeggiJoyst:
	Move.w	$dff00c,D3			; JOY1DAT
	Btst.l	#1,D3				; Bit 1 sagt uns, ob wir nach rechts gehen
	Beq.s	NODESTRA			; Wenn es Null ist, gehe nicht rechts
	Addq.w	#1,d0				; Wenn es 1 ist, verschieben Sie das Sprite um ein Pixel
	Bra.s	CHECK_Y				; Gehe zur Y-Steuerung
NODESTRA:
	Btst	#9,D3				; Bit 9 sagt uns, ob wir nach links gehen
	Beq.s	CHECK_Y				; Wenn es Null ist, gehe nicht nach links
	Subq.w	#1,d0				; Wenn es 1 ist, bewege das Sprite
CHECK_Y:
	Move.w	D3,D2				; Kopieren Sie den Wert des Registers
	Lsr.w	#1,D2				; scrollt die Bits eines Ortes nach rechts
	Eor.w	D2,D3				; führt das Exklusive OR. Jetzt können wir testen
	Btst	#8,D3				; Lass uns testen, ob es hoch geht
	Beq.s	NOALTO				; Wenn nicht, überprüfen Sie, ob es sinkt
	Subq.w	#1,d1				; wenn Sie das Sprite bewegen
	Bra.s	ENDJOYST
NOALTO:
	Btst	#0,D3				; Lass uns testen, ob es runter geht
	Beq.s	ENDJOYST			; wenn nicht fertig
	Addq.w	#1,d1				; wenn Sie das Sprite bewegen
ENDJOYST:
	Rts

;****************************************************************************
; Diese Routine löscht den Bildschirm über den Blitter.
;****************************************************************************

CancellaSchermo:
	btst	#6,2(a6)
WBlit3:
	btst	#6,2(a6)			; Warten Sie, bis der Blitter fertig ist
	bne.s	wblit3

	move.l	#$01000000,$40(a6)	; BLTCON0 und BLTCON1: Löschung
	move.w	#$0000,$66(a6)		; BLTDMOD=0
	move.l	#Screen,$54(a6)		; BLTDPT - Adresse Bildschirm
	move.w	#(64*256)+20,$58(a6)	; BLTSIZE (starte Blitter !)
								; Löscht den gesamten Bildschirm

	rts

; ****************************************************************************

		section	cop,data_C

copperlist
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$38				; DdfStart
	dc.w	$94,$d0				; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod

	dc.w	$100,$1200			; BPLCON0 - 2 bitplanes lowres

	dc.w	$180,$000			; Color0
	dc.w	$182,$aaa			; Color1

BPLPOINTER1:
	dc.w	$e0,0,$e2,0			; erste bitplane

	dc.l	$ffff,$fffe			; Ende copperlist

******************************************************************************

; Der Bob ist eine Bitebene, 128 Pixel breit und 29 Zeilen hoch

Bob:
	Incbin	"/Sources/Amiga.bmp"

; ****************************************************************************

; Dies ist die Tabelle, die wir benötigen, um die unerwünschten Pixel "auszuschneiden".

MaskRight:
	dc.w	%1111111111111111
	dc.w	%1111111111111110
	dc.w	%1111111111111100
	dc.w	%1111111111111000
	dc.w	%1111111111110000
	dc.w	%1111111111100000
	dc.w	%1111111111000000
	dc.w	%1111111110000000
	dc.w	%1111111100000000
	dc.w	%1111111000000000
	dc.w	%1111110000000000
	dc.w	%1111100000000000
	dc.w	%1111000000000000
	dc.w	%1110000000000000
	dc.w	%1100000000000000
	dc.w	%1000000000000000

; ****************************************************************************

	Section Miobuffero,BSS_C

Screen:
		ds.b	(320*256)/8

	end

Dieses kurze Programm zeigt, wie durch den Blitter Bob Clipping möglich ist.
Dies ist in vielen Videospielen nützlich. Wir sehen das erste mal überhaupt was
Clipping ist. Clipping-Routinen sind vor allem in der 2D Grafik bekannt, aber
auch in 3D muss es natürlich oft gemacht werden.
Es geht um das Verfolgen von Zeilen, die aus dem verfügbaren Videospeicher
kommen. Stellen Sie sich zum Beispiel eine Linie mit einer Koordinate (300,450)
vor, die wird in einem Bildschirm von 320x256 in Luft gezeichnet. Das merken
wir sofort.

Wenn die Linie mit irgendeinem Algorithmus gezeichnet wird, könnte letzterer in
einen reservierten Speicherbereich schreiben, zum Beispiel für den Code und
dann die Maschine zum Absturz bringen. Gleiches gilt für die Bobs.
Nehmen wir an, wir haben einen Videobereich von 320x256 und einen Bob von
64x20 Pixel. Unser Videobild ist aufbauend platziert, d.h. die Koordinaten in
der oberen linken Ecke (es kann auch eine andere Koordinate sein) sind x und y.
Durch den Blitter können wir diesen Bob an jeden Punkt der Fläche der zur 
Verfügung steht platzieren. Aber was passiert, wenn wir unseren Bob am
Koordinatenpunkt zum Beispiel (300,120) platzieren. Schauen wir uns die
Zeichnung an:


  (0x0) _______________________
	|			|
	|			|
	|	   (300x120) ___|___
	|		    |	|   |
	|		    | A	| B |
	|		    |___|___|
	|			|
	|			|
	|			|
	|			|
	|_______________________|(320x256)



Wie zu sehen ist, betritt der Bob "B" den Videobereich nicht und verlässt ihn
draußen. Die Frage ist "Aber wo genau geht er hin?", Die Antwort lautet "hängt
von den Fällen ab". Tatsächlich nehmen wir immer an, dass wir einen
Videobereich von 320x256 auf 1 Bitplane haben. Solange wir uns in diesem
Bereich bewegen besteht keine Gefahr, dass der Blitter die Speicherbereiche
ruiniert. In der Tat, der Teil des Bobs, der herauskommt, wird nach links
fallen, aber ein Pixel niedriger, also wird so etwas passieren.



  (0x0) _______________________
	|			|
	|			|
	|	   (300x120) ___|
	|___		    |	|
	|   |		    | A	|
	| B |		    |___|
	|___|			|
	|			|
	|			|
	|			|
	|_______________________|(320x256)


Man denke nur an die Tatsache, dass der Speicher sequentiell ist. Also
angekommen am letzten Wort einer Zeile, dann ist das nächste Wort das erste der
nächsten Zeile. In diesem Fall sehen wir also, dass ein Risiko für unsere Daten
oder unseren Code besteht, aber nehmen wir an, die Koordinate ist in der Nähe
von (320,256). In diesem Fall riskieren wir wirklich viel! Es bleibt jedoch
eine Tatsache, dass die Portion Bob unansehnlich ist.
Haben Sie jemals ein Spiel gesehen, bei dem die von rechts kommenden Bobs aus
dem Spiel kommen? Sinvan zu Silvan? Es gibt verschiedene Lösungen, um diesen
Teil des Bobs der nutzlos und gefährlich wird zu beseitigen. Man könnte
folgendes tun:
Ein größerer Videobereich, dh Hinzufügen von Sicherheitszonen rechts und links
vom Videospeicher. Ich meine so etwas:



  	 _______________________________________
	|\\\\\\\|			|\\\\\\\|	
	|\\\\\\\|			|\\\\\\\|
	|\\\\\\\|	   		|\\\\\\\|
	|\\\\\\\|		    	|\\\\\\\|
	|\\\\\\\|		    	|\\\\\\\|
	|\\\\\\\|		    	|\\\\\\\|  
	|\\\\\\\|			|\\\\\\\|
	|\\\\\\\|			|\\\\\\\|
	|\\\\\\\|			|\\\\\\\|
	|\\\\\\\|			|\\\\\\\|
	|\\\\\\\|_______________________|\\\\\\\|
       

       |\\\|
       |\\\| <- Sicherheitsspeicherbereich
       |\\\|


Wie aus der Zeichnung hervorgeht, garantiert uns diese Lösung zwei Dinge: die
erste ist, dass die überflüssigen Bob-Teile unsere Daten nicht beeinflussen und
zweitens, dass diese Teile nicht auf die linke Seite passen. Aber lassen sie
uns einen bisschen die Kanten machen.... 
Die Dimensionen dieser Bereiche dürfen höchstens gleich sein wie die maximale 
horizontale Abmessung der Bobs. Wenn wir also einen Bob haben, mit einer
maximalen horizontalen Abmessung von 128 Pixel und wir verwenden es auch in
einem 5-Bitebenen-Kontext benötigen wir 2 Bereiche von
((256x128) / 8) * 5 = 20480 Bytes, dh insgesamt 40960 müssen wir auch für die
Sicherheitsbereiche berücksichtigen, die am oberen und unteren Rand unserer 
Videofläche platziert werden sollte. Das wäre für die Speicherbelegung zu viel.
Die Lösung muss daher in einem Algorithmus gesucht werden, der nur die Teile
vom Bob in die richtigen Speicherbereiche schreibt und den Rest weglässt. Alles
kann mit dem Blitter gemacht werden. 
Das Programm zeigt also, wie es möglich ist, von hier aus zu arbeiten. Einige
Überlegungen. Zuallererst, wenn unser Bob an einer Koordinate platziert werden
soll, so dass sich dann der ganze Bob im Videospeicher befindet.
Dies kann mit einer klassischen Routine durchgeführt werden, bei der ein Bob
mit dem Blitter bewegt wird. Variationen treten auf, wenn die xb-Koordinate in
der rechten unteren Ecke liegt und mit der maximalen Begrenzung des
Videospeichers zusammenfällt und übersteigt sie total.
Bereiten wir uns auf ein recht komplexes Argument vor.
Sei XM von nun an die Grenzkoordinate unseres Videobereichs, und nehmen Sie
auch an, dass XM ein Vielfaches von 16 Pixeln ist (der Einfachheit halber).
Machen wir also Beobachtungen. Unser Bob, wenn es mit XM zusammenfällt, dann
ist die x-Koordinate oben links ebenfalls ein Vielfaches von 16 Pixeln. Da der
Bob mehrere horizontale Abmessungen von 16 Pixel hat. Tatsächlich, wenn wir
einen 64-Pixel-Bob und XM = 320 haben, fällt xb mit XM zusammen.
Wir werden das xa = 320-64 = 256 haben, was immer noch ein Vielfaches von 16
ist, das heißt, wenn sich unser Bob nur zu einem anderen Pixel xb bewegt, das
es dasselbe sein wird zu XM + 1, aber das Wichtigste ist, dass wir im ersten
Teil Wortfolgen (XM / 16) in unserem Beispiel ist XM = 320 das Wort schreiben
werden. Wenn Sie das verstehen, haben Sie bestanden.
Einige von Ihnen die vielleicht schon viel mit dem Blitter erlebt haben, sehen
schon die Lösung für das Problem. 
Tatsächlich müssen wir jetzt verhindern, dass der Blitter in das eingedrungene
Wort schreibt. Das habe ich ganz einfach mit dem BLTLWM-Blitterregister auf
"1111111111111110" getan. Auf diese Weise werden die letzten Bits des letzten
Wortes vom Bob von uns nicht kopiert. Wenn sich unser Bob zu einem anderen
Pixel bewegt dann wird das Wort auf "1111111111111100" gesetzt.
Aber was passiert, wenn unser Bob aus 16 Pixel mehr aus dem Videofenster kommt?
Es ist offensichtlich, dass Wir das BLTLWM-Register nicht mehr verwenden
können, aber wir müssen auch die Form verwenden. Wenn wir einen Nicht-RAW-Bob
haben, liegen die Informationen nacheinander im Speicher. Dann setzen wir das
Modulo der Quelle auf Null wenn unser Bob jetzt 16 Pixel raus ist, dann müssen
wir unserem Blitter so etwas sagen: Mein Bob hat jetzt die Dimension x-16 und
die Höhe y, also lese x-16 Bit und sofort danach überspringen sie 16 (die
außerhalb des Videofensters). Schreiben Sie stattdessen, wenn Sie schreiben
x-16 und springe dann auf 320-(x-16) Pixel. Es ist offensichtlich, dass wir
nicht mit dem Blitter auf diese Weise und in Punkto Pixel sprechen aber ich
hoffe ich habe es geschafft das sie mich verstehen. Kombinieren Sie also die
beiden Techniken zum Maskieren unerwünschter Bits und der Sprung von nutzlosen
Informationen durch das Modulo, das wir tun können ein Bob schnell.
Logischerweise dauert es weniger Zeit, nichts zu tun es aber denken wir auch
daran, dass auf diese Weise mehr Teile vom Bob herauskommen und der Blitter
beendet den Kopiervorgang.
Mit dem Joystick kannst du einen 128x29 Pixel großen Bob bewegen und versuchen,
ihn zu ändern. Die XMax-Koordinate (muss ein Vielfaches von 16 sein). In
diesem Beispiel beschränken wir uns darauf, die Technik des "Schneidens" des
Bobs zu veranschaulichen ohne sich um den Hintergrund zu sorgen. Tatsächlich
gestalten wir unseren Bob mit einer einfachen Kopie. Um das Listing nicht 
schwieriger zu machen, führen wir bei jeder Ausführung jedes Mal  eine Löschung
des gesamten Bildschirms statt nur des Rechtecks, das den Bob umschließt durch.
Sie können versuchen, diese Technik auf das Beispiel des gesamten Bobs zu
erweitern (dh mit Wiederherstellung des Hintergrunds). In diesem Fall müssen
Sie bedenken dass, wenn der Bob nach rechts "abgeschnitten" wird, dass das
Modulo, die Größe des Blitts nicht nur in der Bob - Design - Routine (wie
in diesem Beispiel geschehen), aber auch in den Rettungs- und
Wiederherstellungsroutinen des Hintergrunds gewechselt werden müssen.

