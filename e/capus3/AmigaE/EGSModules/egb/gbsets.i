	IFND    EGS_EGB_GBSETS_I
EGS_EGB_GBSETS_I   SET     1
*\
*
*  $
*  $ FILE     : gbsets.i
*  $ VERSION  : 1
*  $ REVISION : 2
*  $ DATE     : 07-Feb-93 19:58
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

 STRUCTURE  EGB_SetGadgetStruct,0
	STRUCT  egeg_Master,eimg_SIZEOF
	LONG    egeg_Data
	LABEL   egeg_SIZEOF

	ENDC  *EGS_EGB_GBSETS_I
