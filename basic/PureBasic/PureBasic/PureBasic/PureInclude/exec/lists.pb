;
; ** $VER: lists.h 39.0 (15.10.91)
; ** Includes Release 40.15
; **
; ** Definitions and macros for use with Exec lists
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/nodes.pb"

;
;  *  Full featured list header.
;
Structure List
   *lh_Head.Node
   *lh_Tail.Node
   *lh_TailPred.Node
   lh_Type.b
   l_pad.b
EndStructure ;  word aligned

;
;  * Minimal List Header - no type checking
;
Structure MinList
   *mlh_Head.MinNode
   *mlh_Tail.MinNode
   *mlh_TailPred.MinNode
EndStructure ;  longword aligned
