
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; a small example showing the wla syntax
; this little program flashes the background colour
; you should see stripes of different colours
; written by ville helin <vhelin@cc.hut.fi> in 1998-2000
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.INCLUDE "gb_memory1.i"
.INCLUDE "defines1.i"
.INCLUDE "cgb_hardware.i"

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; a test macro - doesn't do anything wise, is here just for testing
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.MACRO LUPIN

.IF NARGS == 1
.PRINTT "Ichi!\n"
.DB \1
.ELSE
.PRINTT "Ikura deshoo ka na?\n"
.DB \1
.DB \2
.ENDIF

.ENDM

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; main
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.BANK 0 SLOT 0
.ORG $150

.SECTION "Beginning" FORCE

MAIN:	DI
	LD	SP, stack_ptr-1		;stack_ptr is defined in setup.s
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
.ENDS

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; this just tests the symbol identification routine
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.BANK 2 SLOT 1
.ORG $0

symbol_check_test:
.DB	"this is not a computation even though there are operators here, like - and *" 0
.DB	"neither is this, /* hello */ & 10"

	LUPIN 1
	LUPIN 1 2
