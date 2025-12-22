;
; ** $VER: gfxnodes.h 39.0 (21.8.91)
; ** Includes Release 40.15
; **
; ** graphics extended node definintions
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/nodes.pb"

Structure ExtendedNode
*xln_Succ.Node
*xln_Pred.Node
xln_Type.b
xln_Pri.b
*xln_Name.b
xln_Subsystem.b
xln_Subtype.b
xln_Library.l
*xln_Init.l       ; Pointer to ASM Code
EndStructure

#SS_GRAPHICS = $02

#VIEW_EXTRA_TYPE  = 1
#VIEWPORT_EXTRA_TYPE = 2
#SPECIAL_MONITOR_TYPE = 3
#MONITOR_SPEC_TYPE = 4

