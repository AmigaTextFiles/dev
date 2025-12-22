
	; Simple extended code test for cfasm

	; -- origin
	org	$78000000

	; -- set cpu types. The types available are 5206, 5206e, 5249, 5272, 5307
	;    5407 and "any".
	;    Only cpu types with the mac unit will assemble this correctly.
	cpu 	5206e

	; -- sample structure. The zero value after the test1 is optional, as zero
	;    is a default. This value prefixes the first value in the structure.
      structure test1,0
	fixed	ts_value1
	float	ts_value2
	ulong	ts_value3
	label	ts_sizeof

_main
	; -- mac accumulator
	move.l	acc,d0
	move.l	d0,acc
	move.l	#12345678,acc

	; -- mac mask
	move.l	mask,d0
	move.l	d0,mask
	move.l	#12345678,mask
	
	; -- mac sr
	move.l	macsr,d0
	move.l	d0,macsr
	move.l	#12345678,macsr
	
	; -- move macsr to ccr
	move.l	macsr,ccr
	
	; -- mac types
	mac.w	d0,d1<<1
	mac.l	d0,d1

	msac.w	d0,d1
	msac.l	d0,d1

	mac.w	d0.u,d1.u>>1

	msac.w	d0,d1>>1
	msac.w	d0,d1<<1

	macl.w	d0,d1,(a0),d2
	macl.w	d0,d1,(a4),d6
	macl.w	d0.u,d1.u<<1,(a0),d2
	macl.w	d0.u,d1.u>>1,(a4),d6

	macl.l	d0,d1,(a0),d2
	;
	macl.w	d0,d1,(a2),d6
	macl.w	d0,d1,(a2)+,d6
	macl.w	d0,d1,-(a2),d6
	macl.w	d0,d1,(10,a2),d6
	macl.w	d0,d1<<1,(10,a2),d6

	macl.w	d0,d1,(a2)&,d6
	macl.w	d0,d1,-(a2)&,d6
	macl.w	d0,d1,(a2)+&,d6
	macl.w	d0,d1,(8,a2)&,d6

	macl.w	d0,d1>>1,(a2)&,d6
	macl.w	d0,d1>>1,-(a2)&,d6
	macl.w	d0,d1>>1,(a2)+&,d6
	macl.w	d0,d1>>1,(8,a2)&,d6

	move.l	#ts_value1,d0
	move.l	#ts_value2,d0
	move.l	#ts_value3,d0

	rts
	; -- use the boundary command to issue special segment code between
	;    the end of code and the start of data. This is used to prevent
	;    the look ahead function of the instruction cache obtaining
	;    invalid data and a possible lockup.
; --------------------------------------------------------------------------
	boundary
; --------------------------------------------------------------------------
