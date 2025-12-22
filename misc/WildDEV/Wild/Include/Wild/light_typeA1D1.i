	IFND	wildlighttype1
wildlighttype1	SET	1

	include	wild/tdcore_typeA1.i

; Type 1 of light does: illumination by FACES, not by POINTS.
; ONLY A INTENSITY ILLUMINATION, NO USE OF COLORS !!!!!!!!!!!
; Is good for a flat illumination.

	STRUCTURE	LightTemp1,t1bs_Light
		BYTE	t1bs_Intensity		; 0-255 range
		LABEL	t1bs_LightBuffer
		
		
	ENDC