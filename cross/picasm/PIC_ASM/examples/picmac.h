;
; picmac.h
;

skipc	macro	; skip if carry
	btfss	STATUS,C
	endm

skipnc	macro	; skip if not carry
	btfsc	STATUS,C
	endm

skipz	macro	; skip if zero
	btfss	STATUS,Z
	endm

skipnz	macro	; skip if not zero
	btfsc	STATUS,Z
	endm

skpos	macro	; skip if reg >= 0 (reg)
	btfsc	\1,7
	endm

skneg	macro	; skip if reg < 0 (reg)
	btfss	\1,7
	endm

setc	macro	; set carry
	bsf	STATUS,C
	endm

clrc	macro	; clear carry
	bcf	STATUS,C
	endm

bc	macro	;branch if carry
	skipnc
	goto	\1
	endm

bnc	macro	;branch if no carry
	skipc
	goto	\1
	endm

bz	macro	;branch if zero
	skipnz
	goto	\1
	endm

bnz	macro	;branch if not zero
	skipz
	goto	\1
	endm

bpos	macro	;branch if reg >= 0 (reg,dest_addr)
	btfss	\1,7
	goto	\2
	endm

bneg	macro	;branch if reg < 0 (reg,dest_addr)
	btfsc	\1,7
	goto	\2
	endm

brset	macro	;branch if bit set (reg,bit,dest_addr)
	btfsc	\1,\2
	goto	\3
	endm

brclr	macro	;branch if bit clear (reg,bit,dest_addr)
	btfss	\1,\2
	goto	\3
	endm

;
; save W/STATUS (interrupt entry)
;
save_w_stat macro
	movwf	temp_w
	swapf	STATUS,W
	movwf	temp_s
	endm

restore_w_stat macro
	swapf	temp_s,W
	movwf	STATUS
	swapf	temp_w,F
	swapf	temp_w,W
	endm
