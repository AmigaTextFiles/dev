        IFND    GADTOOLSBOX_TEXTCLASS_I
GADTOOLSBOX_TEXTCLASS_I SET     1
**
**      $Filename: textclass.i $
**      $Release: 1.0 $
**      $Revision: 38.5 $
**
**      Definitions for the TEXT BOOPSI class.
**
**      (C) Copyright 1992 Jaba Development.
**          Written by Jan van den Baard
**
        IFND    EXEC_TYPES_I
        include "exec/types.i"
        ENDC

        IFND    UTILITY_TAGITEM_I
        include "utility/tagitem.i"
        ENDC

** tags for the text class system
TX_TagBase              EQU     TAG_USER+$01

TX_TextAttr             EQU     TX_TagBase+1
TX_Style                EQU     TX_TagBase+2
TX_ForceTextPen         EQU     TX_TagBase+3
TX_Underscore           EQU     TX_TagBase+4
TX_Flags                EQU     TX_TagBase+5
TX_Text                 EQU     TX_TagBase+6
TX_NoBox                EQU     TX_TagBase+7

        ENDC
