**
**	GetMode.asm
**
**	Selects screen mode with Reqtools-requester and displays
**	its mode id on stdout.
**
** 14.08.96 (Phx) created
** 11.10.96 (Phx) replaced reqtools.library by asl.library
**		  minor changes for inclusion into PhxAss' examples drawer
**


	incdir	"include"
**  You should also define an include path for your Commodore **
** includes or make use of the PHXASSINC environment variable **
	include	"lib/exec.i"		; library offsets
	include "lib/dos.i"
	include	"lib/asl.i"

	include	"libraries/asl.i"


	code
	near	a4,-1


start:
	initnear
	move.l	ExecBase.w,a6
	move.l	a6,_SysBase(a4)
	lea	dosName(pc),a1
	moveq	#36,d0
	jsr	OpenLibrary(a6)		; open dos.library v36
	move.l	d0,_DosBase(a4)
	beq	cleanup
	lea	aslName(pc),a1
	moveq	#38,d0
	jsr	OpenLibrary(a6)		; open asl.library v38 (older ver-
	move.l	d0,_AslBase(a4)		; sions have no scr.mode requester)
	beq	cleanup

	move.l	d0,a6
	move.l	#ASL_ScreenModeRequest,d0
	lea	tag_end(pc),a0
	jsr	AllocAslRequest(a6)	; alloc memory for requester struct
	move.l	d0,scrmodreq(a4)
	beq	cleanup

	move.l	d0,a0
	lea	scrmodtags(pc),a1
	jsr	AslRequest(a6)		; render screen mode requester
	tst.l	d0
	beq	cleanup			; clicked cancel?

	move.l	_DosBase(a4),a6
	move.l	scrmodreq(a4),a0
	move.l	sm_DisplayID(a0),-(sp)	; fetch and print display id
	lea	modetxt(pc),a0
	move.l	a0,d1
	move.l	sp,d2
	jsr	VPrintf(a6)
	addq.l	#4,sp

cleanup:
	move.l	_SysBase(a4),a6
	move.l	_AslBase(a4),d7
	beq	2$
	exg	d7,a6
	move.l	scrmodreq(a4),a0
	jsr	FreeAslRequest(a6)	; free screen mode req. structure
	move.l	a6,a1
	move.l	d7,a6
	jsr	CloseLibrary(a6)	; close asl.library
2$:	move.l	_DosBase(a4),d0
	beq	1$
	move.l	d0,a1
	jsr	CloseLibrary(a6)	; close dos.library
1$:	moveq	#0,d0
	rts


dosName:
	dc.b	"dos.library",0
aslName:
	dc.b	"asl.library",0
modetxt:
	dc.b	"0x%08lx\n",0
scrmodtxt:
	dc.b	"Select screen mode",0
	cnop	0,4
scrmodtags:
	dc.l	ASLSM_TitleText,scrmodtxt
tag_end:
	dc.l	TAG_END



	bss

_SysBase:	ds.l	1
_DosBase:	ds.l	1
_AslBase:	ds.l	1
scrmodreq:	ds.l	1


	end
