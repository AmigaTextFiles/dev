	STRUCTURE	Screen_Store,0
		LONG	SS_View
		LONG	SS_ViewExtra
		LONG	SS_MonSpec
		LONG	SS_BitMap
		LONG	SS_Screen
		LONG	SS_RasInfo
		LONG	SS_ViewPort
		LONG	SS_ViewPortExtra
		LONG	SS_DimensionInfo
		LONG	SS_ColorMap
		LONG	SS_ColorTable
		LONG	SS_MaskPlane
		LONG	SS_Width
		LONG	SS_Height
		LONG	SS_Planes
		LONG	SS_RastPort
		LONG	SS_UserCopperList
	LABEL	Screen_Store_SIZEOF

	STRUCTURE	MaskPlane,0
		LONG	MP_PlaneSize
		LONG	MP_MaskPlane
		WORD	MP_Clip_X_Min
		WORD	MP_Clip_Y_Min
		WORD	MP_Clip_X_Max
		WORD	MP_Clip_Y_Max
		STRUCT	MP_PointBuffer,100
		STRUCT	MP_PointBuffer2,100
	LABEL	MaskPlane_SIZEOF

;	A Macro to show the supplied screen
	
SHOW	MACRO
	PUSHALL
	move.l	\1,a5
	move.l	SS_View(a5),a1
	CALLGRAF	LoadView
	PULLALL
	ENDM

;	Turn off sprite DMA

OFF_SPRITE	MACRO
	move.w	#%0000000000100000,$dff096
	ENDM

;	Turn on sprite DMA

ON_SPRITE	MACRO
	move.w	#%1000000000100000,$dff096
	ENDM

;	Copper Macros
;	Use these to construct the copper stream to be fed into
;	Add_Copper()

CMOVE	macro	register,value
	dc.w	\1,\2
	endm

CWAIT	macro	x,y             0<=x<=127, 0<=y<=255
	dc.b	\1,\2,$ff,$fe
	endm

CEND	macro
	dc.w	$ffff,$fffe
	endm

;palette control registers

COLOR00	EQU	$180
COLOR01	EQU	$182
COLOR02	EQU	$184
COLOR03	EQU	$186
COLOR04	EQU	$188
COLOR05	EQU	$18A
COLOR06	EQU	$18C
COLOR07	EQU	$18E
COLOR08	EQU	$190
COLOR09	EQU	$192
COLOR10	EQU	$194
COLOR11	EQU	$196
COLOR12	EQU	$198
COLOR13	EQU	$19A
COLOR14	EQU	$19C
COLOR15	EQU	$19E
COLOR16	EQU	$1A0
COLOR17	EQU	$1A2
COLOR18	EQU	$1A4
COLOR19	EQU	$1A6
COLOR20	EQU	$1A8
COLOR21	EQU	$1AA
COLOR22	EQU	$1AC
COLOR23	EQU	$1AE
COLOR24	EQU	$1B0
COLOR25	EQU	$1B2
COLOR26	EQU	$1B4
COLOR27	EQU	$1B6
COLOR28	EQU	$1B8
COLOR29	EQU	$1BA
COLOR30	EQU	$1BC
COLOR31	EQU	$1BE

BPLCON3	EQU	$106

;	A collection Of macros which are useful or needed by the
;	Graphics_Base.i File

OPENLIB MACRO	address of name,version no,libbase
	movea.l	(4).w,a6
	lea	\1,a1
	moveq.l	#\2,d0
	jsr	_LVOOpenLibrary(a6)
	move.l	d0,\3
	ENDM

CLOSELIB MACRO	libbase
 	 movea.l	(4).w,a6	
	 movea.l	\1,a1
	 jsr	_LVOCloseLibrary(a6)
	 ENDM

; Push registers contents onto stack -- use for > 3 registers only

PUSH		macro
		movem.l		\1,-(sp)
		endm

PUSHALL		macro
		PUSH		d0-d7/a0-a6
		endm
		
; Retrieve registers contents from stack

PULL		macro
		movem.l		(sp)+,\1
		endm

PULLALL		macro
		PULL		d0-d7/a0-a6
		endm

; Inserts pause 

PAUSE		macro

		PUSHALL
		move.l		#\1,d0
_pause\@		subi.l		#1,d0
		bne.s		_pause\@
		PULLALL
		endm

CHECK_CLICK	macro
		btst.b		#6,$BFE001		LMB check
		endm

CHECK_SPACE	macro
		bsr	GetKey
		cmp.b	#$40,d0
		endm

;	include files needed for the iff routines

	include "iff.i"
	include "IFF_Lib.i"
