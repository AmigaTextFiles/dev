#INTUITION_CGHOOKS_H = 1
;
; **  $VER: cghooks.h 38.1 (11.11.91)
; **  Includes Release 40.15
; **
; **  Custom Gadget processing
; **
; **  (C) Copyright 1988-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

;IncludePath   "PureInclude:"
;XIncludeFile "intuition/intuition.pb"

;
;  * Package of information passed to custom and 'boopsi'
;  * gadget "hook" functions.  This structure is READ ONLY.
;
Structure GadgetInfo

    *gi_Screen.Screen
    *gi_Window.Window ;  null for screen gadgets
    *gi_Requester.Requester ;  null if not GTYP_REQGADGET

    ;  rendering information:
;      * don't use these without cloning/locking.
;      * Official way is to call ObtainRPort()
;
    *gi_RastPort.RastPort
    *gi_Layer.Layer

    ;  copy of dimensions of screen/window/g00/req(/group)
;      * that gadget resides in. Left/Top of this box is
;      * offset from window mouse coordinates to gadget coordinates
;      *  screen gadgets:   0,0 (from screen coords)
;      * window gadgets (no g00): 0,0
;      * GTYP_GZZGADGETs (borderlayer):  0,0
;      * GZZ innerlayer gadget:  borderleft, bordertop
;      * Requester gadgets:  reqleft, reqtop
;
    gi_Domain.IBox

    ;  these are the pens for the window or screen
     DetailPen.b
     BlockPen.b
    ;  the Detail and Block pens in gi_DrInfo->dri_Pens[] are
;      * for the screen. Use the above for window-sensitive
;      * colors.
;
    *gi_DrInfo.DrawInfo

    ;  reserved space: this structure is extensible
;      * anyway, but using these saves some recompilation
;
    gi_Reserved.l[6]
EndStructure

; ** system private data structure for now **
;  prop gadget extra info

Structure PGX
    pgx_Container.IBox
    pgx_NewKnob.IBox
EndStructure

;  this casts MutualExclude for easy assignment of a hook
;  * pointer to the unused MutualExclude field of a custom gadget
;
;#CUSTOM_HOOK( = gadget ) ( (*) (gadget)\MutualExclude).Hook
