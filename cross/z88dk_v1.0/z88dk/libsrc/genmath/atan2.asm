;	Small C+ math library
;	atan(x,y)
;	Compiled C..hence the hideous size!


	XLIB	atan2
	LIB	atan

	XREF	pi
	XREF	halfpi

	XREF	dload
	XREF	dpush
	XREF	fabs
	XREF	dge
	XREF	ddiv
	XREF	dstore
	XREF	dlt
	XREF	dadd
	XREF	dsub
	XREF	minusfa
	XREF	qifix

.atan2 
	push	bc
	push	bc
	push	bc
	ld	hl,8
	add	hl,sp
	call	dload
	call	dpush
	call	fabs
	pop	bc
	pop	bc
	pop	bc
	call	dpush
	ld	hl,20
	add	hl,sp
	call	dload
	call	dpush
	call	fabs
	pop	bc
	pop	bc
	pop	bc
	call	dge
	ld	a,h
	or	l
	jp	z,i_2
	ld	hl,0
	add	hl,sp
	push	hl
	ld	hl,16
	add	hl,sp
	call	dload
	call	dpush
	ld	hl,16
	add	hl,sp
	call	dload
	call	ddiv
	call	dpush
	call	atan
	pop	bc
	pop	bc
	pop	bc
	pop	hl
	call	dstore
	ld	hl,8
	add	hl,sp
	call	dload
	call	dpush
	ld	hl,i_1+0
	call	dload
	call	dlt
	ld	a,h
	or	l
	jp	z,i_3
	ld	hl,14
	add	hl,sp
	call	dload
	call	dpush
	ld	hl,i_1+6
	call	dload
	call	dge
	ld	a,h
	or	l
	jp	z,i_4
	ld	hl,0
	add	hl,sp
	push	hl
	call	dload
	call	dpush
	ld	hl,pi
	call	dload
	call	dadd
	pop	hl
	call	dstore
	jp	i_5
.i_4 
	ld	hl,0
	add	hl,sp
	push	hl
	call	dload
	call	dpush
	ld	hl,pi
	call	dload
	call	dsub
	pop	hl
	call	dstore
.i_5 
.i_3 
	jp	i_6
.i_2 
	ld	hl,0
	add	hl,sp
	push	hl
	ld	hl,10
	add	hl,sp
	call	dload
	call	dpush
	ld	hl,22
	add	hl,sp
	call	dload
	call	ddiv
	call	dpush
	call	atan
	pop	bc
	pop	bc
	pop	bc
	call	minusfa
	pop	hl
	call	dstore
	ld	hl,14
	add	hl,sp
	call	dload
	call	dpush
	ld	hl,i_1+12
	call	dload
	call	dlt
	ld	a,h
	or	l
	jp	z,i_7
	ld	hl,0
	add	hl,sp
	push	hl
	call	dload
	call	dpush
	ld	hl,halfpi
	call	dload
	call	dsub
	pop	hl
	call	dstore
	jp	i_8
.i_7 
	ld	hl,0
	add	hl,sp
	push	hl
	call	dload
	call	dpush
	ld	hl,halfpi
	call	dload
	call	dadd
	pop	hl
	call	dstore
.i_8 
.i_6 
	ld	hl,0
	add	hl,sp
	call	dload
	call	qifix
	pop	bc
	pop	bc
	pop	bc
	ret


.i_1 
	defb	0,0,0,0,0,0,0,0,0,0
	defb	0,0,0,0,0,0,0,0
