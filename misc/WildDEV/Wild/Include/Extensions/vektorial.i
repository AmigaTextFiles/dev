	IFND	VektorialExtension
VektorialExtension	SET	1

**	Vektorial.library definitions.

	STRUCTURE	VektorialBase,wx_SIZEOF
		LABEL	vkb_SIZEOF



_LVOVekLookingAt	EQU	-30		; a0:Origin(Vektor),a1:LookAt(Vektor)
_LVOCamLookingAt	EQU	-36		; a0:Cam(Ref),a1:LookAt(Vektor),d0:mode (CAMD_?)
_LVORotateDD		EQU	-42		; a0:Vek,d0:angle(0-1023),d1:X offset,d2:Y offset
_LVORotateTD		EQU	-48		; a0:Vek,d0:angle(0-1023),a1:axis (len 1!)
***************************************************************************************
*** Camera modes								*******
***************************************************************************************

CAMD_GROUND_ORIENTED	EQU	1		; Means the I versor is parallel to the ground. (Usually that's the best)

	ENDC