*-----------------------------------------------*
*	@AppCreationError			*
*-----------------------------------------------*

AppCreationError:
	move.l	dos(a4),a6
	jsr	_LVOIoErr(a6)
	cmp.w	#6,d0
	bmi.b	.mui_error
	bsr	GetErrorString2
	move.l	4(a4),(a4)
.jatka	GETSTR	MSG_APP_CREATION_ERROR
	move.l	d0,a2
	bra	InfoRequester
.x	rts

.mui_error:
	subq.l	#1,d0			; #1
	beq.b	.no_mem
	subq.l	#1,d0			; #2
	beq.b	.no_mem
	subq.l	#2,d0
	beq.b	.missing_lib
	subq.l	#1,d0
	beq.b	.no_arexx
	GETSTR	MSG_MUIE_UNKNOWN
	bra.b	.jatka

.no_arexx:
	GETSTR	MSG_MUIE_NO_AREXX
	move.l	d0,(a4)
	bra.b	.jatka

.missing_lib:
	GETSTR	MSG_MUIE_MISSING_LIB
	move.l	d0,(a4)
	bra.b	.jatka

.no_mem	GETSTR	MSG_MUIE_NO_MEM
	move.l	d0,(a4)
	bra.b	.jatka

*-----------------------------------------------*
*	@NoMemory				*
*-----------------------------------------------*

NotEnoughMemory:
	move.l	(a4),d0
	lsr.l	#8,d0			; muunna kilotavuiksi
	lsr.l	#2,d0
	move.l	d0,(a4)
	GETSTR	MSG_NOMEMORY
	move.l	d0,a2
InfoRequester:
	GETSTR	MSG_OK_GAD
	move.l	d0,a1
MonivalintaKysymys:
	move.l	muimaster(a4),a6
	move.l	App(a4),d0
	moveq	#0,d1			; window
	moveq	#0,d2			; flags
	suba.l	a0,a0			; title
	move.l	a4,a3
	jsr	_LVOMUI_RequestA(a6)
	tst.l	d0
	rts

*-----------------------------------------------*
*	@DiskError				*
*-----------------------------------------------*

DiskError:
	bsr	GetErrorString		; hae virheteksti
	beq.b	.x
	GETSTR	MSG_DISK_ERROR
	move.l	d0,a2
	bra	InfoRequester
.x	rts

*-----------------------------------------------*
*	@DirectoryError				*
*-----------------------------------------------*

DirectoryError:
	bsr	GetErrorString
	GETSTR	MSG_DIRECTORY_ERROR
	move.l	d0,a2
	bra	InfoRequester

*-----------------------------------------------*
*	@GetErrorString				*
*-----------------------------------------------*

GetErrorString:
	jsr	_LVOIoErr(a6)
GetErrorString2:
	move.l	d0,d1
	beq.b	.x
	lea	80(a4),a0
	moveq	#0,d2
	move.l	a0,4(a4)
	move.l	a0,d3
	moveq	#127,d4	
	jmp	_LVOFault(a6)
.x	rts
