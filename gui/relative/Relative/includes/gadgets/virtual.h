/**************************************************************************************************
**
** virtual.gadget
** © 1996-1997 Jeroen Massar
**
** Main Header File
**
***************************************************************************************************
** virtual.gadget Class Tree
***************************************************************************************************
**
**   gadgetclass			(AmigaOS gadgetclass)
**   +--virtual.gadget			(virtual.gadget)
**
***************************************************************************************************
** Supported SuperClass Methods/Attributes
***************************************************************************************************
** Methods not stated here are passed to the superclass.
** AttrMan	OM_ATTRSTART
** rootclass	OM_NEW
**		OM_DISPOSE
**		OM_SET
**		OM_GET
** gadgetclass	GM_RENDER			V40 Renders self and then passes it to the superclass.
**		GM_LAYOUT			V40 Lays out self and then lays out the children.
**		GM_DOMAIN			V40 Asks the child it domain and calcs it.
**		GA_Disabled			V40 Disables(TRUE)/Enables(FALSE:default) virtual gadget.
**		GA_Highlight			V40 ... GFLG_GADGHNONE.
**		GA_RelSpecial			V40 ... TRUE.
**
***************************************************************************************************
** General Header File Information
***************************************************************************************************
**
** All class, method, value, macro and structure definitions follow these rules:
**
** Name				Meaning
**
** VirtM_<method>		Method.
** VirtP_<method>		Methods parameter structure.
** VirtV_<method>_<x>		Special method value.
** VirtA_<attrib>		Attribute.
** VirtV_<attrib>_<x>		Special attribute value.
**
** All definitions are followed by a comment containing the version
** which introduced that definition.
** Attribute definitions are followed by a comment
** consisting of the three possible letters I, S and G.
** I: it's possible to specify this attribute at object creation (init) time.
** S: it's possible to change this attribute with SetAttrs().
** G: it's possible to get this attribute with GetAttr().
**
** The BOOPSI virtual.gadget library uses the following structure as its base for the
** library data.  This allows developers to obtain the class pointer for
** performing object-less inquiries (As specified in the v42 classes.h/i).
**	struct ClassLibrary
**	{
**		struct Library	 cl_Lib;	/* Embedded library */
**		UWORD		 cl_Pad;	/* Align the structure */
**		Class		*cl_Class;	/* Class pointer */
**		/* Private data, has changed, is changing and will continue to change. */
**	};
**
**************************************************************************************************/
#ifndef GADGETS_VIRTUAL_H
#define GADGETS_VIRTUAL_H

/* Compiler specific stuff */

#ifdef _DCC

#define REG(x) __ ## x
#define ASM
#define SAVEDS __geta4

#else

#define REG(x) register __ ## x

#if defined __MAXON__ || defined __GNUC__
#define ASM
#define SAVEDS
#else
#define ASM    __asm
#define SAVEDS __saveds
#endif /* if defined ... */


#ifdef __SASC
#include <pragmas/exec_sysbase_pragmas.h>
#else
#ifndef __GNUC__
#include <pragmas/exec_pragmas.h>
#endif /* ifndef __GNUC__ */
#endif /* ifdef SASC      */

#ifndef __GNUC__

#include <pragmas/dos_pragmas.h>
#include <pragmas/icon_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/utility_pragmas.h>
#include <pragmas/asl_pragmas.h>
#include <pragmas/reqtools.h>
#include <pragmas/timer_pragmas.h>
#include <pragmas/commodities_pragmas.h>

#endif /* ifndef __GNUC__ */

#endif /* ifdef _DCC */

/* System */
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/exec.h>
#include <exec/devices.h>
#include <exec/io.h>
#include <dos/dos.h>
#include <dos/dostags.h>
#include <graphics/gfxmacros.h>
#include <workbench/workbench.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <libraries/gadtools.h>
#include <libraries/reqtools.h>
#include <devices/timer.h>
#include <libraries/commodities.h>

/* Prototypes */
#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/icon_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/utility_protos.h>
#include <clib/timer_protos.h>
#include <clib/asl_protos.h>
#include <clib/reqtools_protos.h>
#include <clib/commodities_protos.h>

/* ANSI C */
#include <stdlib.h>
#include <stdio.h>

/* AttrMan */
#include <AttrMan.h>

/**************************************************************************************************
** Library specification
**************************************************************************************************/
#define VIRTUALGADGET_NAME	"virtual.gadget"
#define VIRTUALGADGET_LIBPATH	"gadgets/"
#define VIRTUALGADGET_VLATEST	40
#define VIRTUALGADGET_VMIN	VIRTUALGADGET_VLATEST

/**************************************************************************************************
** virtual.gadget
**************************************************************************************************/
/* Methods - No special methods except OM_AttrStart for AttrMan support (see AttrMan.h).*/

/* Attributes
** You should add AttrStart gotten from the OM_AttrStart method.
** You must set these values with SetGadgetAttrs() otherwise there
** will be no visual refresh when you set something which needs refreshing.
*/
enum {	VirtA_ChildGadget=0,		/* V40 i.g struct Gadget *ChildGadget.*/
	VirtA_ChildImage,		/* V40 i.g struct Image *ChildImage. */
	VirtA_Virtual,			/* V40 i.g ULONG	VirtV_Virtual_On/Off/Always */
	/* Virtual.gadget requires one ChildGadget _OR_ one ChildImage.
	   If you want more than one child use relgroup.gadget as the
	   child and give it the children you want!

	   The following works just like an propgclass object
	   but with horizontal&vertical freedom and a child.
		PGA_Total	-> VirtA_TotalWidth & VirtA_TotalHeight
		PGA_Visible	-> VirtA_VisibleWidth & VirtA_VisibleWidth
		PGA_Top		-> VirtA_Left & VirtA_Top */
	VirtA_TotalWidth,		/* V40 ..g ULONG	Total Width   (in pixels). */
	VirtA_TotalHeight,		/* V40 ..g ULONG	Total Height  (in pixels). */
	VirtA_VisualWidth,		/* V40 ..g ULONG	Visual Width  (in pixels). */
	VirtA_VisualHeight,		/* V40 ..g ULONG	Visual Height (in pixels). */
	VirtA_Left,			/* V40 .sg ULONG	Left          (in pixels). */
	VirtA_Top,			/* V40 .sg ULONG	Top           (in pixels). */
	VirtA_Frame,			/* V40 isg struct Image*(BOOPSI)Frame-image or special value.
								Defaults to VirtV_Frame_Default. */
	VirtA_LastAttr,			/* LastAttribute (this value is used for allocating AttrMan attributes). */
	};

/* Special Values - Don't use AttrStart. */
enum {	VirtV_Frame_Default=-1,		/* V40 Use default frame (IA_FrameType,FRAME_??? copied from
					   Taglist or defaults to FRAME_RIDGE. */
	VirtV_Frame_None=0,		/* V40 Don't show a frame around the group. */
	};

enum {	VirtV_Virtual_Off=0,		/* V40 Group is in normal mode. */
	VirtV_Virtual_On,		/* V40 Group is in Virtual mode. */
	VirtV_Virtual_Always,		/* V40 Group is always in Virtual mode. */
	/* 1) Needless to say that VirtV_Virtual_Never isn't defined/required
	      as you wouldn't need this class then.
	   2) The VirtV_Virtual_Off/On automaticaly switches when being layed out
	      and little or enough space is available.
	   3) It's possible to compare with TRUE (On/Always) and FALSE (Off). */
	};

#endif /* GADGETS_VIRTUAL_H */
