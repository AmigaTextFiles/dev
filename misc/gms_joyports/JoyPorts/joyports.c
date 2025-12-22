/*
** Module:    JoyPorts.
** Type:      Object based hardware driver.
** Author:    Paul Manias
** Copyright: DreamWorld Productions (c) 1996-1998.  All rights reserved.
**
** --------------------------------------------------------------------------
** 
** TERMS AND CONDITIONS
** 
** This source code is made available on the condition that it is only used to
** further enhance the Games Master System.  IT IS NOT DISTRIBUTED FOR THE USE
** IN OTHER PRODUCTS.  Developers may edit and re-release this source code
** only in the form of its GMS module.  Use of this code outside of the module
** is not permitted under any circumstances.
** 
** This source code stays the copyright of DreamWorld Productions regardless
** of what changes or additions are made to it by 3rd parties.  However joint
** copyright is granted if the 3rd party wishes to retain some ownership of
** said modifications.
** 
** In exchange for our distribution of this source code, we also ask you to
** distribute the source when releasing a modified version of this module.
** This is not compulsory if any additions are sensitive to 3rd party
** copyrights, or if it would damage any commercial product(s).
** 
** --------------------------------------------------------------------------
**
** BUGS AND MISSING FEATURES
** -------------------------
** If you correct a bug or fill in a missing feature, the source should be
** e-mailed to pmanias@ihug.co.nz for inclusion in the next update of this
** module.
**
** The following issues need attention:
**
** + Joypad, Segapad and Analogue support.  There used to be full joypad and
**   sega support but it was never confirmed that it worked, so it was removed.
**
** + The hardware bits for some of the mouse/joystick buttons are not set
**   correctly, these need to be fixed and tested.
**
** + Support a Qualifier mask for keyboard based emulation.  This will allow
**   the player to select between normal keyboard input and joystick input (vital
**   for mouse based games that support the keyboard).  Also, support a
**   switching feature, so that the user can flip between modes at the press of
**   a key.
**
** + Grab joydata timeouts from user prefs rather than using the default.
**
** + Buttons need to be buffered so that there is a point to the time-out field.
**   The time since the last Activate()/Query() should also be stored in the
**   JoyData structure so that we can assess when the last read was.
**
** + If it is necessary to calibrate analog joysticks (find the most extreme
**   value that can be returned for each direction) we will need to do this
**   from GMSPrefs.
**
** CHANGES
** -------
** 12 Jan Added new fields - ButtonTimeOut, MoveTimeOut.
** 21 Jan Bug in Joystick reader not resetting coordinates to null, fixed.
** 22 Jan New fields added, *Limit.
** 06 Feb Added support for GVBase->UserFocus. [Activate() altered]
** 14 Feb Altered port initialisation.
**        Keyboard emulation support is working.
** 26 Apr Now written entirely in C.
** 14 Jun Removed the "DATA=faronly" option from SAS/C and recompiled - looks okay.
**        Tested the DCC compilation, worked fine.
** 10 Oct Added support for JPORT_DIGITAL and JPORT_ANALOGUE in Port field.
*/

#include <proto/dpkernel.h>
#include <system/all.h>
#include <input/keyboard.h>
#include <hardware/custom.h>
#include <hardware/cia.h>
#include <dpkernel/prefs.h>

extern struct SysObject *JoyObject;
extern struct GVBase    *GVBase;
extern struct Custom    *custom;
extern struct CIA       *cia;
extern struct ModPublic *Public;

/************************************************************************************
** Internal proto-types.
*/

void FreeModule(void);
void ReadAnalogue(struct JoyData *);
void ReadJoyPad(struct JoyData *);
void ReadJoyStick(struct JoyData *);
void ReadKeyboard(struct JoyData *);
void ReadMouse(struct JoyData *);
void ReadSegaPad(struct JoyData *);

LIBFUNC LONG             JOY_Activate(mreg(__a0) struct JoyData *);
LIBFUNC struct JoyData * JOY_Get(mreg(__a0) struct Stats *);
LIBFUNC LONG             JOY_Init(mreg(__a0) struct JoyData *);
LIBFUNC void             JOY_Free(mreg(__a0) struct JoyData *);

#define JOY_FIELDS 11

struct Field JoyFields[JOY_FIELDS] = {
  { "Port",          12, FID_Port,          FDF_WORD, 0, 0, NULL, NULL },
  { "XChange",       14, FID_XChange,       FDF_WORD|FDF_RANGE, -1000, +1000, NULL, NULL },
  { "YChange",       16, FID_YChange,       FDF_WORD|FDF_RANGE, -1000, +1000, NULL, NULL },
  { "ZChange",       18, FID_ZChange,       FDF_WORD|FDF_RANGE, -1000, +1000, NULL, NULL }, 
  { "Buttons",       20, FID_Buttons,       FDF_LONG, 0, 0, NULL, NULL },
  { "ButtonTimeOut", 24, FID_ButtonTimeOut, FDF_WORD|FDF_RANGE, 0, 32000, NULL, NULL },
  { "MoveTimeOut",   26, FID_MoveTimeOut,   FDF_WORD|FDF_RANGE, 0, 32000, NULL, NULL },
  { "NXLimit",       28, FID_NXLimit,       FDF_WORD, 0, 0, NULL, NULL },
  { "NYLimit",       30, FID_NYLimit,       FDF_WORD, 0, 0, NULL, NULL },
  { "PXLimit",       32, FID_PXLimit,       FDF_WORD, 0, 0, NULL, NULL },
  { "PYLimit",       34, FID_PYLimit,       FDF_WORD, 0, 0, NULL, NULL },
};

BYTE ModAuthor[]    = "Paul Manias";
BYTE ModDate[]      = "September 1998";
BYTE ModCopyright[] = "DreamWorld Productions (c) 1996-1998.  All rights reserved.";
BYTE ModName[]      = "Joyports";

/************************************************************************************
** Command: Init()
** Short:   Called when our module is being opened for the first time.  Any
**          allocations made here will need to be freed in the FreeModule()
**          function.
*/

LIBFUNC LONG CMDInit(mreg(__a0) LONG argModule,
                     mreg(__a1) LONG argDPKBase,
                     mreg(__a2) LONG argGVBase,
                     mreg(__d0) LONG argDPKVersion,
                     mreg(__d1) LONG argDPKRevision)
{
  DPKBase = (APTR)argDPKBase;
  GVBase  = (struct GVBase *)argGVBase;
  Public  = ((struct Module *)argModule)->Public;

  if ((argDPKVersion < DPKVersion) OR
     ((argDPKVersion IS DPKVersion) AND (argDPKRevision < DPKRevision))) {
     DPrintF("!Init:","This module requires a newer version of the dpkernel library.");
     return(ERR_FAILED);
  }

  if (!(JoyObject = AddSysObjectTags(ID_JOYDATA, ID_JOYDATA, "JoyData",
        TAGS,           NULL,
        SOA_Activate,   JOY_Activate,
        SOA_Free,       JOY_Free,
        SOA_Get,        JOY_Get,
        SOA_Init,       JOY_Init,
        SOA_Query,      JOY_Activate,
        SOA_FieldArray, &JoyFields,
        SOA_FieldTotal, JOY_FIELDS,
        SOA_FieldSize,  sizeof(struct Field),
        TAGEND))) {
     FreeModule();
     return(ERR_FAILED);
  }

  return(ERR_OK);
}

/************************************************************************************
** Command: Open()
** Short:   Called when our module is being opened for a second time...
*/

LIBFUNC LONG CMDOpen(mreg(__a0) struct Module *Module)
{
  Public->OpenCount++;
  return(ERR_OK);
}

/************************************************************************************
** Command: Expunge()
** Short:   Called on expunge - if no program has us opened then we can give
**          permission to have us shut down.
*/

LIBFUNC LONG CMDExpunge(void)
{
  if (Public) {
     if (Public->OpenCount IS NULL) {
        FreeModule();
        return(ERR_OK); /* Okay to expunge */
     }
  }
  else DPrintF("!Joyports:","I have no Public base reference.");

  return(ERR_FAILED); /* Do not expunge */
}

/************************************************************************************
** Command: Close()
** Short:   Called whenever someone is closing a link to our module.
*/

LIBFUNC void CMDClose(mreg(__a0) struct Module *Module)
{
  Public->OpenCount--;
}

/************************************************************************************
** Internal: FreeModule()
** Short:    Frees any allocations made in the initialisation of our module.
*/

void FreeModule(void)
{
  if (JoyObject) RemSysObject(JoyObject);
}

#include "JOY_Init.c"

