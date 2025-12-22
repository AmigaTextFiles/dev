
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; a small example showing the wla syntax
; this little program flashes the background colour
; written by ville helin <vhelin@cc.hut.fi> in 1998-2000
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.NAME = "WLA TEST ROM"
.ROMSIZE 0
.RAMSIZE 0
.EMPTYFILL $C9				;ret.
.CARTRIDGETYPE 1
.LICENSEECODEOLD $1A
.COMPUTECHECKSUM
.COMPUTECOMPLEMENTCHECK

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; includes
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.INCDIR  "../include/"
.INCLUDE "nintendo_logo.i"
.INCLUDE "cgb_hardware.i"

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; macros
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.MACRO STANDARD_BEGINNING

	NOP
	JP	MAIN

.ENDM

.MACRO TEST_LOOP

TST_LOOP@@@:

	DEC	A
	JR	NZ, TST_LOOP@@@

.ENDM

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; standard stuff?
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.BANK 0
.ORG $100

	STANDARD_BEGINNING

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; main
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.IFDEF SAVE_SPACE
.ORG $150
.ELSE
.ORG $200
.ENDIF

MAIN:	DI
	LD	SP, $FFFE
	SUB	A
	LDH	(R_IE), A		;no interrupts at all.

.IFNDEF SAVE_SPACE
	LD	A, 144
	LD	($FF00+R_WY), A		;window y.
.ENDIF

	LD	A, %10000001
	LD	($FF00+R_LCDC), A	;lcd control.

	SUB	A

	TEST_LOOP
	TEST_LOOP
	TEST_LOOP
	TEST_LOOP
	TEST_LOOP
	TEST_LOOP

	SWAP	A
        SWAP    A
        SWAP    A
        SWAP    A
        SWAP    A
        SWAP    A
        SWAP    A
        SWAP    A
        SWAP    A
        SWAP    A
        SWAP    A
        SWAP    A
        SWAP    A
        SWAP    A
        SWAP    A
        SWAP    A
        SWAP    A


.REPT 1000
	NOP
.ENDR

	TEST_LOOP
	TEST_LOOP
	TEST_LOOP
	TEST_LOOP
	TEST_LOOP

LOOP:	LD	($FF00+R_BGP), A	;background palette.
	INC	A

	JP	LOOP

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.SECTION "Data" FREE

.DSW	100 'A'
.DSB    64  $69
.INCDIR ""
.INCBIN	"sorority.bin"
.DB	"HELLO WORLD!"

.ENDS
