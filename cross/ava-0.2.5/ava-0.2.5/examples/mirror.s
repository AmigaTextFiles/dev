/*
  mirror.s

  An example of mirror segment.
  Segment eram.mirror is copied to the flash.mirror and
  if and only if reference __mirror is used, the flash.mirror
  is present.
 
  Uros Platise (c) 1999
*/

#arch AT90S8515
#include "avr.inc"	

	seg abs=0 size=10 removable flash.mirror
public __mirror:

	seg mirror=flash.mirror eram.mirror

	seg eram.mirror
	dc.b "alphabeta"

	seg flash.code
	ldi r16,low(__mirror)
