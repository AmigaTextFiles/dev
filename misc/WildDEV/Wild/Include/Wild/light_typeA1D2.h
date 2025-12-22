#ifndef		wildlighttype2_h
#define		wildlighttype2_h

#include	<wild/tdcore_typeA1.h>

/*
; Type 2 of light does: illumination by FACES, not by POINTS.
; THIS USES 24BIT COLORS, NO INTENSITY LIKE TYPE 1.
; Is good for a flat illumination.
*/

struct LightData
{
 LONG	tbs_IlluminatedColor		; 24bit color of the face illuminated
};
		
#endif