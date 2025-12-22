
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
;	void kn_visualdestroy(TAPTR visual)
;
;-----------------------------------------------------------------------------
;=============================================================================

	tool 'lib/tek/kn/visual/destroyvisual',VP,0

;-----------------------------------------------------------------------------

	ent p0 : -

	defbegin
	defp visual
	defp ave,temp
	
		bcn	visual eq 0,_dw_exit

		cpy.p	[visual+vis_ave],ave
		bcn	ave eq 0,_dw_noave

		cpy.p	[visual+vis_toolkit],temp
		bcn	temp eq 0,_dw_notkit

		ncall	ave,closetoolkit,(ave,temp:-)

_dw_notkit:	cpy.p	[visual+vis_app],temp
		ncall	ave,close,(ave,temp:i~)

_dw_noave:	cpy.p	[visual+vis_buffer],temp
		qcall	lib/free,(temp:-)

		cpy.p	[visual+vis_buffer2],temp
		qcall	lib/free,(temp:-)

		cpy.p	[visual+vis_font],temp
		bcn	temp eq 0,_dw_nofont
		qcall	ave/font/close,(temp:-)
_dw_nofont:
		qcall	lib/free,(visual:-)

_dw_exit:
		ret
		
	defend
	toolend

;-----------------------------------------------------------------------------
;=============================================================================
