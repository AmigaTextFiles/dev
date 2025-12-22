;
; ** $VER: oterrors.h 8.1 (19.6.92)
; ** Includes Release 40.15
; **
; ** oterrors.h -- error results from outline libraries
; **
; ** (C) Copyright 1991-1992 Robert R. Burns
; **     All Rights Reserved
;

;  PRELIMINARY
# OTERR_Failure  = -1 ;  catch-all for error
# OTERR_Success  = 0 ;  no error
# OTERR_BadTag  = 1 ;  inappropriate tag for function
# OTERR_UnknownTag = 2 ;  unknown tag for function
# OTERR_BadData  = 3 ;  catch-all for bad tag data
# OTERR_NoMemory  = 4 ;  insufficient memory for operation
# OTERR_NoFace  = 5 ;  no typeface currently specified
# OTERR_BadFace  = 6 ;  typeface specification problem
# OTERR_NoGlyph  = 7 ;  no glyph specified
# OTERR_BadGlyph  = 8 ;  bad glyph code or glyph range
# OTERR_NoShear  = 9 ;  shear only partially specified
# OTERR_NoRotate  = 10 ;  rotate only partially specified
# OTERR_TooSmall  = 11 ;  typeface metrics yield tiny glyphs
# OTERR_UnknownGlyph = 12 ;  glyph not known by engine

