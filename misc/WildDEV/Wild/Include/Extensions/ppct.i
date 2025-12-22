
	include	exec/types.i

	STRUCTURE	ppctnode,0
		WORD	ppctn_splitatx
 		WORD	ppctn_splitaty
 		WORD	ppctn_splitatz
 		STRUCT	ppctn_childs,8*4
 		WORD	ppctn_numofcols
 		WORD	ppctn_colsarray
		LABEL	ppctn_SIZEOF
	
	STRUCTURE	ppctprek,0
		WORD	ppctp_x
		WORD	ppctp_y
		WORD	ppctp_z
		LABEL	ppctp_SIZEOF
	
	STRUCTURE	ppct,0
		APTR	ppct_pool
		APTR	ppct_root
		WORD	ppct_maxdepth
		WORD	ppct_maxpernode	
		APTR	ppct_truechunky
		APTR	ppct_prekchunky
		BYTE	ppct_flags
		BYTE	ppct_hole00
		LABEL	ppct_SIZEOF

	BITDEF	PPCT,RGBMode,0	

PPCTBASE		EQU	$8eeee000	
PPCT_ChunkyArray	EQU	PPCTBASE+0
PPCT_MaxTreeDepth	EQU	PPCTBASE+1
PPCT_MaxColorsPerNode	EQU	PPCTBASE+2
PPCT_ChunkyPixelsNum	EQU	PPCTBASE+3
PPCT_RGBMode		EQU	PPCTBASE+4

