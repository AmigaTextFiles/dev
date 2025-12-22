*******************************************************
*
** IntList - a replacement for the original IntList V36
** by Commodore Amiga
*
** This IntList has got extensions to the original one,
** it will display software interrupts and CIA resource
** interrupt vectors.
*
** Written 08.11.1997 by Joerg van de Loo
**			 Hoevel 15
**			 47559 Kranenburg
**			 Germany
*

	OUTPUT	RAM:IntList


	STRUCTURE	_Table,68
	APTR	_IRQ
	APTR	_CIABBase
	LABEL	_TableSize

	include	RAD:include/startup.easy

	OPT	P+	; enable position independent code
*	OPT	D+	; enable debug informations for load-file

_main
	bsr.w	_GetVBR
	move.l	D0,_IRQ(A5)

	bsr.w	_PrintStatus

	bsr.s	_GetTBE
	bsr.s	_GetDSKBLK
	bsr.s	_GetSOFTINT
	bsr.w	_GetCIAA
	bsr.s	_GetCOP
	bsr.s	_GetVERTB
	bsr.w	_GetBLIT
	bsr.w	_GetAUD0
	bsr.w	_GetAUD1
	bsr.w	_GetAUD2
	bsr.w	_GetAUD3
	bsr.w	_GetRBF
	bsr.w	_GetDSKSYN
	bsr.w	_GetCIAB
	bsr.w	_GetSoftInts
	bsr.w	_SetPatch
	rts

_GetTBE
	movea.l	_SysBase(A5),A6
	lea	IVTBE(A6),A2
	lea	_TBETxt(pc),A3
	bsr.w	_GetIRQ
	rts
_GetDSKBLK
	movea.l	_SysBase(A5),A6
	lea	IVDSKBLK(A6),A2
	lea	_DSKBLKTxt(pc),A3
	bsr.w	_GetIRQ
	rts
_GetSOFTINT
	movea.l	_SysBase(A5),A6
	lea	IVSOFTINT(A6),A2
	lea	_SOFTINTTxt(pc),A3
	bsr.w	_GetIRQ
	rts
_GetCIAA
	moveq	#0,D0
	bsr.w	_GetCIAs
	rts	
_GetCOP
	movea.l	_SysBase(A5),A6
	lea	IVCOPER(A6),A2
	lea	_COPTxt(pc),A3
	bsr.w	_GetIRQ
	rts
_GetVERTB
	movea.l	_SysBase(A5),A6
	lea	IVVERTB(A6),A2
	lea	_VERTBTxt(pc),A3
	bsr.s	_GetIRQ
	rts
_GetBLIT
	movea.l	_SysBase(A5),A6
	lea	IVBLIT(A6),A2
	lea	_BLITTxt(pc),A3
	bsr.s	_GetIRQ
	rts
_GetAUD0
	movea.l	_SysBase(A5),A6
	lea	IVAUD0(A6),A2
	lea	_AUD0Txt(pc),A3
	bsr.s	_GetIRQ
	rts
_GetAUD1
	movea.l	_SysBase(A5),A6
	lea	IVAUD1(A6),A2
	lea	_AUD1Txt(pc),A3
	bsr.s	_GetIRQ
	rts
_GetAUD2
	movea.l	_SysBase(A5),A6
	lea	IVAUD2(A6),A2
	lea	_AUD2Txt(pc),A3
	bsr.s	_GetIRQ
	rts
_GetAUD3
	movea.l	_SysBase(A5),A6
	lea	IVAUD3(A6),A2
	lea	_AUD3Txt(pc),A3
	bsr.s	_GetIRQ
	rts
_GetRBF
	movea.l	_SysBase(A5),A6
	lea	IVRBF(A6),A2
	lea	_RBFTxt(pc),A3
	bsr.s	_GetIRQ
	rts
_GetDSKSYN
	movea.l	_SysBase(A5),A6
	lea	IVDSKSYNC(A6),A2
	lea	_DSKSYNTxt(pc),A3
	bsr.s	_GetIRQ
	rts
_GetCIAB
	moveq	#1,D0
	bsr.w	_GetCIAs
	rts	

_GetIRQ	; A2 exec server/handler list
	tst.l	IV_NODE(A2)
	beq.s	.server
	movea.l	IV_NODE(A2),A2		; IRQ Node
.scanhandler
	move.l	LN_NAME(A2),-(sp)
	moveq	#0,D0
	move.b	LN_PRI(A2),D0
	ext.w	D0
	move.l	D0,-(sp)
	move.l	A3,-(sp)
	bsr.w	_printf
	lea	12(sp),sp

	move.l	(A2),D0			; Next IRQ Node
	beq.s	.done
	movea.l	D0,A2
	move.l	(A2),D0			; If only last entry!
	beq.s	.done
	bra.s	.scanhandler
*---------------------
.server
	move.l	(A2),D0			; IV_DATA
	beq.s	.done			; Empty?
	bmi.s	.done			; Was opened, now removed?

	movea.l	D0,A2			; Server (struct List;)
	move.l	(A2),D0			; First node
	beq.s	.done
	movea.l	D0,A2
.scanserver
	move.l	LN_NAME(A2),-(sp)
	moveq	#0,D0
	move.b	LN_PRI(A2),D0
	ext.w	D0
	move.l	D0,-(sp)
	move.l	A3,-(sp)
	bsr.w	_printf
	lea	12(sp),sp
	move.l	(A2),D0
	beq.s	.done
	movea.l	D0,A2
	move.l	(A2),D0			; If only last entry!
	beq.s	.done
	bra.s	.scanserver
.done
	rts

* -----------------------------
* Special: CIAs...

_GetCIAs
	movea.l	_SysBase(A5),A6
	move.l	D0,D6
	tst.l	D0
	beq.s	.port
	move.l	IVEXTER(A6),D2
	beq.w	.end
	bra.s	.goon
.port
	move.l	IVPORTS(A6),D2
	beq.w	.end

.goon
	movea.l	D2,A2
	move.l	(A2),D2			; Server list
	beq.w	.end
	movea.l	D2,A2
	move.l	14(A2),D2		; Pointer to resource (ciax)
	beq.w	.end
	movea.l	D2,A2

	lea	64(A2),A2		; ciax ICR vector 1 struct

	moveq	#0,D7			; For ICR vectors 1 - 5

.scan
	tst.w	D7			; ICR vectors or interrupt?
	beq.s	.firstset		; If interrupt

	move.l	8(A2),D0		; Pointer to interrupt node
	beq.s	.next
	movea.l	D0,A0

	moveq	#0,D0
	move.b	D7,D0			; ICR vector
	subq.w	#1,D0
	lsl.w	#1,D0			; Compute table offset
	lea	_ICRBit(pc),A1
	move.w	0(A1,D0.w),D0		; Offset to D0
	pea	0(A1,D0.w)		; Name of IRQ

	moveq	#0,D0
	move.b	D7,D0
	move.l	D0,-(sp)		; ICR

	movea.l	LN_NAME(A0),A1
	moveq	#-1,D0
.strlen
	tst.b	(A1)+
	dbeq	D0,.strlen
	not.l	D0
	cmpi.b	#15,D0
	bhi.s	.max
	bra.s	.align
.max
	moveq	#16,D0
.align
	lea	_BlankTxt(pc),A1
	lea	0(A1,D0.w),A1
	move.l	A1,-(sp)

	move.l	LN_NAME(A0),-(sp)	; Caller's name
	moveq	#0,D0
	move.b	LN_PRI(A0),D0
	ext.w	D0
	move.l	D0,-(sp)		; PRI

	tst.b	D6
	beq.s	.ciab
	pea	_CIABTxt(pc)		; CIA-B
	bra.s	.textset
.ciab
	pea	_CIAATxt(pc)		; CIA-A
.textset
	pea	_txt(pc)		; Text
	bsr.w	_printf
	lea	28(sp),sp

.next
	addq.w	#1,D7			; Next Vector
	cmpi.w	#5,D7			; In range?
	bhi.s	.end
	lea	12(A2),A2		; Next Interrupt vector structure
	bra.s	.scan	

.firstset
	move.l	A3,-(sp)
	lea	-22(A2),A3

.stdscan
	moveq	#1,D7			; Set ICR vector
	moveq	#0,D0
	move.b	LN_PRI(A3),D0
	ext.w	D0

	tst.w	D6			; CIA-A or CIA-B?
	beq.s	.CIAA

	lea	_CIABTxt(pc),A0		; Level 6
	bra.s	.set
.CIAA
	lea	_CIAATxt(pc),A0		; Level 2
.set
	move.l	LN_NAME(A3),-(sp)	; Name of interrupt
	move.l	D0,-(sp)		; Pri
	move.l	A0,-(sp)		; IRQ DES
	pea	_CIAStdText(pc)
	bsr.w	_printf
	lea	16(sp),sp

	move.l	(A3),D0
	beq.s	.nonext
	movea.l	D0,A3
	move.l	(A3),D0			; Only end of node-list?
	beq.s	.nonext
	bra.s	.stdscan
.nonext
	movea.l	(sp)+,A3
	bra.w	.scan
.end
	rts

*********************************************************
* I'm waiting in this place where the sun never shines...
* Stupid to write this function - it will never return
* something meaningfull, when this task runs, no SoftInt
* is running....

_GetSoftInts
	movea.l	_SysBase(A5),A6
	lea	SoftInts(A6),A3		; Pointer to first list
	moveq	#1,D2
	moveq	#-32,D3
.getnode
	movea.l	A3,A2
	move.l	(A2),D0			; Pointer to first node
	beq.s	.next
	movea.l	D0,A2
	move.l	(A2),D0			; Only last entry?
	beq.s	.done
.loop
	move.l	D3,-(sp)
	move.l	LN_NAME(A2),-(sp)
	pea	_SoftIntsTxt(pc)
	bsr.w	_printf
	lea	12(sp),sp

	move.l	(A2),D0
	beq.s	.next
	movea.l	D0,A2
	move.l	(A2),D0			; Only last entry?
	bra.s	.loop
.next
	addq.w	#1,D2
	cmpi.w	#5,D2
	bhi.s	.done
	addi.w	#16,D3
	lea	SH_SIZE(A3),A3
	bra.s	.getnode
.done

	rts

***************************************************************
* Get Vector Base Reqister and from this the level 6 routine to
* call level-6 interrupts.

_GetVBR
	move.l	A5,-(sp)
	movea.l	_SysBase(A5),A6
	move.w	AttnFlags(A6),D0
	lea	0.w,A0
	andi.w	#AFF_68010!AFF_68020!AFF_68030!AFF_68040!AFF_68060,D0
	beq.s	.na
	lea	.except(pc),A5
	jsr	_LVOSupervisor(A6)
	movea.l	D0,A0	
.na
	move.l	$78(A0),D0		; Level 6 ROM-code 
	movea.l	(sp)+,A5
	rts

.except
	movec	VBR,D0
	rte

********************************************************************
* Remember whithin 1 seconds all Cause() calls... a bit dangerous...

_SetPatch
	pea	_PatchTxt(pc)
	bsr.w	_printf
	addq.l	#4,sp

	bsr.s	_SetFunction
	move.l	_OldFunc(pc),D0
	beq.s	.done

	moveq	#60,D1			; ~1 second
	movea.l	_DOSBase(A5),A6
	jsr	_LVODelay(A6)

	bsr.s	_RemFunction

	move.l	_Entries(pc),D3
	beq.s	.done

	lea	_CauseTable(pc),A3
1$
	movea.l	(A3)+,A0
	moveq	#0,D0
	move.b	LN_PRI(A0),D0
	ext.w	D0
	move.l	D0,-(sp)
	move.l	LN_NAME(A0),-(sp)
	pea	_SoftIntsTxt(pc)
	bsr.w	_printf
	lea	12(sp),sp
	subq.l	#1,D3
	bne.s	1$
.done
	rts

_SetFunction
	movea.l	_SysBase(A5),A6
	jsr	_LVODisable(A6)
	movea.l	A6,A1
	lea	_LVOCause.w,A0
	lea	_NewFunction(pc),A2
	move.l	A2,D0
	jsr	_LVOSetFunction(A6)
	lea	_OldFunc(pc),A0
	move.l	D0,(A0)
	jsr	_LVOEnable(A6)
	rts

_RemFunction
	movea.l	_SysBase(A5),A6
	jsr	_LVODisable(A6)
	movea.l	A6,A1
	lea	_LVOCause.w,A0
	move.l	_OldFunc(pc),D0
	jsr	_LVOSetFunction(A6)
	jsr	_LVOEnable(A6)
	rts

_NewFunction
	lea	_CauseTable(pc),A0
.loop
	cmpa.l	(A0),A1			; Else, compare raised one with those we remembered
	beq.s	.alreadyset		; If found...
	tst.l	(A0)			; Nothing remembered until now or a free entry in table?
	beq.s	.setnew			; Then set this irq
	addq.l	#4,A0			; Pointer to next remembered one or again a free entry
	bra.s	.loop			; Search on

.alreadyset
	movea.l	_OldFunc(pc),A0		; Was already remembered...
	jmp	(A0)

.setnew					; Remember new one
	move.l	_Entries(pc),D0	
	cmpi.w	#(128/4)-3,D0		; Entry buffer full?
	bhi.s	.alreadyset

	move.l	A1,(A0)			; If not, remember this irq
	lea	_Entries(pc),A0
	addq.l	#1,(A0)			; Increase remember count
	bra.s	.alreadyset		; Call original exec function

_OldFunc
	ds.l	1
_Entries
	ds.l	1
_CauseTable
	ds.b	128

***********************************************************
_PrintStatus
	pea	_StatusTxt(pc)
	bsr.w	_printf
	addq.l	#4,sp
	rts
***********************************************************


_TBETxt
	dc.b	'IRQ (TBEmpty Level 1), PRI %3d, owner: "%s',10,0
_DSKBLKTxt
	dc.b	'IRQ (DSKBLoK Level 1), PRI %3d, owner: "%s"',10,0
_SOFTINTTxt
	dc.b	'IRQ (SOFTINT Level 1), PRI %3d, owner: "%s"',10,0
_COPTxt
	dc.b	'IRQ (COPpER  Level 3), PRI %3d, owner: "%s"',10,0
_VERTBTxt
	dc.b	'IRQ (VERTB   Level 3), PRI %3d, owner: "%s"',10,0
_BLITTxt
	dc.b	'IRQ (BLITter Level 3), PRI %3d, owner: "%s"',10,0
_AUD0Txt
	dc.b	'IRQ (AUDio 0 Level 4), PRI %3d, owner: "%s"',10,0
_AUD1Txt
	dc.b	'IRQ (AUDio 1 Level 4), PRI %3d, owner: "%s"',10,0
_AUD2Txt
	dc.b	'IRQ (AUDio 2 Level 4), PRI %3d, owner: "%s"',10,0
_AUD3Txt
	dc.b	'IRQ (AUDio 3 Level 4), PRI %3d, owner: "%s"',10,0
_RBFTxt
	dc.b	'IRQ (RBFull  Level 5), PRI %3d, owner: "%s"',10,0
_DSKSYNTxt
	dc.b	'IRQ (DSKSYNC Level 5), PRI %3d, owner: "%s"',10,0
_SoftIntsTxt
	dc.b	'IRQ (SOFTINTS Level 1) raised by: "%s", PRI: %d',10,0
_LF
	dc.b	10,0
_BlankTxt
	dc.b	'                '
	dc.b	0
_txt
	dc.b	'IRQ %s, PRI %3d, owner: "%s",%s IVEC %d = %s',10,0
_CIAStdText
	dc.b	'IRQ %s, PRI %3d, owner: "%s"',10,0
_CIAATxt
	dc.b	'(PORTS   Level 2)',0
_CIABTxt
	dc.b	'(EXTER   Level 6)',0
_StatusTxt
	dc.b	'IntList V3.0 - Based on noone''s Guru''s Guide',10
	dc.b	'- Copyright 1996  ONIX - Exec should be rewritten...',10,10,0
_PatchTxt
	dc.b	10,'Scanning for Cause() Level 1 interrupts',10
	dc.b	'Hold on, computing for about one second...',10,10,0
_VerTxt
	dc.b	'$VER: IntList 3.14 (08.11.97) Copyright J.v.d.Loo »ONIX«',13,10,0

	CNOP	0,4
_ICRBit
	dc.w	1$-_ICRBit
	dc.w	2$-_ICRBit
	dc.w	3$-_ICRBit
	dc.w	4$-_ICRBit
	dc.w	5$-_ICRBit
1$
	dc.b	'Timer A    ',0
2$
	dc.b	'Timer B    ',0
3$
	dc.b	'TOD Alarm  ',0
4$
	dc.b	'Serial Port',0
5$
	dc.b	'Flag Input ',0


	CNOP	0,4

*********************************************************************************
*
** Dies ist die printf()-Routine mit gleichgebliebenen Syntax wie die originale!
** C spezifische Argumente werden aber nicht verwaltet, so z.B. "%#8ld" oder
** dergleichen, da die eigentliche Arbeit an RawDoFmt() übergeben wird, und diese
** Betriebssystemroutine dies nicht unterstützt.
*
** Falls jemand seine eigenen Routinen für den MC++-Compiler der Version 1.10.7
** schreiben möchte, so muß er tunlichst darauf achten das Prozessor-Register
** A6 instand zu halten. Dieses Register wird intern verwendet, so z.B. im Opti=
** mierungsmodus.
*

	OPT	OW-

pfBufferSize	EQU	256

     STRUCTURE	printfBuf,0
	STRUCT	_pfCnt,4		; Zähler für Anzahl Buchstaben
	STRUCT	_pfBuffer,pfBufferSize	; Platz für eine Zeile von 127 Bytes
	LABEL	_pfArgs			; Dynamische Größe...
	LABEL	pfb_SIZE		; Bestimmt nicht das Strukturende.....


_printf
	movem.l	D2-D5/A2-A3/A6,-(sp)	; Alle benötigten Register retten
	movea.l	32(sp),A0		; Zeiger auf den zu formatierenden Text
	moveq	#-1,D1			; Dummy-Zähler
	moveq	#0,D0			; Zähler für Argumente
0$
	cmpi.b	#'%',(A0)		; Argument?
	bne.s	.NoArg			; Nö...
	addq.w	#1,D0			; Argument +1
.NoArg
	tst.b	(A0)+			; Ende der Zeichenkette?
	dbeq	D1,0$			; Wenn nicht...

	lsl.l	#2,D0			; Anzahl Argumente mal 4 ( Langworte )
	add.l	#pfb_SIZE,D0		; 4 Bytes für Zähler, rest Puffer
	addq.l	#7,D0
	andi.l	#-8,D0			; Durch acht teilbar machen
	move.l	D0,D5			; Größe sichern
	move.l	#MEMF_PUBLIC|MEMF_CLEAR,D1 ; Anforderungen an den Speicher
	movea.l	_SysBase(A5),A6
	jsr	_LVOAllocMem(A6)	; Speicher anfordern
	move.l	D0,D4			; Adresse Speicher
	beq.s	3$			; Falls Fehler...

	movea.l	32(sp),A0		; Zeiger auf unformatierte Zeichenkette
	lea	36(sp),A1		; Zeiger auf die Argumentenliste
	movea.l	D4,A2			; Adresse Tabelle
	lea	_pfArgs(A2),A2		; Adresse Argumenten-Puffer (ab Offset 132)

	moveq	#-1,D1			; Dummy-Zähler als Anweisung für
	bra.s	1$			; Turbo-Boards

* --    #############  -- *
.skip
	addq.l	#2,A0			; Beide %-Zeichen überlesen
	subq.w	#2,D1			; 2 Zeichen weniger im Text
	bmi.s	3$			; Falls Fehler (Übertrag)

* --- Hier gehts los! --- *
1$
	cmpi.b	#'%',(A0)		; Argument?
	bne.s	2$			; Nee...
	cmpi.b	#'%',1(A0)		; oder nur ein Prozentzeichen ausgeben?
	beq.s	.skip			; wenn so, beide %-Zeichen überlesen
	addq.l	#1,A0			; Sonst nur ein %-Zeichen überlesen
	subq.w	#1,D1			; Zähler dekremieren
.getType
	cmpi.b	#'b',(A0)		; Argument = BCPL?
	beq.s	.typeFound		; wenn so...
	cmpi.b	#'d',(A0)		; Dezimal-Zahl?
	beq.s	.typeFound.1
	cmpi.b	#'x',(A0)		; Sedezimale Zahl?
	beq.s	.typeFound.1
	cmpi.b	#'s',(A0)		; Zeichenkette?
	beq.s	.typeFound
	cmpi.b	#'c',(A0)		; Ein Buchstaben (o. Zahl)?
	beq.s	.typeFound.1
*
** Da ein Argument so aufgebaut sein kann: '%08ld' suchen wir nur nach der
** gültigen Beschreibung für das Argument, hier 'd' in einer Schleife.
*
	tst.b	(A0)+			; Loop-Anweisung
	dbeq	D1,.getType		; und weiter machen, solange nicht
*					  gefunden
	bra.s	3$			; Wenn Fehler (Ende des Strings ohne
*					  Argument!)
.typeFound.1
	cmp.b	#'l',-1(A0)		; Langwort?
	beq.s	.typeFound		; dann andere Routine
	move.l	(A1),D0			; Hole Argument (immer ein Langwort!)
	move.w	D0,(A2)+		; Schreibe für Exec aber nur Wort!
	addq.l	#4,A1			; Zeiger auf nachfolgenden Parameter
*					  (Argumenten-Inhalt)
	bra.s	2$			; und normal weiter machen
.typeFound
	move.l	(A1),(A2)+		; Argumenten-Inhalt in den Puffer
	addq.l	#4,A1			; siehe oben
2$
	tst.b	(A0)+			; Suche NULL-Byte
	dbeq	D1,1$
	bra.s	.FmtString		; == Ende der Zeichenkette, jetzt die
*					  Zeichenkette ausgeben
3$
	moveq	#-1,D0			; Fehler retournieren
.printf_end
	tst.l	D4			; Adresse Tabelle?
	beq.s	4$
	movea.l	D4,A1			; Adresse Tabelle!
	move.l	D5,D0			; Größe Tabelle
	movea.l	_SysBase(A5),A6
	jsr	_LVOFreeMem(A6)		; Tabelle freigeben
4$
	movem.l	(sp)+,D2-D5/A2-A3/A6
	rts


.FmtString
	movea.l	32(sp),A0		; Zeiger auf unformatierte Zeichnekette
	movea.l	D4,A3			; Adresse Tabelle
	lea	_pfArgs(A3),A1		; Adresse Argumenten-Puffer nach A1 (Stream)
	lea	.Hook(pc),A2		; Call-Back-Routine
*	movea.l	A3,A3			; Adresse Tabelle sowieso in A3
	movea.l	_SysBase(A5),A6		; Basis Exec
	jsr	_LVORawDoFmt(A6)	; Zeichenkette formatieren
	move.l	_stdout(A5),D1		; MC++'s Output-Handle
	beq.s	3$			; falls Fehler (nicht vorhanden)
	movea.l	D4,A0			; Tabelle
	lea	_pfBuffer(A0),A1	; Adresse formatierter Text im Puffer
	move.l	A1,D2			; nach D2
	move.l	_pfCnt(A0),D3		; Länge des Text
	beq.s	.okEnd			; Falls Zeichenkette schon ausgegeben wurde...
	subq.l	#1,D3			; Ignoriere null-Byte am Ende der Zeichenkette
	beq.s	.okEnd			; Falls null
	movea.l	_DOSBase(A5),A6		; Basis DOS
	jsr	_LVOWrite(A6)		; Text schreiben (in Konsole)
.okEnd
	moveq	#0,D0			; Kein Fehler
	bra.s	.printf_end


.Hook
* D0 == Buchstaben, wird retourniert von RawDoFmt()
* A3 == Zeiger auf Tabelle, wird retourniert von RawDoFmt()
	movem.l	D1/A0,-(sp)
	lea	_pfBuffer(A3),A0	; Puffer für formatierten Text
	move.l	_pfCnt(A3),D1		; Anzahl Zeichen die schon im Puffer
*					  abgelegt worden sind
	move.b	D0,0(A0,D1.w)		; aktuelles Zeichen dranhängen
	addq.l	#1,_pfCnt(A3)		; Zähler inkrementieren
	cmpi.l	#pfBufferSize-2,D1	; Maximale Anzahl Zeichen im Puffer!?
	bls.s	.ok			; Wenn weniger o. gleich, ok.

	clr.b	-1(A0,D1.w)
	subq.l	#1,_pfCnt(A3)

.ok	
	movem.l	(sp)+,D1/A0
	rts

	OPT	OW+


	END
