	IFND	COPMACROS_I
COPMACROS_I	SET	1

; $VER: copmacros.i 3.5 (9.5.95)
; by Bruce M. Simpson

;---------------------------------------------------------------------------

bpl1pth	EQU   $0E0
bpl1ptl	EQU   $0E2
bpl2pth	EQU   $0E4
bpl2ptl	EQU   $0E6
bpl3pth	EQU   $0E8
bpl3ptl	EQU   $0EA
bpl4pth	EQU   $0EC
bpl4ptl	EQU   $0EE
bpl5pth	EQU   $0F0
bpl5ptl	EQU   $0F2
bpl6pth	EQU   $0F4
bpl6ptl	EQU   $0F6

	IFND	_PHXASS_
alignlong	MACRO
	CNOP	0,4
	ENDM
	ENDC

align64		MACRO
	CNOP	0,8
	ENDM

;---------------------------------------------------------------------------

;Copperlist Macros

;---------------------------------------------------------------------------

cmove	macro	value,register		; reverse order from how it occurs in RAM
	IFNE	NARG-2					; -makes it look like a real opcode ;)
	FAIL	!!!
	MEXIT
	ENDC
	dc.w	\2,\1
	endm

;---------------------------------------------------------------------------

;0<=x<=127, 0<=y<=255, 0<=ycmp<=255, 0<=xcmp<=63, bfd (if present)

cwait	macro	y,x,ycmp,xcmp,bfd
	IFEQ	NARG-5
	dc.w	(\1<<8)!(\2<<1)!1,(\3<<7)!(\4<<1)&($7FFE)
	MEXIT
	ENDC
	IFEQ	NARG-4
	dc.w	(\1<<8)!(\2<<1)!1,(1<<15)!(\3<<7)!(\4<<1)&($FFFE)
	MEXIT
	ENDC
	IFEQ	NARG-2
	dc.w	(\1<<8)!(\2<<1)!1,$FFFE
	MEXIT
	ENDC
	FAIL	'error in CWAIT macro call'
	ENDM


;0<=x<=127, 0<=y<=255, 0<=ycmp<=255, 0<=xcmp<=63, bfd (if present)

cskip	macro	y,x,ycmp,xcmp,bfd
	IFEQ	NARG-5
	dc.w	(\1<<8)!(\2<<1)!1,((\3<<7)!(\4<<1)!1)&($7FFF)
	MEXIT
	ENDC
	ENDC
	IFEQ	NARG-4
	dc.w	(\1<<8)!(\2<<1)!1,(1<<15)!(\3<<7)!(\4<<1)!1
	MEXIT
	ENDC
	IFEQ	NARG-2
	dc.w	(\1<<8)!(\2<<1)!1,$FFFF
	MEXIT
	FAIL	'error in CSKIP macro call'
	ENDM

;---------------------------------------------------------------------------

cend	macro
	dc.w	$FFFF,$FFFE
	endm

;---------------------------------------------------------------------------
; copper color register equates

color0	EQU	$180
color1	EQU	$182
color2	EQU	$184
color3	EQU	$186
color4	EQU	$188
color5	EQU	$18A
color6	EQU	$18C
color7	EQU	$18E
color8	EQU	$190
color9	EQU	$192
color10	EQU	$194
color11	EQU	$196
color12	EQU	$198
color13	EQU	$19A
color14	EQU	$19C
color15	EQU	$19E
color16	EQU	$1A0
color17	EQU	$1A2
color18	EQU	$1A4
color19	EQU	$1A6
color20	EQU	$1A8
color21	EQU	$1AA
color22	EQU	$1AC
color23	EQU	$1AE
color24	EQU	$1B0
color25	EQU	$1B2
color26	EQU	$1B4
color27	EQU	$1B6
color28	EQU	$1B8
color29	EQU	$1BA
color30	EQU	$1BC
color31	EQU	$1BE

;---------------------------------------------------------------------------

	ENDC	!MYMACROS_I
