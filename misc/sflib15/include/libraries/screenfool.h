/* screenfool.h - Application header file for ScreenFool */

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#include <exec/nodes.h>
#include <exec/lists.h>
#include <exec/memory.h>
#include <intuition/screens.h>
#include <graphics/displayinfo.h>
#include <libraries/diskfont.h>

#include <string.h>
#include <stdio.h>

/* NOTE - These structures are private to screenfool.library.
          DO NOT ASSUME YOU KNOW WHAT THEY DO!
          Creating your own handling code is a No-No */

/* You may *read* all fields in DisplayModeInfo and PublicScreenInfo */

struct DisplayModeInfo {
  struct Node dmi_Node;
  ULONG dmi_DisplayID;
  ULONG dmi_Cardinal;
  struct DisplayInfo *dmi_Display;
  struct DimensionInfo *dmi_Dimensions;
  struct MonitorInfo *dmi_Monitor;
  struct NameInfo *dmi_Name;
  };

struct PublicScreenInfo {
  struct Node psi_Node;
  UWORD psi_Cardinal;
  UBYTE psi_Name[MAXPUBSCREENNAME+1];
  struct Screen *psi_Screen; /* Use LockPubScreen(psi_Name) please */
  };

struct PublicScreenSaveInfo { /* VERY PRIVATE STRUCTURE */
  struct Node psi_Node;
  UWORD psi_Cardinal;
  UBYTE psi_Name[MAXPUBSCREENNAME+1];
  struct Screen *psi_Screen;
  struct TextAttr psi_TextAttr;
  UBYTE psi_FontName[MAXFONTPATH];
  };

/* The ScreenFool list header -- DO NOT ALLOCATE YOURSELF -- may extend */
struct ScreenFoolList {
  struct List sfl_List;
  ULONG sfl_Length;
  };

#define sfNT_SCREEN       (NT_USER-20)
#define sfNT_DISPLAY      (NT_USER-21)
