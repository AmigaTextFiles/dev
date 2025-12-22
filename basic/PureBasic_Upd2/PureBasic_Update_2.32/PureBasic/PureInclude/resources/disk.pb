;
; ** $VER: disk.h 27.11 (21.11.90)
; ** Includes Release 40.15
; **
; ** disk.h -- external declarations for the disk resource
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/lists.pb"
XIncludeFile "exec/ports.pb"
XIncludeFile "exec/interrupts.pb"
XIncludeFile "exec/libraries.pb"


; *******************************************************************
; *
; * Resource structures
; *
; *******************************************************************


Structure DiscResourceUnit
    dru_Message.Message
    dru_DiscBlock.Interrupt
    dru_DiscSync.Interrupt
    dru_Index.Interrupt
EndStructure

Structure DiscResource
     dr_Library.Library
    *dr_Current.DiscResourceUnit
    dr_Flags.b
    dr_pad.b
     *dr_SysLib.Library
     *dr_CiaResource.Library
    dr_UnitID.l[4]
    dr_Waiting.List
    dr_DiscBlock.Interrupt
    dr_DiscSync.Interrupt
    dr_Index.Interrupt
    *dr_CurrTask.Task
EndStructure

;  dr_Flags entries
#DRB_ALLOC0 = 0 ;  unit zero is allocated
#DRB_ALLOC1 = 1 ;  unit one is allocated
#DRB_ALLOC2 = 2 ;  unit two is allocated
#DRB_ALLOC3 = 3 ;  unit three is allocated
#DRB_ACTIVE = 7 ;  is the disc currently busy?

#DRF_ALLOC0 = (1 << 0) ;  unit zero is allocated
#DRF_ALLOC1 = (1 << 1) ;  unit one is allocated
#DRF_ALLOC2 = (1 << 2) ;  unit two is allocated
#DRF_ALLOC3 = (1 << 3) ;  unit three is allocated
#DRF_ACTIVE = (1 << 7) ;  is the disc currently busy?



; *******************************************************************
; *
; * Hardware Magic
; *
; *******************************************************************


#DSKDMAOFF = $4000 ;  idle command for dsklen register


; *******************************************************************
; *
; * Resource specific commands
; *
; *******************************************************************

;
;  * DISKNAME is a generic macro to get the name of the resource.
;  * This way if the name is ever changed you will pick up the
;  *  change automatically.
;

;#DISKNAME = "disk\resource"

#DR_ALLOCUNIT = (#LIB_BASE - 0*#LIB_VECTSIZE)
#DR_FREEUNIT = (#LIB_BASE - 1*#LIB_VECTSIZE)
#DR_GETUNIT = (#LIB_BASE - 2*#LIB_VECTSIZE)
#DR_GIVEUNIT = (#LIB_BASE - 3*#LIB_VECTSIZE)
#DR_GETUNITID = (#LIB_BASE - 4*#LIB_VECTSIZE)
#DR_READUNITID = (#LIB_BASE - 5*#LIB_VECTSIZE)

#DR_LASTCOMM = (#DR_READUNITID)

; *******************************************************************
; *
; * drive types
; *
; *******************************************************************

#DRT_AMIGA = ($00000000)
#DRT_37422D2S = ($55555555)
#DRT_EMPTY = ($FFFFFFFF)
#DRT_150RPM = ($AAAAAAAA)

