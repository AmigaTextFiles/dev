;
; ** $VER: wbpattern.h 39.4 (11.6.92)
; ** Includes Release 40.15
; **
; ** File format for wbpattern preferences
; **
; ** (C) Copyright 1991-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
;

; ***************************************************************************

#ID_PTRN = $5054524E

; ***************************************************************************

Structure WBPatternPrefs

    wbp_Reserved.l[4]
    wbp_Which.w   ;  Which pattern is it
    wbp_Flags.w
    wbp_Revision.b   ;  Must be set to zero
    wbp_Depth.b   ;  Depth of pattern
    wbp_DataLength.w  ;  Length of following data
EndStructure

; ***************************************************************************

;  constants for WBPatternPrefs.wbp_Which
#WBP_ROOT = 0
#WBP_DRAWER = 1
#WBP_SCREEN = 2

;  wbp_Flags values
#WBPF_PATTERN = $0001
    ;  Data contains a pattern

#WBPF_NOREMAP = $0010
    ;  Don't remap the pattern

; ***************************************************************************

#MAXDEPTH = 3 ;   Max depth supported (8 colors)
#DEFPATDEPTH = 2 ;   Depth of default patterns

;   Pattern width & height:
#PAT_WIDTH = 16
#PAT_HEIGHT = 16

; ***************************************************************************

