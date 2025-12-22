        IFND    GADTOOLSBOX_HOTKEY_I
GADTOOLSBOX_HOTKEY_I    SET     1
**
**      $Filename: hotkey.i $
**      $Release: 1.0 $
**      $Revision: 38.5 $
**
**      Definitions for the hotkey system.
**
**      (C) Copyright 1992 Jaba Development.
**          Written by Jan van den Baard
**
        IFND    EXEC_TYPES_I
        include "exec/types.i"
        ENDC

        IFND    LIBRARIES_GADTOOLS_I
        include "libraries/gadtools.i"
        ENDC

** Flags for the HKH_SetRepeat tag.
        BITDEF              SR,MX,0
        BITDEF              SR,CYCLE,1
        BITDEF              SR,SLIDER,2
        BITDEF              SR,SCROLLER,3
        BITDEF              SR,LISTVIEW,4
        BITDEF              SR,PALETTE,5

** Tags for the hotkey system.
HKH_TagBase                 EQU     TAG_USER+256

HKH_KeyMap                  EQU     HKH_TagBase+1
HKH_UseNewButton            EQU     HKH_TagBase+2
HKH_NewText                 EQU     HKH_TagBase+3
HKH_SetRepeat               EQU     HKH_TagBase+4

        ENDC
