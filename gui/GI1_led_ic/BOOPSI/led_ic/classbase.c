/*****************************************************************************
 *
 * COPYRIGHT: Unless otherwise noted, all files are Copyright (c) 1992-1994
 * Commodore-Amiga, Inc. All rights reserved.
 *
 * DISCLAIMER: This software is provided "as is".  No representations or
 * warranties are made with respect to the accuracy, reliability,
 * performance, currentness, or operation of this software, and all use is at
 * your own risk. Neither Commodore nor the authors assume any responsibility
 * or liability whatsoever with respect to your use of this software.
 *
 *****************************************************************************
 * classbase.c
 * Class library initialization
 * Written by David N. Junod
 *
 */

#include <exec/types.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>

#include <clib/intuition_protos.h>

#include <pragmas/intuition_pragmas.h>

/*****************************************************************************/

#include "classbase.h"
#include "classdata.h"

/****** led.image/--datasheet-- ***********************************************
*
*    NAME
*       led.image--Simulated LED display image.                 (V42)
*
*    SUPERCLASS
*	imageclass
*
*    DESCRIPTION
*	The led.image image class provides a simulated LED image display.
*
*    METHODS
*	OM_NEW--Create the LED image.  Passed to superclass, then OM_SET.
*
*	OM_SET--Set object attributes.  Passed to superclass first.
*
*	OM_UPDATE--Set object notification attributes.  Passed to superclass
*	    first.
*
*	IM_DRAW--Renders the images.  Overrides the superclass.
*
*	All other methods are passed to the superclass, including OM_DISPOSE.
*
*    ATTRIBUTES
*	SYSIA_DrawInfo (struct DrawInfo *) -- Contains important pen
*	    information.  This is required if IA_BGPen and IA_FGPen are
*	    not specified.
*
*	IA_FGPen (LONG) -- Pen to use to draw the lit segments.  If -1
*	    is specified then TEXTPEN is used.
*
*	IA_BGPen (LONG) -- Pen to use to draw the unlit segments or
*	    background.  If -1 is specified then BACKGROUNDPEN is used.
*
*	IA_Width (LONG) -- Width of the image.
*
*	IA_Height (LONG) -- Height of the image.
*
*	LED_Pairs (LONG) -- Number of pairs of digits.
*
*	LED_Values (WORD *) -- Array of values.  One entry per pair
*	    is required.
*
*	LED_Colon (BOOL) -- Is the colon between pairs lit or not.
*	    Defaults to FALSE.
*
*	LED_Signed (BOOL) -- Leave room for a negative sign or
*	    not.  Defaults to FALSE.
*
*	LED_Negative (BOOL) -- Is the negative sign lit or not.
*	    Defaults to FALSE.
*
*******************************************************************************
*
* David N. Junod
*
*/

/*****************************************************************************/

VOID CallCHook(void);

/*****************************************************************************/

BOOL __asm CreateClass (register __a6 struct ClassLib *cb)
{
    Class *cl;

    if (cl = MakeClass ("led.image", IMAGECLASS, NULL, sizeof (struct objectData), 0))
    {
        cl->cl_Dispatcher.h_Entry    = (HOOKFUNC)CallCHook;
        cl->cl_Dispatcher.h_SubEntry = (HOOKFUNC)ClassDispatcher;
	cl->cl_Dispatcher.h_Data     = cb;
	cl->cl_UserData              = (ULONG) cb;
	AddClass (cl);
    }

    /* Set the class pointer */
    cb->cb_Library.cl_Class = cl;

    return (BOOL)(cl != NULL);
}


/*****************************************************************************/


BOOL __asm DestroyClass (register __a6 struct ClassLib *cb)
{
    BOOL result;

    if (result = FreeClass (cb->cb_Library.cl_Class))
	cb->cb_Library.cl_Class = NULL;

    return result;
}
