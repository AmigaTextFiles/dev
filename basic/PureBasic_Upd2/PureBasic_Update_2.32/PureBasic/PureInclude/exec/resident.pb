;
; ** $VER: resident.h 39.0 (15.10.91)
; ** Includes Release 40.15
; **
; ** Resident/ROMTag stuff. Used to identify and initialize code modules.
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/types.pb"


Structure Resident
    rt_MatchWord.w ;  word to match on (ILLEGAL)
    *rt_MatchTag.Resident ;  pointer to the above
    *rt_EndSkip.l  ;  address to continue scan
    rt_Flags.b  ;  various tag flags
    rt_Version.b  ;  release version number
    rt_Type.b  ;  type of module (NT_XXXXXX)
    rt_Pri.b  ;  initialization priority
    *rt_Name.b  ;  pointer to node name
    *rt_IdString.b ;  pointer to identification string
    *rt_Init.l  ;  pointer to init code
EndStructure

#RTC_MATCHWORD = $4AFC ;  The 68000 "ILLEGAL" instruction

#RTF_AUTOINIT = (1 << 7) ;  rt_Init points to data structure
#RTF_AFTERDOS = (1 << 2)
#RTF_SINGLETASK = (1 << 1)
#RTF_COLDSTART = (1 << 0)

;  Compatibility: (obsolete)
;  #define RTM_WHEN    3
#RTW_NEVER = 0
#RTW_COLDSTART = 1

