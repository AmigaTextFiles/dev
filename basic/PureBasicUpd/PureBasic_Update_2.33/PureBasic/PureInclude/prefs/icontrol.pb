;
; ** $VER: icontrol.h 39.1 (1.10.92)
; ** Includes Release 40.15
; **
; ** File format for intuition control preferences
; **
; ** (C) Copyright 1991-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
;

; ***************************************************************************


; ***************************************************************************


#ID_ICTL = $4943544C


Structure IControlPrefs

    ic_Reserved.l[4] ;  System reserved
    ic_TimeOut.w  ;  Verify timeout
    ic_MetaDrag.w  ;  Meta drag mouse event
    ic_Flags.l  ;  IControl flags (see below)
    ic_WBtoFront.b  ;  CKey: WB to front
    ic_FrontToBack.b ;  CKey: front screen to back
    ic_ReqTrue.b  ;  CKey: Requester TRUE
    ic_ReqFalse.b  ;  CKey: Requester FALSE
EndStructure

;  flags for IControlPrefs.ic_Flags
#ICB_COERCE_COLORS = 0
#ICB_COERCE_LACE   = 1
#ICB_STRGAD_FILTER = 2
#ICB_MENUSNAP   = 3
#ICB_MODEPROMOTE   = 4

#ICF_COERCE_COLORS = (1 << 0)
#ICF_COERCE_LACE   = (1 << 1)
#ICF_STRGAD_FILTER = (1 << 2)
#ICF_MENUSNAP   = (1 << 3)
#ICF_MODEPROMOTE   = (1 << 4)


; ***************************************************************************


