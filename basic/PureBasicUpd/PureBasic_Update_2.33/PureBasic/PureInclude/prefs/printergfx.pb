;
; ** $VER: printergfx.h 38.2 (3.7.91)
; ** Includes Release 40.15
; **
; ** File format for graphics printer preferences
; **
; ** (C) Copyright 1991-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
;

; ***************************************************************************


#ID_PGFX = $50474658


Structure PrinterGfxPrefs

    pg_Reserved.l[4]
    pg_Aspect.w
    pg_Shade.w
    pg_Image.w
    pg_Threshold.w
    pg_ColorCorrect.b
    pg_Dimensions.b
    pg_Dithering.b
    pg_GraphicFlags.w
    pg_PrintDensity.b  ;  Print density 1 - 7
    pg_PrintMaxWidth.w
    pg_PrintMaxHeight.w
    pg_PrintXOffset.b
    pg_PrintYOffset.b
EndStructure

;  constants for PrinterGfxPrefs.pg_Aspect
#PA_HORIZONTAL = 0
#PA_VERTICAL   = 1

;  constants for PrinterGfxPrefs.pg_Shade
#PS_BW  = 0
#PS_GREYSCALE = 1
#PS_COLOR = 2
#PS_GREY_SCALE2 = 3

;  constants for PrinterGfxPrefs.pg_Image
#PI_POSITIVE = 0
#PI_NEGATIVE = 1

;  flags for PrinterGfxPrefs.pg_ColorCorrect
#PCCB_RED   = 1 ;  color correct red shades
#PCCB_GREEN = 2 ;  color correct green shades
#PCCB_BLUE  = 3 ;  color correct blue shades

#PCCF_RED   = (1 << 0)
#PCCF_GREEN = (1 << 1)
#PCCF_BLUE  = (1 << 2)

;  constants for PrinterGfxPrefs.pg_Dimensions
#PD_IGNORE   = 0  ;  ignore max width/height settings
#PD_BOUNDED  = 1  ;  use max w/h as boundaries
#PD_ABSOLUTE = 2  ;  use max w/h as absolutes
#PD_PIXEL    = 3  ;  use max w/h as prt pixels
#PD_MULTIPLY = 4  ;  use max w/h as multipliers

;  constants for PrinterGfxPrefs.pg_Dithering
#PD_ORDERED = 0  ;  ordered dithering
#PD_HALFTONE = 1  ;  halftone dithering
#PD_FLOYD = 2  ;  Floyd-Steinberg dithering

;  flags for PrinterGfxPrefs.pg_GraphicsFlags
#PGFB_CENTER_IMAGE = 0 ;  center image on paper
#PGFB_INTEGER_SCALING = 1 ;  force integer scaling
#PGFB_ANTI_ALIAS  = 2 ;  anti-alias image

#PGFF_CENTER_IMAGE = (1 << 0)
#PGFF_INTEGER_SCALING = (1 << 1)
#PGFF_ANTI_ALIAS  = (1 << 2)


; ***************************************************************************


