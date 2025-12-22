    IFND    EGS_EGB_GBTEXTINFO_I
EGS_EGB_GBTEXTINFO_I       SET     1
*\
*
*  $
*  $ FILE     : gbtextinfo.i
*  $ VERSION  : 1
*  $ REVISION : 2
*  $ DATE     : 07-Feb-93 19:51
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
    INCLUDE "//egsintui.i"
    ENDC
    IFND    EGS_EGSGADBOX_I
    INCLUDE "//egsgadbox.i"
    ENDC

 STRUCTURE  EGBTextInfoGadgetStruct,0
    STRUCT  egtg_Master,eimg_SIZEOF
    APTR    egtg_Prop
    APTR    egtg_Text
    APTR    egtg_LineDisp
    WORD    egtg_Lines
    WORD    egtg_CHeight
    STRUCT  egtg_Res,ebrb_SIZEOF
    WORD    egtg_X
    WORD    egtg_Y
    WORD    egtg_W
    WORD    egtg_Pad
    APTR    egtg_Font
    APTR    egtg_Con
    LABEL   egtg_SIZEOF

    ENDC    * EGS_EGB_GBTEXTINFO_I
