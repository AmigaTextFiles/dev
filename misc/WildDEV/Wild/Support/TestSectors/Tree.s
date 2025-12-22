; Wild Sector source made by META2Wild
; Made on 07:01:03 of 01-22-1978
; Sector name is Tree

TEXTURE_Tree0	EQU	TextTex

SECTOR_Tree
	Dc.l	Tree_Succ,Tree_Pred
	QuickRefRel	-110,-3,-116
	Dc.l	Tree_Parent
	Dc.l	0
	Dc.b	0,0
	ListHeader	TreeShell,FACE_Tree1,FACE_Tree15
	ListHeader	TreeWire,EDGE_Tree1,EDGE_Tree24
	ListHeader	TreeNebula,DOT_Tree1,DOT_Tree10
	Ds.b	Sphere_SIZE
	Dc.l	FACE_Tree6

COLOR_Tree0	EQU	$FFEEDD

FACE_Tree1
	Dc.l	FACE_Tree2,TreeShell_Head
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Tree1,DOT_Tree2,DOT_Tree3
	Dc.l	EDGE_Tree1,EDGE_Tree2,EDGE_Tree3
	Dc.l	TEXTURE_Tree0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_Tree2
	Dc.l	FACE_Tree3,FACE_Tree1
	Dc.l	0,FACE_Tree1
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Tree3,DOT_Tree2,DOT_Tree4
	Dc.l	EDGE_Tree2,EDGE_Tree4,EDGE_Tree5
	Dc.l	TEXTURE_Tree0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_Tree3
	Dc.l	FACE_Tree4,FACE_Tree2
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Tree4,DOT_Tree2,DOT_Tree5
	Dc.l	EDGE_Tree5,EDGE_Tree6,EDGE_Tree7
	Dc.l	TEXTURE_Tree0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_Tree4
	Dc.l	FACE_Tree5,FACE_Tree3
	Dc.l	FACE_Tree5,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Tree4,DOT_Tree5,DOT_Tree6
	Dc.l	EDGE_Tree6,EDGE_Tree8,EDGE_Tree9
	Dc.l	TEXTURE_Tree0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_Tree5
	Dc.l	FACE_Tree6,FACE_Tree4
	Dc.l	0,FACE_Tree3
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Tree6,DOT_Tree5,DOT_Tree1
	Dc.l	EDGE_Tree8,EDGE_Tree10,EDGE_Tree11
	Dc.l	TEXTURE_Tree0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_Tree6
	Dc.l	FACE_Tree7,FACE_Tree5
	Dc.l	FACE_Tree13,FACE_Tree11
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Tree3,DOT_Tree6,DOT_Tree1
	Dc.l	EDGE_Tree12,EDGE_Tree3,EDGE_Tree10
	Dc.l	TEXTURE_Tree0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_Tree7
	Dc.l	FACE_Tree8,FACE_Tree6
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Tree7,DOT_Tree4,DOT_Tree8
	Dc.l	EDGE_Tree13,EDGE_Tree14,EDGE_Tree15
	Dc.l	TEXTURE_Tree0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_Tree8
	Dc.l	FACE_Tree9,FACE_Tree7
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Tree8,DOT_Tree3,DOT_Tree7
	Dc.l	EDGE_Tree16,EDGE_Tree17,EDGE_Tree14
	Dc.l	TEXTURE_Tree0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_Tree9
	Dc.l	FACE_Tree10,FACE_Tree8
	Dc.l	FACE_Tree2,FACE_Tree7
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Tree7,DOT_Tree3,DOT_Tree4
	Dc.l	EDGE_Tree17,EDGE_Tree13,EDGE_Tree4
	Dc.l	TEXTURE_Tree0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_Tree10
	Dc.l	FACE_Tree11,FACE_Tree9
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Tree8,DOT_Tree4,DOT_Tree9
	Dc.l	EDGE_Tree15,EDGE_Tree18,EDGE_Tree19
	Dc.l	TEXTURE_Tree0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_Tree11
	Dc.l	FACE_Tree12,FACE_Tree10
	Dc.l	FACE_Tree9,FACE_Tree4
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Tree9,DOT_Tree4,DOT_Tree6
	Dc.l	EDGE_Tree18,EDGE_Tree9,EDGE_Tree20
	Dc.l	TEXTURE_Tree0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_Tree12
	Dc.l	FACE_Tree13,FACE_Tree11
	Dc.l	FACE_Tree10,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Tree6,DOT_Tree8,DOT_Tree9
	Dc.l	EDGE_Tree21,EDGE_Tree19,EDGE_Tree20
	Dc.l	TEXTURE_Tree0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_Tree13
	Dc.l	FACE_Tree14,FACE_Tree12
	Dc.l	FACE_Tree12,FACE_Tree14
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Tree6,DOT_Tree10,DOT_Tree8
	Dc.l	EDGE_Tree22,EDGE_Tree21,EDGE_Tree23
	Dc.l	TEXTURE_Tree0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_Tree14
	Dc.l	FACE_Tree15,FACE_Tree13
	Dc.l	FACE_Tree8,FACE_Tree15
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Tree3,DOT_Tree8,DOT_Tree10
	Dc.l	EDGE_Tree16,EDGE_Tree24,EDGE_Tree23
	Dc.l	TEXTURE_Tree0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_Tree15
	Dc.l	TreeShell_Tail,FACE_Tree14
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_Tree10,DOT_Tree6,DOT_Tree3
	Dc.l	EDGE_Tree22,EDGE_Tree12,EDGE_Tree24
	Dc.l	TEXTURE_Tree0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0

EDGE_Tree1
	Dc.l	EDGE_Tree2,TreeWire_Head
	Dc.l	DOT_Tree1,DOT_Tree2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree2
	Dc.l	EDGE_Tree3,EDGE_Tree1
	Dc.l	DOT_Tree2,DOT_Tree3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree3
	Dc.l	EDGE_Tree4,EDGE_Tree2
	Dc.l	DOT_Tree1,DOT_Tree3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree4
	Dc.l	EDGE_Tree5,EDGE_Tree3
	Dc.l	DOT_Tree3,DOT_Tree4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree5
	Dc.l	EDGE_Tree6,EDGE_Tree4
	Dc.l	DOT_Tree2,DOT_Tree4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree6
	Dc.l	EDGE_Tree7,EDGE_Tree5
	Dc.l	DOT_Tree4,DOT_Tree5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree7
	Dc.l	EDGE_Tree8,EDGE_Tree6
	Dc.l	DOT_Tree2,DOT_Tree5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree8
	Dc.l	EDGE_Tree9,EDGE_Tree7
	Dc.l	DOT_Tree5,DOT_Tree6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree9
	Dc.l	EDGE_Tree10,EDGE_Tree8
	Dc.l	DOT_Tree4,DOT_Tree6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree10
	Dc.l	EDGE_Tree11,EDGE_Tree9
	Dc.l	DOT_Tree6,DOT_Tree1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree11
	Dc.l	EDGE_Tree12,EDGE_Tree10
	Dc.l	DOT_Tree5,DOT_Tree1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree12
	Dc.l	EDGE_Tree13,EDGE_Tree11
	Dc.l	DOT_Tree6,DOT_Tree3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree13
	Dc.l	EDGE_Tree14,EDGE_Tree12
	Dc.l	DOT_Tree4,DOT_Tree7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree14
	Dc.l	EDGE_Tree15,EDGE_Tree13
	Dc.l	DOT_Tree7,DOT_Tree8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree15
	Dc.l	EDGE_Tree16,EDGE_Tree14
	Dc.l	DOT_Tree4,DOT_Tree8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree16
	Dc.l	EDGE_Tree17,EDGE_Tree15
	Dc.l	DOT_Tree8,DOT_Tree3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree17
	Dc.l	EDGE_Tree18,EDGE_Tree16
	Dc.l	DOT_Tree3,DOT_Tree7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree18
	Dc.l	EDGE_Tree19,EDGE_Tree17
	Dc.l	DOT_Tree4,DOT_Tree9
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree19
	Dc.l	EDGE_Tree20,EDGE_Tree18
	Dc.l	DOT_Tree8,DOT_Tree9
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree20
	Dc.l	EDGE_Tree21,EDGE_Tree19
	Dc.l	DOT_Tree9,DOT_Tree6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree21
	Dc.l	EDGE_Tree22,EDGE_Tree20
	Dc.l	DOT_Tree6,DOT_Tree8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree22
	Dc.l	EDGE_Tree23,EDGE_Tree21
	Dc.l	DOT_Tree10,DOT_Tree6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree23
	Dc.l	EDGE_Tree24,EDGE_Tree22
	Dc.l	DOT_Tree10,DOT_Tree8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_Tree24
	Dc.l	TreeWire_Tail,EDGE_Tree23
	Dc.l	DOT_Tree3,DOT_Tree10
	Dc.b	0,0,0,0
	Dc.l	0

DOT_Tree1
	Dc.l	DOT_Tree2,TreeNebula_Head
	Dc.l	-118,116,-193
	Dc.l	COLOR_Tree0
	Dc.b	0,0
	Dc.l	0
DOT_Tree2
	Dc.l	DOT_Tree3,DOT_Tree1
	Dc.l	102,109,39
	Dc.l	COLOR_Tree0
	Dc.b	0,0
	Dc.l	0
DOT_Tree3
	Dc.l	DOT_Tree4,DOT_Tree2
	Dc.l	53,50,-65
	Dc.l	COLOR_Tree0
	Dc.b	0,0
	Dc.l	0
DOT_Tree4
	Dc.l	DOT_Tree5,DOT_Tree3
	Dc.l	19,50,56
	Dc.l	COLOR_Tree0
	Dc.b	0,0
	Dc.l	0
DOT_Tree5
	Dc.l	DOT_Tree6,DOT_Tree4
	Dc.l	-86,109,74
	Dc.l	COLOR_Tree0
	Dc.b	0,0
	Dc.l	0
DOT_Tree6
	Dc.l	DOT_Tree7,DOT_Tree5
	Dc.l	-59,50,-37
	Dc.l	COLOR_Tree0
	Dc.b	0,0
	Dc.l	0
DOT_Tree7
	Dc.l	DOT_Tree8,DOT_Tree6
	Dc.l	262,-99,102
	Dc.l	COLOR_Tree0
	Dc.b	0,0
	Dc.l	0
DOT_Tree8
	Dc.l	DOT_Tree9,DOT_Tree7
	Dc.l	0,0,0
	Dc.l	COLOR_Tree0
	Dc.b	0,0
	Dc.l	0
DOT_Tree9
	Dc.l	DOT_Tree10,DOT_Tree8
	Dc.l	-223,-99,111
	Dc.l	COLOR_Tree0
	Dc.b	0,0
	Dc.l	0
DOT_Tree10
	Dc.l	TreeNebula_Tail,DOT_Tree9
	Dc.l	-109,-99,-178
	Dc.l	COLOR_Tree0
	Dc.b	0,0
	Dc.l	0
