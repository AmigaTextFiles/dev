
; Lezione14-6a.s:  ** SPIELT SEHR LANGE SAMPLE AUCH SCHNELL **


	SECTION	PlayLongSamples,CODE

Start:
	bset	#1,$bfe001		; schaltet den Tiefpassfilter aus
							; >>>> PARAMETER <<<<
	lea	sample,a0			; Adresse sample
	move.l	#sample_end-sample,d0	; Länge sample in byte
	;move.w	#17897,d1		; Lesefrequenz		Datei fehlt
	move.w  #21056,d1
	moveq	#64,d2			; volume
	bsr.s	playlongsample_init	; INIT routine (Start)....
							; ....CPU frei....
WLMB:	btst	#6,$bfe001	; drücke LMB+RMB...
	bne.s	wlmb			; um zurück zum Wb zu kommen und Sie werden bemerken
	btst	#10,$dff016		; das es KEINE Verlangsamung gibt
	bne.s	wlmb			; ....Zauber der DMA !

	bsr.w	playlongsample_restore	; RESTORE routine (schalte alles aus)
	rts


***************************************
*****  Play Long Sample Routines  *****
***************************************

PlayLongSample_init:
		; [a0=sample adr]
		; [d0.l=Länge.b sample, d1.w=Frequenz, d2.w=volume]
		; * Autovektor Lv4 IRQ muss verfügbar sein  *

_LVOSupervisor	equ	-30
_LVOAllocMem	EQU	-198
_LVOFreeMem	EQU	-210
_LVOAvailMem	EQU	-216
MEMF_CHIP	equ	1<<1
MEMF_LARGEST	equ	1<<17
MEMF_CLEAR	equ	1<<16
Clock		equ	3546895
AFB_68010	equ	0
AttnFlags	equ	296

	movem.l	d0-d2/a0-a1/a5-a6,-(sp)	; viele Register speichern, weil es
							; die Bibliothek verschmutzt d0-d2 / a0-a1
	lea	plsregs(pc),a5
	movem.l	d0/a0,(a5)		; feste Referenzregister
	movem.l	d0/a0,4*2(a5)	; Arbeitsregister
	move.l	4.w,a6
	move.l	#MEMF_CHIP!MEMF_LARGEST,d1
	jsr	_LVOAvailMem(a6)	; -> d0.l=großer Chipblock
	cmp.l	#2*128*1024,d0	; d0.l > 256 kB ?
	bls.s	.okmem			; wenn nein: nimm die Länge des Blocks
	move.l	#2*128*1024,d0	; wenn ja: genug 256 kB
.OkMem:	and.w	#~%111,d0	; d0.l= Gesamtlänge ausgerichtet von 64 bit
	move.l	d0,4*4(a5)
	move.l	#MEMF_CHIP!MEMF_CLEAR,d1; MEMF_CLEAR: bei 0 der zugewiesene RAM
	jsr	_LVOAllocMem(a6)	; Platzieren Sie 2 benachbarte 128-kB-Banken
	tst.l	d0				; d0.l=0 ?
	beq.w	.bye			; wenn ja: RAM nicht ausreichend -> exit
	move.l	d0,4*5(a5)		; speichern der Basis der ERSTEN Bank im Chip
	move.l	4*4(a5),d1
	lsr.l	#1,d1
	add.l	d1,d0
	move.l	d0,4*6(a5)		; speichern der Basis der ZWEITEN Bank im Chip
	movem.l	4(sp),d1-d2		; Stellen Sie d1-d2 vom Stack wieder her
	sub.l	a0,a0
	move.l	4.w,a6
	btst	#afb_68010,attnflags+1(a6)	; 68010+ ?
	beq.s	.no010
	lea	getvbr(pc),a5		; es geht zur Routine mit privilegierten Befehlen
	jsr	_LVOSupervisor(a6)	; im Supervisor-Modus mit dem exec
.No010:	lea	$dff000,a6
	move.w	#$0780,$9c(a6)	; löscht alle IRQ-Anfragen
	move.w	$1c(a6),oldint	; speichern INTENA von OS
	move.w	#$0780,$9a(a6)	; Maske INT AUD0-AUD3
	move.l	$70(a0),oldlv4	; speichern des Eigenvektor von Level 4
	move.l	#lv4irq,$70(a0)	; neuen Eigenvektor setzen
	move.w	d2,$a8(a6)		; einstellen AUD0VOL
	move.w	d2,$b8(a6)		; einstellen AUD1VOL
	move.w	d2,$c8(a6)		; einstellen AUD2VOL
	move.w	d2,$d8(a6)		; einstellen AUD3VOL
	move.l	#clock,d2
	divu.w	d1,d2			; d2.w=clock/freq = Periode
	move.w	d2,$a6(a6)		; einstellen AUD0PER
	move.w	d2,$b6(a6)		; einstellen AUD1PER
	move.w	d2,$c6(a6)		; einstellen AUD2PER
	move.w	d2,$d6(a6)		; einstellen AUD3PER
	move.w	$2(a6),olddma	; speichern DMACON von OS
	move.w	#$c400,$9a(a6)	; AUD3 IRQ einschalten - nur den...
	move.w	#$8400,$9c(a6)	; den Start des IRQ erzwingen ...
	movem.l	(sp)+,d0-d2/a0-a1/a5-a6
.Bye:	rts
;--------------------------------------
GetVBR:
	dc.l	$4e7a8801	; movec	vbr,a0	; Basis der Ausnahmevektoren
	rte
;--------------------------------------
PlayLongSample_restore:
	movem.l	d0-d2/a0-a1/a5-a6,-(sp)
	sub.l	a0,a0
	move.l	4.w,a6
	btst	#afb_68010,attnflags+1(a6)
	beq.s	.no010
	lea	getvbr(pc),a5
	jsr	_LVOSupervisor(a6)
.No010:	lea	$dff000,a6
	move.w	#$0780,$9c(a6)	; lösche Anfragen von allen Kanälen
	move.w	#$0400,$9a(a6)	; maskiere INT AUD3
	move.l	oldlv4(pc),$70(a0)	; zurücksetzen Eigenvektor 4 von OS
	move.w	#$000f,$96(a6)	; ausschalten alle DMA audio
	move.w	oldint(pc),d0
	or.w	#$8000,d0		; setze SET/CLR welches in INTENAR 0 ist
	move.w	d0,$9a(a6)		; zurücksetzen INTENA von OS
	move.w	olddma(pc),d0
	or.w	#$8000,d0		; setze SET/CLR welches in DMACONR 0 ist
	move.w	d0,$96(a6)		; zurücksetzen DMACON von OS
	move.l	4.w,a6
	movem.l	plsregs+4*4(pc),d0/a0-a1
	cmp.l	a0,a1			; a1 < a0 ? (a1 zeigt auf den Zähler
	blo.s	.min			; Adresse min wo es beginnt
	move.l	a0,a1			; Speicher reserviert ?)
.Min:	jsr	_LVOFreeMem(a6)	; RAM an das System zurückgeben
	movem.l	(sp)+,d0-d2/a0-a1/a5-a6
	rts
;--------------------------------------
PlayLongSample_IRQ:
	movem.l	d0-d2/a0-a1/a5-a6,-(sp)
	lea	$dff000,a6
	lea	plsregs+4*4(pc),a5
	movem.l	-4*2(a5),d0/a0	; d0.l=Länge fehlend/a0=base sample   
	movem.l	(a5),d1/a1		; d1.l=Länge Bank/a1=base Bank
	move.l	a1,$a0(a6)		; einstellen AUDLC
	move.l	a1,$b0(a6)
	move.l	a1,$c0(a6)
	move.l	a1,$d0(a6)
	lsr.l	#1,d1			; halbe Bank
	cmp.l	d0,d1			; halbe Bank <= fehlende Länge?
	bls.s	.longc
	move.l	d0,d1			; wenn nein: Kopieren und spielen fehlende Länge
.LongC:	move.l	d1,d2
	lsr.l	#1,d1			; durch 2 für AUDLEN in Wort teilen
	move.w	d1,$a4(a6)		; einstellen AUDLEN
	move.w	d1,$b4(a6)
	move.w	d1,$c4(a6)
	move.w	d1,$d4(a6)
	lsr.l	#1,d1			; Teilen durch 2, um das Langwort zu kopieren
	subq.w	#1,d1
	move.w	#$007,$180(a6)	; blau, wenn der Kopiervorgang beginnt
.CopyLp:move.l	(a0)+,(a1)+
	dbra	d1,.copylp
	move.w	#$000,$180(a6)	; schwarz wenn es endet
	move.l	-4*1(a5),a0
	add.l	d2,a0			; Zeigen Sie mit a0 auf den nächsten Block
	sub.l	d2,d0			; Länge WENIGER klingende Länge
	bhi.s	.noloop			; d0 >= 1 ? (MINDESTENS 1 Byte fehlt noch)
	movem.l	plsregs(pc),d0/a0	; wenn nein: wiederherstellen Originalregister
.NoLoop:movem.l	d0/a0,-4*2(a5)	; Speichern Sie immer noch d0 und a0 in Kopien
	movem.l	4*1(a5),a0/a1		; Zeiger an 2 Banken tauschen
	exg	a0,a1				; Bei Verwendung wird nur ein Puffer verwendet
	movem.l	a0/a1,4*1(a5)
	move.w	#$820f,$96(a6)
	movem.l	(sp)+,d0-d2/a0-a1/a5-a6
	rts
;--------------------------------------
OldINT:	dc.w	0
OldDMA:	dc.w	0
OldLv4:	dc.l	0
PLSRegs:dc.l	0,0	; Länge,Zeiger des sample - fest
	dc.l	0,0		; Länge,Zeiger des sample - variabel
	dc.l	0,0,0	; Länge,Zeiger Bank 1, Zeiger Bank 2 - fest


***************************************
*****  Level 4 Interrupt Handler  *****
***************************************

	cnop	0,8
Lv4IRQ:	
	btst	#10-8,$dff01e		; IRQ AUD3 ?
	beq.s	.exit
	move.w	#$0780,$dff09c
	bsr.w	playlongsample_irq
.Exit:	rte



	SECTION	Sample,DATA_F

	; MammaGamma by Alan Parsons Project (©1981)
Sample:
	;incbin	"assembler2:sorgenti8/Mammagamma.17897"		; Datei fehlt
	incbin	"assembler3:sorgenti8/carrasco.21056"
Sample_end:

	END


Mit diesem Listing 6 der Listings zum Amiga-Audio sind wir anspruchsvoll 
weitergegangen: mit diesem Listing (oder, wenn Sie es vorziehen,
die Handler von Interrupt, all'exec und ändern der VOI wie in Listing 5b,
um den SetIntVector zu verwenden - im Prinzip nicht notwendig:
Das Betriebssystem verwendet Audio-Interrupts nicht. In der Tat hat es keine
Serverkette der Stufe 4) und sie können praktisch alles spielen was Sie in 
Ihrem Speicher haben, wo immer es ist.
(Solange nur ein fortlaufender RAM-Block belegt ist, erstellen Sie einen
Sample-Player "Aufteilen" in verschiedene Teile rund um den RAM wäre nicht
allzu schwierig:
Es würde ausreichen, dieselbe Quelle zu verwenden, damit das sample 
mehrmals von verschiedenen Stellen gelesen wird. Das einzige Problem wäre
eine Datei durch Brechen einzubinden.
- was der Assembler NICHT tut - mit DOS-Bibliotheksroutinen, die
Teile von Dateien lesen: An diesem Punkt die LOAD-Routine ausgeführt, haben
sie auch einen tollen Player von CLI gemacht!) 
Sie können schliesslich ein sample spielen das sich irgendwo im Speicher
befindet, im größten Teil des AllolocMem finden kann (MEMF_ANY).

Die Bedienung der Routine ist äußerst einfach: gegeben ein sample von
unbestimmte Länge in JEDEM RAM-Block (Chip oder Fast) wird einem RAM-Chip
Block (MEMF_CHIP) von 256 kB zugewiesen (allocated) - wenn möglich - oder nicht.
Dieser ist in zwei Puffer mit jeweils 128 kB oder weniger aufgeteilt, in die
kopiert werden soll mit einer CPU-Schleife die Sampledaten von 128 kB - 
oder weniger um von der DMA lesen zu können.
Der Grund für die Verwendung der 2 Puffer ist sehr einfach: Während das
Audio einen abspielt, füllt die CPU eine andere mit den Daten, die
dann gelesenen wird.

N.B.:	In der Tat sind einige CPUs wie der 68040 oder 68030 so schnell, das
	sie	in der Lage sind, den gesamten Block von 128 kB - oder weniger -
	in etwas mehr eines Rasters zu kopieren. Selbst wenn Sie nicht
	zwei Puffer über alles verwenden. Wenn der Puffer sehr klein ist, ist es
	ehrlich gesagt unmöglich zu hören, das die DMA dieselben Daten zweimal in
	demselben Puffer abspielt, den er durchläuft, weil die CPU sie bereits
	kopiert hat, als die ersten Worte noch gelesen werden.

	Die Gründe, warum zwei separate Puffer verwendet wurden, ist
	das Folgende: Zunächst einmal für die Eleganz der Codierung: IN THEORY
	werden die beiden Puffer benötigt. Auch auf langsamen CPUs wie dem 16-Bit 68000
	beim Zugriff auf den RAM des Amiga 500 ist die Kopie nicht so augenblicklich.
	Schließlich hätte die Routine einen Fehler: den letzten Block des
	sample wird zweimal gespielt vor dem Looping (zum Training,
	versuche zu verstehen warum und repariere das Rad ...).

	Die Mindestlänge für die Puffer beträgt jeweils 4 Byte. Versuchen
	Sie insgesamt nur 8 Bytes zuzuweisen und ein Sample mit der Frequenz abzuspielen
	Maximaler Messwert (ca. 28000 Hz, Periode = 123): Ja, der 040
	- es ist nicht bekannt wie - er schafft es sogar mit der DMA mitzuhalten
	2 Puffer eines Langwortes !!! Sehen heißt glauben...
	
P.S.:	Auf dem _IRQ finden Sie 2 kommentierte Zeilen: Sie werden verwendet,
	um die Hintergrundfarbe immer dann zu ändern, wenn der Interrupt 
	aufgerufen wird. Die CPU startet mit dem Kopieren der Daten aus dem
	Quell-RAM in die Puffer: 
	Kommentar entfernen um zu sehen, was der Prozessor währenddessen vorhat
	DMA scheint Datenänderungen nicht zu bemerken ... 