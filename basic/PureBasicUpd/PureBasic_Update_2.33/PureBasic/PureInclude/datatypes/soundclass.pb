; 
; **  $VER: soundclass.h 39.3 (26.4.93)
; **  Includes Release 40.15
; **
; **  Interface definitions for DataType sound objects.
; **
; **  (C) Copyright 1992-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
; 

IncludePath  "PureInclude:"
XIncludeFile "utility/tagitem.pb"
XIncludeFile "datatypes/datatypesclass.pb"
XIncludeFile "libraries/iffparse.pb"

; ***************************************************************************

; #SOUNDDTCLASS  = "sound\datatype"

; ***************************************************************************

;  Sound attributes 
#SDTA_Dummy  = (DTA_Dummy + 500)
#SDTA_VoiceHeader = (#SDTA_Dummy + 1)
#SDTA_Sample  = (#SDTA_Dummy + 2)
   ;  (UBYTE *) Sample data 

#SDTA_SampleLength = (#SDTA_Dummy + 3)
   ;  (ULONG) Length of the sample data in UBYTEs 

#SDTA_Period  = (#SDTA_Dummy + 4)
    ;  (UWORD) Period 

#SDTA_Volume  = (#SDTA_Dummy + 5)
    ;  (UWORD) Volume. Range from 0 to 64 

#SDTA_Cycles  = (#SDTA_Dummy + 6)

;  The following tags are new for V40 
#SDTA_SignalTask  = (#SDTA_Dummy + 7)
    ;  (struct Task *) Task to signal when sound is complete or
;  next buffer needed. 

#SDTA_SignalBit  = (#SDTA_Dummy + 8)
    ;  (BYTE) Signal bit to use on completion or -1 to disable 

#SDTA_Continuous  = (#SDTA_Dummy + 9)
    ;  (ULONG) Playing a continuous stream of data.  Defaults to
;  FALSE. 

; ***************************************************************************

#CMP_NONE     = 0
#CMP_FIBDELTA = 1

Structure VoiceHeader

    vh_OneShotHiSamples.l
    vh_RepeatHiSamples.l
    vh_SamplesPerHiCycle.l
    vh_SamplesPerSec.w
    vh_Octaves.b
    vh_Compression.b
    vh_Volume.l
EndStructure

; ***************************************************************************

;  IFF types 
; #ID_8SVX = MAKE_ID('8','S','V','X')
; #ID_VHDR = MAKE_ID('V','H','D','R')
; #ID_BODY = MAKE_ID('B','O','D','Y')

; ***************************************************************************

