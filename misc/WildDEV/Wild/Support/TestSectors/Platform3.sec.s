; Wild Sector source made by META2Wild
; Made on 00:07:46 of 02-01-1978
; Sector name is Platform

SECTOR_Platform
	Dc.l	Platform_Succ,Platform_Pred
	QuickRefRel	0+Platform_PosX,0+Platform_PosY,0+Platform_PosZ
	Dc.l	Platform_Parent
	Dc.l	0
	Dc.b	0,0
	ListHeader	PlatformShell,FACE_Platform1,FACE_Platform10
	ListHeader	PlatformWire,EDGE_Platform1,EDGE_Platform15
	ListHeader	PlatformNebula,DOT_Platform1,DOT_Platform7
	Ds.b	Sphere_SIZE
	Dc.l	FACE_Platform4

COLOR_Platform0	EQU	$FFEEDD

FACE_Platform1
	Dc.l	FACE_Platform2,PlatformShell_Head
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform1,DOT_Platform2,DOT_Platform3
	Dc.l	EDGE_Platform1,EDGE_Platform2,EDGE_Platform3
	Dc.l	TEXTURE_Platform0
	Dc.b	125,123
	Dc.b	6,65
	Dc.b	125,4
FACE_Platform2
	Dc.l	FACE_Platform3,FACE_Platform1
	Dc.l	FACE_Platform10,FACE_Platform9
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform3,DOT_Platform4,DOT_Platform1
	Dc.l	EDGE_Platform4,EDGE_Platform5,EDGE_Platform3
	Dc.l	TEXTURE_Platform0
	Dc.b	125,4
	Dc.b	-4,58
	Dc.b	125,123
FACE_Platform3
	Dc.l	FACE_Platform4,FACE_Platform2
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform1,DOT_Platform5,DOT_Platform4
	Dc.l	EDGE_Platform6,EDGE_Platform7,EDGE_Platform5
	Dc.l	TEXTURE_Platform0
	Dc.b	125,123
	Dc.b	-4,-78
	Dc.b	-4,58
FACE_Platform4
	Dc.l	FACE_Platform5,FACE_Platform3
	Dc.l	FACE_Platform2,FACE_Platform6
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform5,DOT_Platform6,DOT_Platform1
	Dc.l	EDGE_Platform8,EDGE_Platform9,EDGE_Platform6
	Dc.l	TEXTURE_Platform0
	Dc.b	-4,-78
	Dc.b	-127,-5
	Dc.b	125,123
FACE_Platform5
	Dc.l	FACE_Platform6,FACE_Platform4
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform6,DOT_Platform1,DOT_Platform7
	Dc.l	EDGE_Platform9,EDGE_Platform10,EDGE_Platform11
	Dc.l	TEXTURE_Platform0
	Dc.b	-127,-5
	Dc.b	125,123
	Dc.b	5,-74
FACE_Platform6
	Dc.l	FACE_Platform7,FACE_Platform5
	Dc.l	FACE_Platform7,FACE_Platform8
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform7,DOT_Platform2,DOT_Platform1
	Dc.l	EDGE_Platform12,EDGE_Platform1,EDGE_Platform10
	Dc.l	TEXTURE_Platform0
	Dc.b	5,-74
	Dc.b	6,65
	Dc.b	125,123
FACE_Platform7
	Dc.l	FACE_Platform8,FACE_Platform6
	Dc.l	FACE_Platform1,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform6,DOT_Platform7,DOT_Platform2
	Dc.l	EDGE_Platform11,EDGE_Platform12,EDGE_Platform13
	Dc.l	TEXTURE_Platform0
	Dc.b	-127,-5
	Dc.b	5,-74
	Dc.b	6,65
FACE_Platform8
	Dc.l	FACE_Platform9,FACE_Platform7
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform2,DOT_Platform3,DOT_Platform4
	Dc.l	EDGE_Platform2,EDGE_Platform4,EDGE_Platform14
	Dc.l	TEXTURE_Platform0
	Dc.b	6,65
	Dc.b	125,4
	Dc.b	-4,58
FACE_Platform9
	Dc.l	FACE_Platform10,FACE_Platform8
	Dc.l	FACE_Platform5,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform5,DOT_Platform6,DOT_Platform4
	Dc.l	EDGE_Platform8,EDGE_Platform15,EDGE_Platform7
	Dc.l	TEXTURE_Platform0
	Dc.b	-4,-78
	Dc.b	-127,-5
	Dc.b	-4,58
FACE_Platform10
	Dc.l	PlatformShell_Tail,FACE_Platform9
	Dc.l	0,FACE_Platform3
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Platform4,DOT_Platform6,DOT_Platform2
	Dc.l	EDGE_Platform15,EDGE_Platform13,EDGE_Platform14
	Dc.l	TEXTURE_Platform0
	Dc.b	-4,58
	Dc.b	-127,-5
	Dc.b	6,65

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
	Dc.l	DOT_Platform4,DOT_Platform1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform6
	Dc.l	EDGE_Platform7,EDGE_Platform5
	Dc.l	DOT_Platform1,DOT_Platform5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform7
	Dc.l	EDGE_Platform8,EDGE_Platform6
	Dc.l	DOT_Platform5,DOT_Platform4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform8
	Dc.l	EDGE_Platform9,EDGE_Platform7
	Dc.l	DOT_Platform5,DOT_Platform6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform9
	Dc.l	EDGE_Platform10,EDGE_Platform8
	Dc.l	DOT_Platform6,DOT_Platform1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform10
	Dc.l	EDGE_Platform11,EDGE_Platform9
	Dc.l	DOT_Platform1,DOT_Platform7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform11
	Dc.l	EDGE_Platform12,EDGE_Platform10
	Dc.l	DOT_Platform6,DOT_Platform7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform12
	Dc.l	EDGE_Platform13,EDGE_Platform11
	Dc.l	DOT_Platform7,DOT_Platform2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform13
	Dc.l	EDGE_Platform14,EDGE_Platform12
	Dc.l	DOT_Platform6,DOT_Platform2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform14
	Dc.l	EDGE_Platform15,EDGE_Platform13
	Dc.l	DOT_Platform2,DOT_Platform4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Platform15
	Dc.l	PlatformWire_Tail,EDGE_Platform14
	Dc.l	DOT_Platform6,DOT_Platform4
	Dc.b	0,0,0,0
	Dc.l	0

DOT_Platform1
	Dc.l	DOT_Platform2,PlatformNebula_Head
	Dc.l	-35,739,-26
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform2
	Dc.l	DOT_Platform3,DOT_Platform1
	Dc.l	-1067,303,-533
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform3
	Dc.l	DOT_Platform4,DOT_Platform2
	Dc.l	-35,29,-1061
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform4
	Dc.l	DOT_Platform5,DOT_Platform3
	Dc.l	1071,303,-594
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform5
	Dc.l	DOT_Platform6,DOT_Platform4
	Dc.l	1071,-12,451
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform6
	Dc.l	DOT_Platform7,DOT_Platform5
	Dc.l	-3,303,1080
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
DOT_Platform7
	Dc.l	PlatformNebula_Tail,DOT_Platform6
	Dc.l	-1078,-22,482
	Dc.l	COLOR_Platform0
	Dc.b	0,0
	Dc.l	0
