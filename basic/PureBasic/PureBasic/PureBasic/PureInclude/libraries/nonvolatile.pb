
;
; ** $VER: nonvolatile.h 40.8 (30.7.93)
; ** Includes Release 40.15
; **
; ** nonvolatile.library interface structures and defintions.
; **
; ** (C) Copyright 1992-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
;

; ***************************************************************************


IncludePath   "PureInclude:"
XIncludeFile "exec/types.pb"
XIncludeFile "exec/nodes.pb"

; ***************************************************************************


Structure NVInfo
    nvi_MaxStorage.l
    nvi_FreeStorage.l
EndStructure


; ***************************************************************************


Structure NVEntry

    nve_Node.MinNode
    *nve_Name.b
    nve_Size.l
    nve_Protection.l
EndStructure

;  bit definitions for mask in SetNVProtection().  Also used for
;  * NVEntry.nve_Protection.
;
#NVEB_DELETE  = 0
#NVEB_APPNAME = 31

#NVEF_DELETE  = (1 << #NVEB_DELETE)
#NVEF_APPNAME = (1 << #NVEB_APPNAME)


; ***************************************************************************


;  errors from StoreNV()
#NVERR_BADNAME = 1
#NVERR_WRITEPROT = 2
#NVERR_FAIL = 3
#NVERR_FATAL = 4


; ***************************************************************************


;  determine the size of data returned by this library
;#SizeNVData(DataPtr) = ((((*) .l


; ***************************************************************************


