#ifndef EGS_EGB_GBSCROLLBOX_H
#define EGS_EGB_GBSCROLLBOX_H

/***************************************************************************\
*
*  $
*  $ FILE     : gbscrollbox.h
*  $ VERSION  : 1
*  $ REVISION : 4
*  $ DATE     : 07-Feb-93 20:59
*  $
*  $ Author   : mvk
*  $
*
*****************************************************************************
*                                                                           *
* (c) Copyright 1990/93 VIONA Development                                   *
*     All Rights Reserved                                                   *
*                                                                           *
\***************************************************************************/

#ifndef         EXEC_TYPES_H
#include        <exec/types.h>
#endif
#ifndef         EGS_EGSINTUI_H
#include        <egs/egsintui.h>
#endif
#ifndef         EGS_EGSGADBOX_H
#include        <egs/egsgadbox.h>
#endif
#ifndef         EGS_EGSGFX_H
#include        <egs/egsgfx.h>
#endif

typedef struct EGB_ScrollGadgetStruct *EGB_ScrollGadPtr;

struct EGB_ScrollGadgetStruct {
	 struct EI_MasterGadget Master;
	 WORD                   PixWidth, PixHeight, Width, Height;
	 EB_SPropGadPtr         Scroller;
	 struct List            List;
	 UWORD                  Pad0;
	 struct Node           *ActText, *TopText;
	 EG_EFontPtr            EFontPtr;
	 EI_GadgetPtr           Selects;
	 UBYTE                  Sort;
	 UBYTE                  Pad1;
	 UWORD                  Pad2;
	 EI_StringGadPtr        String;
};

#endif /* EGS_EGB_GBSCROLLBOX_H */

