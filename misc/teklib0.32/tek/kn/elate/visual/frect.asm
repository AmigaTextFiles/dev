
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
;	void kn_frect(TAPTR v, TINT x, TINT y, TINT w, TINT h)
;
;-----------------------------------------------------------------------------
;=============================================================================

	tool 'lib/tek/kn/visual/frect',VP,TF_EMBED

;-----------------------------------------------------------------------------

	ent p0 i0 i1 i2 i3 : -

	defbegin
	defp visual
	defi x,y,w,h
	defp xarr,yarr,pixmap
	defi color

		cpy.i	[visual+vis_fgcolor],color
		cpy.p	[visual+vis_pixmap],pixmap
		ncall	pixmap,fbox,(pixmap,x,y,color,w,h:-)

		ret
		
	defend

	toolend

;-----------------------------------------------------------------------------
;=============================================================================
