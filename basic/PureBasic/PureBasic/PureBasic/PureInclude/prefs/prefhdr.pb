;
; ** $VER: prefhdr.h 38.1 (19.6.91)
; ** Includes Release 40.15
; **
; ** File format for preferences header
; **
; ** (C) Copyright 1991-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
;

; ***************************************************************************


#ID_PREF = $50524546
#ID_PRHD = $50524844


Structure PrefHeader

    ph_Version.b ;  version of following data
    ph_Type.b ;  type of following data
    ph_Flags.l ;  always set to 0 for now
EndStructure


; ***************************************************************************


