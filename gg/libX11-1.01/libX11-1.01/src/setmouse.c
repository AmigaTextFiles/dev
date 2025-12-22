/*
 * Copyright (c) 1992 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the "Amiga ROM Kernel Reference Manual: Devices", 3rd Edition,
 * published by Addison-Wesley (ISBN 0-201-56775-X).
 *
 * The "Amiga ROM Kernel Reference Manual: Devices" contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in these examples.  The source and executable code
 * of these examples may only be distributed in free electronic form, via
 * bulletin board or as part of a fully non-commercial and freely
 * redistributable diskette.  Both the source and executable code (including
 * comments) must be included, without modification, in any copy.  This
 * example may not be published in printed form or distributed with any
 * commercial product.  However, the programming techniques and support
 * routines set forth in these examples may be used in the development
 * of original executable software products for Commodore Amiga computers.
 *
 * All other rights reserved.
 *
 * This example is provided "as-is" and is subject to change; no
 * warranties are made.  All use is at your own risk. No liability or
 * responsibility is assumed.
 *
 ***************************************************************************
 *
 * Set_Mouse.c
 *
 * This example sets the mouse at x=100 and y=200
 *
 * Compile with SAS C 5.10: LC -b1 -cfistq -v -y -L
 * Requires Kickstart 36 or greater.
 *
 * Run from CLI only
 */

#include <exec/io.h>

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/libraries.h>
#include <devices/input.h>
#include <devices/inputevent.h>
#include <intuition/screens.h>

#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>

#include <stdio.h>

#include "libX11.h"

#include <X11/X.h>
#include <X11/Xlib.h>

#include "x11display.h"

extern struct DosLibrary *DOSBase;

void setmouse( int x, int y )
{
  struct IOStdReq   *InputIO=NULL;           /* I/O request block */
  struct MsgPort    *InputMP=NULL;           /* Message port */
  struct InputEvent *FakeEvent=NULL;         /* InputEvent pointer */
  struct IEPointerPixel *NeoPix=NULL;        /* New mouse position pointer */
  
  if( !(InputMP = CreateMsgPort()) ){
    goto free;
  }
  if( !(FakeEvent = AllocMem(sizeof(struct InputEvent),MEMF_PUBLIC)) ){
    goto free;
  }
  if( !(NeoPix  = AllocMem(sizeof(struct IEPointerPixel),MEMF_PUBLIC)) ){
    goto free;
  }
  if( !(InputIO = CreateIORequest(InputMP,sizeof(struct IOStdReq))) ){
    goto free;
  }
  if( OpenDevice("input.device",NULL,(struct IORequest *)InputIO,NULL) ){
    goto free;
  }
  /* Set up IEPointerPixel fields */
  NeoPix->iepp_Screen =(struct Screen *)DG.wb; /* WB screen */
  NeoPix->iepp_Position.X = x;
  NeoPix->iepp_Position.Y = y;

  /* Set up InputEvent fields */
  FakeEvent->ie_EventAddress = (APTR)NeoPix; /* IEPointerPixel */
  FakeEvent->ie_NextEvent = NULL;
  FakeEvent->ie_Class = IECLASS_NEWPOINTERPOS; /* new mouse pos */
  FakeEvent->ie_SubClass = IESUBCLASS_PIXEL;   /* on pixel */
  FakeEvent->ie_Code = IECODE_NOBUTTON;
  FakeEvent->ie_Qualifier = NULL;   /* absolute positioning */
  
  InputIO->io_Data = (APTR)FakeEvent;   /* InputEvent */
  InputIO->io_Length = sizeof(struct InputEvent);
  InputIO->io_Command = IND_WRITEEVENT;
  DoIO((struct IORequest *)InputIO);

 free:

  if( InputIO ){
    CloseDevice((struct IORequest *)InputIO);
    DeleteIORequest(InputIO);
  }
  if( NeoPix )
    FreeMem(NeoPix,sizeof(struct IEPointerPixel));
  if( FakeEvent )
    FreeMem(FakeEvent,sizeof(struct InputEvent));
  if( InputMP )
    DeleteMsgPort(InputMP);
}
