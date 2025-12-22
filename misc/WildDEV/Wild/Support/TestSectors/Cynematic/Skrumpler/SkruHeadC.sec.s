; Wild Sector source made by META2Wild
; Made on 00:49:04 of 02-02-1978
; Sector name is SkruHeadC

SECTOR_SkruHeadC
	Dc.l	SkruHeadC_Succ,SkruHeadC_Pred
	QuickRefRel	0+SkruHeadC_PosX,0+SkruHeadC_PosY,0+SkruHeadC_PosZ
	Dc.l	SkruHeadC_Parent
	Dc.l	0
	Dc.b	0,0
	ListHeader	SkruHeadCShell,FACE_SkruHeadC1,FACE_SkruHeadC10
	ListHeader	SkruHeadCWire,EDGE_SkruHeadC1,EDGE_SkruHeadC15
	ListHeader	SkruHeadCNebula,DOT_SkruHeadC1,DOT_SkruHeadC7
	Ds.b	Sphere_SIZE
	Dc.l	FACE_SkruHeadC2

COLOR_SkruHeadC0	EQU	$FFEEDD

FACE_SkruHeadC1
	Dc.l	FACE_SkruHeadC2,SkruHeadCShell_Head
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadC1,DOT_SkruHeadC2,DOT_SkruHeadC3
	Dc.l	EDGE_SkruHeadC1,EDGE_SkruHeadC2,EDGE_SkruHeadC3
	Dc.l	TEXTURE_SkruHeadC0
	Dc.b	3,6
	Dc.b	18,33
	Dc.b	33,10
FACE_SkruHeadC2
	Dc.l	FACE_SkruHeadC3,FACE_SkruHeadC1
	Dc.l	0,FACE_SkruHeadC3
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadC3,DOT_SkruHeadC4,DOT_SkruHeadC5
	Dc.l	EDGE_SkruHeadC4,EDGE_SkruHeadC5,EDGE_SkruHeadC6
	Dc.l	TEXTURE_SkruHeadC0
	Dc.b	33,10
	Dc.b	47,33
	Dc.b	62,6
FACE_SkruHeadC3
	Dc.l	FACE_SkruHeadC4,FACE_SkruHeadC2
	Dc.l	0,FACE_SkruHeadC6
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadC4,DOT_SkruHeadC2,DOT_SkruHeadC6
	Dc.l	EDGE_SkruHeadC7,EDGE_SkruHeadC8,EDGE_SkruHeadC9
	Dc.l	TEXTURE_SkruHeadC0
	Dc.b	47,33
	Dc.b	18,33
	Dc.b	33,59
FACE_SkruHeadC4
	Dc.l	FACE_SkruHeadC5,FACE_SkruHeadC3
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadC6,DOT_SkruHeadC7,DOT_SkruHeadC4
	Dc.l	EDGE_SkruHeadC10,EDGE_SkruHeadC11,EDGE_SkruHeadC9
	Dc.l	TEXTURE_SkruHeadC0
	Dc.b	33,59
	Dc.b	33,24
	Dc.b	47,33
FACE_SkruHeadC5
	Dc.l	FACE_SkruHeadC6,FACE_SkruHeadC4
	Dc.l	FACE_SkruHeadC10,FACE_SkruHeadC9
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadC7,DOT_SkruHeadC4,DOT_SkruHeadC5
	Dc.l	EDGE_SkruHeadC11,EDGE_SkruHeadC5,EDGE_SkruHeadC12
	Dc.l	TEXTURE_SkruHeadC0
	Dc.b	33,24
	Dc.b	47,33
	Dc.b	62,6
FACE_SkruHeadC6
	Dc.l	FACE_SkruHeadC7,FACE_SkruHeadC5
	Dc.l	FACE_SkruHeadC5,FACE_SkruHeadC7
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadC7,DOT_SkruHeadC5,DOT_SkruHeadC3
	Dc.l	EDGE_SkruHeadC12,EDGE_SkruHeadC6,EDGE_SkruHeadC13
	Dc.l	TEXTURE_SkruHeadC0
	Dc.b	33,24
	Dc.b	62,6
	Dc.b	33,10
FACE_SkruHeadC7
	Dc.l	FACE_SkruHeadC8,FACE_SkruHeadC6
	Dc.l	FACE_SkruHeadC8,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadC7,DOT_SkruHeadC3,DOT_SkruHeadC1
	Dc.l	EDGE_SkruHeadC13,EDGE_SkruHeadC3,EDGE_SkruHeadC14
	Dc.l	TEXTURE_SkruHeadC0
	Dc.b	33,24
	Dc.b	33,10
	Dc.b	3,6
FACE_SkruHeadC8
	Dc.l	FACE_SkruHeadC9,FACE_SkruHeadC7
	Dc.l	FACE_SkruHeadC1,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadC7,DOT_SkruHeadC1,DOT_SkruHeadC2
	Dc.l	EDGE_SkruHeadC14,EDGE_SkruHeadC1,EDGE_SkruHeadC15
	Dc.l	TEXTURE_SkruHeadC0
	Dc.b	33,24
	Dc.b	3,6
	Dc.b	18,33
FACE_SkruHeadC9
	Dc.l	FACE_SkruHeadC10,FACE_SkruHeadC8
	Dc.l	FACE_SkruHeadC4,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadC7,DOT_SkruHeadC2,DOT_SkruHeadC6
	Dc.l	EDGE_SkruHeadC15,EDGE_SkruHeadC8,EDGE_SkruHeadC10
	Dc.l	TEXTURE_SkruHeadC0
	Dc.b	33,24
	Dc.b	18,33
	Dc.b	33,59
FACE_SkruHeadC10
	Dc.l	SkruHeadCShell_Tail,FACE_SkruHeadC9
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruHeadC3,DOT_SkruHeadC4,DOT_SkruHeadC2
	Dc.l	EDGE_SkruHeadC4,EDGE_SkruHeadC7,EDGE_SkruHeadC2
	Dc.l	TEXTURE_SkruHeadC0
	Dc.b	33,10
	Dc.b	47,33
	Dc.b	18,33

EDGE_SkruHeadC1
	Dc.l	EDGE_SkruHeadC2,SkruHeadCWire_Head
	Dc.l	DOT_SkruHeadC1,DOT_SkruHeadC2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadC2
	Dc.l	EDGE_SkruHeadC3,EDGE_SkruHeadC1
	Dc.l	DOT_SkruHeadC2,DOT_SkruHeadC3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadC3
	Dc.l	EDGE_SkruHeadC4,EDGE_SkruHeadC2
	Dc.l	DOT_SkruHeadC1,DOT_SkruHeadC3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadC4
	Dc.l	EDGE_SkruHeadC5,EDGE_SkruHeadC3
	Dc.l	DOT_SkruHeadC3,DOT_SkruHeadC4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadC5
	Dc.l	EDGE_SkruHeadC6,EDGE_SkruHeadC4
	Dc.l	DOT_SkruHeadC4,DOT_SkruHeadC5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadC6
	Dc.l	EDGE_SkruHeadC7,EDGE_SkruHeadC5
	Dc.l	DOT_SkruHeadC3,DOT_SkruHeadC5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadC7
	Dc.l	EDGE_SkruHeadC8,EDGE_SkruHeadC6
	Dc.l	DOT_SkruHeadC4,DOT_SkruHeadC2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadC8
	Dc.l	EDGE_SkruHeadC9,EDGE_SkruHeadC7
	Dc.l	DOT_SkruHeadC2,DOT_SkruHeadC6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadC9
	Dc.l	EDGE_SkruHeadC10,EDGE_SkruHeadC8
	Dc.l	DOT_SkruHeadC4,DOT_SkruHeadC6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadC10
	Dc.l	EDGE_SkruHeadC11,EDGE_SkruHeadC9
	Dc.l	DOT_SkruHeadC6,DOT_SkruHeadC7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadC11
	Dc.l	EDGE_SkruHeadC12,EDGE_SkruHeadC10
	Dc.l	DOT_SkruHeadC7,DOT_SkruHeadC4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadC12
	Dc.l	EDGE_SkruHeadC13,EDGE_SkruHeadC11
	Dc.l	DOT_SkruHeadC7,DOT_SkruHeadC5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadC13
	Dc.l	EDGE_SkruHeadC14,EDGE_SkruHeadC12
	Dc.l	DOT_SkruHeadC7,DOT_SkruHeadC3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadC14
	Dc.l	EDGE_SkruHeadC15,EDGE_SkruHeadC13
	Dc.l	DOT_SkruHeadC7,DOT_SkruHeadC1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruHeadC15
	Dc.l	SkruHeadCWire_Tail,EDGE_SkruHeadC14
	Dc.l	DOT_SkruHeadC7,DOT_SkruHeadC2
	Dc.b	0,0,0,0
	Dc.l	0

DOT_SkruHeadC1
	Dc.l	DOT_SkruHeadC2,SkruHeadCNebula_Head
	Dc.l	-120,-200,80
	Dc.l	COLOR_SkruHeadC0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadC2
	Dc.l	DOT_SkruHeadC3,DOT_SkruHeadC1
	Dc.l	-60,0,-40
	Dc.l	COLOR_SkruHeadC0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadC3
	Dc.l	DOT_SkruHeadC4,DOT_SkruHeadC2
	Dc.l	0,0,60
	Dc.l	COLOR_SkruHeadC0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadC4
	Dc.l	DOT_SkruHeadC5,DOT_SkruHeadC3
	Dc.l	60,0,-40
	Dc.l	COLOR_SkruHeadC0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadC5
	Dc.l	DOT_SkruHeadC6,DOT_SkruHeadC4
	Dc.l	120,-200,80
	Dc.l	COLOR_SkruHeadC0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadC6
	Dc.l	DOT_SkruHeadC7,DOT_SkruHeadC5
	Dc.l	0,-200,-160
	Dc.l	COLOR_SkruHeadC0
	Dc.b	0,0
	Dc.l	0
DOT_SkruHeadC7
	Dc.l	SkruHeadCNebula_Tail,DOT_SkruHeadC6
	Dc.l	0,-69,0
	Dc.l	COLOR_SkruHeadC0
	Dc.b	0,0
	Dc.l	0
