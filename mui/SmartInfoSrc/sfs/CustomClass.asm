*-----------------------------------------------*
*	@Defrag_AskMinMax			*
*-----------------------------------------------*

Defrag_AskMinMax:
	bsr	DoSuperMethod
	move.l	4(a1),a0
	add.w	#120,MMM_MinWidth(a0)
	add.w	#4096,MMM_MaxWidth(a0)
	add.w	#120,MMM_MinHeight(a0)
	add.w	#4096,MMM_MaxHeight(a0)
	add.w	#400,MMM_DefWidth(a0)		; 513
	add.w	#300,MMM_DefHeight(a0)		; 641
	moveq	#0,d0
	rts

*-----------------------------------------------*
*	@Tee_CustomClass			*
*-----------------------------------------------*

Tee_CustomClass:
	move.l	muimaster(a4),a6
	suba.l	a0,a0				; base
	lea	MUIC_Area-t(a5),a1		; supername
	suba.l	a2,a2				; supermcc
	lea	DefragDispatcher(pc),a3
	move.l	#4,d0
	jsr	_LVOMUI_CreateCustomClass(a6)
	move.l	d0,Defrag_mcc(a4)
	rts

*-----------------------------------------------*
*	DefragDispatcher			*
*						*
*	A0	- IClass			*
*	A1	- Msg				*
*	A2	- Object			*
*-----------------------------------------------*

DefragDispatcher:
	move.l	(a1),d0				; MethodID
	cmp.l	#MUIM_Draw,d0
	beq	Defrag_Draw
	cmp.l	#MUIM_Oma_Render,d0
	beq	Defrag_Oma_Render
	cmp.l	#MUIM_Oma_ReDraw,d0
	beq	Defrag_Oma_ReDraw
	cmp.l	#MUIM_AskMinMax,d0
	beq	Defrag_AskMinMax
	cmp.l	#MUIM_Setup,d0
	beq	Defrag_Setup
	cmp.l	#MUIM_Cleanup,0
	beq	Defrag_Cleanup
	bra	DoSuperMethod

*-----------------------------------------------*
*	@Defrag_Draw				*
*-----------------------------------------------*

Defrag_Draw:
	bsr	DoSuperMethod

	movem.l	d1-d7/a0-a6,-(sp)
	lea	t,a5
	move.l	(a5),a4

	tst.b	bfBitMapExists(a4)
	beq.b	.pois

	move.l	4(a1),d0		; flags
	btst.l	#0,d0			; DRAWOBJECT
	bne.b	.draw_object
	btst.l	#1,d0			; DRAWUPDATE
	beq.b	.pois

	move.l	RenderData(a4),d3
	beq	.pois

	clr.l	RenderData(a4)

	bsr	.get_sizes

	move.l	d3,a3
	move.l	gfxbase(a4),a6

	tst.l	lastblocks(a4)
	beq.b	.ohita

.loop	move.l	lastread(a4),d1
	move.l	lastblocks(a4),d2
	moveq	#0,d0
	bsr	render
	move.l	lastwritten(a4),d1
	move.l	lastblocks(a4),d2
	move.w	UsedPen+2(a4),d0	; #1
	bsr	render

.ohita	cmp.l	#'MOVE',(a3)
	bne.b	.pois			; esim. DONE
	cmp.l	#3,4(a3)
	bne.b	.skip

	move.l	12(a3),d1
	move.l	8(a3),d2
	move.w	RemovedPen+2(a4),d0	; #2

	move.l	d1,lastread(a4)
	move.l	d2,lastblocks(a4)

	bsr	render

	move.l	16(a3),d1
	move.l	8(a3),d2
	move.w	NewPen+2(a4),d0		; #3
	move.l	d1,lastwritten(a4)
	bsr	render

	move.l	8(a3),-(sp)
	move.l	16(a3),-(sp)
	move.l	btotal(a4),-(sp)
	bsr	bmclr

	move.l	12(a3),4(sp)
	bsr	bmset
	add.w	#12,sp

.skip	move.l	4(a3),d0
	lea	8(a3,d0.w*4),a3
	tst.l	(a3)
	bne.b	.loop

.pois	movem.l	(sp)+,d1-d7/a0-a6
	moveq	#0,d0
	rts

.draw_object:
	bsr	.get_sizes

	tst.b	bfUpdatePens(a4)
	beq.b	.init

	bsr	VapautaKynät
	bsr	VaraaKynät
	clr.b	bfUpdatePens(a4)

.init	bsr	InitField

	movem.l	(sp)+,d1-d7/a0-a6
	moveq	#0,d0
	rts

.get_sizes:
	lea	MUI_NotifyData_SIZEOF(a2),a0
	move.l	mad_RenderInfo(a0),a1
	move.l	mri_RastPort(a1),MUI_RastPort(a4)

	move.w	mad_Box+ibox_Left(a0),d0
	move.w	mad_Box+ibox_Top(a0),d1
	add.b	mad_addleft(a0),d0
	add.b	mad_addtop(a0),d1
	move.w	d0,MUI_LeftOffset+2(a4)
	move.w	d1,MUI_TopOffset+2(a4)

	move.w	mad_Box+ibox_Width(a0),d0
	move.w	mad_Box+ibox_Height(a0),d1
	sub.b	mad_subwidth(a0),d0
	sub.b	mad_subheight(a0),d1
	move.w	d0,MUI_Width+2(a4)
	move.w	d1,MUI_Height+2(a4)
	rts

*-----------------------------------------------*
*	@Defrag_Oma_ReDraw			*
*-----------------------------------------------*

Defrag_Oma_ReDraw:
	movem.l	d0-d1/a0-a1/a6,-(sp)
	move.l	b+muimaster,a6
	move.l	a2,a0
	move.l	#MADF_DRAWOBJECT,d0
	jsr	_LVOMUI_Redraw(a6)
	movem.l	(sp)+,d0-d1/a0-a1/a6
	rts

*-----------------------------------------------*
*	@Defrag_Oma_Render			*
*-----------------------------------------------*

Defrag_Oma_Render:
	movem.l	d0-d1/a0-a1/a6,-(sp)
	move.l	b+muimaster,a6
	move.l	a2,a0
	move.l	#MADF_DRAWUPDATE,d0
	jsr	_LVOMUI_Redraw(a6)
	movem.l	(sp)+,d0-d1/a0-a1/a6
	rts

*-----------------------------------------------*
*	@DoSuperMethod				*
*-----------------------------------------------*

DoSuperMethod:
	movem.l	a0-a1,-(sp)
	move.l	a2,d0			; be safe (object)
	beq.b	cmreturn
	move.l	a0,d0			; be safe (class)
	beq.b	cmreturn
	move.l	h_SIZEOF+4(a0),a0	; substitute superclass
	pea.l	cmreturn(pc)		; cminvoke
	move.l	h_Entry(a0),-(sp)
	rts
cmreturn:
	movem.l	(sp)+,a0-a1
	rts

*-----------------------------------------------*
*	@render					*
*-----------------------------------------------*
;void render(ULONG block, ULONG blocks, WORD pen)
;		d1		d2	d0

render:	movem.l	d3-d7,-(sp)

	;  ULONG firstunit=block/bpu;
	move.l	d1,d4
	divul.l	bpu(a4),d4
	;  ULONG lastunit=(block+blocks-1)/bpu;
	add.l	d1,d2
	subq.l	#1,d2
	divul.l	bpu(a4),d2

	and.l	#$ffff,d0
	move.l	MUI_RastPort(a4),a1
	jsr	_LVOSetAPen(a6)

	;  line=firstunit / uhor;
	move.l	uhor(a4),d0
	move.l	d4,d3
	divul.l	d0,d3
	;  offset=firstunit % uhor;
	move.l	uhor(a4),d0
	divul.l	d0,d0:d4
	move.l	d0,d4
	;  endline=lastunit / uhor;
	move.l	uhor(a4),d0
	move.l	d2,d1
	divul.l	d0,d1
	move.l	d1,endline(a4)
	;  endoffset=lastunit % uhor;
	move.l	uhor(a4),d0
	divul.l	d0,d0:d2
	move.l	d0,d7
	;  for(;;
L62
	;    if(line==endline) 
	cmp.l	endline(a4),d3
	bne	L67
L63
	;      i=uh;
	move.l	uh(a4),d2
	;      while(i-->0) 
	bra	L65

L64	;	Move(rastport, dx + offset * uw, dy + line * uh + i);
	move.l	MUI_TopOffset(a4),d1
	move.l	uh(a4),d0
	mulu.l	d3,d0
	add.l	d0,d1
	moveq	#0,d0
	move.w	d2,d0
	add.l	d0,d1
	move.l	MUI_LeftOffset(a4),d0
	move.l	uw(a4),d5
	mulu.l	d4,d5
	add.l	d5,d0
	move.l	MUI_RastPort(a4),a1
	jsr	_LVOMove(a6)
	;	Draw(rastport, dx + endoffset * uw + uw-1, dy + line * uh + i);
	move.l	MUI_TopOffset(a4),d1
	move.l	uh(a4),d0
	mulu.l	d3,d0
	add.l	d0,d1
	moveq	#0,d0
	move.w	d2,d0
	add.l	d0,d1
	move.l	MUI_LeftOffset(a4),d0
	move.l	uw(a4),d5
	mulu.l	d7,d5
	add.l	d5,d0
	move.l	uw(a4),d5
	add.l	d5,d0
	subq.l	#1,d0
	move.l	MUI_RastPort(a4),a1
	jsr	_LVODraw(a6)
L65	move.w	d2,d0
	subq.w	#1,d2
	tst.w	d0
	bne	L64
	bra	L72

L67
	;      i=uh;
	move.l	uh(a4),d2
	;      while(i-->0) 
	bra	L69
L68
	;	Move(rastport, dx + offset * uw, dy + line * uh + i);
	move.l	MUI_TopOffset(a4),d1
	move.l	uh(a4),d0
	mulu.l	d3,d0
	add.l	d0,d1
	moveq	#0,d0
	move.w	d2,d0
	add.l	d0,d1
	move.l	MUI_LeftOffset(a4),d0
	move.l	uw(a4),d5
	mulu.l	d4,d5
	add.l	d5,d0
	move.l	MUI_RastPort(a4),a1
	jsr	_LVOMove(a6)
	;	Draw(rastport, dx + (uhor * uw) - 1, dy + line * uh + i);
	move.l	MUI_TopOffset(a4),d1
	move.l	uh(a4),d0
	mulu.l	d3,d0
	add.l	d0,d1
	moveq	#0,d0
	move.w	d2,d0
	add.l	d0,d1
	move.l	MUI_LeftOffset(a4),d0
	move.l	uhor(a4),d5
	mulu.l	uw(a4),d5
	add.l	d5,d0
	subq.l	#1,d0
	move.l	MUI_RastPort(a4),a1
	jsr	_LVODraw(a6)
L69
	move.w	d2,d0
	subq.w	#1,d2
	tst.w	d0
	bne	L68
L70
;    line++;
	addq.l	#1,d3
;    offset=0;
	moveq	#0,d4
L71
	bra	L62
L72
	movem.l	(sp)+,d3-d7
	rts

*-----------------------------------------------*
*	@bfset					*
*-----------------------------------------------*
;ULONG bfset(ULONG data,WORD bitoffset,WORD bits) 

bfset:	movem.l	d2/d3,-(a7)
	move.l	$C(a7),d0
	move.w	$12(a7),d1
	move.w	$10(a7),d2
L102
;  mask=~((1<<(32-bits))-1);
	ext.l	d1
	moveq	#$20,d3
	sub.l	d1,d3
	moveq	#1,d1
	asl.l	d3,d1
	subq.l	#1,d1
	not.l	d1
;  mask>>=bitoffset;
	ext.l	d2
	lsr.l	d2,d1
	or.l	d1,d0
	movem.l	(a7)+,d2/d3
	rts

*-----------------------------------------------*
*	@bfclr					*
*-----------------------------------------------*
;ULONG bfclr(ULONG data,WORD bitoffset,WORD bits) 

bfclr:	movem.l	d2/d3,-(a7)
	move.l	$C(a7),d0
	move.w	$12(a7),d1
	move.w	$10(a7),d2
	;  mask=~((1<<(32-bits))-1);
	ext.l	d1
	moveq	#$20,d3
	sub.l	d1,d3
	moveq	#1,d1
	asl.l	d3,d1
	subq.l	#1,d1
	not.l	d1
	;  mask>>=bitoffset;
	ext.l	d2
	lsr.l	d2,d1
	not.l	d1
	and.l	d1,d0
	movem.l	(a7)+,d2/d3
	rts

*-----------------------------------------------*
*	@bmclr					*
*-----------------------------------------------*
;LONG bmclr(LONG longs,LONG bitoffset,LONG bits) 

bmclr:	movem.l	d2-d5/a2,-(sp)
	move.l	32(sp),d2
	move.l	24(sp),d3
	move.l	28(sp),d4

	move.l	DefragBitMap(a4),a0

	;  ULONG *scan=bitmap;
	move.l	a0,a2
	;  LONG orgbits=bits;
	move.l	d2,d5
	;  longoffset=bitoffset>>5;
	move.l	d4,d0
	asr.l	#5,d0
;  longs-=longoffset;
	sub.l	d0,d3
;  scan+=longoffset;
	asl.l	#2,d0
	add.l	d0,a2
;  bitoffset=bitoffset & 0x1F;
	and.l	#$1F,d4
;  if(bitoffset!=0) 
	beq.b	L114
L105
;    if(bits<32) 
	cmp.l	#32,d2
	bge.b	L107
L106
;      *scan=bfclr(*scan,bitoffset,bits);
	move.w	d2,-(a7)
	move.w	d4,-(a7)
	move.l	(a2),-(a7)
	bsr	bfclr
	addq.w	#$8,a7
	move.l	d0,(a2)
	bra.b	L108
L107
;      *scan=bfclr(*scan,bitoffset,32);
	move.w	#$20,-(a7)
	move.w	d4,-(a7)
	move.l	(a2),-(a7)
	bsr	bfclr
	addq.w	#$8,a7
	move.l	d0,(a2)
L108
;    scan++;
	addq.w	#4,a2
;    longs--;
	subq.l	#1,d3
;    bits-=32-bitoffset;
	moveq	#$20,d0
	sub.l	d4,d0
	sub.l	d0,d2
L109
;  while(bits>0 && longs-->0) 
	bra.b	L114
L110
;    if(bits>31) 
	cmp.l	#$1F,d2
	ble.b	L112
L111
;      *scan++=0;
	clr.l	(a2)+
	bra.b	L113
L112
;      *scan=bfclr(*scan,0,bits);
	move.w	d2,-(a7)
	clr.w	-(a7)
	move.l	(a2),-(a7)
	bsr	bfclr
	addq.w	#8,a7
	move.l	d0,(a2)
L113
;    bits-=32;
	sub.l	#$20,d2
L114
	cmp.l	#0,d2
	ble.b	L116
L115
	move.l	d3,d0
	subq.l	#1,d3
	cmp.l	#0,d0
	bgt.b	L110
L116
;  if(bits<=0) 
	cmp.l	#0,d2
	bgt.b	L118
L117
	move.l	d5,d0
	movem.l	(a7)+,d2-d5/a2
	rts
L118
	move.l	d5,d0
	sub.l	d2,d0
	movem.l	(a7)+,d2-d5/a2
	rts

*-----------------------------------------------*
*	@bmset					*
*-----------------------------------------------*
;LONG bmset(LONG longs,LONG bitoffset,LONG bits) 

bmset:	movem.l	d2-d5/a2,-(a7)
	move.l	32(a7),d2
	move.l	24(a7),d3
	move.l	28(a7),d4

	move.l	DefragBitMap(a4),a0

	;  ULONG *scan=bitmap;
	move.l	a0,a2
;  LONG orgbits=bits;
	move.l	d2,d5
;  longoffset=bitoffset>>5;
	move.l	d4,d0
	asr.l	#5,d0
;  longs-=longoffset;
	sub.l	d0,d3
;  scan+=longoffset;
	asl.l	#2,d0
	add.l	d0,a2
;  bitoffset=bitoffset & 0x1F;
	and.l	#$1F,d4
;  if(bitoffset!=0) 
	beq.b	L129
L120
;    if(bits<32) 
	cmp.l	#$20,d2
	bge.b	L122
L121
;      *scan=bfset(*scan,bitoffset,bits);
	move.w	d2,-(a7)
	move.w	d4,-(a7)
	move.l	(a2),-(a7)
	bsr	bfset
	addq.w	#$8,a7
	move.l	d0,(a2)
	bra.b	L123
L122
;      *scan=bfset(*scan,bitoffset,32);
	move.w	#$20,-(a7)
	move.w	d4,-(a7)
	move.l	(a2),-(a7)
	bsr	bfset
	addq.w	#$8,a7
	move.l	d0,(a2)
L123
;    scan++;
	addq.w	#4,a2
;    longs--;
	subq.l	#1,d3
;    bits-=32-bitoffset;
	moveq	#$20,d0
	sub.l	d4,d0
	sub.l	d0,d2
L124
;  while(bits>0 && longs-->0) 
	bra.b	L129
L125
;    if(bits>31) 
	cmp.l	#$1F,d2
	ble.b	L127
L126
;      *scan++=0xFFFFFFFF;
	move.l	#-1,(a2)+
	bra.b	L128
L127
;      *scan=bfset(*scan,0,bits);
	move.w	d2,-(a7)
	clr.w	-(a7)
	move.l	(a2),-(a7)
	bsr	bfset
	addq.w	#$8,a7
	move.l	d0,(a2)
L128
;    bits-=32;
	sub.l	#$20,d2
L129
	cmp.l	#0,d2
	ble.b	L131
L130
	move.l	d3,d0
	subq.l	#1,d3
	cmp.l	#0,d0
	bgt.b	L125
L131
;  if(bits<=0) 
	cmp.l	#0,d2
	bgt.b	L133
L132
	move.l	d5,d0
	movem.l	(sp)+,d2-d5/a2
	rts
L133
	move.l	d5,d0
	sub.l	d2,d0
	movem.l	(sp)+,d2-d5/a2
	rts

*-----------------------------------------------*
*	@bfffo					*
*-----------------------------------------------*
;WORD bfffo(ULONG data,WORD bitoffset) 

bfffo:	movem.l	d2-d4,-(sp)
	move.w	20(sp),d0
	move.l	16(sp),d3
	;  ULONG bitmask=1<<(31-bitoffset);
	move.w	d0,d1
	ext.l	d1
	moveq	#$1F,d2
	sub.l	d1,d2
	moveq	#1,d1
	asl.l	d2,d1
;  
L75
;    if((data & bitmask)!=0) 
	move.l	d3,d2
	and.l	d1,d2
	beq.b	L77
L76
	movem.l	(sp)+,d2-d4
	rts
L77
;    bitoffset++;
	addq.w	#1,d0
;    bitmask>>=1;
	lsr.l	#1,d1
	tst.l	d1
	bne.b	L75
L78
	moveq	#-1,d0
	movem.l	(sp)+,d2-d4
	rts

*-----------------------------------------------*
*	@bmffo					*
*-----------------------------------------------*
;LONG bmffo(LONG longs,LONG bitoffset) 

bmffo:	movem.l	d2/d3/a2/a3,-(sp)
	move.l	24(sp),d0
	move.l	20(sp),d2
	move.l	DefragBitMap(a4),a3

;  ULONG *scan=bitmap;
;  longoffset=bitoffset>>5;
	move.l	d0,d1
	asr.l	#5,d1
;  longs-=longoffset;
	sub.l	d1,d2
;  scan+=longoffset;
	asl.l	#2,d1
	lea	0(a3,d1.l),a2
;  bitoffset=bitoffset & 0x1F;
	and.l	#$1F,d0
;  if(bitoffset!=0) 
	beq.b	L91
L85
;    if((bit=bfffo(*scan,bitoffset))>=0) 
	move.w	d0,-(sp)
	move.l	(a2),-(sp)
	bsr	bfffo
	addq.w	#6,sp
	tst.w	d0
	bmi.b	L87
L86
	ext.l	d0
	move.l	a2,d1
	sub.l	a3,d1
	asr.l	#2,d1
	asl.l	#5,d1
	add.l	d1,d0
	movem.l	(sp)+,d2/d3/a2/a3
	rts

L87	;    scan++;
	addq.w	#4,a2
	;    longs--;
	subq.l	#1,d2
L88
;  while(longs-->0) 
	bra.b	L91
L89
;    if(*scan++!=0) 
	tst.l	(a2)+
	beq.b	L91
L90
	clr.w	-(sp)
	move.l	-(a2),-(sp)
	bsr	bfffo
	addq.w	#6,sp
	ext.l	d0
	move.l	a2,d1
	sub.l	a3,d1
	asr.l	#2,d1
	asl.l	#5,d1
	add.l	d1,d0
	movem.l	(sp)+,d2/d3/a2/a3
	rts
L91
	move.l	d2,d0
	subq.l	#1,d2
	cmp.l	#0,d0
	bgt.b	L89
L92	;      return
	moveq	#-1,d0
	movem.l	(sp)+,d2/d3/a2/a3
	rts

*-----------------------------------------------*
*	@bmffz					*
*-----------------------------------------------*
;LONG bmffz(LONG longs,LONG bitoffset) 
bmffz	movem.l	d2/d3/a2/a3,-(sp)
	move.l	24(sp),d0		; bitoffset
	move.l	20(sp),d2		; longs
	move.l	DefragBitMap(a4),a3

;  ULONG *scan=bitmap;
;  longoffset=bitoffset>>5;

	move.l	d0,d1
	asr.l	#5,d1
;  longs-=longoffset;
	sub.l	d1,d2
;  scan+=longoffset;
	asl.l	#2,d1
	lea	0(a3,d1.l),a2
;  bitoffset=bitoffset & 0x1F;
	and.l	#$1F,d0
;  if(bitoffset!=0) 
	beq.b	.L100
.L94	;    if((bit=bfffz(*scan,bitoffset))>=0) 
	move.w	d0,-(sp)
	move.l	(a2),-(sp)
	bsr	bfffz
	addq.w	#6,sp
	tst.w	d0
	bmi.b	.L96

.L95	ext.l	d0
	move.l	a2,d1
	sub.l	a3,d1
	asr.l	#2,d1
	asl.l	#5,d1
	add.l	d1,d0
	movem.l	(sp)+,d2/d3/a2/a3
	rts

	;    scan++;
.L96	addq.w	#4,a2
	;    longs--;
	subq.l	#1,d2
.L97	;  while(longs-->0) 
	bra.b	.L100
.L98	;    if(*scan++!=0xFFFFFFFF) 
	move.l	(a2)+,d0
	cmp.l	#-1,d0
	beq.b	.L100

.L99	clr.w	-(sp)
	move.l	-(a2),-(sp)
	bsr	bfffz
	addq.w	#6,sp
	ext.l	d0
	move.l	a2,d1
	sub.l	a3,d1
	asr.l	#2,d1
	asl.l	#5,d1
	add.l	d1,d0
	movem.l	(sp)+,d2/d3/a2/a3
	rts

.L100	move.l	d2,d0
	subq.l	#1,d2
	cmp.l	#0,d0
	bgt.b	.L98

.L101	;      return
	moveq	#-1,d0
	movem.l	(sp)+,d2/d3/a2/a3
	rts

*-----------------------------------------------*
*	@bfffz					*
*-----------------------------------------------*
;WORD bfffz(ULONG data,WORD bitoffset) 

bfffz:	movem.l	d2-d4,-(sp)
	move.w	20(sp),d0
	move.l	16(sp),d3
L79
	;  ULONG bitmask=1<<(31-bitoffset);
	move.w	d0,d1
	ext.l	d1
	moveq	#$1F,d2
	sub.l	d1,d2
	moveq	#1,d1
	asl.l	d2,d1
;  
L80
;    if((data & bitmask)==0) 
	move.l	d3,d2
	and.l	d1,d2
	bne.b	L82
L81
	movem.l	(sp)+,d2-d4
	rts
L82
;    bitoffset++;
	addq.w	#1,d0
;    bitmask>>=1;
	lsr.l	#1,d1
	tst.l	d1
	bne.b	L80
L83
	moveq	#-1,d0
	movem.l	(sp)+,d2-d4
	rts

*-----------------------------------------------*
*	@ReCalc					*
*-----------------------------------------------*

*	D5 - units
*	D6 - uhor
*	D7 - uver

ReCalc:
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#16,d0
	lea	pixw-t(a5),a0
	lea	pixh-t(a5),a1

.loop	move.b	0(a0,d0.w),d3	; uw
	move.b	0(a1,d0.w),d4	; uh
	;    uw    = pixw[i];
	;    uh    = pixh[i];
	move.l	d3,d1
	mulu.w	d4,d1		; uw * uh
	move.l	d1,ppu(a4)

	move.l	MUI_Width(a4),d6
	divsl.l	d3,d6		; w/uw=uhor

	move.l	MUI_Height(a4),d7
	divsl.l	d4,d7		; h/uh=uver

	move.l	d6,d5
	mulu.w	d7,d5		; uhor * uver = units

	move.l	MUI_TotalBlocks(a4),d1
	add.l	d5,d1
	subq.l	#1,d1		; blocks_total+units-1
	divul.l	d5,d1

	cmp.l	#1,d1
	bhi.b	.L54
	bra.b	.L57

.L54	subq.w	#1,d0
	tst.w	d0
	bpl.b	.loop

.L57	;  if(bpu==0) 
	tst.l	d1
	bne.b	.L59
	;    bpu=1;
	move.l	#1,d1
.L59	move.l	d1,bpu(a4)
	move.l	d3,uw(a4)
	move.l	d4,uh(a4)
	move.l	d6,uhor(a4)
	move.l	d7,uver(a4)
	rts

*-----------------------------------------------*
*	@InitField				*
*-----------------------------------------------*

InitField:
	bsr	ReCalc

	;  ULONG current=0;
	moveq	#0,d2
	move.l	MUI_TotalBlocks(a4),d3

	;  while(current<blocks_total)

	move.l	gfxbase(a4),a6
	bra.b	.ohita

*	D2 - current

.loop	;    start=bmffz((blocks_total+31)/32, current);
	move.l	d2,-(sp)
	move.l	btotal(a4),-(sp)
	bsr	bmffz
	move.l	d0,d4			; start

	;    end=bmffo((blocks_total+31)/32, start);
	move.l	d0,4(sp)		; start
	bsr	bmffo
	add.w	#8,sp
	move.l	d0,d2
	;    if(end==-1) 
	addq.l	#1,d0
	bne.b	.jatka			; jos <> -1
	;      end=blocks_total;
	move.l	d3,d2

.jatka	;    render(start, end-start, 1)(d1,d2,d0)
	move.l	d2,d7
	move.w	UsedPen+2(a4),d0	; #1
	sub.l	d4,d2			; end-start
	move.l	d4,d1			; start
	bsr	render
	move.l	d7,d2
	;    current=end;

	;  while(current<blocks_total)
.ohita	cmp.l	d3,d2
	blo.b	.loop
	rts

*-----------------------------------------------*
*	@Defrag_Setup				*
*-----------------------------------------------*

Defrag_Setup:
	bsr	DoSuperMethod
	tst.l	d0
	beq.b	.x
	movem.l	d1-d2/a0-a4/a6,-(sp)
	move.l	#b,a4
	move.l	4(a1),RenderInfo(a4)
	move.l	muimaster(a4),a6
	bsr	VaraaKynät
	movem.l	(sp)+,d1-d2/a0-a4/a6
	move.l	#TRUE,d0
.x	rts

*-----------------------------------------------*
*	@VaraaKynät				*
*-----------------------------------------------*

VaraaKynät:
	lea	PenSpec1(a4),a2
	lea	MyPen(a4),a3

	moveq	#2,d2

.loop	move.l	RenderInfo(a4),a0
	move.l	(a2)+,a1
	moveq	#0,d0
	jsr	_LVOMUI_ObtainPen(a6)
	move.l	d0,(a3)+
	dbf	d2,.loop
	rts

*-----------------------------------------------*
*	@Defrag_Cleanup				*
*-----------------------------------------------*

Defrag_Cleanup:
	movem.l	d1-d2/a0-a2/a4/a6,-(sp)
	move.l	#b,a4
	bsr	VapautaKynät
	movem.l	(sp)+,d1-d2/a0-a2/a4/a6
	bra	DoSuperMethod

*-----------------------------------------------*
*	@VapautaKynät				*
*-----------------------------------------------*

VapautaKynät:
	move.l	muimaster(a4),a6
	moveq	#2,d2
	lea	MyPen(a4),a2

.loop	move.l	RenderInfo(a4),a0
	move.l	(a2)+,d0
	jsr	_LVOMUI_ReleasePen(a6)
	dbf	d2,.loop
	rts
