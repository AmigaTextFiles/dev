	IFND    EGS_EGB_GBRADIO_I
EGS_EGB_GBRADIO_I  SET     1
*\
*  $
*  $ FILE     : gbradio.i
*  $ VERSION  : 1
*  $ REVISION : 2
*  $ DATE     : 07-Feb-93 19:57
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

EGB_NoneSelected  EQU     -1

 STRUCTURE  EGB_RadioGadgetStruct,0
	STRUCT  egrg_Master,eimg_SIZEOF
	WORD    egrg_Selected
	WORD    egrg_Pad
	APTR    egrg_SelGad
	LABEL   egrg_SIZEOF

	ENDC * EGS_EGB_GBRADIO_I
