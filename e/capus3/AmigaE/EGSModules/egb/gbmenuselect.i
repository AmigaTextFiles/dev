	IFND    EGS_EGB_GBMENUSELECT_I
EGS_EGB_GBMENUSELECT_I  SET     1
*\
*
*  $
*  $ FILE     : gbmenuselect.i
*  $ VERSION  : 1
*  $ REVISION : 4
*  $ DATE     : 07-Feb-93 20:37
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

* Fix for DICE that has problems with typedef of structs

 STRUCTURE  EGB_MenuGadgetStruct,0
	STRUCT  egmg_Gadget,eiga_SIZEOF
	WORD    egmg_Sel
	WORD    egmg_Selnum
	APTR    egmg_SelGfx
	LABEL   egmg_SIZEOF

	ENDC * EGS_EGB_GBMENUSELECT_I
