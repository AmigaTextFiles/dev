;TOSPJPKPJPKAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGAFAGAG
*************************************************************************
*									*
*				No Mem Guru				*
*									*
*************************************************************************
;Written on Trashm'one 2.0
;Freeware source for learning purpose
;Most commends is in polish (APL)
;Do what You want with this!

	AUTO	=\
VERSION		MACRO
		dc.b	'2.3'
		ENDM
DATE		MACRO
		dc.b	'95.08.15'
		ENDM
;
;NoMemGuru
;Rafik/rdst/sct
;94.12.19?
;ma wyôwietlaê guru gdy zabrakîo alloc mem..
;95 Feb 27? dorzucam wolnâ pamiëê
;
;bigfoot/rdst
;95.06.19
;Od Nowa (prawie) napisaî bigfoot/rdst
;poprawiîem tekst wyôwietlany przez DisplayAlert
; dziaîa deinstalacja, ale trzeba odczekaê trochë czasu zanim nastâpi
; sprawdzenie (Delay -1)
; czasami sië wiesza (dlaczego ????????)
;
;NewAllocMem_OldAllocMem2 jest zostawione na przyszîoôê, moûna sprawdzaê
;czy coô innego nie podîâczyîo sië do AllocMem (np. stary MemoryController)
;OK dalsze poprawki by rthek...:)))
;czyje ûe sopro stâd wywale....:))))
;prawidîowo powinno byê "czujë ûe sporo stâd wywalë"
;exe=952 po skrótach exe=944 (8 bajtów mniej !!!!!) coô dla rthek
;


;		jmp	ShowGuru
EXEC:	MACRO
	move.l	4.w,a6
	ENDM
CALL:	MACRO
	jsr	_\1(a6)
	ENDM

MainStart:
		EXEC
		move.l	_AllocMem+2(a6),a1
		
		cmp.l	#'NMem',[NewAllocMem_Header-NewAllocMem](a1)
		beq.b	Uninstall

		lea	IntName(pc),a1
		CALL	OldOpenLibrary
		move.l	d0,IntBase
		beq.b	MainEnd

		move.l	_AllocMem+2(a6),OldAllocMem	;Zamiana wektorów
		move.l	_AllocMem+2(a6),OldAllocMem2 ;Zamiana wektorów
		move.l	#NewAllocMem,_AllocMem+2(a6)

_AllocAbs	EQU	-204
;		move.l	#NewAllocMem,_AllocAbs+2(a6)

		lea	DosName(pc),a1
		CALL	OldOpenLibrary
		move.l	d0,a6

		jsr	Output(a6)
		move.l  d0,d1
		move.l	#AboutTXT,d2
		move.l  #AboutTXTEnd-AboutTXT,d3
		jsr	Write(a6)

.1		move.l	#1*50*60,d1	;1 na minute...
		jsr	Delay(a6)

		move.b	Switch(pc),d0
		beq.b	.1
.deinstall
		move.l	a6,a1
		EXEC

		jsr	CloseLibrary(a6)

		move.l	IntBase(pc),a1
		jsr	CloseLibrary(a6)

MainEnd:
		moveq	#0,d0
		rts

Uninstall:
		st.b	[Switch-NewAllocMem](a1)

		move.l	[OldAllocMem-NewAllocMem](a1),_AllocMem+2(a6)	;restore old

		lea	DosName(pc),a1
		CALL	OldOpenLibrary
		move.l	d0,a6

		jsr	Output(a6)
		move.l  d0,d1
		move.l	#AboutTXT,d2
		move.l  #UninstallTXTEnd-AboutTXT,d3
		jsr	Write(a6)

		moveq	#0,d0
		rts


NewAllocMem:		bra.b	NewAllocMem_1
NewAllocMem_Header:	dc.l	'NMem'
OldAllocMem:		dc.l	0
OldAllocMem2:		dc.l	0
Switch:			dc.b	0,0

NewAllocMem_1:
		move.l	d0,-(sp)	;MemorySize
		move.l	d1,-(sp)	;MemoryType

		move.l	#NewAllocMem_3,-(sp)	;powrót
		move.l	OldAllocMem(pc),-(sp)	;orginalnyadr
		rts

NewAllocMem_3:
		tst.l	d0
		beq.b	ShowGuru
		addq.l	#8,sp		;skip memory adr/size!
		rts
ShowGuru:
;MEMF_PUBLIC	=1
;MEMF_CHIP	=2
;MEMF_FAST	=4
;MEMF_CLEAR	=$10000
;MEMF_LARGEST	=$20000
	move.l	(sp)+,d0		;memtype
	move.l	(sp)+,MemorySize	;memsize

	movem.l	d0-a6,-(sp)

	btst.l	#1,d0
	beq.b	ShowGuru_Public
	move.w	#'  ',NeedType1
	btst.l	#2,d0
	beq.b	ShowGuru_Chip

ShowGuru_Fast:
	move.l	#'FAST',NeedType2
	bra.b	ShowGuru.1
ShowGuru_Chip:
	move.l	#'CHIP',NeedType2
	bra.b	ShowGuru.1
ShowGuru_Public:
	move.w	#'PU',NeedType1
	move.l	#'BLIC',NeedType2

ShowGuru.1:
	lea	TaskName(pc),a0
	moveq	#67,d0
.0:	move.b	#' ',(a0)+
	dbra	d0,.0

	EXEC
	sub.l	a1,a1
	jsr	FindTask(A6)
	move.l	d0,a1
	move.l	10(a1),a2
	lea	TaskName(pc),a0
.1:
	move.b	(a2)+,d0
	beq.b	.2
	move.b	d0,(a0)+
	bra.b	.1
.2:

;	move.l	MemorySize(pc),FreeMemory
	lea     DecRecord(pc),a0
	lea     MemorySize(pc),a1	;*
	lea     PutChProc(pc),a2
	lea     NeedSize(pc),a3
	jsr     RawDoFmt(a6)

	move.l	#MEMF_LARGEST!MEMF_CHIP,d1
	jsr	AvailMem(a6)
	move.l	d0,FreeMemory

	lea     DecRecord(pc),a0
	lea     FreeMemory(pc),a1
	lea     PutChProc(pc),a2
	lea     Largest(pc),a3
	jsr     RawDoFmt(a6)

Display:
	move.l	IntBase(pc),a6
	moveq	#0,d0
	moveq	#100,d1
	lea	Text(pc),a0
	jsr	DisplayAlert(a6)
	tst.l	d0
	bne.b	.1
	st	Switch	;tera to rmb=end!!! gdyby 2 taski..to :((
	EXEC
	move.l	OldAllocMem(pc),_AllocMem+2(a6)
.1
	movem.l	(sp)+,d0-a6
	moveq	#0,d0
	rts

PutChProc:		
			tst.b	d0
			beq.b	.1
			move.b  d0,(a3)+
.1			rts

IntBase:	dc.l	0
FreeMemory:	dc.l	0
MemorySize:	dc.l	0	
Text:					;Text glowny
		dc.b	0,235,20
		dc.b	"No Memory Guru V"
		VERSION
		dc.b	0,1
		dc.b	0,200,35
		dc.b	'(C) 1995 by Rafik & BigFoot'
		dc.b	0,1
		dc.b	0,20,60
		dc.b	'Task:'
TaskName:	dc.b	'                                                                     '
TaskNameEnd:	dc.b	0,1
		dc.b	0,180,70
SizeText:	dc.b	'needs '
NeedSize:	dc.b	'xxxxxxxxx bytes of '
NeedType1:	dc.b	'  '
NeedType2:	dc.b	'CHIP Ram.'
		dc.b	0,1
		dc.b	0,120,80
		dc.b	'Largest block of free memory has '
Largest:	dc.b	'xxxxxxxxx'
		dc.b	' bytes.'
		dc.b	0,1
		dc.b	1,220,90
		dc.b	'RMB = Deinstall'
		dc.b	0,0
EndText:
			dc.b	'$VER: No Memory Guru '
			VERSION
			dc.b	' by Rafik/rdst/sct Gdynia '
			DATE
			dc.b	$a
	dc.b	'Its a simple freeware proggy that shows guru when alloc mem'
	dc.b	' fails.',0

IntName:		dc.b	'intuition.library',0
DosName:		dc.b	'dos.library',0
DecRecord:		dc.b    '%9.9ld',0,0
AboutTXT:		dc.b	$1b,'[1mNo Memory Guru '
			VERSION
	dc.b	$1b,'[22m (c) 1995 by Rafik/rdst/sct & BigFoot/rdst',$a
AboutTXTEnd:		dc.b	'Uninstalled...',$a
UninstallTXTEnd:

Write                           EQU                     -48
Output                          EQU                     -60
Lock                            EQU                     -84
UnLock                          EQU                     -90
DupLock                         EQU                     -96
CreateDir                       EQU                     -120
AssignLock                      EQU                     -612

MEMF_PUBLIC	=1
MEMF_CHIP	=2
MEMF_FAST	=4
MEMF_CLEAR	=$10000
MEMF_LARGEST	=$20000
AvailMem	EQU	-216
_AllocMem	EQU	-198
_OldOpenLibrary	equ	-408
DisplayAlert	equ	-90
CloseLibrary	EQU	-414
;dos
Delay	EQU	-198
RawDoFmt                                EQU                     -522
FindTask	EQU	-294
