







;
; TrueColor Display
;
; by Smack/Infect (based on the MultiColour idea by Stefan Kost)
; (use ASM-One V1.25 to assemble)
;
;
; REQUIRES: OS V36+, MC68020+, AGA, FastMem (careful, these are not checked!!)
;
;
; V0.1
; (191095) -read PPM file (marker 'P6'), show on "PAL:Super-High Res Laced"
;          -wait for LMB (hardware style) while showing
;




	include	includes:os_macros.is
CALL	MACRO
	jsr     (_LVO\1,a6)
	ENDM


	section	aaa,code
first_
	basereg	first_,a4
	lea	(first_,pc),a4


;--------------------------------------
; 'open' libs
	move.l	(4.w),a6
	move.l	(378,a6),a0
	lea	(intunam,pc),a1
	CALL	FindName
	move.l	d0,(intuitionbase,a4)
	move.l	(378,a6),a0
	lea	(dosnam,pc),a1
	CALL	FindName
	move.l	d0,(dosbase,a4)
	move.l	d0,a6

;--------------------------------------
; read command line arguments
	lea	(template,pc),a0
	move.l	a0,d1
	lea	(filenamept,pc),a0
	move.l	a0,d2
	moveq	#0,d3
	CALL	ReadArgs
	move.l	d0,(rdargs,a4)
	beq	ende

;--------------------------------------
; open file
	move.l	(filenamept,pc),d1
	move.l	#1005,d2
	CALL	Open
	move.l	d0,(fh,a4)
	ble	ende
	move.l	d0,d1
	move.l	(buffpt,pc),d2
	moveq	#30,d3
	CALL	Read
	tst.l	d0
	ble	ende

;--------------------------------------
; read width and height from file
	move.l	(buffpt,pc),a0
	cmp	#"P6",(a0)+
	bne	ende
	cmp.b	#10,(a0)+
	bne	ende
	moveq	#3,d2
	moveq	#0,d7
	cmp.b	#" ",(4,a0)
	bne.b	.ew1000
	addq	#1,d2
	move.b	(a0)+,d0
	sub.b	#48,d0
	bmi	ende
.w1000	subq.b	#1,d0
	bmi.b	.ew1000
	add	#1000,d7
	bra.b	.w1000
.ew1000	addq	#4,d2
	move.b	(a0)+,d0
	sub.b	#48,d0
	bmi	ende
.w100	subq.b	#1,d0
	bmi.b	.ew100
	add	#100,d7
	bra.b	.w100
.ew100	move.b	(a0)+,d0
	sub.b	#48,d0
	bmi	ende
.w10	subq.b	#1,d0
	bmi.b	.ew10
	add	#10,d7
	bra.b	.w10
.ew10	move.b	(a0)+,d0
	sub.b	#48,d0
	bmi	ende
.w1	subq.b	#1,d0
	bmi.b	.ew1
	addq	#1,d7
	bra.b	.w1
.ew1	move	d7,(picwidth,a4)

	cmp.b	#" ",(a0)+
	bne	ende
	moveq	#0,d7
	cmp.b	#10,(4,a0)
	bne.b	.eh1000
	addq	#1,d2
	move.b	(a0)+,d0
	sub.b	#48,d0
	bmi	ende
.h1000	subq.b	#1,d0
	bmi.b	.eh1000
	add	#1000,d7
	bra.b	.h1000
.eh1000	addq	#4,d2
	move.b	(a0)+,d0
	sub.b	#48,d0
	bmi	ende
.h100	subq.b	#1,d0
	bmi.b	.eh100
	add	#100,d7
	bra.b	.h100
.eh100	move.b	(a0)+,d0
	sub.b	#48,d0
	bmi	ende
.h10	subq.b	#1,d0
	bmi.b	.eh10
	add	#10,d7
	bra.b	.h10
.eh10	move.b	(a0)+,d0
	sub.b	#48,d0
	bmi	ende
.h1	subq.b	#1,d0
	bmi.b	.eh1
	addq	#1,d7
	bra.b	.h1
.eh1	move	d7,(picheight,a4)
	cmp.b	#10,(a0)+
	bne	ende
	cmp.l	#"255"<<8+10,(a0)+
	bne	ende
	addq	#4,d2

	move.l	(fh,pc),d1
	moveq	#-1,d3
	CALL	Seek

;--------------------------------------
; set some variables
	move	(picwidth,pc),d0
	mulu	#3,d0
	move	d0,(picbpr3,a4)
	lsr	d0
	move	d0,(screenwidth,a4)
	move	(picheight,pc),(linecount,a4)
	move	(picwidth,pc),d0
	mulu	#18,d0
	move.l	d0,(loadsize,a4)

;--------------------------------------
; open screen and window
	move	(screenwidth,pc),d0
	add	#63,d0
	and	#-64,d0
	lsr	#3,d0
	move	d0,(bmap,a4)
	move	(picheight,pc),d1
	move	d1,(bmap+2,a4)
	move	#8,(bmap+4,a4)
	mulu	d1,d0
	move.l	d0,(screenplsz,a4)
	lsl.l	#3,d0
	move.l	#$10002,d1
	CALLEXEC AllocMem
	move.l	d0,(chipaddr,a4)
	beq	ende

	move.l	(screenplsz,pc),d1
	lea	(bmap+8,pc),a0
	moveq	#7,d7
.bmapll	move.l	d0,(a0)+
	add.l	d1,d0
	dbf	d7,.bmapll

	lea	(newscreen,pc),a0
	move	(screenwidth,pc),(4,a0)
	move	(picheight,pc),(6,a0)
	lea	(screentaglist,pc),a1
	CALLINT	OpenScreenTagList
	move.l	d0,(screen,a4)
	beq	ende

	lea	(newwindow,pc),a0
	move.l	(screen,pc),(30,a0)
	CALL	OpenWindow
	move.l	d0,(window,a4)
	beq	ende

	lea	(chunkytab,pc),a0
	moveq	#0,d1
	move	(bmap,pc),d1
	lsl	#3,d1
	lea	(chunkybuffer),a1
	moveq	#5,d7
.ctll	move.l	a1,(a0)+
	add.l	d1,a1
	dbf	d7,.ctll



	endb	a4




mainloop
	btst	#6,$bfe001
	beq	ende
	subq	#6,(linecount)
	blt	www

	move.l	(fh,pc),d1
	move.l	(buffpt,pc),d2
	move.l	(loadsize,pc),d3
	CALLDOS	Read
	tst.l	d0
	bmi	ende

;-------------------------------------
; step 1: 24bit to 8bit chunky - 6 rows at a time
	lea	(rtab+1,pc),a4
	lea	(gtab+1,pc),a5
	lea	(btab+1,pc),a6
	move.l	(buffpt,pc),a0
	lea	(chunkytab,pc),a3
	moveq	#0,d5
	move	(picbpr3,pc),d5
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2

	movem.l	(a3)+,a1/a2
	move	(picwidth,pc),d7
	subq	#1,d7
	move	d7,d4
.loop0	move.b	(a0)+,d0
	move.b	(a0)+,d1
	move.b	(a0)+,d2
	move.b	(a5,d1.l*2),(a1)+
	move.b	(a4,d0.l*2),(a2)+
	move.b	(a6,d2.l*2),(a1)+
	dbf	d7,.on0
	bra.b	.end0
.on0	move.b	(a0)+,d0
	move.b	(a0)+,d1
	move.b	(a0)+,d2
	move.b	(a5,d1.l*2),(a2)+
	move.b	(a4,d0.l*2),(a1)+
	move.b	(a6,d2.l*2),(a2)+
	dbf	d7,.loop0
.end0	lea	(a0,d5.l),a0

	movem.l	(a3)+,a1/a2
	move	d4,d7
.loop1	move.b	(a0)+,d0
	move.b	(a0)+,d1
	move.b	(a0)+,d2
	move.b	(a4,d0.l*2),(a1)+
	move.b	(a6,d2.l*2),(a2)+
	move.b	(a5,d1.l*2),(a1)+
	dbf	d7,.on1
	bra.b	.end1
.on1	move.b	(a0)+,d0
	move.b	(a0)+,d1
	move.b	(a0)+,d2
	move.b	(a4,d0.l*2),(a2)+
	move.b	(a6,d2.l*2),(a1)+
	move.b	(a5,d1.l*2),(a2)+
	dbf	d7,.loop1
.end1	lea	(a0,d5.l),a0

	movem.l	(a3)+,a1/a2
	move	d4,d7
.loop2	move.b	(a0)+,d0
	move.b	(a0)+,d1
	move.b	(a0)+,d2
	move.b	(a6,d2.l*2),(a1)+
	move.b	(a5,d1.l*2),(a2)+
	move.b	(a4,d0.l*2),(a1)+
	dbf	d7,.on2
	bra.b	.end2
.on2	move.b	(a0)+,d0
	move.b	(a0)+,d1
	move.b	(a0)+,d2
	move.b	(a6,d2.l*2),(a2)+
	move.b	(a5,d1.l*2),(a1)+
	move.b	(a4,d0.l*2),(a2)+
	dbf	d7,.loop2
.end2

;-------------------------------------
; step 2: 8bit chunky to planar
	move.l	(chunkytab,pc),a0
	move.l	(offsetplanes,pc),d1
	move.l	(chipaddr,pc),a1
	lea	(a1,d1.l),a1
	move	(bmap,pc),d0
	mulu	#6,d0
	lea	(a1,d0.l),a5
	add.l	d0,d1
	move.l	d1,(offsetplanes)
	move.l	(screenplsz,pc),a6
	lea	(a1,a6.l),a2
	lea	(a2,a6.l*4),a3
	lea	(a3,a6.l),a3
	move.l	#$0f0f0f0f,d5
	move.l	#$55555555,d6
	move.l	#$3333cccc,d7
.loop
	lea	(chunkytmp,pc),a4
	REPT	4
	movem.l	(a0)+,d0/d1
	move.l	d0,d2
	and.l	d5,d2
	eor.l	d2,d0
	lsl.l	#4,d2
	move.l	d1,d3
	and.l	d5,d3
	eor.l	d3,d1
	lsr.l	#4,d1
	or.l	d3,d2
	or.l	d1,d0
	move.l	d2,d3
	and.l	d7,d3
	move	d3,d1
	clr	d3
	lsl.l	#2,d3
	lsr	#2,d1
	or	d1,d3
	swap	d2
	and.l	d7,d2
	or.l	d2,d3
	move.l	d0,d1
	and.l	d7,d1
	move	d1,d2
	clr	d1
	lsl.l	#2,d1
	lsr	#2,d2
	or	d2,d1
	swap	d0
	and.l	d7,d0
	or.l	d0,d1
	move.l	d1,d2
	lsr.l	#7,d2
	move.l	d1,d0
	and.l	d6,d0
	eor.l	d0,d1
	move.l	d2,d4
	and.l	d6,d4
	eor.l	d4,d2
	or.l	d4,d1
	lsr.l	d1
	move.b	d1,(7*4,a4)	plane 7
	swap	d1
	move.b	d1,(5*4,a4)	plane 5
	or.l	d0,d2
	move.b	d2,(6*4,a4)	plane 6
	swap	d2
	move.b	d2,(4*4,a4)	plane 4
	move.l	d3,d2
	lsr.l	#7,d2
	move.l	d3,d0
	and.l	d6,d0
	eor.l	d0,d3
	move.l	d2,d4
	and.l	d6,d4
	eor.l	d4,d2
	or.l	d4,d3
	lsr.l	d3
	move.b	d3,(3*4,a4)	plane 3
	swap	d3
	move.b	d3,(1*4,a4)	plane 1
	or.l	d0,d2
	move.b	d2,(2*4,a4)	plane 2
	swap	d2
	move.b	d2,(a4)+	plane 0
	ENDR

	lea	(6*4,a4),a4
	move.l	(a4),(a3,a6.l)
	move.l	-(a4),(a3)+
	move.l	-(a4),(a2,a6.l*4)
	move.l	-(a4),(a1,a6.l*4)
	move.l	-(a4),(a2,a6.l*2)
	move.l	-(a4),(a1,a6.l*2)
	move.l	-(a4),(a2)+
	move.l	-(a4),(a1)+

	cmpa.l	a1,a5
	bne	.loop

	bra	mainloop



;--------------------------------------
; wait for user
www
	moveq	#1,d1
	CALLDOS	Delay
	btst	#6,$bfe001
	bne.b	www


;--------------------------------------
; free resources and exit
ende
	move.l	(rdargs,pc),d1
	CALLDOS	FreeArgs
	move.l	(fh,pc),d1
	ble.b	.nofile
	CALL	Close
.nofile
	move.l	(window,pc),d0
	beq.b	.nowin
	move.l	d0,a0
	CALLINT	CloseWindow
.nowin
	move.l	(screen,pc),d0
	beq.b	.noscr
	move.l	d0,a0
	CALLINT	CloseScreen
.noscr
	move.l	(chipaddr,pc),d0
	beq.b	.nocmem
	move.l	d0,a1
	move.l	(screenplsz,pc),d0
	lsl.l	#3,d0
	CALLEXEC FreeMem
.nocmem


	moveq	#0,d0
	rts








;--------------------------------------
; data area

dosnam	dc.b	"dos.library",0
intunam	dc.b	"intuition.library",0
dosbase		dc.l	0
intuitionbase	dc.l	0
offsetplanes	dc.l	0
rdargs		dc.l	0
template	dc.b	"PPMFILE/A",0
filenamept	dc.l	0
fh		dc.l	0
loadsize	dc.l	0
chipaddr	dc.l	0

picwidth	dc	0
picheight	dc	0

picbpr3		dc	0
linecount	dc	0
screenwidth	dc	0
screenplsz	dc.l	0
chunkytab	ds.l	6
chunkytmp	ds.l	8

window		dc.l	0
newwindow
	dc	0,0	;leftedge, topedge
	dc	32,32	;width, height
	dc.b	0,1	;detailpen, blockpen
	dc.l	0	;IDCMP flags
	dc.l	$31900	;window flags
	dc.l	0,0	;firstgadget, checkmark
	dc.l	0	;title
	dc.l	0,0	;screen, bitmap
	dc	0,0,0,0	;min, max width, height
	dc	$f	;screen type


screen		dc.l	0
newscreen
	dc	0,0	;leftedge, topedge
	dc	0,0	;width, height
	dc	8	;depth
	dc.b	0,1	;detailpen, blockpen
	dc	$8024	;viewmodes
	dc	$414f	;type
	dc.l	0,stitle,0	;textattr, title, gadgets
	dc.l	bmap	;custombitmap
screentaglist
	dc.l	$80000032,$8024		;SA_DisplayID
	dc.l	$80000043,palette	;SA_Colors32
	dc.l	$80000034,3		;SA_Overscan (OSCAN_MAX)
	dc.l	0,0
stitle	dc.b	"TruView_Screen",0,0
bmap	ds.l	16
palette	dc.l	$01000000,$00000000,$00000000,$00000000,$03000000,$00000000
	dc.l	$00000000,$06000000,$00000000,$00000000,$09000000,$00000000
	dc.l	$00000000,$0C000000,$00000000,$00000000,$0F000000,$00000000
	dc.l	$00000000,$12000000,$00000000,$00000000,$15000000,$00000000
	dc.l	$00000000,$18000000,$00000000,$00000000,$1B000000,$00000000
	dc.l	$00000000,$1E000000,$00000000,$00000000,$21000000,$00000000
	dc.l	$00000000,$24000000,$00000000,$00000000,$27000000,$00000000
	dc.l	$00000000,$2A000000,$00000000,$00000000,$2E000000,$00000000
	dc.l	$00000000,$31000000,$00000000,$00000000,$34000000,$00000000
	dc.l	$00000000,$37000000,$00000000,$00000000,$3A000000,$00000000
	dc.l	$00000000,$3D000000,$00000000,$00000000,$40000000,$00000000
	dc.l	$00000000,$43000000,$00000000,$00000000,$46000000,$00000000
	dc.l	$00000000,$49000000,$00000000,$00000000,$4C000000,$00000000
	dc.l	$00000000,$4F000000,$00000000,$00000000,$52000000,$00000000
	dc.l	$00000000,$55000000,$00000000,$00000000,$58000000,$00000000
	dc.l	$00000000,$5B000000,$00000000,$00000000,$5E000000,$00000000
	dc.l	$00000000,$61000000,$00000000,$00000000,$64000000,$00000000
	dc.l	$00000000,$67000000,$00000000,$00000000,$6A000000,$00000000
	dc.l	$00000000,$6D000000,$00000000,$00000000,$70000000,$00000000
	dc.l	$00000000,$73000000,$00000000,$00000000,$76000000,$00000000
	dc.l	$00000000,$79000000,$00000000,$00000000,$7C000000,$00000000
	dc.l	$00000000,$7F000000,$00000000,$00000000,$82000000,$00000000
	dc.l	$00000000,$85000000,$00000000,$00000000,$88000000,$00000000
	dc.l	$00000000,$8B000000,$00000000,$00000000,$8E000000,$00000000
	dc.l	$00000000,$91000000,$00000000,$00000000,$94000000,$00000000
	dc.l	$00000000,$97000000,$00000000,$00000000,$9A000000,$00000000
	dc.l	$00000000,$9D000000,$00000000,$00000000,$A0000000,$00000000
	dc.l	$00000000,$A3000000,$00000000,$00000000,$A6000000,$00000000
	dc.l	$00000000,$A9000000,$00000000,$00000000,$AC000000,$00000000
	dc.l	$00000000,$AF000000,$00000000,$00000000,$B2000000,$00000000
	dc.l	$00000000,$B5000000,$00000000,$00000000,$B8000000,$00000000
	dc.l	$00000000,$BB000000,$00000000,$00000000,$BE000000,$00000000
	dc.l	$00000000,$C1000000,$00000000,$00000000,$C4000000,$00000000
	dc.l	$00000000,$C7000000,$00000000,$00000000,$CA000000,$00000000
	dc.l	$00000000,$CD000000,$00000000,$00000000,$D0000000,$00000000
	dc.l	$00000000,$D3000000,$00000000,$00000000,$D7000000,$00000000
	dc.l	$00000000,$DA000000,$00000000,$00000000,$DD000000,$00000000
	dc.l	$00000000,$E0000000,$00000000,$00000000,$E3000000,$00000000
	dc.l	$00000000,$E6000000,$00000000,$00000000,$E9000000,$00000000
	dc.l	$00000000,$EC000000,$00000000,$00000000,$EF000000,$00000000
	dc.l	$00000000,$F2000000,$00000000,$00000000,$F5000000,$00000000
	dc.l	$00000000,$F8000000,$00000000,$00000000,$FB000000,$00000000
	dc.l	$00000000,$FF000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00000000,$03000000,$00000000,$00000000,$06000000
	dc.l	$00000000,$00000000,$09000000,$00000000,$00000000,$0C000000
	dc.l	$00000000,$00000000,$0F000000,$00000000,$00000000,$12000000
	dc.l	$00000000,$00000000,$15000000,$00000000,$00000000,$18000000
	dc.l	$00000000,$00000000,$1B000000,$00000000,$00000000,$1E000000
	dc.l	$00000000,$00000000,$21000000,$00000000,$00000000,$24000000
	dc.l	$00000000,$00000000,$27000000,$00000000,$00000000,$2A000000
	dc.l	$00000000,$00000000,$2E000000,$00000000,$00000000,$31000000
	dc.l	$00000000,$00000000,$34000000,$00000000,$00000000,$37000000
	dc.l	$00000000,$00000000,$3A000000,$00000000,$00000000,$3D000000
	dc.l	$00000000,$00000000,$40000000,$00000000,$00000000,$43000000
	dc.l	$00000000,$00000000,$46000000,$00000000,$00000000,$49000000
	dc.l	$00000000,$00000000,$4C000000,$00000000,$00000000,$4F000000
	dc.l	$00000000,$00000000,$52000000,$00000000,$00000000,$55000000
	dc.l	$00000000,$00000000,$58000000,$00000000,$00000000,$5B000000
	dc.l	$00000000,$00000000,$5E000000,$00000000,$00000000,$61000000
	dc.l	$00000000,$00000000,$64000000,$00000000,$00000000,$67000000
	dc.l	$00000000,$00000000,$6A000000,$00000000,$00000000,$6D000000
	dc.l	$00000000,$00000000,$70000000,$00000000,$00000000,$73000000
	dc.l	$00000000,$00000000,$76000000,$00000000,$00000000,$79000000
	dc.l	$00000000,$00000000,$7C000000,$00000000,$00000000,$7F000000
	dc.l	$00000000,$00000000,$82000000,$00000000,$00000000,$85000000
	dc.l	$00000000,$00000000,$88000000,$00000000,$00000000,$8B000000
	dc.l	$00000000,$00000000,$8E000000,$00000000,$00000000,$91000000
	dc.l	$00000000,$00000000,$94000000,$00000000,$00000000,$97000000
	dc.l	$00000000,$00000000,$9A000000,$00000000,$00000000,$9D000000
	dc.l	$00000000,$00000000,$A0000000,$00000000,$00000000,$A3000000
	dc.l	$00000000,$00000000,$A6000000,$00000000,$00000000,$A9000000
	dc.l	$00000000,$00000000,$AC000000,$00000000,$00000000,$AF000000
	dc.l	$00000000,$00000000,$B2000000,$00000000,$00000000,$B5000000
	dc.l	$00000000,$00000000,$B8000000,$00000000,$00000000,$BB000000
	dc.l	$00000000,$00000000,$BE000000,$00000000,$00000000,$C1000000
	dc.l	$00000000,$00000000,$C4000000,$00000000,$00000000,$C7000000
	dc.l	$00000000,$00000000,$CA000000,$00000000,$00000000,$CD000000
	dc.l	$00000000,$00000000,$D0000000,$00000000,$00000000,$D3000000
	dc.l	$00000000,$00000000,$D7000000,$00000000,$00000000,$DA000000
	dc.l	$00000000,$00000000,$DD000000,$00000000,$00000000,$E0000000
	dc.l	$00000000,$00000000,$E3000000,$00000000,$00000000,$E6000000
	dc.l	$00000000,$00000000,$E9000000,$00000000,$00000000,$EC000000
	dc.l	$00000000,$00000000,$EF000000,$00000000,$00000000,$F2000000
	dc.l	$00000000,$00000000,$F5000000,$00000000,$00000000,$F8000000
	dc.l	$00000000,$00000000,$FB000000,$00000000,$00000000,$FF000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$03000000,$00000000,$00000000,$06000000,$00000000,$00000000
	dc.l	$09000000,$00000000,$00000000,$0C000000,$00000000,$00000000
	dc.l	$0F000000,$00000000,$00000000,$12000000,$00000000,$00000000
	dc.l	$15000000,$00000000,$00000000,$18000000,$00000000,$00000000
	dc.l	$1B000000,$00000000,$00000000,$1E000000,$00000000,$00000000
	dc.l	$21000000,$00000000,$00000000,$24000000,$00000000,$00000000
	dc.l	$27000000,$00000000,$00000000,$2A000000,$00000000,$00000000
	dc.l	$2E000000,$00000000,$00000000,$31000000,$00000000,$00000000
	dc.l	$34000000,$00000000,$00000000,$37000000,$00000000,$00000000
	dc.l	$3A000000,$00000000,$00000000,$3D000000,$00000000,$00000000
	dc.l	$40000000,$00000000,$00000000,$43000000,$00000000,$00000000
	dc.l	$46000000,$00000000,$00000000,$49000000,$00000000,$00000000
	dc.l	$4C000000,$00000000,$00000000,$4F000000,$00000000,$00000000
	dc.l	$52000000,$00000000,$00000000,$55000000,$00000000,$00000000
	dc.l	$58000000,$00000000,$00000000,$5B000000,$00000000,$00000000
	dc.l	$5E000000,$00000000,$00000000,$61000000,$00000000,$00000000
	dc.l	$64000000,$00000000,$00000000,$67000000,$00000000,$00000000
	dc.l	$6A000000,$00000000,$00000000,$6D000000,$00000000,$00000000
	dc.l	$70000000,$00000000,$00000000,$73000000,$00000000,$00000000
	dc.l	$76000000,$00000000,$00000000,$79000000,$00000000,$00000000
	dc.l	$7C000000,$00000000,$00000000,$7F000000,$00000000,$00000000
	dc.l	$82000000,$00000000,$00000000,$85000000,$00000000,$00000000
	dc.l	$88000000,$00000000,$00000000,$8B000000,$00000000,$00000000
	dc.l	$8E000000,$00000000,$00000000,$91000000,$00000000,$00000000
	dc.l	$94000000,$00000000,$00000000,$97000000,$00000000,$00000000
	dc.l	$9A000000,$00000000,$00000000,$9D000000,$00000000,$00000000
	dc.l	$A0000000,$00000000,$00000000,$A3000000,$00000000,$00000000
	dc.l	$A6000000,$00000000,$00000000,$A9000000,$00000000,$00000000
	dc.l	$AC000000,$00000000,$00000000,$AF000000,$00000000,$00000000
	dc.l	$B2000000,$00000000,$00000000,$B5000000,$00000000,$00000000
	dc.l	$B8000000,$00000000,$00000000,$BB000000,$00000000,$00000000
	dc.l	$BE000000,$00000000,$00000000,$C1000000,$00000000,$00000000
	dc.l	$C4000000,$00000000,$00000000,$C7000000,$00000000,$00000000
	dc.l	$CA000000,$00000000,$00000000,$CD000000,$00000000,$00000000
	dc.l	$D0000000,$00000000,$00000000,$D3000000,$00000000,$00000000
	dc.l	$D7000000,$00000000,$00000000,$DA000000,$00000000,$00000000
	dc.l	$DD000000,$00000000,$00000000,$E0000000,$00000000,$00000000
	dc.l	$E3000000,$00000000,$00000000,$E6000000,$00000000,$00000000
	dc.l	$E9000000,$00000000,$00000000,$EC000000,$00000000,$00000000
	dc.l	$EF000000,$00000000,$00000000,$F2000000,$00000000,$00000000
	dc.l	$F5000000,$00000000,$00000000,$F8000000,$00000000,$00000000
	dc.l	$FB000000,$00000000,$00000000,$FF000000,$FF000000,$FF000000
	dc.l	$FF000000,$00000000


rtab
i set 0
	rept	254
i set i+1
	dc	i/3
	endr
	dc	84,84
gtab
i set 0
	rept	254
i set i+1
	dc	i/3+85
	endr
	dc	169,169
btab
i set 0
	rept	254
i set i+1
	dc	i/3+170
	endr
	dc	254,254

buffpt		dc.l	loadbuffer


	section	bbbb,bss
chunkybuffer	ds.b	70*1024
loadbuffer	ds.b	50*1024
