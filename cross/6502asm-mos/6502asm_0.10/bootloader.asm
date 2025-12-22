BRKFAKE:
	rti

START:
	lda	#0x00	;
	sta	0x8000	; turn off interrupts

; connection settings
	lda	#0x80	
	sta	0x8003	; DLHB on
	lda	#0x0C	; 9600 baud lsb
	sta	0x8000	; -> DLL
	lda	#0x00	; =9600 baud msb
	sta	0x8001	; -> DLM
			; see datasheet on 16c550 page 10 for details
	lda	#0x03	; =8-N-1, DLHB off
	sta	0x8003	; -> LCR
			; see datasheet on 16c500 page 17 for details
	lda	#0xC7	; = RCVR trigger MSB/LSB, DMA mode=0, trigger level=14 
			; XMIT FIFO reset, RCVR FIFO reset, FIFO enable
	sta	0x8002  ; -> FCR
	lda	#0x0B	; loopback=0, -op2=1,-op1=0,-rts=1,-dtr=1
	sta	0x8004	; -> MCR

	
	ldx	#0x00
PRINTHEADER:
	lda	TEXT,x
	beq	PRINTHEADERDONE
	inx
	sta	0x8000
	jmp	PRINTHEADER
PRINTHEADERDONE:
	ldx	#0x00
PRINTPROMPT:
	lda	PROMPT,x
	beq	PRINTPROMPTDONE
	inx	
	sta	0x8000
	jmp	PRINTPROMPT

PRINTPROMPTDONE:
	ldx	#0x00	; set x-reg to 0
	ldy	#0x80	; set y-reg to 0
	lda	#0x01	; msb for x-modem
	sty	0x00	; lsb
	sta	0x01	; msb
	sta	0x02	; block number=0
WAITFORKEY:
	lda	0x8005	; <-LSR
	and	#0x01	; key pressed
	beq	WAITFORKEY
	lda	0x8000	; read key
	eor	#0x01	; x-modem header detected
	beq	RECEIVE_XMODEMHEADER
	eor	#0x01	; no x-modem header

	sta	0x8000	; return an echo
	eor	#0x0A	; enter?
	beq	PRINTPROMPT
	eor	#0x0A
	eor	#0x3F	; ?
	beq	HELPSCREEN
	eor	#0x3F
	eor	#0x58	; X?
	beq	RECEIVE_XMODEM_RUN
	eor	#0x58
	eor	#0x78	; x?
	beq	RECEIVE_XMODEM_NORUN
	eor	#0x78
	jmp	WAITFORKEY
HELPSCREEN:
	ldx	#0x00	; set x-reg to 0
PRINTHELPSCREEN:
	lda	HELP,x
	beq	PRINTPROMPTDONE
	inx
	sta	0x8000
	jmp	PRINTHELPSCREEN

RECEIVE_XMODEMHEADER:
	jsr	RECEIVE_XMODEM_GOTHEADER
;	jmp	0x200	// run the program
	jmp	PRINTPROMPT
RECEIVE_XMODEM_RUN:
	jsr	RECEIVE_XMODEM
	jmp	0x0200	; run the program
	
RECEIVE_XMODEM_NORUN:
	jsr	RECEIVE_XMODEM
	jmp	PRINTPROMPT

; load a program, transmitted by xmodem protocol
; store it at (00)+y
; set y to 0x80 at first, and the address at 0x180, this way it is easier
; to detect the end of a 128 byte block.
RECEIVE_XMODEM:
	lda	#0x15
	sta	0x8000	
RECEIVE_XMODEM_NONACK:
	ldx	#0x00
	stx	0x04	; timeout
RECEIVE_XMODEM_WAITFORDATA:
	lda	0x8005
	dex
	bne	RECEIVE_XMODEM_WAITFORDATAGOON
	dec	0x04
	bne	RECEIVE_XMODEM_WAITFORDATAGOON
	lda	#0x15	; NACK
	sta	0x8000	
	jmp	RECEIVE_XMODEM
RECEIVE_XMODEM_WAITFORDATAGOON:
	and	#0x01	; wait for data
	beq	RECEIVE_XMODEM_WAITFORDATA
	ldx	#0x00
	stx	0x04
	lda	0x8000	; which byte was it?
	eor	#0x01
	BEQ	RECEIVE_XMODEM_GOTHEADER
	eor	#0x05	; end of transmission (xor 1,xor 4=xor 5)
	bne	RECEIVE_XMODEM	
	jmp	RECEIVE_XMODEM_DONE		
; i assume you got the header by now
RECEIVE_XMODEM_GOTHEADER:
	dex
	beq	RECEIVE_XMODEM_GOTHEADERGOON
	dec	0x04
	bne	RECEIVE_XMODEM_GOTHEADERGOON
	jmp	RECEIVE_XMODEM
RECEIVE_XMODEM_GOTHEADERGOON:
	lda	0x8005
	and	#0x01	; wait for data
	beq	RECEIVE_XMODEM_GOTHEADER
	lda	0x8000	; which byte was it?
	eor	0x02	; the block number?
	bne	RECEIVE_XMODEM_SEND_NACK	; no? what a shame
	eor	0x02	
	ldx	#0x00
	stx	0x04	
RECEIVE_XMODEM_GOTBLOCKNUM:
	dex
	bne	RECEIVE_XMODEM_GOTBLOCKNUMGOON
	dec	0x04
	bne	RECEIVE_XMODEM_GOTBLOCKNUMGOON
	jmp	RECEIVE_XMODEM
RECEIVE_XMODEM_GOTBLOCKNUMGOON:
	lda	0x8005
	and	#0x01	; wait for data
	beq	RECEIVE_XMODEM_GOTBLOCKNUM
	eor	0x8000	; which byte was it?
	eor	#0xff	; the inverted blocknum?
	bne	RECEIVE_XMODEM_SEND_NACK        ; no? what a shame
	sta	0x03	; crc=0

	ldx	#0x00
	stx	0x04
RECEIVE_XMODEM_GET128BYTES:
	dex
	bne	RECEIVE_XMODEM_GET128BYTESGOON
	dec	0x04
	bne	RECEIVE_XMODEM_GET128BYTESGOON
	jmp	RECEIVE_XMODEM

RECEIVE_XMODEM_GET128BYTESGOON:

	lda	0x8005
	and	#0x01	; wait for data
	beq	RECEIVE_XMODEM_GET128BYTES
	lda	0x8000
	sta	(0x00),y	; store it
	clc			; clear c-flag
	adc	0x03		; 
	sta	0x03		; calculate the checksum
	iny			
	bne	RECEIVE_XMODEM_GET128BYTES	; wait for the next byte
	ldx	#0x00
	ldy	#0x80
RECEIVE_XMODEM_GOT128BYTES:
	dex
	bne	RECEIVE_XMODEM_GOT128BYTESGOON
	dec	0x04
	bne	RECEIVE_XMODEM_GOT128BYTESGOON
	jmp	RECEIVE_XMODEM
RECEIVE_XMODEM_GOT128BYTESGOON:
	lda	0x8005
	and	#0x01	; wait for data
	beq	RECEIVE_XMODEM_GOT128BYTES
	lda	0x8000
	eor	0x03
	bne	RECEIVE_XMODEM_SEND_NACK
	lda	#0x06	; ACK
	sta	0x8000	; send ack
; checksum okay
	inc	0x02	; increment the block num
	lda	0x00
	eor	#0x80	; increment the lsb of the address
	sta	0x00
	beq	NRECEIVE_XMODEM
	jmp	RECEIVE_XMODEM_NONACK

NRECEIVE_XMODEM:
	inc	0x01	; increment the msb of the address
	jmp	RECEIVE_XMODEM_NONACK
RECEIVE_XMODEM_SEND_NACK:
	jmp	RECEIVE_XMODEM

RECEIVE_XMODEM_DONE:
	lda	#0x06	; ACK
	sta	0x8000

	rts
	
			

LOOPFOREVER:
	jmp	LOOPFOREVER

TEXT:
."http://www.dettus.net/6502                                  type ? to get help\n"
."----------------------------------------------------------------[version 0.0]-\n\n\0"
PROMPT:
."6502> \0"
HELP:
."\nX- receive a program via X-Modem protocol. Store it at @0x0200-0x7FFF and run it\nx- receive a program via X-modem protocol. But don't run it!\n?- Show this screen\n\n\0"
ROM:
.START_LO,START_HI	; reset startup vector @0xfffc
.BRKFAKE_LO,BRKFAKE_HI	; where to go if a brk command has been issued
