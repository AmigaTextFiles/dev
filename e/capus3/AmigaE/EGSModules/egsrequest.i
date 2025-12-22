    IFND    EGS_EGSREQUEST_I
EGS_EGSREQUEST_I       SET     1
*\
*  $
*  $ FILE     : egsrequest.i
*  $ VERSION  : 1
*  $ REVISION : 2
*  $ DATE     : 07-Feb-93 18:25
*  $
*  $ Author   : mvk
*  $
*
*
* (c) Copyright 1990/93 VIONA Development
*     All Rights Reserved
*
*\
    IFND    EXEC_TYPES_I
    INCLUDE "exec/types.i"
    ENDC
    IFND    EGS_EGSINTUI_I
    INCLUDE "egsintui.i"
    ENDC
    IFND    EGS_EGSGADBOX_I
    INCLUDE "egsgadbox.i"
    ENDC
    IFND    EGS_EGB_GBSCROLLBOX_I
    INCLUDE "egb/gbscrollbox.i"
    ENDC

ER_USER_GADID_MIN        EQU     $100000
ER_USER_GADID_MAX        EQU     $1FFFFF
ER_REQ_OK                EQU     0
ER_REQ_FINISHED          EQU     1
ER_NO_REQWINDOW          EQU     2
ER_REQ_CANCELED          EQU     3
ER_AUTO_CLOSE            EQU     $0000001

 STRUCTURE  ERReqContext,0
    APTR    errc_First
    APTR    errc_Last
    LABEL   errc_SIZEOF

 STRUCTURE  ERRequest,0
    APTR    erre_ObjectKey
    LONG    erre_Type
    APTR    erre_Context
    APTR    erre_Next
    APTR    erre_Prev
    UBYTE   erre_Error
    UBYTE   erre_Pad0
    UWORD   erre_Pad1
    APTR    erre_UserData
    STRUCT  erre_Private1,4*6
    APTR    erre_Private2
    APTR    erre_Nw
    APTR    erre_Con
    APTR    erre_Root
    APTR    erre_Menu
    APTR    erre_Title
    APTR    erre_Port
    APTR    erre_Screen
    APTR    erre_RWindow
    ULONG   erre_Flags
    STRUCT  erre_Private3,4*8
    LABEL   erre_SIZEOF

 STRUCTURE  ERTextList,0
    STRUCT  ertl_List,LH_SIZE
    UWORD   ertl_Pad
    APTR    ertl_Con
    LABEL   ertl_SIZEOF

 STRUCTURE  ERFileRequest,0
    STRUCT  erfr_Req,erre_SIZEOF
    UWORD   erfr_NameLen
    STRUCT  erfr_Name,32
    UWORD   erfr_Pad1
    UWORD   erfr_PathLen
    STRUCT  erfr_Path,100
    UWORD   erfr_Pad2
    UWORD   erfr_PattLen
    STRUCT  erfr_Pattern,100
    UWORD   erfr_Pad3
    STRUCT  erfr_Fnumbox,ebib_SIZEOF
    STRUCT  erfr_Dnumbox,ebib_SIZEOF
    STRUCT  erfr_Files,ertl_SIZEOF
    STRUCT  erfr_Volumes,ertl_SIZEOF
    APTR    erfr_FileGad
    APTR    erfr_VolGad
    APTR    erfr_PathGad
    APTR    erfr_NameGad
    APTR    erfr_PattGad
    UWORD   erfr_OnameLen
    STRUCT  erfr_Oname,32
    UWORD   erfr_Pad4
    UWORD   erfr_OPathLen
    STRUCT  erfr_OPath,100
    UWORD   erfr_Pad5
    UWORD   erfr_OPattLen
    STRUCT  erfr_OPattern,100
    UWORD   erfr_Pad7
    APTR    erfr_OldFile
    UBYTE   erfr_CursLeft
    UBYTE   erfr_Pad8
    UWORD   erfr_Pad9
    APTR    erfr_LeftCurs
    APTR    erfr_RightCurs
    LABEL   erfr_SIZEOF

 STRUCTURE  ERSimpleRequest,0
    STRUCT  ersr_Req,erre_SIZEOF
    APTR    ersr_Texts
    APTR    ersr_Selects
    WORD    ersr_Selected
    WORD    ersr_Pad0
    LABEL   ersr_SIZEOF

    ENDC    * EGS_EGSREQUEST_H

