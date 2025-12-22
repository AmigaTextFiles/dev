; Wild Sector source made by META2Wild
; Made on 02:28:48 of 01-21-1978
; Sector name is SkruTre

SECTOR_SkruTre
	Dc.l	SkruTre_Succ,SkruTre_Pred
	QuickRefRel	0,0,0
	Dc.l	SkruTre_Parent
	Dc.l	0
	Dc.b	0,0
	ListHeader	SkruTreShell,FACE_SkruTre1,FACE_SkruTre31
	ListHeader	SkruTreWire,EDGE_SkruTre1,EDGE_SkruTre45
	ListHeader	SkruTreNebula,DOT_SkruTre1,DOT_SkruTre16
	Ds.b	Sphere_SIZE
	Dc.l	FACE_SkruTre4

COLOR_SkruTre0	EQU	$FFEEDD

FACE_SkruTre1
	Dc.l	FACE_SkruTre2,SkruTreShell_Head
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre1,DOT_SkruTre2,DOT_SkruTre3
	Dc.l	EDGE_SkruTre1,EDGE_SkruTre2,EDGE_SkruTre3
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre2
	Dc.l	FACE_SkruTre3,FACE_SkruTre1
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre4,DOT_SkruTre5,DOT_SkruTre6
	Dc.l	EDGE_SkruTre4,EDGE_SkruTre5,EDGE_SkruTre6
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre3
	Dc.l	FACE_SkruTre4,FACE_SkruTre2
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre7,DOT_SkruTre8,DOT_SkruTre9
	Dc.l	EDGE_SkruTre7,EDGE_SkruTre8,EDGE_SkruTre9
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre4
	Dc.l	FACE_SkruTre5,FACE_SkruTre3
	Dc.l	FACE_SkruTre8,FACE_SkruTre11
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre7,DOT_SkruTre8,DOT_SkruTre10
	Dc.l	EDGE_SkruTre7,EDGE_SkruTre10,EDGE_SkruTre11
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre5
	Dc.l	FACE_SkruTre6,FACE_SkruTre4
	Dc.l	FACE_SkruTre9,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre10,DOT_SkruTre5,DOT_SkruTre4
	Dc.l	EDGE_SkruTre12,EDGE_SkruTre4,EDGE_SkruTre13
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre6
	Dc.l	FACE_SkruTre7,FACE_SkruTre5
	Dc.l	FACE_SkruTre7,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre3,DOT_SkruTre1,DOT_SkruTre10
	Dc.l	EDGE_SkruTre3,EDGE_SkruTre14,EDGE_SkruTre15
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre7
	Dc.l	FACE_SkruTre8,FACE_SkruTre6
	Dc.l	0,FACE_SkruTre12
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre10,DOT_SkruTre3,DOT_SkruTre11
	Dc.l	EDGE_SkruTre15,EDGE_SkruTre16,EDGE_SkruTre17
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre8
	Dc.l	FACE_SkruTre9,FACE_SkruTre7
	Dc.l	FACE_SkruTre13,FACE_SkruTre15
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre10,DOT_SkruTre11,DOT_SkruTre4
	Dc.l	EDGE_SkruTre17,EDGE_SkruTre18,EDGE_SkruTre13
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre9
	Dc.l	FACE_SkruTre10,FACE_SkruTre8
	Dc.l	0,FACE_SkruTre22
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre5,DOT_SkruTre12,DOT_SkruTre10
	Dc.l	EDGE_SkruTre19,EDGE_SkruTre20,EDGE_SkruTre12
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre10
	Dc.l	FACE_SkruTre11,FACE_SkruTre9
	Dc.l	FACE_SkruTre18,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre7,DOT_SkruTre12,DOT_SkruTre10
	Dc.l	EDGE_SkruTre21,EDGE_SkruTre20,EDGE_SkruTre11
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre11
	Dc.l	FACE_SkruTre12,FACE_SkruTre10
	Dc.l	FACE_SkruTre26,FACE_SkruTre25
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre10,DOT_SkruTre8,DOT_SkruTre13
	Dc.l	EDGE_SkruTre10,EDGE_SkruTre22,EDGE_SkruTre23
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre12
	Dc.l	FACE_SkruTre13,FACE_SkruTre11
	Dc.l	0,FACE_SkruTre21
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre13,DOT_SkruTre1,DOT_SkruTre10
	Dc.l	EDGE_SkruTre24,EDGE_SkruTre14,EDGE_SkruTre23
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre13
	Dc.l	FACE_SkruTre14,FACE_SkruTre12
	Dc.l	FACE_SkruTre14,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre14,DOT_SkruTre2,DOT_SkruTre3
	Dc.l	EDGE_SkruTre25,EDGE_SkruTre2,EDGE_SkruTre26
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre14
	Dc.l	FACE_SkruTre15,FACE_SkruTre13
	Dc.l	0,FACE_SkruTre6
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre14,DOT_SkruTre2,DOT_SkruTre1
	Dc.l	EDGE_SkruTre25,EDGE_SkruTre1,EDGE_SkruTre27
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre15
	Dc.l	FACE_SkruTre16,FACE_SkruTre14
	Dc.l	FACE_SkruTre16,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre15,DOT_SkruTre4,DOT_SkruTre6
	Dc.l	EDGE_SkruTre28,EDGE_SkruTre6,EDGE_SkruTre29
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre16
	Dc.l	FACE_SkruTre17,FACE_SkruTre15
	Dc.l	0,FACE_SkruTre5
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre5,DOT_SkruTre6,DOT_SkruTre15
	Dc.l	EDGE_SkruTre5,EDGE_SkruTre29,EDGE_SkruTre30
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre17
	Dc.l	FACE_SkruTre18,FACE_SkruTre16
	Dc.l	0,FACE_SkruTre10
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre9,DOT_SkruTre7,DOT_SkruTre16
	Dc.l	EDGE_SkruTre9,EDGE_SkruTre31,EDGE_SkruTre32
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre18
	Dc.l	FACE_SkruTre19,FACE_SkruTre17
	Dc.l	0,FACE_SkruTre19
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre16,DOT_SkruTre8,DOT_SkruTre9
	Dc.l	EDGE_SkruTre33,EDGE_SkruTre8,EDGE_SkruTre32
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre19
	Dc.l	FACE_SkruTre20,FACE_SkruTre18
	Dc.l	FACE_SkruTre24,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre16,DOT_SkruTre8,DOT_SkruTre13
	Dc.l	EDGE_SkruTre33,EDGE_SkruTre22,EDGE_SkruTre34
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre20
	Dc.l	FACE_SkruTre21,FACE_SkruTre19
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre13,DOT_SkruTre14,DOT_SkruTre1
	Dc.l	EDGE_SkruTre35,EDGE_SkruTre27,EDGE_SkruTre24
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre21
	Dc.l	FACE_SkruTre22,FACE_SkruTre20
	Dc.l	0,FACE_SkruTre1
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre14,DOT_SkruTre11,DOT_SkruTre3
	Dc.l	EDGE_SkruTre36,EDGE_SkruTre16,EDGE_SkruTre26
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre22
	Dc.l	FACE_SkruTre23,FACE_SkruTre21
	Dc.l	0,FACE_SkruTre2
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre4,DOT_SkruTre11,DOT_SkruTre15
	Dc.l	EDGE_SkruTre18,EDGE_SkruTre37,EDGE_SkruTre28
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre23
	Dc.l	FACE_SkruTre24,FACE_SkruTre22
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre5,DOT_SkruTre15,DOT_SkruTre12
	Dc.l	EDGE_SkruTre30,EDGE_SkruTre38,EDGE_SkruTre19
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre24
	Dc.l	FACE_SkruTre25,FACE_SkruTre23
	Dc.l	0,FACE_SkruTre3
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre12,DOT_SkruTre16,DOT_SkruTre7
	Dc.l	EDGE_SkruTre39,EDGE_SkruTre31,EDGE_SkruTre21
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre25
	Dc.l	FACE_SkruTre26,FACE_SkruTre24
	Dc.l	FACE_SkruTre17,FACE_SkruTre31
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre13,DOT_SkruTre12,DOT_SkruTre16
	Dc.l	EDGE_SkruTre40,EDGE_SkruTre39,EDGE_SkruTre34
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre26
	Dc.l	FACE_SkruTre27,FACE_SkruTre25
	Dc.l	FACE_SkruTre20,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre13,DOT_SkruTre14,DOT_SkruTre11
	Dc.l	EDGE_SkruTre35,EDGE_SkruTre36,EDGE_SkruTre41
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre27
	Dc.l	FACE_SkruTre28,FACE_SkruTre26
	Dc.l	0,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre15,DOT_SkruTre11,DOT_SkruTre12
	Dc.l	EDGE_SkruTre37,EDGE_SkruTre42,EDGE_SkruTre38
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre28
	Dc.l	FACE_SkruTre29,FACE_SkruTre27
	Dc.l	FACE_SkruTre30,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre14,DOT_SkruTre15,DOT_SkruTre16
	Dc.l	EDGE_SkruTre43,EDGE_SkruTre44,EDGE_SkruTre45
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre29
	Dc.l	FACE_SkruTre30,FACE_SkruTre28
	Dc.l	0,FACE_SkruTre28
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre15,DOT_SkruTre11,DOT_SkruTre14
	Dc.l	EDGE_SkruTre37,EDGE_SkruTre36,EDGE_SkruTre43
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre30
	Dc.l	FACE_SkruTre31,FACE_SkruTre29
	Dc.l	FACE_SkruTre27,0
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre13,DOT_SkruTre14,DOT_SkruTre16
	Dc.l	EDGE_SkruTre35,EDGE_SkruTre45,EDGE_SkruTre34
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0
FACE_SkruTre31
	Dc.l	SkruTreShell_Tail,FACE_SkruTre30
	Dc.l	FACE_SkruTre29,FACE_SkruTre23
	Dc.b	0,0,BSPTY_FACE,0
	Dc.l	0
	Dc.l	DOT_SkruTre12,DOT_SkruTre16,DOT_SkruTre15
	Dc.l	EDGE_SkruTre39,EDGE_SkruTre44,EDGE_SkruTre38
	Dc.l	TEXTURE_SkruTre0
	Dc.b	0,0
	Dc.b	0,0
	Dc.b	0,0

EDGE_SkruTre1
	Dc.l	EDGE_SkruTre2,SkruTreWire_Head
	Dc.l	DOT_SkruTre1,DOT_SkruTre2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre2
	Dc.l	EDGE_SkruTre3,EDGE_SkruTre1
	Dc.l	DOT_SkruTre2,DOT_SkruTre3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre3
	Dc.l	EDGE_SkruTre4,EDGE_SkruTre2
	Dc.l	DOT_SkruTre1,DOT_SkruTre3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre4
	Dc.l	EDGE_SkruTre5,EDGE_SkruTre3
	Dc.l	DOT_SkruTre4,DOT_SkruTre5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre5
	Dc.l	EDGE_SkruTre6,EDGE_SkruTre4
	Dc.l	DOT_SkruTre5,DOT_SkruTre6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre6
	Dc.l	EDGE_SkruTre7,EDGE_SkruTre5
	Dc.l	DOT_SkruTre4,DOT_SkruTre6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre7
	Dc.l	EDGE_SkruTre8,EDGE_SkruTre6
	Dc.l	DOT_SkruTre7,DOT_SkruTre8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre8
	Dc.l	EDGE_SkruTre9,EDGE_SkruTre7
	Dc.l	DOT_SkruTre8,DOT_SkruTre9
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre9
	Dc.l	EDGE_SkruTre10,EDGE_SkruTre8
	Dc.l	DOT_SkruTre7,DOT_SkruTre9
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre10
	Dc.l	EDGE_SkruTre11,EDGE_SkruTre9
	Dc.l	DOT_SkruTre8,DOT_SkruTre10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre11
	Dc.l	EDGE_SkruTre12,EDGE_SkruTre10
	Dc.l	DOT_SkruTre7,DOT_SkruTre10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre12
	Dc.l	EDGE_SkruTre13,EDGE_SkruTre11
	Dc.l	DOT_SkruTre10,DOT_SkruTre5
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre13
	Dc.l	EDGE_SkruTre14,EDGE_SkruTre12
	Dc.l	DOT_SkruTre10,DOT_SkruTre4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre14
	Dc.l	EDGE_SkruTre15,EDGE_SkruTre13
	Dc.l	DOT_SkruTre1,DOT_SkruTre10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre15
	Dc.l	EDGE_SkruTre16,EDGE_SkruTre14
	Dc.l	DOT_SkruTre3,DOT_SkruTre10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre16
	Dc.l	EDGE_SkruTre17,EDGE_SkruTre15
	Dc.l	DOT_SkruTre3,DOT_SkruTre11
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre17
	Dc.l	EDGE_SkruTre18,EDGE_SkruTre16
	Dc.l	DOT_SkruTre10,DOT_SkruTre11
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre18
	Dc.l	EDGE_SkruTre19,EDGE_SkruTre17
	Dc.l	DOT_SkruTre11,DOT_SkruTre4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre19
	Dc.l	EDGE_SkruTre20,EDGE_SkruTre18
	Dc.l	DOT_SkruTre5,DOT_SkruTre12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre20
	Dc.l	EDGE_SkruTre21,EDGE_SkruTre19
	Dc.l	DOT_SkruTre12,DOT_SkruTre10
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre21
	Dc.l	EDGE_SkruTre22,EDGE_SkruTre20
	Dc.l	DOT_SkruTre7,DOT_SkruTre12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre22
	Dc.l	EDGE_SkruTre23,EDGE_SkruTre21
	Dc.l	DOT_SkruTre8,DOT_SkruTre13
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre23
	Dc.l	EDGE_SkruTre24,EDGE_SkruTre22
	Dc.l	DOT_SkruTre10,DOT_SkruTre13
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre24
	Dc.l	EDGE_SkruTre25,EDGE_SkruTre23
	Dc.l	DOT_SkruTre13,DOT_SkruTre1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre25
	Dc.l	EDGE_SkruTre26,EDGE_SkruTre24
	Dc.l	DOT_SkruTre14,DOT_SkruTre2
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre26
	Dc.l	EDGE_SkruTre27,EDGE_SkruTre25
	Dc.l	DOT_SkruTre14,DOT_SkruTre3
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre27
	Dc.l	EDGE_SkruTre28,EDGE_SkruTre26
	Dc.l	DOT_SkruTre14,DOT_SkruTre1
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre28
	Dc.l	EDGE_SkruTre29,EDGE_SkruTre27
	Dc.l	DOT_SkruTre15,DOT_SkruTre4
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre29
	Dc.l	EDGE_SkruTre30,EDGE_SkruTre28
	Dc.l	DOT_SkruTre15,DOT_SkruTre6
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre30
	Dc.l	EDGE_SkruTre31,EDGE_SkruTre29
	Dc.l	DOT_SkruTre5,DOT_SkruTre15
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre31
	Dc.l	EDGE_SkruTre32,EDGE_SkruTre30
	Dc.l	DOT_SkruTre7,DOT_SkruTre16
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre32
	Dc.l	EDGE_SkruTre33,EDGE_SkruTre31
	Dc.l	DOT_SkruTre9,DOT_SkruTre16
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre33
	Dc.l	EDGE_SkruTre34,EDGE_SkruTre32
	Dc.l	DOT_SkruTre16,DOT_SkruTre8
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre34
	Dc.l	EDGE_SkruTre35,EDGE_SkruTre33
	Dc.l	DOT_SkruTre16,DOT_SkruTre13
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre35
	Dc.l	EDGE_SkruTre36,EDGE_SkruTre34
	Dc.l	DOT_SkruTre13,DOT_SkruTre14
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre36
	Dc.l	EDGE_SkruTre37,EDGE_SkruTre35
	Dc.l	DOT_SkruTre14,DOT_SkruTre11
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre37
	Dc.l	EDGE_SkruTre38,EDGE_SkruTre36
	Dc.l	DOT_SkruTre11,DOT_SkruTre15
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre38
	Dc.l	EDGE_SkruTre39,EDGE_SkruTre37
	Dc.l	DOT_SkruTre15,DOT_SkruTre12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre39
	Dc.l	EDGE_SkruTre40,EDGE_SkruTre38
	Dc.l	DOT_SkruTre12,DOT_SkruTre16
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre40
	Dc.l	EDGE_SkruTre41,EDGE_SkruTre39
	Dc.l	DOT_SkruTre13,DOT_SkruTre12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre41
	Dc.l	EDGE_SkruTre42,EDGE_SkruTre40
	Dc.l	DOT_SkruTre13,DOT_SkruTre11
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre42
	Dc.l	EDGE_SkruTre43,EDGE_SkruTre41
	Dc.l	DOT_SkruTre11,DOT_SkruTre12
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre43
	Dc.l	EDGE_SkruTre44,EDGE_SkruTre42
	Dc.l	DOT_SkruTre14,DOT_SkruTre15
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre44
	Dc.l	EDGE_SkruTre45,EDGE_SkruTre43
	Dc.l	DOT_SkruTre15,DOT_SkruTre16
	Dc.b	0,0,0,0
	Dc.l	0
EDGE_SkruTre45
	Dc.l	SkruTreWire_Tail,EDGE_SkruTre44
	Dc.l	DOT_SkruTre14,DOT_SkruTre16
	Dc.b	0,0,0,0
	Dc.l	0

DOT_SkruTre1
	Dc.l	DOT_SkruTre2,SkruTreNebula_Head
	Dc.l	-60,62,153
	Dc.l	COLOR_SkruTre0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTre2
	Dc.l	DOT_SkruTre3,DOT_SkruTre1
	Dc.l	0,62,253
	Dc.l	COLOR_SkruTre0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTre3
	Dc.l	DOT_SkruTre4,DOT_SkruTre2
	Dc.l	60,62,153
	Dc.l	COLOR_SkruTre0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTre4
	Dc.l	DOT_SkruTre5,DOT_SkruTre3
	Dc.l	140,62,-27
	Dc.l	COLOR_SkruTre0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTre5
	Dc.l	DOT_SkruTre6,DOT_SkruTre4
	Dc.l	80,62,-127
	Dc.l	COLOR_SkruTre0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTre6
	Dc.l	DOT_SkruTre7,DOT_SkruTre5
	Dc.l	200,62,-127
	Dc.l	COLOR_SkruTre0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTre7
	Dc.l	DOT_SkruTre8,DOT_SkruTre6
	Dc.l	-100,62,-127
	Dc.l	COLOR_SkruTre0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTre8
	Dc.l	DOT_SkruTre9,DOT_SkruTre7
	Dc.l	-160,62,-27
	Dc.l	COLOR_SkruTre0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTre9
	Dc.l	DOT_SkruTre10,DOT_SkruTre8
	Dc.l	-220,62,-127
	Dc.l	COLOR_SkruTre0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTre10
	Dc.l	DOT_SkruTre11,DOT_SkruTre9
	Dc.l	0,122,13
	Dc.l	COLOR_SkruTre0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTre11
	Dc.l	DOT_SkruTre12,DOT_SkruTre10
	Dc.l	60,142,33
	Dc.l	COLOR_SkruTre0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTre12
	Dc.l	DOT_SkruTre13,DOT_SkruTre11
	Dc.l	0,142,-67
	Dc.l	COLOR_SkruTre0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTre13
	Dc.l	DOT_SkruTre14,DOT_SkruTre12
	Dc.l	-60,142,33
	Dc.l	COLOR_SkruTre0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTre14
	Dc.l	DOT_SkruTre15,DOT_SkruTre13
	Dc.l	0,202,93
	Dc.l	COLOR_SkruTre0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTre15
	Dc.l	DOT_SkruTre16,DOT_SkruTre14
	Dc.l	80,202,-47
	Dc.l	COLOR_SkruTre0
	Dc.b	0,0
	Dc.l	0
DOT_SkruTre16
	Dc.l	SkruTreNebula_Tail,DOT_SkruTre15
	Dc.l	-80,202,-47
	Dc.l	COLOR_SkruTre0
	Dc.b	0,0
	Dc.l	0
