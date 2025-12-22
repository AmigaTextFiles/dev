;
; ** $VER: utility.h 39.2 (18.9.92)
; ** Includes Release 40.15
; **
; ** utility.library include file
; **
; ** (C) Copyright 1992-1993 Commodore-Amiga Inc.
; ** All Rights Reserved
;

; ***************************************************************************

IncludePath   "PureInclude:"
XIncludeFile "exec/libraries.pb"


; ***************************************************************************

Structure UtilityBase
    ub_LibNode.Library
    ub_Language.b
    ub_Reserved.b
EndStructure

; ***************************************************************************


