
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
;	TVOID kn_line(visual, x1, y1, x2, y2)
;
;-----------------------------------------------------------------------------
;=============================================================================

	tool 'lib/tek/kn/visual/line',VP,TF_EMBED

;-----------------------------------------------------------------------------

	ent p0 i0 i1 i2 i3 : -

	defbegin
	defp visual
	defi x0,y0,x,y

	defi color
	defp pixmap

		cpy.p	[visual+vis_pixmap],pixmap
		cpy.i	[visual+vis_fgcolor],color
		ncall	pixmap,line,(pixmap,x0,y0,color,x,y:-)
		ret
		
	defend

	toolend

;-----------------------------------------------------------------------------
;=============================================================================
