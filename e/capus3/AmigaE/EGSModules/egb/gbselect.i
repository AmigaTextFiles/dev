	IFND    EGS_EGB_GBSELECT_I
EGS_EGB_GBSELECT_I    SET     1
*\
*
*  $
*  $ FILE     : gbselect.i
*  $ VERSION  : 1
*  $ REVISION : 2
*  $ DATE     : 07-Feb-93 19:54
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
	INCLUDE "egs/egsintui.i"
	ENDC
	IFND    EGS_EGSGADBOX_I
	INCLUDE "egs/egsgadbox.i"
	ENDC

* DICE typedef workaround

 STRUCTURE  EGB_SelectGadgetStruct,0
	STRUCT  egsg_Gadget,eiga_SIZEOF
	WORD    egsg_Sel
	WORD    egsg_Selnum
	APTR    egsg_SelGfx
	LABEL   egsg_SIZEOF

	ENDC    *EGS_EGB_GBSELECT_I
