; Wild Sector source made by META2Wild
; Made on 23:58:03 of 02-01-1978
; Sector name is SkruTreB

SECTOR_SkruTreB
	Dc.l	SkruTreB_Succ,SkruTreB_Pred
	QuickRefRel	0+SkruTreB_PosX,0+SkruTreB_PosY,0+SkruTreB_PosZ
	Dc.l	SkruTreB_Parent
	Dc.l	0
	Dc.b	0,0
	ListHeader	SkruTreBShell,FACE_SkruTreB1,FACE_SkruTreB31
	ListHeader	SkruTreBWire,EDGE_SkruTreB1,EDGE_SkruTreB45
	ListHeader	SkruTreBNebula,DOT_SkruTreB1,DOT_SkruTreB16
	Ds.b	Sphere_SIZE
	Dc.l	FACE_SkruTreB4

COLOR_SkruTreB0	EQU	$FFEEDD

FACE_SkruTreB1
	Dc.l	FACE_SkruTreB2,SkruTreBShell_Head
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB1,DOT_SkruTreB2,DOT_SkruTreB3
	Dc.l	EDGE_SkruTreB1,EDGE_SkruTreB2,EDGE_SkruTreB3
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-38,-19
	Dc.b	-30,-4
	Dc.b	-22,-19
FACE_SkruTreB2
	Dc.l	FACE_SkruTreB3,FACE_SkruTreB1
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB4,DOT_SkruTreB5,DOT_SkruTreB6
	Dc.l	EDGE_SkruTreB4,EDGE_SkruTreB5,EDGE_SkruTreB6
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-11,-45
	Dc.b	-19,-60
	Dc.b	-3,-60
FACE_SkruTreB3
	Dc.l	FACE_SkruTreB4,FACE_SkruTreB2
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB7,DOT_SkruTreB8,DOT_SkruTreB9
	Dc.l	EDGE_SkruTreB7,EDGE_SkruTreB8,EDGE_SkruTreB9
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-43,-60
	Dc.b	-51,-45
	Dc.b	-59,-60
FACE_SkruTreB4
	Dc.l	FACE_SkruTreB5,FACE_SkruTreB3
	Dc.l	FACE_SkruTreB8,FACE_SkruTreB11
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB7,DOT_SkruTreB8,DOT_SkruTreB10
	Dc.l	EDGE_SkruTreB7,EDGE_SkruTreB10,EDGE_SkruTreB11
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-43,-60
	Dc.b	-51,-45
	Dc.b	-30,-39
FACE_SkruTreB5
	Dc.l	FACE_SkruTreB6,FACE_SkruTreB4
	Dc.l	FACE_SkruTreB9,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB10,DOT_SkruTreB5,DOT_SkruTreB4
	Dc.l	EDGE_SkruTreB12,EDGE_SkruTreB4,EDGE_SkruTreB13
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-30,-39
	Dc.b	-19,-60
	Dc.b	-11,-45
FACE_SkruTreB6
	Dc.l	FACE_SkruTreB7,FACE_SkruTreB5
	Dc.l	FACE_SkruTreB7,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB3,DOT_SkruTreB1,DOT_SkruTreB10
	Dc.l	EDGE_SkruTreB3,EDGE_SkruTreB14,EDGE_SkruTreB15
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-22,-19
	Dc.b	-38,-19
	Dc.b	-30,-39
FACE_SkruTreB7
	Dc.l	FACE_SkruTreB8,FACE_SkruTreB6
	Dc.l	0,FACE_SkruTreB12
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB10,DOT_SkruTreB3,DOT_SkruTreB11
	Dc.l	EDGE_SkruTreB15,EDGE_SkruTreB16,EDGE_SkruTreB17
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-30,-39
	Dc.b	-22,-19
	Dc.b	-22,-36
FACE_SkruTreB8
	Dc.l	FACE_SkruTreB9,FACE_SkruTreB7
	Dc.l	FACE_SkruTreB13,FACE_SkruTreB15
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB10,DOT_SkruTreB11,DOT_SkruTreB4
	Dc.l	EDGE_SkruTreB17,EDGE_SkruTreB18,EDGE_SkruTreB13
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-30,-39
	Dc.b	-22,-36
	Dc.b	-11,-45
FACE_SkruTreB9
	Dc.l	FACE_SkruTreB10,FACE_SkruTreB8
	Dc.l	0,FACE_SkruTreB22
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB5,DOT_SkruTreB12,DOT_SkruTreB10
	Dc.l	EDGE_SkruTreB19,EDGE_SkruTreB20,EDGE_SkruTreB12
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-19,-60
	Dc.b	-30,-51
	Dc.b	-30,-39
FACE_SkruTreB10
	Dc.l	FACE_SkruTreB11,FACE_SkruTreB9
	Dc.l	FACE_SkruTreB18,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB7,DOT_SkruTreB12,DOT_SkruTreB10
	Dc.l	EDGE_SkruTreB21,EDGE_SkruTreB20,EDGE_SkruTreB11
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-43,-60
	Dc.b	-30,-51
	Dc.b	-30,-39
FACE_SkruTreB11
	Dc.l	FACE_SkruTreB12,FACE_SkruTreB10
	Dc.l	FACE_SkruTreB26,FACE_SkruTreB25
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB10,DOT_SkruTreB8,DOT_SkruTreB13
	Dc.l	EDGE_SkruTreB10,EDGE_SkruTreB22,EDGE_SkruTreB23
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-30,-39
	Dc.b	-51,-45
	Dc.b	-38,-36
FACE_SkruTreB12
	Dc.l	FACE_SkruTreB13,FACE_SkruTreB11
	Dc.l	0,FACE_SkruTreB21
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB13,DOT_SkruTreB1,DOT_SkruTreB10
	Dc.l	EDGE_SkruTreB24,EDGE_SkruTreB14,EDGE_SkruTreB23
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-38,-36
	Dc.b	-38,-19
	Dc.b	-30,-39
FACE_SkruTreB13
	Dc.l	FACE_SkruTreB14,FACE_SkruTreB12
	Dc.l	FACE_SkruTreB14,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB14,DOT_SkruTreB2,DOT_SkruTreB3
	Dc.l	EDGE_SkruTreB25,EDGE_SkruTreB2,EDGE_SkruTreB26
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-30,-28
	Dc.b	-30,-4
	Dc.b	-22,-19
FACE_SkruTreB14
	Dc.l	FACE_SkruTreB15,FACE_SkruTreB13
	Dc.l	0,FACE_SkruTreB6
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB14,DOT_SkruTreB2,DOT_SkruTreB1
	Dc.l	EDGE_SkruTreB25,EDGE_SkruTreB1,EDGE_SkruTreB27
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-30,-28
	Dc.b	-30,-4
	Dc.b	-38,-19
FACE_SkruTreB15
	Dc.l	FACE_SkruTreB16,FACE_SkruTreB14
	Dc.l	FACE_SkruTreB16,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB15,DOT_SkruTreB4,DOT_SkruTreB6
	Dc.l	EDGE_SkruTreB28,EDGE_SkruTreB6,EDGE_SkruTreB29
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-19,-48
	Dc.b	-11,-45
	Dc.b	-3,-60
FACE_SkruTreB16
	Dc.l	FACE_SkruTreB17,FACE_SkruTreB15
	Dc.l	0,FACE_SkruTreB5
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB5,DOT_SkruTreB6,DOT_SkruTreB15
	Dc.l	EDGE_SkruTreB5,EDGE_SkruTreB29,EDGE_SkruTreB30
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-19,-60
	Dc.b	-3,-60
	Dc.b	-19,-48
FACE_SkruTreB17
	Dc.l	FACE_SkruTreB18,FACE_SkruTreB16
	Dc.l	0,FACE_SkruTreB10
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB9,DOT_SkruTreB7,DOT_SkruTreB16
	Dc.l	EDGE_SkruTreB9,EDGE_SkruTreB31,EDGE_SkruTreB32
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-59,-60
	Dc.b	-43,-60
	Dc.b	-40,-48
FACE_SkruTreB18
	Dc.l	FACE_SkruTreB19,FACE_SkruTreB17
	Dc.l	0,FACE_SkruTreB19
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB16,DOT_SkruTreB8,DOT_SkruTreB9
	Dc.l	EDGE_SkruTreB33,EDGE_SkruTreB8,EDGE_SkruTreB32
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-40,-48
	Dc.b	-51,-45
	Dc.b	-59,-60
FACE_SkruTreB19
	Dc.l	FACE_SkruTreB20,FACE_SkruTreB18
	Dc.l	FACE_SkruTreB24,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB16,DOT_SkruTreB8,DOT_SkruTreB13
	Dc.l	EDGE_SkruTreB33,EDGE_SkruTreB22,EDGE_SkruTreB34
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-40,-48
	Dc.b	-51,-45
	Dc.b	-38,-36
FACE_SkruTreB20
	Dc.l	FACE_SkruTreB21,FACE_SkruTreB19
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB13,DOT_SkruTreB14,DOT_SkruTreB1
	Dc.l	EDGE_SkruTreB35,EDGE_SkruTreB27,EDGE_SkruTreB24
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-38,-36
	Dc.b	-30,-28
	Dc.b	-38,-19
FACE_SkruTreB21
	Dc.l	FACE_SkruTreB22,FACE_SkruTreB20
	Dc.l	0,FACE_SkruTreB1
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB14,DOT_SkruTreB11,DOT_SkruTreB3
	Dc.l	EDGE_SkruTreB36,EDGE_SkruTreB16,EDGE_SkruTreB26
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-30,-28
	Dc.b	-22,-36
	Dc.b	-22,-19
FACE_SkruTreB22
	Dc.l	FACE_SkruTreB23,FACE_SkruTreB21
	Dc.l	0,FACE_SkruTreB2
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB4,DOT_SkruTreB11,DOT_SkruTreB15
	Dc.l	EDGE_SkruTreB18,EDGE_SkruTreB37,EDGE_SkruTreB28
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-11,-45
	Dc.b	-22,-36
	Dc.b	-19,-48
FACE_SkruTreB23
	Dc.l	FACE_SkruTreB24,FACE_SkruTreB22
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB5,DOT_SkruTreB15,DOT_SkruTreB12
	Dc.l	EDGE_SkruTreB30,EDGE_SkruTreB38,EDGE_SkruTreB19
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-19,-60
	Dc.b	-19,-48
	Dc.b	-30,-51
FACE_SkruTreB24
	Dc.l	FACE_SkruTreB25,FACE_SkruTreB23
	Dc.l	0,FACE_SkruTreB3
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB12,DOT_SkruTreB16,DOT_SkruTreB7
	Dc.l	EDGE_SkruTreB39,EDGE_SkruTreB31,EDGE_SkruTreB21
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-30,-51
	Dc.b	-40,-48
	Dc.b	-43,-60
FACE_SkruTreB25
	Dc.l	FACE_SkruTreB26,FACE_SkruTreB24
	Dc.l	FACE_SkruTreB17,FACE_SkruTreB31
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB13,DOT_SkruTreB12,DOT_SkruTreB16
	Dc.l	EDGE_SkruTreB40,EDGE_SkruTreB39,EDGE_SkruTreB34
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-38,-36
	Dc.b	-30,-51
	Dc.b	-40,-48
FACE_SkruTreB26
	Dc.l	FACE_SkruTreB27,FACE_SkruTreB25
	Dc.l	FACE_SkruTreB20,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB13,DOT_SkruTreB14,DOT_SkruTreB11
	Dc.l	EDGE_SkruTreB35,EDGE_SkruTreB36,EDGE_SkruTreB41
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-38,-36
	Dc.b	-30,-28
	Dc.b	-22,-36
FACE_SkruTreB27
	Dc.l	FACE_SkruTreB28,FACE_SkruTreB26
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB15,DOT_SkruTreB11,DOT_SkruTreB12
	Dc.l	EDGE_SkruTreB37,EDGE_SkruTreB42,EDGE_SkruTreB38
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-19,-48
	Dc.b	-22,-36
	Dc.b	-30,-51
FACE_SkruTreB28
	Dc.l	FACE_SkruTreB29,FACE_SkruTreB27
	Dc.l	FACE_SkruTreB30,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB14,DOT_SkruTreB15,DOT_SkruTreB16
	Dc.l	EDGE_SkruTreB43,EDGE_SkruTreB44,EDGE_SkruTreB45
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-30,-28
	Dc.b	-19,-48
	Dc.b	-40,-48
FACE_SkruTreB29
	Dc.l	FACE_SkruTreB30,FACE_SkruTreB28
	Dc.l	0,FACE_SkruTreB28
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB15,DOT_SkruTreB11,DOT_SkruTreB14
	Dc.l	EDGE_SkruTreB37,EDGE_SkruTreB36,EDGE_SkruTreB43
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-19,-48
	Dc.b	-22,-36
	Dc.b	-30,-28
FACE_SkruTreB30
	Dc.l	FACE_SkruTreB31,FACE_SkruTreB29
	Dc.l	FACE_SkruTreB27,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB13,DOT_SkruTreB14,DOT_SkruTreB16
	Dc.l	EDGE_SkruTreB35,EDGE_SkruTreB45,EDGE_SkruTreB34
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-38,-36
	Dc.b	-30,-28
	Dc.b	-40,-48
FACE_SkruTreB31
	Dc.l	SkruTreBShell_Tail,FACE_SkruTreB30
	Dc.l	FACE_SkruTreB29,FACE_SkruTreB23
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTreB12,DOT_SkruTreB16,DOT_SkruTreB15
	Dc.l	EDGE_SkruTreB39,EDGE_SkruTreB44,EDGE_SkruTreB38
	Dc.l	TEXTURE_SkruTreB0
	Dc.b	-30,-51
	Dc.b	-40,-48
	Dc.b	-19,-48

EDGE_SkruTreB1
	Dc.l	EDGE_SkruTreB2,SkruTreBWire_Head
	Dc.l	DOT_SkruTreB1,DOT_SkruTreB2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB2
	Dc.l	EDGE_SkruTreB3,EDGE_SkruTreB1
	Dc.l	DOT_SkruTreB2,DOT_SkruTreB3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB3
	Dc.l	EDGE_SkruTreB4,EDGE_SkruTreB2
	Dc.l	DOT_SkruTreB1,DOT_SkruTreB3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB4
	Dc.l	EDGE_SkruTreB5,EDGE_SkruTreB3
	Dc.l	DOT_SkruTreB4,DOT_SkruTreB5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB5
	Dc.l	EDGE_SkruTreB6,EDGE_SkruTreB4
	Dc.l	DOT_SkruTreB5,DOT_SkruTreB6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB6
	Dc.l	EDGE_SkruTreB7,EDGE_SkruTreB5
	Dc.l	DOT_SkruTreB4,DOT_SkruTreB6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB7
	Dc.l	EDGE_SkruTreB8,EDGE_SkruTreB6
	Dc.l	DOT_SkruTreB7,DOT_SkruTreB8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB8
	Dc.l	EDGE_SkruTreB9,EDGE_SkruTreB7
	Dc.l	DOT_SkruTreB8,DOT_SkruTreB9
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB9
	Dc.l	EDGE_SkruTreB10,EDGE_SkruTreB8
	Dc.l	DOT_SkruTreB7,DOT_SkruTreB9
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB10
	Dc.l	EDGE_SkruTreB11,EDGE_SkruTreB9
	Dc.l	DOT_SkruTreB8,DOT_SkruTreB10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB11
	Dc.l	EDGE_SkruTreB12,EDGE_SkruTreB10
	Dc.l	DOT_SkruTreB7,DOT_SkruTreB10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB12
	Dc.l	EDGE_SkruTreB13,EDGE_SkruTreB11
	Dc.l	DOT_SkruTreB10,DOT_SkruTreB5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB13
	Dc.l	EDGE_SkruTreB14,EDGE_SkruTreB12
	Dc.l	DOT_SkruTreB10,DOT_SkruTreB4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB14
	Dc.l	EDGE_SkruTreB15,EDGE_SkruTreB13
	Dc.l	DOT_SkruTreB1,DOT_SkruTreB10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB15
	Dc.l	EDGE_SkruTreB16,EDGE_SkruTreB14
	Dc.l	DOT_SkruTreB3,DOT_SkruTreB10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB16
	Dc.l	EDGE_SkruTreB17,EDGE_SkruTreB15
	Dc.l	DOT_SkruTreB3,DOT_SkruTreB11
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB17
	Dc.l	EDGE_SkruTreB18,EDGE_SkruTreB16
	Dc.l	DOT_SkruTreB10,DOT_SkruTreB11
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB18
	Dc.l	EDGE_SkruTreB19,EDGE_SkruTreB17
	Dc.l	DOT_SkruTreB11,DOT_SkruTreB4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB19
	Dc.l	EDGE_SkruTreB20,EDGE_SkruTreB18
	Dc.l	DOT_SkruTreB5,DOT_SkruTreB12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB20
	Dc.l	EDGE_SkruTreB21,EDGE_SkruTreB19
	Dc.l	DOT_SkruTreB12,DOT_SkruTreB10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB21
	Dc.l	EDGE_SkruTreB22,EDGE_SkruTreB20
	Dc.l	DOT_SkruTreB7,DOT_SkruTreB12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB22
	Dc.l	EDGE_SkruTreB23,EDGE_SkruTreB21
	Dc.l	DOT_SkruTreB8,DOT_SkruTreB13
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB23
	Dc.l	EDGE_SkruTreB24,EDGE_SkruTreB22
	Dc.l	DOT_SkruTreB10,DOT_SkruTreB13
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB24
	Dc.l	EDGE_SkruTreB25,EDGE_SkruTreB23
	Dc.l	DOT_SkruTreB13,DOT_SkruTreB1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB25
	Dc.l	EDGE_SkruTreB26,EDGE_SkruTreB24
	Dc.l	DOT_SkruTreB14,DOT_SkruTreB2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB26
	Dc.l	EDGE_SkruTreB27,EDGE_SkruTreB25
	Dc.l	DOT_SkruTreB14,DOT_SkruTreB3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB27
	Dc.l	EDGE_SkruTreB28,EDGE_SkruTreB26
	Dc.l	DOT_SkruTreB14,DOT_SkruTreB1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB28
	Dc.l	EDGE_SkruTreB29,EDGE_SkruTreB27
	Dc.l	DOT_SkruTreB15,DOT_SkruTreB4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB29
	Dc.l	EDGE_SkruTreB30,EDGE_SkruTreB28
	Dc.l	DOT_SkruTreB15,DOT_SkruTreB6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB30
	Dc.l	EDGE_SkruTreB31,EDGE_SkruTreB29
	Dc.l	DOT_SkruTreB5,DOT_SkruTreB15
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB31
	Dc.l	EDGE_SkruTreB32,EDGE_SkruTreB30
	Dc.l	DOT_SkruTreB7,DOT_SkruTreB16
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB32
	Dc.l	EDGE_SkruTreB33,EDGE_SkruTreB31
	Dc.l	DOT_SkruTreB9,DOT_SkruTreB16
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB33
	Dc.l	EDGE_SkruTreB34,EDGE_SkruTreB32
	Dc.l	DOT_SkruTreB16,DOT_SkruTreB8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB34
	Dc.l	EDGE_SkruTreB35,EDGE_SkruTreB33
	Dc.l	DOT_SkruTreB16,DOT_SkruTreB13
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB35
	Dc.l	EDGE_SkruTreB36,EDGE_SkruTreB34
	Dc.l	DOT_SkruTreB13,DOT_SkruTreB14
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB36
	Dc.l	EDGE_SkruTreB37,EDGE_SkruTreB35
	Dc.l	DOT_SkruTreB14,DOT_SkruTreB11
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB37
	Dc.l	EDGE_SkruTreB38,EDGE_SkruTreB36
	Dc.l	DOT_SkruTreB11,DOT_SkruTreB15
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB38
	Dc.l	EDGE_SkruTreB39,EDGE_SkruTreB37
	Dc.l	DOT_SkruTreB15,DOT_SkruTreB12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB39
	Dc.l	EDGE_SkruTreB40,EDGE_SkruTreB38
	Dc.l	DOT_SkruTreB12,DOT_SkruTreB16
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB40
	Dc.l	EDGE_SkruTreB41,EDGE_SkruTreB39
	Dc.l	DOT_SkruTreB13,DOT_SkruTreB12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB41
	Dc.l	EDGE_SkruTreB42,EDGE_SkruTreB40
	Dc.l	DOT_SkruTreB13,DOT_SkruTreB11
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB42
	Dc.l	EDGE_SkruTreB43,EDGE_SkruTreB41
	Dc.l	DOT_SkruTreB11,DOT_SkruTreB12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB43
	Dc.l	EDGE_SkruTreB44,EDGE_SkruTreB42
	Dc.l	DOT_SkruTreB14,DOT_SkruTreB15
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB44
	Dc.l	EDGE_SkruTreB45,EDGE_SkruTreB43
	Dc.l	DOT_SkruTreB15,DOT_SkruTreB16
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTreB45
	Dc.l	SkruTreBWire_Tail,EDGE_SkruTreB44
	Dc.l	DOT_SkruTreB14,DOT_SkruTreB16
	Dc.b	0,0,0,0
	Dc.l	0

DOT_SkruTreB1
	Dc.l	DOT_SkruTreB2,SkruTreBNebula_Head
	Dc.l	-60,62,153
	Dc.l	COLOR_SkruTreB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreB2
	Dc.l	DOT_SkruTreB3,DOT_SkruTreB1
	Dc.l	0,62,253
	Dc.l	COLOR_SkruTreB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreB3
	Dc.l	DOT_SkruTreB4,DOT_SkruTreB2
	Dc.l	60,62,153
	Dc.l	COLOR_SkruTreB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreB4
	Dc.l	DOT_SkruTreB5,DOT_SkruTreB3
	Dc.l	140,62,-27
	Dc.l	COLOR_SkruTreB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreB5
	Dc.l	DOT_SkruTreB6,DOT_SkruTreB4
	Dc.l	80,62,-127
	Dc.l	COLOR_SkruTreB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreB6
	Dc.l	DOT_SkruTreB7,DOT_SkruTreB5
	Dc.l	200,62,-127
	Dc.l	COLOR_SkruTreB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreB7
	Dc.l	DOT_SkruTreB8,DOT_SkruTreB6
	Dc.l	-100,62,-127
	Dc.l	COLOR_SkruTreB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreB8
	Dc.l	DOT_SkruTreB9,DOT_SkruTreB7
	Dc.l	-160,62,-27
	Dc.l	COLOR_SkruTreB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreB9
	Dc.l	DOT_SkruTreB10,DOT_SkruTreB8
	Dc.l	-220,62,-127
	Dc.l	COLOR_SkruTreB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreB10
	Dc.l	DOT_SkruTreB11,DOT_SkruTreB9
	Dc.l	0,122,13
	Dc.l	COLOR_SkruTreB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreB11
	Dc.l	DOT_SkruTreB12,DOT_SkruTreB10
	Dc.l	60,142,33
	Dc.l	COLOR_SkruTreB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreB12
	Dc.l	DOT_SkruTreB13,DOT_SkruTreB11
	Dc.l	0,142,-67
	Dc.l	COLOR_SkruTreB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreB13
	Dc.l	DOT_SkruTreB14,DOT_SkruTreB12
	Dc.l	-60,142,33
	Dc.l	COLOR_SkruTreB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreB14
	Dc.l	DOT_SkruTreB15,DOT_SkruTreB13
	Dc.l	0,202,93
	Dc.l	COLOR_SkruTreB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreB15
	Dc.l	DOT_SkruTreB16,DOT_SkruTreB14
	Dc.l	80,202,-47
	Dc.l	COLOR_SkruTreB0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTreB16
	Dc.l	SkruTreBNebula_Tail,DOT_SkruTreB15
	Dc.l	-80,202,-47
	Dc.l	COLOR_SkruTreB0
	Dc.b	0,0
	Dc.l	0
