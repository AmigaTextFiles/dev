;
; ** $VER: sprite.h 39.6 (16.6.92)
; ** Includes Release 40.15
; **
; **
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

#SPRITE_ATTACHED = $80

Structure SimpleSprite

    *posctldata.w
    height.w
    x.w
    y.w    ;  current position
    num.w
EndStructure

Structure ExtSprite

 es_SimpleSprite.SimpleSprite ;  conventional simple sprite structure
 es_wordwidth.w   ;  graphics use only, subject to change
 es_flags.w   ;  graphics use only, subject to change
EndStructure



;  tags for AllocSpriteData()
#SPRITEA_Width  = $81000000
#SPRITEA_XReplication = $81000002
#SPRITEA_YReplication = $81000004
#SPRITEA_OutputHeight = $81000006
#SPRITEA_Attached = $81000008
#SPRITEA_OldDataFormat = $8100000a ;  MUST pass in outputheight if using this tag

;  tags for GetExtSprite()
#GSTAG_SPRITE_NUM = $82000020
#GSTAG_ATTACHED  = $82000022
#GSTAG_SOFTSPRITE = $82000024

;  tags valid for either GetExtSprite or ChangeExtSprite
#GSTAG_SCANDOUBLED = $83000000 ;  request "NTSC-Like" height if possible.

