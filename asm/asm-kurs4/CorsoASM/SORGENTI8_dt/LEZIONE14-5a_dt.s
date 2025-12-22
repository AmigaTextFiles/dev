
; Lezione14-5a.s	** SPIELT SAMPLE SEHR LANG **


	SECTION	PlayLongSamples,CODE

Start:
	bset	#1,$bfe001		; schaltet den Tiefpassfilter aus

							; >>>> PARAMETER <<<<
	lea	sample,a0			; Adresse sample
	move.l	#sample_end-sample,d0	; Länge samples in byte
	;move.w	#17897,d1		; Lesefrequenz		Datei fehlt
	move.w  #21056,d1		
	moveq	#64,d2			; volume
	bsr.s	playlongsample_init	; INIT routine (es beginnt)....
							; ....CPU frei....
WLMB:
	btst	#6,$bfe001		; drücke LMB+RMB...
	bne.s	wlmb			; um zurück zum Wb zu kommen und Sie werden bemerken
	btst	#10,$dff016		; das es KEINE Verlangsamung gibt
	bne.s	wlmb			; .... Magie von DMA !

	bsr.w	playlongsample_restore	; WIEDERHERSTELLEN routine (schalte alles aus)
	rts


***************************************
*****  Play Long Sample Routines  *****
***************************************
;
; a0	= sample adr
; d0.l  = Länge.b sample, d1.w=Frequenz, d2.w=volume
;
; LinearAutoVector Lv4 IRQ muss verfügbar sein


_LVOSupervisor	equ	-30
Clock		equ	3546895
AFB_68010	equ	0
AttnFlags	equ	296

PlayLongSample_init:
	movem.l	d2/a0/a6,-(sp)
	movem.l	d0/a0,plsregs		; feste Referenzregister
	movem.l	d0/a0,plsregs+4*2	; Arbeitsregister
	sub.l	a0,a0				; FAST CLEAR An
	move.l	4.w,a6
	btst	#afb_68010,attnflags+1(a6)	; 68010+ ?
	beq.s	.no010
	lea	getvbr(pc),a5
	jsr	_LVOSupervisor(a6)
.No010:
	lea	$dff000,a6
	move.w	#$0780,$9c(a6)		; löscht alle IRQ-Anfragen
	move.w	$1c(a6),oldint		; speichern INTENA vom OS
	move.w	#$0780,$9a(a6)		; Maske INT AUD0-AUD3
	move.l	$70(a0),oldlv4		; speichern des Eigenvektors von Level 4
	move.l	#lv4irq,$70(a0)		; setze den neuen Eigenvektor
	move.w	d2,$a8(a6)			; einstellen AUD0VOL
	move.w	d2,$b8(a6)			; einstellen AUD1VOL
	move.w	d2,$c8(a6)			; einstellen AUD2VOL
	move.w	d2,$d8(a6)			; einstellen AUD3VOL
	move.l	#clock,d2
	divu.w	d1,d2				; d2.w=clock/freq = Periode
	move.w	d2,$a6(a6)			; einstellen AUD0PER
	move.w	d2,$b6(a6)			; einstellen AUD1PER
	move.w	d2,$c6(a6)			; einstellen AUD2PER
	move.w	d2,$d6(a6)			; einstellen AUD3PER
	move.w	$2(a6),olddma		; speichern DMACON vom OS
	move.w	#$8400,$9a(a6)		; AUD3 IRQ einschalten - nur er...
	move.w	#$8400,$9c(a6)		; Erzwinge den Start des IRQ...
	movem.l	(sp)+,d2/a0/a6
	rts

;--------------------------------------
GetVBR:
	dc.l	$4e7a8801	; movec	vbr,a0	; Basis von Ausnahmevektoren
	rte
;--------------------------------------

PlayLongSample_restore:
	movem.l	d0/a0/a6,-(sp)
	sub.l	a0,a0
	move.l	4.w,a6
	btst	#afb_68010,attnflags+1(a6)
	beq.s	.no010
	lea	getvbr(pc),a5
	jsr	_LVOSupervisor(a6)
.No010:
	lea	$dff000,a6
	move.w	#$0780,$9c(a6)		; lösche alle Anfragen (requests) von allen Kanälen
	move.w	#$0400,$9a(a6)		; maskiere INT AUD3
	move.l	oldlv4(pc),$70(a0)	; alten Eigenvektor 4 zurücksetzen
	move.w	#$000f,$96(a6)		; schaltet alle Audio-DMAs aus
	move.w	oldint(pc),d0
	or.w	#$8000,d0			; mit SET/CLR INTENAR auf 0 einstellen
	move.w	d0,$9a(a6)			; INTENA des Betriebssystems zurücksetzen
	move.w	olddma(pc),d0
	or.w	#$8000,d0			; mit SET/CLR DMACONR auf 0 einstellen 
	move.w	d0,$96(a6)			; DMACON des Betriebssystems zurücksetzen
	movem.l	(sp)+,d0/a0/a6
	rts

;--------------------------------------

PlayLongSample_IRQ:
	movem.l	d0-d1/a0-a1/a6,-(sp)
	lea	$dff000,a6
	movem.l	plsregs+4*2(pc),d0/a0	; Arbeitsregister zurück
	move.l	a0,$a0(a6)			; einstellen AUD0LC
	move.l	a0,$b0(a6)			; einstellen AUD1LC
	move.l	a0,$c0(a6)			; einstellen AUD2LC
	move.l	a0,$d0(a6)			; einstellen AUD3LC
	move.l	d0,d1				; d1.l=Länge fehlt
	and.l	#~(128*1024-1),d1	; es fehlen noch mehr als 128 kB
	bne.s	.long				; wenn JA: gehe zu .long
	move.l	d0,d1				; wenn NEIN: Länge verwenden fehlt (<128 kB)
.Long:	lsr.l	#1,d1			; transformiert die Länge in .W spielen
	move.w	d1,$a4(a6)			; einstellen AUD0LEN
	move.w	d1,$b4(a6)			; einstellen AUD1LEN
	move.w	d1,$c4(a6)			; einstellen AUD2LEN
	move.w	d1,$d4(a6)			; einstellen AUD3LEN
	add.l	#128*1024,a0		; mit a0 auf den nächsten Block zeigen
	sub.l	#128*1024,d0		; Länge WENIGER 128 kB
	bhi.s	.noloop				; d0 => 1 ? (MINDESTENS 1 byte)
	movem.l	plsregs(pc),d0/a0	; wenn NEIN: Originalregister zurücksetzen
.NoLoop:movem.l	d0/a0,plsregs+4*2	; Speichern Sie immer noch d0 und a0 in Kopien
	move.w	#$820f,$96(a6)		; Schaltet alle Audio-DMAs ein und wird eingeschaltet
								; hat den IRQ sofort generiert, nur für den Fall
								; Wenn Sie das Audio zum ersten Mal einschalten
	movem.l	(sp)+,d0-d1/a0-a1/a6
	rts

;--------------------------------------

OldINT:	dc.w	0
OldDMA:	dc.w	0
OldLv4:	dc.l	0
PLSRegs: dc.l	0,0				; Länge, Zeiger - fest
	dc.l	0,0					; Länge, Zeiger - variabel


***************************************
*****  Level 4 Interrupt Handler  *****
***************************************

	cnop	0,8
Lv4IRQ:	
	btst	#10-8,$dff01e		; IRQ AUD3 ?
	beq.s	.exit				; wenn nein: exit
	move.w	#$0400,$dff09c		; Schalten Sie die Anfrage sofort aus, wie
					; in der Routine die DMA eingeschaltet werden 
					; und der neue IRQ wird sofort generiert:
					; Ausschalten der Anfrage nach der Routine dann
					; laufen sie Gefahr, den ersten Zyklus des
					; IRQ request des Interrupt zu löschen 
					; (der gerade gestarteten Routine).
			
	bsr.w	playlongsample_irq
.Exit:
	rte
	

	SECTION	Sample,DATA_C

	; MammaGamma by Alan Parsons Project (©1981)
Sample:
	;incbin	"assembler2:sorgenti8/Mammagamma.17897"	; Datei fehlt
	incbin	"assembler3:sorgenti8/carrasco.21056"
Sample_end:

	END


Jetzt werden die Dinge wieder kompliziert ... Wir haben angefangen, Interrupts zu
verwenden und die Routinen  - sagen wir mal - sind nicht mehr trivial.
Wie bereits in der LEKTION geschrieben, sind die 4 Audiokanäle 4 verschiedenen 
Interrupts von Level 4 des 680x0 zugeordnet. 

Solche Interrupts werden von der Hardware jedes Mal generiert. Wenn ein Kanal
angefordert wird, erfolgt das Lesen der Daten von der in Ihrem AUDLC enthaltenen
Adresse aus dem Speicher. Dafür muss nur den DMA des Kanals jedes Mal zu Beginn
einer neuen Sample-Schleife eingeschaltet sein.

* Sobald ein Kanal ein Sample abspielt, kommt zusätzlich				
 der IRQ, sein AUDLC bleibt unverändert und ist daher veränderlich:

So funktioniert die Routine "PlayLongSample": Jedes Mal, wenn der DMA mit dem
Lesen eines Stücks beginnt (128KB oder weniger, abhängig von welchem Teil des
fehlenden zu spielenden Samples es ist der länger als die maximale AUDLEN-Schleife) 
der durch Interrupt erzeugte wurde und die AUDxLC-Register (alle 4 in diesem
Fall, denn sie werden alle verwendet, um die gleichen Daten abzuspielen) kommen 
neu berechnet und je nach "Stück" des Samples vorwärts oder rückwärts bewegt	
zu denen sie vorher gestellt wurden und die die DMA jetzt liest *.

*** Grundsätzlich ist es mit dieser Technik möglich, mit dem Amiga viele 
128-kB-Chunks oder weniger - spielen zu lassen , wie beim letzten Chunk - von 
benachbarten Audiodaten im Speicher, ohne dass man die "Lücke" zwischen dem
einen und dem anderen merkt ***.

N.B.:  Sobald die Routine gestartet wurde, wird das Sample nur durch den
	Interrupt-Code unendlich weiter wiederholt, also ist es ** VOLLSTÄNDIG
	UNABHÄNGIG: Mit anderen Worten, gehen Sie nach dem "_init" zurück zu main
	und Sie haben die normale Kontrolle über die gesamte Hardware (außer Sound,
	natürlich) und die CPU (mit Ausnahme des Interrupts des Level 4
	die vom "PlayLongSample" verwendet wird) **.
	Wenn Sie das Sample ausschalten möchten, rufen Sie "_restore" auf und alles
	wird wie vor dem Aufrufen von "_init" zurückkehren (beliebige Routine 
	die auch Audio-Interrupts enthalten!).

P.S.:	Ein letzter Punkt: Hier wurde nur ein IRQ für alle Stimmen verwendet,
	da sie alle gleichzeitig klangen. Das Gleiche und genau das von
	Stimme 3 oder am meisten hohe Hardware-Priorität.
	Theoretisch sollte sich an der Verwendung einiger anderer Stimmen nichts
	ändern, solange die anderen maskiert sind - oder auf andere Weise vom 
	Handler ignoriert werden - ansonsten würden am Ende des Lesens von jeden
	Block 4 Interrupts generiert.