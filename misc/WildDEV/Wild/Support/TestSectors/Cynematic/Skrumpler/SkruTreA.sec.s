; Wild Sector source made by META2Wild
; Made on 23:56:15 of 02-01-1978
; Sector name is SkruTreA

SECTOR_SkruTreA
	Dc.l	SkruTreA_Succ,SkruTreA_Pred
	QuickRefRel	0+SkruTreA_PosX,0+SkruTreA_PosY,0+SkruTreA_PosZ
	Dc.l	SkruTreA_Parent
	Dc.l	0
	Dc.b	0,0
	ListHeader	SkruTreAShell,FACE_SkruTreA1,FACE_SkruTreA31
	ListHeader	SkruTreAWire,EDGE_SkruTreA1,EDGE_SkruTreA45
	ListHeader	SkruTreANebula,DOT_SkruTreA1,DOT_SkruTreA16
	Ds.b	Sphere_SIZE
	Dc.l	FACE_SkruTreA4

COLOR_SkruTreA0	EQU	$FFEEDD

FACE_SkruTreA1
	Dc.l	FACE_SkruTreA2,SkruTreAShell_Head
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA1,DOT_SkruTreA2,DOT_SkruTreA3
	Dc.l	EDGE_SkruTreA1,EDGE_SkruTreA2,EDGE_SkruTreA3
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	26,-19
	Dc.b	33,-4
	Dc.b	41,-19
FACE_SkruTreA2
	Dc.l	FACE_SkruTreA3,FACE_SkruTreA1
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA4,DOT_SkruTreA5,DOT_SkruTreA6
	Dc.l	EDGE_SkruTreA4,EDGE_SkruTreA5,EDGE_SkruTreA6
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	51,-46
	Dc.b	44,-61
	Dc.b	59,-61
FACE_SkruTreA3
	Dc.l	FACE_SkruTreA4,FACE_SkruTreA2
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA7,DOT_SkruTreA8,DOT_SkruTreA9
	Dc.l	EDGE_SkruTreA7,EDGE_SkruTreA8,EDGE_SkruTreA9
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	20,-61
	Dc.b	13,-46
	Dc.b	5,-61
FACE_SkruTreA4
	Dc.l	FACE_SkruTreA5,FACE_SkruTreA3
	Dc.l	FACE_SkruTreA8,FACE_SkruTreA11
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA7,DOT_SkruTreA8,DOT_SkruTreA10
	Dc.l	EDGE_SkruTreA7,EDGE_SkruTreA10,EDGE_SkruTreA11
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	20,-61
	Dc.b	13,-46
	Dc.b	33,-40
FACE_SkruTreA5
	Dc.l	FACE_SkruTreA6,FACE_SkruTreA4
	Dc.l	FACE_SkruTreA9,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA10,DOT_SkruTreA5,DOT_SkruTreA4
	Dc.l	EDGE_SkruTreA12,EDGE_SkruTreA4,EDGE_SkruTreA13
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	33,-40
	Dc.b	44,-61
	Dc.b	51,-46
FACE_SkruTreA6
	Dc.l	FACE_SkruTreA7,FACE_SkruTreA5
	Dc.l	FACE_SkruTreA7,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA3,DOT_SkruTreA1,DOT_SkruTreA10
	Dc.l	EDGE_SkruTreA3,EDGE_SkruTreA14,EDGE_SkruTreA15
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	41,-19
	Dc.b	26,-19
	Dc.b	33,-40
FACE_SkruTreA7
	Dc.l	FACE_SkruTreA8,FACE_SkruTreA6
	Dc.l	0,FACE_SkruTreA12
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA10,DOT_SkruTreA3,DOT_SkruTreA11
	Dc.l	EDGE_SkruTreA15,EDGE_SkruTreA16,EDGE_SkruTreA17
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	33,-40
	Dc.b	41,-19
	Dc.b	41,-37
FACE_SkruTreA8
	Dc.l	FACE_SkruTreA9,FACE_SkruTreA7
	Dc.l	FACE_SkruTreA13,FACE_SkruTreA15
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA10,DOT_SkruTreA11,DOT_SkruTreA4
	Dc.l	EDGE_SkruTreA17,EDGE_SkruTreA18,EDGE_SkruTreA13
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	33,-40
	Dc.b	41,-37
	Dc.b	51,-46
FACE_SkruTreA9
	Dc.l	FACE_SkruTreA10,FACE_SkruTreA8
	Dc.l	0,FACE_SkruTreA22
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA5,DOT_SkruTreA12,DOT_SkruTreA10
	Dc.l	EDGE_SkruTreA19,EDGE_SkruTreA20,EDGE_SkruTreA12
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	44,-61
	Dc.b	33,-52
	Dc.b	33,-40
FACE_SkruTreA10
	Dc.l	FACE_SkruTreA11,FACE_SkruTreA9
	Dc.l	FACE_SkruTreA18,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA7,DOT_SkruTreA12,DOT_SkruTreA10
	Dc.l	EDGE_SkruTreA21,EDGE_SkruTreA20,EDGE_SkruTreA11
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	20,-61
	Dc.b	33,-52
	Dc.b	33,-40
FACE_SkruTreA11
	Dc.l	FACE_SkruTreA12,FACE_SkruTreA10
	Dc.l	FACE_SkruTreA26,FACE_SkruTreA25
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA10,DOT_SkruTreA8,DOT_SkruTreA13
	Dc.l	EDGE_SkruTreA10,EDGE_SkruTreA22,EDGE_SkruTreA23
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	33,-40
	Dc.b	13,-46
	Dc.b	26,-37
FACE_SkruTreA12
	Dc.l	FACE_SkruTreA13,FACE_SkruTreA11
	Dc.l	0,FACE_SkruTreA21
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA13,DOT_SkruTreA1,DOT_SkruTreA10
	Dc.l	EDGE_SkruTreA24,EDGE_SkruTreA14,EDGE_SkruTreA23
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	26,-37
	Dc.b	26,-19
	Dc.b	33,-40
FACE_SkruTreA13
	Dc.l	FACE_SkruTreA14,FACE_SkruTreA12
	Dc.l	FACE_SkruTreA14,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA14,DOT_SkruTreA2,DOT_SkruTreA3
	Dc.l	EDGE_SkruTreA25,EDGE_SkruTreA2,EDGE_SkruTreA26
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	33,-28
	Dc.b	33,-4
	Dc.b	41,-19
FACE_SkruTreA14
	Dc.l	FACE_SkruTreA15,FACE_SkruTreA13
	Dc.l	0,FACE_SkruTreA6
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA14,DOT_SkruTreA2,DOT_SkruTreA1
	Dc.l	EDGE_SkruTreA25,EDGE_SkruTreA1,EDGE_SkruTreA27
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	33,-28
	Dc.b	33,-4
	Dc.b	26,-19
FACE_SkruTreA15
	Dc.l	FACE_SkruTreA16,FACE_SkruTreA14
	Dc.l	FACE_SkruTreA16,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA15,DOT_SkruTreA4,DOT_SkruTreA6
	Dc.l	EDGE_SkruTreA28,EDGE_SkruTreA6,EDGE_SkruTreA29
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	44,-49
	Dc.b	51,-46
	Dc.b	59,-61
FACE_SkruTreA16
	Dc.l	FACE_SkruTreA17,FACE_SkruTreA15
	Dc.l	0,FACE_SkruTreA5
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA5,DOT_SkruTreA6,DOT_SkruTreA15
	Dc.l	EDGE_SkruTreA5,EDGE_SkruTreA29,EDGE_SkruTreA30
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	44,-61
	Dc.b	59,-61
	Dc.b	44,-49
FACE_SkruTreA17
	Dc.l	FACE_SkruTreA18,FACE_SkruTreA16
	Dc.l	0,FACE_SkruTreA10
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA9,DOT_SkruTreA7,DOT_SkruTreA16
	Dc.l	EDGE_SkruTreA9,EDGE_SkruTreA31,EDGE_SkruTreA32
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	5,-61
	Dc.b	20,-61
	Dc.b	23,-49
FACE_SkruTreA18
	Dc.l	FACE_SkruTreA19,FACE_SkruTreA17
	Dc.l	0,FACE_SkruTreA19
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA16,DOT_SkruTreA8,DOT_SkruTreA9
	Dc.l	EDGE_SkruTreA33,EDGE_SkruTreA8,EDGE_SkruTreA32
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	23,-49
	Dc.b	13,-46
	Dc.b	5,-61
FACE_SkruTreA19
	Dc.l	FACE_SkruTreA20,FACE_SkruTreA18
	Dc.l	FACE_SkruTreA24,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA16,DOT_SkruTreA8,DOT_SkruTreA13
	Dc.l	EDGE_SkruTreA33,EDGE_SkruTreA22,EDGE_SkruTreA34
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	23,-49
	Dc.b	13,-46
	Dc.b	26,-37
FACE_SkruTreA20
	Dc.l	FACE_SkruTreA21,FACE_SkruTreA19
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA13,DOT_SkruTreA14,DOT_SkruTreA1
	Dc.l	EDGE_SkruTreA35,EDGE_SkruTreA27,EDGE_SkruTreA24
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	26,-37
	Dc.b	33,-28
	Dc.b	26,-19
FACE_SkruTreA21
	Dc.l	FACE_SkruTreA22,FACE_SkruTreA20
	Dc.l	0,FACE_SkruTreA1
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA14,DOT_SkruTreA11,DOT_SkruTreA3
	Dc.l	EDGE_SkruTreA36,EDGE_SkruTreA16,EDGE_SkruTreA26
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	33,-28
	Dc.b	41,-37
	Dc.b	41,-19
FACE_SkruTreA22
	Dc.l	FACE_SkruTreA23,FACE_SkruTreA21
	Dc.l	0,FACE_SkruTreA2
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA4,DOT_SkruTreA11,DOT_SkruTreA15
	Dc.l	EDGE_SkruTreA18,EDGE_SkruTreA37,EDGE_SkruTreA28
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	51,-46
	Dc.b	41,-37
	Dc.b	44,-49
FACE_SkruTreA23
	Dc.l	FACE_SkruTreA24,FACE_SkruTreA22
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA5,DOT_SkruTreA15,DOT_SkruTreA12
	Dc.l	EDGE_SkruTreA30,EDGE_SkruTreA38,EDGE_SkruTreA19
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	44,-61
	Dc.b	44,-49
	Dc.b	33,-52
FACE_SkruTreA24
	Dc.l	FACE_SkruTreA25,FACE_SkruTreA23
	Dc.l	0,FACE_SkruTreA3
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA12,DOT_SkruTreA16,DOT_SkruTreA7
	Dc.l	EDGE_SkruTreA39,EDGE_SkruTreA31,EDGE_SkruTreA21
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	33,-52
	Dc.b	23,-49
	Dc.b	20,-61
FACE_SkruTreA25
	Dc.l	FACE_SkruTreA26,FACE_SkruTreA24
	Dc.l	FACE_SkruTreA17,FACE_SkruTreA31
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA13,DOT_SkruTreA12,DOT_SkruTreA16
	Dc.l	EDGE_SkruTreA40,EDGE_SkruTreA39,EDGE_SkruTreA34
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	26,-37
	Dc.b	33,-52
	Dc.b	23,-49
FACE_SkruTreA26
	Dc.l	FACE_SkruTreA27,FACE_SkruTreA25
	Dc.l	FACE_SkruTreA20,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA13,DOT_SkruTreA14,DOT_SkruTreA11
	Dc.l	EDGE_SkruTreA35,EDGE_SkruTreA36,EDGE_SkruTreA41
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	26,-37
	Dc.b	33,-28
	Dc.b	41,-37
FACE_SkruTreA27
	Dc.l	FACE_SkruTreA28,FACE_SkruTreA26
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA15,DOT_SkruTreA11,DOT_SkruTreA12
	Dc.l	EDGE_SkruTreA37,EDGE_SkruTreA42,EDGE_SkruTreA38
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	44,-49
	Dc.b	41,-37
	Dc.b	33,-52
FACE_SkruTreA28
	Dc.l	FACE_SkruTreA29,FACE_SkruTreA27
	Dc.l	FACE_SkruTreA30,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA14,DOT_SkruTreA15,DOT_SkruTreA16
	Dc.l	EDGE_SkruTreA43,EDGE_SkruTreA44,EDGE_SkruTreA45
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	33,-28
	Dc.b	44,-49
	Dc.b	23,-49
FACE_SkruTreA29
	Dc.l	FACE_SkruTreA30,FACE_SkruTreA28
	Dc.l	0,FACE_SkruTreA28
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA15,DOT_SkruTreA11,DOT_SkruTreA14
	Dc.l	EDGE_SkruTreA37,EDGE_SkruTreA36,EDGE_SkruTreA43
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	44,-49
	Dc.b	41,-37
	Dc.b	33,-28
FACE_SkruTreA30
	Dc.l	FACE_SkruTreA31,FACE_SkruTreA29
	Dc.l	FACE_SkruTreA27,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA13,DOT_SkruTreA14,DOT_SkruTreA16
	Dc.l	EDGE_SkruTreA35,EDGE_SkruTreA45,EDGE_SkruTreA34
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	26,-37
	Dc.b	33,-28
	Dc.b	23,-49
FACE_SkruTreA31
	Dc.l	SkruTreAShell_Tail,FACE_SkruTreA30
	Dc.l	FACE_SkruTreA29,FACE_SkruTreA23
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreA12,DOT_SkruTreA16,DOT_SkruTreA15
	Dc.l	EDGE_SkruTreA39,EDGE_SkruTreA44,EDGE_SkruTreA38
	Dc.l	TEXTURE_SkruTreA0
	Dc.b	33,-52
	Dc.b	23,-49
	Dc.b	44,-49

EDGE_SkruTreA1
	Dc.l	EDGE_SkruTreA2,SkruTreAWire_Head
	Dc.l	DOT_SkruTreA1,DOT_SkruTreA2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA2
	Dc.l	EDGE_SkruTreA3,EDGE_SkruTreA1
	Dc.l	DOT_SkruTreA2,DOT_SkruTreA3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA3
	Dc.l	EDGE_SkruTreA4,EDGE_SkruTreA2
	Dc.l	DOT_SkruTreA1,DOT_SkruTreA3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA4
	Dc.l	EDGE_SkruTreA5,EDGE_SkruTreA3
	Dc.l	DOT_SkruTreA4,DOT_SkruTreA5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA5
	Dc.l	EDGE_SkruTreA6,EDGE_SkruTreA4
	Dc.l	DOT_SkruTreA5,DOT_SkruTreA6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA6
	Dc.l	EDGE_SkruTreA7,EDGE_SkruTreA5
	Dc.l	DOT_SkruTreA4,DOT_SkruTreA6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA7
	Dc.l	EDGE_SkruTreA8,EDGE_SkruTreA6
	Dc.l	DOT_SkruTreA7,DOT_SkruTreA8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA8
	Dc.l	EDGE_SkruTreA9,EDGE_SkruTreA7
	Dc.l	DOT_SkruTreA8,DOT_SkruTreA9
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA9
	Dc.l	EDGE_SkruTreA10,EDGE_SkruTreA8
	Dc.l	DOT_SkruTreA7,DOT_SkruTreA9
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA10
	Dc.l	EDGE_SkruTreA11,EDGE_SkruTreA9
	Dc.l	DOT_SkruTreA8,DOT_SkruTreA10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA11
	Dc.l	EDGE_SkruTreA12,EDGE_SkruTreA10
	Dc.l	DOT_SkruTreA7,DOT_SkruTreA10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA12
	Dc.l	EDGE_SkruTreA13,EDGE_SkruTreA11
	Dc.l	DOT_SkruTreA10,DOT_SkruTreA5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA13
	Dc.l	EDGE_SkruTreA14,EDGE_SkruTreA12
	Dc.l	DOT_SkruTreA10,DOT_SkruTreA4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA14
	Dc.l	EDGE_SkruTreA15,EDGE_SkruTreA13
	Dc.l	DOT_SkruTreA1,DOT_SkruTreA10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA15
	Dc.l	EDGE_SkruTreA16,EDGE_SkruTreA14
	Dc.l	DOT_SkruTreA3,DOT_SkruTreA10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA16
	Dc.l	EDGE_SkruTreA17,EDGE_SkruTreA15
	Dc.l	DOT_SkruTreA3,DOT_SkruTreA11
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA17
	Dc.l	EDGE_SkruTreA18,EDGE_SkruTreA16
	Dc.l	DOT_SkruTreA10,DOT_SkruTreA11
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA18
	Dc.l	EDGE_SkruTreA19,EDGE_SkruTreA17
	Dc.l	DOT_SkruTreA11,DOT_SkruTreA4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA19
	Dc.l	EDGE_SkruTreA20,EDGE_SkruTreA18
	Dc.l	DOT_SkruTreA5,DOT_SkruTreA12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA20
	Dc.l	EDGE_SkruTreA21,EDGE_SkruTreA19
	Dc.l	DOT_SkruTreA12,DOT_SkruTreA10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA21
	Dc.l	EDGE_SkruTreA22,EDGE_SkruTreA20
	Dc.l	DOT_SkruTreA7,DOT_SkruTreA12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA22
	Dc.l	EDGE_SkruTreA23,EDGE_SkruTreA21
	Dc.l	DOT_SkruTreA8,DOT_SkruTreA13
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA23
	Dc.l	EDGE_SkruTreA24,EDGE_SkruTreA22
	Dc.l	DOT_SkruTreA10,DOT_SkruTreA13
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA24
	Dc.l	EDGE_SkruTreA25,EDGE_SkruTreA23
	Dc.l	DOT_SkruTreA13,DOT_SkruTreA1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA25
	Dc.l	EDGE_SkruTreA26,EDGE_SkruTreA24
	Dc.l	DOT_SkruTreA14,DOT_SkruTreA2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA26
	Dc.l	EDGE_SkruTreA27,EDGE_SkruTreA25
	Dc.l	DOT_SkruTreA14,DOT_SkruTreA3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA27
	Dc.l	EDGE_SkruTreA28,EDGE_SkruTreA26
	Dc.l	DOT_SkruTreA14,DOT_SkruTreA1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA28
	Dc.l	EDGE_SkruTreA29,EDGE_SkruTreA27
	Dc.l	DOT_SkruTreA15,DOT_SkruTreA4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA29
	Dc.l	EDGE_SkruTreA30,EDGE_SkruTreA28
	Dc.l	DOT_SkruTreA15,DOT_SkruTreA6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA30
	Dc.l	EDGE_SkruTreA31,EDGE_SkruTreA29
	Dc.l	DOT_SkruTreA5,DOT_SkruTreA15
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA31
	Dc.l	EDGE_SkruTreA32,EDGE_SkruTreA30
	Dc.l	DOT_SkruTreA7,DOT_SkruTreA16
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA32
	Dc.l	EDGE_SkruTreA33,EDGE_SkruTreA31
	Dc.l	DOT_SkruTreA9,DOT_SkruTreA16
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA33
	Dc.l	EDGE_SkruTreA34,EDGE_SkruTreA32
	Dc.l	DOT_SkruTreA16,DOT_SkruTreA8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA34
	Dc.l	EDGE_SkruTreA35,EDGE_SkruTreA33
	Dc.l	DOT_SkruTreA16,DOT_SkruTreA13
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA35
	Dc.l	EDGE_SkruTreA36,EDGE_SkruTreA34
	Dc.l	DOT_SkruTreA13,DOT_SkruTreA14
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA36
	Dc.l	EDGE_SkruTreA37,EDGE_SkruTreA35
	Dc.l	DOT_SkruTreA14,DOT_SkruTreA11
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA37
	Dc.l	EDGE_SkruTreA38,EDGE_SkruTreA36
	Dc.l	DOT_SkruTreA11,DOT_SkruTreA15
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA38
	Dc.l	EDGE_SkruTreA39,EDGE_SkruTreA37
	Dc.l	DOT_SkruTreA15,DOT_SkruTreA12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA39
	Dc.l	EDGE_SkruTreA40,EDGE_SkruTreA38
	Dc.l	DOT_SkruTreA12,DOT_SkruTreA16
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA40
	Dc.l	EDGE_SkruTreA41,EDGE_SkruTreA39
	Dc.l	DOT_SkruTreA13,DOT_SkruTreA12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA41
	Dc.l	EDGE_SkruTreA42,EDGE_SkruTreA40
	Dc.l	DOT_SkruTreA13,DOT_SkruTreA11
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA42
	Dc.l	EDGE_SkruTreA43,EDGE_SkruTreA41
	Dc.l	DOT_SkruTreA11,DOT_SkruTreA12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA43
	Dc.l	EDGE_SkruTreA44,EDGE_SkruTreA42
	Dc.l	DOT_SkruTreA14,DOT_SkruTreA15
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA44
	Dc.l	EDGE_SkruTreA45,EDGE_SkruTreA43
	Dc.l	DOT_SkruTreA15,DOT_SkruTreA16
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreA45
	Dc.l	SkruTreAWire_Tail,EDGE_SkruTreA44
	Dc.l	DOT_SkruTreA14,DOT_SkruTreA16
	Dc.b	0,0,0,0
	Dc.l	0

DOT_SkruTreA1
	Dc.l	DOT_SkruTreA2,SkruTreANebula_Head
	Dc.l	-60,62,153
	Dc.l	COLOR_SkruTreA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreA2
	Dc.l	DOT_SkruTreA3,DOT_SkruTreA1
	Dc.l	0,62,253
	Dc.l	COLOR_SkruTreA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreA3
	Dc.l	DOT_SkruTreA4,DOT_SkruTreA2
	Dc.l	60,62,153
	Dc.l	COLOR_SkruTreA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreA4
	Dc.l	DOT_SkruTreA5,DOT_SkruTreA3
	Dc.l	140,62,-27
	Dc.l	COLOR_SkruTreA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreA5
	Dc.l	DOT_SkruTreA6,DOT_SkruTreA4
	Dc.l	80,62,-127
	Dc.l	COLOR_SkruTreA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreA6
	Dc.l	DOT_SkruTreA7,DOT_SkruTreA5
	Dc.l	200,62,-127
	Dc.l	COLOR_SkruTreA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreA7
	Dc.l	DOT_SkruTreA8,DOT_SkruTreA6
	Dc.l	-100,62,-127
	Dc.l	COLOR_SkruTreA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreA8
	Dc.l	DOT_SkruTreA9,DOT_SkruTreA7
	Dc.l	-160,62,-27
	Dc.l	COLOR_SkruTreA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreA9
	Dc.l	DOT_SkruTreA10,DOT_SkruTreA8
	Dc.l	-220,62,-127
	Dc.l	COLOR_SkruTreA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreA10
	Dc.l	DOT_SkruTreA11,DOT_SkruTreA9
	Dc.l	0,122,13
	Dc.l	COLOR_SkruTreA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreA11
	Dc.l	DOT_SkruTreA12,DOT_SkruTreA10
	Dc.l	60,142,33
	Dc.l	COLOR_SkruTreA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreA12
	Dc.l	DOT_SkruTreA13,DOT_SkruTreA11
	Dc.l	0,142,-67
	Dc.l	COLOR_SkruTreA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreA13
	Dc.l	DOT_SkruTreA14,DOT_SkruTreA12
	Dc.l	-60,142,33
	Dc.l	COLOR_SkruTreA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreA14
	Dc.l	DOT_SkruTreA15,DOT_SkruTreA13
	Dc.l	0,202,93
	Dc.l	COLOR_SkruTreA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreA15
	Dc.l	DOT_SkruTreA16,DOT_SkruTreA14
	Dc.l	80,202,-47
	Dc.l	COLOR_SkruTreA0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreA16
	Dc.l	SkruTreANebula_Tail,DOT_SkruTreA15
	Dc.l	-80,202,-47
	Dc.l	COLOR_SkruTreA0
	Dc.b	0,0
	Dc.l	0
