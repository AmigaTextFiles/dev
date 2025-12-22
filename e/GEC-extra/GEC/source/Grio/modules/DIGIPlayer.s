
	XDEF    digiPlay_module

digiPlay_module
	move.l 4(a7),ModDIGI
	beq.s	.q
	movem.l	d3-d7/a4/a5,-(a7)
	bsr.w   db_Init
	tst.l	d0
	beq.s	.err
	bsr.w   PlugCIA
	tst.l	d0
	beq.s	.err
	moveq	#-1,d0
	bra.s	.ok
.err	bsr	db_end
.ok	lea	Enabled(pc),a0
	move.b	d0,(a0)
	lea	Ended(pc),a0
	move.b	d0,(a0)
	not.b	(a0)
	movem.l	(a7)+,d3-d7/a4/a5
.q	rts




	XDEF    digiStop

digiStop
	move.l	a5,-(a7)
	bsr.w   UnPlugCIA
	move.l	(a7)+,a5
	bsr.w   db_end	
	rts
	


	XDEF    digiGetSongLen

digiGetSongLen
	moveq	#0,d0
	movea.l	ModDIGI(pc),a0
	move.b	OrdNum(a0),d0
	rts



	XDEF    digiGetSongPos

digiGetSongPos
	moveq   #0,d0
	move.b  SongPos(pc),d0
	rts



	XDEF    digiSetSongPos_value

digiSetSongPos_value
	move.l  ModDIGI(pc),a0
	moveq   #0,d0
	move.b  OrdNum(a0),d0
	subq.b  #1,d0
	move.l  4(a7),d1
	cmp.l   d1,d0
	bhs.s   .okval
	moveq   #-1,d0
	rts
.okval
	lea     SongPos(pc),a0
	move.b  (a0),d0
	move.b  d1,(a0)
	rts




	XDEF    digiPause

digiPause
	lea	$dff000,a0
	move.w	#$f,$96(a0)
	clr.w	$a8(a0)
	clr.w	$b8(a0)
	clr.w	$c8(a0)
	clr.w	$d8(a0)
	moveq	#0,d0
	lea     Enabled(pc),a0
	tst.b   (a0)
	bne.s   qpause
	moveq	#-1,d0
qpause
	move.b	d0,(a0)
	rts

	


	XDEF    digiIsEnabled

digiIsEnabled
	moveq   #0,d0
	move.b	Enabled(pc),d0
	beq.s   .no
	moveq   #-1,d0
.no
	rts



	XDEF    digiSetVolume_value

digiSetVolume_value
	move.l  4(a7),d0
	cmp.l   #64,d0
	bls.s   ok_vol
	moveq   #64,d0
ok_vol
	lea     MasterVol(pc),a0
	move.w  d0,(a0)
	lea     $dff0a8,a1
	lea     Channel1(pc),a0
	bsr.s   calcvol
	lea     Channel2(pc),a0
	lea     $10(a1),a1
	bsr.s   calcvol
	lea     Channel3(pc),a0
	lea     $10(a1),a1
	bsr.s   calcvol
	lea     Channel4(pc),a0
	lea     $10(a1),a1

calcvol
	moveq   #0,d1
	move.b  MainVol(a0),d1
	mulu.w  d0,d1
	lsr.w   #6,d1
	move.w  d1,(a1)
	rts



	XDEF    digiGetVolume_channel
	
digiGetVolume_channel
	moveq   #0,d0
	move.l  4(a7),d1
	bne.s   .skip
	move.w  MasterVol(pc),d0
	rts
.skip:
	moveq   #4,d0
	cmp.l   d0,d1
	bls.s   .okidoki
	moveq   #-1,d0
	rts
.okidoki:
	subq.l  #1,d1
	mulu.w  #ChanArea,d1
	lea     Channel1(pc),a0
	move.b  MainVol(a0,d1.w),d0
	rts




	XDEF    digiSetPattPos_value

digiSetPattPos_value
	move.l  4(a7),d0
	moveq   #64,d1
	cmp.l   d1,d0
	bls.s   .ok
	move.l  d1,d0
.ok	lea     PattPos(pc),a0
	move.b  d0,(a0)
	rts



	XDEF    digiGetPattPos

digiGetPattPos
	moveq   #0,d0
	move.b  PattPos(pc),d0
	rts




	XDEF    digiGetSampleInfo_module_buf4name_samplenum
	
digiGetSampleInfo_module_buf4name_samplenum
	moveq   #-1,d0
	move.l  4(a7),d2
	beq.s   .quit
	moveq   #31,d1
	cmp.l   d1,d2
	bhi.s   .quit
	movea.l 12(a7),a0  ; module
	subq.l  #1,d2
	move.l	d2,d1
	beq.s   .copy
	mulu.w  #30,d2
.copy
	lsl.w	#2,d1
	add.w	#SamLens,d1
	move.l  0(a0,d1.w),d0
	add.w	#SamNames,d2
	lea     0(a0,d2.w),a0
	moveq   #29,d1
	movea.l 8(a7),a1
.loop
	move.b  (a0)+,d2
	beq.s   .ok
	cmp.b   #32,d2
	bhs.s   .ok
	moveq   #32,d2
.ok
	move.b  d2,(a1)+
	dbeq    d1,.loop
	clr.b   (a1)
.quit:
	rts
	



	XDEF    digiGetNote_channel

digiGetNote_channel:
	move.l  4(a7),d0
	beq.s   .quit
	moveq   #4,d1
	cmp.l   d1,d0
	bhi.s   .quit
	move.l	d0,d1
	subq.w  #1,d1
	lsl.w	#3,d1
	move.l	WorkPTR(pc),a0
	lea	UnPackedData(a0),a0
	move.w	0(a0,d1.w),d0		; xA
	swap	d0
	move.w	4(a0,d1.w),d0		; xB
	rts
.quit:
	moveq   #0,d0
	rts




	XDEF    digiGetCmd_channel

digiGetCmd_channel:
	move.l  4(a7),d0
	beq.s   .quit
	moveq   #4,d1
	cmp.l   d1,d0
	bhi.s   .quit
	move.l	d0,d1
	subq.w  #1,d1
	lsl.w	#3,d1
	move.l	WorkPTR(pc),a0
	lea	UnPackedData(a0),a0
	move.w	2(a0,d1.w),d0		; xA
	swap	d0
	move.w	6(a0,d1.w),d0		; xB
	rts
.quit:
	moveq   #0,d0
	rts

	


	XDEF	digiLoopPlay_val
	
digiLoopPlay_val:
	move.l	4(a7),d1
	beq.s	.Set
	moveq	#-1,d1
.Set
	bsr.s	digiIsLooped
	lea	Looped(pc),a0
	move.b	d1,(a0)
	rts
	




	XDEF	digiIsLooped

digiIsLooped:
	move.b	Looped(pc),d0
	ext.w	d0
	ext.l	d0
	rts




	XDEF	digiIsEnded

digiIsEnded:
	move.b	Ended(pc),d0
	ext.w	d0
	ext.l	d0
	rts






;----------------- DIGI Booster By Tap & Walt ----------------
;		     player v 1.6 pure code
;		     by Tap - Tomasz Piasta
;			  © 14.06.1996
;
; This player is very easy to use. If you want to play only the VBL modules
; (with cia tempo 125) you can do this:
; - first jump to db_init
; - in your own loop jump to db_music
; - to switch off player jump to db_end
;
; But if you have CIA modules you must use CIA interrupt...
;
; The player plays modules from Digi Booster 1.0-1.6 with packed
; and unpacked pattern data. Eight channels modules take about 0.25 frame
; (on standard Amiga 1200). The player automticly recognize
; processor (old Motorola 68000/68010 or 68020 and higher) and uses
; suitable instructions. If you want to use this player in your
; productions please buy the original (DIGI Booster with player
; source code).
; The code of player isn't optimized yet (except the mix routine
; which is extremly fast!).
;
;------------------------- effects commands --------------------------
; * 0xx arpeggio
; * 1xx portamento up
; * 2xx portamento down
; * 3xx glissando
; * 4xx vibrato
; * 5xx glissando + slide volume
; * 6xx vibrato + slide volume
;   7xx volume vibrato
; * 8xx robot
; * 9xx sample offset - main
; * axx slide volume
; * bxx song repeat
; * cxx set volume
; * dxx pattern break
; * fxx set speed
;
;----------------------------- exx commands ---------------------------
; * e00 filter off
; * e01 filter on
; * e1x fine slide up
; * e2x fine slide down
; * e30 backwd play sample
; * e31 backwd play sample+loop
; * e40 stop playing sample
; * e50 channel	off
; * e51 channel	on
; * e6x loops
; * e8x sample offset 2
; * e9x retrace
; * eax fine volume up
; * ebx fine volume down
; * ecx cut sample
;   edx sample delay
; * eex pause


ChanArea:	equ	108
Version:	equ	24
Channels:	equ	25
PackEnable:	equ	26
PatNum:		equ	46
OrdNum:		equ	47
Orders:		equ	48
SamLens:	equ	176
SamReps:	equ	300
SamReplens:	equ	424
SamVols:	equ	548
SamFins:	equ	579
SongName:	equ	610
SamNames:	equ	642
SongData:	equ	1572


SamBuffAdr:	equ	0	; 4
SamRep1:	equ	4	; 4
SamRep2:	equ	8	; 4
ChangeAdr:	equ	12	; 1
MixDon:		equ	13	; 1
VolA:		equ	14	; 1
VolB:		equ	15	; 1
SlideVolOldA	equ	16	; 1
SlideVolOldB	equ	17	; 1
ReplaceEnable	equ	18	; 1
OffEnable	equ	19	; 1
SamOffsetA	equ	20	; 1
SamOffsetB	equ	21	; 1
RetraceCntA	equ	22	; 1
RetraceCntB	equ	23	; 1
OldSamNumA:	equ	24	; 1
OldSamNumB:	equ	25	; 1
RobotOldVal:	equ	26	; 1
RobotEnable:	equ	27	; 1
MainPeriod:	equ	28	; 2
MainVol:	equ	30	; 1
MBRPointer	equ	31	; 1
PlayPointer	equ	32	; 1
Oldd0		equ	34	; 2
Oldd1		equ	36	; 2
Oldd2		equ	38	; 2
Oldd3		equ	40	; 2
Oldd4		equ	42	; 2
Oldd5		equ	44	; 2
Oldd6		equ	46	; 2
loopsdataschanA	equ	48	; 3
loopsdataschanB	equ	51	; 3
BackWDenable:	equ	56	; 1
EqNewSamA	equ	57	; 1
EqNewSamB	equ	58	; 1
MainDTALEN:	equ	60	; 2
PortUpOldValA	equ	62	; 1
PortUpOldValB	equ	63	; 1
PortDownOldValA	equ	64	; 1
PortDownOldValB	equ	65	; 1
VibratoDatasA	equ	66	; 4
VibratoDatasB	equ	70	; 4
GlissandoDatasA	equ	74	; 6
GlissandoDatasB	equ	80	; 6
BuffBegADR	equ	86	; 4
BuffEndADR	equ	90	; 4
BuffMixADR	equ	94	; 4
OnOffChanA	equ	98	; 1
OnOffChanB	equ	99	; 1
OrgPeriodA	equ	100	; 2
OrgPeriodB	equ	102	; 2
OldVolA:	equ	104	; 1
OldVolB:	equ	105	; 1
NoteCount	equ	106	; 2

; ----------------- To Play VBL modules -------------------
;VBLproc:
;	bsr	db_Init
;	move.w	#$4000,$dff09a
;Loop:	bsr	vbl
;	bsr	db_Music
;	move.w	#$f,$dff180
;	btst	#6,$bfe001
;	bne.s	Loop
;	bsr	db_end
;	move.w	#$c000,$dff09a
;	rts
;vbl:	cmp.b	#$ff,$dff006
;	bne.s	vbl
;	rts
; ----------------- To Play CIA modules -------------------
;CIAproc:
;	move.l	4,a6
;	lea	NameDOS,a1
;	moveq	#0,d0
;	jsr	-408(a6)
;	move.l	d0,DosBase
;	bsr	db_Init
;	bsr	PlugCIA
;LoopCIA:move.l	DosBase,a6
;	moveq	#10,d1
;	jsr	-198(a6)
;	btst	#6,$bfe001
;	bne.s	LoopCIA
;	btst	#2,$dff016
;	bne.s	LoopCIA
;	bsr	UnPlugCIA
;	bsr	db_end
;	rts

PlugCIA:
	move.l	4.w,a6
	lea	GraphName(pc),a1
	moveq	#0,d0
	jsr	-408(a6)
	move.l	d0,GraphBase

	lea	$BFD000,a5
	moveq	#2,d6
IrqCiaLoop:
	moveq	#0,d0
	lea	CiaName(pc),a1
	movea.l	4.w,a6
	jsr	-498(a6)
	move.l	d0,CiaBase
	beq	NoCia

	move.l	GraphBase(pc),d0
	move.l	d0,a1

	tst.l	d0
	beq	UnPlugCIA

	move.l	#125*14209,d7
	divu.w	#125,d7
	jsr	-414(a6)
	move.l	CiaBase(pc),a6
	cmp.w	#2,d6
	beq.s	CiaB

	lea	IrqData(pc),a1
	moveq	#1,d0
	jsr	-6(a6)

	move.l	#1,WhichCIA
	tst.l	d0
	bne.s	ChangeCia
	move.l	a5,CiaAdress

	move.b	d7,$600(a5)
	lsr.w	#8,d7
	move.b	d7,$700(a5)
	move.b	#%00010001,$f00(a5)
	moveq	#1,d0
	rts

CiaB:
	lea	IrqData(pc),a1
	moveq	#0,d0
	jsr	-6(a6)
	clr.l	WhichCIA
	tst.l	d0
	bne.s	ChangeCia
	move.l	a5,CiaAdress

	move.b	d7,$400(a5)
	lsr.w	#8,d7
	move.b	d7,$500(a5)
	move.b	#%00010001,$e00(a5)
	moveq	#1,d0
	rts

ChangeCia:
	move.b	#"a",CiaName+3
	lea	$BFE001,a5
	subq.w	#1,d6
	bne.w	IrqCiaLoop
NoCia:
	moveq	#0,d0
	move.l	d0,CiaBase
	rts

UnPlugCIA:
	move.l	4.w,a6
	move.l	GraphBase(pc),a1
	jsr	-414(a6)
	move.l	CiaBase(pc),d0
	beq.l	NoCia
	move.l	d0,a6
	move.l	CiaAdress(pc),a5
	move.l	WhichCIA(pc),d0
	beq.s	CiabOff
	bclr	#0,$F00(a5)
	moveq	#1,d0
	bra.s	OffEvery
CiabOff:
	bclr	#0,$E00(a5)
	moveq	#0,d0
OffEvery:
	lea	IrqData(pc),a1
	jsr	-12(a6)
	rts

DosBase:	dc.l	0
GraphBase:	dc.l	0
CiaBase:	dc.l	0
CiaAdress:	dc.l	0
WhichCIA:	dc.l	0
NameDOS:	dc.b	"dos.library",0
GraphName:	dc.b	'graphics.library',0
CiaName:	dc.b	"ciab.resource",0
		even
IrqData:
	dc.l	0,0
	dc.b	2,1
	dc.l	DIGIIntName
	dc.l	0
	dc.l	IrqProc

DIGIIntName:
	dc.b	"DIGIBooster Interrupt",0
	even

IrqProc:
	movem.l	d0-a6,-(sp)
	lea	CiaChanged(pc),a2
	tst.w	(a2)
	beq.s	CIA_DONE
	clr.w	(a2)
	move.l	CiaAdress(pc),a5
	move.l	#14209*125,d7
	divu	CiaTempo(pc),d7
	and.l	#$ffff,d7
	move.l	WhichCIA(pc),d1
	bne.s	CIA_B
	move.b	d7,$400(a5)
	lsr.w	#8,d7
	move.b	d7,$500(a5)
	bset	#0,$E00(a5)
	bra.s	CIA_DONE
CIA_B
	move.b	d7,$600(a5)
	lsr.w	#8,d7
	move.b	d7,$700(a5)
	bset	#0,$F00(a5)
CIA_DONE
	bsr	db_Music
	movem.l	(sp)+,d0-a6
	rts
; --------------------------------------------------------------------

db_Init:
	lea	Channel4+ChanArea(pc),a0
	moveq	#ChanArea-1,d0
.loop	clr.l	-(a0)
	dbf	d0,.loop
	move.l	#$10001,MEMTYPE
	move.w	#14-1,WDMA
	move.w	#125,CiaTempo
	clr.b	Fast
	move.l	4.w,a6
	move.l	#4,d1
	jsr	-216(a6)
	tst.l	d0
	beq.w	NoFast
	move.b	#1,Fast
	move.w	#8-1,WDMA
NoFast:
	move.l	4.w,a6	
	move.w	296(a6),d0	

	btst	#0,d0
	beq.s	MC68010
	move.b	#1,OldCPU
MC68010:
	btst	#1,d0
	beq.s	MC68020
	clr.b	OldCPU
MC68020:
	btst	#2,d0
	beq.s	MC68030
	clr.b	OldCPU
MC68030:
	btst	#3,d0
	beq.s	MC68040
	clr.b	OldCPU
MC68040:
	tst.b	OldCPU
	beq.s	NewCPU
	clr.b	Fast
	move.w	#14-1,WDMA
	move.l	#$10002,MEMTYPE
NewCPU
	btst	#7,d0			;
	beq.s	.1			;
	move.w	#20-1,WDMA		;
.1:	bsr	AllocChipBuffs
	tst.l	d0
	beq	Exit
	bsr	AllocMixBuffers
	tst.l	d0
	beq.w	Exit		; If there's no mem just exit this shit
	bsr	AllocWorkBuff
	tst.l	d0
	beq	Exit

	lea	Channel1(pc),a0
	move.l	sample_buff1(pc),a1
	move.l	a1,(a0)
	move.l	a1,BuffBegADR(a0)
	lea	BuffSize(a1),a1
	move.l	a1,BuffEndADR(a0)
	move.l	sample_buff2(pc),a1
	move.l	a1,ChanArea(a0)
	move.l	a1,ChanArea+BuffBegADR(a0)
	lea	BuffSize(a1),a1
	move.l	a1,ChanArea+BuffEndADR(a0)
	move.l	sample_buff3(pc),a1
	move.l	a1,ChanArea*2(a0)
	move.l	a1,[ChanArea*2]+BuffBegADR(a0)
	lea	BuffSize(a1),a1
	move.l	a1,[ChanArea*2]+BuffEndADR(a0)
	move.l	sample_buff4(pc),a1
	move.l	a1,ChanArea*3(a0)
	move.l	a1,[ChanArea*3]+BuffBegADR(a0)
	lea	BuffSize(a1),a1
	move.l	a1,[ChanArea*3]+BuffEndADR(a0)

	clr.b	SongPos
	clr.b	PattPos
	clr.b	count
	move.b	#6,temp

	bset	#1,$bfe001
	bsr	db_InitVoices

	move.b	temp(pc),count
	move.l	ModDIGI(PC),a5

	lea	1572(a5),a1
	movea.l	WorkPTR(pc),a2
	lea	PattAdresses(a2),a2
	move.l	a1,(a2)+
	moveq	#0,d7
	move.b	PatNum(a5),d7
	move.l	#2048,d0
db_MakePatAdr
	tst.b	PackEnable(a5)
	beq.s	dp_SetPatAdr
	move.w	(a1),d0
	addq	#2,d0
dp_SetPatAdr
	add.l	d0,a1
	move.l	a1,(a2)+
	dbf	d7,db_MakePatAdr

	lea	SamLens(a5),a0
	move.l	a1,d6
	move.l	WorkPTR(pc),a2
	lea	sample_starts(a2),a2
	moveq	#30,d7
db_MakeSamAdr
	move.l	d6,(a2)+
	add.l	(a0)+,d6
	dbf	d7,db_MakeSamAdr

	lea	SamLens(a5),a0
	move.l	WorkPTR(pc),a1
	lea	sample_lenghts(a1),a1
	moveq	#31-1,d7
db_cploop1:
	move.l	(a0)+,(a1)+
	dbf	d7,db_cploop1
	bsr	make_voltab
	cmp.b	#$10,Version(a5)
	beq.s	OldDIGIMOD
	cmp.b	#$11,Version(a5)
	beq.s	OldDIGIMOD
	cmp.b	#$12,Version(a5)
	beq.s	OldDIGIMOD
	cmp.b	#$13,Version(a5)
	beq.s	OldDIGIMOD
	moveq	#-1,d0
Exit	rts

OldDIGIMOD
	lea	SamFins(a5),a6
	moveq	#31-1,d7
CLRFINS	clr.b	(a6)+
	dbf	d7,CLRFINS
	moveq	#-1,d0
	rts

db_InitVoices:
	lea	$dff000,a1
	move.l	sample_buff1(pc),$a0(a1)
	move.w	#166,$a4(a1)
	move.w	#214,$a6(a1)
	clr.w	$a8(a1)
	move.l	sample_buff2(pc),$b0(a1)
	move.w	#166,$b4(a1)
	move.w	#214,$b6(a1)
	clr.w	$b8(a1)
	move.l	sample_buff3(pc),$c0(a1)
	move.w	#166,$c4(a1)
	move.w	#214,$c6(a1)
	clr.w	$c8(a1)
	move.l	sample_buff4(pc),$d0(a1)
	move.w	#166,$d4(a1)
	move.w	#214,$d6(a1)
	clr.w	$d8(a1)
	rts


AllocWorkBuff:
	move.l	4.w,a6
	moveq	#1,d1
	swap	d1
	move.l	#WorkBuffSize,d0
	jsr	-198(a6)
	move.l	d0,WorkPTR
	rts

FreeWorkBuff:
	lea	WorkPTR(pc),a0
	move.l	(a0),d0
	beq.s	.1
	clr.l	(a0)
	move.l	4.w,a6
	move.l	d0,a1
	move.l	#WorkBuffSize,d0
	jsr	-210(a6)
.1:	rts


AllocChipBuffs:
	lea	sample_buff3(pc),a6
	clr.l	(a6)
	clr.l	-(a6)
	clr.l	-(a6)
	clr.l	-(a6)
	move.l	4.w,a6
	lea	sample_buff1(pc),a5
	bsr.s	.alloc
	lea	sample_buff2(pc),a5
	bsr.s	.alloc
	lea	sample_buff3(pc),a5
	bsr.s	.alloc
	lea	sample_buff4(pc),a5
	bsr.s	.alloc
	rts
.alloc:
	move.l	#BuffSize+4,d0
	move.l	#$10002,d1
	jsr	-198(a6)
	move.l	d0,(a5)
	bne.s	.ex
	addq.l	#4,a7
.ex:	rts


FreeChipBuffs:
	movea.l	4.w,a6
	lea	sample_buff1(pc),a1
	bsr.s	.free
	lea	sample_buff2(pc),a1
	bsr.s	.free
	lea	sample_buff3(pc),a1
	bsr.s	.free
.3:	lea	sample_buff4(pc),a1
	bsr.s	.free
.q:	moveq	#0,d0
	rts
.free:
	move.l	(a1),d0
	beq.s	.q
	clr.l	(a1)
	move.l	d0,a1
	move.l	#BuffSize+4,d0
	jmp	-210(a6)

	

AllocMixBuffers:
	lea	sample_buff4_MIX(pc),a6
	clr.l	(a6)
	clr.l	-(a6)
	clr.l	-(a6)
	clr.l	-(a6)
	move.l	4.w,a6
	lea	sample_buff1_MIX(pc),a5
	bsr.s	.alloc
	lea	sample_buff2_MIX(pc),a5
	bsr.s	.alloc
	lea	sample_buff3_MIX(pc),a5
	bsr.s	.alloc
	lea	sample_buff4_MIX(pc),a5
	bsr.s	.alloc
	rts

.alloc:
	moveq	#8+8,d0
	addi.l	#2500*3,d0
	move.l	MEMTYPE(pc),d1
	jsr	-198(a6)
	tst.l	d0
	bne.s	.oka
	addq.l	#4,a7
	rts
.oka:	addq.l	#8,d0
	move.l	d0,(a5)
	rts


FreeMixBuffers:
	move.l	4.w,a6
	lea	sample_buff1_MIX(pc),a1
	bsr.s	.free
	lea	sample_buff2_MIX(pc),a1
	bsr.s	.free
	lea	sample_buff3_MIX(pc),a1
	bsr.s	.free
	lea	sample_buff4_MIX(pc),a1
	bsr.s	.free
.exit:
	rts
.free:
	move.l	(a1),d0
	beq.s	.exit
	clr.l	(a1)
	move.l	d0,a1
	subq.l	#8,a1
	moveq	#8+8,d0
	add.l	#2500*3,d0
	jmp	-210(a6)



sample_buff1_MIX:	dc.l	0
sample_buff2_MIX:	dc.l	0
sample_buff3_MIX:	dc.l	0
sample_buff4_MIX:	dc.l	0

MEMTYPE:	dc.l	0
WDMA:		dc.w	0
Fast:		dc.b	0
OldCPU:		dc.b	0
SongPos:	dc.b	0
PattPos:	dc.b	0
temp:		dc.b	0
count:		dc.b	0
JMPEN:		dc.b	0
OldPattPos:	dc.b	0
PauseEn:	dc.b	0
hisam:		dc.b	0
PauseVBL:	dc.w	0
OldDepAdr:	dc.l	0
ModDIGI:	dc.l	0
channelenable:	dc.w	0
MixPeriodA:	dc.w	0
MixPeriodB:	dc.w	0
leng:		dc.w	0
what:		dc.w	0
CiaTempo:	dc.w	0
CiaChanged:	dc.w	0

; ------------------- Paremeters --------------
MainVolValue:	dc.w	64	; 0-64
ConfVolBoost	dc.w	80	; 0-100%
ConfMix:	dc.b	0	; 0 - mix only joined chennels eg. mix when
				; 1a and 1b channels are used...
				; 1 - mix all channels
BuffSize	equ	4096	; sample mix buffer size
		even

db_Music:
	move.b	Enabled(pc),d0
	bne.s	.1
	rts
.1	move.l	ModDIGI(pc),a5
	move.l	WorkPTR(pc),a0
	lea	sample_starts(a0),a0	; sample starts, 124(a0) lenghts
	lea	SamReps(a5),a3		; sample repeats, 124(a3) replens
	lea	SamVols(a5),a4		; sample volumes

	move.b	count(pc),d7
	cmp.b	temp(pc),d7
	blt	DepackDone

	tst.b	temp
	beq.s	NoNewPos
	cmp.b	#64,PattPos
	bne.s	NoNewPos
	clr.b	PattPos
	addq.b	#1,SongPos
NoNewPos:
	moveq	#0,d6
	moveq	#0,d7
	move.b	OrdNum(a5),d7
	move.b	SongPos(pc),d6
	cmp.w	d6,d7
	bge.s	NoRepeatSong
	clr.b	SongPos
	clr.b	PattPos
	move.l	WorkPTR(pc),a1
	move.l	PattAdresses(a1),a1
	
;	tst.b	Looped
;	bne.w	NoRepeatSong
;	move.l	a0,-(a7)
;	lea	Enabled(pc),a0
;	sf	(a0)
;	lea	$dff000,a0
;	clr.w	$a8(a0)
;	clr.w	$b8(a0)
;	clr.w	$c8(a0)
;	clr.w	$d8(a0)
;	lea	Ended(pc),a0
;	st	(a0)
;	movea.l	(a7)+,a0
;	rts
	
NoRepeatSong:

	moveq	#0,d7
	move.b	SongPos(pc),d7
	move.b	Orders(a5,d7.w),d7
	lsl.w	#2,d7
	move.l	WorkPTR(pc),a1
	lea	PattAdresses(a1),a1
	move.l	(a1,d7.w),a1
	
	tst.b	PackEnable(a5)
	bne.s	DepackPattern

	moveq	#0,d7
	move.b	PattPos(pc),d7
	lsl.w	#2,d7
	add.w	d7,a1

	move.l	WorkPTR(pc),a6
	lea	UnPackedData(a6),a6
	moveq	#3,d7
CopyDataLoop
	move.l	(a1),(a6)+
	move.l	1024(a1),(a6)+
	lea	256(a1),a1
	dbf	d7,CopyDataLoop
	bra	DepackDone
DepackPattern:

	addq.w	#2,a1
	lea	(a1),a6
	lea	64(a1),a5
	moveq	#0,d7
	move.b	PattPos(pc),d7
	add.w	d7,a1
	move.b	OldPattPos(pc),d6
	addq.b	#1,d6
	cmp.b	d6,d7
	beq.s	NoCalcAdr

	tst.w	d7
	beq.s	DepackData
	subq	#1,d7
	moveq	#0,d1
DepackCalcAdr:
	move.b	(a6)+,d0
	btst	#7,d0
	beq.s	DepackNoAdd7
	addq	#4,d1
DepackNoAdd7
	btst	#6,d0
	beq.s	DepackNoAdd6
	addq	#4,d1
DepackNoAdd6
	btst	#5,d0
	beq.s	DepackNoAdd5
	addq	#4,d1
DepackNoAdd5
	btst	#4,d0
	beq.s	DepackNoAdd4
	addq	#4,d1
DepackNoAdd4
	btst	#3,d0
	beq.s	DepackNoAdd3
	addq	#4,d1
DepackNoAdd3
	btst	#2,d0
	beq.s	DepackNoAdd2
	addq	#4,d1
DepackNoAdd2
	btst	#1,d0
	beq.s	DepackNoAdd1
	addq	#4,d1
DepackNoAdd1
	btst	#0,d0
	beq.s	DepackNoAdd0
	addq	#4,d1
DepackNoAdd0
	dbf	d7,DepackCalcAdr
	add.l	d1,a5
	bra.s	DepackData
NoCalcAdr
	move.l	OldDepAdr(pc),a5
DepackData:
	move.b	PattPos(pc),OldPattPos
	movea.l	WorkPTR(pc),a6
	lea	UnPackedData(a6),a6
	moveq	#7,d7
DepackDataLoop
	btst	d7,(a1)
	beq.s	DepackPutZero
	move.l	(a5)+,(a6)+
	dbf	d7,DepackDataLoop
	move.l	a5,OldDepAdr
	bra.s	DepackDone
DepackPutZero
	clr.l	(a6)+
	dbf	d7,DepackDataLoop
	move.l	a5,OldDepAdr
DepackDone

	movea.l	WorkPTR(pc),a1
	lea	UnPackedData(a1),a1
	moveq	#0,d6
	moveq	#0,d5
	lea	Channel1(pc),a6
	lea	$dff0a0,a5
	bsr	playvoice
	moveq	#1,d5
	lea	Channel2(pc),a6
	lea	$dff0b0,a5
	bsr	playvoice
	moveq	#2,d5
	lea	Channel3(pc),a6
	lea	$dff0c0,a5
	bsr	playvoice
	moveq	#3,d5
	lea	Channel4(pc),a6
	lea	$dff0d0,a5
	bsr	playvoice

	tst.w	d6
	beq.s	NoSetDma

	bsr	Wait_DMA

	or.w	#$8000,d6
	move.w	d6,$dff096

NoSetDma:
	move.l	ModDIGI(pc),a5
	lea	Channel1(pc),a6
	bsr	MIXCHAN

	tst.w	PauseVBL
	beq.s	NoPause
	move.b	#1,PauseEn
	subq.w	#1,PauseVBL
NoPause:

	move.b	count(pc),d7
	cmp.b	temp(pc),d7
	blt.s	No_NEW
	clr.b	count

	tst.w	PauseVBL
	bne.s	DoPAUSE
	addq.b	#1,PattPos
	clr.b	PauseEn
DoPAUSE
No_NEW
	addq.b	#1,count
	rts

playvoice:
	clr.b	EqNewSamA(a6)
	clr.b	EqNewSamB(a6)

	tst.w	MainPeriod(a6)
	beq.w	PlayOK

	tst.b	OffEnable(a6)
	beq.s	NoOFFchan
	clr.b	OffEnable(a6)

	tst.w	Oldd0(a6)
	beq.s	NoData1
	tst.w	Oldd4(a6)
	bne.s	OFFchan
NoData1
	tst.b	PlayPointer(a6)
	beq.s	OFFchan
	move.w	Oldd2(a6),d1
	lsr.w	#8,d1
	cmp.b	#3,d1
	beq.s	NoOFFchan
	cmp.b	#5,d1
	beq.s	NoOFFchan
	move.w	Oldd6(a6),d1
	lsr.w	#8,d1
	cmp.b	#3,d1
	beq.s	NoOFFchan
	cmp.b	#5,d1
	beq.s	NoOFFchan
OFFchan
	moveq	#0,d0
	bset	d5,d0
	move.w	d0,$dff096
	bset	d5,d6
NoOFFchan
	cmp.w	#-1,MainPeriod(a6)
	beq.w	StopChan

	cmp.b	#1,MBRPointer(a6)
	beq.s	NoPlayMixBuff
	move.l	BuffBegADR(a6),(a5)
	move.w	#BuffSize,d7
	lsr.w	#1,d7
	move.w	d7,4(a5)
	move.w	MainPeriod(a6),6(a5)
	moveq	#0,d7
	move.b	MainVol(a6),d7
	mulu	MasterVol(pc),d7
	lsr.w	#6,d7
	move.w	d7,8(a5)
	cmp.b	#2,MBRPointer(a6)
	beq.s	PlayOK
	move.b	#1,PlayPointer(a6)
	bra.s	PlayOK
NoPlayMixBuff
	move.l	BuffMixADR(a6),(a5)
	move.w	Oldd3(a6),d3
	lsr.w	#1,d3
	move.w	d3,4(a5)
	move.w	MainPeriod(a6),6(a5)
	moveq	#0,d7
	move.b	MainVol(a6),d7
	mulu	MasterVol(pc),d7
	lsr.w	#6,d7
	move.w	d7,8(a5)
	bra.s	PlayOK
StopChan
	moveq	#0,d0
	bset	d5,d0
	bclr	d5,d6
	move.w	d0,$dff096
	move.b	#1,PlayPointer(a6)
	clr.w	MainPeriod(a6)
PlayOK	rts


Wait_DMA:
	lea	$dff006,a5
	move.w	WDMA(pc),d0
wait_loop1:
	move.b	(a5),d1
wait_loop2:
	cmp.b	(a5),d1
	beq.s	wait_loop2
	dbf	d0,wait_loop1
	rts

MIXCHAN:
*-------------------- channel 1a,1b mix ---------------------------
	move.l	WorkPTR(pc),a2
	lea	sample_pos1(a2),a2	; sample positions
	move.w	Oldd0(a6),d0
	move.w	Oldd1(a6),d1
	move.w	Oldd2(a6),d2
	move.w	Oldd3(a6),d3
	move.w	Oldd4(a6),d4
	move.w	Oldd5(a6),d5
	move.w	Oldd6(a6),d6

	tst.w	what
	bne.s	ok1
	move.l	sample_buff1_MIX(pc),BuffMixADR(a6)
ok1:
	cmp.w	#1,what
	bne.s	ok2
	move.l	sample_buff1_MIX(pc),BuffMixADR(a6)
	add.l	#2500,BuffMixADR(a6)
ok2:
	cmp.w	#2,what
	bne.s	ok3
	move.l	sample_buff1_MIX(pc),BuffMixADR(a6)
	add.l	#5000,BuffMixADR(a6)
ok3:
	bsr	mainPROC
	move.w	d0,Oldd0(a6)
	move.w	d1,Oldd1(a6)
	move.w	d2,Oldd2(a6)
	move.w	d3,Oldd3(a6)
	move.w	d4,Oldd4(a6)
	move.w	d5,Oldd5(a6)
	move.w	d6,Oldd6(a6)

*-------------------- channel 2a,2b mix ---------------------------
	lea	ChanArea(a6),a6
	move.l	WorkPTR(pc),a2
	lea	sample_pos2(a2),a2	; sample positions
	move.w	Oldd0(a6),d0
	move.w	Oldd1(a6),d1
	move.w	Oldd2(a6),d2
	move.w	Oldd3(a6),d3
	move.w	Oldd4(a6),d4
	move.w	Oldd5(a6),d5
	move.w	Oldd6(a6),d6
	lea	8(a1),a1

	tst.w	what
	bne.s	ok1_2
	move.l	sample_buff2_MIX(pc),BuffMixADR(a6)
ok1_2:
	cmp.w	#1,what
	bne.s	ok2_2
	move.l	sample_buff2_MIX(pc),BuffMixADR(a6)
	add.l	#2500,BuffMixADR(a6)
ok2_2:
	cmp.w	#2,what
	bne.s	ok3_2
	move.l	sample_buff2_MIX(pc),BuffMixADR(a6)
	add.l	#5000,BuffMixADR(a6)
ok3_2:
	bsr	mainPROC
	move.w	d0,Oldd0(a6)
	move.w	d1,Oldd1(a6)
	move.w	d2,Oldd2(a6)
	move.w	d3,Oldd3(a6)
	move.w	d4,Oldd4(a6)
	move.w	d5,Oldd5(a6)
	move.w	d6,Oldd6(a6)
*-------------------- channel 3a,3b mix ---------------------------
	lea	ChanArea(a6),a6
	move.l	WorkPTR(pc),a2
	lea	sample_pos3(a2),a2	; sample positions
	move.w	Oldd0(a6),d0
	move.w	Oldd1(a6),d1
	move.w	Oldd2(a6),d2
	move.w	Oldd3(a6),d3
	move.w	Oldd4(a6),d4
	move.w	Oldd5(a6),d5
	move.w	Oldd6(a6),d6
	lea	8(a1),a1

	tst.w	what
	bne.s	ok1_3
	move.l	sample_buff3_MIX(pc),BuffMixADR(a6)
ok1_3:
	cmp.w	#1,what
	bne.s	ok2_3
	move.l	sample_buff3_MIX(pc),BuffMixADR(a6)
	add.l	#2500,BuffMixADR(a6)
ok2_3:
	cmp.w	#2,what
	bne.s	ok3_3
	move.l	sample_buff3_MIX(pc),BuffMixADR(a6)
	add.l	#5000,BuffMixADR(a6)
ok3_3:
	bsr	mainPROC
	move.w	d0,Oldd0(a6)
	move.w	d1,Oldd1(a6)
	move.w	d2,Oldd2(a6)
	move.w	d3,Oldd3(a6)
	move.w	d4,Oldd4(a6)
	move.w	d5,Oldd5(a6)
	move.w	d6,Oldd6(a6)
*-------------------- channel 4a,4b mix ---------------------------
	lea	ChanArea(a6),a6
	move.l	WorkPTR(pc),a2
	lea	sample_pos4(a2),a2	; sample positions
	move.w	Oldd0(a6),d0
	move.w	Oldd1(a6),d1
	move.w	Oldd2(a6),d2
	move.w	Oldd3(a6),d3
	move.w	Oldd4(a6),d4
	move.w	Oldd5(a6),d5
	move.w	Oldd6(a6),d6
	lea	8(a1),a1

	tst.w	what
	bne.s	ok1_4
	move.l	sample_buff4_MIX(pc),BuffMixADR(a6)
ok1_4:
	cmp.w	#1,what
	bne.s	ok2_4
	move.l	sample_buff4_MIX(pc),BuffMixADR(a6)
	add.l	#2500,BuffMixADR(a6)
ok2_4:
	cmp.w	#2,what
	bne.s	ok3_4
	move.l	sample_buff4_MIX(pc),BuffMixADR(a6)
	add.l	#5000,BuffMixADR(a6)
ok3_4:
	bsr	mainPROC
	move.w	d0,Oldd0(a6)
	move.w	d1,Oldd1(a6)
	move.w	d2,Oldd2(a6)
	move.w	d3,Oldd3(a6)
	move.w	d4,Oldd4(a6)
	move.w	d5,Oldd5(a6)
	move.w	d6,Oldd6(a6)
* ----------------------------------------------------------
	tst.w	what
	bne.s	whatok
	move.w	#3,what
whatok
	subq	#1,what
	rts

; -------------- main procedure ----------------------------
mainPROC:
	move.b	OldVolA(a6),VolA(a6)
	move.b	OldVolB(a6),VolB(a6)

	addq.w	#1,NoteCount(a6)

	tst.b	temp
	beq.w	old_data

	move.b	count(pc),d7
	cmp.b	temp(pc),d7
	blt	old_data

	tst.b	PauseEn
	bne.w	oldperiod_1
	tst.b	OnOffChanA(a6)
	bne.w	oldperiod_1

	moveq	#0,d3

	tst.w	(a1)
	beq.w	oldperiod_1

	move.w	2(a1),d7
	and.w	#$0f00,d7
	cmp.w	#$300,d7
	bne.s	NoClrGliss_1
	clr.w	GlissandoDatasA+4(a6)
NoClrGliss_1

	clr.w	VibratoDatasA(a6)

	move.b	#1,OffEnable(a6)
	move.b	#1,EqNewSamA(a6)
	move.w	(a1),d7

	btst	#12,d7
	beq.s	nohisam1
	move.b	#1,hisam
	bclr	#12,d7
	tst.w	d7
	beq.w	oldperiod_1
nohisam1
	move.w	d7,d0

;					 finetunes
	movem.l	d1-d3/d7/a0/a1,-(sp)
	move.w	2(a1),d7
	lsr.w	#8,d7
	lsr.w	#4,d7
	tst.b	hisam
	beq.s	nohisam111
	add.w	#$10,d7
nohisam111
	tst.w	d7
	bne.s	notakeold1
	moveq	#0,d7
	move.b	OldSamNumA(a6),d7
	lsr.w	#2,d7
	addq	#1,d7
notakeold1
	moveq	#0,d2
	moveq	#0,d3
	move.b	30(a4,d7.w),d2
	subq.b	#1,d2
	ext.w	d2
	beq.s	FinTOK3

	cmp.w	#7,d2
	bgt.s	NotFromTable1
	cmp.w	#-8,d2
	blt.s	NotFromTable1

	lea	Periods(pc),a1
	moveq	#36,d7
ftulop1	cmp.w	(a1)+,d0
	beq.s	ftufnd1
	dbf	d7,ftulop1
	cmp.w	#74,a1
	bge.s	NotFromTable1
ftufnd1	sub.l	#Periods,a1
	move.l	a1,d1
	subq.w	#2,d1

	lea	Tunnings(pc),a0
	add.w	#8,d2
	mulu	#72,d2
	add.w	d2,a0
	move.w	(a0,d1.w),d0
	bra.s	FinTOK3
NotFromTable1

	tst.w	d2
	bgt.s	FinTOK1
	mulu	#-1,d2
	moveq	#-1,d3
FinTOK1	moveq	#0,d1
	move.w	d0,d1
	mulu	d2,d1
	divu	#140,d1
	tst.w	d3
	bne.s	FinTOK2
	sub.w	d1,d0
	bra.s	FinTOK3
FinTOK2	add.w	d1,d0
FinTOK3	movem.l	(sp)+,d1-d3/d7/a0/a1
	move.w	d0,OrgPeriodA(a6)

	tst.b	MixDon(a6)
	beq.s	cont1

	move.l	(a0,d5.w),d7
	add.l	124(a0,d5.w),d7
	cmp.l	124(a2,d5.w),d7
	bgt.s	cont1

	tst.l	(a3,d5.w)
	bne.s	cont1

	clr.l	124(a2,d5.w)
	moveq	#0,d4
	moveq	#0,d5
	clr.b	MixDon(a6)
cont1:
	bra.s	newperiod_1
oldperiod_1:
	moveq	#-1,d3
newperiod_1:

	moveq	#0,d2

	tst.b	hisam
	bne.s	neweff_1
	tst.w	2(a1)
	beq.w	oldeff_1
neweff_1
	move.w	2(a1),d2
	move.w	d2,d7
	lsr.w	#8,d7
	lsr.w	#4,d7

	tst.b	hisam
	beq.s	nohisam11
	add.w	#$10,d7
	clr.b	hisam
nohisam11

	tst.b	d7
	beq.s	oldeff_1

	cmp.b	#-1,d3
	bne.s	noupvol_1
	move.w	d1,d3
	lsr.w	#2,d3
	move.b	(a4,d3.w),VolA(a6)
	and.w	#$0fff,d2
	bra.s	NoOldNum_1
noupvol_1:

	move.w	d7,d1
	subq	#1,d1
	lsl.w	#2,d1
	move.w	d2,d7
	and.w	#$0f00,d7
	cmp.w	#$300,d7
	bne.s	NewAdr_1

	tst.l	(a2,d1.w)
	bne.s	NoNewAdr_1
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	bra.s	NoOldNum_1
NewAdr_1
	move.l	(a0,d1.w),(a2,d1.w)
NoNewAdr_1
	move.w	d1,d3
	lsr.w	#2,d3
	move.b	(a4,d3.w),VolA(a6)
	and.w	#$0fff,d2
	move.b	d1,OldSamNumA(a6)
	clr.b	BackWDenable(a6)
	bra.s	NoOldNum_1
oldeff_1:
	tst.w	(a1)
	beq.s	NoOldNum_1

	moveq	#0,d1
	move.b	OldSamNumA(a6),d1

	move.w	d2,d7
	and.w	#$0f00,d7
	cmp.w	#$500,d7
	beq.s	YeGL_1
	cmp.w	#$300,d7
	bne.s	NoGL_1
YeGL_1
	tst.l	(a2,d1.w)
	bne.s	NoOldNum_1
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	bra.s	NoOldNum_1
NoGL_1

	move.l	(a0,d1.w),(a2,d1.w)
NoOldNum_1


	tst.b	PauseEn
	bne.w	oldperiod_2
	tst.b	OnOffChanB(a6)
	bne.w	oldperiod_2

	moveq	#0,d3

	tst.w	4(a1)
	beq.w	oldperiod_2

	move.w	6(a1),d7
	and.w	#$0f00,d7
	cmp.w	#$300,d7
	bne.s	NoClrGliss_2
	clr.w	GlissandoDatasB+4(a6)
NoClrGliss_2

	clr.w	VibratoDatasB(a6)
	add.b	#1,OffEnable(a6)
	move.b	#1,EqNewSamB(a6)

	move.w	4(a1),d7

	btst	#12,d7
	beq.s	nohisam_2
	move.b	#1,hisam
	bclr	#12,d7
	tst.w	d7
	beq.w	oldperiod_2
nohisam_2:
	move.w	d7,d4

;					 finetunes
	movem.l	d1-d3/d7/a0/a1,-(sp)
	move.w	6(a1),d7
	lsr.w	#8,d7
	lsr.w	#4,d7
	tst.b	hisam
	beq.s	nohisam222
	add.w	#$10,d7
nohisam222
	tst.w	d7
	bne.s	notakeold2
	moveq	#0,d7
	move.b	OldSamNumB(a6),d7
	lsr.w	#2,d7
	addq	#1,d7
notakeold2
	moveq	#0,d2
	moveq	#0,d3
	move.b	30(a4,d7.w),d2
	subq.b	#1,d2
	ext.w	d2
	beq.s	FinTOK3b

	cmp.w	#7,d2
	bgt.s	NotFromTable2
	cmp.w	#-8,d2
	blt.s	NotFromTable2

	lea	Periods(pc),a1
	moveq	#36,d7
ftulop2	cmp.w	(a1)+,d4
	beq.s	ftufnd2
	dbf	d7,ftulop2
	cmp.w	#74,a1
	bge.s	NotFromTable2
ftufnd2	sub.l	#Periods,a1
	move.l	a1,d1
	subq.w	#2,d1

	add.w	#8,d2
	lea	Tunnings(pc),a0
	mulu	#72,d2
	add.w	d2,a0
	move.w	(a0,d1.w),d4
	bra.s	FinTOK3b
NotFromTable2


	tst.w	d2
	bge.s	FinTOK1b
	mulu	#-1,d2
	moveq	#-1,d3
FinTOK1b
	moveq	#0,d1
	move.w	d4,d1
	mulu	d2,d1
	divu	#140,d1
	tst.w	d3
	bne.s	FinTOK2b
	sub.w	d1,d4
	bra.s	FinTOK3b
FinTOK2b
	add.w	d1,d4
FinTOK3b
	movem.l	(sp)+,d1-d3/d7/a0/a1
	move.w	d4,OrgPeriodB(a6)

	tst.b	MixDon(a6)
	beq.s	cont2

	move.l	(a0,d1.w),d7
	add.l	124(a0,d1.w),d7
	cmp.l	(a2,d1.w),d7
	bgt.s	cont2

	tst.l	(a3,d1.w)
	bne.s	cont2

	clr.l	(a2,d1.w)
	moveq	#0,d0
	moveq	#0,d1
	clr.b	MixDon(a6)
cont2:
	bra.s	newperiod_2
oldperiod_2:
	moveq	#-1,d3
newperiod_2:

	moveq	#0,d6

	tst.b	hisam
	bne.s	neweff_2
	tst.w	6(a1)
	beq.w	OldEff_2
neweff_2
	move.w	6(a1),d6

	move.w	d6,d7
	lsr.w	#8,d7
	lsr.w	#4,d7

	tst.b	hisam
	beq.s	nohisam22
	add.w	#$10,d7
	clr.b	hisam
nohisam22

	tst.b	d7
	beq.s	OldEff_2

	cmp.b	#-1,d3
	bne.s	noupvol_2
	move.w	d5,d3
	lsr.w	#2,d3
	move.b	(a4,d3.w),VolB(a6)
	and.w	#$0fff,d6
	bra.s	NoOldNum_2
noupvol_2:
	move.w	d7,d5
	subq	#1,d5
	lsl.w	#2,d5

	move.w	d6,d7
	and.w	#$0f00,d7
	cmp.w	#$300,d7
	bne.s	NewAdr_2

	tst.l	124(a2,d5.w)		; adres sampla
	bne.s	NoNewAdr_2
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	bra.s	NoOldNum_2
NewAdr_2
	move.l	(a0,d5.w),124(a2,d5.w)	; adres sampla
NoNewAdr_2
	move.w	d5,d3
	lsr.w	#2,d3
	move.b	(a4,d3.w),VolB(a6)
	and.w	#$0fff,d6
	move.b	d5,OldSamNumB(a6)
	clr.b	BackWDenable(a6)
	bra.s	NoOldNum_2
OldEff_2:
	tst.w	4(a1)
	beq.s	NoOldNum_2

	moveq	#0,d5
	move.b	OldSamNumB(a6),d5

	move.w	d6,d7
	and.w	#$0f00,d7
	cmp.w	#$500,d7
	beq.s	YeGL_2
	cmp.w	#$300,d7
	bne.s	NoGL_2
YeGL_2
	tst.l	124(a2,d5.w)
	bne.s	NoOldNum_2
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	bra.s	NoOldNum_2
NoGL_2
	move.l	(a0,d5.w),124(a2,d5.w)
NoOldNum_2
	tst.l	(a0,d5.w)
	bne.s	NoZeroSam2
	moveq	#0,d4
	moveq	#0,d5
NoZeroSam2
	tst.l	(a0,d1.w)
	bne.s	NoZeroSam1
	moveq	#0,d0
	moveq	#0,d1
NoZeroSam1


	move.l	a5,-(sp)
	bsr	EffectCommandsA2
	bsr	EffectCommandsB2
	move.l	(sp)+,a5

	tst.b	OnOffChanA(a6)
	bne.s	Stop1
	cmp.w	#$0e40,d2
	bne.s	No_stop1
	move.l	BuffBegADR(a6),(a6)
	move.b	#1,OffEnable(a6)
Stop1	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
No_stop1
	tst.b	OnOffChanB(a6)
	bne.s	Stop2
	cmp.w	#$0e40,d6
	bne.s	No_stop2
	move.l	BuffBegADR(a6),(a6)
	move.b	#1,OffEnable(a6)
Stop2	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
No_stop2

old_data:

	move.b	temp(pc),d7
	subq	#1,d7
	cmp.b	count(pc),d7
	bne.s	no_CLReff
	move.w	d2,d7
	lsr.w	#8,d7
	cmp.b	#8,d7
	beq.s	no_CLReff1
	cmp.b	#3,d7
	beq.s	no_CLReff1
	cmp.b	#4,d7
	beq.s	no_CLReff1
	cmp.b	#5,d7
	beq.s	CLReffSP1
	TST.b	d7
	beq.s	no_CLReff1

	move.w	d2,d7
	lsr.w	#4,d7
	cmp.w	#$ec,d7
	beq.s	no_CLReff1
	cmp.w	#$e9,d7
	beq.s	no_CLReff1
	moveq	#0,d2
	bra.s	no_CLReff1
CLReffSP1:
	move.w	#$0300,d2
no_CLReff1
	move.w	d6,d7
	lsr.w	#8,d7
	cmp.b	#3,d7
	beq.s	no_CLReff2
	cmp.b	#4,d7
	beq.s	no_CLReff2
	cmp.b	#5,d7
	beq.s	CLReffSP2
	TST.b	d7
	beq.s	no_CLReff2

	move.w	d6,d7
	lsr.w	#4,d7
	cmp.w	#$ec,d7
	beq.s	no_CLReff2
	cmp.w	#$e9,d7
	beq.s	no_CLReff2

	moveq	#0,d6
	bra.s	no_CLReff2
CLReffSP2:
	move.w	#$0300,d6
no_CLReff2

no_CLReff

	bsr	TestPeriod
	move.l	a5,-(sp)
	bsr	EffectCommandsA
	bsr	EffectCommandsB
	move.l	(sp)+,a5
	bsr	TestPeriod

	move.w	d0,GlissandoDatasA+2(a6)
	move.w	d4,GlissandoDatasB+2(a6)

; -----------------------------------
	movem.l	d0-a6,-(sp)
	move.b	VolA(a6),OldVolA(a6)
	move.b	VolB(a6),OldVolB(a6)
	move.w	MainVolValue(pc),d0
	mulu	ConfVolBoost(pc),d0
	divu	#100,d0
	moveq	#0,d1
	move.b	VolA(a6),d1
	mulu	d0,d1
	lsr.w	#6,d1
	move.b	d1,VolA(a6)
	moveq	#0,d1
	move.b	VolB(a6),d1
	mulu	d0,d1
	lsr.w	#6,d1
	move.b	d1,VolB(a6)
	movem.l	(sp)+,d0-a6

	tst.w	d0
	bne.s	NoReplace1
	tst.w	d4
	beq.s	NoReplace1
	move.l	124(a2,d5.w),(a2,d5.w)
	clr.l	124(a2,d5.w)
	move.w	d4,d0
	move.w	d5,d1
	move.w	d6,d2
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	move.b	#1,ReplaceEnable(a6)
	move.b	VolA(a6),d3
	move.b	VolB(a6),VolA(a6)
	move.b	d3,VolB(a6)
NoReplace1

	tst.w	d4
	bne	mixing

	clr.b	MBRPointer(a6)

	tst.w	d0
	beq	nothing

	move.w	d0,MainPeriod(a6)
	move.b	VolA(a6),MainVol(a6)

	tst.b	OffEnable(a6)
	beq.s	NoAtStartBuff
	tst.b	PlayPointer(a6)
	beq.s	BuffAtStart
	move.w	d2,d7
	lsr.w	#8,d7
	cmp.b	#3,d7
	beq.s	NoAtStartBuff
	cmp.b	#5,d7
	beq.s	NoAtStartBuff
BuffAtStart
	move.l	BuffBegADR(a6),(a6)
NoAtStartBuff

	bsr	Calc
; - - - - - - - - - - - - - - -  backwd play - - - - - - - - - - - - - - -
	tst.b	BackWDenable(a6)
	bne.s	bckOK

	move.w	d2,d7
	lsr.w	#4,d7
	cmp.w	#$e3,d7
	bne.w	no_backwd
	move.l	124(a0,d1.w),d7
	add.l	d7,(a2,d1.w)
	move.b	#1,BackWDenable(a6)

	move.b	d2,d7
	and.b	#$0f,d7
	beq.s	bckOK
	move.b	#2,BackWDenable(a6)
bckOK
	move.b	#1,MBRPointer(a6)
	movem.l	d0-d1/a4-a5,-(sp)

	move.l	(a0,d1.w),d0
	move.w	d3,d7
	subq	#1,d7
	move.l	(a2,d1.w),a5
	move.l	BuffMixADR(a6),a4

	cmp.b	#1,BackWDenable(a6)
	beq.s	copy_loopbck1

copy_loopbck2:
	cmp.l	d0,a5
	ble.s	sampleend_str
	move.b	-(a5),(a4)+
	dbf	d7,copy_loopbck2
	bra.s	bck_done
sampleend_str:
copy_loopbck3:
	move.b	(a5)+,(a4)+
	dbf	d7,copy_loopbck3
	clr.b	BackWDenable(a6)
	bra.s	bck_done

copy_loopbck1:
	cmp.l	d0,a5
	bgt.s	NoTasampleend
	moveq	#0,d0
	clr.b	-1(a4)
clr_loop2:
	move.b	d0,(a4)+
	dbf	d7,clr_loop2
	tst.b	Fast
	beq.s	NoCopyFromFAST
	bsr	CopyFromFAST
NoCopyFromFAST
	bra.w	realsampleend
NoTasampleend

	move.b	-(a5),(a4)+
	dbf	d7,copy_loopbck1
bck_done:
	move.l	a5,(a2,d1.w)
	movem.l	(sp)+,d0-d1/a4-a5
	tst.b	Fast
	beq.s	NoCopyFromFAST2
	bsr	CopyFromFAST
NoCopyFromFAST2
	bra.w	Replace2
no_backwd
	move.w	d2,d7
	lsr.w	#8,d7
	cmp.b	#$8,d7
	beq	RobotEffect

	tst.b	RobotEnable(a6)
	beq.s	NoOffCH
	move.b	#1,OffEnable(a6)
	move.l	BuffBegADR(a6),(a6)
NoOffCH	clr.b	RobotEnable(a6)
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	addq	#1,d3

	tst.l	124(a3,d1.w)
	bne	sampleloop

	movem.l	d0-d1/a4-a5,-(sp)

	move.l	124(a0,d1.w),d0
	add.l	(a0,d1.w),d0
	move.l	(a2,d1.w),a5
	cmp.l	d0,a5
	blt.s	NotSamEnd0
	move.w	#-1,MainPeriod(a6)
	bra	realsampleend
NotSamEnd0

	move.l	(a6),d7
	move.l	(a6),d1
	add.l	d3,d1
	cmp.l	BuffEndADR(a6),d1
	ble.s	NotEndBuff

	move.l	a5,d7
	add.l	d3,d7
	cmp.l	d0,d7
	ble.s	NotSamEnd2
	move.w	#-1,MainPeriod(a6)
	bra	realsampleend
NotSamEnd2
	sub.l	BuffEndADR(a6),d1
	move.w	d3,d7
	sub.w	d1,d7
	subq.w	#1,d7
	move.l	(a6),a4
	bsr	copy_loop

	move.l	BuffBegADR(a6),(a6)
	move.l	(a6),a4

	move.w	d1,d7
	subq.w	#1,d7
	bsr	copy_loop
	bra.s	CopyDone
NotEndBuff

	move.l	(a6),a4

	move.l	a5,d7
	add.l	d3,d7
	cmp.l	d0,d7
	ble.s	NotSamEnd1
	sub.l	d0,d7
	move.w	d7,d0
	move.w	d3,d7
	sub.w	d0,d7
	subq.w	#1,d7
	bsr	copy_loop

	move.w	d0,d7
	beq.s	nosubq1
	subq.w	#1,d7
nosubq1
	bra	sampleend
NotSamEnd1
	move.w	d3,d7
	subq	#1,d7
	bsr	copy_loop
CopyDone:
	move.l	a4,(a6)
	movem.l	(sp)+,d0-d1/a4-a5
	add.l	d3,(a2,d1.w)

Replace2:
	move.w	d3,MainDTALEN(a6)
Replace_R:
	tst.b	ReplaceEnable(a6)
	beq.s	NoReplace2
	move.l	(a2,d1.w),124(a2,d1.w)
	clr.l	(a2,d1.w)
	move.w	d0,d4
	move.w	d1,d5
	move.w	d2,d6
	clr.b	ReplaceEnable(a6)
	move.b	VolA(a6),d0
	move.b	VolB(a6),VolA(a6)
	move.b	d0,VolB(a6)
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
NoReplace2
	rts

copy_loopM:
	tst.w	d7
	blt.s	copy_loopex
	bra.s	copy_loopM2
copy_loop:
	tst.w	d7
	blt.s	copy_loopex
	tst.b	ConfMix
	bne.s	copy_loop2
copy_loopM2:
	tst.b	OldCPU
	bne.s	copy_loopL68000
	movem.l	d7/a4-a5,-(sp)
	lsr.w	#2,d7
copy_loopL
	move.l	(a5)+,(a4)+
	dbf	d7,copy_loopL
	movem.l	(sp)+,d7/a4-a5
	addq	#1,d7
	add.w	d7,a5
	add.w	d7,a4
	rts
copy_loopL68000
	move.b	(a5)+,(a4)+
	dbf	d7,copy_loopL68000
copy_loopex
	rts

copy_loop2:
	movem.l	d0/a2/a3,-(sp)
	moveq	#0,d0
	move.b	VolA(a6),d0
	lsl.w	#8,d0
	move.l	WorkPTR(pc),a2
	add.l	VolTabPTR(a2),d0
	move.b	#$40,MainVol(a6)
copy_loopL2
	move.b	(a5)+,d0
	move.l	d0,a3
	move.b	(a3),(a4)+
	dbf	d7,copy_loopL2
	movem.l	(sp)+,d0/a2/a3
	rts


nothing:
	tst.w	MainPeriod(a6)
	beq.s	nostopperiod
	move.w	#-1,MainPeriod(a6)
nostopperiod
	rts

sampleend:
	moveq	#0,d0
	clr.b	-1(a4)
clr_loop:
	move.b	d0,(a4)+
	dbf	d7,clr_loop
realsampleend:
	movem.l	(sp)+,d0-d1/a4-a5
	clr.l	(a2,d1.w)
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	clr.b	ReplaceEnable(a6)
	clr.b	BackWDenable(a6)
	rts

sampleloop:
	movem.l	d0-d4/a4-a5,-(sp)

	move.l	(a2,d1.w),a5
	move.l	124(a3,d1.w),d4
	add.l	(a3,d1.w),d4
	add.l	(a0,d1.w),d4

	cmp.l	d4,a5
	ble.s	NotSamEndL
	move.l	d4,(a2,d1.w)
	subq.l	#1,(a2,d1.w)
	move.l	d4,a5
	subq.l	#1,a5
NotSamEndL

	move.l	(a6),d7
	move.l	(a6),d2
	add.l	d3,d2
	cmp.l	BuffEndADR(a6),d2
	ble.w	NotEndBuff_L

	move.l	(a6),a4
	move.l	a5,d7
	add.l	d3,d7
	cmp.l	d4,d7
	ble.w	NoMakeLoop_EB

	sub.l	d4,d7			; loop
	move.w	d7,d4
	move.w	d3,d7
	sub.w	d4,d7

	sub.l	BuffEndADR(a6),d2
	move.w	d3,d0
	sub.w	d2,d0

	cmp.w	d0,d7
	bge.s	Copy_ToEndBuff
; d0=>d7 koniec buff pozniej niz petla

	move.l	BuffEndADR(a6),d2

	move.w	d3,d7
	subq	#1,d7
	move.l	124(a3,d1.w),d4
	add.l	(a3,d1.w),d4
	add.l	(a0,d1.w),d4

	move.l	(a3,d1.w),d0
	add.l	(a0,d1.w),d0
	tst.b	ConfMix
	bne.s	copy_loop3EBMH
	bra.s	copy_loop3EBML2
copy_loop4EBML2:
	move.l	d0,a5
copy_loop3EBML2:
	cmp.l	d4,a5
	bge.s	copy_loop4EBML2

	cmp.l	d2,a4
	blt.s	EBMLcont
	move.l	BuffBegADR(a6),(a6)
	move.l	(a6),a4
EBMLcont
	move.b	(a5)+,(a4)+
	dbf	d7,copy_loop3EBML2
	bra.w	MakeLoopEB_done

***********************************
copy_loop3EBMH:
	movem.l	d1/a1/a3,-(sp)
	moveq	#0,d1
	move.b	VolA(a6),d1
	lsl.w	#8,d1
	movea.l	WorkPTR(pc),a1
	add.l	VolTabPTR(a1),d1
	move.b	#$40,MainVol(a6)
	bra.s	copy_loop3EBMLH2
copy_loop4EBMLH2:
	move.l	d0,a5
copy_loop3EBMLH2:
	cmp.l	d4,a5
	bge.s	copy_loop4EBMLH2
	cmp.l	d2,a4
	blt.s	EBMLHcont
	move.l	BuffBegADR(a6),(a6)
	move.l	(a6),a4
EBMLHcont
	move.b	(a5)+,d1
	move.l	d1,a3
	move.b	(a3),(a4)+
	dbf	d7,copy_loop3EBMLH2
	movem.l	(sp)+,d1/a1/a3
	bra.s	MakeLoopEB_done
***********************************


Copy_ToEndBuff
	exg	d0,d7
	sub.w	d7,d0
	subq	#1,d7
	bsr	copy_loop
	move.l	BuffBegADR(a6),(a6)
	move.l	(a6),a4
	exg	d0,d7
	subq	#1,d7
	bsr	copy_loop

	move.w	d4,d7
	subq.w	#1,d7
	move.l	124(a3,d1.w),d4
	add.l	(a3,d1.w),d4
	add.l	(a0,d1.w),d4

	move.l	(a3,d1.w),d0
	add.l	(a0,d1.w),d0

	tst.b	ConfMix
	bne.s	copy_loop4EBMLHM

copy_loop4EBML:
	move.l	d0,a5
copy_loop3EBML:
	cmp.l	d4,a5
	bge.s	copy_loop4EBML
	move.b	(a5)+,(a4)+
	dbf	d7,copy_loop3EBML
	bra.s	MakeLoopEB_done

***********************************
copy_loop4EBMLHM:
	movem.l	d1/a1/a3,-(sp)
	moveq	#0,d1
	move.b	VolA(a6),d1
	lsl.w	#8,d1
	move.l	WorkPTR(pc),a1
	add.l	VolTabPTR(a1),d1
	move.b	#$40,MainVol(a6)
copy_loop4EBMLH:
	move.l	d0,a5
copy_loop3EBMLH:
	cmp.l	d4,a5
	bge.s	copy_loop4EBMLH
	move.b	(a5)+,d1
	move.l	d1,a3
	move.b	(a3),(a4)+
	dbf	d7,copy_loop3EBMLH
	movem.l	(sp)+,d1/a1/a3
***********************************

MakeLoopEB_done
	move.l	a4,(a6)
	move.l	a5,(a2,d1.w)
	movem.l	(sp)+,d0-d4/a4-a5
	bsr	Replace2
	rts

NoMakeLoop_EB
	sub.l	BuffEndADR(a6),d2
	move.w	d3,d7
	sub.w	d2,d7
	subq.w	#1,d7
	bsr	copy_loop

	move.l	BuffBegADR(a6),(a6)
	move.l	(a6),a4

	move.w	d2,d7
	subq.w	#1,d7
	bsr	copy_loop

	move.l	a4,(a6)
	move.l	a5,(a2,d1.w)
	movem.l	(sp)+,d0-d4/a4-a5
	bsr	Replace2
	rts

NotEndBuff_L
	move.l	(a6),a4
	move.l	a5,d7
	add.l	d3,d7

	cmp.l	d4,d7
	ble.s	NoMakeLoop

	sub.l	d4,d7
	move.w	d7,d4
	move.w	d3,d7
	sub.w	d4,d7
	subq.w	#1,d7
	bsr	copy_loop

	move.w	d4,d7
	subq.w	#1,d7

	move.l	124(a3,d1.w),d4
	add.l	(a3,d1.w),d4
	add.l	(a0,d1.w),d4

	move.l	(a3,d1.w),d0
	add.l	(a0,d1.w),d0
	tst.b	ConfMix
	bne.s	copy_loop4HM
copy_loop4:
	move.l	d0,a5
copy_loop3:
	cmp.l	d4,a5
	bge.s	copy_loop4
	move.b	(a5)+,(a4)+
	dbf	d7,copy_loop3
	bra.s	copy_loopHdone
***********************************
copy_loop4HM:
	movem.l	d1/a1/a3,-(sp)
	moveq	#0,d1
	move.b	VolA(a6),d1
	lsl.w	#8,d1
	move.l	WorkPTR(pc),a1
	add.l	VolTabPTR(a1),d1
	move.b	#$40,MainVol(a6)
copy_loop4H:
	move.l	d0,a5
copy_loop3H:
	cmp.l	d4,a5
	bge.s	copy_loop4H
	move.b	(a5)+,d1
	move.l	d1,a3
	move.b	(a3),(a4)+
	dbf	d7,copy_loop3H
	movem.l	(sp)+,d1/a1/a3
***********************************

copy_loopHdone:
	move.l	a4,(a6)
	move.l	a5,(a2,d1.w)
	movem.l	(sp)+,d0-d4/a4-a5
	bsr	Replace2
	rts

NoMakeLoop
	move.w	d3,d7
	subq	#1,d7
	bsr	copy_loop
	move.l	a4,(a6)
	move.l	a5,(a2,d1.w)
	movem.l	(sp)+,d0-d4/a4-a5
	bsr	Replace2
	rts

TestPeriod:
	cmp.w	#113,d0
	bge.s	OKKI1
	tst.w	d0
	beq.s	OKKI1
	moveq	#113,d0
OKKI1	cmp.w	#113,d4
	bge.s	OKKI2
	tst.w	d4
	beq.s	OKKI2
	moveq	#113,d4
OKKI2	tst.w	d0
	bne.s	OKKI3
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
OKKI3	tst.w	d4
	bne.s	OKKI4
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
OKKI4	rts
; --------------------------- EffectCommands ---------------------------

EffectCommandsA2:
; effects 9xx, bxx, cxx, dxx, fxx chan A

	move.w	d2,d7
	beq	EffComA2exit
	lsr.w	#8,d7
	clr.b	channelenable
	move.w	d2,d3

	lea	SamOffsetA(a6),a5
	cmp.b	#9,d7
	beq	SampleOffset

	cmp.b	#$b,d7
	beq	SongRepeat

	lea	VolA(a6),a5
	cmp.b	#$c,d7
	beq	SetVolume

	lea	Hex(pc),a5
	cmp.b	#$d,d7
	beq	PattBreak

	cmp.b	#$f,d7
	beq	SetTempo

; effects E0x, E1x, E2x, E6x, E8x, EAx, EBx EEx chan A

	cmp.w	#$e00,d3
	beq.w	OffFilter

	cmp.w	#$e01,d3
	beq.w	OnFilter

	cmp.w	#$e50,d3
	beq.w	OffChannelA

	cmp.w	#$e51,d3
	beq.w	OnChannelA

	move.w	d2,d7
	lsr.w	#4,d7
	move.w	d2,d3

	cmp.b	#$e1,d7
	beq.w	FineSlideUp

	cmp.b	#$e2,d7
	beq.w	FineSlideDown

	lea	loopsdataschanA(a6),a5
	cmp.b	#$e6,d7
	beq.w	loops

	lea	SamOffsetA(a6),a5
	cmp.b	#$e8,d7
	beq	offsets

	lea	VolA(a6),a5
	cmp.b	#$ea,d7
	beq	FineVolUp

	cmp.b	#$eb,d7
	beq	FineVolDown

	cmp.b	#$ee,d7
	beq	Pause
EffComA2exit
	rts

EffectCommandsB2:
; effects 9xx, bxx, cxx, dxx, fxx chan B

	move.w	d6,d7
	beq	EffComB2exit
	lsr.w	#8,d7
	move.b	#1,channelenable
	move.w	d6,d3

	lea	SamOffsetB(a6),a5
	cmp.b	#9,d7
	beq	SampleOffset

	cmp.b	#$b,d7
	beq	SongRepeat

	lea	VolB(a6),a5
	cmp.b	#$c,d7
	beq	SetVolume

	lea	Hex(pc),a5
	cmp.b	#$d,d7
	beq	PattBreak

	cmp.b	#$f,d7
	beq	SetTempo

; effects E0x, E1x, E2x, E6x, E8x, EAx, EBx EEx chan B

	cmp.w	#$e00,d3
	beq.w	OffFilter

	cmp.w	#$e01,d3
	beq.w	OnFilter

	cmp.w	#$e50,d3
	beq.w	OffChannelB

	cmp.w	#$e51,d3
	beq.w	OnChannelB

	move.w	d6,d7
	lsr.w	#4,d7
	move.w	d6,d3

	cmp.b	#$e1,d7
	beq.w	FineSlideUp

	cmp.b	#$e2,d7
	beq.w	FineSlideDown

	lea	loopsdataschanB(a6),a5
	cmp.b	#$e6,d7
	beq.w	loops

	lea	SamOffsetB(a6),a5
	cmp.b	#$e8,d7
	beq	offsets

	lea	VolB(a6),a5
	cmp.b	#$ea,d7
	beq	FineVolUp

	cmp.b	#$eb,d7
	beq	FineVolDown

	cmp.b	#$ee,d7
	beq	Pause
EffComB2exit
	rts




EffectCommandsA:
; effects 0xx 1xx, 2xx, 3xx, 4xx, 5xx, 6xx, axx, chan A
	move.w	d2,d7
	beq	EffComAexit
	lsr.w	#8,d7
	clr.b	channelenable
	move.w	d2,d3

	lea	OrgPeriodA(a6),a5
	tst.b	d7
	beq.w	Arpeggio

	cmp.b	#1,d7
	beq.w	PortUp

	cmp.b	#2,d7
	beq.w	PortDown

	lea	GlissandoDatasA(a6),a5
	cmp.b	#3,d7
	beq.w	Glissando

	lea	VibratoDatasA(a6),a5
	cmp.b	#4,d7
	beq.w	Vibrato

	cmp.b	#5,d7
	beq.w	SlideVolGliss

	cmp.b	#6,d7
	beq.w	SlideVolVib

	lea	VolA(a6),a5
	cmp.b	#$a,d7
	beq	SlideVolume

; effects E9x, ECx chan A

	move.w	d2,d7
	lsr.w	#4,d7
	move.w	d2,d3

	lea	RetraceCntA(a6),a5
	cmp.b	#$e9,d7
	beq.w	Retrace

	lea	VolA(a6),a5
	cmp.b	#$ec,d7
	beq	cutsample
EffComAexit
	rts


EffectCommandsB:
; effects 1xx, 2xx, 3xx, 4xx, 5xx, 6xx, axx, chan B
	move.w	d6,d7
	beq	EffComBexit
	lsr.w	#8,d7
	move.b	#1,channelenable
	move.w	d6,d3

	lea	OrgPeriodB(a6),a5
	tst.b	d7
	beq.w	Arpeggio

	cmp.b	#1,d7
	beq.w	PortUp

	cmp.b	#2,d7
	beq.w	PortDown

	lea	GlissandoDatasB(a6),a5
	cmp.b	#3,d7
	beq.w	Glissando

	lea	VibratoDatasB(a6),a5
	cmp.b	#4,d7
	beq.w	Vibrato

	cmp.b	#5,d7
	beq.w	SlideVolGliss

	cmp.b	#6,d7
	beq.w	SlideVolVib

	lea	VolB(a6),a5
	cmp.b	#$a,d7
	beq	SlideVolume

; effects E9x, ECx chan B

	move.w	d6,d7
	lsr.w	#4,d7
	move.w	d6,d3

	lea	RetraceCntB(a6),a5
	cmp.b	#$e9,d7
	beq.w	Retrace

	lea	VolB(a6),a5
	cmp.b	#$ec,d7
	beq	cutsample
EffComBexit
	rts

;------------------------------ effects -------------------------------------

;looppattpos	(a5)
;loopsongpos	1(a5)
;loophowmany	2(a5)

loops:
	cmp.w	#$e60,d3
	bne.s	no_loop
	tst.b	2(a5)
	bne.s	loops_done
	move.b	PattPos(pc),(a5)
	subq.b	#1,(a5)
	move.b	SongPos(pc),1(a5)
	bra.s	loops_done
no_loop
	tst.b	2(a5)
	beq.s	storehowmany
	subq.b	#1,2(a5)
	bne.s	no_done
	clr.b	(a5)
	clr.b	1(a5)
	clr.b	2(a5)
	bra.s	loops_done
no_done
	move.b	(a5),PattPos
	move.b	1(a5),SongPos
	bra.s	loops_done
storehowmany
	and.b	#$0f,d3
	move.b	d3,2(a5)
	move.b	(a5),PattPos
	move.b	1(a5),SongPos
loops_done
	rts

Pause:
	tst.b	PauseEn
	bne.s	no_pause

	moveq	#0,d7
	move.b	d3,d7
	and.b	#$0f,d7
	beq.s	no_pause
	moveq	#0,d3
	move.b	temp(pc),d3
	mulu	d3,d7
	addq.w	#1,d7
	move.w	d7,PauseVBL
no_pause
	rts

SongRepeat:
	move.b	#-1,PattPos
	moveq	#0,d7
	move.b	d3,d7
	cmp.w	#$7f,d7
	blt.s	songrep_ok
	move.b	#$7f,d7
songrep_ok
	move.b	d7,SongPos
	rts

PattBreak:
	moveq	#0,d7
	move.b	d3,d7
	cmp.w	#$63,d7
	blt.s	patt_ok
	move.b	#$63,d7
patt_ok
	cmp.b	#-1,PattPos
	beq.s	NoAddSP
	addq.b	#1,SongPos
NoAddSP
	move.b	(a5,d7.w),d7
	move.b	d7,PattPos
	subq.b	#1,PattPos
	rts

SampleOffset:
	moveq	#0,d7
	move.b	(a5),d7
	lsl.w	#8,d7
	lsl.l	#8,d7
	and.w	#$00ff,d3
	lsl.w	#8,d3
	add.w	d3,d7
	tst.b	channelenable
	bne.s	SamOffsChanB
	add.l	d7,(a2,d1.w)
	rts
SamOffsChanB
	add.l	d7,124(a2,d5.w)
	rts


offsets:
	move.b	d3,d7
	and.b	#$0f,d7
	move.b	d7,(a5)
	rts

SetTempo:
	moveq	#0,d7
	move.b	d3,d7
	cmp.w	#$1f,d7
	bgt.s	Cia_temp
	move.b	d3,temp
	move.b	d3,count
	rts
Cia_temp
	tst.l	CiaBase
	beq.s	NoCia_Temp
	move.w	d7,CiaTempo
	move.w	#1,CiaChanged
NoCia_Temp
	rts

OffChannelA:
	bset	#0,OnOffChanA(a6)
	rts
OnChannelA:
	bclr	#0,OnOffChanA(a6)
	rts
OffChannelB:
	bset	#0,OnOffChanB(a6)
	rts
OnChannelB:
	bclr	#0,OnOffChanB(a6)
	rts

OffFilter:
	bclr	#1,$bfe001
	rts
OnFilter:
	bset	#1,$bfe001
	rts



Retrace:
	cmp.b	#1,count
	bne.s	retrno_2
	clr.b	(a5)
retrno_2
	moveq	#0,d7
	move.b	d3,d7
	and.b	#$0f,d7
	subq.b	#1,d7
	cmp.b	(a5),d7
	bne.s	retrno_1

	tst.b	channelenable
	beq.s	retr_chan_a
	move.l	(a0,d5.w),124(a2,d5.w)	; adres sampla
	move.b	#1,OffEnable(a6)
	bra.s	retr_chan_b
retr_chan_a
	move.b	#1,OffEnable(a6)
	move.l	(a0,d1.w),(a2,d1.w)	; adres sampla
retr_chan_b
	clr.b	(a5)
	rts
retrno_1
	addq.b	#1,(a5)
no_retrace_1
	rts

cutsample:
	moveq	#0,d7
	move.b	d3,d7
	and.b	#$0f,d7
	cmp.b	count(pc),d7
	bne.s	no_cut_sam
	clr.b	(a5)
no_cut_sam:
	rts

; ------------- arpeggio -------------
arplist:
	dc.b 0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1
Arpeggio:
	movem.l	d2/a6,-(sp)
	bsr	ArpeggioMain
	movem.l	(sp)+,d2/a6
	rts

ArpeggioMain:
	moveq	#0,d7
	move.b	count(pc),d7
	subq.b	#1,d7

	move.b	arplist(pc,d7.w),d7
	beq.s	arp0
	cmp.b	#2,d7
	beq.s	arp2

arp1:	moveq	#0,d2
	move.b	d3,d2
	lsr.b	#4,d2
	bra.s	arpdo

arp2:	moveq	#0,d2
	move.b	d3,d2
	and.b	#$f,d2
arpdo:
	asl.w	#1,d2
	move.w	(a5),d7
	lea	Periods(pc),a6
	moveq	#36,d3
arp3:	cmp.w	(a6)+,d7
	bge.s	arpfound
	dbf	d3,arp3
arp0:
	tst.b	channelenable
	bne.s	ARP_chanB1
	move.w	(a5),d0
	rts
ARP_chanB1
	move.w	(a5),d4
	rts
arpfound:
	add.w	d2,a6
	cmp.l	#PeriodsEnd,a6
	ble.s	ArpOk1
	move.l	#PeriodsEnd,a6
	moveq	#0,d2
	bra.s	ArpOk2
ArpOk1	sub.w	d2,a6
ArpOk2	tst.b	channelenable
	bne.s	ARP_chanB2
	move.w	-2(a6,d2.w),d0
	rts
ARP_chanB2
	move.w	-2(a6,d2.w),d4
	rts

; ------------- portamento up -------------

PortUp:
	moveq	#0,d7
	move.b	d3,d7

	tst.b	channelenable
	bne.s	PortUp_chan_b
	
PortUp_chan_a
	tst.b	d7
	bne.s	NoOldPortUpA
	move.b	PortUpOldValA(a6),d7
NoOldPortUpA
	move.b	d7,PortUpOldValA(a6)
	sub.w	d7,d0
	cmp.w	#113,d0
	bge.s	PortUpOkA
	move.w	#113,d0
PortUpOkA
	rts

PortUp_chan_b
	tst.b	d7
	bne.s	NoOldPortUpB
	move.b	PortUpOldValB(a6),d7
NoOldPortUpB
	move.b	d7,PortUpOldValB(a6)
	sub.w	d7,d4
	cmp.w	#113,d4
	bge.s	PortUpOkB
	move.w	#113,d4
PortUpOkB
	rts
NoPortUp:
	rts

; ------------- portamento down -------------
PortDown:
	moveq	#0,d7
	move.b	d3,d7

	tst.b	channelenable
	bne.s	PortDown_chan_b
PortDown_chan_a
	tst.b	d7
	bne.s	NoOldPortDownA
	move.b	PortDownOldValA(a6),d7
NoOldPortDownA
	move.b	d7,PortDownOldValA(a6)
	add.w	d7,d0
	cmp.w	#856,d0
	ble.s	PortDownOkA
	move.w	#856,d0
PortDownOkA
	rts

PortDown_chan_b
	tst.b	d7
	bne.s	NoOldPortDownB
	move.b	PortDownOldValB(a6),d7
NoOldPortDownB
	move.b	d7,PortDownOldValB(a6)
	add.w	d7,d4
	cmp.w	#856,d4
	ble.s	PortDownOkB
	move.w	#856,d4
PortDownOkB
	rts
noPortDown:
	rts

; --------------- set volume  -------------
SetVolume:
	move.b	d3,(a5)
	rts

; --------------- slide volume up -------------
SlideVolume:
	tst.b	d3
	bne.s	NoOldSlideVol
	move.b	2(a5),d3	; Old SlideVolVolue
NoOldSlideVol
	move.b	d3,2(a5)

	moveq	#0,d7
	move.b	d3,d7
	cmp.w	#$10,d7
	blt.s	Voldown
	lsr.b	#4,d7
	add.b	d7,(a5)
	cmp.b	#64,(a5)
	blt.s	Voldone
	move.b	#64,(a5)
	rts
Voldown
	sub.b	d3,(a5)
	tst.b	(a5)
	bgt.s	Voldone
	clr.b	(a5)
Voldone:rts


; --------------- fine slide down -------------
FineSlideDown:
	move.w	d3,d7
	and.w	#$000f,d7

	tst.b	channelenable
	bne.s	FineSlideDownB

	add.w	d7,d0
	cmp.w	#856,d0
	ble.s	FineSlideDownOkA
	move.w	#856,d0
FineSlideDownOkA
	moveq	#0,d2
	rts

FineSlideDownB
	add.w	d7,d4
	cmp.w	#856,d4
	ble.s	FineSlideDownOkB
	move.w	#856,d4
FineSlideDownOkB
	moveq	#0,d6
	rts

; --------------- fine slide up -------------
FineSlideUp:
	move.w	d3,d7
	and.w	#$000f,d7

	tst.b	channelenable
	bne.s	FineSlideUpB

	sub.w	d7,d0
	cmp.w	#113,d0
	bge.s	FineSlideUpOkA
	move.w	#113,d0
FineSlideUpOkA
	moveq	#0,d2
	rts

FineSlideUpB
	sub.w	d7,d4
	cmp.w	#113,d4
	bge.s	FineSlideUpOkB
	move.w	#113,d4
FineSlideUpOkB
	moveq	#0,d6
	rts

; --------------- fine volume up  -------------
FineVolUp:
	move.w	d3,d7
	and.b	#$0f,d7
	add.b	d7,(a5)
	cmp.b	#64,(a5)
	blt.s	FVUOK
	move.b	#64,(a5)
FVUOK
	tst.b	channelenable
	bne.s	FVUClrVolB
	moveq	#0,d2
	rts
FVUClrVolB
	moveq	#0,d6
	rts


; --------------- fine volume down  -------------
FineVolDown:
	move.w	d3,d7
	and.b	#$0f,d7
	sub.b	d7,(a5)
	tst.b	(a5)
	bge.s	FVDOK
	clr.b	(a5)
FVDOK
	tst.b	channelenable
	bne.s	FVDClrVolB
	moveq	#0,d2
	rts
FVDClrVolB
	moveq	#0,d6
NoFVD	rts


; ------------- glissando -------------

;GlissOldValue:		 (a5)
;GlissEnable:		1(a5)
;GlissOldPeriod:	2(a5)
;GlissNewPeriod:	4(a5)

Glissando:
	move.w	d3,d7
	tst.b	d3
	bne.s	NoOLDgliss
	move.b	(a5),d3
NoOLDgliss

	cmp.b	#1,count
	bne.s	NoStore
	move.b	d3,(a5)
NoStore

	tst.w	2(a5)
	beq.w	GlissRTS

	tst.b	channelenable
	bne.s	GlissOK1B

GlissOK1A:
	tst.w	4(a5)
	bne.s	GlissOk2
	move.w	d0,d7
	move.w	d0,4(a5)
	move.w	2(a5),d0
	clr.b	1(a5)
	cmp.w	d0,d7
	beq.s	ClrNP
	bge.w	GlissRTS
	move.b	#1,1(a5)
	rts

GlissOK1B:
	tst.w	4(a5)
	bne.s	GlissOk2
	move.w	d4,d7
	move.w	d4,4(a5)
	move.w	2(a5),d4
	clr.b	1(a5)
	cmp.w	d4,d7
	beq.s	ClrNP
	bge.s	GlissRTS
	move.b	#1,1(a5)
	rts

ClrNP:	clr.w	4(a5)
	rts

GlissOk2:
	move.w	d3,d7
	and.w	#$0ff,d7
	tst.w	4(a5)
	beq.s	GlissRTS
	tst.b	1(a5)
	bne.s	Glisssub
	add.w	d7,2(a5)
	move.w	4(a5),d7
	cmp.w	2(a5),d7
	bgt.s	GlissOK3
	move.w	4(a5),2(a5)
	clr.w	4(a5)
GlissOK3:
	tst.b	channelenable
	bne.s	GlissChanB
GlissChanA
	move.w	2(a5),d0
	rts
GlissChanB
	move.w	2(a5),d4
	rts

Glisssub:
	sub.w	d7,2(a5)
	move.w	4(a5),d7
	cmp.w	2(a5),d7
	blt.s	GlissOK3
	move.w	4(a5),2(a5)
	clr.w	4(a5)
	bra.s	GlissOK3

GlissRTS:
	rts

SlideVolGliss:
	and.w	#$00ff,d3
	add.w	#$a00,d3
	tst.b	channelenable
	bne.s	SlideChanB
	lea	VolA(a6),a5
	bra.s	DoSlideChan
SlideChanB
	lea	VolB(a6),a5
DoSlideChan
	bsr	SlideVolume

	move.w	#$0300,d3
	tst.b	channelenable
	bne.s	GlissBChan
	lea	GlissandoDatasA(a6),a5
	bra.s	DoGlissChan
GlissBChan
	lea	GlissandoDatasB(a6),a5
DoGlissChan
	bra	Glissando


SlideVolVib:
	and.w	#$00ff,d3
	add.w	#$a00,d3
	tst.b	channelenable
	bne.s	SlideChanBV
	lea	VolA(a6),a5
	bra.s	DoSlideChanV
SlideChanBV
	lea	VolB(a6),a5
DoSlideChanV
	bsr	SlideVolume

	move.w	#$0400,d3
	tst.b	channelenable
	bne.s	VibBChan
	lea	VibratoDatasA(a6),a5
	bra.s	DoVibChan
VibBChan
	lea	VibratoDatasB(a6),a5
DoVibChan
	bra	Vibrato




;VibPeriod	(a5)
;VibValue	2(a5)
;ViboldValue	3(a5)

Vibrato:
	movem.l	d2/d5,-(sp)

	move.w	d4,d2
	tst.b	channelenable
	bne.s	VibCHANB1
	move.w	d0,d2
VibCHANB1
	bsr	VibratoMain
	tst.b	channelenable
	bne.s	VibCHANB2
	move.w	d2,d0
	bra.s	VibMainDone
VibCHANB2
	move.w	d2,d4
VibMainDone
	movem.l	(sp)+,d2/d5
	rts

VibratoMain:
	move.b	count(pc),d7
	cmp.b	temp(pc),d7
	bne.s	NoNewPeriod
	tst.w	(a5)
	bne.s	NoNewPeriod
	move.w	d2,(a5)
NoNewPeriod
	move.w	(a5),d2
	move.b	temp(pc),d7
	subq	#1,d7
	cmp.b	count(pc),d7
	bne.s	DoVibrato
	clr.w	(a5)
	rts
DoVibrato
	move.b	d3,d5
	and.b	#$0f,d5
	bne.s	NoNew1
	move.b	3(a5),d5
	and.b	#$0f,d5
	add.b	d5,d3
NoNew1
	move.b	d3,d5
	and.b	#$f0,d5
	bne.s	NoNew2
	move.b	3(a5),d5
	and.b	#$f0,d5
	add.b	d5,d3
NoNew2
	move.w	d3,-(sp)

	move.b	d3,3(a5)

	move.b	d3,d7
	move.b	2(a5),d3
	lsr.w	#2,d3
	and.w	#$1f,d3
	moveq	#0,d5
	move.b	VibSin(pc,d3.w),d5

	move.b	d7,d3
	and.w	#$f,d3
	mulu	d3,d5
	lsr.w	#7,d5

	tst.b	2(a5)
	bmi.s	VibSub
	add.w	d5,d2
	bra.s	VibNext
VibSub:
	sub.w	d5,d2
VibNext:
	move.w	d2,d5
	move.b	d7,d5
	lsr.w	#2,d5
	and.w	#$3c,d5
	add.b	d5,2(a5)
	move.w	(sp)+,d3
	rts
VibSin:
	dc.b	$00,$18,$31,$4a,$61,$78,$8d,$a1,$b4,$c5,$d4,$e0,$eb,$f4,$fa,$fd
	dc.b	$ff,$fd,$fa,$f4,$eb,$e0,$d4,$c5,$b4,$a1,$8d,$78,$61,$4a,$31,$18

Calc:	tst.b	OldCPU
	bne.s	OldCpuRout
	tst.b	Fast
	beq.s	OldCpuRout
	move.l	#35795*2*125,d3
	moveq	#0,d7
	move.w	CiaTempo(pc),d7
	divu.l	d7,d3
	divu	d0,d3
	and.l	#$ffff,d3
	addq	#1,d3
	rts
OldCpuRout
	cmp.w	#70,CiaTempo
	ble.s	NewRout
	move.l	#35795*125,d3
	divu	CiaTempo(pc),d3
	and.l	#$ffff,d3
	divu	d0,d3
	and.l	#$ffff,d3
	add.w	d3,d3
	addq	#2,d3
	rts
NewRout:move.l	#35795*125/4,d3
	divu	CiaTempo(pc),d3
	and.l	#$ffff,d3
	lsl.l	#2,d3
	divu	d0,d3
	and.l	#$ffff,d3
	add.w	d3,d3
	addq	#2,d3
	rts

mixing:
	move.w	d0,MixPeriodA
	move.w	d4,MixPeriodB

	bsr	Calc
	movem.l	d0-d6/a0-a4,-(sp)

	move.l	(a2,d1.w),a0

	tst.b	OldCPU
	bne.s	OldCpuRout2
	tst.b	Fast
	beq.s	OldCpuRout2
	move.l	#35795*2*125,d0
	moveq	#0,d7
	move.w	CiaTempo(pc),d7
	divu.l	d7,d0
	divu	d4,d0
	and.l	#$ffff,d0
	addq	#1,d0
	bra.s	RoutDone
OldCpuRout2
	cmp.w	#70,CiaTempo
	ble.s	NewRout2
	move.l	#35795*125,d0
	divu	CiaTempo(pc),d0
	and.l	#$ffff,d0
	bra.s	NewRout3
NewRout2
	move.l	#35795*125/4,d0
	divu	CiaTempo(pc),d0
	and.l	#$ffff,d0
	lsl.l	#2,d0
NewRout3
	divu	d4,d0
	and.l	#$ffff,d0
	add.w	d0,d0
	addq	#2,d0
RoutDone:

	move.l	124(a2,d5.w),a1
	move.l	d0,d4
	cmp.w	d3,d4
	ble	noreplace

	add.l	d0,124(a2,d5.w)
	exg	d1,d5
	lea	-124(a2),a2

	exg	d3,d4
	exg	d2,d6
	exg	a0,a1
	move.w	d3,leng
	move.b	VolA(a6),d7
	move.b	VolB(a6),VolA(a6)
	move.b	d7,VolB(a6)

	bsr	mix
	movem.l	(sp)+,d0-d6/a0-a4

	move.w	leng(pc),d3
	exg	d0,d4
	bsr	play
	exg	d0,d4
	move.b	VolA(a6),d7
	move.b	VolB(a6),VolA(a6)
	move.b	d7,VolB(a6)

	tst.b	ChangeAdr(a6)
	beq.s	nochadr1
	move.l	SamRep2(a6),124(a2,d5.w)
nochadr1:
	cmp.b	#1,MixDon(a6)
	beq.s	offsam1
	rts

offsam1:clr.l	(a2,d1.w)
	clr.l	124(a2,d5.w)
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	clr.b	MixDon(a6)
	rts

noreplace
	add.l	d3,(a2,d1.w)
	bsr	mix

	movem.l	(sp)+,d0-d6/a0-a4

	bsr	play

	tst.b	ChangeAdr(a6)
	beq.s	nochadr2
	move.l	SamRep2(a6),(a2,d1.w)
nochadr2:
	cmp.b	#1,MixDon(a6)
	beq.s	offsam1
	rts


; --------------- robot -------------

MakeBuff_ROBOT:
	move.b	#1,MBRPointer(a6)

	tst.l	124(a3,d1.w)
	bne	sampleloop_R

	movem.l	d0-d1/a4-a5,-(sp)
	move.l	BuffMixADR(a6),a4
	move.l	124(a0,d1.w),d0
	add.l	(a0,d1.w),d0
	move.w	d3,d7
	subq	#1,d7
	move.l	(a2,d1.w),a5
	cmp.l	d0,a5
	bgt	realsampleend
	move.l	a5,d1
copy_loop_R:
	cmp.l	d0,a5
	bgt	sampleend
	move.b	(a5)+,(a4)+
	dbf	d7,copy_loop_R
	movem.l	(sp)+,d0-d1/a4-a5
	add.l	d3,(a2,d1.w)
	rts

sampleloop_R:
	movem.l	d0-d4/a4-a5,-(sp)
	move.l	124(a3,d1.w),d4
	add.l	(a3,d1.w),d4
	add.l	(a0,d1.w),d4

	move.w	d3,d7
	subq	#1,d7
	move.l	(a2,d1.w),a5
	move.l	BuffMixADR(a6),a4
copy_loop2_R:
	cmp.l	d4,a5
	bge.s	makeloop_R
	move.b	(a5)+,(a4)+
	dbf	d7,copy_loop2_R
	movem.l	(sp)+,d0-d4/a4-a5
	add.l	d3,(a2,d1.w)
	rts

makeloop_R:
	move.l	(a3,d1.w),d0
	add.l	(a0,d1.w),d0
copy_loop4_R:
	move.l	d0,a5
copy_loop3_R:
	cmp.l	d4,a5
	bge.s	copy_loop4_R
	move.b	(a5)+,(a4)+
	dbf	d7,copy_loop3_R
	move.l	a5,(a2,d1.w)
	movem.l	(sp)+,d0-d4/a4-a5
	rts

RobotEffect:
	tst.b	RobotEnable(a6)
	bne.s	NoROffCH
	move.b	#1,OffEnable(a6)
NoROffCH
	move.b	#1,RobotEnable(a6)
	bsr	MakeBuff_ROBOT

	tst.b	Fast
	beq.s	NoCopyFromFAST3
	bsr	CopyFromFAST
	move.l	(a6),BuffMixADR(a6)
	move.b	#1,MBRPointer(a6)
NoCopyFromFAST3

	move.w	d3,MainDTALEN(a6)
	bsr	RobotMain
	bsr	Replace_R
	rts

RobotMain:
	tst.b	d2
	bne.s	NoOldRobot
	move.b	RobotOldVal(a6),d2
NoOldRobot
	move.b	d2,RobotOldVal(a6)

	moveq	#0,d7
	move.b	d2,d7
	add.w	#80,d7

	move.w	d3,d4
	lsr.w	#6,d4
	lsr.w	#2,d7
	mulu	d7,d4

	cmp.w	d4,d3
	ble.s	CLRrobot
	sub.w	d4,d3
	addq	#1,d3
	bra.s	NoRobot
CLRrobot:
	moveq	#2,d3
NoRobot:
	moveq	#0,d4
	rts


play:	move.w	d0,MainPeriod(a6)
	move.b	#$40,MainVol(a6)

	cmp.b	#1,OffEnable(a6)
	bne.w	NoSet3OnEn
	cmp.w	MainDTALEN(a6),d3
	beq.s	NoSet3OnEn
	move.b	#1,OffEnable(a6)
	clr.w	NoteCount(a6)
	move.l	BuffBegADR(a6),(a6)
	bra.s	NoSet2OnEn
NoSet3OnEn
	cmp.b	#2,OffEnable(a6)	; jesli jedn. dwa mix sampl. to wait
	bne.w	NoSet1OnEn
	move.b	#1,OffEnable(a6)
	clr.w	NoteCount(a6)
	move.l	BuffBegADR(a6),(a6)
	bra.s	NoSet2OnEn
NoSet1OnEn
	cmp.b	#1,OffEnable(a6)
	bne.s	NoSet4OnEn
	cmp.w	#100,NoteCount(a6)
	blt.s	NoSet4OnEn
	clr.w	NoteCount(a6)
	move.l	BuffBegADR(a6),(a6)
	bra.s	NoSet2OnEn
NoSet4OnEn
	clr.b	OffEnable(a6)
	tst.b	Fast
	bne.s	NoSet2OnEn
	tst.b	PlayPointer(a6)
	beq.s	NoSet2OnEn
	clr.b	PlayPointer(a6)
	move.b	#1,OffEnable(a6)
	clr.w	NoteCount(a6)
	move.l	BuffBegADR(a6),(a6)
NoSet2OnEn
	move.w	d3,MainDTALEN(a6)
	tst.b	Fast
	bne.s	CopyFromFAST
	rts

CopyFromFAST:
	move.b	#2,MBRPointer(a6)
	movem.l	d0-a6,-(sp)

	move.l	BuffMixADR(a6),a5
	move.l	(a6),d1
	and.l	#$ffff,d3
	add.l	d3,d1
	cmp.l	BuffEndADR(a6),d1
	ble.s	NotEndBufM
	sub.l	BuffEndADR(a6),d1
	move.w	d3,d7
	sub.w	d1,d7
	subq.w	#1,d7
	move.l	(a6),a4
	bsr	copy_loopM
	move.l	BuffBegADR(a6),(a6)
	move.l	(a6),a4
	move.w	d1,d7
	subq.w	#1,d7
	bsr	copy_loopM
	bra.s	CopyDoneM
NotEndBufM
	move.l	(a6),a4
	moveq	#0,d7
	move.w	d3,d7
	subq	#1,d7
	bsr	copy_loopM
CopyDoneM
	move.l	a4,(a6)
	movem.l	(sp)+,d0-a6
	rts

db_end:
	lea	$dff000,a0
	move.w	#$f,$96(a0)
	clr.w	$a8(a0)
	clr.w	$b8(a0)
	clr.w	$c8(a0)
	clr.w	$d8(a0)
	bsr	FreeMixBuffers
	bsr	FreeChipBuffs
	bsr	FreeWorkBuff
	lea	Ended(pc),a0
	st	(a0)
	moveq	#0,d0
	lea	Enabled(pc),a0
	move.b	d0,(a0)
	lea	Channel1+MainVol(pc),a0
	move.b	d0,(a0)
	move.b	d0,ChanArea(a0)
	move.b	d0,ChanArea*2(a0)
	move.b	d0,ChanArea*3(a0)
	rts

GETVOL1:MACRO
	move.b	(a0)+,d1
	move.l	d1,a4
	move.b	(a4),d1
	ENDM

GETVOL2:MACRO
	move.b	(a1)+,d0
	move.l	d0,a5
	move.b	(a5),d0
	ENDM

mix:
	move.b	#1,MBRPointer(a6)

	movem.l	d5/a2,-(sp)
	move.l	WorkPTR(pc),a4
	lea	sample_starts(a4),a4
	lea	(a3),a5			; smaple repeats

	move.l	BuffMixADR(a6),a2
	moveq	#0,d2
	move.w	d4,d2
	move.w	d3,d7
	subq	#1,d7

	moveq	#0,d0
	move.b	VolA(a6),d0
	cmp.w	#$40,d0
	ble.s	mix_volok1
	move.b	#$40,VolA(a6)
mix_volok1
	moveq	#0,d0
	move.b	VolB(a6),d0
	cmp.w	#$40,d0
	ble.s	mix_volok2
	move.b	#$40,VolB(a6)
mix_volok2

	move.b	OldCPU(pc),d6
	beq.s	_68020
	move.l	d3,d6
	lsl.l	#8,d6
	lsl.l	#4,d6
	divu.w	d2,d6
	and.l	#$ffff,d6
	lsl.l	#4,d6
	bra.s	_68000
_68020:
	move.l	d3,d6
	swap	d6
	divu.l	d2,d6
_68000:
	tst.l	124(a5,d1.w)
	beq.s	nosamloop2
	move.l	(a5,d1.w),d4
	add.l	124(a5,d1.w),d4
	add.l	(a4,d1.w),d4
	tst.l	124(a5,d5.w)
	bne.s	doubleloop
	bra.w	samloopmix2
doubleloop
	move.l	(a5,d5.w),d0
	add.l	124(a5,d5.w),d0
	add.l	(a4,d5.w),d0
	bra.w	samloopmix3
nosamloop2:

	move.l	124(a4,d1.w),d4
	add.l	(a4,d1.w),d4

	tst.l	124(a5,d5.w)
	beq.s	nosamloop1
	move.l	(a5,d5.w),d0
	add.l	124(a5,d5.w),d0
	add.l	(a4,d5.w),d0
	bra.w	samloopmix1
nosamloop1:
	move.l	124(a4,d5.w),d0
	add.l	(a4,d5.w),d0
	move.l	d0,d5

; -------------- mixing norm. sample + norm. sample
	movem.l	d3-d4,-(sp)

	moveq	#0,d0
	moveq	#0,d1
	move.b	VolA(a6),d0
	move.b	VolB(a6),d1
	lsl.w	#8,d0
	lsl.w	#8,d1
	move.l	WorkPTR(pc),a5
	move.l	VolTabPTR(a5),a4
	move.l	a4,a5
	add.l	d0,a4
	add.l	d1,a5

	cmp.l	d4,a0
	bge.w	sammixloop1_11

	cmp.l	d5,a1
	bge.w	sammixloop1_111

	move.l	a0,d0
	add.l	d3,d0
	cmp.l	d4,d0
	bge.w	sammixloop1_1111

	move.l	a1,d1
	add.l	d2,d1
	cmp.l	d5,d1
	bge.w	sammixloop1_1111

sammixloop1_1:
	move.l	a4,d1
	move.l	a5,d0
	move.l	d6,d2
	move.l	d6,d3
	move.l	#$10000,d4
mixloop1_1:
	GETVOL1
	add.l	d4,d2
	cmp.l	d2,d3
	ble.s	newdata1_1
	add.b	d0,d1
	move.b	d1,(a2)+
	dbf	d7,mixloop1_1
	bra.w	mixdone
newdata1_1:
	add.l	d6,d3
	GETVOL2
	add.b	d0,d1
	move.b	d1,(a2)+
	dbf	d7,mixloop1_1
	bra.w	mixdone

;				 test d5,a1

sammixloop1_11:
	move.l	a4,d1
	move.l	a5,d0
	move.l	d6,d2
	move.l	d6,d3
	move.l	#$10000,d4
mixloop1_11:
	add.l	d4,d2
	cmp.l	d2,d3
	ble.s	newdata1_11
	move.b	d0,(a2)+
	dbf	d7,mixloop1_11
	bra.w	mixdone

newdata1_11
	add.l	d6,d3
	cmp.l	a1,d5
	bgt.s	mixgoon2_11
	clr.b	d0
	move.b	d0,(a2)+
	dbf	d7,mixloop1_11
	bra.w	mixdone

mixgoon2_11
	GETVOL2
	move.b	d0,(a2)+
	dbf	d7,mixloop1_11
	bra.w	mixdone

;				 test d4,a0

sammixloop1_111:
	moveq	#0,d0
	move.l	a4,d1
	moveq	#0,d2
	moveq	#0,d6
mixloop1_111:
	GETVOL1
	cmp.l	a0,d4
	bgt.s	mixgoon1_111
	move.b	d0,(a2)+
	dbf	d7,mixloop1_111
	bra.w	mixdone
mixgoon1_111
	move.b	d1,(a2)+
	dbf	d7,mixloop1_111
	bra.w	mixdone

;				 test d4,a0,	 d5,a1

sammixloop1_1111:
	move.l	a4,d1
	move.l	a5,d0
	move.l	d6,d2
	move.l	d6,d3
	move.l	d4,a3
	move.l	#$10000,d4
mixloop1_1111:
	GETVOL1
	cmp.l	a0,a3	; a0,d4
	bgt.s	mixgoon1_1111
	clr.b	d1
mixgoon1_1111
	add.l	d4,d2
	cmp.l	d2,d3
	ble.s	newdata1_1111
	add.b	d0,d1
	move.b	d1,(a2)+
	dbf	d7,mixloop1_1111
	bra.w	mixdone

newdata1_1111
	add.l	d6,d3
	GETVOL2
	cmp.l	a1,d5
	bgt.s	mixgoon2_1111
	clr.b	d0
	move.b	d1,(a2)+
	dbf	d7,mixloop1_1111
	bra.w	mixdone
mixgoon2_1111
	add.b	d0,d1
	move.b	d1,(a2)+
	dbf	d7,mixloop1_1111
	bra.w	mixdone



; -------------- mixing norm. sample + loop. sample

samloopmix1:
	movem.l	d3-d4,-(sp)
	move.l	(a5,d5.w),d1
	add.l	(a4,d5.w),d1
	move.l	d1,SamRep1(a6)
	move.l	d0,d5

	moveq	#0,d0
	moveq	#0,d1
	move.b	VolA(a6),d0
	move.b	VolB(a6),d1
	lsl.w	#8,d0
	lsl.w	#8,d1
	move.l	WorkPTR(pc),a5
	move.l	VolTabPTR(a5),a4
	move.l	a4,a5
	add.l	d0,a4
	add.l	d1,a5

	cmp.l	a0,d4
	blt.s	sammixloop1_22

	move.l	a0,d0
	add.l	d3,d0
	cmp.l	d4,d0
	bge.s	sammixloop1_2

	move.l	a1,d1
	add.l	d2,d1
	cmp.l	d5,d1
	bge.s	sammixloop1_2
	bra.w	sammixloop1_1

sammixloop1_2:
	move.l	a4,d1
	move.l	a5,d0
	move.l	d6,d2
	move.l	d6,d3
	move.l	d4,a3
	move.l	#$10000,d4
mixloop1_2:
	GETVOL1
	cmp.l	a0,a3
	bgt.s	mixgoon1_2
	clr.b	d1
mixgoon1_2
	add.l	d4,d2
	cmp.l	d2,d3
	ble.s	newdata1_2
	add.b	d0,d1
	move.b	d1,(a2)+
	dbf	d7,mixloop1_2
	bra.w	mixdone
newdata1_2
	add.l	d6,d3
	GETVOL2
	cmp.l	a1,d5
	bgt.s	mixgoon2_2
	move.l	SamRep1(a6),a1	; samrep1
mixgoon2_2
	add.b	d0,d1
	move.b	d1,(a2)+
	dbf	d7,mixloop1_2
	bra.w	mixdone

sammixloop1_22:
	move.l	a4,d1
	move.l	a5,d0
	move.l	d6,d2
	move.l	d6,d3
	move.l	#$10000,d4
mixloop1_22:
	add.l	d4,d2
	cmp.l	d2,d3
	ble.s	newdata1_22
	move.b	d0,(a2)+
	dbf	d7,mixloop1_22
	bra.w	mixdone
newdata1_22
	add.l	d6,d3
	GETVOL2
	cmp.l	a1,d5
	bgt.s	mixgoon2_22
	move.l	SamRep1(a6),a1	; samrep1
mixgoon2_22
	move.b	d0,(a2)+
	dbf	d7,mixloop1_22
	bra.w	mixdone

; -------------- mixing loop. sample + norm. sample

samloopmix2:
	movem.l	d3-d4,-(sp)
	move.l	124(a4,d5.w),d0
	add.l	(a4,d5.w),d0
	move.l	d0,d5

	move.l	(a5,d1.w),d0
	add.l	(a4,d1.w),d0
	move.l	d0,SamRep2(a6)

	moveq	#0,d0
	moveq	#0,d1
	move.b	VolA(a6),d0
	move.b	VolB(a6),d1
	lsl.w	#8,d0
	lsl.w	#8,d1
	move.l	WorkPTR(pc),a5
	move.l	VolTabPTR(a5),a4
	move.l	a4,a5
	add.l	d0,a4
	add.l	d1,a5

	cmp.l	a1,d5
	blt.s	sammixloop1_33

	move.l	a0,d0
	add.l	d3,d0
	cmp.l	d4,d0
	bge.s	sammixloop1_3

	move.l	a1,d1
	add.l	d2,d1
	cmp.l	d5,d1
	bge.s	sammixloop1_3
	bra.w	sammixloop1_1

sammixloop1_3
	move.l	a4,d1
	move.l	a5,d0
	move.l	d6,d2
	move.l	d6,d3
	move.l	d4,a3
	move.l	#$10000,d4
mixloop1_3:
	GETVOL1
	cmp.l	a0,a3
	bgt.s	mixgoon1_3
	move.l	SamRep2(a6),a0
	move.b	#1,ChangeAdr(a6)
mixgoon1_3
	add.l	d4,d2
	cmp.l	d2,d3
	ble.s	newdata1_3
	add.b	d0,d1
	move.b	d1,(a2)+
	dbf	d7,mixloop1_3
	bra.w	mixdone
newdata1_3
	add.l	d6,d3
	GETVOL2
	cmp.l	a1,d5
	bgt.s	mixgoon2_3
	clr.b	d0
	move.b	d1,(a2)+
	dbf	d7,mixloop1_3
	bra.w	mixdone
mixgoon2_3
	add.b	d0,d1
	move.b	d1,(a2)+
	dbf	d7,mixloop1_3
	bra.w	mixdone

sammixloop1_33
	move.l	a4,d1
	move.l	a5,d0
mixloop1_33:
	move.b	(a0)+,d1
	cmp.l	a0,d4
	bgt.s	mixgoon1_33
	move.l	SamRep2(a6),a0
	move.b	#1,ChangeAdr(a6)
mixgoon1_33
	move.l	d1,a4
	move.b	(a4),(a2)+
	dbf	d7,mixloop1_33
	bra.w	mixdone

; -------------- mixing loop. sample + loop. sample

samloopmix3:
	movem.l	d3-d4,-(sp)
	move.l	(a5,d1.w),SamRep2(a6)
	move.l	(a4,d1.w),d1
	add.l	d1,SamRep2(a6)

	move.l	(a5,d5.w),d1
	add.l	(a4,d5.w),d1
	move.l	d1,SamRep1(a6)
	move.l	d0,d5

	moveq	#0,d0
	moveq	#0,d1
	move.b	VolA(a6),d0
	move.b	VolB(a6),d1
	lsl.w	#8,d0
	lsl.w	#8,d1
	move.l	WorkPTR(pc),a5
	move.l	VolTabPTR(a5),a4
	move.l	a4,a5
	add.l	d0,a4
	add.l	d1,a5

	move.l	a4,d1
	move.l	a5,d0
	move.l	d6,d2
	move.l	d6,d3
	move.l	d5,a3
	move.l	d4,d5
	move.l	#$10000,d4
mixloop1_4:
	GETVOL1
	cmp.l	a0,d5		; a0;d4
	bgt.s	mixgoon1_4
	move.l	SamRep2(a6),a0
	move.b	#1,ChangeAdr(a6)
mixgoon1_4
	add.l	d4,d2
	cmp.l	d2,d3
	ble.s	newdata1_4
	add.b	d0,d1
	move.b	d1,(a2)+
	dbf	d7,mixloop1_4
	move.l	a3,d5
	bra.s	mixdone
newdata1_4
	add.l	d6,d3
	GETVOL2
	cmp.l	a1,a3		; a0;d5
	bgt.s	mixgoon2_4
	move.l	SamRep1(a6),a1
mixgoon2_4
	add.b	d0,d1
	move.b	d1,(a2)+
	dbf	d7,mixloop1_4
	move.l	a3,d5
	bra.w	mixdone

; -------------------------------------------------- 

mixdone:
	movem.l	(sp)+,d3-d4

	move.l	d0,-(sp)
	move.w	MixPeriodB(pc),d0
	cmp.w	MixPeriodA(pc),d0
	beq.s	NoSubAD
;	lsl.w	#1,d0
;	cmp.w	MixPeriodA(pc),d0
;	beq.s	NoSubAD
;	lsr.w	#2,d0
;	cmp.w	MixPeriodA(pc),d0
;	beq.s	NoSubAD

	cmp.l	SamRep1(a6),a1
	bne.s	NoSubOK
	move.l	d5,a1
	bra.s	NoSubAD
NoSubOK	subq.l	#1,a1
	subq.l	#2,d5
NoSubAD	move.l	(sp)+,d0

	lea	MixDon(a6),a4
	cmp.l	a0,d4
	bge.s	notyet3
	move.b	#3,(a4)
notyet3
	cmp.l	a1,d5
	bge.s	notyet2
	move.b	#2,(a4)
notyet2
	cmp.l	a1,d5
	bge.s	notyet1
	cmp.l	a0,d4
	bge.s	notyet1
	move.b	#1,(a4)
notyet1
	movem.l	(sp)+,d5/a2
	move.l	a0,SamRep2(a6)
	move.l	a1,124(a2,d5.w)
	rts

make_voltab:
	move.l	WorkPTR(pc),a0
	pea	VolTab(a0)
	move.l	(a7)+,d0
	and.l	#$ffffff00,d0
	move.l	d0,VolTabPTR(a0)
	move.l	d0,a0
	moveq	#0,d2
	move.w	#128,d3

	moveq	#64,d6
make_voltabl2
	move.w	#$ff,d7
	moveq	#0,d0
make_voltabl1
	move.b	d0,d1
	ext.w	d1
	muls	d2,d1
	divs	d3,d1
	cmp.b	#63,d1
	blt.s	make_volok1
	moveq	#63,d1
make_volok1
	cmp.b	#-64,d1
	bgt.s	make_volok2
	moveq	#-64,d1
make_volok2
	move.b	d1,(a0)+
	addq	#1,d0
	dbf	d7,make_voltabl1
	addq	#2,d2
	dbf	d6,make_voltabl2
	rts

Hex:
 dc.b	0,1,2,3,4,5,6,7,8,9,0,0,0,0,0,0,10,11,12,13,14,15,16,17,18,19
 dc.b	0,0,0,0,0,0,20,21,22,23,24,25,26,27,28,29,0,0,0,0,0,0,30,31
 dc.b	32,33,34,35,36,37,38,39,0,0,0,0,0,0,40,41,42,43,44,45,46,47
 dc.b	48,49,0,0,0,0,0,0,50,51,52,53,54,55,56,57,58,59,0,0,0,0,0,0
 dc.b	60,61,62,63

Tunnings:

; Tuning -8
	dc.w	907,856,808,762,720,678,640,604,570,538,508,480
	dc.w	453,428,404,381,360,339,320,302,285,269,254,240
	dc.w	226,214,202,190,180,170,160,151,143,135,127,120
; Tuning -7
	dc.w	900,850,802,757,715,675,636,601,567,535,505,477
	dc.w	450,425,401,379,357,337,318,300,284,268,253,238
	dc.w	225,212,200,189,179,169,159,150,142,134,126,119
; Tuning -6
	dc.w	894,844,796,752,709,670,632,597,563,532,502,474
	dc.w	447,422,398,376,355,335,316,298,282,266,251,237
	dc.w	223,211,199,188,177,167,158,149,141,133,125,118
; Tuning -5
	dc.w	887,838,791,746,704,665,628,592,559,528,498,470
	dc.w	444,419,395,373,352,332,314,296,280,264,249,235
	dc.w	222,209,198,187,176,166,157,148,140,132,125,118
; Tuning -4
	dc.w	881,832,785,741,699,660,623,588,555,524,494,467
	dc.w	441,416,392,370,350,330,312,294,278,262,247,233
	dc.w	220,208,196,185,175,165,156,147,139,131,123,117
; Tuning -3
	dc.w	875,826,779,736,694,655,619,584,551,520,491,463
	dc.w	437,413,390,368,347,328,309,292,276,260,245,232
	dc.w	219,206,195,184,174,164,155,146,138,130,123,116
; Tuning -2
	dc.w	868,820,774,730,689,651,614,580,547,516,487,460
	dc.w	434,410,387,365,345,325,307,290,274,258,244,230
	dc.w	217,205,193,183,172,163,154,145,137,129,122,115
; Tuning -1
	dc.w	862,814,768,725,684,646,610,575,543,513,484,457
	dc.w	431,407,384,363,342,323,305,288,272,256,242,228
	dc.w	216,203,192,181,171,161,152,144,136,128,121,114
; Tuning 0, Normal
Periods:
	dc.w	856,808,762,720,678,640,604,570,538,508,480,453
	dc.w	428,404,381,360,339,320,302,285,269,254,240,226
	dc.w	214,202,190,180,170,160,151,143,135,127,120,113
PeriodsEnd:
; Tuning 1
	dc.w	850,802,757,715,674,637,601,567,535,505,477,450
	dc.w	425,401,379,357,337,318,300,284,268,253,239,225
	dc.w	213,201,189,179,169,159,150,142,134,126,119,113
; Tuning 2
	dc.w	844,796,752,709,670,632,597,563,532,502,474,447
	dc.w	422,398,376,355,335,316,298,282,266,251,237,224
	dc.w	211,199,188,177,167,158,149,141,133,125,118,112
; Tuning 3
	dc.w	838,791,746,704,665,628,592,559,528,498,470,444
	dc.w	419,395,373,352,332,314,296,280,264,249,235,222
	dc.w	209,198,187,176,166,157,148,140,132,125,118,111
; Tuning 4
	dc.w	832,785,741,699,660,623,588,555,524,495,467,441
	dc.w	416,392,370,350,330,312,294,278,262,247,233,220
	dc.w	208,196,185,175,165,156,147,139,131,124,117,110
; Tuning 5
	dc.w	826,779,736,694,655,619,584,551,520,491,463,437
	dc.w	413,390,368,347,328,309,292,276,260,245,232,219
	dc.w	206,195,184,174,164,155,146,138,130,123,116,109
; Tuning 6
	dc.w	820,774,730,689,651,614,580,547,516,487,460,434
	dc.w	410,387,365,345,325,307,290,274,258,244,230,217
	dc.w	205,193,183,172,163,154,145,137,129,122,115,109
; Tuning 7
	dc.w	814,768,725,684,646,610,575,543,513,484,457,431
	dc.w	407,384,363,342,323,305,288,272,256,242,228,216
	dc.w	204,192,181,171,161,152,144,136,128,121,114,108



WorkPTR:	dc.l	0

		rsreset
VolTabPTR:	rs.l	1
		rs.b	256
VolTab:		rs.b	65*256
UnPackedData:	rs.l	8
PattAdresses:	rs.l	129
sample_starts:	rs.l	31
sample_lenghts:	rs.l	31
sample_pos1:	rs.l	31
		rs.l	31
sample_pos2:	rs.l	31
		rs.l	31
sample_pos3:	rs.l	31
		rs.l	31
sample_pos4:	rs.l	31
		rs.l	31
WorkBuffSize:	rs.b	0



; Channel 1A&1B
Channel1:	ds.b	ChanArea
; Channel 2A&2B datas
Channel2:	ds.b	ChanArea
; Channel 3A&3B datas
Channel3:	ds.b	ChanArea
; Channel 4A&4B datas
Channel4:	ds.b	ChanArea

Enabled:	dc.b	0
Looped:		dc.b	-1
Ended:		dc.b	-1
	even

MasterVol:	dc.w	64



sample_buff4:
	dc.l	0
sample_buff1:
	dc.l	0
sample_buff2:
	dc.l	0
sample_buff3
	dc.l	0

