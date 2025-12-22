	IFND	wildlighttype2
wildlighttype2	SET	1

	include	wild/tdcore_typeA1.i

; Type 2 of light does: illumination by FACES, not by POINTS.
; THIS USES 24BIT COLORS, NO INTENSITY LIKE TYPE 1.
; Is good for a flat illumination.

	STRUCTURE	LightTemp,t1bs_Light
		LONG	t1bs_IlluminatedColor		; 24bit color of the face illuminated
		LABEL	t1bs_LightBuffer
		
		
	ENDC