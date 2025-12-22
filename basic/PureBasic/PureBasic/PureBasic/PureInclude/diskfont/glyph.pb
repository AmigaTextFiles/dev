;
; ** $VER: glyph.h 9.1 (19.6.92)
; ** Includes Release 40.15
; **
; ** glyph.h -- structures for glyph libraries
; **
; ** (C) Copyright 1991-1992 Robert R. Burns
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/types.pb"
XIncludeFile "exec/libraries.pb"
XIncludeFile "exec/nodes.pb"

;  A GlyphEngine must be acquired via OpenEngine and is read-only
Structure GlyphEngine
    *gle_Library.Library ;  engine library
    *gle_Name.b  ;  library basename: e.g. "bullet"
    ;  private library data follows...
EndStructure

Structure GlyphMap
    glm_BMModulo.w ;  # of bytes in row: always multiple of 4
    glm_BMRows.w  ;  # of rows in bitmap
    glm_BlackLeft.w ;  # of blank pixel columns at left
    glm_BlackTop.w ;  # of blank rows at top
    glm_BlackWidth.w ;  span of contiguous non-blank columns
    glm_BlackHeight.w ;  span of contiguous non-blank rows
    glm_XOrigin.l ;  distance from upper left corner of bitmap
    glm_YOrigin.l ;    to initial CP, in fractional pixels
    glm_X0.w  ;  approximation of XOrigin in whole pixels
    glm_Y0.w  ;  approximation of YOrigin in whole pixels
    glm_X1.w  ;  approximation of XOrigin + Width
    glm_Y1.w  ;  approximation of YOrigin + Width
    glm_Width.l  ;  character advance, as fraction of em width
    *glm_BitMap.b  ;  actual glyph bitmap
EndStructure

Structure GlyphWidthEntry
    gwe_Node.MinNode ;  on list returned by OT_WidthList inquiry
    gwe_Code.w  ;  entry's character code value
    gwe_Width.l  ;  character advance, as fraction of em width
EndStructure
