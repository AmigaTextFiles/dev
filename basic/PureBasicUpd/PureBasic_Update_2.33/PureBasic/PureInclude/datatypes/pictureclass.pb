; 
; **  $VER: pictureclass.h 39.5 (28.4.93)
; **  Includes Release 40.15
; **
; **  Interface definitions for DataType picture objects.
; **
; **  (C) Copyright 1992-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
; 

IncludePath  "PureInclude:"
XIncludeFile "utility/tagitem\h"
XIncludeFile "datatypes/datatypesclass\h"
XIncludeFile "libraries/iffparse\h"

; ***************************************************************************

; #PICTUREDTCLASS  = "picture\datatype"

; ***************************************************************************

;  Picture attributes 
#PDTA_ModeID  = (#DTA_Dummy + 200)
 ;  Mode ID of the picture 

#PDTA_BitMapHeader = (#DTA_Dummy + 201)

#PDTA_BitMap  = (#DTA_Dummy + 202)
 ;  Pointer to a class-allocated bitmap, that will end
;   * up being freed by picture.class when DisposeDTObject()
;   * is called 

#PDTA_ColorRegisters = (#DTA_Dummy + 203)
#PDTA_CRegs  = (#DTA_Dummy + 204)
#PDTA_GRegs  = (#DTA_Dummy + 205)
#PDTA_ColorTable  = (#DTA_Dummy + 206)
#PDTA_ColorTable2 = (#DTA_Dummy + 207)
#PDTA_Allocated  = (#DTA_Dummy + 208)
#PDTA_NumColors  = (#DTA_Dummy + 209)
#PDTA_NumAlloc  = (#DTA_Dummy + 210)

#PDTA_Remap  = (#DTA_Dummy + 211)
 ;  Boolean : Remap picture (defaults to TRUE) 

#PDTA_Screen  = (#DTA_Dummy + 212)
 ;  Screen to remap to 

#PDTA_FreeSourceBitMap = (#DTA_Dummy + 213)
 ;  Boolean : Free the source bitmap after remapping 

#PDTA_Grab  = (#DTA_Dummy + 214)
 ;  Pointer to a Point structure 

#PDTA_DestBitMap  = (#DTA_Dummy + 215)
 ;  Pointer to the destination (remapped) bitmap 

#PDTA_ClassBitMap = (#DTA_Dummy + 216)
 ;  Pointer to class-allocated bitmap, that will end
;   * up being freed by the class after DisposeDTObject()
;   * is called 

#PDTA_NumSparse  = (#DTA_Dummy + 217)
 ;  (UWORD) Number of colors used for sparse remapping 

#PDTA_SparseTable = (#DTA_Dummy + 218)
 ;  (UBYTE *) Pointer to a table of pen numbers indicating
;   * which colors should be used when remapping the image.
;   * This array must contain as many entries as there
;   * are colors specified with PDTA_NumSparse 

; ***************************************************************************

;   Masking techniques 
#mskNone   = 0
#mskHasMask  = 1
#mskHasTransparentColor = 2
#mskLasso  = 3
#mskHasAlpha  = 4

;   Compression techniques  
#cmpNone   = 0
#cmpByteRun1  = 1
#cmpByteRun2  = 2

;   Bitmap header (BMHD) structure  
Structure BitMapHeader

    bmh_Width.w  ;  Width in pixels 
    bmh_Height.w  ;  Height in pixels 
    bmh_Left.w  ;  Left position 
    bmh_Top.w  ;  Top position 
    bmh_Depth.b  ;  Number of planes 
    bmh_Masking.b  ;  Masking type 
    bmh_Compression.b ;  Compression type 
    bmh_Pad.b
    bmh_Transparent.w ;  Transparent color 
    bmh_XAspect.b
    bmh_YAspect.b
    bmh_PageWidth.w
    bmh_PageHeight.w
EndStructure

; ***************************************************************************

;   Color register structure 
Structure ColorRegister

    red.b : green.b : blue.b
EndStructure

; ***************************************************************************

;  IFF types that may be in pictures 
; #ID_ILBM  = MAKE_ID('I','L','B','M')
; #ID_BMHD  = MAKE_ID('B','M','H','D')
; #ID_BODY  = MAKE_ID('B','O','D','Y')
; #ID_CMAP  = MAKE_ID('C','M','A','P')
; #ID_CRNG  = MAKE_ID('C','R','N','G')
; #ID_GRAB  = MAKE_ID('G','R','A','B')
; #ID_SPRT  = MAKE_ID('S','P','R','T')
; #ID_DEST  = MAKE_ID('D','E','S','T')
; #ID_CAMG  = MAKE_ID('C','A','M','G')

