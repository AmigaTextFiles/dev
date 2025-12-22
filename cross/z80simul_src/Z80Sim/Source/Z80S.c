/****h* Z80Simulator/Z80s.c [2.5] ***************************************
*
* NAME
*    Z80S.c
*
* DESCRIPTION
*    Some Global support functions & variables for the Z80 Simulator.
*
*    The current function(s) that are VISIBLE to other 
*    source files in the Z80Simulator project:
* 
*    VISIBLE void SetGText( struct Gadget *tg, STRPTR text,
*                           struct Window *w, int type 
*                         );
*
*************************************************************************
*
*/


#include <AmigaDOSErrs.h>

#include <exec/types.h>

#include <intuition/intuitionbase.h>

#include <libraries/GadTools.h>

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>


#include "CPGM:GlobalObjects/CommonFuncs.h"
 
/****i* Z80S.c/SetGText() [2.0] ************************************* 
*
* NAME 
*   SetGText - Currently NOT used.
*
* SYNOPSIS
*   void SetGText( struct Gadget *tg, STRPTR text, struct Window *w,
*                  int type
*                );
*
* FUNCTION
*   Set a GadTools Gadget to the supplied text.
*
* INPUTS
*   'tg'   - The gadget to set.
*   'text' - The text string. 
*   'w'    - The window the gadget is in.
*   'type' - The type of the gadget.
*
*********************************************************************
*
*/

VISIBLE void SetGText( struct Gadget *tg, STRPTR text, 
                       struct Window *w,  int type
                     )
{
   switch (type)
      {
      case STRING_KIND:
         GT_SetGadgetAttrs( tg, w, NULL, GTST_String, text, TAG_END );
         break;

      case TEXT_KIND:
         GT_SetGadgetAttrs( tg, w, NULL, GTTX_Text, text, TAG_END );
         break;

      default:
         break;
      }

   return;
}

/****i* Z80S.c/match() [1.0] **************************************** 
*
* NAME 
*   match - Currently NOT needed.
*
* SYNOPSIS
*   Boolean = match( char *str1, char *str2 )
*
* FUNCTION
*   Return 0 if str1 & str2 are identical, 1 otherwise.
*
* INPUTS
*   'str1' - first string to match.
*   'str2' - second string to match.
*
*********************************************************************
*
*/

PRIVATE int match( char *str1, char *str2 )
{
   int index;

   for (index = 0; *(str1 + index) == *(str2 + index); index++)
      {
      if (*(str2 + index + 1) == '\0')
         return( 0 );                    // strings match!
      }

   return( 1 );
}

/* ---------------------- End of Z80S.c ------------------------- */
