; Wild Sector source made by META2Wild
; Made on 18:12:19 of 01-12-1978
; Sector name is Single

SECTOR_Single
	Dc.l	Single_Succ,Single_Pred
	QuickRefRel	0,0,0
	Dc.l	Single_Parent
	Dc.l	0
	Dc.b	0,0
	ListHeader	SingleShell,FACE_Single1,FACE_Single1
	ListHeader	SingleWire,EDGE_Single1,EDGE_Single3
	ListHeader	SingleNebula,DOT_Single1,DOT_Single3
	Ds.b	Sphere_SIZE
	Dc.l	FACE_Single1

COLOR_Single0	EQU	$FFEEDD

FACE_Single1
	Dc.l	FACE_Single2,SingleShell_Head
	Dc.l	FACE_Single2,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Single1,DOT_Single2,DOT_Single3
	Dc.l	EDGE_Single1,EDGE_Single2,EDGE_Single3
	Dc.l	TEXTURE_Single0
	Dc.b	0,0
	Dc.b	255,0
	Dc.b	0,255
FACE_Single2
	Dc.l	SingleShell_Tail,FACE_Single1
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Single4,DOT_Single5,DOT_Single6
	Dc.l	EDGE_Single4,EDGE_Single5,EDGE_Single6
	Dc.l	TEXTURE_Single0
	Dc.b	0,0
	Dc.b	255,0
	Dc.b	0,255

EDGE_Single1
	Dc.l	EDGE_Single2,SingleWire_Head
	Dc.l	DOT_Single1,DOT_Single2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Single2
	Dc.l	EDGE_Single3,EDGE_Single1
	Dc.l	DOT_Single2,DOT_Single3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Single3
	Dc.l	EDGE_Single4,EDGE_Single2
	Dc.l	DOT_Single1,DOT_Single3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Single4
	Dc.l	EDGE_Single5,EDGE_Single3
	Dc.l	DOT_Single4,DOT_Single5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Single5
	Dc.l	EDGE_Single6,EDGE_Single4
	Dc.l	DOT_Single5,DOT_Single6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Single6
	Dc.l	SingleWire_Tail,EDGE_Single5
	Dc.l	DOT_Single4,DOT_Single6
	Dc.b	0,0,0,0
	Dc.l	0

DOT_Single1
	Dc.l	DOT_Single2,SingleNebula_Head
	Dc.l	0,0,30
	Dc.l	COLOR_Single0
	Dc.b	0,0
	Dc.l	0
DOT_Single2
	Dc.l	DOT_Single3,DOT_Single1
	Dc.l	-100,100,30
	Dc.l	COLOR_Single0
	Dc.b	0,0
	Dc.l	0
DOT_Single3
	Dc.l	DOT_Single4,DOT_Single2
	Dc.l	-100,-100,30
	Dc.l	COLOR_Single0
	Dc.b	0,0
	Dc.l	0

DOT_Single4
	Dc.l	DOT_Single4,DOT_Single3
	Dc.l	0,0,-30
	Dc.l	COLOR_Single0
	Dc.b	0,0
	Dc.l	0
DOT_Single5
	Dc.l	DOT_Single5,DOT_Single4
	Dc.l	-100,100,-30
	Dc.l	COLOR_Single0
	Dc.b	0,0
	Dc.l	0
DOT_Single6
	Dc.l	SingleNebula_Tail,DOT_Single5
	Dc.l	-100,-100,-30
	Dc.l	COLOR_Single0
	Dc.b	0,0
	Dc.l	0
