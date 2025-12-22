
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
;	void kn_sync(TAPTR v, TINT x, TINT y, TINT w, TINT h)
;
;-----------------------------------------------------------------------------
;=============================================================================

	tool 'lib/tek/kn/visual/flush',VP,TF_EMBED

;-----------------------------------------------------------------------------

	ent p0 i0 i1 i2 i3 : -

	defbegin
	defp visual,pixmap
	defi x,y,w,h

		; qcall	dev/ave/tao/lock,(-:-)
		; qcall	dev/ave/tao/unlock,(-:-)

		cpy.p	[visual+vis_pixmap],pixmap

		bcp	x ge 0,_local

		ncall	pixmap,updatelocal,(pixmap:-)
		ret

_local:		ncall	pixmap,addpatch,(pixmap,x,y,w,h:-)
		ncall	pixmap,updatepatchlocal,(pixmap:-)
		ret

	defend

	toolend

;-----------------------------------------------------------------------------
;=============================================================================
