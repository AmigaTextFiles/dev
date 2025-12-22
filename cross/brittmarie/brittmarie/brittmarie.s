;APS00000000000000000000000000000000000000000000000000000000000000000000000000000000
	incdir	"include:"
	include "hardware/custom.i"
	include "hardware/dmabits.i"
	include "hardware/intbits.i"
	include "hardware/cia.i"

RELOCATE	equ 1
BOOTBLOCK	equ 1
CUSTOMBASE	equ $00dff000
VEC_PRIVILEGE_V	equ $20
SERDATRB_RBF	equ 14
;BAUD9600	equ 372
;BAUD38400	equ $005c
;BAUD230400	equ 14
BAUD		equ 14
CIAA		equ $00bfe001
CIAB		equ $00bfd000
SREC_BUFLEN	equ (1+255) ; (address + data + checksum)
RAM_END		equ $00200000
;RAM_END		equ $00100000
;RAM_END		equ $00080000

	IF BOOTBLOCK*RELOCATE
header:
	dc.b	"DOS",0
	dc.l	0
	dc.l	880

	; Turn off disk motor.
	move.b	#$f1, CIAB+$100
	ENDIF


; a6 - CUSTOMBASE
; a5 - srec_bytes
; d0, d1, a0, a1 - scratch registers.
init:
	lea	CUSTOMBASE, a6

	move.w	#INTF_INTEN, intena(a6)
	move.w	#DMAF_MASTER, dmacon(a6)
	move.w	#$00f0, color(a6)
	; Enter supervisor state
	lea	init_super(pc), a1
	; Assume VBR is 0.
	move.l	a1, VEC_PRIVILEGE_V

init_super:
	move.w	#$2000, sr

	jsr	uart_init

	IF RELOCATE
init_relocate
	lea.l	RELOCATE_START(pc), a0
	lea.l	RAM_END, a3
	lea.l	-(RELOCATE_END-RELOCATE_START)(a3), a1
	lea.l	(a1), a2

init_relocate_loop:
	move.w	(a0)+, (a1)+
	cmp.l	a1, a3
	bne.b	init_relocate_loop
	lea.l	-SREC_BUFLEN(a2), a5
	lea.l	(a5), a7
	jmp	(a2)

RELOCATE_START:

	ELSE

	lea	srec_bytes(pc), a5

	ENDIF

main_loop:
	bsr.w	srec_get

	tst.b	d1
	bne.b	main_loop
	move.b	d0, d7

	bsr.w	srec_checksum
	tst.b	d0
	bne.b	main_fail

	move.b	d7, d0
	bsr.b	srec_parse
	bra.b	main_loop

main_fail:
	move.w	#$0f00, color(a6)
	bra.b	main_fail


; in
;   - d0 srec type as hex digit
srec_parse:
	; Prepare exec functions with srec_bytes in a0.
	; Prepare address length in d1
	lea.l	(a5), a0

	moveq.l	#2, d1
	cmp.b	#'1', d0
	beq.b	srec_s123
	cmp.b	#'9', d0
	beq.b	srec_s789


	moveq.l	#3, d1
	cmp.b	#'2', d0
	beq.b	srec_s123
	cmp.b	#'8', d0
	beq.b	srec_s789


	moveq.l	#4, d1
	cmp.b	#'3', d0
	beq.b	srec_s123
	cmp.b	#'7', d0
	beq.b	srec_s789

;	cmp.b	#'0', d0
;	beq.b	srec_s0

srec_unimp:
	rts


;srec_s0:
;	; Do something interesting with the identifier here...
;	rts


; in
;   - d1 len in bytes
;   - a0 srec bytes
; out
;   - a0 a0 + len
;   - a1 dest ptr
srec_addr:
	moveq.l	#0, d0

srec_addr_loop:
	lsl.l	#8, d0
	move.b	(a0)+, d0
	subq.b	#1, d1
	bne.b	srec_addr_loop

	move.l	d0, a1
	
	rts


; S-RECORD type 1/2/3
; in
;   - d1 address length
;   - a0 srec_bytes
srec_s123:
	move.w	d2, -(a7)
	; Record length
	move.b	(a0)+, d2
	; Subtract 16/24/32 bit address bytes
	sub.b	d1, d2
	bsr.b	srec_addr
	; Subtract checksum byte
	subq.b	#1, d2

srec_s123_loop:
	move.b	(a0)+, (a1)+
	subq.b	#1, d2
	bne.b	srec_s123_loop
	move.w	(a7)+, d2
	rts


; S-RECORD type 1/2/3
; in
;   - d1 address length
;   - a0 srec_bytes
srec_s789:
	; Extract record length (addr+checksum)
	move.b	(a0)+, d0
	; Subtract checksum
	subq.b	#1, d0
	cmp.b	d0, d1
	bne.b	srec_s789_end
	; Extract 24-bit address
	bsr.b	srec_addr
srec_s789_wait:
	move.w	#$0fff, color(a6)
	; Delay boot if mouse button is pressed.
	btst.b	#CIAB_GAMEPORT0, CIAA+ciapra
	beq.b	srec_s789_wait

	move.w	#$0307, color(a6)
	lea.l	RAM_END, a7
	jmp	(a1)

srec_s789_end:
	rts

; Sample the next SREC
; in
;   - a5 Output buffer, 256 byte long
; out
;   - d0 Record type (hex digit)
srec_get:
	; Working registers
	; d4 - Local byte count
	; d3 - Return value
	; d2 - msn
	movem.l	d2/d3/d4, -(a7)
srec_get_restart:
	bsr.b	uart_get
	cmp.b	#'S', d0
	bne.b	srec_get_restart

	; Record type
	bsr.b	uart_get
	move.l	d0, d3
	bsr.b	nibble2int
	tst.l	d0
	bmi.b	srec_nothex

	clr.l	d4

srec_get_loop:
	;msn
	bsr.b	uart_get
	bsr.b	nibble2int
	move.l	d0, d2
	bmi.b	srec_nothex

	;lsn
	bsr.b	uart_get
	bsr.b	nibble2int
	tst.l	d0
	bmi.b	srec_nothex
	lsl.w	#4, d2
	or.l	d0, d2

	move.b	d2, (a5,d4.w)
	addq.b	#1, d4
	bne.b	srec_get_loop

srec_nothex:
	move.l	d3, d0
	movem.l	(a7)+, d2/d3/d4
	rts


; Verify S-RECORD checksum
; out
;   - d0[ 7.. 0] 0 iff checksum correct
srec_checksum:
	lea.l	(a5), a1
	move.b	(a1)+, d1
	move.b	d1, d0
	subq.b	#1, d1

srec_checksum_loop:
	add.b	(a1)+, d0
	subq.b	#1, d1
	bne.b	srec_checksum_loop

	not.b	d0
	sub.b	(a1), d0
	rts

	incdir	"brittmarie:"
	include	"uartmarie.s"
	include "nibblemarie.s"

	IF RELOCATE
RELOCATE_END:
	ELSE

srec_bytes:
	ds.b	SREC_BUFLEN
	ENDIF
