
; soc27.s = keyboard(interrupt).s 

; Coded by Denis Duplan for Stash of Code (http://www.stashofcode.fr, stashofcode@gmail.com) in 2017.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Lesen einer auf der Tastatur gedrückten Taste (Interrupt-Modus)

; TODO: $BFEE01 vor dem Ändern speichern und am Ende wiederherstellen?
; TODO: Der Code blockiert die Ausführung für ein paar Rasterzeilen, die mit der Tastatur bestätigt
; werden müssen, und das ist nicht elegant!

;********** Direktiven **********

	SECTION yragael,CODE_C

;********** Konstanten **********

; Programm

DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_DEPTH=1
COPSIZE=10*4+DISPLAY_DEPTH*2*4+2*4+4	; 10*4				Konfiguration der Anzeige
										; DISPLAY_DEPTH*2*4	 Adressen der Bitebenen
										; 2*4				Palette
										; 4					$FFFFFFFE

;********** Macros **********

WAIT_RASTER:		MACRO
_waitRaster\@:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmp.w #\1,d0
	bne _waitRaster\@
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
	move.l d0,copperList

	; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt ist

	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplanes

	; System ausschalten

	movea.l $4,a6
	jsr -132(a6)

	; Warten Sie auf ein VERTB (damit die Sprites nicht sabbern) und
	; schalten Sie alle Hardware-Interrupts und DMAs aus.

	WAIT_RASTER DISPLAY_Y+DISPLAY_DY
	move.w INTENAR(a5),oldintena
	move.w #$7FFF,INTENA(a5)
	move.w INTREQR(a5),oldintreq
	move.w #$7FFF,INTREQ(a5)
	move.w DMACONR(a5),olddmacon
	move.w #$07FF,DMACON(a5)

	; Interrupt-Vektoren umleiten

	lea $64,a0
	lea vectors,a1
	REPT 6
	move.l (a0),(a1)+
	move.l #_rte,(a0)+
	ENDR

;---------- Copperlist ----------

	movea.l copperList,a0

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
	move.w #0,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #0,(a0)+

	; Kompatibilität OCS mit AGA

	move.w #FMODE,(a0)+
	move.w #$0000,(a0)+

	; Adressen der Bitebenen

	move.w #BPL1PTH,d0
	move.l bitplanes,d1
	moveq #DISPLAY_DEPTH-1,d2
_cooperListBitplanes:
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	add.l #DISPLAY_DY*(DISPLAY_DX>>3),d1
	dbf d2,_cooperListBitplanes

	; Palette

	move.w #COLOR00,d1
	moveq #(1<<DISPLAY_DEPTH)-1,d0
_copperListColors:
	move.w d1,(a0)+
	addq.w #1,d1
	move.w #$0000,(a0)+
	dbf d0,_copperListColors

	; Ende

	move.l #$FFFFFFFE,(a0)

	; DMA aktivieren

	move.w #$83C0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

	; Start der Copperlist

	move.l copperList,COP1LCH(a5)
	clr.w COPJMP1(a5)

;********** Hauptprogramm **********

; Initiierung des Unterbrechungsmechanismus durch den CIA A bei Empfang der von der Tastatur gesendeten Bits.
; Wir entscheiden uns dafür, das Betriebssystem zu schonen, indem wir die Möglichkeit für den CIA A nicht
; unterbinden, andere Interrupt-Anforderungen als die, die uns interessiert, zu präsentieren 
; (mit anderen Worten, kein move.b #$1F,$BFED01 für begin).

	tst.b $BFED01				; Bestätigen Sie alle Unterbrechungsanforderungen von CIA A in ICR
	move.b #$88,$BFED01			; Deaktivieren Sie das Verbergen von SP-Interrupts in ICR
	and.b #$BF,$BFEE01			; Lösche das SPMODE-Bit in CRA, um den CIA A in den Empfangsmodus von Bits zu schalten,
								; die von der Tastatur übertragen werden
	move.w #$0008,INTREQ(a5)	; Bestätigen Sie jede Unterbrechungsanforderung der Ebene 2 (PORTS-Bit)
	move.l #_keyboard,$68		; Installieren Sie den Interrupt-Handler an der Vektoradresse des Level-2-Interrupts
	move.w #$C008,INTENA(a5)	; Aktivieren Sie die Möglichkeit, dass eine Interrupt-Anforderung tatsächlich einen
								; CPU-Interrupt verursacht (INTEN- und PORTS-Bits).

_loop:

	; Auf einen Frame warten (zwei WAIT_RASTER, da die Schleife weniger als eine Rasterzeile zur Ausführung benötigt)

	WAIT_RASTER DISPLAY_Y+DISPLAY_DY
	WAIT_RASTER DISPLAY_Y+DISPLAY_DY+1

	; Testen Sie den Druck der linken Maustaste

	btst #6,$BFE001
	bne _loop

	move.w #$4008,INTENA(a5)	; Sperren der Möglichkeit, dass eine Unterbrechungsanforderung tatsächlich eine CPU-Unterbrechung verursacht

;********** Ende **********

	; Hardware-Interrupts und DMAs ausschalten

	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)
	move.w #$07FF,DMACON(a5)

	; Interrupts wiederherstellen

	lea $64,a0
	lea vectors,a1
	REPT 6
	move.l (a1)+,(a0)+
	ENDR

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

	movea.l copperList,a1
	move.l #COPSIZE,d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l bitplanes,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

	; Register wiederherstellen

	movem.l (sp)+,d0-d7/a0-a6
	rts

;********** Routinen **********

	INCLUDE "common/registers.s"

;---------- Tastaturverwaltung ----------

; Als Minimum muss der Interrupt-Handler die Interrupt-Anfrage der Ebene 2 (Löschen des PORTS-Bits in INTREQ)
; und den zugrunde liegenden CIA-A-Interrupt, der ihn verursacht hat, bestätigen (Lesezugriff auf CIA-A-ICR, 
; der alle Bits in ICR bestätigt). Dieses Minimum versteht sich natürlich nur unter der Bedingung, dass der
; Empfang der von der Tastatur gesendeten 8 Bits das erzeugende Ereignis der Interrupt-Anforderung der
; Ebene 2 darstellt:
;	tst.b $BFED01
;	move.w #$0008,INTREQ(a5)
;	rte

_keyboard:
	movem.l d0-d1,-(sp)		; erforderlich, aber auf modifizierte Register zu beschränken

	; Überprüfen Sie in ICR, dass die Anfrage tatsächlich von der CIA A beim SP-Ereignis generiert wird 
	; (Toggle der 8 Bits, die von der Tastatur in SDR empfangen wurden)
	btst #3,$BFED01
	beq _keyboardNotKeyboard

	; Lesen Sie die 8 Bits in SDR und erkennen Sie, ob es sich um einen Tastendruck oder -loslassen handelt

	move.b $BFEC01,d0
	btst #0,d0
	bne _keyboardKeyDown
	move.w #$00F0,d1		; Taste losgelassen: grüne Farbe
	bra _keyboardKeyUp
_keyboardKeyDown:
	move.w #$0F00,d1		; Taste gedrückt: rote Farbe
_keyboardKeyUp:

	; Ändern Sie die Hintergrundfarbe, wenn die gedrückte Taste die erwartete ist (ESC)

	not.b d0
	lsr.b #1,d0
	cmpi.b #$45,d0
	bne _keyboardNotESC
	move.w d1,COLOR00(a5)
_keyboardNotESC:

	; Bestätigen Sie die Tastatur, indem Sie das Signal auf seiner KDAT-Leitung 82 Mikrosekunden
	; lang auf 0 halten, was durch Setzen von SPMODE auf 1 in CRA erfolgt ("Software muss die Leitung
	; 85 Mikrosekunden lang niedrig pulsieren, um die Kompatibilität mit allen Tastaturmodellen 
	; sicherzustellen" und " die KDAT-Leitung ist aktiv low [...] ein Low-Pegel (0V) wird als 1 interpretiert")

	bset #6,$BFEE01
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	addq.w #2,d0 				; Nicht elegant: blockiert die Ausführungszeit, um ein paar Zeilen zu scannen!
_keyboardACK85us:
	move.l VPOSR(a5),d1
	lsr.l #8,d1
	and.w #$01FF,d1
	cmp.w d0,d1
	bne _keyboardACK85us
	bclr #6,$BFEE01

_keyboardNotKeyboard:

	; Bestätigen Sie die Unterbrechungsanforderung

	move.w #$0008,INTREQ(a5)
	movem.l (sp)+,d0-d1		; erforderlich, aber auf modifizierte Register zu beschränken
	rte

;---------- Interrrupt-Handler ----------

_rte:
	rte

;********** Daten **********

olddmacon:			DC.W 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
vectors:			BLK.L 6
copperList:			DC.L 0
bitplanes:			DC.L 0
graphicsLibrary:	DC.B "graphics.library",0
					EVEN
