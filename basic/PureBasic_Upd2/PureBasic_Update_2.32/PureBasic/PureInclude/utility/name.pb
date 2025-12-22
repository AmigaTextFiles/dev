;
; ** $VER: name.h 39.5 (11.8.93)
; ** Includes Release 40.15
; **
; ** Namespace definitions
; **
; ** (C) Copyright 1992-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
; *

; ***************************************************************************


;  The named object structure
Structure NamedObject
    *no_Object.l ;  Your pointer, for whatever you want
EndStructure

;  Tags for AllocNamedObject()
#ANO_NameSpace = 4000 ;  Tag to define namespace
#ANO_UserSpace = 4001 ;  tag to define userspace
#ANO_Priority  = 4002 ;  tag to define priority
#ANO_Flags     = 4003 ;  tag to define flags

;  Flags for tag ANO_Flags
#NSB_NODUPS = 0
#NSB_CASE = 1

#NSF_NODUPS = (1  <<  #NSB_NODUPS) ;  Default allow duplicates
#NSF_CASE = (1  <<  #NSB_CASE) ;  Default to caseless...


; ***************************************************************************


