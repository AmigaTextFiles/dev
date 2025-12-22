/****************************************************************************

$RCSfile: guienvsupport.h $

$Revision: 1.3 $
    $Date: 1994/09/14 20:01:05 $

    Some needful extra definitions and functions for GUIEnvironment

    SAS/C V6.51

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany


****************************************************************************/

#ifndef LIBRARIES_GUIENVSUPP_H
#define LIBRARIES_GUIENVSUPP_H TRUE

#include <graphics/displayinfo.h>
#include <libraries/gadtools.h>
#include <utility/hooks.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <string.h>

#include "guienv.h"

/* -------------- screen support: displayIDs ----------------------------- */

#define GES_HiresPalID  (HIRES_KEY + PAL_MONITOR_ID)
#define GES_HiresID     (HIRES_KEY + DEFAULT_MONITOR_ID)
#define GES_LoresPalID  (LORES_KEY + PAL_MONITOR_ID)
#define GES_LoresID     (LORES_KEY + DEFAULT_MONITOR_ID)


/* -------------------------- tag data support --------------------------- */

#define GEG_ShiftLeft    (256*256*256)
#define GEG_ShiftTop     (256*256)
#define GEG_ShiftWidth   256
#define GEG_ShiftHeight  1

#define GADDESC(l,t,w,h)   (GEG_ShiftLeft*(l)+GEG_ShiftTop*(t)+GEG_ShiftWidth*(w)+h)
#define GADOBJS(l,t,w,h)   (GEG_ShiftLeft*(l)+GEG_ShiftTop*(t)+GEG_ShiftWidth*(w)+h)

/* ------------------------------- Font support ------------------------- */

struct TextAttr topaz8font; /* don't use this directly !!! */


struct TextAttr *TopazAttr(VOID)
{
  topaz8font.ta_Name = "topaz.font";
  topaz8font.ta_YSize= 8;

  return &topaz8font;
}


/* ---------------------------- Hook functions -------------------------- */

/* WARNING: Not exported ! Don't call this directly !
            Use the Amiga hooks and GEUpdateEntryGadgetAHook instead */
BOOL __asm GEHUpdateEntryGadget(register __a0 struct GUIInfo * gui,
                                register __a1 struct Gadget *gadget)
{
  struct GUIGadgetInfo *GINFO;
  LONG   *VA;
  struct StringInfo *SI;

  GINFO = gadget->UserData;
  VA = GetGUIGadget(gui, gadget->GadgetID, GEG_VarAddress);
  if (VA)
  {
    SI = gadget->SpecialInfo;
    if (GINFO->kind == INTEGER_KIND)
    {
      *VA = SI->LongInt;
      return TRUE;
    }
    if (GINFO->kind == STRING_KIND)
    {
      strcpy(VA, SI->Buffer);
      return TRUE;
    }
  }
  return FALSE;
}

LONG __asm GEUpdateEntryGadgetAHook(register __a0 struct Hook *hook,
                                    register __a2 struct Gadget *gadget,
                                    register __a1 APTR unused)
{
  if (GEHUpdateEntryGadget(hook->h_Data, gadget) == TRUE)
    return 1;
  else
    return 0;
}

#endif
