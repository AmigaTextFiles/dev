/**************************************************************************************************
**
** relgroup.gadget
** © 1996-1997 Jeroen Massar
**
** Main Header File
**
***************************************************************************************************
** relgroup.gadget Class Tree
***************************************************************************************************
**
**   gadgetclass			(AmigaOS gadgetclass)
**   +--relgroup.gadget			(relgroup.gadget)
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
**		GM_DOMAIN			V40 For all which's Top=Height=0,
**						    MINIMUM==NOMINAL Calculated size of all children but
**						                     needs to exist or when
**						                     Disappear==TRUE Width=Height=0.
**						    MAXIMUM          Width=Height=~0.
**		GA_Disabled			V40 Disables(TRUE)/Enables(FALSE:default) group.
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
** RGrpM_<method>		Method.
** RGrpP_<method>		Methods parameter structure.
** RGrpV_<method>_<x>		Special method value.
** RGrpA_<attrib>		Attribute.
** RGrpV_<attrib>_<x>		Special attribute value.
**
** All definitions are followed by a comment containing the version
** which introduced that definition.
** Attribute definitions are followed by a comment
** consisting of the three possible letters I, S and G.
** I: it's possible to specify this attribute at object creation (init) time.
** S: it's possible to change this attribute with SetAttrs().
** G: it's possible to get this attribute with GetAttr().
**
** The BOOPSI relgroup.gadget library uses the following structure as its base for the
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
#ifndef GADGETS_RELGROUP_H
#define GADGETS_RELGROUP_H

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
#define RELGROUPGADGET_NAME	"relgroup.gadget"
#define RELGROUPGADGET_LIBPATH	"gadgets/"
#define RELGROUPGADGET_VLATEST	40
#define RELGROUPGADGET_VMIN	RELGROUPGADGET_VLATEST

/**************************************************************************************************
** relgroup.gadget
**************************************************************************************************/
/* Methods - No special methods except OM_AttrStart for AttrMan support (see AttrMan.h).*/

/* Attributes
** You should add AttrStart gotten from the OM_AttrStart method.
** You must set these values with SetGadgetAttrs() otherwise there
** will be no visual refresh when you set something which needs refreshing.
*/
enum {	RGrpA_Child=0,			/* V40 i.. struct Gadget *ChildGadget.
								There should be at least one child. */
	RGrpA_Orientation,		/* V40 isg ULONG	Orientation of the gadgets.
								See specials below.
								Defaults to RGrpV_Orientation_Default. */
	RGrpA_Columns,			/* V40 i.g ULONG	Number of columns in the group. */
	RGrpA_Rows,			/* V40 i.g ULONG	Number of rows in the group. */
	RGrpA_Disappear,		/* V40 i.g BOOL		This group may disappear when domain
								is to small. Defaults to FALSE. */
	RGrpA_Frame,			/* V40 isg struct Image*(BOOPSI)Frame-image or special value.
								Defaults to RGrpV_Frame_Default. */
	RGrpA_Weight,			/* V40 i.. ULONG	Weight Factor or a special value.
								Defaults to RGrpV_Weight_Average. */

	RGrpA_LastAttr,			/* LastAttribute (this value is used for allocating AttrMan attributes). */
	};

/* Special Values - Don't use AttrStart. */
/* Orientation is only used when nor Columns nor Rows is set at init. */
enum {	RGrpV_Orientation_Default=0,	/* V40 Gadgets are placed in a block. (eg. 9 gads => 3 by 3) */
	RGrpV_Orientation_Horizontal,	/* V40 Gadgets are placed horizontaly (side by side). */
	RGrpV_Orientation_Vertical,	/* V40 Gadgets are placed verticaly (above each other). */
	RGrpV_Orientation_User,		/* V40 Gadgets are placed in a block sized columns by rows.
					       You must set the RGrpA_Columns and RGrpA_Rows to 1+
					       or this will default to RGrpV_Orientation_Default! */
	};

enum {	RGrpV_Frame_Default=-1,		/* V40 Use default frame (chosen by prefs program). */
	RGrpV_Frame_None=0,		/* V40 Don't show a frame around the group. */
	};

/*
** When a weight is set it is used for all children succeeding
** that weight until a new weight is set.
*/
enum {	RGrpV_Weight_NoReSize=-3,	/* V40 Don't resize. */
	RGrpV_Weight_NoYReSize,		/* V40 Don't Y-resize (handy for stringgadgets etc). */
	RGrpV_Weight_NoXReSize,		/* V40 Don't X-resize. */
	RGrpV_Weight_Average,		/* V40 Use a avarage weight calculated from the other weights. */
	};

#endif /* GADGETS_RELGROUP_H */
