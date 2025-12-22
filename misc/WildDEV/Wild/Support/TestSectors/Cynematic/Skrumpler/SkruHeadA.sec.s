; Wild Sector source made by META2Wild
; Made on 00:00:15 of 02-02-1978
; Sector name is SkruHeadA

SECTOR_SkruHeadA
	Dc.l	SkruHeadA_Succ,SkruHeadA_Pred
	QuickRefRel	0+SkruHeadA_PosX,0+SkruHeadA_PosY,0+SkruHeadA_PosZ
	Dc.l	SkruHeadA_Parent
	Dc.l	0
	Dc.b	0,0
	ListHeader	SkruHeadAShell,FACE_SkruHeadA1,FACE_SkruHeadA10
	ListHeader	SkruHeadAWire,EDGE_SkruHeadA1,EDGE_SkruHeadA15
	ListHeader	SkruHeadANebula,DOT_SkruHeadA1,DOT_SkruHeadA7
	Ds.b	Sphere_SIZE
	Dc.l	FACE_SkruHeadA2

COLOR_SkruHeadA0	EQU	$FFEEDD

FACE_SkruHeadA1
	Dc.l	FACE_SkruHeadA2,SkruHeadAShell_Head
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadA1,DOT_SkruHeadA2,DOT_SkruHeadA3
	Dc.l	EDGE_SkruHeadA1,EDGE_SkruHeadA2,EDGE_SkruHeadA3
	Dc.l	TEXTURE_SkruHeadA0
	Dc.b	-123,-5
	Dc.b	-110,-32
	Dc.b	-97,-9
FACE_SkruHeadA2
	Dc.l	FACE_SkruHeadA3,FACE_SkruHeadA1
	Dc.l	0,FACE_SkruHeadA3
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadA3,DOT_SkruHeadA4,DOT_SkruHeadA5
	Dc.l	EDGE_SkruHeadA4,EDGE_SkruHeadA5,EDGE_SkruHeadA6
	Dc.l	TEXTURE_SkruHeadA0
	Dc.b	-97,-9
	Dc.b	-84,-32
	Dc.b	-71,-5
FACE_SkruHeadA3
	Dc.l	FACE_SkruHeadA4,FACE_SkruHeadA2
	Dc.l	0,FACE_SkruHeadA6
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadA4,DOT_SkruHeadA2,DOT_SkruHeadA6
	Dc.l	EDGE_SkruHeadA7,EDGE_SkruHeadA8,EDGE_SkruHeadA9
	Dc.l	TEXTURE_SkruHeadA0
	Dc.b	-84,-32
	Dc.b	-110,-32
	Dc.b	-97,-59
FACE_SkruHeadA4
	Dc.l	FACE_SkruHeadA5,FACE_SkruHeadA3
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadA6,DOT_SkruHeadA7,DOT_SkruHeadA4
	Dc.l	EDGE_SkruHeadA10,EDGE_SkruHeadA11,EDGE_SkruHeadA9
	Dc.l	TEXTURE_SkruHeadA0
	Dc.b	-97,-59
	Dc.b	-97,-23
	Dc.b	-84,-32
FACE_SkruHeadA5
	Dc.l	FACE_SkruHeadA6,FACE_SkruHeadA4
	Dc.l	FACE_SkruHeadA10,FACE_SkruHeadA9
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadA7,DOT_SkruHeadA4,DOT_SkruHeadA5
	Dc.l	EDGE_SkruHeadA11,EDGE_SkruHeadA5,EDGE_SkruHeadA12
	Dc.l	TEXTURE_SkruHeadA0
	Dc.b	-97,-23
	Dc.b	-84,-32
	Dc.b	-71,-5
FACE_SkruHeadA6
	Dc.l	FACE_SkruHeadA7,FACE_SkruHeadA5
	Dc.l	FACE_SkruHeadA5,FACE_SkruHeadA7
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadA7,DOT_SkruHeadA5,DOT_SkruHeadA3
	Dc.l	EDGE_SkruHeadA12,EDGE_SkruHeadA6,EDGE_SkruHeadA13
	Dc.l	TEXTURE_SkruHeadA0
	Dc.b	-97,-23
	Dc.b	-71,-5
	Dc.b	-97,-9
FACE_SkruHeadA7
	Dc.l	FACE_SkruHeadA8,FACE_SkruHeadA6
	Dc.l	FACE_SkruHeadA8,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadA7,DOT_SkruHeadA3,DOT_SkruHeadA1
	Dc.l	EDGE_SkruHeadA13,EDGE_SkruHeadA3,EDGE_SkruHeadA14
	Dc.l	TEXTURE_SkruHeadA0
	Dc.b	-97,-23
	Dc.b	-97,-9
	Dc.b	-123,-5
FACE_SkruHeadA8
	Dc.l	FACE_SkruHeadA9,FACE_SkruHeadA7
	Dc.l	FACE_SkruHeadA1,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadA7,DOT_SkruHeadA1,DOT_SkruHeadA2
	Dc.l	EDGE_SkruHeadA14,EDGE_SkruHeadA1,EDGE_SkruHeadA15
	Dc.l	TEXTURE_SkruHeadA0
	Dc.b	-97,-23
	Dc.b	-123,-5
	Dc.b	-110,-32
FACE_SkruHeadA9
	Dc.l	FACE_SkruHeadA10,FACE_SkruHeadA8
	Dc.l	FACE_SkruHeadA4,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadA7,DOT_SkruHeadA2,DOT_SkruHeadA6
	Dc.l	EDGE_SkruHeadA15,EDGE_SkruHeadA8,EDGE_SkruHeadA10
	Dc.l	TEXTURE_SkruHeadA0
	Dc.b	-97,-23
	Dc.b	-110,-32
	Dc.b	-97,-59
FACE_SkruHeadA10
	Dc.l	SkruHeadAShell_Tail,FACE_SkruHeadA9
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadA3,DOT_SkruHeadA4,DOT_SkruHeadA2
	Dc.l	EDGE_SkruHeadA4,EDGE_SkruHeadA7,EDGE_SkruHeadA2
	Dc.l	TEXTURE_SkruHeadA0
	Dc.b	-97,-9
	Dc.b	-84,-32
	Dc.b	-110,-32

EDGE_SkruHeadA1
	Dc.l	EDGE_SkruHeadA2,SkruHeadAWire_Head
	Dc.l	DOT_SkruHeadA1,DOT_SkruHeadA2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadA2
	Dc.l	EDGE_SkruHeadA3,EDGE_SkruHeadA1
	Dc.l	DOT_SkruHeadA2,DOT_SkruHeadA3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadA3
	Dc.l	EDGE_SkruHeadA4,EDGE_SkruHeadA2
	Dc.l	DOT_SkruHeadA1,DOT_SkruHeadA3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadA4
	Dc.l	EDGE_SkruHeadA5,EDGE_SkruHeadA3
	Dc.l	DOT_SkruHeadA3,DOT_SkruHeadA4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadA5
	Dc.l	EDGE_SkruHeadA6,EDGE_SkruHeadA4
	Dc.l	DOT_SkruHeadA4,DOT_SkruHeadA5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadA6
	Dc.l	EDGE_SkruHeadA7,EDGE_SkruHeadA5
	Dc.l	DOT_SkruHeadA3,DOT_SkruHeadA5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadA7
	Dc.l	EDGE_SkruHeadA8,EDGE_SkruHeadA6
	Dc.l	DOT_SkruHeadA4,DOT_SkruHeadA2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadA8
	Dc.l	EDGE_SkruHeadA9,EDGE_SkruHeadA7
	Dc.l	DOT_SkruHeadA2,DOT_SkruHeadA6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadA9
	Dc.l	EDGE_SkruHeadA10,EDGE_SkruHeadA8
	Dc.l	DOT_SkruHeadA4,DOT_SkruHeadA6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadA10
	Dc.l	EDGE_SkruHeadA11,EDGE_SkruHeadA9
	Dc.l	DOT_SkruHeadA6,DOT_SkruHeadA7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadA11
	Dc.l	EDGE_SkruHeadA12,EDGE_SkruHeadA10
	Dc.l	DOT_SkruHeadA7,DOT_SkruHeadA4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadA12
	Dc.l	EDGE_SkruHeadA13,EDGE_SkruHeadA11
	Dc.l	DOT_SkruHeadA7,DOT_SkruHeadA5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadA13
	Dc.l	EDGE_SkruHeadA14,EDGE_SkruHeadA12
	Dc.l	DOT_SkruHeadA7,DOT_SkruHeadA3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadA14
	Dc.l	EDGE_SkruHeadA15,EDGE_SkruHeadA13
	Dc.l	DOT_SkruHeadA7,DOT_SkruHeadA1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadA15
	Dc.l	SkruHeadAWire_Tail,EDGE_SkruHeadA14
	Dc.l	DOT_SkruHeadA7,DOT_SkruHeadA2
	Dc.b	0,0,0,0
	Dc.l	0

DOT_SkruHeadA1
	Dc.l	DOT_SkruHeadA2,SkruHeadANebula_Head
	Dc.l	-120,-200,80
	Dc.l	COLOR_SkruHeadA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadA2
	Dc.l	DOT_SkruHeadA3,DOT_SkruHeadA1
	Dc.l	-60,0,-40
	Dc.l	COLOR_SkruHeadA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadA3
	Dc.l	DOT_SkruHeadA4,DOT_SkruHeadA2
	Dc.l	0,0,60
	Dc.l	COLOR_SkruHeadA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadA4
	Dc.l	DOT_SkruHeadA5,DOT_SkruHeadA3
	Dc.l	60,0,-40
	Dc.l	COLOR_SkruHeadA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadA5
	Dc.l	DOT_SkruHeadA6,DOT_SkruHeadA4
	Dc.l	120,-200,80
	Dc.l	COLOR_SkruHeadA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadA6
	Dc.l	DOT_SkruHeadA7,DOT_SkruHeadA5
	Dc.l	0,-200,-160
	Dc.l	COLOR_SkruHeadA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadA7
	Dc.l	SkruHeadANebula_Tail,DOT_SkruHeadA6
	Dc.l	0,-69,0
	Dc.l	COLOR_SkruHeadA0
	Dc.b	0,0
	Dc.l	0
