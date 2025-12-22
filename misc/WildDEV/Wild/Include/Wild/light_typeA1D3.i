	IFND	wildlighttype3
wildlighttype3	SET	1

	include	wild/tdcore_typeA1.i

; Type 3 of lighting: calced for the 3 points of a face.
; Uses only intensity, like type 1.

	STRUCTURE	LightTemp,t1pn_Light
		WORD	t1pn_Intensity
		LABEL	t1pn_LightBuffer
		
		
		
	ENDC