
; Listing13d3.s - Tabellen	- nimmt Bezug auf Listing11l5b.s
; optimierte Lösung (Routine) durch vorberechnete Tabelle
; Zeile 1145

start:
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;
	bsr.w	PrecalcoTabba		; Tabelle Turbo mit vorkalibrierten "erweiterten" Bytes erstellen.
	bsr		normalloop
	bsr		optloop

	rts

****************************************************************************
; Routine, die alle möglichen 8 Bytes in Kombination mit möglichen
; 8-Bit vorberechnet. Für alle $FF bedeutet es, das heißt, 255.
****************************************************************************

PrecalcoTabba:
	lea	Precalctabba,a1			; Ziel
	moveq	#0,d0				; Teile von Null
FaiTabba:
	MOVEQ	#8-1,D1				; 8 bit die sie steuern und erweitern möchten.
BYTELOOP:
	BTST.l	D1,d0				; Testen des aktuellen Schleifenbits
	BEQ.S	bitclear			; ist es zurückgesetzt?
	ST.B	(A1)+				; wenn nein, legt das Byte fest (=$FF)
	BRA.S	bitset
bitclear:
	clr.B	(A1)+				; Wenn es Null ist, setzt es das Byte zurück (=$00)
bitset:
	DBRA	D1,BYTELOOP			; Überprüfen und erweitern Sie alle Bits des Bytes:						
								; D1, abnehmend, bewirkt, dass der BTST jedes Mal auf
								; ein anderes Bit zeigt von 7 bis 0.	
	ADDQ.W	#1,D0				; Nächster Wert
	CMP.W	#256,d0				; Haben wir alle gemacht? (max $FF)
	bne.s	FaiTabba
	rts

****************************************************************************
; Dies ist die "normale" Routine:	; von Listing11l5.s
****************************************************************************

normalloop:
;ZoomaFrame:
	move.l	AnimPointer(PC),A0	; aktuelles kleines Bild (40*29)
	lea	Planexpand,A1			; Puffer Ziel (320*29)
;	MOVE.W	#(5*29*3)-1,D7		; 5 Bytes für eine Zeile * 29 Zeilen * 3 Bitplanes
;Animloop:
	moveq	#0,d0
	move.b	(A0)+,d0			; nächste byte in d0
	MOVEQ	#8-1,D1				; 8 Bit zu überprüfen und zu erweitern.
BYTELOOP2:
	BTST.l	D1,d0				; Testen des aktuellen Schleifenbits
	BEQ.S	bitclear2			; Ist es zurückgesetzt?
	ST.B	(A1)+				; Wenn nicht, legt das Byte fest (=$FF)
	BRA.S	bitset2
bitclear2:
	clr.B	(A1)+				; Wenn es Null ist, setzt es das Byte zurück (=$00)
bitset2:
	DBRA	D1,BYTELOOP2			; Überprüfen und erweitern Sie alle Bits des Bytes:
								; D1, abnehmend, bewirkt, dass der BTST jedes Mal auf
								; ein anderes Bit zeigt von 7 bis 0.

;	DBRA	D7,Animloop			; Konvertieren Sie den gesamten Frame

;	add.l	#(5*29)*3,AnimPointer	; Zeigen Sie auf das nächste Bild
;	move.l	AnimPointer(PC),A0
;	lea	FineAnim(PC),a1
;	cmp.l	a0,a1					; War es der letzte Frame?
;	bne.s	NonRiparti
;	move.l	#cannoanim,AnimPointer	; Wenn ja, fangen wir mit dem ersten an
;NonRiparti:
	rts

****************************************************************************
; Dies ist die "optimierte" Routine:	; von Listing11l5b.s
; benötigt vorberechnete Tabelle (PrecalcoTabba)
****************************************************************************

optloop:
;ZoomaFrame:
	move.l	AnimPointer(PC),A0	; Frame klein aktuell (40*29)
	lea	Planexpand,A1			; Puffer Ziel (zu 320*29)
;	MOVE.W	#(5*29*3)-1,D7		; 5 bytes pro Zeile * 29 Zeilen * 3 bitplanes
Animloop:
	moveq	#0,d0
	move.b	(A0)+,d0			; nächstes byte in d0
	lsl.w	#3,d0				; d0*8 um den Wert in der Tabelle zu finden
								; (d.h. der Offset von seinem Anfang)
	lea	Precalctabba,a2
	lea	0(a2,d0.w),a2			; In a2 die Adresse im 8-Byte-Tab
								; "Erweiterung" der 8 Bits.
	move.l	(a2)+,(a1)+			; 4 bytes erweitert
	move.l	(a2),(a1)+			; 4 bytes erweitert (total 8 bytes!!)

	;DBRA	D7,Animloop			; Konvertieren des gesamten Frames

;	add.l	#(5*29)*3,AnimPointer	; Zeigen Sie auf den nächsten Frame
;	move.l	AnimPointer(PC),A0
;	lea	FineAnim(PC),a1
;	cmp.l	a0,a1					; War es der letzte Frame?
;	bne.s	NonRiparti
;	move.l	#cannoanim,AnimPointer	; wenn ja, mit dem ersten beginnen
;NonRiparti:
	rts

****************************************************************************
; ANIMATION: 8 Frames Größe 40*29 pixel, mit 8 Farben (3 Bitplanes)
****************************************************************************

; Animation jedes Frame mist 40*29 pixel, 3 bitplanes. Tot. 8 frames

AnimPointer:
	dc.l	cannoanim

cannoanim:
	incbin	"//Sources/frame1"			; 40*29 mit 3 Bitplanes (8 Farben)

****************************************************************************
; Puffer mit der Tabelle für den vorkalkulierten Zoom
****************************************************************************

	section	precalcolone,bss

PrecalcTabba:
	ds.b	256*8

****************************************************************************
; Puffer, bei dem pro Frame "erweitert" wird.
****************************************************************************

	SECTION	BitPlanes,BSS_C

PLANEXPAND:						; Wo jeder Frame erweitert wird.
	ds.b	40*29*3				; 40 Bytes * 29 Zeilen * 3 Bitplanes	

	end



Wenn Sie sehr aufmerksam waren, sollten Sie sich auch daran erinnern, dass in
Listing11a, das Listing einer Tabellenoptimierung unterzogen wurde, die weitaus
riskanter war, als diese Sicht (Blick) jetzt ist.
Tatsächlich wird eine ganze Routine anstelle von nur einer Multiplikation 
aufgezeichnet. Es ist kein Zufall, dass ich es in Lektion 11 und nicht in 8
eingefügt habe! Das "normale" Listing ist Listing11l5.s, das "tabellarische"
Listing ist Listing11l5b.s.
Überprüfen Sie, wie die starke Optimierung stattgefunden hat, die ich erneut
vorschlage.

Dies ist die "normale" Routine:

-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-

Animloop:
	moveq	#0,d0
	move.b	(A0)+,d0	; Nächstes byte in d0
	MOVEQ	#8-1,D1		; 8 Bits zum Überprüfen und Erweitern.
BYTELOOP:
	BTST.l	D1,d0		; Test des aktuellen Schleifenbits
	BEQ.S	bitclear	; zurückgesetzt?
	ST.B	(A1)+		; wenn nicht, setze byte (=$FF)
	BRA.S	bitset
bitclear:
	clr.B	(A1)+		; Wenn es gelöscht ist, wird das Byte gelöscht
bitset:
	DBRA	D1,BYTELOOP	; Überprüfen und erweitern Sie alle Bits des Bytes
	DBRA	D7,Animloop	; Konvertieren Sie den gesamten Frame

-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-

Wir haben nichts getan, als alle Möglichkeiten vorab zu berechnen:

-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-

****************************************************************************
; Routine, die alle möglichen 8 Bytes in Kombination mit den möglichen 8 Bit
; vorberechnet. Mit allem meinen wir $FF, das sind 255.
****************************************************************************

PrecalcoTabba:
	lea	Precalctabba,a1	; Ziel
	moveq	#0,d0		; von Null anfangen
FaiTabba:
	MOVEQ	#8-1,D1		; 8 Bits zum Überprüfen und Erweitern.
BYTELOOP:
	BTST.l	D1,d0		; Test des aktuellen Schleifenbits
	BEQ.S	bitclear	; zurückgesetzt?
	ST.B	(A1)+		; wenn nicht, setze byte (=$FF)
	BRA.S	bitset
bitclear:
	clr.B	(A1)+		; Wenn es gelöscht ist, wird das Byte gelöscht
bitset:
	DBRA	D1,BYTELOOP	; Überprüfen und erweitern Sie alle Bits des Bytes:
						; D1, das jedes Mal fällt, macht den btst von
						; alle Bits.
	ADDQ.W	#1,D0		; Nächster Wert
	CMP.W	#256,d0		; Haben wir alle gemacht? (max $FF)
	bne.s	FaiTabba
	rts

-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-

Und ändern Sie die "Executive" -Routine:

-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-

Animloop:
	moveq	#0,d0
	move.b	(A0)+,d0	; Nächstes Byte in d0
	lsl.w	#3,d0		; d0 * 8, um den Wert in der Tabelle zu finden
						; (d.h. der Versatz von seinem Anfang)
	lea	Precalctabba,a2
	lea	0(a2,d0.w),a2	; In a2 die Adresse in der 8-Byte-Tabelle
						; genau richtig für die "Erweiterung" der 8 Bits.
	move.l	(a2)+,(a1)+	; 4 bytes erweitern
	move.l	(a2),(a1)+	; 4 bytes erweitern (gesamt 8 bytes!!)

	DBRA	D7,Animloop	; Konvertieren Sie den gesamten Frame

-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-

Wie Sie sehen können, gehen wir hier in eine Art Optimierung ein, die eine 
gewisse Erfahrung und eine gewisse Intuition erfordert.
Mechanisch ist es leicht zu sagen: "Ich versuche, alle Multiplikationen und 
Divisionen zu tabellieren und setze alle möglichen addqs und moveqs". Aber wenn
ich davon weiß, finden sie "seltsame" Routinen wie die bereits gesehene
was btst aus einem ganzen Byte macht und es auf 8 Bytes erweitert, ist es notwendig 
das Auge eines Luchses zu haben, um zu verstehen, wie man es optimiert.
Es ist dieses Luchsauge, das den Unterschied zwischen einer 3D-Routine ausmacht
die auf die Fünfzigstel-Sekunde geht, obwohl es eine 50stel-Sekunde ist...
durch Drehen von 8192. Und natürlich können Sie nicht alle mögliche Routinen
mit allen möglichen Optimierungen daneben auflisten.
Es ist notwendig, das Auge eines Luchses zu bekommen, indem man die wenigen
vorgestellten Beispiele sieht.


;------------------------------------------------------------------------------
r
Filename: Listing13d3.s
>a
Pass1
Pass2
No Errors
>j			

;------------------------------------------------------------------------------

>d pc
00022ffc 66f6                     bne.b #$f6 == $00022ff4 (T)
00022ffe 6100 000c                bsr.w #$000c == $0002300c
00023002 6100 002a                bsr.w #$002a == $0002302e
00023006 6100 0046                bsr.w #$0046 == $0002304e
0002300a 4e75                     rts  == $00c4f7b8
0002300c 43f9 0002 3228           lea.l $00023228,a1								; Tabelle precalctab
00023012 7000                     moveq #$00,d0
00023014 7207                     moveq #$07,d1
00023016 0300                     btst.l d1,d0
00023018 6704                     beq.b #$04 == $0002301e (F)
>d
0002301a 50d9                     st .b (a1)+ [00] (T)
0002301c 6002                     bra.b #$02 == $00023020 (T)
0002301e 4219                     clr.b (a1)+ [00]
00023020 51c9 fff4                dbf .w d1,#$fff4 == $00023016 (F)
00023024 5240                     addq.w #$01,d0
00023026 0c40 0100                cmp.w #$0100,d0
0002302a 66e8                     bne.b #$e8 == $00023014 (T)
0002302c 4e75                     rts  == $00c4f7b8
0002302e 207a 003e                movea.l (pc,$003e) == $0002306e [00023072],a0
00023032 43f9 0006 a4d8           lea.l $0006a4d8,a1								; Tabelle Plane
>d
00023038 7000                     moveq #$00,d0
0002303a 1018                     move.b (a0)+ [c6],d0
0002303c 7207                     moveq #$07,d1
0002303e 0300                     btst.l d1,d0
00023040 6704                     beq.b #$04 == $00023046 (F)
00023042 50d9                     st .b (a1)+ [00] (T)
00023044 6002                     bra.b #$02 == $00023048 (T)
00023046 4219                     clr.b (a1)+ [00]
00023048 51c9 fff4                dbf .w d1,#$fff4 == $0002303e (F)
0002304c 4e75                     rts  == $00c4f7b8
>d
0002304e 207a 001e                movea.l (pc,$001e) == $0002306e [00023072],a0
00023052 43f9 0006 a4d8           lea.l $0006a4d8,a1
00023058 7000                     moveq #$00,d0
0002305a 1018                     move.b (a0)+ [c6],d0
0002305c e748                     lsl.w #$03,d0
0002305e 45f9 0002 3228           lea.l $00023228,a2
00023064 45f2 0000                lea.l (a2,d0.W,$00) == $00023950,a2
00023068 22da                     move.l (a2)+ [00000000],(a1)+ [00000000]
0002306a 22d2                     move.l (a2) [00000000],(a1)+ [00000000]
0002306c 4e75                     rts  == $00c4f7b8
>d
0002306e 0002 3072                or.b #$72,d2

;------------------------------------------------------------------------------
>m 6a4d8 1																			; Tabelle Plane
0006A4D8 0000 0000 0000 0000 0000 0000 0000 0000  ................					; alles Null
>
;------------------------------------------------------------------------------
>f 23002
Breakpoint added.
>f 23006
Breakpoint added.
>f 2300a
Breakpoint added.
>fl
0: PC == 00023002 [00000000 00000000]
1: PC == 00023006 [00000000 00000000]
2: PC == 0002300a [00000000 00000000]

>
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 6228338 Chip, 12456676 CPU. (V=105 H=3 -> V=311 H=142)
  D0 00000100   D1 0000FFFF   D2 0000FFFF   D3 00000000
  D4 00000481   D5 00000000   D6 00000000   D7 0000FFFF
  A0 00022F97   A1 00023A28   A2 00023550   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 6100 (BSR) 002a (OR) Chip latch 0000FFFE
00023002 6100 002a                bsr.w #$002a == $0002302e
Next PC: 00023006
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 197 Chip, 394 CPU. (V=311 H=142 -> V=312 H=112)								; 394 Zyklen (normal)
  D0 00000080   D1 0000FFFF   D2 0000FFFF   D3 00000000
  D4 00000481   D5 00000000   D6 00000000   D7 0000FFFF
  A0 00023073   A1 0006A4E0   A2 00023550   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 6100 (BSR) 0046 (OR) Chip latch 0000FFFE
00023006 6100 0046                bsr.w #$0046 == $0002304e
Next PC: 0002300a
;------------------------------------------------------------------------------
>m 6a4d8 1																			; Ergebnis	
0006A4D8 FF00 0000 0000 0000 0000 0000 0000 0000  ................
>W 6a4d8 0
Wrote 0 (0) at 0006A4D8.B
>m 6a4d8 1
0006A4D8 0000 0000 0000 0000 0000 0000 0000 0000  ................
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 75 Chip, 150 CPU. (V=312 H=112 -> V=312 H=187)								; 150 Zyklen (optimiert)
  D0 00000400   D1 0000FFFF   D2 0000FFFF   D3 00000000
  D4 00000481   D5 00000000   D6 00000000   D7 0000FFFF
  A0 00023073   A1 0006A4E0   A2 0002362C   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4e75 (RTS) 43f9 (LEA) Chip latch 0000FFFE
0002300a 4e75                     rts  == $00c4f7b8
Next PC: 0002300c
;------------------------------------------------------------------------------
>m 6a4d8 1																			; Ergebnis	
0006A4D8 FF00 0000 0000 0000 0000 0000 0000 0000  ................
>



