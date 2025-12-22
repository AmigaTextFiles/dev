	IFND    EGS_EGB_GBSCROLLBOX_I
EGS_EGB_GBSCROLLBOX_I EQU     1
*\
*
*  $
*  $ FILE     : gbscrollbox.i
*  $ VERSION  : 1
*  $ REVISION : 5
*  $ DATE     : 07-Feb-93 20:58
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
	IFND    EGS_EGSGFX_I
	INCLUDE "egs/egsgfx.i"
	ENDC

 STRUCTURE  EGB_ScrollGadgetStruct,0
	STRUCT  egbg_Master,eimg_SIZEOF
	WORD    egbg_PixWidth
	WORD    egbg_PixHeight
	WORD    egbg_Width
	WORD    egbg_Height
	APTR    egbg_Scroller
	STRUCT  egbg_List,LH_SIZE
	UWORD   egbg_Pad0
	APTR    egbg_ActText
	APTR    egbg_TopText
	APTR    egbg_EFontPtr
	APTR    egbg_Selects
	UBYTE   egbg_Sort
	UBYTE   egbg_Pad1
	UWORD   egbg_Pad2
	APTR    egbg_String
	LABEL   egbg_SIZEOF

	ENDC    * EGS_EGB_GBSCROLLBOX_H

