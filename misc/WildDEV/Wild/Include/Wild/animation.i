	IFND	WILD_ANIMATION_i
WILD_ANIMATION_I	SET	1

	include wild/tdcore.i
	include	wild/wild.i

	STRUCTURE WildAction,MLN_SIZE
		WORD	act_Sectors
		BYTE	act_Flags
 		BYTE	act_hole00
 		STRUCT	act_Moves,MLH_SIZE
 		STRUCT	act_StopCheck,MLH_SIZE
 		STRUCT	act_StopCall,MLH_SIZE
 		LABEL	act_SIZEOF

	STRUCTURE WildMove,MLN_SIZE
		BYTE	mov_Flags
 		BYTE	mov_RunTime
 		WORD	mov_UseCnt
 		WORD	mov_Sector
 		LONG	mov_Starter
 		LONG	mov_Duration
 		STRUCT	mov_StopCheck,MLH_SIZE
		APTR	mov_Commands
		LABEL	mov_SIZEOF

	STRUCTURE WildMoveCommand,0
 		BYTE	mcd_Command
 		BYTE	mcd_Target
 		LONG	mcd_Value
 		LABEL	mcd_SIZEOF

MOVECOMMAND_SET		EQU	1
MOVECOMMAND_ADD		EQU	2
MOVECOMMAND_END		EQU	0

TARGET_X		EQU	0
TARGET_Y		EQU	1
TARGET_Z		EQU	2
TARGET_R		EQU	3
TARGET_RX		EQU	4
TARGET_RY		EQU	5
TARGET_RZ		EQU	6

TARGETMASK_XYZR		EQU	7

TARGET_SECTORREF	EQU	1<<3	/* not supported now, maybe never. (requires differentials math, complex, slow, heavy to code.)*/
TARGET_PARENTREF	EQU	0	

TARGET_C		EQU	0<<4
TARGET_V		EQU	1<<4
TARGET_A		EQU	2<<4

TARGETMASK_CVA		EQU	3<<4

	STRUCTURE MovingVar,0
		LONG	mv_c
		LONG	mv_v
		LONG	mv_a
		LABEL	mv_SIZEOF

	STRUCTURE MovingRef,0
		STRUCT	mr_x,mv_SIZEOF
		STRUCT	mr_y,mv_SIZEOF
		STRUCT	mr_z,mv_SIZEOF
		STRUCT	mr_r,mv_SIZEOF		; until here, the cva vars
		STRUCT	mr_rv,Vek_SIZE		; the rotation axis (parent referred)
		STRUCT	mr_i,Vek_SIZE		; i,j,k of ref, to rotate...
		STRUCT  mr_j,Vek_SIZE	
		STRUCT	mr_k,Vek_SIZE
		LABEL	mr_SIZEOF

	STRUCTURE WildDoing,MLN_SIZE
		APTR	doi_Alien
		LONG	doi_Started
		APTR	doi_Action
		STRUCT	doi_Sectors,MLH_SIZE
		APTR	doi_LastMove
		LABEL	doi_SIZEOF
		
	STRUCTURE WildDoingSector,MLN_SIZE
		APTR	dse_Sector
		STRUCT	dse_LastMoveShot,mr_SIZEOF
		APTR	dse_LastInitMove
		LABEL	dse_SIZEOF

WILD_ANIMATIONBASE	EQU	WILD_OTHERSTD+300

WIDA_Alien	EQU	WILD_ANIMATIONBASE+1
WIDA_Action	EQU	WILD_ANIMATIONBASE+2
WIDA_Sectors	EQU	WILD_ANIMATIONBASE+3
WIDA_StartTime	EQU	WILD_ANIMATIONBASE+4

WIAN_Arenas	EQU	WILD_ANIMATIONBASE+20
WIAN_Time	EQU	WILD_ANIMATIONBASE+21

	ENDC