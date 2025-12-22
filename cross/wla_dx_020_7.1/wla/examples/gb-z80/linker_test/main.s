
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; a small example showing and testing the wla syntax
; this little program flashes the background colour
; you should see stripes of different colours
; written by ville helin <vhelin@cc.hut.fi> in 1998-2001
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.DEFINE Q 0
.REPT 2
.REPT 2
.PRINTT ".REPT level 2 - call "
.PRINTV DEC Q
.PRINTT "\n"
.REDEFINE Q Q+1
.ENDR
.ENDR

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; project includes
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.INCLUDE "gb_memory1.i"
.INCLUDE "defines1.i"
.INCLUDE "cgb_hardware.i"

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; test macros - don't do anything wise, are here just for testing
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.DEFINE FILE "makefile"
.PRINTT WLA_FILENAME
.PRINTT "\n"
.PRINTT "\"String definition\" works!\n"
.DEFINE X 10
.DEFINE A 1

.MACRO REPETOR
.REPT \1-Q
	NOP
.ENDR
.ENDM


.MACRO RECUR
	PRINT "*** Recursive macros ***\n"
	PRINT "*** Seem to work...  ***\n"
.ENDM


.MACRO PRINT
.PRINTT \1
.ENDM

	
.MACRO NUM
.PRINTT "\""
.PRINTV DEC A << \1 << \1
.PRINTT "\"\n"
.ENDM


.MACRO LUPIN

.IF NARGS == 1
.PRINTT "Ichi!\n"
.DW \1
.ELSE
.PRINTT "Ikura deshoo ka na? \\@\n"
.PRINTT "Boku no bangoo wa \"\@\" desu!\n"
.DW \@, \2
.DB "N \@ N"
.REPT 16
	NOP
.ENDR
.ENDIF

.PRINTT "X = X("
.PRINTV DEC X
.PRINTT ") + \@ = "
.REDEFINE X X + \@
.PRINTV DEC X
.PRINTT "\n"
.REDEFINE X X | (1 << \1)

.ENDM


.IFEXISTS FILE
.PRINTT "\""
.PRINTT FILE
.PRINTT "\" exists!\n"
.ELSE
.PRINTT "\""
.PRINTT FILE
.PRINTT "\" doesn't exist!\n"
.ENDIF

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; main
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.BANK 0 SLOT 0
.ORG $150

.SECTION "Beginning" FORCE

MAIN:	DI
	LD	SP, stack_ptr-1		;stack_ptr is defined in setup.s
	LD	A, 'C'-10
	SUB	A
	LD	($FF00+R_IE), A		;no interrupts at all.

	LD	A, 144
	LDH	(R_WY), A		;window y.

	LD	A, %10000001
	LDH	(R_LCDC), A		;lcd control.

	SUB	A

_LOOP:	LD	($FF00+R_BGP), A	;background palette.
	INC	A

	JP	_LOOP

.REPT 8
.DB	(_LOOP - _LOOP) + 1
.ENDR

.ENDS

.SECTION "Gusto_Victor_128"
	NOP
.ENDS

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; this just tests the symbol identification routine
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.BANK 2 SLOT 1
.ORG $0

symbol_check_test:
.DB	"this is not a computation even though there are operators here, like - and *", 0
.DB	"neither is this, /* hello */ & 10", 0
.DB	"here we test the \"string parser\"." 0
.DB	'U', 'P', '!'

	LUPIN 6
	LUPIN 666 2

.PRINTT "Trying to trick .INCBIN...\n"
.PRINTT ".INCDIR \"other\"\n"

.INCDIR "other"
.INCBIN FILE

	NUM A
	NUM 2
	NUM 3
	NUM 4

	RECUR
	REPETOR 10
	OUTSIDE 11
.PRINTT WLA_FILENAME
.PRINTT "\n"
