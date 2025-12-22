
	.include 'taort'
	.include 'ave/toolkit/toolkit.inc'
	.include 'lib/tek/kn/elate/visual.inc'

;=============================================================================
;-----------------------------------------------------------------------------
; 
;	TEKlib
;	(C) 1999-2001 TEK neoscientists
;	all rights reserved.
;
;	extern void kn_drawrgb(TAPTR v, TUINT *buf, TINT x, TINT y, TINT w, TINT h, TINT totw)
;
;	TODO: if totw == w, use a single copy
;
;-----------------------------------------------------------------------------
;=============================================================================

	tool 'lib/tek/kn/visual/drawrgb',VP,TF_EMBED

;-----------------------------------------------------------------------------

	ent p0 p1 i0 i1 i2 i3 i4 : -

	defbegin
	defp visual,buffer
	defi x,y,w,h,totw,over
	defp dest

		cpy.i	[visual+vis_width]-x-w,over
		bcp	over ge 0,_ok
		add.i	over,w
		bcn	w le 0,_raus
		
_ok:		cpy.i	[visual+vis_height]-y-h,over
		bcp	over ge 0,_ok2
		add.i	over,h
		bcn	h le 0,_raus
_ok2:
		cpy.p	[visual+vis_buffer],dest
		add.p	(x+(y*[visual+vis_width]))<<2,dest
		cpy.i	totw<<2,totw
		cpy.i	w<<2,w

_copy:		cpbi	buffer,dest,w
		add.p	totw,buffer
		add.p	[visual+vis_width]<<2,dest
		dec.i	h
		bcp	h gt 0,_copy

_raus:
		ret

	defend

	toolend

;-----------------------------------------------------------------------------
;=============================================================================
