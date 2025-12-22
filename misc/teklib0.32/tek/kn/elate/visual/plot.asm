
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
;	void kn_plot(TAPTR v, TINT x, TINT y)
;
;-----------------------------------------------------------------------------
;=============================================================================

	tool 'lib/tek/kn/visual/plot',VP,TF_EMBED

;-----------------------------------------------------------------------------

	ent p0 i0 i1 : -

	defbegin
	defp visual
	defi x,y

	defp pixmap
	defi color

		cpy.i	[visual+vis_fgcolor],color
		cpy.p	[visual+vis_pixmap],pixmap
		ncall	pixmap,plot,(pixmap,x,y,color:-)

		ret
		
	defend

	toolend

;-----------------------------------------------------------------------------
;=============================================================================
