;
; ** $VER: libraries.h 39.2 (10.4.92)
; ** Includes Release 40.15
; **
; ** Definitions for use when creating or using Exec libraries
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

XIncludeFile "exec/nodes.pb"


; ------ Special Constants ---------------------------------------
#LIB_VECTSIZE = 6 ;  Each library entry takes 6 bytes
#LIB_RESERVED = 4 ;  Exec reserves the first 4 vectors
#LIB_BASE = -#LIB_VECTSIZE
#LIB_USERDEF = (#LIB_BASE-(#LIB_RESERVED*#LIB_VECTSIZE))
#LIB_NONSTD = (#LIB_USERDEF)

; ------ Standard Functions --------------------------------------
#LIB_OPEN = (-6)
#LIB_CLOSE = (-12)
#LIB_EXPUNGE = (-18)
#LIB_EXTFUNC = (-24) ;  for future expansion


; ------ Library Base Structure ----------------------------------
;  Also used for Devices and some Resources

Structure Library
    lib_Node.Node
    lib_Flags.b
    lib_pad.b
    lib_NegSize.w     ;  number of bytes before library
    lib_PosSize.w     ;  number of bytes after library
    lib_Version.w     ;  major
    lib_Revision.w     ;  minor
    *lib_IdString.l   ;  ASCII identification
    lib_Sum.l      ;  the checksum itself
    lib_OpenCnt.w     ;  number of current opens
EndStructure

;  lib_Flags bit definitions (all others are system reserved)
#LIBF_SUMMING = (1 << 0)     ;  we are currently checksumming
#LIBF_CHANGED = (1 << 1)     ;  we have just changed the lib
#LIBF_SUMUSED = (1 << 2)     ;  set if we should bother to sum
#LIBF_DELEXP = (1 << 3)     ;  delayed expunge
