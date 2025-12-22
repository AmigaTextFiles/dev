/**************************************************************************************************
**
** relbutton.gadget
** © 1996-1997 Jeroen Massar
**
** Main Header File
**
** Requires AmigaOS v39+ (Kickstart 3.0+)
**
***************************************************************************************************
** Group Class Tree
***************************************************************************************************
**
**   gadgetclass			(AmigaOS gadgetclass)
**   +--relbutton.gadget		(relbutton.gadget)
**
***************************************************************************************************
** Supported (SuperClass) Methods/Attributes
***************************************************************************************************
** (Methods not stated here are passed to the superclass.
** AttrMan	OM_ATTRSTART			v40 /* Should/Can be used as classlibrary method. */
** rootclass	OM_NEW				v40
**		OM_DISPOSE			v40
**		OM_SET				v40
**		OM_GET				v40
**		OM_UPDATE			v40 (Same as OM_SET)
** gadgetclass	GM_HITTEST			v40
**		GM_RENDER			v40
**		GM_GOACTIVE			v40
**		GM_HANDLEINPUT			v40
**		GM_GOINACTIVE			v40
**		GM_HELPTEST			v40
**		GM_LAYOUT			v40
**		GM_DOMAIN			v40
**		GA_Disabled			v40 isg BOOL Disabled(TRUE)/Enabled   (FALSE)-default.
**		GA_Selected			v40 isg BOOL Selected(TRUE)/UnSelected(FALSE)-default.
**		GA_ToggleSelect			v40 isg BOOL Toggled (TRUE)/HitSelect (FALSE)-default.
**		GA_TabCycle			v40 When TRUE gets activated when tab-cycle reaches gad.
**		GA_GadgetHelp			v40 When TRUE sends help messages when help is pressed
**						    and the pointer is over the gadget.
**		GA_TextAttr			v?? Font for Label.
**		GA_ReadOnly			v40 ReadOnly(TRUE)/Selectable(FALSE)-default.
**		GA_Bounds			v40 isg struct IBox *
**		GA_RelSpecial			v40 Set to TRUE.
**
***************************************************************************************************
** General Header File Information
***************************************************************************************************
**
** All class, method, value, macro and structure definitions follow these rules:
**
** Name				Meaning
**
** RButM_<method>		Method.
** RButP_<method>		Methods parameter structure.
** RButV_<method>_<x>		Special method value.
** RButA_<attrib>		Attribute (add AttrMan's AttrStart to it!).
** RButV_<attrib>_<x>		Special attribute value.
**
** All definitions are followed by a comment containing the version
** which introduced that definition.
** RButA_... attribute definitions are followed by a comment
** consisting of the three possible letters I, S and G.
** I: it's possible to specify this attribute at object creation (init) time.
** S: it's possible to change this attribute with SetAttrs().
** G: it's possible to get this attribute with GetAttr().
**
** The BOOPSI relbutton.gadget library uses the following structure as its base for the
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
#ifndef GADGETS_RELBUTTON_H
#define GADGETS_RELBUTTON_H

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
#define RELBUTTONGADGET_NAME	"relbutton.gadget"
#define RELBUTTONGADGET_LIBPATH	"gadgets/"
#define RELBUTTONGADGET_VLATEST	40
#define RELBUTTONGADGET_VMIN	RELBUTTONGADGET_VLATEST

/**************************************************************************************************
** relbutton.gadget
**************************************************************************************************/
/* Methods - No special methods except OM_AttrStart for AttrMan support.*/

/* Attributes
** You should add AttrStart gotten from the OM_AttrStart method.
** You must set these values with SetGadgetAttrs() or there
** will be no visual refresh when an attribute needs refreshing.
*/
enum {	RButA_Label=0,			/* V40 isg STRPTR	Label in the gadget. Defaults to NULL. */
	RButA_LabelSel,			/* V40 isg STRPTR	Selected label in the gadget. Defaults to NULL. */
	RButA_Frame,			/* V40 isg struct Image*(BOOPSI)Frame-image or specials.
								Defaults to RButV_Frame_Default. */
	RButA_LastAttr,			/* LastAttribute (this value is used for allocating AttrMan attributes). */
	};

/* Special Values - Don't use AttrStart. */
enum {	RButV_Frame_Default=-1,		/* V40 Use default frame (chosen by prefs program). */
	RButV_Frame_None=0,		/* V40 Don't show a frame around the gadget. */
	};

#endif /* GADGETS_RELBUTTON_H */
