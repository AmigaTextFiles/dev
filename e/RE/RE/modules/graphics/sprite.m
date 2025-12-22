#ifndef	GRAPHICS_SPRITE_H
#define	GRAPHICS_SPRITE_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#define SPRITE_ATTACHED $80
OBJECT SimpleSprite

    posctldata:PTR TO UWORD
    height:UWORD
    x:UWORD
y:UWORD    
    num:UWORD
ENDOBJECT

OBJECT ExtSprite

	  SimpleSprite:SimpleSprite	
	wordwidth:UWORD			
	flags:UWORD			
ENDOBJECT


#define SPRITEA_Width		$81000000
#define SPRITEA_XReplication	$81000002
#define SPRITEA_YReplication	$81000004
#define SPRITEA_OutputHeight	$81000006
#define SPRITEA_Attached	$81000008
#define SPRITEA_OldDataFormat	$8100000a	

#define GSTAG_SPRITE_NUM $82000020
#define GSTAG_ATTACHED	 $82000022
#define GSTAG_SOFTSPRITE $82000024

#define GSTAG_SCANDOUBLED	$83000000	
#endif	
