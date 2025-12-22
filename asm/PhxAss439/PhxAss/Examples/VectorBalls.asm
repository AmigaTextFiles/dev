**
**	V E C T O R B A L L S
**
**	 by Frank Wille 1994
**
**     Assembler: PhxAss V4.xx
**     Linker:	  PhxLnk V4.xx
**


** Imported Functions **

	xref	demoStartup
;		(IN: - / OUT: a4=SmallDataBase,a6=CUSTOM)

	xref	demoCleanup
;		(IN: - / OUT: d0=0)

	xref	demoStdView
;		(IN: d0=Width,d1=Height,d2=HStrt,d3=VStrt,d4=Depth,a0=CList,
;		 a1=DisplayMem / OUT: a0=newCList)

	xref	demoColors
;		(IN: a0=CList,a1=ColorTab,d0=nColors / OUT: a0=CList)




** Includes **

	incdir	"include"
	include "hardware/custom_all.i"
	include "hardware/dmabits.i"
	include "hardware/intbits.i"



** Defines **

WIDTH		= 336			; Bitmap dimensions
HEIGHT		= 128
DEPTH		= 4
BPR		= WIDTH>>3		; Bytes per row
DISPHEIGHT	= 176			; last line of display (bitmap pos.)
HSTART		= $79			; Display start position (beam pos.)
VSTART		= $4c
MIRRSTART	= 90			; first line for reflecting surface
VBWIDTH 	= 16			; Vector Ball dimensions
VBHEIGHT	= 16
SINTABVALS	= 256			; number of entries in sine table
ORGX		= 240			; bitmap position of spatial origin
ORGY		= 80
ORGZ		= 200
NUMOBS		= 52			; number of vector balls

; DblBuf structure
		rsreset
dblbuf_CList	rs.l	1		; copper list and its
dblbuf_Bitmap	rs.l	1		;  bitmap pointer
dblbuf_SIZE	rs

; BobCoords structure
		rsreset
bobc_next	rs.l 1			; MinNode header
bobc_prev	rs.l 1
bobc_x		rs.w 1			; object's 3D coords
bobc_y		rs.w 1
bobc_z		rs.w 1
bobc_reserved	rs.w 1			; longword align
bobc_SIZE	rs



** Macros **

	macro	WAITBLIT
1\@$:	btst	#6,DMACONR(a6)		; wait until blitter ready
	bne.s	1\@$
	endm

LASTLIN set	0
	macro	COPWAIT 		; COPWAIT <line>
	ifge	\1-256			; wait for line >= 256?
	iflt	LASTLIN-256
	move.l	#$ffe1fffe,(a0)+
	endc
	endc
	move.l	#(\1&$ff)<<24|$0ffffe,(a0)+
LASTLIN set	\1
	endm

	macro	COPEND
	move.l	#$fffffffe,(a0)
LASTLIN set	0
	endm



** Code **

	near	a4,-2			; __MERGED Small Data (a4)

	code


	bsr	demoStartup		; -> a4=SmallData Base, a6=CUSTOM
	bsr	make_ytable		; pre-calculate line offsets
	bsr	initCopperLists
	move.w	#$8200|DMAF_RASTER|DMAF_COPPER|DMAF_BLITTER|DMAF_DISK,DMACON(a6)
loop:
	bsr	drawVBalls		; call main routine
1$:	move.w	INTREQR(a6),d0		; wait for copper interrupt, which
	and.w	#INTF_COPER,d0		;  occurs always at end of display
	beq.s	1$
	move.w	toggle(a4),d0		; swap copper lists and bitmaps
	lea	DblBufInfo(a4),a0
	move.l	dblbuf_CList(a0,d0.w),COP1LC(a6)
	eor.w	#dblbuf_SIZE,d0 	; toggle
	move.w	d0,toggle(a4)
	move.l	dblbuf_Bitmap(a0,d0.w),workBitmap(a4)
	btst	#6,$bfe001		; loop until left mouse button pressed
	bne.s	loop
	bra	demoCleanup		; cleanup and quit to CLI or WB


drawVBalls:
	moveq	#1,d0
	ror.l	#8,d0			; $01000000 (use D only, D=0)
	WAITBLIT
	move.w	d0,BLTDMOD(a6)		; use blitter to clear bitmap
	move.l	d0,BLTCON0(a6)
	move.l	workBitmap(a4),BLTDPT(a6)
	move.w	#((DEPTH*HEIGHT)<<6)|(WIDTH>>4),BLTSIZE(a6)

	lea	boblist(a4),a3		; init empty Bob list header -> a3
	move.l	a3,(a3)
	addq.l	#4,(a3)
	move.l	a3,8(a3)
	lea	bobnodes(a4),a2 	; a2 = first Bob node
	lea	SinCosTab(pc),a0	; a0/a1 = Sine/Cosine table
	lea	SINTABVALS/2(a0),a1
	movem.w alpha(a4),d0/d1 	; d0 = alpha, d1 = beta
	move.w	(a0,d0.w),d5		; d5 = MSW: sin(alpha) | LSW: cos(alpha)
	swap	d5
	move.w	(a1,d0.w),d5
	move.w	(a0,d1.w),d6		; d6 = MSW: sin(beta) | LSW: cos(beta)
	swap	d6
	move.w	(a1,d1.w),d6

	moveq	#NUMOBS-1,d7		; *** Coordinate Calculation Loop ***
	lea	vballcoords(pc),a5	; a5 = spatial positions of all VBalls
rotbobs_loop:
	movem.w (a5)+,d0-d1		; d0=x, d1=y, z=0
	move.w	d1,d2
	muls	d5,d1			; * rotate about x-axis *
	swap	d5
	add.l	d1,d1
	clr.w	d1
	swap	d1			; y' = y*cos(alpha) [- z*sin(alpha)]
	muls	d5,d2
	swap	d5
	add.l	d2,d2
	swap	d2			; z' = y*sin(alpha) [+ z*cos(alpha)]
	move.w	d0,d3
	move.w	d1,d4
	muls	d6,d0			; * rotate about y-axis *
	swap	d6
	muls	d6,d4
	add.l	d4,d0
	add.l	d0,d0
	clr.w	d0
	swap	d0			; x' = x*cos(beta) + z*sin(beta)
	muls	d6,d3
	swap	d6
	muls	d6,d2
	sub.l	d3,d2
	add.l	d2,d2
	swap	d2			; z' = -x*sin(beta) + z*cos(beta)
	add.w	#ORGX,d0
	add.w	#ORGY,d1
	add.w	#ORGZ,d2
	move.w	d2,d4			; projection
	add.w	#$100,d4
	beq.s	1$
	lsl.l	#8,d0
	divs	d4,d0
	lsl.l	#8,d1
	divs	d4,d1
1$:	movem.w d0-d2,bobc_x(a2)	; write transformed coords. into node
	move.l	(a3),a1
	bra.s	3$
2$:	cmp.w	bobc_z(a1),d2		; insert into list, sorted by z-coord.
	bge.s	4$
	move.l	d0,a1
3$:	move.l	bobc_next(a1),d0
	bne.s	2$
4$:	move.l	a1,(a2) 		; insert node a2 before node a1
	addq.l	#4,a1
	move.l	(a1),a0
	move.l	a0,4(a2)
	move.l	a2,(a0)
	move.l	a2,(a1)
	lea	bobc_SIZE(a2),a2	; create next Bob node
	dbf	d7,rotbobs_loop

	moveq	#NUMOBS-1,d7		; Bob counter
	move.w	#(DEPTH*VBHEIGHT)<<6|(VBWIDTH+16)>>4,d6  ; d6 = BLTSIZE
	moveq	#15,d5			; d5 = shift mask
	move.l	#%111111001010,d4	; d4 Use ABCD  Minterm: ABC|ABc|aBC|abC
	lea	vballimg,a0			    ; a0 = image pointer
	lea	(VBWIDTH>>3)*VBHEIGHT*DEPTH(a0),a1  ; a1 = mask pointer
	move.l	(a3),d2 		; d2 = first Bob node
	lea	yoffsets(a4),a3 	; a3 = offset table for y-coords
	move.l	workBitmap(a4),a5	; a5 = bitmap pointer
	moveq	#-1,d0
	clr.w	d0			; BLTAFWM/BLTALWM = $ffff0000
	move.l	#(-2<<16)|((WIDTH-VBWIDTH-16)>>3),d1  ; Bob / Bitmap modulos
	WAITBLIT
	move.l	d0,BLTAFWM(a6)
	move.l	d1,BLTAMOD(a6)		; A and D modulo
	swap	d1
	move.l	d1,BLTCMOD(a6)		; C and B modulo
blit_loop:
	move.l	d2,a2
	move.l	bobc_next(a2),d2	; next Bob node
	movem.w bobc_x(a2),d0-d1	; d0 = x, d1 = y
	add.w	d1,d1
	move.w	(a3,d1.w),d1		; fetch line-offset
	lea	(a5,d1.w),a2
	move.w	d0,d1
	lsr.w	#4,d0			; + 2*(x/16)
	add.w	d0,d0
	add.w	d0,a2			; -> a2 destination pointer
	and.w	d5,d1			; x & 15
	ror.w	#4,d1			; A/B shift (moved to bit 15-12)
	move.l	d4,d0
	or.w	d1,d0
	swap	d0
	move.w	d1,d0			; d0 = BLTCON0 | BLTCON1
	WAITBLIT
	move.l	a0,BLTBPT(a6)		; B = Image
	move.l	a1,BLTAPT(a6)		; A = Mask
	move.l	a2,BLTCPT(a6)		; C,D = Destination
	move.l	a2,BLTDPT(a6)
	move.l	d0,BLTCON0(a6)
	move.w	d6,BLTSIZE(a6)		; blit it!
	dbf	d7,blit_loop

	move.w	#(SINTABVALS-1)<<1,d2	; change rotation angles
	movem.w alpha(a4),d0-d1 	; d0 = alpha, d1 = beta
	addq.w	#2,d0
	and.w	d2,d0
	addq.w	#4,d1
	and.w	d2,d1
	movem.w d0-d1,alpha(a4)
	rts


initCopperLists:
	move.w	#$0020,BEAMCON0(a6)	; enable PAL-display (to get more time)
	lea	clist1,a0
	lea	dispmem1,a1
	move.l	a1,workBitmap(a4)	; work with Bitmap #1 first
	movem.l a0-a1,DblBufInfo+dblbuf_CList(a4)  ; save CList and Bitmap poin-
	bsr.s	initCList$			   ;  ters for double buffering
	lea	clist2,a0
	lea	dispmem2,a1
	move.l	a0,COP1LC(a6)		; use copper list #2 first
	tst.w	COPJMP1(a6)
	movem.l a0-a1,DblBufInfo+dblbuf_SIZE+dblbuf_CList(a4)
initCList$:
	move.l	#INTREQ<<16|INTF_COPER,(a0)+ ; reset copper interrupt flag
	move.w	#WIDTH,d0
	move.w	#DISPHEIGHT,d1
	move.w	#HSTART,d2
	moveq	#VSTART,d3
	moveq	#%1000|DEPTH,d4 	; Interleaved bitplanes!
	bsr	demoStdView
	lea	NrmColors(pc),a1
	moveq	#16,d0
	bsr	demoColors		; init all 16 colors at top of frame
	COPWAIT VSTART+MIRRSTART
	move.l	#COLOR00<<16|$313,(a0)+ ; purple mirror surface
	COPWAIT VSTART+MIRRSTART+29
	lea	MirrColors(pc),a1
	moveq	#14,d0
	bsr	demoColors		; reflected colors
	COPWAIT VSTART+MIRRSTART+30
	move.l	#(BPL1MOD<<16)|(((-2*DEPTH-1)*BPR)&$ffff),(a0)+ ; mirror effect
	move.l	#(BPL2MOD<<16)|(((-2*DEPTH-1)*BPR)&$ffff),(a0)+
	COPWAIT VSTART+DISPHEIGHT
	move.l	#INTREQ<<16|$8000|INTF_COPER,(a0)+ ; invoke copper interrupt
	COPEND					   ;  at end of display
	rts


make_ytable:				; calculate an offset for any
	lea	yoffsets(a4),a0 	;  y-coordinate
	moveq	#0,d0
	move.w	#HEIGHT-1,d1
1$:	move.w	d0,(a0)+
	add.w	#BPR*DEPTH,d0
	dbf	d1,1$
	rts


NrmColors:				; normal Demo colors
	dc.w	$000,$aad,$ddf,$88c,$66a,$459,$337,$226
	dc.w	$114,$b8a,$a78,$857,$745,$534,$c22,$114

MirrColors:				; Mirror colors
	dc.w	$313,$988,$988,$869,$758,$646,$435,$324
	dc.w	$114,$756,$645,$534,$423,$423


vballcoords:				; object coordinates
	dc.w	-$b0,-$20,-$a0,-$20,-$90,-$10,-$b0,-$10 		;'P'(8)
	dc.w	-$a0,0,-$b0,0,-$b0,$10,-$b0,$20
	dc.w	-$70,-$20,-$70,-$10,-$70,0,-$70,$10,-$70,$20		;'H'(11)
	dc.w	-$60,0,-$50,-$20,-$50,-$10,-$50,0,-$50,$10,-$50,$20
	dc.w	-$30,-$20,-$30,-$10,-$20,0,-$30,$10,-$30,$20		;'X'(9)
	dc.w	-$10,-$20,-$10,-$10,-$10,$10,-$10,$20
	dc.w	$20,-$20,$10,-$10,$10,0,$10,$10,$10,$20 		;'A'(10)
	dc.w	$20,0,$30,-$10,$30,0,$30,$10,$30,$20
	dc.w	$70,-$20,$60,-$20,$50,-$10,$60,0			;'S'(7)
	dc.w	$70,$10,$60,$20,$50,$20
	dc.w	$b0,-$20,$a0,-$20,$90,-$10,$a0,0			;'S'(7)
	dc.w	$b0,$10,$a0,$20,$90,$20


SinCosTab:				; Sine and Cosine table
twopi	equ.d	6.2831853072
ang	set.d	0
	rept	SINTABVALS+SINTABVALS/4
sinval	int	sin(ang)*32767
	dc.w	sinval
ang	set.d	ang+twopi/SINTABVALS
	endr




	section "__MERGED",bss

boblist:				; (uninitialized) MinList for
	ds.l	3			;  depth-sorted Bob Nodes
bobnodes:
	ds.b	NUMOBS*bobc_SIZE	; all Bob Nodes containing 3d coords
alpha:
	ds.w	1			; rotation about x-axis
beta:
	ds.w	1			; rotation about y-axis
yoffsets:
	ds.w	HEIGHT			; Offset table for any y-coordinate

DblBufInfo:
	ds.l	2*dblbuf_SIZE		; copper list and bitmap pointers
workBitmap:
	ds.l	1			; current Bitmap for drawing objects
toggle:
	ds.w	1			; toggle switch for double buffering




	section "VBallImage",data,chip

vballimg:				; Ball image, interleaved
	incbin	"VBallImage.ilvd"	; size: 16x16x4 (mask appended)




	section "CopperLists",bss,chip

clist1:
	ds.l	2*DEPTH 	; BPLxPT
	ds.l	7		; BPLxMOD,DIWSTRT/STOP,DDFSTRT/STOP,BPLCON0
	ds.l	1<<DEPTH	; COLORxx
	ds.l	28		; mirror colors, mirror effect, etc. - some
				;  extra longwords included :-)

clist2:
	ds.l	2*DEPTH
	ds.l	7
	ds.l	1<<DEPTH
	ds.l	28




	section "DisplayMem_1",bss,chip

dispmem1:
	ds.b	BPR*HEIGHT*DEPTH




	section "DisplayMem_2",bss,chip

dispmem2:
	ds.b	BPR*HEIGHT*DEPTH


	end
