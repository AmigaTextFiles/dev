; Wild Sector source made by META2Wild
; Made on 00:07:26 of 01-29-1978
; Sector name is Platform

SECTOR_Platform
	Dc.l	Platform_Succ,Platform_Pred
	QuickRefRel	0+Platform_PosX,0+Platform_PosY,0+Platform_PosZ
	Dc.l	Platform_Parent
	Dc.l	0
	Dc.b	0,0
	ListHeader	PlatformShell,FACE_Platform1,FACE_Platform30
	ListHeader	PlatformWire,EDGE_Platform1,EDGE_Platform49
	ListHeader	PlatformNebula,DOT_Platform1,DOT_Platform20
	Ds.b	Sphere_SIZE
	Dc.l	FACE_Platform3

COLOR_Platform0	EQU	$FFEEDD

FACE_Platform1
	Dc.l	FACE_Platform2,PlatformShell_Head
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform1,DOT_Platform2,DOT_Platform3
	Dc.l	EDGE_Platform1,EDGE_Platform2,EDGE_Platform3
	Dc.l	TEXTURE_Platform1
	Dc.b	-128,-118
	Dc.b	-128,-122
	Dc.b	-122,-121
FACE_Platform2
	Dc.l	FACE_Platform3,FACE_Platform1
	Dc.l	FACE_Platform1,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform3,DOT_Platform4,DOT_Platform5
	Dc.l	EDGE_Platform4,EDGE_Platform5,EDGE_Platform6
	Dc.l	TEXTURE_Platform1
	Dc.b	-122,-121
	Dc.b	-119,-128
	Dc.b	-123,-128
FACE_Platform3
	Dc.l	FACE_Platform4,FACE_Platform2
	Dc.l	FACE_Platform18,FACE_Platform4
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform4,DOT_Platform5,DOT_Platform6
	Dc.l	EDGE_Platform5,EDGE_Platform7,EDGE_Platform8
	Dc.l	TEXTURE_Platform1
	Dc.b	-119,-128
	Dc.b	-123,-128
	Dc.b	-122,121
FACE_Platform4
	Dc.l	FACE_Platform5,FACE_Platform3
	Dc.l	FACE_Platform24,FACE_Platform6
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform6,DOT_Platform7,DOT_Platform8
	Dc.l	EDGE_Platform9,EDGE_Platform10,EDGE_Platform11
	Dc.l	TEXTURE_Platform1
	Dc.b	-122,121
	Dc.b	-128,122
	Dc.b	-128,118
FACE_Platform5
	Dc.l	FACE_Platform6,FACE_Platform4
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform8,DOT_Platform9,DOT_Platform7
	Dc.l	EDGE_Platform12,EDGE_Platform13,EDGE_Platform10
	Dc.l	TEXTURE_Platform1
	Dc.b	-128,118
	Dc.b	122,121
	Dc.b	-128,122
FACE_Platform6
	Dc.l	FACE_Platform7,FACE_Platform5
	Dc.l	FACE_Platform27,FACE_Platform30
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform7,DOT_Platform10,DOT_Platform9
	Dc.l	EDGE_Platform14,EDGE_Platform15,EDGE_Platform13
	Dc.l	TEXTURE_Platform1
	Dc.b	-128,122
	Dc.b	123,-128
	Dc.b	122,121
FACE_Platform7
	Dc.l	FACE_Platform8,FACE_Platform6
	Dc.l	FACE_Platform8,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform9,DOT_Platform11,DOT_Platform10
	Dc.l	EDGE_Platform16,EDGE_Platform17,EDGE_Platform15
	Dc.l	TEXTURE_Platform1
	Dc.b	122,121
	Dc.b	119,-128
	Dc.b	123,-128
FACE_Platform8
	Dc.l	FACE_Platform9,FACE_Platform7
	Dc.l	0,FACE_Platform5
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform11,DOT_Platform10,DOT_Platform12
	Dc.l	EDGE_Platform17,EDGE_Platform18,EDGE_Platform19
	Dc.l	TEXTURE_Platform1
	Dc.b	119,-128
	Dc.b	123,-128
	Dc.b	122,-121
FACE_Platform9
	Dc.l	FACE_Platform10,FACE_Platform8
	Dc.l	FACE_Platform2,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform12,DOT_Platform1,DOT_Platform2
	Dc.l	EDGE_Platform20,EDGE_Platform1,EDGE_Platform21
	Dc.l	TEXTURE_Platform1
	Dc.b	122,-121
	Dc.b	-128,-118
	Dc.b	-128,-122
FACE_Platform10
	Dc.l	FACE_Platform11,FACE_Platform9
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform2,DOT_Platform12,DOT_Platform10
	Dc.l	EDGE_Platform21,EDGE_Platform18,EDGE_Platform22
	Dc.l	TEXTURE_Platform1
	Dc.b	-128,-122
	Dc.b	122,-121
	Dc.b	123,-128
FACE_Platform11
	Dc.l	FACE_Platform12,FACE_Platform10
	Dc.l	FACE_Platform13,FACE_Platform14
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform10,DOT_Platform2,DOT_Platform7
	Dc.l	EDGE_Platform22,EDGE_Platform23,EDGE_Platform14
	Dc.l	TEXTURE_Platform1
	Dc.b	123,-128
	Dc.b	-128,-122
	Dc.b	-128,122
FACE_Platform12
	Dc.l	FACE_Platform13,FACE_Platform11
	Dc.l	FACE_Platform10,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform6,DOT_Platform7,DOT_Platform5
	Dc.l	EDGE_Platform9,EDGE_Platform24,EDGE_Platform7
	Dc.l	TEXTURE_Platform1
	Dc.b	-122,121
	Dc.b	-128,122
	Dc.b	-123,-128
FACE_Platform13
	Dc.l	FACE_Platform14,FACE_Platform12
	Dc.l	FACE_Platform12,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform5,DOT_Platform2,DOT_Platform3
	Dc.l	EDGE_Platform25,EDGE_Platform2,EDGE_Platform6
	Dc.l	TEXTURE_Platform1
	Dc.b	-123,-128
	Dc.b	-128,-122
	Dc.b	-122,-121
FACE_Platform14
	Dc.l	FACE_Platform15,FACE_Platform13
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform5,DOT_Platform2,DOT_Platform7
	Dc.l	EDGE_Platform25,EDGE_Platform23,EDGE_Platform24
	Dc.l	TEXTURE_Platform1
	Dc.b	-123,-128
	Dc.b	-128,-122
	Dc.b	-128,122
FACE_Platform15
	Dc.l	FACE_Platform16,FACE_Platform14
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform13,DOT_Platform1,DOT_Platform14
	Dc.l	EDGE_Platform26,EDGE_Platform27,EDGE_Platform28
	Dc.l	TEXTURE_Platform1
	Dc.b	-126,-3
	Dc.b	-128,-118
	Dc.b	-27,-22
FACE_Platform16
	Dc.l	FACE_Platform17,FACE_Platform15
	Dc.l	FACE_Platform17,FACE_Platform15
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform1,DOT_Platform14,DOT_Platform3
	Dc.l	EDGE_Platform27,EDGE_Platform29,EDGE_Platform3
	Dc.l	TEXTURE_Platform1
	Dc.b	-128,-118
	Dc.b	-27,-22
	Dc.b	-122,-121
FACE_Platform17
	Dc.l	FACE_Platform18,FACE_Platform16
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform3,DOT_Platform14,DOT_Platform15
	Dc.l	EDGE_Platform29,EDGE_Platform30,EDGE_Platform31
	Dc.l	TEXTURE_Platform1
	Dc.b	-122,-121
	Dc.b	-27,-22
	Dc.b	-3,-121
FACE_Platform18
	Dc.l	FACE_Platform19,FACE_Platform17
	Dc.l	FACE_Platform21,FACE_Platform16
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform15,DOT_Platform3,DOT_Platform4
	Dc.l	EDGE_Platform31,EDGE_Platform4,EDGE_Platform32
	Dc.l	TEXTURE_Platform1
	Dc.b	-3,-121
	Dc.b	-122,-121
	Dc.b	-119,-128
FACE_Platform19
	Dc.l	FACE_Platform20,FACE_Platform18
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform4,DOT_Platform15,DOT_Platform6
	Dc.l	EDGE_Platform32,EDGE_Platform33,EDGE_Platform8
	Dc.l	TEXTURE_Platform1
	Dc.b	-119,-128
	Dc.b	-3,-121
	Dc.b	-122,121
FACE_Platform20
	Dc.l	FACE_Platform21,FACE_Platform19
	Dc.l	FACE_Platform19,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform6,DOT_Platform15,DOT_Platform16
	Dc.l	EDGE_Platform33,EDGE_Platform34,EDGE_Platform35
	Dc.l	TEXTURE_Platform1
	Dc.b	-122,121
	Dc.b	-3,-121
	Dc.b	-33,23
FACE_Platform21
	Dc.l	FACE_Platform22,FACE_Platform20
	Dc.l	FACE_Platform22,FACE_Platform20
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform16,DOT_Platform6,DOT_Platform8
	Dc.l	EDGE_Platform35,EDGE_Platform11,EDGE_Platform36
	Dc.l	TEXTURE_Platform1
	Dc.b	-33,23
	Dc.b	-122,121
	Dc.b	-128,118
FACE_Platform22
	Dc.l	FACE_Platform23,FACE_Platform21
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform8,DOT_Platform16,DOT_Platform17
	Dc.l	EDGE_Platform36,EDGE_Platform37,EDGE_Platform38
	Dc.l	TEXTURE_Platform1
	Dc.b	-128,118
	Dc.b	-33,23
	Dc.b	-127,0
FACE_Platform23
	Dc.l	FACE_Platform24,FACE_Platform22
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform17,DOT_Platform8,DOT_Platform18
	Dc.l	EDGE_Platform38,EDGE_Platform39,EDGE_Platform40
	Dc.l	TEXTURE_Platform1
	Dc.b	-127,0
	Dc.b	-128,118
	Dc.b	33,20
FACE_Platform24
	Dc.l	FACE_Platform25,FACE_Platform23
	Dc.l	FACE_Platform25,FACE_Platform23
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform8,DOT_Platform18,DOT_Platform9
	Dc.l	EDGE_Platform39,EDGE_Platform41,EDGE_Platform12
	Dc.l	TEXTURE_Platform1
	Dc.b	-128,118
	Dc.b	33,20
	Dc.b	122,121
FACE_Platform25
	Dc.l	FACE_Platform26,FACE_Platform24
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform9,DOT_Platform18,DOT_Platform19
	Dc.l	EDGE_Platform41,EDGE_Platform42,EDGE_Platform43
	Dc.l	TEXTURE_Platform1
	Dc.b	122,121
	Dc.b	33,20
	Dc.b	2,-120
FACE_Platform26
	Dc.l	FACE_Platform27,FACE_Platform25
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform19,DOT_Platform9,DOT_Platform11
	Dc.l	EDGE_Platform43,EDGE_Platform16,EDGE_Platform44
	Dc.l	TEXTURE_Platform1
	Dc.b	2,-120
	Dc.b	122,121
	Dc.b	119,-128
FACE_Platform27
	Dc.l	FACE_Platform28,FACE_Platform26
	Dc.l	FACE_Platform28,FACE_Platform26
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform11,DOT_Platform19,DOT_Platform12
	Dc.l	EDGE_Platform44,EDGE_Platform45,EDGE_Platform19
	Dc.l	TEXTURE_Platform1
	Dc.b	119,-128
	Dc.b	2,-120
	Dc.b	122,-121
FACE_Platform28
	Dc.l	FACE_Platform29,FACE_Platform27
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform12,DOT_Platform20,DOT_Platform19
	Dc.l	EDGE_Platform46,EDGE_Platform47,EDGE_Platform45
	Dc.l	TEXTURE_Platform1
	Dc.b	122,-121
	Dc.b	36,-24
	Dc.b	2,-120
FACE_Platform29
	Dc.l	FACE_Platform30,FACE_Platform28
	Dc.l	FACE_Platform7,FACE_Platform9
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform12,DOT_Platform20,DOT_Platform1
	Dc.l	EDGE_Platform46,EDGE_Platform48,EDGE_Platform20
	Dc.l	TEXTURE_Platform1
	Dc.b	122,-121
	Dc.b	36,-24
	Dc.b	-128,-118
FACE_Platform30
	Dc.l	PlatformShell_Tail,FACE_Platform29
	Dc.l	FACE_Platform11,FACE_Platform29
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform1,DOT_Platform20,DOT_Platform13
	Dc.l	EDGE_Platform48,EDGE_Platform49,EDGE_Platform26
	Dc.l	TEXTURE_Platform1
	Dc.b	-128,-118
	Dc.b	36,-24
	Dc.b	-126,-3

EDGE_Platform1
	Dc.l	EDGE_Platform2,PlatformWire_Head
	Dc.l	DOT_Platform1,DOT_Platform2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform2
	Dc.l	EDGE_Platform3,EDGE_Platform1
	Dc.l	DOT_Platform2,DOT_Platform3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform3
	Dc.l	EDGE_Platform4,EDGE_Platform2
	Dc.l	DOT_Platform1,DOT_Platform3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform4
	Dc.l	EDGE_Platform5,EDGE_Platform3
	Dc.l	DOT_Platform3,DOT_Platform4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform5
	Dc.l	EDGE_Platform6,EDGE_Platform4
	Dc.l	DOT_Platform4,DOT_Platform5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform6
	Dc.l	EDGE_Platform7,EDGE_Platform5
	Dc.l	DOT_Platform3,DOT_Platform5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform7
	Dc.l	EDGE_Platform8,EDGE_Platform6
	Dc.l	DOT_Platform5,DOT_Platform6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform8
	Dc.l	EDGE_Platform9,EDGE_Platform7
	Dc.l	DOT_Platform4,DOT_Platform6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform9
	Dc.l	EDGE_Platform10,EDGE_Platform8
	Dc.l	DOT_Platform6,DOT_Platform7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform10
	Dc.l	EDGE_Platform11,EDGE_Platform9
	Dc.l	DOT_Platform7,DOT_Platform8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform11
	Dc.l	EDGE_Platform12,EDGE_Platform10
	Dc.l	DOT_Platform6,DOT_Platform8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform12
	Dc.l	EDGE_Platform13,EDGE_Platform11
	Dc.l	DOT_Platform8,DOT_Platform9
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform13
	Dc.l	EDGE_Platform14,EDGE_Platform12
	Dc.l	DOT_Platform9,DOT_Platform7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform14
	Dc.l	EDGE_Platform15,EDGE_Platform13
	Dc.l	DOT_Platform7,DOT_Platform10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform15
	Dc.l	EDGE_Platform16,EDGE_Platform14
	Dc.l	DOT_Platform10,DOT_Platform9
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform16
	Dc.l	EDGE_Platform17,EDGE_Platform15
	Dc.l	DOT_Platform9,DOT_Platform11
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform17
	Dc.l	EDGE_Platform18,EDGE_Platform16
	Dc.l	DOT_Platform11,DOT_Platform10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform18
	Dc.l	EDGE_Platform19,EDGE_Platform17
	Dc.l	DOT_Platform10,DOT_Platform12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform19
	Dc.l	EDGE_Platform20,EDGE_Platform18
	Dc.l	DOT_Platform11,DOT_Platform12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform20
	Dc.l	EDGE_Platform21,EDGE_Platform19
	Dc.l	DOT_Platform12,DOT_Platform1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform21
	Dc.l	EDGE_Platform22,EDGE_Platform20
	Dc.l	DOT_Platform12,DOT_Platform2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform22
	Dc.l	EDGE_Platform23,EDGE_Platform21
	Dc.l	DOT_Platform2,DOT_Platform10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform23
	Dc.l	EDGE_Platform24,EDGE_Platform22
	Dc.l	DOT_Platform2,DOT_Platform7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform24
	Dc.l	EDGE_Platform25,EDGE_Platform23
	Dc.l	DOT_Platform7,DOT_Platform5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform25
	Dc.l	EDGE_Platform26,EDGE_Platform24
	Dc.l	DOT_Platform5,DOT_Platform2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform26
	Dc.l	EDGE_Platform27,EDGE_Platform25
	Dc.l	DOT_Platform13,DOT_Platform1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform27
	Dc.l	EDGE_Platform28,EDGE_Platform26
	Dc.l	DOT_Platform1,DOT_Platform14
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform28
	Dc.l	EDGE_Platform29,EDGE_Platform27
	Dc.l	DOT_Platform13,DOT_Platform14
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform29
	Dc.l	EDGE_Platform30,EDGE_Platform28
	Dc.l	DOT_Platform14,DOT_Platform3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform30
	Dc.l	EDGE_Platform31,EDGE_Platform29
	Dc.l	DOT_Platform14,DOT_Platform15
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform31
	Dc.l	EDGE_Platform32,EDGE_Platform30
	Dc.l	DOT_Platform3,DOT_Platform15
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform32
	Dc.l	EDGE_Platform33,EDGE_Platform31
	Dc.l	DOT_Platform15,DOT_Platform4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform33
	Dc.l	EDGE_Platform34,EDGE_Platform32
	Dc.l	DOT_Platform15,DOT_Platform6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform34
	Dc.l	EDGE_Platform35,EDGE_Platform33
	Dc.l	DOT_Platform15,DOT_Platform16
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform35
	Dc.l	EDGE_Platform36,EDGE_Platform34
	Dc.l	DOT_Platform6,DOT_Platform16
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform36
	Dc.l	EDGE_Platform37,EDGE_Platform35
	Dc.l	DOT_Platform16,DOT_Platform8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform37
	Dc.l	EDGE_Platform38,EDGE_Platform36
	Dc.l	DOT_Platform16,DOT_Platform17
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform38
	Dc.l	EDGE_Platform39,EDGE_Platform37
	Dc.l	DOT_Platform8,DOT_Platform17
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform39
	Dc.l	EDGE_Platform40,EDGE_Platform38
	Dc.l	DOT_Platform8,DOT_Platform18
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform40
	Dc.l	EDGE_Platform41,EDGE_Platform39
	Dc.l	DOT_Platform17,DOT_Platform18
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform41
	Dc.l	EDGE_Platform42,EDGE_Platform40
	Dc.l	DOT_Platform18,DOT_Platform9
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform42
	Dc.l	EDGE_Platform43,EDGE_Platform41
	Dc.l	DOT_Platform18,DOT_Platform19
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform43
	Dc.l	EDGE_Platform44,EDGE_Platform42
	Dc.l	DOT_Platform9,DOT_Platform19
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform44
	Dc.l	EDGE_Platform45,EDGE_Platform43
	Dc.l	DOT_Platform19,DOT_Platform11
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform45
	Dc.l	EDGE_Platform46,EDGE_Platform44
	Dc.l	DOT_Platform19,DOT_Platform12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform46
	Dc.l	EDGE_Platform47,EDGE_Platform45
	Dc.l	DOT_Platform12,DOT_Platform20
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform47
	Dc.l	EDGE_Platform48,EDGE_Platform46
	Dc.l	DOT_Platform20,DOT_Platform19
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform48
	Dc.l	EDGE_Platform49,EDGE_Platform47
	Dc.l	DOT_Platform20,DOT_Platform1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform49
	Dc.l	PlatformWire_Tail,EDGE_Platform48
	Dc.l	DOT_Platform20,DOT_Platform13
	Dc.b	0,0,0,0
	Dc.l	0

DOT_Platform1
	Dc.l	DOT_Platform2,PlatformNebula_Head
	Dc.l	7,18,297
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform2
	Dc.l	DOT_Platform3,DOT_Platform1
	Dc.l	7,-72,194
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform3
	Dc.l	DOT_Platform4,DOT_Platform2
	Dc.l	211,-27,217
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform4
	Dc.l	DOT_Platform5,DOT_Platform3
	Dc.l	309,18,21
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform5
	Dc.l	DOT_Platform6,DOT_Platform4
	Dc.l	173,-72,21
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform6
	Dc.l	DOT_Platform7,DOT_Platform5
	Dc.l	204,-27,-191
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform7
	Dc.l	DOT_Platform8,DOT_Platform6
	Dc.l	7,-72,-153
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform8
	Dc.l	DOT_Platform9,DOT_Platform7
	Dc.l	-4,18,-278
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform9
	Dc.l	DOT_Platform10,DOT_Platform8
	Dc.l	-201,-27,-188
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform10
	Dc.l	DOT_Platform11,DOT_Platform9
	Dc.l	-164,-72,21
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform11
	Dc.l	DOT_Platform12,DOT_Platform10
	Dc.l	-303,18,24
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform12
	Dc.l	DOT_Platform13,DOT_Platform11
	Dc.l	-191,-27,227
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform13
	Dc.l	DOT_Platform14,DOT_Platform12
	Dc.l	79,18,3664
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform14
	Dc.l	DOT_Platform15,DOT_Platform13
	Dc.l	3380,18,3122
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform15
	Dc.l	DOT_Platform16,DOT_Platform14
	Dc.l	4169,18,208
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform16
	Dc.l	DOT_Platform17,DOT_Platform15
	Dc.l	3164,18,-3044
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform17
	Dc.l	DOT_Platform18,DOT_Platform16
	Dc.l	43,18,-3722
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform18
	Dc.l	DOT_Platform19,DOT_Platform17
	Dc.l	-3150,18,-3146
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform19
	Dc.l	DOT_Platform20,DOT_Platform18
	Dc.l	-4190,18,242
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform20
	Dc.l	PlatformNebula_Tail,DOT_Platform19
	Dc.l	-3042,18,3054
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
