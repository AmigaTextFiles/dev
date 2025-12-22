; Wild Sector source made by META2Wild
; Made on 00:00:15 of 02-02-1978
; Sector name is SkruHeadD

SECTOR_SkruHeadD
	Dc.l	SkruHeadD_Succ,SkruHeadD_Pred
	QuickRefRel	0+SkruHeadD_PosX,0+SkruHeadD_PosY,0+SkruHeadD_PosZ
	Dc.l	SkruHeadD_Parent
	Dc.l	0
	Dc.b	0,0
	ListHeader	SkruHeadDShell,FACE_SkruHeadD1,FACE_SkruHeadD10
	ListHeader	SkruHeadDWire,EDGE_SkruHeadD1,EDGE_SkruHeadD15
	ListHeader	SkruHeadDNebula,DOT_SkruHeadD1,DOT_SkruHeadD7
	Ds.b	Sphere_SIZE
	Dc.l	FACE_SkruHeadD2

COLOR_SkruHeadD0	EQU	$FFEEDD

FACE_SkruHeadD1
	Dc.l	FACE_SkruHeadD2,SkruHeadDShell_Head
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadD1,DOT_SkruHeadD2,DOT_SkruHeadD3
	Dc.l	EDGE_SkruHeadD1,EDGE_SkruHeadD2,EDGE_SkruHeadD3
	Dc.l	TEXTURE_SkruHeadD0
	Dc.b	-123,-5
	Dc.b	-110,-32
	Dc.b	-97,-9
FACE_SkruHeadD2
	Dc.l	FACE_SkruHeadD3,FACE_SkruHeadD1
	Dc.l	0,FACE_SkruHeadD3
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadD3,DOT_SkruHeadD4,DOT_SkruHeadD5
	Dc.l	EDGE_SkruHeadD4,EDGE_SkruHeadD5,EDGE_SkruHeadD6
	Dc.l	TEXTURE_SkruHeadD0
	Dc.b	-97,-9
	Dc.b	-84,-32
	Dc.b	-71,-5
FACE_SkruHeadD3
	Dc.l	FACE_SkruHeadD4,FACE_SkruHeadD2
	Dc.l	0,FACE_SkruHeadD6
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadD4,DOT_SkruHeadD2,DOT_SkruHeadD6
	Dc.l	EDGE_SkruHeadD7,EDGE_SkruHeadD8,EDGE_SkruHeadD9
	Dc.l	TEXTURE_SkruHeadD0
	Dc.b	-84,-32
	Dc.b	-110,-32
	Dc.b	-97,-59
FACE_SkruHeadD4
	Dc.l	FACE_SkruHeadD5,FACE_SkruHeadD3
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadD6,DOT_SkruHeadD7,DOT_SkruHeadD4
	Dc.l	EDGE_SkruHeadD10,EDGE_SkruHeadD11,EDGE_SkruHeadD9
	Dc.l	TEXTURE_SkruHeadD0
	Dc.b	-97,-59
	Dc.b	-97,-23
	Dc.b	-84,-32
FACE_SkruHeadD5
	Dc.l	FACE_SkruHeadD6,FACE_SkruHeadD4
	Dc.l	FACE_SkruHeadD10,FACE_SkruHeadD9
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadD7,DOT_SkruHeadD4,DOT_SkruHeadD5
	Dc.l	EDGE_SkruHeadD11,EDGE_SkruHeadD5,EDGE_SkruHeadD12
	Dc.l	TEXTURE_SkruHeadD0
	Dc.b	-97,-23
	Dc.b	-84,-32
	Dc.b	-71,-5
FACE_SkruHeadD6
	Dc.l	FACE_SkruHeadD7,FACE_SkruHeadD5
	Dc.l	FACE_SkruHeadD5,FACE_SkruHeadD7
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadD7,DOT_SkruHeadD5,DOT_SkruHeadD3
	Dc.l	EDGE_SkruHeadD12,EDGE_SkruHeadD6,EDGE_SkruHeadD13
	Dc.l	TEXTURE_SkruHeadD0
	Dc.b	-97,-23
	Dc.b	-71,-5
	Dc.b	-97,-9
FACE_SkruHeadD7
	Dc.l	FACE_SkruHeadD8,FACE_SkruHeadD6
	Dc.l	FACE_SkruHeadD8,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadD7,DOT_SkruHeadD3,DOT_SkruHeadD1
	Dc.l	EDGE_SkruHeadD13,EDGE_SkruHeadD3,EDGE_SkruHeadD14
	Dc.l	TEXTURE_SkruHeadD0
	Dc.b	-97,-23
	Dc.b	-97,-9
	Dc.b	-123,-5
FACE_SkruHeadD8
	Dc.l	FACE_SkruHeadD9,FACE_SkruHeadD7
	Dc.l	FACE_SkruHeadD1,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadD7,DOT_SkruHeadD1,DOT_SkruHeadD2
	Dc.l	EDGE_SkruHeadD14,EDGE_SkruHeadD1,EDGE_SkruHeadD15
	Dc.l	TEXTURE_SkruHeadD0
	Dc.b	-97,-23
	Dc.b	-123,-5
	Dc.b	-110,-32
FACE_SkruHeadD9
	Dc.l	FACE_SkruHeadD10,FACE_SkruHeadD8
	Dc.l	FACE_SkruHeadD4,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadD7,DOT_SkruHeadD2,DOT_SkruHeadD6
	Dc.l	EDGE_SkruHeadD15,EDGE_SkruHeadD8,EDGE_SkruHeadD10
	Dc.l	TEXTURE_SkruHeadD0
	Dc.b	-97,-23
	Dc.b	-110,-32
	Dc.b	-97,-59
FACE_SkruHeadD10
	Dc.l	SkruHeadDShell_Tail,FACE_SkruHeadD9
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadD3,DOT_SkruHeadD4,DOT_SkruHeadD2
	Dc.l	EDGE_SkruHeadD4,EDGE_SkruHeadD7,EDGE_SkruHeadD2
	Dc.l	TEXTURE_SkruHeadD0
	Dc.b	-97,-9
	Dc.b	-84,-32
	Dc.b	-110,-32

EDGE_SkruHeadD1
	Dc.l	EDGE_SkruHeadD2,SkruHeadDWire_Head
	Dc.l	DOT_SkruHeadD1,DOT_SkruHeadD2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadD2
	Dc.l	EDGE_SkruHeadD3,EDGE_SkruHeadD1
	Dc.l	DOT_SkruHeadD2,DOT_SkruHeadD3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadD3
	Dc.l	EDGE_SkruHeadD4,EDGE_SkruHeadD2
	Dc.l	DOT_SkruHeadD1,DOT_SkruHeadD3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadD4
	Dc.l	EDGE_SkruHeadD5,EDGE_SkruHeadD3
	Dc.l	DOT_SkruHeadD3,DOT_SkruHeadD4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadD5
	Dc.l	EDGE_SkruHeadD6,EDGE_SkruHeadD4
	Dc.l	DOT_SkruHeadD4,DOT_SkruHeadD5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadD6
	Dc.l	EDGE_SkruHeadD7,EDGE_SkruHeadD5
	Dc.l	DOT_SkruHeadD3,DOT_SkruHeadD5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadD7
	Dc.l	EDGE_SkruHeadD8,EDGE_SkruHeadD6
	Dc.l	DOT_SkruHeadD4,DOT_SkruHeadD2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadD8
	Dc.l	EDGE_SkruHeadD9,EDGE_SkruHeadD7
	Dc.l	DOT_SkruHeadD2,DOT_SkruHeadD6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadD9
	Dc.l	EDGE_SkruHeadD10,EDGE_SkruHeadD8
	Dc.l	DOT_SkruHeadD4,DOT_SkruHeadD6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadD10
	Dc.l	EDGE_SkruHeadD11,EDGE_SkruHeadD9
	Dc.l	DOT_SkruHeadD6,DOT_SkruHeadD7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadD11
	Dc.l	EDGE_SkruHeadD12,EDGE_SkruHeadD10
	Dc.l	DOT_SkruHeadD7,DOT_SkruHeadD4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadD12
	Dc.l	EDGE_SkruHeadD13,EDGE_SkruHeadD11
	Dc.l	DOT_SkruHeadD7,DOT_SkruHeadD5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadD13
	Dc.l	EDGE_SkruHeadD14,EDGE_SkruHeadD12
	Dc.l	DOT_SkruHeadD7,DOT_SkruHeadD3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadD14
	Dc.l	EDGE_SkruHeadD15,EDGE_SkruHeadD13
	Dc.l	DOT_SkruHeadD7,DOT_SkruHeadD1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadD15
	Dc.l	SkruHeadDWire_Tail,EDGE_SkruHeadD14
	Dc.l	DOT_SkruHeadD7,DOT_SkruHeadD2
	Dc.b	0,0,0,0
	Dc.l	0

DOT_SkruHeadD1
	Dc.l	DOT_SkruHeadD2,SkruHeadDNebula_Head
	Dc.l	-120,-200,80
	Dc.l	COLOR_SkruHeadD0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadD2
	Dc.l	DOT_SkruHeadD3,DOT_SkruHeadD1
	Dc.l	-60,0,-40
	Dc.l	COLOR_SkruHeadD0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadD3
	Dc.l	DOT_SkruHeadD4,DOT_SkruHeadD2
	Dc.l	0,0,60
	Dc.l	COLOR_SkruHeadD0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadD4
	Dc.l	DOT_SkruHeadD5,DOT_SkruHeadD3
	Dc.l	60,0,-40
	Dc.l	COLOR_SkruHeadD0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadD5
	Dc.l	DOT_SkruHeadD6,DOT_SkruHeadD4
	Dc.l	120,-200,80
	Dc.l	COLOR_SkruHeadD0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadD6
	Dc.l	DOT_SkruHeadD7,DOT_SkruHeadD5
	Dc.l	0,-200,-160
	Dc.l	COLOR_SkruHeadD0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadD7
	Dc.l	SkruHeadDNebula_Tail,DOT_SkruHeadD6
	Dc.l	0,-69,0
	Dc.l	COLOR_SkruHeadD0
	Dc.b	0,0
	Dc.l	0
