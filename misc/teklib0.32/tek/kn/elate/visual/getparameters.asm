
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
;	void kn_getparameters(TAPTR v, struct visual_parameters *p)
;
;-----------------------------------------------------------------------------
;=============================================================================

	tool 'lib/tek/kn/visual/getparameters',VP,TF_EMBED

;-----------------------------------------------------------------------------

	ent p0 p1 : -

	defbegin
	defp visual,params
	defi w,h,fw,fh

		cpy.i	[visual+vis_width],w
		cpy.i	[visual+vis_height],h
		cpy.i	[visual+vis_fontwidth],fw
		cpy.i	[visual+vis_fontheight],fh
		cpy.i	w,[params]
		cpy.i	h,[params+4]
		cpy.i	w/fw,[params+8]
		cpy.i	h/fh,[params+12]
		cpy.i	fw,[params+16]
		cpy.i	fh,[params+20]

		ret

	defend

	toolend

;-----------------------------------------------------------------------------
;=============================================================================
