*****************************************************************
*                                                               *
*       MaxonAsm.i                                              *
*                                                               *
*       PhxAss macro extension for MaxonAsm compatibility       *
*                                                               *
*****************************************************************
*
*       $VER: MaxonAsm.i 1.0 (12.02.97)
*       (C) 1997 Frank Wille -- All rights reserved
*
*****************************************************************

		IFND	_MAXONASM_I
_MAXONASM_I	set	-1


align		MACRO			; align.<w/l> -> cnop 0,<2/4>
		IFC     "\0","L"
		cnop	0,4
		ELSE
		IFC    "\0","W"
		even
		ENDC
		ENDC
		ENDM

basereg		MACRO			; base relative addressing
		IFC	"\1","OFF"
		far
		ELSE
		IFC	"\1","off"
		far
		ELSE
		echo	"BASEREG An,<base> is not supported. Please use NEAR directive instead."
		fail
		ENDC
		ENDC
		ENDM

cstr		MACRO			; define 0-terminated strings
		rept	NARG
		dc.b	\+,0
		endr
		ENDM

cstring		MACRO
		rept	NARG
		dc.b	\+,0
		endr
		ENDM

date		MACRO
		dc.b	"XX.XX.XX"
		echo	"DATE is currently not supported."
		ENDM

db		MACRO
		rept	NARG
		dc.b	\+
		endr
		ENDM

dw		MACRO
		rept	NARG
		dc.w	\+
		endr
		ENDM

dl		MACRO
		rept	NARG
		dc.l	\+
		endr
		ENDM

entry		MACRO
		rept	NARG
		xdef	\+
		endr
		ENDM

extern		MACRO
		rept	NARG
		xref	\+
		endr
		ENDM

equate		MACRO
		echo	"EQUATE no supported! Please use EQU."
		fail
		ENDM

ibytes		MACRO
		incbin	\1
		IFGE	NARG-2
		echo	"Size parameter in IBYTES <file>,<size> ignored!"
		ENDC
		ENDM

identify	MACRO
		idnt	\1
		ENDM

program		MACRO
		idnt	\1
		ENDM

mexp		MACRO
		;
		ENDM

nomexp		MACRO
		;
		ENDM

nocommarkers	MACRO
		;
		ENDM

odderr		MACRO
		;
		ENDM

oddok		MACRO
		;
		ENDM

text		MACRO
		section	text,code
		ENDM

___pstr		MACRO
		dc.b	2\@$-1\@$
1\@$:
		dc.b	\1
2\@$:
		ENDM

pstr		MACRO
		rept	NARG
		___pstr	\+
		endr
		ENDM

pstring		MACRO
		rept	NARG
		___pstr	\+
		endr
		ENDM

cend		MACRO
		dc.w	$ffff,$fffe
		ENDM

cmove		MACRO
		dc.w	\2,\1
		ENDM

clmove		MACRO
		dc.w	\2,\1>>16,\2+2,\1&$ffff
		ENDM

cwait		MACRO
		dc.w	(\1<<8)|((\2&$1fc)>>1)|1
		IFEQ	NARG-2
		dc.w	$fffe
		ELSE
		IFEQ	NARG-3
		IFC	"\3","BFD"
		dc.w	$fffe
		ELSE
		IFC	"\3","bfd"
		dc.w	$fffe
		ELSE
		dc.w	$7ffe
		ENDC
		ENDC
		ELSE
		IFEQ	NARG-5
		IFC	"\5","BFD"
		dc.w	$8000|((\3&$7f)<<8)|((\4&$1fc)>>1)
		ELSE
		IFC	"\5","bfd"
		dc.w	$8000|((\3&$7f)<<8)|((\4&$1fc)>>1)
		ELSE
		dc.w	((\3&$7f)<<8)|((\4&$1fc)>>1)
		ENDC
		ENDC
		ELSE
		echo	"cwait: illegal number of parameters."
		ENDC
		ENDC
		ENDC
		ENDC
		ENDM

cskip		MACRO
		dc.w	(\1<<8)|((\2&$1fc)>>1)|1
		IFEQ	NARG-2
		dc.w	$fffe
		ELSE
		IFEQ	NARG-3
		IFC	"\3","BFD"
		dc.w	$fffe
		ELSE
		IFC	"\3","bfd"
		dc.w	$fffe
		ELSE
		dc.w	$7ffe
		ENDC
		ENDC
		ELSE
		IFEQ	NARG-5
		IFC	"\5","BFD"
		dc.w	$8000|((\3&$7f)<<8)|((\4&$1fc)>>1)|1
		ELSE
		IFC	"\5","bfd"
		dc.w	$8000|((\3&$7f)<<8)|((\4&$1fc)>>1)|1
		ELSE
		dc.w	((\3&$7f)<<8)|((\4&$1fc)>>1)|1
		ENDC
		ENDC
		ELSE
		echo	"cskip: illegal number of parameters."
		ENDC
		ENDC
		ENDC
		ENDC
		ENDM

		ENDC
