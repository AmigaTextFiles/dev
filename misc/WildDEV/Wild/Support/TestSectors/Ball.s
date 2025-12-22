; Wild Sector source made by META2Wild
; Made on 10:39:13 of 07-17-1998
; Sector name is Ball

SECTOR_Ball
	Dc.l	Ball_Succ,Ball_Pred
	QuickRefRel	0,-250,0
	Dc.l	Ball_Parent
	Dc.l	0
	Dc.b	0,0
	ListHeader	BallShell,FACE_Ball1,FACE_Ball16
	ListHeader	BallWire,EDGE_Ball1,EDGE_Ball24
	ListHeader	BallNebula,DOT_Ball1,DOT_Ball10
	Ds.b	Sphere_SIZE
	Dc.l	FACE_Ball2

COLOR_Ball0	EQU	$FFEEDD

FACE_Ball1
	Dc.l	FACE_Ball2,BallShell_Head
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Ball1,DOT_Ball2,DOT_Ball3
	Dc.l	EDGE_Ball1,EDGE_Ball2,EDGE_Ball3
	Dc.l	TEXTURE_Ball1
	Dc.b	0,64
	Dc.b	64,64
	Dc.b	32,0
FACE_Ball2
	Dc.l	FACE_Ball3,FACE_Ball1
	Dc.l	FACE_Ball16,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Ball3,DOT_Ball1,DOT_Ball4
	Dc.l	EDGE_Ball3,EDGE_Ball4,EDGE_Ball5
	Dc.l	TEXTURE_Ball1
	Dc.b	0,64
	Dc.b	64,64
	Dc.b	32,0
FACE_Ball3
	Dc.l	FACE_Ball4,FACE_Ball2
	Dc.l	FACE_Ball5,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Ball4,DOT_Ball1,DOT_Ball5
	Dc.l	EDGE_Ball5,EDGE_Ball6,EDGE_Ball7
	Dc.l	TEXTURE_Ball1
	Dc.b	0,64
	Dc.b	64,64
	Dc.b	32,0
FACE_Ball4
	Dc.l	FACE_Ball5,FACE_Ball3
	Dc.l	FACE_Ball3,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Ball1,DOT_Ball5,DOT_Ball2
	Dc.l	EDGE_Ball7,EDGE_Ball8,EDGE_Ball1
	Dc.l	TEXTURE_Ball1
	Dc.b	0,64
	Dc.b	64,64
	Dc.b	32,0
FACE_Ball5
	Dc.l	FACE_Ball6,FACE_Ball4
	Dc.l	0,FACE_Ball8
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Ball2,DOT_Ball3,DOT_Ball6
	Dc.l	EDGE_Ball2,EDGE_Ball9,EDGE_Ball10
	Dc.l	TEXTURE_Ball1
	Dc.b	0,64
	Dc.b	64,64
	Dc.b	32,0
FACE_Ball6
	Dc.l	FACE_Ball7,FACE_Ball5
	Dc.l	FACE_Ball7,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Ball7,DOT_Ball6,DOT_Ball3
	Dc.l	EDGE_Ball11,EDGE_Ball12,EDGE_Ball9
	Dc.l	TEXTURE_Ball1
	Dc.b	0,64
	Dc.b	64,64
	Dc.b	32,0
FACE_Ball7
	Dc.l	FACE_Ball8,FACE_Ball6
	Dc.l	0,FACE_Ball10
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Ball3,DOT_Ball4,DOT_Ball7
	Dc.l	EDGE_Ball4,EDGE_Ball13,EDGE_Ball12
	Dc.l	TEXTURE_Ball1
	Dc.b	0,64
	Dc.b	64,64
	Dc.b	32,0
FACE_Ball8
	Dc.l	FACE_Ball9,FACE_Ball7
	Dc.l	FACE_Ball9,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Ball8,DOT_Ball7,DOT_Ball4
	Dc.l	EDGE_Ball14,EDGE_Ball15,EDGE_Ball13
	Dc.l	TEXTURE_Ball1
	Dc.b	0,64
	Dc.b	64,64
	Dc.b	32,0
FACE_Ball9
	Dc.l	FACE_Ball10,FACE_Ball8
	Dc.l	0,FACE_Ball12
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Ball4,DOT_Ball5,DOT_Ball8
	Dc.l	EDGE_Ball6,EDGE_Ball16,EDGE_Ball15
	Dc.l	TEXTURE_Ball1
	Dc.b	0,64
	Dc.b	64,64
	Dc.b	32,0
FACE_Ball10
	Dc.l	FACE_Ball11,FACE_Ball9
	Dc.l	FACE_Ball11,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Ball9,DOT_Ball8,DOT_Ball5
	Dc.l	EDGE_Ball17,EDGE_Ball18,EDGE_Ball16
	Dc.l	TEXTURE_Ball1
	Dc.b	0,64
	Dc.b	64,64
	Dc.b	32,0
FACE_Ball11
	Dc.l	FACE_Ball12,FACE_Ball10
	Dc.l	0,FACE_Ball14
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Ball5,DOT_Ball2,DOT_Ball9
	Dc.l	EDGE_Ball8,EDGE_Ball19,EDGE_Ball18
	Dc.l	TEXTURE_Ball1
	Dc.b	0,64
	Dc.b	64,64
	Dc.b	32,0
FACE_Ball12
	Dc.l	FACE_Ball13,FACE_Ball11
	Dc.l	FACE_Ball13,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Ball6,DOT_Ball9,DOT_Ball2
	Dc.l	EDGE_Ball20,EDGE_Ball10,EDGE_Ball19
	Dc.l	TEXTURE_Ball1
	Dc.b	0,64
	Dc.b	64,64
	Dc.b	32,0
FACE_Ball13
	Dc.l	FACE_Ball14,FACE_Ball12
	Dc.l	0,FACE_Ball6
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Ball6,DOT_Ball7,DOT_Ball10
	Dc.l	EDGE_Ball11,EDGE_Ball21,EDGE_Ball22
	Dc.l	TEXTURE_Ball1
	Dc.b	0,64
	Dc.b	64,64
	Dc.b	32,0
FACE_Ball14
	Dc.l	FACE_Ball15,FACE_Ball13
	Dc.l	0,FACE_Ball15
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Ball7,DOT_Ball8,DOT_Ball10
	Dc.l	EDGE_Ball14,EDGE_Ball23,EDGE_Ball21
	Dc.l	TEXTURE_Ball1
	Dc.b	0,64
	Dc.b	64,64
	Dc.b	32,0
FACE_Ball15
	Dc.l	FACE_Ball16,FACE_Ball14
	Dc.l	0,FACE_Ball1
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Ball8,DOT_Ball9,DOT_Ball10
	Dc.l	EDGE_Ball17,EDGE_Ball24,EDGE_Ball23
	Dc.l	TEXTURE_Ball1
	Dc.b	0,64
	Dc.b	64,64
	Dc.b	32,0
FACE_Ball16
	Dc.l	BallShell_Tail,FACE_Ball15
	Dc.l	0,FACE_Ball4
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Ball9,DOT_Ball6,DOT_Ball10
	Dc.l	EDGE_Ball20,EDGE_Ball22,EDGE_Ball24
	Dc.l	TEXTURE_Ball1
	Dc.b	0,64
	Dc.b	64,64
	Dc.b	32,0

EDGE_Ball1
	Dc.l	EDGE_Ball2,BallWire_Head
	Dc.l	DOT_Ball1,DOT_Ball2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball2
	Dc.l	EDGE_Ball3,EDGE_Ball1
	Dc.l	DOT_Ball2,DOT_Ball3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball3
	Dc.l	EDGE_Ball4,EDGE_Ball2
	Dc.l	DOT_Ball1,DOT_Ball3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball4
	Dc.l	EDGE_Ball5,EDGE_Ball3
	Dc.l	DOT_Ball3,DOT_Ball4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball5
	Dc.l	EDGE_Ball6,EDGE_Ball4
	Dc.l	DOT_Ball1,DOT_Ball4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball6
	Dc.l	EDGE_Ball7,EDGE_Ball5
	Dc.l	DOT_Ball4,DOT_Ball5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball7
	Dc.l	EDGE_Ball8,EDGE_Ball6
	Dc.l	DOT_Ball1,DOT_Ball5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball8
	Dc.l	EDGE_Ball9,EDGE_Ball7
	Dc.l	DOT_Ball5,DOT_Ball2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball9
	Dc.l	EDGE_Ball10,EDGE_Ball8
	Dc.l	DOT_Ball3,DOT_Ball6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball10
	Dc.l	EDGE_Ball11,EDGE_Ball9
	Dc.l	DOT_Ball2,DOT_Ball6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball11
	Dc.l	EDGE_Ball12,EDGE_Ball10
	Dc.l	DOT_Ball6,DOT_Ball7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball12
	Dc.l	EDGE_Ball13,EDGE_Ball11
	Dc.l	DOT_Ball7,DOT_Ball3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball13
	Dc.l	EDGE_Ball14,EDGE_Ball12
	Dc.l	DOT_Ball4,DOT_Ball7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball14
	Dc.l	EDGE_Ball15,EDGE_Ball13
	Dc.l	DOT_Ball7,DOT_Ball8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball15
	Dc.l	EDGE_Ball16,EDGE_Ball14
	Dc.l	DOT_Ball8,DOT_Ball4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball16
	Dc.l	EDGE_Ball17,EDGE_Ball15
	Dc.l	DOT_Ball5,DOT_Ball8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball17
	Dc.l	EDGE_Ball18,EDGE_Ball16
	Dc.l	DOT_Ball8,DOT_Ball9
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball18
	Dc.l	EDGE_Ball19,EDGE_Ball17
	Dc.l	DOT_Ball9,DOT_Ball5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball19
	Dc.l	EDGE_Ball20,EDGE_Ball18
	Dc.l	DOT_Ball2,DOT_Ball9
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball20
	Dc.l	EDGE_Ball21,EDGE_Ball19
	Dc.l	DOT_Ball9,DOT_Ball6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball21
	Dc.l	EDGE_Ball22,EDGE_Ball20
	Dc.l	DOT_Ball7,DOT_Ball10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball22
	Dc.l	EDGE_Ball23,EDGE_Ball21
	Dc.l	DOT_Ball6,DOT_Ball10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball23
	Dc.l	EDGE_Ball24,EDGE_Ball22
	Dc.l	DOT_Ball8,DOT_Ball10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Ball24
	Dc.l	BallWire_Tail,EDGE_Ball23
	Dc.l	DOT_Ball9,DOT_Ball10
	Dc.b	0,0,0,0
	Dc.l	0

DOT_Ball1
	Dc.l	DOT_Ball2,BallNebula_Head
	Dc.l	0,0,0
	Dc.l	COLOR_Ball0
	Dc.b	0,0
	Dc.l	0
DOT_Ball2
	Dc.l	DOT_Ball3,DOT_Ball1
	Dc.l	40,-17,25
	Dc.l	COLOR_Ball0
	Dc.b	0,0
	Dc.l	0
DOT_Ball3
	Dc.l	DOT_Ball4,DOT_Ball2
	Dc.l	16,40,25
	Dc.l	COLOR_Ball0
	Dc.b	0,0
	Dc.l	0
DOT_Ball4
	Dc.l	DOT_Ball5,DOT_Ball3
	Dc.l	-41,16,25
	Dc.l	COLOR_Ball0
	Dc.b	0,0
	Dc.l	0
DOT_Ball5
	Dc.l	DOT_Ball6,DOT_Ball4
	Dc.l	-17,-41,25
	Dc.l	COLOR_Ball0
	Dc.b	0,0
	Dc.l	0
DOT_Ball6
	Dc.l	DOT_Ball7,DOT_Ball5
	Dc.l	40,16,75
	Dc.l	COLOR_Ball0
	Dc.b	0,0
	Dc.l	0
DOT_Ball7
	Dc.l	DOT_Ball8,DOT_Ball6
	Dc.l	-17,40,75
	Dc.l	COLOR_Ball0
	Dc.b	0,0
	Dc.l	0
DOT_Ball8
	Dc.l	DOT_Ball9,DOT_Ball7
	Dc.l	-41,-17,75
	Dc.l	COLOR_Ball0
	Dc.b	0,0
	Dc.l	0
DOT_Ball9
	Dc.l	DOT_Ball10,DOT_Ball8
	Dc.l	16,-41,75
	Dc.l	COLOR_Ball0
	Dc.b	0,0
	Dc.l	0
DOT_Ball10
	Dc.l	BallNebula_Tail,DOT_Ball9
	Dc.l	0,0,100
	Dc.l	COLOR_Ball0
	Dc.b	0,0
	Dc.l	0
