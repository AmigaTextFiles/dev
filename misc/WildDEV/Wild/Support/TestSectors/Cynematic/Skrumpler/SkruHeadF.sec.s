; Wild Sector source made by META2Wild
; Made on 00:49:04 of 02-02-1978
; Sector name is SkruHeadF

SECTOR_SkruHeadF
	Dc.l	SkruHeadF_Succ,SkruHeadF_Pred
	QuickRefRel	0+SkruHeadF_PosX,0+SkruHeadF_PosY,0+SkruHeadF_PosZ
	Dc.l	SkruHeadF_Parent
	Dc.l	0
	Dc.b	0,0
	ListHeader	SkruHeadFShell,FACE_SkruHeadF1,FACE_SkruHeadF10
	ListHeader	SkruHeadFWire,EDGE_SkruHeadF1,EDGE_SkruHeadF15
	ListHeader	SkruHeadFNebula,DOT_SkruHeadF1,DOT_SkruHeadF7
	Ds.b	Sphere_SIZE
	Dc.l	FACE_SkruHeadF2

COLOR_SkruHeadF0	EQU	$FFEEDD

FACE_SkruHeadF1
	Dc.l	FACE_SkruHeadF2,SkruHeadFShell_Head
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadF1,DOT_SkruHeadF2,DOT_SkruHeadF3
	Dc.l	EDGE_SkruHeadF1,EDGE_SkruHeadF2,EDGE_SkruHeadF3
	Dc.l	TEXTURE_SkruHeadF0
	Dc.b	3,6
	Dc.b	18,33
	Dc.b	33,10
FACE_SkruHeadF2
	Dc.l	FACE_SkruHeadF3,FACE_SkruHeadF1
	Dc.l	0,FACE_SkruHeadF3
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadF3,DOT_SkruHeadF4,DOT_SkruHeadF5
	Dc.l	EDGE_SkruHeadF4,EDGE_SkruHeadF5,EDGE_SkruHeadF6
	Dc.l	TEXTURE_SkruHeadF0
	Dc.b	33,10
	Dc.b	47,33
	Dc.b	62,6
FACE_SkruHeadF3
	Dc.l	FACE_SkruHeadF4,FACE_SkruHeadF2
	Dc.l	0,FACE_SkruHeadF6
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadF4,DOT_SkruHeadF2,DOT_SkruHeadF6
	Dc.l	EDGE_SkruHeadF7,EDGE_SkruHeadF8,EDGE_SkruHeadF9
	Dc.l	TEXTURE_SkruHeadF0
	Dc.b	47,33
	Dc.b	18,33
	Dc.b	33,59
FACE_SkruHeadF4
	Dc.l	FACE_SkruHeadF5,FACE_SkruHeadF3
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadF6,DOT_SkruHeadF7,DOT_SkruHeadF4
	Dc.l	EDGE_SkruHeadF10,EDGE_SkruHeadF11,EDGE_SkruHeadF9
	Dc.l	TEXTURE_SkruHeadF0
	Dc.b	33,59
	Dc.b	33,24
	Dc.b	47,33
FACE_SkruHeadF5
	Dc.l	FACE_SkruHeadF6,FACE_SkruHeadF4
	Dc.l	FACE_SkruHeadF10,FACE_SkruHeadF9
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadF7,DOT_SkruHeadF4,DOT_SkruHeadF5
	Dc.l	EDGE_SkruHeadF11,EDGE_SkruHeadF5,EDGE_SkruHeadF12
	Dc.l	TEXTURE_SkruHeadF0
	Dc.b	33,24
	Dc.b	47,33
	Dc.b	62,6
FACE_SkruHeadF6
	Dc.l	FACE_SkruHeadF7,FACE_SkruHeadF5
	Dc.l	FACE_SkruHeadF5,FACE_SkruHeadF7
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadF7,DOT_SkruHeadF5,DOT_SkruHeadF3
	Dc.l	EDGE_SkruHeadF12,EDGE_SkruHeadF6,EDGE_SkruHeadF13
	Dc.l	TEXTURE_SkruHeadF0
	Dc.b	33,24
	Dc.b	62,6
	Dc.b	33,10
FACE_SkruHeadF7
	Dc.l	FACE_SkruHeadF8,FACE_SkruHeadF6
	Dc.l	FACE_SkruHeadF8,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadF7,DOT_SkruHeadF3,DOT_SkruHeadF1
	Dc.l	EDGE_SkruHeadF13,EDGE_SkruHeadF3,EDGE_SkruHeadF14
	Dc.l	TEXTURE_SkruHeadF0
	Dc.b	33,24
	Dc.b	33,10
	Dc.b	3,6
FACE_SkruHeadF8
	Dc.l	FACE_SkruHeadF9,FACE_SkruHeadF7
	Dc.l	FACE_SkruHeadF1,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadF7,DOT_SkruHeadF1,DOT_SkruHeadF2
	Dc.l	EDGE_SkruHeadF14,EDGE_SkruHeadF1,EDGE_SkruHeadF15
	Dc.l	TEXTURE_SkruHeadF0
	Dc.b	33,24
	Dc.b	3,6
	Dc.b	18,33
FACE_SkruHeadF9
	Dc.l	FACE_SkruHeadF10,FACE_SkruHeadF8
	Dc.l	FACE_SkruHeadF4,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadF7,DOT_SkruHeadF2,DOT_SkruHeadF6
	Dc.l	EDGE_SkruHeadF15,EDGE_SkruHeadF8,EDGE_SkruHeadF10
	Dc.l	TEXTURE_SkruHeadF0
	Dc.b	33,24
	Dc.b	18,33
	Dc.b	33,59
FACE_SkruHeadF10
	Dc.l	SkruHeadFShell_Tail,FACE_SkruHeadF9
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadF3,DOT_SkruHeadF4,DOT_SkruHeadF2
	Dc.l	EDGE_SkruHeadF4,EDGE_SkruHeadF7,EDGE_SkruHeadF2
	Dc.l	TEXTURE_SkruHeadF0
	Dc.b	33,10
	Dc.b	47,33
	Dc.b	18,33

EDGE_SkruHeadF1
	Dc.l	EDGE_SkruHeadF2,SkruHeadFWire_Head
	Dc.l	DOT_SkruHeadF1,DOT_SkruHeadF2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadF2
	Dc.l	EDGE_SkruHeadF3,EDGE_SkruHeadF1
	Dc.l	DOT_SkruHeadF2,DOT_SkruHeadF3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadF3
	Dc.l	EDGE_SkruHeadF4,EDGE_SkruHeadF2
	Dc.l	DOT_SkruHeadF1,DOT_SkruHeadF3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadF4
	Dc.l	EDGE_SkruHeadF5,EDGE_SkruHeadF3
	Dc.l	DOT_SkruHeadF3,DOT_SkruHeadF4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadF5
	Dc.l	EDGE_SkruHeadF6,EDGE_SkruHeadF4
	Dc.l	DOT_SkruHeadF4,DOT_SkruHeadF5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadF6
	Dc.l	EDGE_SkruHeadF7,EDGE_SkruHeadF5
	Dc.l	DOT_SkruHeadF3,DOT_SkruHeadF5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadF7
	Dc.l	EDGE_SkruHeadF8,EDGE_SkruHeadF6
	Dc.l	DOT_SkruHeadF4,DOT_SkruHeadF2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadF8
	Dc.l	EDGE_SkruHeadF9,EDGE_SkruHeadF7
	Dc.l	DOT_SkruHeadF2,DOT_SkruHeadF6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadF9
	Dc.l	EDGE_SkruHeadF10,EDGE_SkruHeadF8
	Dc.l	DOT_SkruHeadF4,DOT_SkruHeadF6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadF10
	Dc.l	EDGE_SkruHeadF11,EDGE_SkruHeadF9
	Dc.l	DOT_SkruHeadF6,DOT_SkruHeadF7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadF11
	Dc.l	EDGE_SkruHeadF12,EDGE_SkruHeadF10
	Dc.l	DOT_SkruHeadF7,DOT_SkruHeadF4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadF12
	Dc.l	EDGE_SkruHeadF13,EDGE_SkruHeadF11
	Dc.l	DOT_SkruHeadF7,DOT_SkruHeadF5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadF13
	Dc.l	EDGE_SkruHeadF14,EDGE_SkruHeadF12
	Dc.l	DOT_SkruHeadF7,DOT_SkruHeadF3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadF14
	Dc.l	EDGE_SkruHeadF15,EDGE_SkruHeadF13
	Dc.l	DOT_SkruHeadF7,DOT_SkruHeadF1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadF15
	Dc.l	SkruHeadFWire_Tail,EDGE_SkruHeadF14
	Dc.l	DOT_SkruHeadF7,DOT_SkruHeadF2
	Dc.b	0,0,0,0
	Dc.l	0

DOT_SkruHeadF1
	Dc.l	DOT_SkruHeadF2,SkruHeadFNebula_Head
	Dc.l	-120,-200,80
	Dc.l	COLOR_SkruHeadF0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadF2
	Dc.l	DOT_SkruHeadF3,DOT_SkruHeadF1
	Dc.l	-60,0,-40
	Dc.l	COLOR_SkruHeadF0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadF3
	Dc.l	DOT_SkruHeadF4,DOT_SkruHeadF2
	Dc.l	0,0,60
	Dc.l	COLOR_SkruHeadF0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadF4
	Dc.l	DOT_SkruHeadF5,DOT_SkruHeadF3
	Dc.l	60,0,-40
	Dc.l	COLOR_SkruHeadF0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadF5
	Dc.l	DOT_SkruHeadF6,DOT_SkruHeadF4
	Dc.l	120,-200,80
	Dc.l	COLOR_SkruHeadF0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadF6
	Dc.l	DOT_SkruHeadF7,DOT_SkruHeadF5
	Dc.l	0,-200,-160
	Dc.l	COLOR_SkruHeadF0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadF7
	Dc.l	SkruHeadFNebula_Tail,DOT_SkruHeadF6
	Dc.l	0,-69,0
	Dc.l	COLOR_SkruHeadF0
	Dc.b	0,0
	Dc.l	0
