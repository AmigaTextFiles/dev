
	incdir	include:
	include	exec/execbase.i	

CacheClearU	=	-636
Forbid		=	-132
Permit		=	-138
OpenLibrary	=	-552
CloseLibrary	=	-414
Wait		=	-318
FindTask	=	-294
EasyRequestArgs =	-588
SetFunction	=	-420

	move.l	4.w,a6				; Execbase nach A6
	lea	IntuiName(pc),a1		; "intuition.library"
	move.l	#37,d0				; Version 37+
	jsr	OpenLibrary(a6)			; OpenLib()
	move.l	d0,IntuiBase			; Intuitionbase nach D0
	beq.w	NoIntui				; !Lib -> Raus

	move.l	4.w,a6				; Execbase
	jsr	Forbid(a6)			; Stop MT

	jsr	CacheClearU(a6)			; Caches loeschen

	move.l	4,a1				; Execbase nach A1
	move.w	#SetFunction,d0			; SetFunction()-Offs. nach D0
	ext.l	d0				; Auf long
	add.l	d0,a1				; auf Execbase addieren
	addq.l	#2,a1				; Zwei dazu (fuer JMP)
	lea	NewSetFunction(pc),a2		; Neue Setfunction nach A2
	move.l	(a1),OldSetFunction		; Orig.-Setfunction speichern
	move.l	a2,(a1)				; ...und durch neue ersetzen!

	move.l	4,a6				; Execbase nach A6
	jsr	Permit(a6)			; Start MT

	move.l	#1<<12,d0	;SIGF_CTRL_C	; CTRL-C-Signal maskieren
	jsr	Wait(a6)			; Und warten....
;Ctrl-C received

	move.l	4.w,a6				; Execbase nach A6
	jsr	Forbid(a6)			; Stop MT

	jsr	CacheClearU(a6)			; Caches loeschen

	move.l	4,a1				; Execbase nach A1
	move.w	#SetFunction,d0			; SetFunction-Offs. nach D0
	ext.l	d0				; Auf long
	add.l	d0,a1				; auf Execbase addieren
	addq.l	#2,a1				; Zwei dazu (fuer JMP)
	move.l	OldSetFunction,(a1)		; Orig.-SetFunction zurueck!

	move.l	4,a6				; Execbase nach A6
	jsr	Permit(a6)			; Start MT

	move.l	IntuiBase(pc),a1		; Intuitionbase nach A1
	jsr	CloseLibrary(a6)		; CloseLib()
NoIntui:
	moveq	#0,d0				; Kein FehlerCode
	rts					; ..und tschuess!

NewSetFunction:
	movem.l	d0-d7/a0-a6,-(sp)		; Register retten

	move.l	d0,d6				; Zeiger auf NewFunc nach D6
	move.l	a1,d5				; Zeiger auf LibBase nach D5
	moveq	#0,d4				; D4 = 0
	move.w	a0,d4				; FuncOffset nach D4
	ext.l	d4				; Auf long
	neg.l	d4				; invertieren

	move.l	4,a6				; ExecBase nach A6
	suba.l	a1,a1				; A1 = 0
	jsr	FindTask(a6)			; TaskAdresse holen
	move.l	d0,a0				; ...nach A0
	move.l	10(a0),d0			; Name des Tasks nach D0
	lea	TextArray(pc),a3		; RequesterTextArray nach A3
	move.l	d0,(a3)+			; TaskName eintragen
	move.l	d4,(a3)+			; FuncOffset eintragen

	move.l	4.w,a1				; Execbase nach A1
	move.l	LibList+LH_HEAD(a1),a1		; 1.Node in LibListe nach A1

Liblistloop:
	move.l	a1,d0				; Node nach D0
	tst.l	d0				; Node == 0 (Ende) ?
	beq	Liblistend			; Ja, keine weiteren Eintraege
	cmp.l	a1,d5				; Node == uebergebene LibBase ?
	beq	Libfound			; ...yep ! Zum Requester...
	move.l	(a1),a1				; Naechsten Node nach A1 holen
	bra.s	Liblistloop			; ...und zurueck in Schleife

LibListEnd:
	lea	UnknownLib(pc),a1		; "UNKNOWN !!" nach A1
	move.l	a1,(a3)+			; Und ins Requesterarray rein!
	bra.s	Libfound2			; ...weiter

Libfound:
	move.l	LN_Name(a1),(a3)+		; LibNode->LN_Name ins Array

Libfound2:
	move.l	d6,(a3)				; NewFunc ins Array
	move.l	IntuiBase(pc),a6		; Intuitionbase nach A6
	moveq	#0,d0				; WindowPtr = 0
	move.l	d0,a0				; ...in A0
	lea	EasyStruct(pc),a1		; EasyStruct nach A1
	move.l	#0,a2				; keine idcmpPtr
	lea	TextArray,a3			; RequesterArray nach A3
	jsr	EasyRequestArgs(a6)		; EasyRequestArgs()

	movem.l	(sp)+,d0-d7/a0-a6		; Register zurueckholen
	move.l	OldSetFunction,-(sp)		; Orig.-Setfunction aufn Stack
	rts					; ...go...


OldSetFunction:	dc.l	0
IntuiBase:	dc.l	0
IntuiName:	dc.b	'intuition.library',0
		cnop	0,4

EasyStruct:
	dc.l	EasyStructEnd-EasyStruct
	dc.l	0
	dc.l	TitleText
	dc.l	Text
	dc.l	GadText
EasyStructEnd:
	cnop	0,4
		dc.b	'$VER:'
TitleText:	dc.b	'SetFunction()-Snooper V0.9',0
	cnop	0,4
Text:		dc.b	'Task ',34,'%s',34,' attemps to patch a'
		dc.b	' library-function!',$0a
		dc.b	'Function-offset: -%ld',$0a
		dc.b	'Library-name   : %s',$0a
		dc.b	'Newfunction at : $%08lx',$0a,0
	cnop	0,4
GadText:	dc.b	'Aha aha...',0				
	cnop	0,4
TextArray:	dc.l	0,0,0,0,0
	cnop	0,4
UnknownLib:	dc.b	'UNKNOWN !!',0
	

