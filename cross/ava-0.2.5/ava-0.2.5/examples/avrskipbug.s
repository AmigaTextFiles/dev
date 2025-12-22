/*
	avrskipbug.s
	
	Bug Test: skip instruction followed by the two-word instruction
	Uros Platise (c) 1999
*/

#arch AT90S8515
#include "avr.inc"

	seg flash.code
	
	lds	r2,last_val
	sbic	PIND,2
	lds	r2,init_val
	inc	r2
	sts	last_val,r2
	lds	r3, init_val
	cpse	r2,r3
	sts	last_val,r3
	

	seg eram.data
	
init_val:	ds.b	1
last_val:	ds.b	1
