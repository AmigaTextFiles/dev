; Wild Sector source made by META2Wild
; Made on 23:47:51 of 02-01-1978
; Sector name is SkruBase

SECTOR_SkruBase
	Dc.l	SkruBase_Succ,SkruBase_Pred
	QuickRefRel	0+SkruBase_PosX,0+SkruBase_PosY,0+SkruBase_PosZ
	Dc.l	SkruBase_Parent
	Dc.l	0
	Dc.b	0,0
	ListHeader	SkruBaseShell,FACE_SkruBase1,FACE_SkruBase22
	ListHeader	SkruBaseWire,EDGE_SkruBase1,EDGE_SkruBase31
	ListHeader	SkruBaseNebula,DOT_SkruBase1,DOT_SkruBase13
	Ds.b	Sphere_SIZE
	Dc.l	FACE_SkruBase13

COLOR_SkruBase0	EQU	$FFEEDD

FACE_SkruBase1
	Dc.l	FACE_SkruBase2,SkruBaseShell_Head
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase1,DOT_SkruBase2,DOT_SkruBase3
	Dc.l	EDGE_SkruBase1,EDGE_SkruBase2,EDGE_SkruBase3
	Dc.l	TEXTURE_SkruBase0
	Dc.b	-71,-68
	Dc.b	-39,-95
	Dc.b	-6,-68
FACE_SkruBase2
	Dc.l	FACE_SkruBase3,FACE_SkruBase1
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase3,DOT_SkruBase1,DOT_SkruBase4
	Dc.l	EDGE_SkruBase3,EDGE_SkruBase4,EDGE_SkruBase5
	Dc.l	TEXTURE_SkruBase0
	Dc.b	-6,-68
	Dc.b	-71,-68
	Dc.b	-55,-80
FACE_SkruBase3
	Dc.l	FACE_SkruBase4,FACE_SkruBase2
	Dc.l	FACE_SkruBase15,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase4,DOT_SkruBase3,DOT_SkruBase2
	Dc.l	EDGE_SkruBase5,EDGE_SkruBase2,EDGE_SkruBase6
	Dc.l	TEXTURE_SkruBase0
	Dc.b	-55,-80
	Dc.b	-6,-68
	Dc.b	-39,-95
FACE_SkruBase4
	Dc.l	FACE_SkruBase5,FACE_SkruBase3
	Dc.l	0,FACE_SkruBase12
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase2,DOT_SkruBase5,DOT_SkruBase1
	Dc.l	EDGE_SkruBase7,EDGE_SkruBase8,EDGE_SkruBase1
	Dc.l	TEXTURE_SkruBase0
	Dc.b	-39,-95
	Dc.b	-104,-95
	Dc.b	-71,-68
FACE_SkruBase5
	Dc.l	FACE_SkruBase6,FACE_SkruBase4
	Dc.l	FACE_SkruBase10,FACE_SkruBase4
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase6,DOT_SkruBase7,DOT_SkruBase8
	Dc.l	EDGE_SkruBase9,EDGE_SkruBase10,EDGE_SkruBase11
	Dc.l	TEXTURE_SkruBase0
	Dc.b	5,-123
	Dc.b	38,-95
	Dc.b	70,-123
FACE_SkruBase6
	Dc.l	FACE_SkruBase7,FACE_SkruBase5
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase8,DOT_SkruBase6,DOT_SkruBase9
	Dc.l	EDGE_SkruBase11,EDGE_SkruBase12,EDGE_SkruBase13
	Dc.l	TEXTURE_SkruBase0
	Dc.b	70,-123
	Dc.b	5,-123
	Dc.b	54,-111
FACE_SkruBase7
	Dc.l	FACE_SkruBase8,FACE_SkruBase6
	Dc.l	0,FACE_SkruBase16
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase9,DOT_SkruBase7,DOT_SkruBase6
	Dc.l	EDGE_SkruBase14,EDGE_SkruBase9,EDGE_SkruBase12
	Dc.l	TEXTURE_SkruBase0
	Dc.b	54,-111
	Dc.b	38,-95
	Dc.b	5,-123
FACE_SkruBase8
	Dc.l	FACE_SkruBase9,FACE_SkruBase7
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase10,DOT_SkruBase11,DOT_SkruBase12
	Dc.l	EDGE_SkruBase15,EDGE_SkruBase16,EDGE_SkruBase17
	Dc.l	TEXTURE_SkruBase0
	Dc.b	103,-95
	Dc.b	-128,-95
	Dc.b	-128,-107
FACE_SkruBase9
	Dc.l	FACE_SkruBase10,FACE_SkruBase8
	Dc.l	FACE_SkruBase11,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase11,DOT_SkruBase12,DOT_SkruBase5
	Dc.l	EDGE_SkruBase16,EDGE_SkruBase18,EDGE_SkruBase19
	Dc.l	TEXTURE_SkruBase0
	Dc.b	-128,-95
	Dc.b	-128,-107
	Dc.b	-104,-95
FACE_SkruBase10
	Dc.l	FACE_SkruBase11,FACE_SkruBase9
	Dc.l	FACE_SkruBase9,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase5,DOT_SkruBase13,DOT_SkruBase11
	Dc.l	EDGE_SkruBase20,EDGE_SkruBase21,EDGE_SkruBase19
	Dc.l	TEXTURE_SkruBase0
	Dc.b	-104,-95
	Dc.b	-128,-84
	Dc.b	-128,-95
FACE_SkruBase11
	Dc.l	FACE_SkruBase12,FACE_SkruBase10
	Dc.l	0,FACE_SkruBase8
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase13,DOT_SkruBase11,DOT_SkruBase10
	Dc.l	EDGE_SkruBase21,EDGE_SkruBase15,EDGE_SkruBase22
	Dc.l	TEXTURE_SkruBase0
	Dc.b	-128,-84
	Dc.b	-128,-95
	Dc.b	103,-95
FACE_SkruBase12
	Dc.l	FACE_SkruBase13,FACE_SkruBase11
	Dc.l	0,FACE_SkruBase14
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase10,DOT_SkruBase8,DOT_SkruBase7
	Dc.l	EDGE_SkruBase23,EDGE_SkruBase10,EDGE_SkruBase24
	Dc.l	TEXTURE_SkruBase0
	Dc.b	103,-95
	Dc.b	70,-123
	Dc.b	38,-95
FACE_SkruBase13
	Dc.l	FACE_SkruBase14,FACE_SkruBase12
	Dc.l	FACE_SkruBase17,FACE_SkruBase5
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase5,DOT_SkruBase1,DOT_SkruBase13
	Dc.l	EDGE_SkruBase8,EDGE_SkruBase25,EDGE_SkruBase20
	Dc.l	TEXTURE_SkruBase0
	Dc.b	-104,-95
	Dc.b	-71,-68
	Dc.b	-128,-84
FACE_SkruBase14
	Dc.l	FACE_SkruBase15,FACE_SkruBase13
	Dc.l	0,FACE_SkruBase21
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase12,DOT_SkruBase8,DOT_SkruBase10
	Dc.l	EDGE_SkruBase26,EDGE_SkruBase23,EDGE_SkruBase17
	Dc.l	TEXTURE_SkruBase0
	Dc.b	-128,-107
	Dc.b	70,-123
	Dc.b	103,-95
FACE_SkruBase15
	Dc.l	FACE_SkruBase16,FACE_SkruBase14
	Dc.l	FACE_SkruBase19,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase1,DOT_SkruBase4,DOT_SkruBase13
	Dc.l	EDGE_SkruBase4,EDGE_SkruBase27,EDGE_SkruBase25
	Dc.l	TEXTURE_SkruBase0
	Dc.b	-71,-68
	Dc.b	-55,-80
	Dc.b	-128,-84
FACE_SkruBase16
	Dc.l	FACE_SkruBase17,FACE_SkruBase15
	Dc.l	0,FACE_SkruBase18
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase9,DOT_SkruBase8,DOT_SkruBase12
	Dc.l	EDGE_SkruBase13,EDGE_SkruBase26,EDGE_SkruBase28
	Dc.l	TEXTURE_SkruBase0
	Dc.b	54,-111
	Dc.b	70,-123
	Dc.b	-128,-107
FACE_SkruBase17
	Dc.l	FACE_SkruBase18,FACE_SkruBase16
	Dc.l	FACE_SkruBase7,FACE_SkruBase3
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase9,DOT_SkruBase7,DOT_SkruBase10
	Dc.l	EDGE_SkruBase14,EDGE_SkruBase24,EDGE_SkruBase29
	Dc.l	TEXTURE_SkruBase0
	Dc.b	54,-111
	Dc.b	38,-95
	Dc.b	103,-95
FACE_SkruBase18
	Dc.l	FACE_SkruBase19,FACE_SkruBase17
	Dc.l	0,FACE_SkruBase6
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase12,DOT_SkruBase10,DOT_SkruBase9
	Dc.l	EDGE_SkruBase17,EDGE_SkruBase29,EDGE_SkruBase28
	Dc.l	TEXTURE_SkruBase0
	Dc.b	-128,-107
	Dc.b	103,-95
	Dc.b	54,-111
FACE_SkruBase19
	Dc.l	FACE_SkruBase20,FACE_SkruBase18
	Dc.l	0,FACE_SkruBase20
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase2,DOT_SkruBase4,DOT_SkruBase5
	Dc.l	EDGE_SkruBase6,EDGE_SkruBase30,EDGE_SkruBase7
	Dc.l	TEXTURE_SkruBase0
	Dc.b	-39,-95
	Dc.b	-55,-80
	Dc.b	-104,-95
FACE_SkruBase20
	Dc.l	FACE_SkruBase21,FACE_SkruBase19
	Dc.l	FACE_SkruBase2,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase5,DOT_SkruBase13,DOT_SkruBase4
	Dc.l	EDGE_SkruBase20,EDGE_SkruBase27,EDGE_SkruBase30
	Dc.l	TEXTURE_SkruBase0
	Dc.b	-104,-95
	Dc.b	-128,-84
	Dc.b	-55,-80
FACE_SkruBase21
	Dc.l	FACE_SkruBase22,FACE_SkruBase20
	Dc.l	0,FACE_SkruBase22
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase13,DOT_SkruBase10,DOT_SkruBase5
	Dc.l	EDGE_SkruBase22,EDGE_SkruBase31,EDGE_SkruBase20
	Dc.l	TEXTURE_SkruBase0
	Dc.b	-128,-84
	Dc.b	103,-95
	Dc.b	-104,-95
FACE_SkruBase22
	Dc.l	SkruBaseShell_Tail,FACE_SkruBase21
	Dc.l	0,FACE_SkruBase1
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruBase5,DOT_SkruBase10,DOT_SkruBase12
	Dc.l	EDGE_SkruBase31,EDGE_SkruBase17,EDGE_SkruBase18
	Dc.l	TEXTURE_SkruBase0
	Dc.b	-104,-95
	Dc.b	103,-95
	Dc.b	-128,-107

EDGE_SkruBase1
	Dc.l	EDGE_SkruBase2,SkruBaseWire_Head
	Dc.l	DOT_SkruBase1,DOT_SkruBase2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase2
	Dc.l	EDGE_SkruBase3,EDGE_SkruBase1
	Dc.l	DOT_SkruBase2,DOT_SkruBase3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase3
	Dc.l	EDGE_SkruBase4,EDGE_SkruBase2
	Dc.l	DOT_SkruBase1,DOT_SkruBase3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase4
	Dc.l	EDGE_SkruBase5,EDGE_SkruBase3
	Dc.l	DOT_SkruBase1,DOT_SkruBase4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase5
	Dc.l	EDGE_SkruBase6,EDGE_SkruBase4
	Dc.l	DOT_SkruBase3,DOT_SkruBase4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase6
	Dc.l	EDGE_SkruBase7,EDGE_SkruBase5
	Dc.l	DOT_SkruBase4,DOT_SkruBase2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase7
	Dc.l	EDGE_SkruBase8,EDGE_SkruBase6
	Dc.l	DOT_SkruBase2,DOT_SkruBase5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase8
	Dc.l	EDGE_SkruBase9,EDGE_SkruBase7
	Dc.l	DOT_SkruBase5,DOT_SkruBase1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase9
	Dc.l	EDGE_SkruBase10,EDGE_SkruBase8
	Dc.l	DOT_SkruBase6,DOT_SkruBase7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase10
	Dc.l	EDGE_SkruBase11,EDGE_SkruBase9
	Dc.l	DOT_SkruBase7,DOT_SkruBase8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase11
	Dc.l	EDGE_SkruBase12,EDGE_SkruBase10
	Dc.l	DOT_SkruBase6,DOT_SkruBase8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase12
	Dc.l	EDGE_SkruBase13,EDGE_SkruBase11
	Dc.l	DOT_SkruBase6,DOT_SkruBase9
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase13
	Dc.l	EDGE_SkruBase14,EDGE_SkruBase12
	Dc.l	DOT_SkruBase8,DOT_SkruBase9
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase14
	Dc.l	EDGE_SkruBase15,EDGE_SkruBase13
	Dc.l	DOT_SkruBase9,DOT_SkruBase7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase15
	Dc.l	EDGE_SkruBase16,EDGE_SkruBase14
	Dc.l	DOT_SkruBase10,DOT_SkruBase11
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase16
	Dc.l	EDGE_SkruBase17,EDGE_SkruBase15
	Dc.l	DOT_SkruBase11,DOT_SkruBase12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase17
	Dc.l	EDGE_SkruBase18,EDGE_SkruBase16
	Dc.l	DOT_SkruBase10,DOT_SkruBase12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase18
	Dc.l	EDGE_SkruBase19,EDGE_SkruBase17
	Dc.l	DOT_SkruBase12,DOT_SkruBase5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase19
	Dc.l	EDGE_SkruBase20,EDGE_SkruBase18
	Dc.l	DOT_SkruBase11,DOT_SkruBase5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase20
	Dc.l	EDGE_SkruBase21,EDGE_SkruBase19
	Dc.l	DOT_SkruBase5,DOT_SkruBase13
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase21
	Dc.l	EDGE_SkruBase22,EDGE_SkruBase20
	Dc.l	DOT_SkruBase13,DOT_SkruBase11
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase22
	Dc.l	EDGE_SkruBase23,EDGE_SkruBase21
	Dc.l	DOT_SkruBase13,DOT_SkruBase10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase23
	Dc.l	EDGE_SkruBase24,EDGE_SkruBase22
	Dc.l	DOT_SkruBase10,DOT_SkruBase8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase24
	Dc.l	EDGE_SkruBase25,EDGE_SkruBase23
	Dc.l	DOT_SkruBase10,DOT_SkruBase7
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase25
	Dc.l	EDGE_SkruBase26,EDGE_SkruBase24
	Dc.l	DOT_SkruBase1,DOT_SkruBase13
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase26
	Dc.l	EDGE_SkruBase27,EDGE_SkruBase25
	Dc.l	DOT_SkruBase12,DOT_SkruBase8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase27
	Dc.l	EDGE_SkruBase28,EDGE_SkruBase26
	Dc.l	DOT_SkruBase4,DOT_SkruBase13
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase28
	Dc.l	EDGE_SkruBase29,EDGE_SkruBase27
	Dc.l	DOT_SkruBase9,DOT_SkruBase12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase29
	Dc.l	EDGE_SkruBase30,EDGE_SkruBase28
	Dc.l	DOT_SkruBase9,DOT_SkruBase10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase30
	Dc.l	EDGE_SkruBase31,EDGE_SkruBase29
	Dc.l	DOT_SkruBase4,DOT_SkruBase5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruBase31
	Dc.l	SkruBaseWire_Tail,EDGE_SkruBase30
	Dc.l	DOT_SkruBase10,DOT_SkruBase5
	Dc.b	0,0,0,0
	Dc.l	0

DOT_SkruBase1
	Dc.l	DOT_SkruBase2,SkruBaseNebula_Head
	Dc.l	140,-1,140
	Dc.l	COLOR_SkruBase0
	Dc.b	0,0
	Dc.l	0
DOT_SkruBase2
	Dc.l	DOT_SkruBase3,DOT_SkruBase1
	Dc.l	220,-1,0
	Dc.l	COLOR_SkruBase0
	Dc.b	0,0
	Dc.l	0
DOT_SkruBase3
	Dc.l	DOT_SkruBase4,DOT_SkruBase2
	Dc.l	300,-1,140
	Dc.l	COLOR_SkruBase0
	Dc.b	0,0
	Dc.l	0
DOT_SkruBase4
	Dc.l	DOT_SkruBase5,DOT_SkruBase3
	Dc.l	180,79,80
	Dc.l	COLOR_SkruBase0
	Dc.b	0,0
	Dc.l	0
DOT_SkruBase5
	Dc.l	DOT_SkruBase6,DOT_SkruBase4
	Dc.l	60,-1,0
	Dc.l	COLOR_SkruBase0
	Dc.b	0,0
	Dc.l	0
DOT_SkruBase6
	Dc.l	DOT_SkruBase7,DOT_SkruBase5
	Dc.l	-300,-1,-140
	Dc.l	COLOR_SkruBase0
	Dc.b	0,0
	Dc.l	0
DOT_SkruBase7
	Dc.l	DOT_SkruBase8,DOT_SkruBase6
	Dc.l	-220,-1,0
	Dc.l	COLOR_SkruBase0
	Dc.b	0,0
	Dc.l	0
DOT_SkruBase8
	Dc.l	DOT_SkruBase9,DOT_SkruBase7
	Dc.l	-140,-1,-140
	Dc.l	COLOR_SkruBase0
	Dc.b	0,0
	Dc.l	0
DOT_SkruBase9
	Dc.l	DOT_SkruBase10,DOT_SkruBase8
	Dc.l	-180,79,-80
	Dc.l	COLOR_SkruBase0
	Dc.b	0,0
	Dc.l	0
DOT_SkruBase10
	Dc.l	DOT_SkruBase11,DOT_SkruBase9
	Dc.l	-60,-1,0
	Dc.l	COLOR_SkruBase0
	Dc.b	0,0
	Dc.l	0
DOT_SkruBase11
	Dc.l	DOT_SkruBase12,DOT_SkruBase10
	Dc.l	0,-50,0
	Dc.l	COLOR_SkruBase0
	Dc.b	0,0
	Dc.l	0
DOT_SkruBase12
	Dc.l	DOT_SkruBase13,DOT_SkruBase11
	Dc.l	0,-1,-60
	Dc.l	COLOR_SkruBase0
	Dc.b	0,0
	Dc.l	0
DOT_SkruBase13
	Dc.l	SkruBaseNebula_Tail,DOT_SkruBase12
	Dc.l	0,-1,60
	Dc.l	COLOR_SkruBase0
	Dc.b	0,0
	Dc.l	0
