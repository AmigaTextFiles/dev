
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
;	void kn_scroll(TAPTR v, TINT x, TINT y, TINT w, TINT h, TINT dx, TINT dy)
;
;-----------------------------------------------------------------------------
;=============================================================================

	tool 'lib/tek/kn/visual/scroll',VP,TF_EMBED

;-----------------------------------------------------------------------------

	ent p0 i0 i1 i2 i3 i4 i5 : -

	defbegin
	defp visual
	defi x,y,w,h,dx,dy
	defp pixmap

		cpy.p	[visual+vis_pixmap],pixmap
		ncall	pixmap,copy,(pixmap,pixmap,x,y,w-dx,h-dy,x+dx,y+dy:-)

		ret
		
	defend

	toolend

;-----------------------------------------------------------------------------
;=============================================================================
