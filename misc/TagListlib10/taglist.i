 IFND TAGLIST_I
TAGLIST_I SET 1

;*--------------------------------------------------------------------------*
;                       taglist.i (Jul 17 1992)
;                     Copyright © 1992 Zeal Computer
;                             By Sam Hepworth
;                                Freeware
;
;                May be copied UNMODIFIED without royalties
;*--------------------------------------------------------------------------*




	;* TagMapItem
	;*
 STRUCTURE TagMapItem,0
	ULONG	tmi_ID
	WORD	tmi_Offset
	UBYTE	tmi_Miss
	UBYTE	tmi_Type
	LABEL	tmi_Bits
	ULONG	tmi_Default
	LABEL	tmi_SizeOf




	;* TagMapItem types
	;*
TMI_BYTE		EQU 0
TMI_WORD		EQU 4
TMI_LONG		EQU 8
TMI_INT			EQU 0
TMI_BOOL		EQU 12
TMI_bool		EQU 24
TMI_NODEFAULT	EQU 0
TMI_DEFAULT		EQU 36
TMI_default		EQU 60


	;* Tag command
	;*
TAG_INIT		EQU 1





	;* TagMap macro
	;*
TAGMAP MACRO ;ID,OFFSET,MISSBITS,BYTE|WORD|LONG,REAL|BOOL|bool,NODEFAULT|DEFAULT|default
	DC.L \1
	DC.W \2
	DC.B \3
	DC.B TMI_\4+TMI_\5+TMI_\6
	DC.L \7
	ENDM





 ENDC ;* TAGLIST_I *
