
	output	Wildpj:demos/3d/cynetik/Cynetik_Gouraud
	
	include	exec/exec_lib.i
	include	wildinc.gs
	include	wild/wild.i
	include	wild/allmodules.i
	include	extensions/vektorial.i
	include	pypermacro.i

	Exec
	lea.l	wildname,a1
	jsr	_LVOOldOpenLibrary(a6)
	move.l	d0,_WILDBase
	beq	exit
	
	bsr	Go

exit	Exec
	movea.l	_WILDBase,a1
	move.l	a1,d0
	beq.b	.nwi
.nwi	jsr	_LVOCloseLibrary(a6)
	moveq.l	#0,d0
	rts
	
vektname	dc.b	'libs:Wild/Vektorial.library',0
wildname	dc.b	'wild.library',0
drawm		dc.b	'Fluff',0
dispm		dc.b	'TryPeJam+',0
brokm		dc.b	'ShiX',0
lighm		dc.b	'Koton',0
sincosname2	dc.b	'libs:'
sincosname1	dc.b	'wild/tables/sincos1616.table',0
		cnop	0,4
_WILDBase	dc.l	0
VektBase	dc.l	0
WApp		dc.l	0
AppTags		dc.l	WITD_Scene,TestScene
		dc.l	WIAP_DrawModule,drawm
		dc.l	WIAP_DisplayModule,dispm
		dc.l	WIAP_BrokerModule,brokm
		dc.l	WIAP_LightModule,lighm
		dc.l	WIDI_Width,320
		dc.l	WIDI_Height,256
		dc.l	WIDI_DisplayID,$21000
		dc.l	WITD_CutDistance,32000
		dc.l	0
sincos		dc.l	0
SinOffs		dc.l	0

Go	bsr	SetUpWildApp
	bsr	SetUpExts
	
cycle	Wild
	move.l	WApp,a0
	Call	InitFrame
	move.l	WApp,a0
	Call	RealyzeFrame
	move.l	WApp,a0
	Call	DisplayFrame

	add.w	#8,PUI
	bmi.b	.npuir
	clr.w	PUI
.npuir	moveq.l	#0,d0
	move.b	$dff007,d0
	andi.w	#63,d0
	cmp.w	#36,d0
	bge.b	.nadpui
	move.w	PUI,d1
	sub.w	d0,d1
	cmp.w	#-255,d1
	bge.b	.ntpui
	move.w	#-255,d1
.ntpui	move.w	d1,PUI
.nadpui

RotSecY	MACRO	;\1=sec,angle EA
	movea.l	VektBase,a6
	lea.l	SECTOR_\1+ent_Ref+ref_I+Rel,a0
	move.l	\2,d0
	moveq.l	#vek_X,d1
	moveq.l	#vek_Z,d2
	Call	RotateDD
	lea.l	SECTOR_\1+ent_Ref+ref_K+Rel,a0
	move.l	\2,d0
	moveq.l	#vek_X,d1
	moveq.l	#vek_Z,d2
	Call	RotateDD
	ENDM
	
	RotSecY	SkruBase,BaseRot
	RotSecY	SkruTreA,TreRot
	RotSecY	SkruTreB,TreRot
	RotSecY	SkruHeadA,HeadRot
	RotSecY	SkruHeadB,HeadRot
	RotSecY	SkruHeadC,HeadRot
	RotSecY	SkruHeadD,HeadRot
	RotSecY	SkruHeadE,HeadRot
	RotSecY	SkruHeadF,HeadRot

	sub.l	#10,MyCamera+ref_O+Abs+vek_Y
		
	movea.l	VektBase,a6
	lea.l	MyCamera,a0
	lea.l	SECTOR_SkruBase+ent_Ref+ref_O+Abs,a1
	moveq.l	#1,d0
CLA	Call	CamLookingAt

.pr	btst	#7,$bfe001
	beq.b	.pr
	
	btst	#6,$bfe001
	bne	cycle

	bsr	KillWildApp
	bsr	KillExts
	rts

BaseRot	dc.l	5
TreRot	dc.l	10
HeadRot	dc.l	20

SetUpExts	Wild
		moveq.l	#0,d0
		lea.l	vektname,a1
		Call	LoadExtension
		move.l	d0,VektBase
		
		rts

KillExts	Wild
		movea.l	VektBase,a1
		Call	KillExtension
		rts
		
SetUpWildApp	Exec
		Call	CreateMsgPort
		tst.l	d0
		bne.b	.msgok
		rts
.msgok		Wild
		movea.l	d0,a0
		lea.l	AppTags,a1
		Call	AddWildApp
		move.l	d0,WApp
		
		lea.l	sincosname1,a0
		moveq.l	#WITA_SINCOS1616,d0
		Call	LoadTable
		move.l	d0,sincos
		bne.b	.had
		lea.l	sincosname2,a0
		moveq.l	#WITA_SINCOS1616,d0
		Call	LoadTable
		move.l	d0,sincos
.had		rts

KillWildApp	Wild
		move.l	sincos,a1
		move.l	a1,d0
		beq.b	.nsc
		Call	KillTable
.nsc		
		move.l	WApp,d0
		bne.b	.okwa
		rts
.okwa		movea.l	d0,a0
		move.l	wap_WildPort(a0),d2
		Call	RemWildApp
		Exec
		move.l	d2,a0
		Call	DeleteMsgPort
		rts
				

TestScene	dc.l	TestWorld
MyCamera

		QuickRefAbs	0,0,-900

		dc.l 	palette

palette		incbin	fusion256.pal		

TestWorld
twarhead	dc.l	TestArena
twartail	dc.l	0
		dc.l	TestArena
twalhead	dc.l	twaltail
twaltail	dc.l	0
		dc.l	twalhead
		dc.l	TestPlayer			

TestPlayer	dc.l	0			; HAKK: no player, for now a sector is enough

TestArena	dc.l	twartail
		dc.l	twarhead
		QuickRefRel	0,0,0
		dc.l	0			; Parent of arenas is UNIVERSE! ABSOLUTE=RELATIVE
		dc.l	0
		dc.w	0
		
tasehead	dc.l	SECTOR_SkruBase
tasetail	dc.l	0	
		dc.l	SECTOR_SkruHeadF

taalhead	dc.l	taaltail
taaltail	dc.l	0
		dc.l	taalhead
talihead	dc.l	TestLight
talitail	dc.l	0
		dc.l	TestLight
		dcb	Sphere_SIZE*3
		dc.l	0

TestLight	dc.l	AmbLight,talihead
		dc.l	DOT_SkruBase11
		dc.l	$0055ff
		dc.w	255

AmbLight	dc.l	talitail,TestLight
		dc.l	0
		dc.l	$ffca22
		dc.w	-16

TextTex		EQU	0
TEXTURE_SkruBase0	EQU	TextTex
TEXTURE_SkruTreA0	EQU	TextTex
TEXTURE_SkruTreB0	EQU	TextTex
TEXTURE_SkruHeadA0	EQU	TextTex
TEXTURE_SkruHeadB0	EQU	TextTex
TEXTURE_SkruHeadC0	EQU	TextTex
TEXTURE_SkruHeadD0	EQU	TextTex
TEXTURE_SkruHeadE0	EQU	TextTex
TEXTURE_SkruHeadF0	EQU	TextTex
		
PUI		dc.w	-16
	
		MakeSector SkruBase,WildPJ:Support/TestSectors/Cynematic/Skrumpler/SkruBase.sec.s
		MakeSector SkruTreA,WildPJ:Support/TestSectors/Cynematic/Skrumpler/SkruTreA.sec.s
		MakeSector SkruTreB,WildPJ:Support/TestSectors/Cynematic/Skrumpler/SkruTreB.sec.s
		MakeSector SkruHeadA,WildPJ:Support/TestSectors/Cynematic/Skrumpler/SkruHeadA.sec.s
		MakeSector SkruHeadB,WildPJ:Support/TestSectors/Cynematic/Skrumpler/SkruHeadB.sec.s
		MakeSector SkruHeadC,WildPJ:Support/TestSectors/Cynematic/Skrumpler/SkruHeadC.sec.s
		MakeSector SkruHeadD,WildPJ:Support/TestSectors/Cynematic/Skrumpler/SkruHeadD.sec.s
		MakeSector SkruHeadE,WildPJ:Support/TestSectors/Cynematic/Skrumpler/SkruHeadE.sec.s
		MakeSector SkruHeadF,WildPJ:Support/TestSectors/Cynematic/Skrumpler/SkruHeadF.sec.s
		
		LinkSector SkruBase,SECTOR_SkruTreA,tasehead,TestArena
		LinkSector SkruTreA,SECTOR_SkruTreB,SECTOR_SkruBase,SECTOR_SkruBase
		LinkSector SkruTreB,SECTOR_SkruHeadA,SECTOR_SkruTreA,SECTOR_SkruBase
		LinkSector SkruHeadA,SECTOR_SkruHeadB,SECTOR_SkruTreB,SECTOR_SkruTreA
		LinkSector SkruHeadB,SECTOR_SkruHeadC,SECTOR_SkruHeadA,SECTOR_SkruTreA
		LinkSector SkruHeadC,SECTOR_SkruHeadD,SECTOR_SkruHeadB,SECTOR_SkruTreA
		LinkSector SkruHeadD,SECTOR_SkruHeadE,SECTOR_SkruHeadC,SECTOR_SkruTreB
		LinkSector SkruHeadE,SECTOR_SkruHeadF,SECTOR_SkruHeadD,SECTOR_SkruTreB
		LinkSector SkruHeadF,tasetail,SECTOR_SkruHeadE,SECTOR_SkruTreB
	
		PosSector SkruBase,0,0,0
		PosSector SkruTreA,220,-202,93
		PosSector SkruTreB,-220,-202,-93
		PosSector SkruHeadA,0,62,186
		PosSector SkruHeadB,140,62,-93
		PosSector SkruHeadC,-160,62,-93
		PosSector SkruHeadD,0,62,186
		PosSector SkruHeadE,140,62,-93
		PosSector SkruHeadF,-160,62,-93
