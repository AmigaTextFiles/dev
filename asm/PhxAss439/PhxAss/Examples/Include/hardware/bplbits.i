	IFND	BPLBITS_I
BPLBITS_I	SET	1
**
** $VER: bplbits.i 1.0 (4.6.97)
**
** bits to use with bplcon0
**
** Written by Sunbeam/Shelter!
**

	IFND	EXEC_TYPES_I
	INCLUDE	"exec/types.i"
	ENDC	;EXEC_TYPES_I


	BITDEF	BPL,HIRES,15	;activate hi-res mode
	BITDEF	BPL,BPU2,14	;number of bpl's set in this 3
	BITDEF	BPL,BPU1,13	;bits
	BITDEF	BPL,BPU0,12
	BITDEF	BPL,HAM,11	;activate hold-and-modify mode
	BITDEF	BPL,DUAL,10	;activate dual-playfield mode
	BITDEF	BPL,COLOR,9	;video output color
	BITDEF	BPL,GAUD,8	;activate genlock audio
	BITDEF	BPL,UHRES,7	;ultra hires
	BITDEF	BPL,SHRES,6	;super hires
	BITDEF	BPL,BYPASS,5	;bypass color table
	BITDEF	BPL,BPU3,4
	BITDEF	BPL,LPEN,3	;activate lightpen input
	BITDEF	BPL,LACE,2	;interlace mode
	BITDEF	BPL,ERSY,1	;external resync
	BITDEF	BPL,ECSEN,0	;disables BRDRBLNK,BRDNTRAN,ZDCLKEN,BRDSPRT,EXTBLKEN


	ENDC	;BPLBITS_I