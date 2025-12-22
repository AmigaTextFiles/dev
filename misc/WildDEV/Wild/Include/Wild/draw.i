
	IFND	WILDraw
WILDraw	SET	1

		STRUCTURE	WildDrawModuleBASE,wm_SIZEOF
			LABEL	wdrm_SIZEOF

_LVODRWPaintArray	EQU	-60		; A0:App,A1:Array of sorted BSPEntries (0 terminated)
_LVODRWInitFrame	EQU	-66		; A0:App
_LVODRWInitTexture	EQU	-72		; A0:App,A1:Texture

	ENDC