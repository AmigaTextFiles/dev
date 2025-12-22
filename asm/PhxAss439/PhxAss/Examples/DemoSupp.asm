**
**    A500/600/1000/1200/2000/3000/4000
**	  Kick 1.2,1.3 / OS 2.x/3.x
**	    68000/010/020/030/040
**		 OCS/ECS/AGA
**
**	** DEMO SUPPORT FUNCTIONS **
**
**
**	  Coded by Frank Wille 1994
**	       using PhxAss 4
**
**
**     __MERGED SMALL DATA A4 - VERSION
**   Link with: PhxLnk prog.o DemoSupp.o
**
**
**  10.12.94	demoStartup, demoCleanUp, demoIntVec (created)
**  12.12.94	Switched to __MERGED-SmallData
**  20.12.94	demoStdView, demoBplPtrs (created)
**  22.12.94	demoColors (created), code optimizations in demoStdView
**


;=============================================================================
; Exported Symbols:
;=============================================================================
; _SysBase		Pointer to ExecBase structure
; _GfxBase		Pointer to GfxBase structure
; PALflag		true: System is in PAL mode
; AAflag		true: AGA chips are available
;=============================================================================


;=============================================================================
; Exported Functions:
;=============================================================================
;
; demoStartup
;	in:	-
;	out:	Z-Flag = Error! Jump to demoCleanup immediately!
;		a4 = Small Data Base
;		a6 = CUSTOM
;		All other registers are in random state!!!
;	Small Data initialization. Disable Data Cache. Enable CLI or Workbench
;	start. Determine VBR, PAL/NTSC mode, Gfx-chips. Save system state.
;	Allocate Blitter. Turn off all interrupts and DMA channels. Disable
;	AGA/ECS features. Save interrupt autovectors.
;
; demoCleanup
;	in:	-
;	out:	d0 = 0 (for return to CLI - no error)
;		All other registers are in random state!!!
;	Restores anything which has changed during the demo. Then, the program
;	may return to CLI or WB without any danger.
;
; demoIntVec
;	in:	d0.w = Number of interrupt level vector to change (1-6)
;		a0 = Pointer to interrupt routine (terminated by 'rte')
;		     (CAUTION: The 'rte' should be preceded by a 'nop',
;		      because of the 68040's instruction pipeline)
;	out:	-
;	Set interrupt autovector.
;
; demoStdView
;	in:	d0.w = Display width in pixels (should be word-aligned)
;		d1.w = Display height in lines
;		d2.w = Horizontal start position (std.= $81)
;		d3.w = Vertical start position (std.= $29)
;		d4.w = Depth
;			Bits 2-0 = Number of bitplanes (1-5)
;			Bit 3	 = Interleaved Mode (fast blits)
;		a0 = Actual copper list pointer
;		a1 = Display memory pointer
;	out:	a0 = New copper list pointer
;		All registers, with the exception of a0, d0 and d1 will be saved
;	All necessary copper instructions for defining a display of the pre-
;	fered dimensions will be appended to the specified copper list.
;	If Width exceeds 384, the HIRES mode will be activated. If Height
;	exceeds 288 the LACE mode will be activated. Additionally to BPLxPT
;	the following registers are initialized by these copper instructions:
;	BPLxMOD, DIWSTRT, DIWSTOP, DDFSTRT, DDFSTOP, BPLCON0.
;	BPLCON1 and BPLCON2 were already initialized in demoStartup.
;
;  demoBplPtrs
;	in:	a0 = Actual copper list pointer
;		a1 = Display memory pointer
;		d0.w = Depth (1-5)
;		d1 = Plane offset (mode-dependant, e.g. LACE or Interleaved)
;	out:	a0 = New copper list pointer
;		All registers but a0 will be saved!
;	Append copper instructions for bitplane pointer initialization. This
;	routine will be also called by demoStdView.
;
;  demoColors
;	in:	a0 = Actual copper list pointer
;		a1 = Color table (RGB4 UWORDs)
;		d0.w = Number of colors in table (always beginning with COLOR00)
;	out:	a0 = New copper list pointer
;	Transfer colors from a UWORD-table directly to copper list.
;
;=============================================================================


	incdir	"include"
**  You should also define an include path for your Commodore **
** includes or make use of the PHXASSINC environment variable **

	include "lib/exec.i"
	include "lib/graphics.i"

	include "exec/execbase.i"
	include "exec/libraries.i"
	include "dos/dosextens.i"
	include "graphics/gfxbase.i"
	include "hardware/dmabits.i"
	include "hardware/intbits.i"
	include "hardware/custom_all.i"

	IFND	lib_Version
lib_Version	equ	LIB_VERSION
	ENDC


	near	a4,-2			; Small Data __MERGED

	xref	_DATA_BAS_		; symbols will be supplied by PhxLnk
	xref	_DATA_LEN_
	xref	_BSS_LEN_



	code


	xdef	demoStartup
demoStartup:
; -> a4 = Small Data Base
; -> a6 = CUSTOM
	move.l	ExecBase.w,a6
	lea	_DATA_BAS_,a0
	lea	32766(a0),a4		; a4 SmallData Base
	cmp.w	#36,lib_Version(a6)	; OS2.0+ available?
	bhs.s	2$
	add.l	#_DATA_LEN_,a0
	move.l	#_BSS_LEN_,d0
1$:	clr.l	(a0)+			; Initialize BSS area (for Kick 1.x)
	subq.l	#4,d0
	bhi.s	1$
	bra.s	3$
2$:	move.l	#$100,d2
	moveq	#0,d0
	move.l	d2,d1
	jsr	CacheControl(a6)	; disable Data Cache
	and.l	d2,d0
	move.l	d0,oldCache(a4)
3$:	move.l	a6,_SysBase(a4)
	move.l	ThisTask(a6),a2 	; pointer to actual process structure
	move.l	pr_CLI(a2),d0
	bne.s	5$			; Workbench start?
4$:	lea	pr_MsgPort(a2),a0
	jsr	WaitPort(a6)		; get WBStartupMsg
	lea	pr_MsgPort(a2),a0
	jsr	GetMsg(a6)
	move.l	d0,wbStartupMsg(a4)
	beq.s	4$
5$:	sub.l	a0,a0
	btst	#AFB_68010,AttnFlags+1(a6)
	beq.s	6$
	lea	get_VBR(pc),a5
	jsr	Supervisor(a6)		; read and save VBR (68010+)
6$:	move.l	a0,VBReg(a4)
	lea	$64(a0),a0
	lea	autoVecs(a4),a1 	; save Interrupt Autovectors
	moveq	#6-1,d0
7$:	move.l	(a0)+,(a1)+
	dbf	d0,7$
	lea	GfxName(pc),a1
	moveq	#33,d0
	jsr	OpenLibrary(a6) 	; open graphics.library
	move.l	d0,_GfxBase(a4)
	beq	99$			; error?
	move.l	d0,a6
	move.l	gb_ActiView(a6),ActiView(a4)
	sub.l	a1,a1
	jsr	LoadView(a6)		; LoadView(NULL)
	jsr	WaitTOF(a6)
	jsr	WaitTOF(a6)
	jsr	OwnBlitter(a6)		; allocate Blitter
	jsr	WaitBlit(a6)
	moveq	#0,d2			; d2 BEAMCON0 (init PAL or NTSC)
	btst	#PALn,gb_DisplayFlags+1(a6)
	beq.s	8$			; PAL?
	st	PALflag(a4)
	moveq	#$20,d2
8$:	moveq	#%1100,d0
	and.b	gb_ChipRevBits0(a6),d0
	sne	AAflag(a4)		; AGA available?
	lea	CUSTOM,a6
	move.w	DMACONR(a6),d0		; save DMACON and INTENA states
	or.w	#DMAF_SETCLR,d0
	move.w	d0,oldDMACON(a4)
	move.w	INTENAR(a6),d0
	or.w	#INTF_SETCLR|INTF_INTEN,d0
	move.w	d0,oldINTENA(a4)
	movem.l dmaintInit(pc),d0-d1	; turn off DMA channels, CLXCON=0
	movem.l d0-d1,DMACON(a6)	; disable interrupts, clear INTREQ

	move.w	d2,BEAMCON0(a6) 	; *** disable AGA / ECS features ***
	lea	bplconInit(pc),a0
	lea	BPLCON0(a6),a1		; init BPLCON0..4, BPL1MOD, BPL2MOD
	moveq	#7-1,d0
9$:	move.w	(a0)+,(a1)+
	dbf	d0,9$
	lea	SPR0POS(a6),a0		; clear all sprites
	moveq	#16-1,d1
	moveq	#0,d0
10$:	move.l	d0,(a0)+
	dbf	d1,10$
	move.w	d0,FMODE(a6)		; OCS fetch mode
	moveq	#-1,d0
99$:	rts

	machine 68010
get_VBR:
	movec	VBR,a0
	rte
	machine 68000

bplconInit:				; init values for BPLCON0..4, BPL1/2MOD
	dc.w	$0000,$0000,$0024,$0c00,$0000,$0000,$0011
dmaintInit:				; init DMACON,CLXCON,INTENA,INTREQ
	dc.w	$1fff,$0000,$7fff,$7fff
GfxName:
	dc.b	"graphics.library",0
	even


	xdef	demoCleanup
demoCleanup:
	move.l	_GfxBase(a4),d0
	beq	3$
	move.l	d0,a6
	jsr	WaitBlit(a6)
	lea	CUSTOM,a5
	movem.l dmaintInit(pc),d0-d1	; turn off DMA channels, CLXCON=0
	movem.l d0-d1,DMACON(a5)	; disable interrupts, clear INTREQ
	moveq	#0,d0			; zero audio volumes
	move.w	d0,AUD0VOL(a5)
	move.w	d0,AUD1VOL(a5)
	move.w	d0,AUD2VOL(a5)
	move.w	d0,AUD3VOL(a5)
	lea	autoVecs(a4),a0
	move.l	VBReg(a4),a1
	lea	$64(a1),a1
	moveq	#6-1,d0
4$:	move.l	(a0)+,(a1)+		; restore interrupt autovectors
	dbf	d0,4$
	move.w	oldDMACON(a4),DMACON(a5) ; reactivate DMA channels and interrupts
	move.w	oldINTENA(a4),INTENA(a5)
	bclr	#1,$bfe001		; turn on LED/filter
	move.l	ActiView(a4),a1
	jsr	LoadView(a6)		; restore system View
	jsr	DisownBlitter(a6)	; free Blitter
	move.l	gb_copinit(a6),COP1LC(a5) ; restart system copper lists
	move.l	a6,a1
	move.l	_SysBase(a4),a6
	jsr	CloseLibrary(a6)	; close graphics.library
3$:	move.l	_SysBase(a4),a6
	cmp.w	#36,lib_Version(a6)
	blo.s	2$			; OS2.0+ available?
	moveq	#-1,d0
	move.l	oldCache(a4),d1
	jsr	CacheControl(a6)	; enable Data Cache (if required)
2$:	move.l	wbStartupMsg(a4),d0	; WB start? Reply WB message
	beq.s	1$
	move.l	d0,a1
	jsr	Forbid(a6)
	jsr	ReplyMsg(a6)
1$:	moveq	#0,d0			; Finished, return to CLI or Workbench
	rts


	xdef	demoIntVec
	cnop	0,4
demoIntVec:
; d0 = Interrupt Level (1-6)
; a0 = Pointer to interrupt routine
	move.l	VBReg(a4),a1
	add.w	d0,d0
	add.w	d0,d0
	move.l	a0,$60(a1,d0.w) 	; set interrupt autovector
	rts


	xdef	demoStdView
	cnop	0,4
demoStdView:
; d0 = Width.w, d1 = Height.w
; d2 = HStart.w, d3 = VStart.w
; d4 = Depth.w (Bit 3 = Interleaved)
; a0 = Copper List
; a1 = Display Memory
; -> a0 = new Copper List
	movem.l d2-d7,-(sp)
	move.w	#$0200,d6		; d6 BPLCON0 Display Mode
	moveq	#0,d7			; d7 Std Modulo
	move.w	d0,d5
	lsr.w	#3,d5			; d5 calculate bitplane offset
	cmp.w	#384,d0
	blo.s	1$			; Width >= 384 -> HIRES
	lsr.w	#1,d0			;  convert to LoRes-width
	or.w	#$8000,d6
1$:	cmp.w	#288,d1
	blo.s	2$			; Height >= 288 -> LACE
	lsr.w	#1,d1
	addq.w	#4,d6
	move.w	d5,d7			; d7 set Lace Modulo
	bclr	#3,d4			; Lace-Interleaved?
	beq.s	4$
	mulu	d4,d7
	add.l	d7,d7
	bra.s	3$
2$:	bclr	#3,d4			; Interleaved?
	beq.s	4$
	move.w	d5,d7			; d7 set Interleaved Modulo
	mulu	d4,d7
3$:	ext.l	d5
	sub.l	d5,d7
	bra.s	5$

7$:	move.w	d3,d7
	lsl.w	#8,d7
	move.b	d2,d7
6$:	move.w	d0,(a0)+
	move.w	d7,(a0)+
	addq.w	#2,d0
	rts

4$:	mulu	d1,d5
5$:	exg	d4,d0
	exg	d5,d1
	bsr.s	demoBplPtrs		; initialize bitplane pointers
	ror.w	#4,d0
	or.w	d0,d6			; d6 BPLCON0 ready
	move.w	#BPL1MOD,d0
	bsr.s	6$			; initialize modulos
	bsr.s	6$
	move.w	#DIWSTRT,d0
	bsr.s	7$			; init DIWSTRT
	move.w	d2,d1
	add.w	d4,d2
	add.w	d5,d3
	bsr.s	7$			; init DIWSTOP
	moveq	#8,d7
	tst.w	d6			; HIRES?
	bpl.s	8$
	moveq	#4,d7
8$:	lsr.w	#1,d1			; init DDFSTRT
	sub.w	d7,d1
	neg.w	d7
	and.w	d1,d7
	bsr.s	6$
	lsr.w	#1,d4			; init DFFSTOP
	subq.w	#8,d4
	add.w	d4,d7
	bsr.s	6$
	move.w	#BPLCON0,(a0)+		; set BPLCON0 (DispMode, Planes)
	move.w	d6,(a0)+
	movem.l (sp)+,d2-d7
	rts


	xdef	demoBplPtrs
	cnop	0,4
demoBplPtrs:
; d0 = Depth.w
; a0 = Copper List
; a1 = Display Memory
; d1 = Plane Offset
; -> d0, d1, a1 will be saved!
; -> a0 = new Copper List
	movem.l d0-d3,-(sp)
	subq.w	#1,d0
	move.l	a1,d3
	move.w	#BPL1PT,d2
1$:	bsr.s	2$
	bsr.s	2$
	add.l	d1,d3
	dbf	d0,1$
	movem.l (sp)+,d0-d3
	rts
2$:	swap	d3
	move.w	d2,(a0)+
	move.w	d3,(a0)+
	addq.w	#2,d2
	rts


	xdef	demoColors
	cnop	0,4
demoColors:
; d0 = NumColors.w
; a0 = Copper List
; a1 = Color Table
; -> a0 = new Copper List
	subq.w	#1,d0
	move.w	#COLOR00,d1
1$:	move.w	d1,(a0)+
	move.w	(a1)+,(a0)+
	addq.w	#2,d1
	dbf	d0,1$
	rts




	section "__MERGED",bss


	xdef	_SysBase,_GfxBase,PALflag,AAflag

_SysBase:	ds.l 1
_GfxBase:	ds.l 1
oldCache:	ds.l 1
wbStartupMsg:	ds.l 1
VBReg:		ds.l 1
ActiView:	ds.l 1
oldDMACON:	ds.w 1
oldINTENA:	ds.w 1
autoVecs:	ds.l 6
PALflag:	ds.b 1
AAflag: 	ds.b 1

	end
