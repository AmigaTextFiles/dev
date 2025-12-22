
; Listing14-5b.s:	** SPIELT SAMPLE SEHR LANG UNTER OS **

	SECTION	PlayLongSamples_OS,CODE

Start:
	bset	#1,$bfe001

	lea	sample,a0
	move.l	#sample_end-sample,d0
	;move.w	#17897,d1			; Lesefrequenz		Datei fehlt
	move.w  #21056,d1		
	moveq	#64,d2
	bsr.s	playlongsample_init

WLMB:	btst	#6,$bfe001
	bne.s	wlmb
	btst	#10,$dff016
	bne.s	wlmb

	bsr.w	playlongsample_restore
	rts


***************************************
*****  Play Long Sample Routines  *****
***************************************

PlayLongSample_init:
		;[a0=sample adr]
		;[d0.l=Länge.b sample, d1.w=Frequenz, d2.w=volume]

Clock		equ	3546895
NT_Interrupt	equ	2
LN_Type		equ	8
LN_Pri		equ	9
LN_Name		equ	10
IS_Data		equ	14
IS_Code		equ	18
IS_SIZE		equ	22
_LVOSetIntVector	equ	-162

	movem.l	d0/d2/a1/a6,-(sp)
	movem.l	d0/a0,plsregs
	movem.l	d0/a0,plsregs+4*2
	movem.l	d1-d2,-(sp)
	move.l	4.w,a6						; exec-base in a6
	lea	aud1int_node(pc),a1				; Interrupt-Struktur / Knoten
	move.b	#nt_interrupt,ln_type(a1)	; Knotentyp: interrrupt
	move.l	#aud1int_name,ln_name(a1)	; Name des öffentlichen Knotens
	move.l	#aud1int_data,is_data(a1)	; zeigt auf die Daten (a1-scratch)
	move.l	#aud1int_code,is_code(a1)	; zeigt auf den Code (a5-scratch)
	moveq	#8,d0						; Bit INTENA/INTREQ (AUD1)
	jsr	_LVOSetIntVector(a6)
	move.l	d0,oldaud1int_node			; d0.l=vorheriger Knoten
	movem.l	(sp)+,d1-d2
	lea	$dff000,a6
	move.w	d2,$a8(a6)
	move.w	d2,$b8(a6)
	move.w	d2,$c8(a6)
	move.w	d2,$d8(a6)
	move.l	#clock,d2
	divu.w	d1,d2
	move.w	d2,$a6(a6)
	move.w	d2,$b6(a6)
	move.w	d2,$c6(a6)
	move.w	d2,$d6(a6)
	move.w	$2(a6),olddma
	move.w	$1c(a6),oldint
	move.w	#$8100,$9a(a6)
	move.w	#$8100,$9c(a6)
	movem.l	(sp)+,d0/d2/a1/a6
	rts
;--------------------------------------
PlayLongSample_restore:
	movem.l	d0/a1/a6,-(sp)
	move.l	4.w,a6
	move.l	oldaud1int_node(pc),a1	; vorherigen Knoten zurücksetzen
	moveq 	#8,d0					; Bit INTENA/INTREQ (AUD1)
	jsr	_LVOSetIntVector(a6)
	lea	$dff000,a6
	move.w	#$0780,$9c(a6)			; schaltet alle IRQ-Anforderungen aus
	move.w	#$0100,$9a(a6)
	move.w	oldint(pc),d0
	or.w	#$8000,d0
	move.w	d0,$9a(a6)
	move.w	#$000f,$96(a6)
	move.w	olddma(pc),d0
	or.w	#$8000,d0
	move.w	d0,$96(a6)
	movem.l	(sp)+,d0/a1/a6
	rts
;--------------------------------------
PlayLongSample_IRQ:					; <<< diese Routine ist identisch
	movem.l	d0-d1/a0-a1/a6,-(sp)
	lea	$dff000,a6
	movem.l	plsregs+4*2(pc),d0/a0
	move.l	a0,$a0(a6)
	move.l	a0,$b0(a6)
	move.l	a0,$c0(a6)
	move.l	a0,$d0(a6)
	move.l	d0,d1
	and.l	#~(128*1024-1),d1
	bne.s	.long
	move.l	d0,d1
.Long:	lsr.l	#1,d1
	move.w	d1,$a4(a6)
	move.w	d1,$b4(a6)
	move.w	d1,$c4(a6)
	move.w	d1,$d4(a6)
	add.l	#128*1024,a0
	sub.l	#128*1024,d0
	bhi.s	.noloop
	movem.l	plsregs(pc),d0/a0
.NoLoop:movem.l	d0/a0,plsregs+4*2
	move.w	#$820f,$96(a6)
	movem.l	(sp)+,d0-d1/a0-a1/a6
	rts
;--------------------------------------
OldDMA:	dc.w	0
OldInt:	dc.w	0
OldAud1Int_Node:dc.l	0
Aud1Int_Node:
	blk.b	is_size				; Länge InterruptStructure
	even
Aud1Int_Name:
	dc.b	"PlayLongSampleIRQ",0
	even
Aud1Int_Data:
PLSRegs:dc.l	0,0				; Länge,Zeiger - fest
	dc.l	0,0					; Länge,Zeiger - variabel

	cnop   0,8
Aud1Int_Code:
	move.w	#$0100,$dff09c
	bsr.w	playlongsample_irq
	rts



	SECTION	Sample,DATA_C

	; MammaGamma by Alan Parsons Project (©1981)
Sample:
	;incbin	"/Sources/Mammagamma.17897"	; Datei fehlt
	incbin	"/Sources/carrasco.21056"
Sample_end:

	END


Diesmal hat sich im Vergleich zur vorherigen Quelle fast nichts geändert:
Wir haben also nur den Interrupt-Handler der exec-Bibliothek zugewiesen
um alles etwas "freundlicher" gegenüber dem Betriebssystem zu machen.

N.B.:	Der Interrupt von Kanal 1 wurde verwendet, wegen der Pseudo 
	Software-Priorität des Exec. Er ist das erste, welcher vom 
	internen ROM-Handler der Ebene 4 erkannt wird.

P.S.:	eine Klarstellung bezüglich des Unterschieds zwischen Server Chain
	und Interrupt-Handler per exec: bestimmte Interrupts (VERTB, COPER,
	PORTS, EXTER und NMI) sind nützlicher als andere und werden häufiger
	verwendet sowohl vom Betriebssystem als auch von Benutzeraufgaben. Der exec
	muss daher die Möglichkeit gegeben werden für jeden, seine eigenen
	Interruptroutinen zu haben und bildet daher "Ketten" von Routinen, die
	unterschiedliche und spezifizierbare Ausführungsprioritäten haben, die
	von einem einzelnen Handler verwaltet werden.

	Alle anderen Paula-Interrupts (TBE, DSKBLK, SOFT, BLIT, AUD0-3, RBF und 
	DSKSYNC) werden nicht als Server chain gesehen, sondern als Handler: 
	Jeder kann den Interrupt vollständig übernehmen, ohne es zu verknüpfen
	oder zu teilen mit keiner anderen Aufgabe.

	In unserem Fall haben wir den Interrupt von Kanal 1 zugewiesen, für eine
	höhere Softwarepriorität für den Exec (... und frag mich nicht warum),
	mit _LVOSetIntVector, da ein Handler und kein Server erforderlich ist.
	Darüber hinaus muss im Fall von Handlern die Priorität des Knotens der 
	Interrupt Struktur nicht gesetzt werden, da dies nicht der Fall ist
	Es gibt andere Server in der Kette, Sie sind allein.

P.P.S.:		alle Noten aus der vorherigen Quelle - außer den verschiedenen -
	gilt auch dafür.

	N.B.:	Die EQUs stammen aus den include "exec / interrupt.i"
			"LVO1.3 / exec_lib.i".