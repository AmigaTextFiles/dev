
	.include 'taort'
	.include 'ave/toolkit/toolkit.inc'
	.include 'lib/tek/kn/elate/visual.inc'
	.include 'ave/font/style.inc'

;=============================================================================
;-----------------------------------------------------------------------------
; 
;	TEKlib
;	(C) 1999-2001 TEK neoscientists
;	all rights reserved.
;
;	TVOID kn_drawtext(TAPTR v, TSTRPTR text, TINT x, TINT y, TINT length)
;
;-----------------------------------------------------------------------------
;=============================================================================

	tool 'lib/tek/kn/visual/drawtext',VP,TF_EMBED

;-----------------------------------------------------------------------------

	ent p0 p1 i0 i1 i2 : -

	defbegin
	defp visual,text
	defi x,y,len
	defp font,pixmap
	defi bgcol,fgcol

		cpy.p	[visual+vis_font],font
		cpy.p	[visual+vis_pixmap],pixmap
		
		cpy.i	[visual+vis_bgcolor],bgcol
		cpy.i	[visual+vis_fgcolor],fgcol

		cpy.i	[visual+vis_fontwidth]*x,x
		cpy.i	[visual+vis_fontheight]*y,y

		ncall	font,strnprint,(font,pixmap,text,0.p,x,y+2,fgcol,bgcol,TRF_INK+TRF_PAPER,len:i~,i~)
		
		ret
		
	defend

	toolend

;-----------------------------------------------------------------------------
;=============================================================================
