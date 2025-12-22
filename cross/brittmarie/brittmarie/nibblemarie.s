;APS00000000000000000000000000000000000000000000000000000000000000000000000000000000
; in
;   - d0 Any byte value
; out
;   - d0 0..$f if valid, $ffffffff otherwise.
nibble2int:
	lea	nibbletable(pc), a0
nibble2int_loop:
	move.b	(a0)+, d1
	beq.b	nibble2int_end
	cmp.b	d0, d1
	beq.b	nibble2int_found
	lea	1(a0), a0
	bra.b	nibble2int_loop

nibble2int_found:
	clr.l	d0
	move.b	(a0), d0
	rts

nibble2int_end:
	moveq.l	#-1, d0
	rts


	cnop	0,2
nibbletable:
	dc.b	'0', $0
	dc.b	'1', $1
	dc.b	'2', $2
	dc.b	'3', $3
	dc.b	'4', $4
	dc.b	'5', $5
	dc.b	'6', $6
	dc.b	'7', $7
	dc.b	'8', $8
	dc.b	'9', $9
	dc.b	'A', $a
	dc.b	'B', $b
	dc.b	'C', $c
	dc.b	'D', $d
	dc.b	'E', $e
	dc.b	'F', $f
	dc.b	'a', $a
	dc.b	'b', $b
	dc.b	'c', $c
	dc.b	'd', $d
	dc.b	'e', $e
	dc.b	'f', $f
	dc.b	0
	cnop	0,2
