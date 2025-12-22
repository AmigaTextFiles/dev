; Wild Sector source made by META2Wild
; Made on 00:01:35 of 02-02-1978
; Sector name is SkruHeadE

SECTOR_SkruHeadE
	Dc.l	SkruHeadE_Succ,SkruHeadE_Pred
	QuickRefRel	0+SkruHeadE_PosX,0+SkruHeadE_PosY,0+SkruHeadE_PosZ
	Dc.l	SkruHeadE_Parent
	Dc.l	0
	Dc.b	0,0
	ListHeader	SkruHeadEShell,FACE_SkruHeadE1,FACE_SkruHeadE10
	ListHeader	SkruHeadEWire,EDGE_SkruHeadE1,EDGE_SkruHeadE15
	ListHeader	SkruHeadENebula,DOT_SkruHeadE1,DOT_SkruHeadE7
	Ds.b	Sphere_SIZE
	Dc.l	FACE_SkruHeadE2

COLOR_SkruHeadE0	EQU	$FFEEDD

FACE_SkruHeadE1
	Dc.l	FACE_SkruHeadE2,SkruHeadEShell_Head
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadE1,DOT_SkruHeadE2,DOT_SkruHeadE3
	Dc.l	EDGE_SkruHeadE1,EDGE_SkruHeadE2,EDGE_SkruHeadE3
	Dc.l	TEXTURE_SkruHeadE0
	Dc.b	69,-4
	Dc.b	82,-32
	Dc.b	95,-9
FACE_SkruHeadE2
	Dc.l	FACE_SkruHeadE3,FACE_SkruHeadE1
	Dc.l	0,FACE_SkruHeadE3
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadE3,DOT_SkruHeadE4,DOT_SkruHeadE5
	Dc.l	EDGE_SkruHeadE4,EDGE_SkruHeadE5,EDGE_SkruHeadE6
	Dc.l	TEXTURE_SkruHeadE0
	Dc.b	95,-9
	Dc.b	107,-32
	Dc.b	120,-4
FACE_SkruHeadE3
	Dc.l	FACE_SkruHeadE4,FACE_SkruHeadE2
	Dc.l	0,FACE_SkruHeadE6
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadE4,DOT_SkruHeadE2,DOT_SkruHeadE6
	Dc.l	EDGE_SkruHeadE7,EDGE_SkruHeadE8,EDGE_SkruHeadE9
	Dc.l	TEXTURE_SkruHeadE0
	Dc.b	107,-32
	Dc.b	82,-32
	Dc.b	95,-60
FACE_SkruHeadE4
	Dc.l	FACE_SkruHeadE5,FACE_SkruHeadE3
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadE6,DOT_SkruHeadE7,DOT_SkruHeadE4
	Dc.l	EDGE_SkruHeadE10,EDGE_SkruHeadE11,EDGE_SkruHeadE9
	Dc.l	TEXTURE_SkruHeadE0
	Dc.b	95,-60
	Dc.b	95,-23
	Dc.b	107,-32
FACE_SkruHeadE5
	Dc.l	FACE_SkruHeadE6,FACE_SkruHeadE4
	Dc.l	FACE_SkruHeadE10,FACE_SkruHeadE9
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadE7,DOT_SkruHeadE4,DOT_SkruHeadE5
	Dc.l	EDGE_SkruHeadE11,EDGE_SkruHeadE5,EDGE_SkruHeadE12
	Dc.l	TEXTURE_SkruHeadE0
	Dc.b	95,-23
	Dc.b	107,-32
	Dc.b	120,-4
FACE_SkruHeadE6
	Dc.l	FACE_SkruHeadE7,FACE_SkruHeadE5
	Dc.l	FACE_SkruHeadE5,FACE_SkruHeadE7
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadE7,DOT_SkruHeadE5,DOT_SkruHeadE3
	Dc.l	EDGE_SkruHeadE12,EDGE_SkruHeadE6,EDGE_SkruHeadE13
	Dc.l	TEXTURE_SkruHeadE0
	Dc.b	95,-23
	Dc.b	120,-4
	Dc.b	95,-9
FACE_SkruHeadE7
	Dc.l	FACE_SkruHeadE8,FACE_SkruHeadE6
	Dc.l	FACE_SkruHeadE8,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadE7,DOT_SkruHeadE3,DOT_SkruHeadE1
	Dc.l	EDGE_SkruHeadE13,EDGE_SkruHeadE3,EDGE_SkruHeadE14
	Dc.l	TEXTURE_SkruHeadE0
	Dc.b	95,-23
	Dc.b	95,-9
	Dc.b	69,-4
FACE_SkruHeadE8
	Dc.l	FACE_SkruHeadE9,FACE_SkruHeadE7
	Dc.l	FACE_SkruHeadE1,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadE7,DOT_SkruHeadE1,DOT_SkruHeadE2
	Dc.l	EDGE_SkruHeadE14,EDGE_SkruHeadE1,EDGE_SkruHeadE15
	Dc.l	TEXTURE_SkruHeadE0
	Dc.b	95,-23
	Dc.b	69,-4
	Dc.b	82,-32
FACE_SkruHeadE9
	Dc.l	FACE_SkruHeadE10,FACE_SkruHeadE8
	Dc.l	FACE_SkruHeadE4,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadE7,DOT_SkruHeadE2,DOT_SkruHeadE6
	Dc.l	EDGE_SkruHeadE15,EDGE_SkruHeadE8,EDGE_SkruHeadE10
	Dc.l	TEXTURE_SkruHeadE0
	Dc.b	95,-23
	Dc.b	82,-32
	Dc.b	95,-60
FACE_SkruHeadE10
	Dc.l	SkruHeadEShell_Tail,FACE_SkruHeadE9
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadE3,DOT_SkruHeadE4,DOT_SkruHeadE2
	Dc.l	EDGE_SkruHeadE4,EDGE_SkruHeadE7,EDGE_SkruHeadE2
	Dc.l	TEXTURE_SkruHeadE0
	Dc.b	95,-9
	Dc.b	107,-32
	Dc.b	82,-32

EDGE_SkruHeadE1
	Dc.l	EDGE_SkruHeadE2,SkruHeadEWire_Head
	Dc.l	DOT_SkruHeadE1,DOT_SkruHeadE2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadE2
	Dc.l	EDGE_SkruHeadE3,EDGE_SkruHeadE1
	Dc.l	DOT_SkruHeadE2,DOT_SkruHeadE3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadE3
	Dc.l	EDGE_SkruHeadE4,EDGE_SkruHeadE2
	Dc.l	DOT_SkruHeadE1,DOT_SkruHeadE3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadE4
	Dc.l	EDGE_SkruHeadE5,EDGE_SkruHeadE3
	Dc.l	DOT_SkruHeadE3,DOT_SkruHeadE4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadE5
	Dc.l	EDGE_SkruHeadE6,EDGE_SkruHeadE4
	Dc.l	DOT_SkruHeadE4,DOT_SkruHeadE5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadE6
	Dc.l	EDGE_SkruHeadE7,EDGE_SkruHeadE5
	Dc.l	DOT_SkruHeadE3,DOT_SkruHeadE5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadE7
	Dc.l	EDGE_SkruHeadE8,EDGE_SkruHeadE6
	Dc.l	DOT_SkruHeadE4,DOT_SkruHeadE2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadE8
	Dc.l	EDGE_SkruHeadE9,EDGE_SkruHeadE7
	Dc.l	DOT_SkruHeadE2,DOT_SkruHeadE6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadE9
	Dc.l	EDGE_SkruHeadE10,EDGE_SkruHeadE8
	Dc.l	DOT_SkruHeadE4,DOT_SkruHeadE6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadE10
	Dc.l	EDGE_SkruHeadE11,EDGE_SkruHeadE9
	Dc.l	DOT_SkruHeadE6,DOT_SkruHeadE7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadE11
	Dc.l	EDGE_SkruHeadE12,EDGE_SkruHeadE10
	Dc.l	DOT_SkruHeadE7,DOT_SkruHeadE4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadE12
	Dc.l	EDGE_SkruHeadE13,EDGE_SkruHeadE11
	Dc.l	DOT_SkruHeadE7,DOT_SkruHeadE5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadE13
	Dc.l	EDGE_SkruHeadE14,EDGE_SkruHeadE12
	Dc.l	DOT_SkruHeadE7,DOT_SkruHeadE3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadE14
	Dc.l	EDGE_SkruHeadE15,EDGE_SkruHeadE13
	Dc.l	DOT_SkruHeadE7,DOT_SkruHeadE1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadE15
	Dc.l	SkruHeadEWire_Tail,EDGE_SkruHeadE14
	Dc.l	DOT_SkruHeadE7,DOT_SkruHeadE2
	Dc.b	0,0,0,0
	Dc.l	0

DOT_SkruHeadE1
	Dc.l	DOT_SkruHeadE2,SkruHeadENebula_Head
	Dc.l	-120,-200,80
	Dc.l	COLOR_SkruHeadE0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadE2
	Dc.l	DOT_SkruHeadE3,DOT_SkruHeadE1
	Dc.l	-60,0,-40
	Dc.l	COLOR_SkruHeadE0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadE3
	Dc.l	DOT_SkruHeadE4,DOT_SkruHeadE2
	Dc.l	0,0,60
	Dc.l	COLOR_SkruHeadE0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadE4
	Dc.l	DOT_SkruHeadE5,DOT_SkruHeadE3
	Dc.l	60,0,-40
	Dc.l	COLOR_SkruHeadE0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadE5
	Dc.l	DOT_SkruHeadE6,DOT_SkruHeadE4
	Dc.l	120,-200,80
	Dc.l	COLOR_SkruHeadE0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadE6
	Dc.l	DOT_SkruHeadE7,DOT_SkruHeadE5
	Dc.l	0,-200,-160
	Dc.l	COLOR_SkruHeadE0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadE7
	Dc.l	SkruHeadENebula_Tail,DOT_SkruHeadE6
	Dc.l	0,-69,0
	Dc.l	COLOR_SkruHeadE0
	Dc.b	0,0
	Dc.l	0
