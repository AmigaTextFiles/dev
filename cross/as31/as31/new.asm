; -----------------------------------------------------------------------
; -		debugger v2.0 theo de raadt 21/1/90			-
; NOTE: Hardware has to be specially built to handle this monitor.
; The CODE address space and the DATA address space have to be mapped
; on top of each other. ie. CHIP_READ* = 8031RD* AND 8031PSEN* and
; CHIP_WRITE* = 8031WR*.
; Within this (combined) address space, you can now use either MOVX
; or MOVC for the same effect.
; In this address space, I have placed the rom this debugger is in
; at 0x0000 and ram at 0x8000. (additional IO would go in between.)
; (actually, I used a battery backed up static ram at 0x000.)
; Some of the commands in the help are actually unimplimented. It
; suited my purposes. The 'g' command could be much improved, to have
; a seperate register set for the called routine.
; -----------------------------------------------------------------------

		.org	0
start:		nop			; for accidental overwrite if ram
					; at 0 -- bug in my decode logic?
		mov	P3, #0xff	; use alternate fns on P3
		ajmp	main

; -----------------------------------------------------------------------
; SERINIT() nothing hurt
serinit:	mov	TMOD, #0x20	; timer 1 mode 2
	;	mov	TH1, #230	; 1200 baud
		mov	TH1,#243	; 4800 baud
		mov	TCON, #0x40	; turn timer 1 on
		mov	SCON, #0x52	; serial mode 1 rx, fake tx done

		mov	A, PCON		; for 4800 baud
		setb	ACC.7
		mov	PCON, A
		ret

; -----------------------------------------------------------------------
; PUTC( A=char )
putc:		jnb	TI, putc	; wait for tx free
		clr	TI
		mov	SBUF, A		; send it
		ret

; -----------------------------------------------------------------------
; GETC() A=char
getc:		jnb	RI, getc
		clr	RI
		mov	A, SBUF
		ret

; -----------------------------------------------------------------------
; GETS( DPTR=start of string ) A not hurt, DPTR at start of string
gets:		push	ACC
		push	DPL
		push	DPH
		mov	A, R3
		push	ACC

		clr	A
		mov	R3, A
gets_nxt:	lcall	getc
		cjne	A, #8, gets_notbs
		ajmp	gets_bs
gets_notbs:	cjne	A, #'\r', gets_good
		clr	A
		movx	@DPTR, A

		pop	ACC
		mov	R3, A
		pop	DPH
		pop	DPL
		pop	ACC
		ret

gets_bs:	mov	A, R3		; backspaced too far
		jz	gets_nxt
		dec	A
		mov	R3, A

		mov	A, #8		; "\b \b"
		lcall	putc
		mov	A, #' '
		lcall	putc
		mov	A, #8
		lcall	putc

		setb	C		; this is "dec DPTR"
		mov	A, DPL
		subb	A, #0
		mov	DPL, A
		mov	A, DPH
		subb	A, #0
		mov	DPH, A
		ajmp	gets_nxt

gets_good:	movx	@DPTR, A
		lcall	putc
		inc	DPTR
		inc	R3
		ajmp	gets_nxt

; ----------------------------------------------------------------------
; HEXPARSE( DPTR=string ) A not hurt, DPTR advanced, R0/R1 [H/L] return
hexparse:	push	ACC

hp_char:	movx	A, @DPTR	; get char

		clr	C
		subb	A, #'a'
		jc	hp_notalpha	; < 'a' not hex alpha char
		subb	A, #5+1
		jnc	hp_notalpha	; > 'f' not hex aplha char
		movx	A, @DPTR
		clr	C
		subb	A, #'a'-10
		sjmp	hp_nybble

hp_notalpha:	movx	A, @DPTR
		clr	C
		subb	A, #'0'
		jc	hp_notdigit	; < '0' not hex digit
		subb	A, #9+1
		jnc	hp_notdigit	; > '9' not hex digit
		movx	A, @DPTR
		clr	C
		subb	A, #'0'

hp_nybble:	inc	DPTR

		anl	A, #0x0f
		push	ACC		;     R0       R1
		mov	A, R0		;  HHHH LLLL hhhh llll
		swap	A
		anl	A, #0xf0
		mov	R0, A
		mov	A, R1
		swap	A		; shift left by nybble
		anl	A, #0x0f
		orl	A, R0
		mov	R0, A
		mov	A, R1
		swap	A
		anl	A, #0xf0
		mov	R1, A
		pop	ACC
		orl	A, R1
		mov	R1, A		;  LLLL hhhh llll aaaa

	;	debugging
	;	push	ACC
	;	push	DPL
	;	push	DPH
	;	mov	DPH, R0
	;	mov	DPL, R1
	;	lcall	putword
	;	lcall	putnl
	;	pop	DPH
	;	pop	DPL
	;	pop	ACC

		sjmp	hp_char

hp_notdigit:	pop	ACC
		ret

; ----------------------------------------------------------------------
; EATSPACE( DPTR=string ) A not hurt, DPTR advanced
eatspace:	push	ACC
eatspace_loop:	movx	A, @DPTR
		cjne	A, #' ', eatspace_done
		inc	DPTR
		sjmp	eatspace_loop
eatspace_done:	pop	ACC
		ret

; -----------------------------------------------------------------------
; PUTS( DPTR=string ) A not hurt, DPTR at end of string
puts:		push	ACC
puts_ch:	movx	A, @DPTR	; get ch
		jz	puts_q		; null - finished str
		lcall	putc
		inc	DPTR
		sjmp	puts_ch		; go for next
puts_q:		pop	ACC
		ret

; -----------------------------------------------------------------------
; PUTNL() nothing hurt
putnl:		push	ACC
		mov	A, #0x0d
		lcall	putc
		mov	A, #0x0a
		lcall	putc
		pop	ACC
		ret

; -----------------------------------------------------------------------
; putword( DPTR=word) nothing hurt
putword:	push	ACC
		mov	A, DPH
		lcall	putbyte
		mov	A, DPL
		lcall	putbyte
		pop	ACC
		ret

; -----------------------------------------------------------------------
; putbyte( A=byte) nothing hurt
putbyte:	push	ACC
		push	ACC
		swap	A
		lcall	putnyb
		pop	ACC
		lcall	putnyb
		pop	ACC
		ret

; -----------------------------------------------------------------------
; putnyb( A=nybble ) A hurt
putnyb:		anl	A, #0x0f
		push	ACC
		clr	C
		subb	A, #10
		jc	pn_digit	; <= 9, then it's a digit
		add	A, #'a'		; alphabetic
		lcall	putc
		pop	ACC
		ret

pn_digit:	pop	ACC		; it's a digit
		add	A, #'0'
		lcall	putc
		ret

; -----------------------------------------------------------------------
main:		lcall	serinit
		mov	DPTR, #run_regs_psw	; initialize psw at least!
		clr	A
		movx	@DPTR, A
		mov	DPTR, #title_msg
		lcall	puts

next_line:	mov	A, #'>'		; prompt
		lcall	putc

		mov	DPTR, #linebuf	; get cmd
		lcall	gets
		lcall	putnl

next_cmd:	lcall	eatspace
		movx	A, @DPTR
		jz	next_line

		; --------------------------------------------------
		cjne	A, #'g', cmd_notgo	; g --> lcall addr..
		push	DPL
		push	DPH
		push	ACC
		push	PSW

		mov	DPTR, #go_return	; come back to here..
		push	DPL
		push	DPH

		mov	A, R1			; return on top of function
		push	ACC
		mov	A, R0
		push	ACC
		mov	DPTR, #run_regs
		movx	A, @DPTR		; DPH
		push	ACC
		inc	DPTR
		movx	A, @DPTR		; DPL
		push	ACC
		inc	DPTR
		movx	A, @DPTR		; PSW
		push	ACC
		inc	DPTR
		movx	A, @DPTR		; ACC
		pop	PSW
		pop	DPL
		pop	DPH
		ret				; enter it

go_return:	pop	PSW
		pop	ACC
		pop	DPH
		pop	DPL
		inc	DPTR
		sjmp	next_cmd

		; --------------------------------------------------
cmd_notgo:	cjne	A, #'R', cmd_notregs
		inc	DPTR
		push	DPH
		push	DPL
		mov	DPTR, #regs_msg		; "DPTR ACC PSW"
		lcall	puts
		mov	DPTR, #run_regs
		movx	A, @DPTR
		acall	putbyte			;  xx
		inc	DPTR
		movx	A, @DPTR
		acall	putbyte			;    xx
		mov	A, #' '
		acall	putc
		inc	DPTR
		movx	A, @DPTR
		acall	putbyte			;       xx
		inc	DPTR
		mov	A, #' '
		acall	putc
		acall	putc
		movx	A, @DPTR
		acall	putbyte			;           xx
		acall	putnl
		pop	DPL
		pop	DPH
		sjmp	next_cmd

		; --------------------------------------------------
cmd_notregs:	cjne	A, #':', cmd_notenter	; : --> eat bytes..
		inc	DPTR
		mov	A, R2
		push	ACC
		mov	A, R3
		push	ACC
		mov	A, R0
		mov	R2, A
		mov	A, R1
		mov	R3, A		; R2/R3 = mem ptr

enter_next:	lcall	eatspace
		movx	A, @DPTR
		jz	enter_done

		push	DPL
		clr	A
		mov	R0, A
		mov	R1, A
		lcall	hexparse
		pop	ACC
		cjne	A, DPL, enter_number
		sjmp	enter_next

enter_number:	push	DPL
		push	DPH
		mov	DPH, R2		; put low byte only
		mov	DPL, R3
		mov	A, R1
		movx	@DPTR, A
		inc	DPTR
		mov	R2, DPH
		mov	R3, DPL
		pop	DPH
		pop	DPL
		sjmp	enter_next

enter_done:	pop	ACC
		mov	R3, A
		pop	ACC
		mov	R2, A
		ajmp	next_cmd

		; --------------------------------------------------
cmd_notenter:	cjne	A, #'?', cmd_nothelp
		push	DPL
		push	DPH
		mov	DPTR, #help_msg
		lcall	puts
		pop	DPH
		pop	DPL
		inc	DPTR
		ajmp	next_cmd

		; --------------------------------------------------
cmd_nothelp:	cjne	A, #'l', cmd_notlist
		push	DPL
		push	DPH
		push	B
		clr	A
		mov	B, ACC
		mov	DPH, R0
		mov	DPL, R1
		lcall	putword		; addr: [16 bytes]
		mov	A, #':'
		lcall	putc
		mov	A, #' '
		lcall	putc
cl_nextbyte:	movx	A, @DPTR
		lcall	putbyte
		mov	A, #' '
		lcall	putc
		inc	DPTR
		inc	B
		mov	A, B
		cjne	A, #16, cl_nextbyte
		lcall	putnl
		mov	R0, DPH
		mov	R1, DPL
		pop	B
		pop	DPH
		pop	DPL
		inc	DPTR
		ajmp	next_cmd

		; --------------------------------------------------
cmd_notlist:	cjne	A, #'r', cmd_notread
		mov	A, R3		; counter
		push	ACC
		mov	A, R1		; base addr
		push	ACC

		inc	DPTR		; get arg
		lcall	eatspace
		push	DPL
		lcall	hexparse
		pop	ACC
		cjne	A, DPL, nl_loop
		mov	A, #1
		mov	R3, A
		sjmp	nl_start
nl_loop:	mov	A, R1
		mov	R3, A
		
nl_start:	pop	ACC
		mov	R1, A
		mov	A, R1		; put address
		lcall	putbyte
		mov	A, #':'
		lcall	putc

nl_nextloop:	mov	A, R3		; eat one loop
		jz	nl_endloop
		dec	A
		mov	R3, A

		mov	A, #' '
		lcall	putc
		mov	A, @R1		; put byte
		lcall	putbyte
		inc	R1		; inc address

		sjmp	nl_nextloop

nl_endloop:	lcall	putnl
		pop	ACC
		mov	R3, A
		ajmp	next_cmd

		; --------------------------------------------------
cmd_notread:	cjne	A, #'w', cmd_notwrite
		mov	A, R3
		push	ACC
		mov	A, R1
		mov	R3, A		; save addr
		inc	DPTR

nr_nextbyte:	lcall	eatspace
		movx	A, @DPTR
		jz	nr_earlyeol	; [addr] w [EOL]
		push	DPL
		lcall	hexparse	; [addr] w [NONHEX]
		pop	ACC
		cjne	A, DPL, nr_good
		sjmp	nr_earlyeol

nr_good:	mov	A, R3		; R1 = value, R3 = addr
		mov	R0, A
		mov	A, R1
		mov	@R0, A
		ajmp	nr_nextbyte

nr_earlyeol:	pop	ACC
		mov	R3, A
		ajmp	next_cmd

		; --------------------------------------------------
cmd_notwrite:	cjne	A, #';', cmd_notcomment
		ajmp	next_line

cmd_notcomment:	push	DPL
		clr	A
		mov	R0, A
		mov	R1, A
		lcall	hexparse		; probably addr, see if ptr
		pop	ACC			; moved, else error
		cjne	A, DPL, cmd_more
		sjmp	cmd_error

		; --------------------------------------------------
cmd_more:
	;	debugging
	;	push	DPL
	;	push	DPH
	;	mov	DPTR, #number_msg
	;	lcall	puts
	;	mov	DPH, R0
	;	mov	DPL, R1
	;	lcall	putword
	;	lcall	putnl
	;	pop	DPH
	;	pop	DPL
		ajmp	next_cmd

cmd_error:	mov	DPTR, #error_msg
		lcall	puts
		ajmp	next_line

; -----------------------------------------------------------------------
title_msg:	.byte	"\r\n8031 mon v3.0\r\n", 0
error_msg:	.byte	"syntax error\r\n", 0
regs_msg:	.byte	"DPTR ACC PSW\r\n", 0
help_msg:	.byte	"8031 mon v3.0\r\n"
		.byte	"[addr] : [bytes]\tstore bytes\t"
		.byte	"[addr] g\t\tcall address\r\n"
		.byte	"[addr] l\t\tlist memory\t"
		.byte	"[addr] r [count]\tlist onchip\r\n"
		.byte	"[addr] w [bytes]\tstore onchip\t"
		.byte	"; [comment]\t\tcomment\r\n"
		.byte	"[value] D\t\tstore in DPTR\t"
		.byte	"[value] A\t\tstore in ACC\r\n"
		.byte	"[value] P\t\tstore in PSW\t"
		.byte	"R\t\t\tprint registers\r\n", 0

; -----------------------------------------------------------------------
; sort of a bss segment
; -----------------------------------------------------------------------
		.org	0x8000
run_regs:	.skip	2		; DPTR [H/L]
run_regs_psw:	.skip	1		; PSW
		.skip	1		; ACC
linebuf:	.skip	256

		.end
