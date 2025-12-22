
; soc14.s = perfectBob.s

; Coded by Denis Duplan for Stash of Code (http://www.stashofcode.fr, stashofcode@gmail.com) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Anzeige und Verschieben eines 64 x 64 Pixel großen BOB (die Abmessungen können über die
; Konstanten BOB_DX und BOB_DY verändert werden, sofern BOB_DX ein Vielfaches von 16 ist)
; in 32 Farben auf einem Hintergrund aus 5 Bitplanes im RAW-Blitter-Modus, mit Maskierung.
; Im Gegensatz zu bobRAWB.s wird der Hintergrund auf dem einzigen rechteckigen Bereich 
; wiederhergestellt, den das BOB einnahm, bevor es verschoben wurde (fast perfekte
; Wiederherstellung, denn wenn das BOB keine transparenten Pixel enthält, weil es ein
; Rechteck ist, kann man sagen, dass nur die Pixel, die sie überdecken, wiederhergestellt
; werden, was nützlich ist, um Fenster zu verwalten).

; In der Realität könnte man auch einfach nur den Hintergrund wiederherstellen, ohne ihn
; zu verdecken. Wenn sich der Hintergrund zwischen dem Zeitpunkt, an dem das BOB angezeigt
; wurde, und dem Zeitpunkt, an dem das BOB gelöscht werden soll, nicht geändert hat,
; können Sie die Wörter in jeder Zeile, die das BOB überdeckt hat, auch wenn es nur ein 
; Teil davon war, vollständig kopieren. Was perfekt ist, ist nicht unbedingt das Beste,
; denn es ist nicht immer das Effektivste :) Daher habe ich eine optimierte Version von
; _clearBOB hinzugefügt, _clearBOBFast. Verwenden Sie die Konstante CLEARFAST, um zwischen
; _clearBOB und _clearBOBFAst zu wechseln.

;********** Direktiven **********

	SECTION yragael,CODE_C

;********** Konstanten **********

; Programm

DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_DEPTH=5
COPSIZE=10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*2*4+4
	; 10*4						Konfiguration der Anzeige
	; DISPLAY_DEPTH*2*4			Adressen der Bitebenen
	; (1<<DISPLAY_DEPTH)*2*4	Palette
	; 4							$FFFFFFFE
DEBUG=1			; 0 : Zeigen Sie die verbrauchte Zeit an, indem Sie während der Berechnungen die Farbe von 0 auf rot ändern.
				; 1 : Verbrauchte Zeit nicht anzeigen
CLEARFAST=1		; 0 : _clearBOB verwenden (d.h. den Hintergrund möglichst genau wiederherstellen)
				; 1 : _clearBOBFast verwenden (d.h.: den Hintergrund auf breitester Ebene wiederherstellen)

;********** Macros **********

; Warten Sie auf den Blitter. Wenn der zweite Operand eine Adresse ist, testet BTST
; nur die Bits 7-0 des gezeigten Bytes, aber da der erste Operand als Modulo-8-Bitnummer
; behandelt wird, bedeutet BTST #14,DMACONR(a5), dass das Bit 14%8=6 des höchstwertigen
; Bytes von DMACONR getestet wird, was gut zu BBUSY passt...

WAIT_BLITTER:	MACRO
_WAIT_BLITTER0\@
	btst #14,DMACONR(a5)
	bne _WAIT_BLITTER0\@
_WAIT_BLITTER1\@
	btst #14,DMACONR(a5)
	bne _WAIT_BLITTER1\@
	ENDM

;********** Initialisierung **********

	; Register auf den Stack

	movem.l d0-d7/a0-a6,-(sp)
	lea $DFF000,a5

	; Speicher in CHIP zuordnen, der für die Copperliste auf 0 gesetzt ist

	move.l #COPSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,copperlist

	; Speicher in Chip zuweisen auf 0 gesetzt für Hintergrund (background)

	move.l #DISPLAY_DEPTH*(DISPLAY_DX*DISPLAY_DY)>>3,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,background

	; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt ist (für Anzeige) (front buffer)

	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,frontBuffer

	; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt (für Erstellung) (back buffer)

	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,backBuffer

	; System ausschalten

	movea.l $4,a6
	jsr -132(a6)

	; Warten Sie auf ein VERTB (damit die Sprites nicht sabbern) und
	; schalten Sie alle Hardware-Interrupts und DMAs aus.

	bsr _waitVERTB
	move.w INTENAR(a5),oldintena
	move.w #$7FFF,INTENA(a5)
	move.w INTREQR(a5),oldintreq
	move.w #$7FFF,INTREQ(a5)
	move.w DMACONR(a5),olddmacon
	move.w #$07FF,DMACON(a5)

	;---------- Copperlist ----------

	movea.l copperlist,a0

	; Konfiguration des Bildschirms

	move.w #DIWSTRT,(a0)+
	move.w #(DISPLAY_Y<<8)!DISPLAY_X,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #((DISPLAY_Y+DISPLAY_DY-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),(a0)+
	move.w #BPLCON0,(a0)+
	move.w #(DISPLAY_DEPTH<<12)!$0200,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #$0000,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #$0000,(a0)+
	move.w #DDFSTRT,(a0)+
	move.w #((DISPLAY_X-17)>>1)&$00FC,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC,(a0)+
	move.w #BPL1MOD,(a0)+
	move.w #(DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #(DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),(a0)+

	; Kompatibilität OCS mit AGA

	move.w #FMODE,(a0)+
	move.w #$0000,(a0)+

	; Adressen der Bitebenen

	move.w #BPL1PTH,d0
	move.l frontBuffer,d1
	moveq #DISPLAY_DEPTH-1,d2
_copperListBitplanes:
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	addi.l #DISPLAY_DX>>3,d1
	dbf d2,_copperListBitplanes

	; Palette

	lea palette,a1
	move.w #COLOR00,d0
	moveq #(1<<DISPLAY_DEPTH)-1,d1
	IFNE DEBUG				; Füge einen unnötigen MOVE hinzu, der COLOR00 nicht beeinflusst, 
							; um die Größe der Copperlist nicht zu verändern (kann nützlich sein)
	addq.w #2,d0
	move.w d0,(a0)+
	move.w (a1)+,(a0)+
	subq.w #1,d1
	ENDIF
_palette:
	move.w d0,(a0)+
	addq.w #2,d0
	move.w (a1)+,(a0)+
	dbf d1,_palette

	; Ende

	move.l #$FFFFFFFE,(a0)

	; DMA aktivieren

	bsr _waitVERTB
	move.w #$83C0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

	; die Copperlist starten

	move.l copperlist,COP1LCH(a5)
	clr.w COPJMP1(a5)

;********** Hauptprogramm **********

BOB_DX=64		; Vielfaches von 16 (nur für _drawBOB, da _clearBOB flexibler ist: siehe dessen Anleitung)
BOB_DY=64
BOB_X=(DISPLAY_DX-BOB_DX)>>1
BOB_Y=(DISPLAY_DY-BOB_DY)>>1

	; Zeichnen Sie den Hintergrund aus 16 x 16 Quadraten aufeinanderfolgender
	; Farben, die auf Farbe 0 zurückspringen.

	moveq #0,d0
	movea.l background,a0
	move.w #(DISPLAY_DY>>4)-1,d1
_checkerDrawRows:
	move.w #(DISPLAY_DX>>4)-1,d2
_checkerDrawCols:
	move.b d0,d3
	movea.l a0,a1
	move.w #DISPLAY_DEPTH-1,d4
_checkerDrawBitplanes:
	lsr.b #1,d3
	bcc _checkerSkipBitplane
	movea.l a1,a2
	move.w #16-1,d5
_checkerDrawLines:
	move.w #$FFFF,(a2)
	lea DISPLAY_DEPTH*(DISPLAY_DX>>3)(a2),a2
	dbf d5,_checkerDrawLines
_checkerSkipBitplane:
	lea DISPLAY_DX>>3(a1),a1
	dbf d4,_checkerDrawBitplanes
	lea 2(a0),a0
	addq.b #1,d0
	dbf d2,_checkerDrawCols
	lea (16*DISPLAY_DEPTH-1)*(DISPLAY_DX>>3)(a0),a0
	dbf d1,_checkerDrawRows

	; Kopieren Sie den Hintergrund in den Front- und Backpuffer.

	move.w #(DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),BLTBMOD(a5)
	move.w #(DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),BLTDMOD(a5)
	move.w #$05CC,BLTCON0(a5)	; USEA=0, USEB=1, USEC=0, USED=1, D=B
	move.w #$0000,BLTCON1(a5)
	move.l background,a0
	move.l frontBuffer,a1
	move.l backBuffer,a2
	move.w #DISPLAY_DEPTH-1,d0
_copyBackground:
	move.l a0,BLTBPTH(a5)
	move.l a1,BLTDPTH(a5)
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER
	move.l a0,BLTBPTH(a5)
	move.l a2,BLTDPTH(a5)
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER
	lea DISPLAY_DX>>3(a0),a0
	lea DISPLAY_DX>>3(a1),a1
	lea DISPLAY_DX>>3(a2),a2
	dbf d0,_copyBackground

	; Erstellen Sie das BOB, indem Sie einen Teil des Hintergrunds kopieren und
	; ihn gleichzeitig mit der Maske kombinieren (dieser Schritt ist erforderlich, 
	; da die transparenten Pixel des BOB in diesem tatsächlich transparent sein müssen,
	; da die Maske bei der Anzeige des BOB nur auf den Hintergrund angewendet wird:
	; Die in _drawBOB verwendete Formel lautet D=A+bC und nicht D=BA+bC).

	move.w #$0788,BLTCON0(a5)		; USEA=0, USEB=1, USEC=1, USED=1, D=BC
	move.w #$0000,BLTCON1(a5)
	move.w #2,BLTBMOD(a5)
	move.w #(DISPLAY_DX-BOB_DX)>>3,BLTCMOD(a5)
	move.w #0,BLTDMOD(a5)
	move.l #BOBMask,BLTBPTH(a5)
	move.l background,BLTCPTH(a5)
	move.l #BOB,BLTDPTH(a5)
	move.w #((DISPLAY_DEPTH*BOB_DY)<<6)!(BOB_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER
	
	; Hauptschleife

_loop:

	; BOB löschen

	lea clearBOBData,a0
	move.w #DISPLAY_DEPTH,OFFSET_CLEARBOB_DEPTH(a0)
	move.w oldBobX,OFFSET_CLEARBOB_X(a0)
	move.w oldBobY,OFFSET_CLEARBOB_Y(a0)
	move.w #BOB_DX,OFFSET_CLEARBOB_DX(a0)
	move.w #BOB_DY,OFFSET_CLEARBOB_DY(a0)
	move.l background,OFFSET_CLEARBOB_SRC(a0)
	move.l backBuffer,OFFSET_CLEARBOB_DST(a0)
	move.w #DISPLAY_DX,OFFSET_CLEARBOB_SRCDSTWIDTH(a0)
	IFNE CLEARFAST
	bsr _clearBOB
	ELSE
	bsr _clearBOBFast
	ENDC

	; BOB bewegen
	
	move.w bobX,d0
	move.w d0,oldBobX
	add.w bobSpeedX,d0
	bge _moveBobNoUnderflowX
	neg.w bobSpeedX
	add.w bobSpeedX,d0
	bra _moveBobNoOverflowX
_moveBobNoUnderflowX:
	cmpi.w #DISPLAY_DX-BOB_DX,d0
	blt _moveBobNoOverflowX
	neg.w bobSpeedX
	add.w bobSpeedX,d0
_moveBobNoOverflowX:
	move.w d0,bobX

	move.w bobY,d0
	move.w d0,oldBobY
	add.w bobSpeedY,d0
	bge _moveBobNoUnderflowY
	neg.w bobSpeedY
	add.w bobSpeedY,d0
	bra _moveBobNoOverflowY
_moveBobNoUnderflowY:
	cmpi.w #DISPLAY_DY-BOB_DY,d0
	blt _moveBobNoOverflowY
	neg.w bobSpeedY
	add.w bobSpeedY,d0
_moveBobNoOverflowY:
	move.w d0,bobY

	; BOB anzeigen

	lea drawBOBData,a0
	move.w #DISPLAY_DEPTH,OFFSET_DRAWBOB_DEPTH(a0)
	move.w bobX,OFFSET_DRAWBOB_X(a0)
	move.w bobY,OFFSET_DRAWBOB_Y(a0)
	move.w #BOB_DX,OFFSET_DRAWBOB_DX(a0)
	move.w #BOB_DY,OFFSET_DRAWBOB_DY(a0)
	move.l #BOBMask,OFFSET_DRAWBOB_MASK(a0)
	move.l #BOB,OFFSET_DRAWBOB_SRC(a0)
	move.w #BOB_DX,OFFSET_DRAWBOB_SRCWIDTH(a0)
	move.w #0,OFFSET_DRAWBOB_SRCX(a0)
	move.w #0,OFFSET_DRAWBOB_SRCY(a0)
	move.l backBuffer,OFFSET_DRAWBOB_DST(a0)
	move.w #DISPLAY_DX,OFFSET_DRAWBOB_DSTWIDTH(a0)
	bsr _drawBOB

	; Debugging: Hintergrundfarbe am Ende der Schleife auf xxx ändern

	WAIT_BLITTER
	IFNE DEBUG
	move.w #$0000,COLOR00(a5)
	ENDC
	moveq #1,d0
	jsr _wait
	IFNE DEBUG
	move.w #$0F00,COLOR00(a5)
	ENDC

	; Front- und Backpuffer umkehren

	move.l frontBuffer,d0
	move.l backBuffer,d1
	move.l d0,backBuffer
	move.l d1,frontBuffer
	movea.l copperlist,a0
	lea 10*4+2(a0),a0
	moveq #DISPLAY_DEPTH-1,d0
	move.l frontBuffer,d1
_swapBitplanes:
	swap d1
	move.w d1,(a0)
	swap d1
	move.w d1,4(a0)
	addi.l #DISPLAY_DX>>3,d1
	lea 2*4(a0),a0
	dbf d0,_swapBitplanes

	; Testen eines Drucks der linken Maustaste

	btst #6,$BFE001
	bne _loop

;********** Ende **********

	; Hardware-Interrupts und DMAs ausschalten

	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)
	move.w #$07FF,DMACON(a5)

	; Hardware-Interrupts und DMAs wiederherstellen

	move.w olddmacon,d0
	bset #15,d0
	move.w d0,DMACON(a5)
	move.w oldintreq,d0
	bset #15,d0
	move.w d0,INTREQ(a5)
	move.w oldintena,d0
	bset #15,d0
	move.w d0,INTENA(a5)

	; Copperlist wiederherstellen

	lea graphicsLibrary,a1
	movea.l $4,a6
	jsr -408(a6)
	move.l d0,a1
	move.l 38(a1),COP1LCH(a5)
	clr.w COPJMP1(a5)
	jsr -414(a6)

	; System wiederherstellen

	movea.l $4,a6
	jsr -138(a6)

	; Speicher freigeben

	movea.l copperlist,a1
	move.l #COPSIZE,d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l background,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l frontBuffer,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l backBuffer,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

	; Register wiederherstellen

	movem.l (sp)+,d0-d7/a0-a6
	rts

;********** Routinen **********

	INCLUDE "common/registers.s"
	INCLUDE "common/wait.s"


;---------- Löschen eines BOB in einer Fläche in RAWB ----------

; Eingang(s) :
;	(die Struktur clearBOBData)
; Ausgang(s) :
;	(rien)
; Hinweis:
; Das ist etwas mehr als das Löschen eines BOB, da die Breite des Bereichs
; von der Quelle in das Ziel kopiert wird, kann beliebig sein.
;
; Die Breite des zu kopierenden Bereichs ist auf DISPLAY_DX beschränkt
; (ansonsten müssen Sie die Größe von copyMaskData ändern).
;
; Achtung! Kein WAIT_BLITTER am Ende.

_clearBOB:
	movem.l d0-d4/a0-a1,-(sp)
	lea clearBOBData,a0

	WAIT_BLITTER

	;++++++++++ Die Maske aufbauen (Erinnerung: In Bezug auf A werden BLTAFWM und 
	; BLTALWM mit AND verknüpft, wenn der BOB auf einem Wort steht). ++++++++++

; In jedem Fall enthält die Maske mindestens ein Wort, das standardmäßig auf $FFFF initialisiert und
; gezählt wird. Beachten Sie, dass die Anzahl der Wörter sicherlich nicht 255 übersteigt, sodass die 
; Anrechnung in einem Byte erfolgt (d.h. ADDQ.B und nicht ADDQ.W im Folgenden).
	
	lea clearBOBMask,a1
	move.w #$FFFF,(a1)
	moveq #1,d4
	move.w OFFSET_CLEARBOB_X(a0),d0
	move.w OFFSET_CLEARBOB_DX(a0),d1
	move.w d0,d2
	add.w d1,d2

; Verschiebt das erste Wort der Maske, falls der BOB nicht auf einer Abszisse beginnt, die ein Vielfaches von 16 ist.

	move.w #$FFFF,d3
	and.w #$000F,d0		; Zur Erinnerung: LSR Dx,Dy = LSR (Dx % 64),Dy: Für LSR (Dx % 16),Dy würde es also genügen,
						; die Bits 5-4 von D0 durch AND.B #$0F,D0 zu löschen, aber D0 wird für ein späteres ADD.W
						; verwendet, so dass auch seine 8 höchstwertigen Bits gelöscht werden müssen.
	beq _copyAreaNoFirstWordShift
	lsr.w d0,d3
	move.w d3,(a1)

_copyAreaNoFirstWordShift:

; Reduzieren Sie die Anzahl der noch zu verarbeitenden Maskenbits um die Anzahl der Maskenbits, die im ersten Wort
; vorkommen (oder vorkommen können, da die Maske vielleicht weniger breit ist): DX -= 16 - X. Diese Länge wird
; null oder negativ, wenn die Maske nur das erste Wort fasst. In diesem Fall sollten Sie direkt damit beginnen,
; das letzte Wort zu bestimmen.

	subi.w #16,d1
	add.w d0,d1
	ble _copyAreaNoMiddleWords

; An dieser Stelle wissen wir, dass sich die Maske über das erste Wort hinaus auf mindestens ein weiteres Wort
; erstreckt. Es gibt drei mögliche Fälle (ein mittleres Wort ist ein Wort, bei dem alle Bits auf 1 gesetzt sind,
; das Endwort ist ein Wort, bei dem nur einige Bits auf 1 gesetzt sind): (1) mittlere Wörter ohne Endwort,
; (2) mittlere Wörter und ein Endwort, (3) nur ein Endwort. Zählen Sie vorerst ein weiteres Wort und 
; initialisieren Sie dieses Wort auf $FFFF.
	
	moveq #2,d4
	addq.l #2,a1
	move.w #$FFFF,(a1)

; Zählen Sie die mittleren Wörter: Das ist die verbleibende Länge geteilt durch 16. Wenn es keine
; mittleren Wörter gibt, versuchen Sie direkt, das letzte Wort zu bestimmen.

	lsr.w #4,d1
	beq _copyAreaNoMiddleWords

; Addieren Sie die Anzahl der mittleren Wörter zur Anzahl der Wörter, wobei Sie derzeit davon ausgehen,
; dass das letzte Wort ein mittleres Wort ist, so dass es bereits früher gezählt worden wäre (MOVEQ #2,d4).

	add.b d1,d4
	subq.b #1,d4

; Fügen Sie die mittleren Wörter hinzu, die also Wörter mit $FFFF sind.


	move.w #$FFFF,d0
_copyAreaSetMiddleWords:
	move.w d0,(a1)+
	subq.w #1,d1
	bne _copyAreaSetMiddleWords

; Überprüfen, ob das Endwort ein Mittelwort ist...

	and.b #$0F,d2
	beq _copyAreaNoLastWordShift

; ...und wenn das Endwort kein Medianwort ist, zählen Sie ein weiteres Wort und initialisieren Sie
; dieses Wort auf $FFFF. Da es nicht nötig ist, diesen Test zu wiederholen, beginnen wir direkt 
; damit, das Endwort zu verschieben.

	addq.b #1,d4
	move.w #$FFFF,(a1)
	bra _copyAreaShiftLastWord
_copyAreaNoMiddleWords:

; Hier kommt man an, egal ob es mittlere Wörter gibt oder nicht. Das laufende Wort ist das
; letzte Wort. Es kann mit dem ersten Wort verwechselt werden. Ist dies nicht der Fall,
; wurde es mit $FFFF initialisiert. Deshalb wird die hier berechnete Maske durch AND mit
; dem aktuellen Wort verknüpft, um das Endwort zu erzeugen.


	move.w #$FFFF,d0
	and.b #$0F,d2
	beq _copyAreaNoLastWordShift
_copyAreaShiftLastWord:
	lsr.w d2,d0
	not.w d0
	and.w d0,(a1)
_copyAreaNoLastWordShift:

; Diese unumgänglichen Zuordnungen wurden an das Ende verschoben, um sie nicht mehrfach in
; all dem Vorangegangenen unterbringen zu müssen.

	move.w d0,BLTALWM(a5)
	move.w d3,BLTAFWM(a5)

	;++++++++++ Zeiger und Modulos berechnen ++++++++++

	; Berechnen Sie den Offset die Zeiger der Quelle und des Ziels

	moveq #0,d0
	move.w OFFSET_CLEARBOB_X(a0),d0
	lsr.w #3,d0
	and.b #$FE,d0
	move.w OFFSET_CLEARBOB_SRCDSTWIDTH(a0),d1
	lsr.w #3,d1
	mulu OFFSET_CLEARBOB_DEPTH(a0),d1
	mulu OFFSET_CLEARBOB_Y(a0),d1
	add.l d1,d0

	movea.l OFFSET_CLEARBOB_SRC(a0),a1
	add.l d0,a1
	move.l a1,BLTAPTH(a5)
	movea.l OFFSET_CLEARBOB_DST(a0),a1
	add.l d0,a1
	move.l a1,BLTCPTH(a5)
	move.l a1,BLTDPTH(a5)
	move.l #clearBOBMask,BLTBPTH(a5)

	; Modulos berechnen

	move.w OFFSET_CLEARBOB_SRCDSTWIDTH(a0),d0
	lsr.w #3,d0
	move.w d4,d1
	add.w d1,d1
	sub.w d1,d0
	move.w d0,BLTAMOD(a5)
	move.w d0,BLTCMOD(a5)
	move.w d0,BLTDMOD(a5)
	neg.w d1
	move.w d1,BLTBMOD(a5)

	;++++++++++ Kopieren ++++++++++

	move.w #$0FF2,BLTCON0(a5)		; ASH3-0=0, USEA=1, USEB=1, USEC=1, USED=1, D=A+bC
	move.w #$0000,BLTCON1(a5)
	move.w OFFSET_CLEARBOB_DY(a0),d1
	mulu OFFSET_CLEARBOB_DEPTH(a0),d1
	lsl.w #6,d1
	or.w d4,d1
	move.w d1,BLTSIZE(a5)

	movem.l (sp)+,d0-d4/a0-a1
	rts

clearBOBData:
OFFSET_CLEARBOB_DEPTH=0
OFFSET_CLEARBOB_X=2
OFFSET_CLEARBOB_Y=4
OFFSET_CLEARBOB_DX=6
OFFSET_CLEARBOB_DY=8
OFFSET_CLEARBOB_SRC=10
OFFSET_CLEARBOB_DST=14
OFFSET_CLEARBOB_SRCDSTWIDTH=18
DATASIZE_CLEARBOB=20
	BLK.B DATASIZE_CLEARBOB,0

clearBOBMask:
	BLK.W DISPLAY_DX>>4,0

;---------- Löschen eines BOB in einer Fläche in RAWB (optimierte Version) ----------

; Eingang(s) :
;	(die Struktur clearBOBData)
; Ausgang(s) :
;	(nichts)
; Hinweis:
; Dies ist eine optimierte Version von _clearBOB, die lediglich alle
; Wörter, die auch nur teilweise vom BOB belegt sind, also nicht maskiert werden.
;
; Achtung! Kein WAIT_BLITTER am Ende.

_clearBOBFast:
	movem.l d0-d3/a0-a1,-(sp)
	lea clearBOBData,a0

	WAIT_BLITTER

	; Berechnen Sie die Anzahl der teilweise oder vollständig betroffenen Wörter

	moveq #0,d3
	move.w OFFSET_CLEARBOB_X(a0),d0
	move.w OFFSET_CLEARBOB_DX(a0),d1
	move.w d1,d2
	add.w d0,d2

	and.w #$000F,d0
	beq _clearBOBFastLeftAligned
	moveq #1,d3
	subi.w #16,d1
	add.w d0,d1
	ble _clearBOBFastRightAligned
_clearBOBFastLeftAligned:
	lsr.w #4,d1
	add.b d1,d3
	and.b #$0F,d2
	beq _clearBOBFastRightAligned
	addq.b #1,d3
_clearBOBFastRightAligned:

	; Berechnen des Offsets der Quell- und Zielzeiger

	moveq #0,d0
	move.w OFFSET_CLEARBOB_X(a0),d0
	lsr.w #3,d0
	and.b #$FE,d0
	move.w OFFSET_CLEARBOB_SRCDSTWIDTH(a0),d1
	lsr.w #3,d1
	mulu OFFSET_CLEARBOB_DEPTH(a0),d1
	mulu OFFSET_CLEARBOB_Y(a0),d1
	add.l d1,d0

	movea.l OFFSET_CLEARBOB_SRC(a0),a1
	add.l d0,a1
	move.l a1,BLTBPTH(a5)
	movea.l OFFSET_CLEARBOB_DST(a0),a1
	add.l d0,a1
	move.l a1,BLTDPTH(a5)

	; Modulos berechnen

	move.w OFFSET_CLEARBOB_SRCDSTWIDTH(a0),d0
	lsr.w #3,d0
	move.w d3,d1
	add.w d1,d1
	sub.w d1,d0
	move.w d0,BLTBMOD(a5)
	move.w d0,BLTDMOD(a5)

	; Kopieren

	move.w #$05CC,BLTCON0(a5)		; USEA=0, USEB=1, USEC=0, USED=1, D=B
	move.w #$0000,BLTCON1(a5)
	move.w OFFSET_CLEARBOB_DY(a0),d0
	mulu OFFSET_CLEARBOB_DEPTH(a0),d0
	lsl.w #6,d0
	or.w d3,d0
	move.w d0,BLTSIZE(a5)

	movem.l (sp)+,d0-d3/a0-a1
	rts

;---------- Anzeige eines BOB in einer RAWB-Fläche ----------

; Eingang(s) :
;	(die Struktur drawBOBData)
; Ausgang(s) :
;	(nichts)
; Bemerkung:
; Der BOB wird aus der Quelle an einer Abszisse ausgeschnitten, die ein Vielfaches von 16 ist,
; und seine Breite muss ein Vielfaches von 16 sein.
;
; Quelle und Ziel müssen die gleiche Tiefe haben, und ihre
; Daten müssen in RAWBs organisiert sein.
;
; Das Modulo der Maske muss 0 sein (d. h. ihre Breite ist die Breite von BOB + 16).
;
; Achtung! Kein WAIT_BLITTER am Ende.

_drawBOB:
	movem.l d0-d1/a0-a2,-(sp)
	WAIT_BLITTER

	; Faktorisierbarer Teil, wenn mehrere BOBs nacheinander angezeigt werden

	move.w #$FFFF,BLTAFWM(a5)
	move.w #$0000,BLTALWM(a5)
	lea drawBOBData,a0
	move.w OFFSET_DRAWBOB_SRCWIDTH(a0),d0
	sub.w OFFSET_DRAWBOB_DX(a0),d0
	subi.w #16,d0
	asr.w #3,d0
	move.w d0,BLTAMOD(a5)
	move.w OFFSET_DRAWBOB_DSTWIDTH(a0),d0
	sub.w OFFSET_DRAWBOB_DX(a0),d0
	subi.w #16,d0
	asr.w #3,d0
	move.w d0,BLTCMOD(a5)

	; Holen Sie sich einen Zeiger auf das BOB an seinen Startkoordinaten (seine Abszisse ist ein Vielfaches von 16).

	movea.l OFFSET_DRAWBOB_SRC(a0),a1
	moveq #0,d0
	move.w OFFSET_DRAWBOB_SRCX(a0),d0
	lsr.w #3,d0
	and.b #$FE,d0
	add.l d0,a1
	move.w OFFSET_DRAWBOB_SRCY(a0),d0
	move.w OFFSET_DRAWBOB_SRCWIDTH(a0),d1
	lsr.w #3,d1
	mulu OFFSET_DRAWBOB_DEPTH(a0),d1
	mulu d1,d0
	add.l d0,a1

	; Einen Zeiger auf den Standort des BOB an seinen Ankunftskoordinaten abrufen

	movea.l OFFSET_DRAWBOB_DST(a0),a2
	moveq #0,d0
	move.w OFFSET_DRAWBOB_X(a0),d0
	lsr.w #3,d0
	and.b #$FE,d0
	add.l d0,a2
	move.w OFFSET_DRAWBOB_Y(a0),d0
	move.w OFFSET_DRAWBOB_DSTWIDTH(a0),d1
	lsr.w #3,d1
	mulu OFFSET_DRAWBOB_DEPTH(a0),d1
	mulu d1,d0
	add.l d0,a2

	; BOB anzeigen

	move.w OFFSET_DRAWBOB_X(a0),d0
	and.w #$000F,d0
	ror.w #4,d0
	move.w d0,BLTCON1(a5)		; BSH3-0=Verschiebung
	or.w #$0FF2,d0
	move.w d0,BLTCON0(a5)		; ASH3-0=Verschiebung, USEA=1, USEB=1, USEC=1, USED=1, D=A+bC
	move.w OFFSET_DRAWBOB_DX(a0),d0
	addi.w #16,d0
; Wenn alle Zeilen der Maske identisch sind, könnte die Maske eine Zeile sein, die vom Blitter
; wiederholt wird, anstatt in den Daten wiederholt zu werden :
; BOBMask:	BLK.W BOB_DX>>4,$F0F0
;			DC.W $0000
; Dazu müsste der Modulo der Maske lauten -((BOB_DX+16)>>3) :
;	move.w d0,d1
;	lsr.w #3,d1
;	neg.w d1
;	move.w d1,BLTBMOD(a5)
	move.w #0,BLTBMOD(a5)
	move.w OFFSET_DRAWBOB_DSTWIDTH(a0),d1
	sub.w d0,d1
	lsr.w #3,d1
	move.w d1,BLTDMOD(a5)
	move.l a1,BLTAPTH(a5)
	move.l OFFSET_DRAWBOB_MASK(a0),BLTBPTH(a5)
	move.l a2,BLTCPTH(a5)
	move.l a2,BLTDPTH(a5)
	move.w OFFSET_DRAWBOB_DY(a0),d1
	mulu OFFSET_DRAWBOB_DEPTH(a0),d1
	lsl.w #6,d1
	lsr.w #4,d0
	or.w d1,d0
	move.w d0,BLTSIZE(a5)

	movem.l (sp)+,d0-d1/a0-a2
	rts

drawBOBData:
OFFSET_DRAWBOB_DEPTH=0
OFFSET_DRAWBOB_X=2
OFFSET_DRAWBOB_Y=4
OFFSET_DRAWBOB_DX=6			; Vielfaches von 16
OFFSET_DRAWBOB_DY=8
OFFSET_DRAWBOB_MASK=10		; Modulo 0
OFFSET_DRAWBOB_SRC=14
OFFSET_DRAWBOB_SRCWIDTH=18
OFFSET_DRAWBOB_SRCX=20		; Vielfaches von 16
OFFSET_DRAWBOB_SRCY=22
OFFSET_DRAWBOB_DST=24
OFFSET_DRAWBOB_DSTWIDTH=28
DATASIZE_DRAWBOB=30
	BLK.B DATASIZE_DRAWBOB,0

;********** Daten **********

olddmacon:			DC.W 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
copperlist:			DC.L 0
graphicsLibrary:	DC.B "graphics.library",0
					EVEN
background:			DC.L 0
frontBuffer:		DC.L 0
backBuffer:			DC.L 0
BOB:				BLK.W DISPLAY_DEPTH*BOB_DY*(BOB_DX>>4),0
BOBMask:			REPT DISPLAY_DEPTH*BOB_DY	; Diese Wiederholung kann durch einen negativen Modulo vermieden werden (cf. _drawBOB)
					BLK.W BOB_DX>>4,$F0F0
					DC.W $0000
					ENDR
bobX:				DC.W BOB_X
bobY:				DC.W BOB_Y
oldBobX:			DC.W BOB_X
oldBobY:			DC.W BOB_Y
bobSpeedX:			DC.W 1
bobSpeedY:			DC.W 1
palette:
					DC.W $0000
					DC.W $0FFF
					DC.W $0700
					DC.W $0900
					DC.W $0B00
					DC.W $0D00
					DC.W $0F00
					DC.W $0070
					DC.W $0090
					DC.W $00B0
					DC.W $00D0
					DC.W $00F0
					DC.W $0007
					DC.W $0009
					DC.W $000B
					DC.W $000D
					DC.W $000F
					DC.W $0770
					DC.W $0990
					DC.W $0BB0
					DC.W $0DD0
					DC.W $0FF0
					DC.W $0707
					DC.W $0909
					DC.W $0B0B
					DC.W $0D0D
					DC.W $0F0F
					DC.W $0077
					DC.W $0099
					DC.W $00BB
					DC.W $00DD
					DC.W $00FF
