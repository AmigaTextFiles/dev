/* Copyright (c) 1994 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     amigaX
   PURPOSE
     make X11 programs compileable on Amiga/Intuition 
   NOTES
     
   HISTORY
     Terje Pedersen - Oct 9, 1994: Created.
***/

#ifndef AMIGAX
#define AMIGAX

#include <proto/exec.h>
#include "proto/dos.h"


#include <exec/types.h>
#include <exec/memory.h>
#include <string.h>

/*
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>

#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/gadtools.h>

#include <graphics/scale.h>
#include <graphics/gfx.h>
#include <graphics/rastport.h>
#include <graphics/gfxbase.h>
*/

#include <devices/timer.h>
#include <time.h>

/*
#undef SIGHUP
#define SIGHUP SIGINT
*/

#define LOCK_EX 100
#include <signal.h>
#include <sys/errno.h>

extern struct Library *X11Base;
extern struct Library *XtBase;

#ifndef MAXPATHLEN
#define MAXPATHLEN 256
#endif

struct timezone {
	int	tz_minuteswest;	/* minutes west of Greenwich */
	int	tz_dsttime;	/* type of dst correction */
};

#define S_IFCHR 512
#define S_IFBLK 256

extern void XSetPlanes(int d);

/*
enum {
  xmArrowButtonWidgetClass=1,
  xmBulletinBoardWidgetClass,
  xmCascadeButtonWidgetClass,
  xmCommandWidgetClass,
  xmDesktopClass,
  xmDialogShellWidgetClass,
  xmDialogShellExtObjectClass,
  xmDragIconObjectClass,
  xmDrawingAreaWidgetClass,
  xmDrawnButtonWidgetClass,
  xmDropSiteManagerObjectClass,
  xmDropTransferObjectClass,
  xmExtObjectClass,
  xmFileSelectionBoxWidgetClass,
  xmFormWidgetClass,
  xmFrameWidgetClass,
  xmLabelWidgetClass,
  xmListWidgetClass,
  xmMainWindowWidgetClass,
  xmMenuShellWidgetClass,
  xmMessageBoxWidgetClass,
  xmPanedWindowWidgetClass,
  xmProtocolObjectClass,
  xmPushButtonWidgetClass,
  xmRowColumnWidgetClass,
  xmScaleWidgetClass,
  xmScrollBarWidgetClass,
  xmScrolledWindowWidgetClass,
  xmSelectionBoxWidgetClass,
  xmSeparatorWidgetClass,
  xmShellExtObjectClass,
  xmTextWidgetClass,
  xmTextFieldWidgetClass,
  xmToggleButtonWidgetClass,
  vendorShellWidgetClass,
  xmVendorShellExtObjectClass,
  xmWorldClass,
  xmWorldObjectClass,
  xmDesktopObjectClass,
  xmDisplayObjectClass,
  xmScreenObjectClass,
  xmPrimitiveWidgetClass,
  xmManagerWidgetClass
};
*/

enum {
  simpleWidgetClass=1
};

enum {
  smeLineObjectClass=1,
};

#endif /* AMIGAX */
