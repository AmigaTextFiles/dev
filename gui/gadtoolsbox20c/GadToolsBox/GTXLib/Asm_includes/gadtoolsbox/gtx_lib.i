        IFND    GADTOOLSBOX_GTX_LIB_I
GADTOOLSBOX_GTX_LIB_I   SET 1
**
**      $Filename: gadtoolsbox/gtx_lib.i $
**      $Release: 1.0 $
**      $Revision: 38.1 $
**
**      Library Vector Offset table for the gadtoolsbox.library.
**
**      (C) Copyright 1992-1993 Jaba Development.
**          Written by Jan van den Baard
**
        IFND    EXEC_TYPES_I
        include "exec/types.i"
        ENDC

        IFND    EXEC_NODES_I
        include "exec/nodes.i"
        ENDC

        IFND    EXEC_LISTS_I
        include "exec/lists.i"
        ENDC

        IFND    EXEC_LIBRARIES_I
        include "exec/libraries.i"
        ENDC

        LIBINIT

        LIBDEF  GTX_TagInArray
        LIBDEF  GTX_SetTagData
        LIBDEF  GTX_GetNode
        LIBDEF  GTX_GetNodeNumber
        LIBDEF  GTX_CountNodes
        LIBDEF  GTX_MoveNode
        LIBDEF  GTX_IFFErrToStr
        LIBDEF  GTX_GetHandleA
        LIBDEF  GTX_FreeHandle
        LIBDEF  GTX_RefreshWindow
        LIBDEF  GTX_CreateGadgetA
        LIBDEF  GTX_RawToVanilla
        LIBDEF  GTX_GetIMsg
        LIBDEF  GTX_ReplyIMsg
        LIBDEF  GTX_SetGadgetAttrsA
        LIBDEF  GTX_DetachLabels
        LIBDEF  GTX_DrawBox
        LIBDEF  GTX_InitTextClass
        LIBDEF  GTX_InitGetFileClass
        LIBDEF  GTX_SetHandleAttrsA
        LIBDEF  GTX_BeginRefresh
        LIBDEF  GTX_EndRefresh
        LIBDEF  Private0
        LIBDEF  Private1
        LIBDEF  Private2
        LIBDEF  Private3
        LIBDEF  Private4
        LIBDEF  Private5
        LIBDEF  Private6
        LIBDEF  Private7
        LIBDEF  Private8
        LIBDEF  Private9
        LIBDEF  Private10
        LIBDEF  GTX_FreeWindows
        LIBDEF  GTX_LoadGUIA
        LIBDEF  Private11
        LIBDEF  Private12
        LIBDEF  Private13
        LIBDEF  Private14
        LIBDEF  Private15

        ENDC
