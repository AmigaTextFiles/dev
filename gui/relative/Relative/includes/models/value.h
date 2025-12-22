/**************************************************************************************************
**
** value.model
** © 1996-1997 Jeroen Massar
**
** Main Header File
**
***************************************************************************************************
** value.model Class Tree
***************************************************************************************************
**
**   modelclass				(AmigaOS modelclass)
**   +--value.model			(value.model)
**
***************************************************************************************************
** Supported SuperClass Methods/Attributes
***************************************************************************************************
** Unless stated all methods are passed to the superclass.
** AttrMan	OM_ATTRSTART
** rootclass	OM_NEW
**		OM_DISPOSE
**		OM_SET
**		OM_GET
** modelclass
**
***************************************************************************************************
** General Header File Information
***************************************************************************************************
**
** All class, method, value, macro and structure definitions follow these rules:
**
** Name				Meaning
**
** ValMM_<method>		Method.
** ValMP_<method>		Methods parameter structure.
** ValMV_<method>_<x>		Special method value.
** ValMA_<attrib>		Attribute.
** ValMV_<attrib>_<x>		Special attribute value.
**
** All definitions are followed by a comment containing the version
** which introduced that definition.
** Attribute definitions are followed by a comment
** consisting of the three possible letters I, S and G.
** I: it's possible to specify this attribute at object creation (init) time.
** S: it's possible to change this attribute with SetAttrs().
** G: it's possible to get this attribute with GetAttr().
**
** The BOOPSI value.model library uses the following structure as its base for the
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
#ifndef MODELS_VALUE_H
#define MODELS_VALUE_H

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
#include <intuition/icclass.h>
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
#define VALUEMODEL_NAME		"value.model"
#define VALUEMODEL_LIBPATH	"models/"
#define VALUEMODEL_VLATEST	40
#define VALUEMODEL_VMIN		VALUEMODEL_VLATEST

/**************************************************************************************************
** value.model
**************************************************************************************************/
/* Methods - No special methods except OM_AttrStart for AttrMan support (see AttrMan.h).*/

/* Attributes
** You should add AttrStart gotten from the OM_AttrStart method.
** When setting ValMA_Value out of the range of ValMA_Min/Max it will become ValMA_Min/Max.
*/
enum {	ValMA_Value=0,			/* V40 isg ULONG Current Value. Default=0 */
	ValMA_Min,			/* V40 isg ULONG Minimum Value. Default=0 */
	ValMA_Max,			/* V40 isg ULONG Maximum Value. Default=100 */
	ValMA_Step,			/* V40 isg ULONG Increment/Decrement Step-size. Default=1 */
	ValMA_Incr,			/* V40 .s. Increase by ValMA_Steps. */
	ValMA_Decr,			/* V40 .s. Decrease by ValMA_Steps. */
	ValMA_LastAttr,			/* LastAttribute (this value is used for allocating AttrMan attributes). */
	};

#endif /* MODELS_VALUE_H */
