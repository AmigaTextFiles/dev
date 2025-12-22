/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#define	LIBQSYS_DRIVER
#include "../../../include/libqsys.h"

/* display */
staticvar int expunge = 0;

extern struct ExecBase *SysBase;
extern struct DOSBase *DOSBase;
staticvar struct GfxBase *GfxBase = NULL;
staticvar struct IntuitionBase *IntuitionBase = NULL;
staticvar struct Library *AslBase = NULL;
staticvar struct Library *CyberGfxBase = NULL;
staticvar void CloseLibs(void);
staticvar struct nlist trackDisplay;

staticfnc void *InitDisplay(struct driverPrivate *priv)
{
  /* Works with Windows and Screens!!! */
  if (priv->ScreenDepth <= 8) {
    priv->BytesPerPel = 1;
    priv->FrameFormat = RECTFMT_LUT8;
  }
  else if (priv->ScreenDepth <= 16) {
    priv->BytesPerPel = 2;
    priv->FrameFormat = NULL;
  }
  else if (priv->ScreenDepth <= 24) {
    priv->BytesPerPel = 3;
    priv->FrameFormat = RECTFMT_RGB;
  }
  else if (priv->ScreenDepth <= 32) {
    priv->BytesPerPel = 4;
    priv->FrameFormat = RECTFMT_ARGB;
  }
  priv->BytesPerRow = priv->ScreenWidth * priv->BytesPerPel;
  priv->FrameSize = priv->BytesPerRow * priv->ScreenHeight;

  if (priv->FrameFormat) {
    if (priv->FrameBuffer)
      tfree(priv->FrameBuffer);
    if (!(priv->FrameBuffer = (void *)tmalloc(priv->FrameSize)))		/* BitMap allocation failed, what now?? */
      Error(failed_memoryunsize, "FrameBuffer");
  }
  else {
    if (priv->FrameHandle != 0)
      UnLockBitMap(priv->FrameHandle);
    if (priv->FrameBitMap != NULL)
      FreeBitMap(priv->FrameBitMap);
    if ((priv->FrameBitMap = AllocBitMap(priv->ScreenWidth, priv->ScreenHeight, priv->ScreenDepth,
					 BMF_MINPLANES | BMF_SPECIALFMT | SHIFT_PIXFMT(PIXFMT_RGB16), priv->RastPort->BitMap)) == NULL)	/* BitMap allocation failed, what now?? */
      Error(failed_memoryunsize, "FrameBuffer");
    if (!(priv->FrameHandle = LockBitMapTags(priv->FrameBitMap,
					     LBMI_BASEADDRESS, (unsigned long int)&priv->FrameBuffer,
					     TAG_DONE, 0)))
      Error("cannot lock FrameBuffer\n");
  }

  return priv->FrameBuffer;
}

staticfnc void ExitDisplay(struct driverPrivate *priv)
{
  if (priv->FrameFormat) {
    if (priv->FrameBuffer)
      tfree(priv->FrameBuffer);
    priv->FrameBuffer = NULL;
  }
  else {
    if (priv->FrameHandle)
      UnLockBitMap(priv->FrameHandle);
    priv->FrameHandle = 0;
    if (priv->FrameBitMap)
      FreeBitMap(priv->FrameBitMap);
    priv->FrameBitMap = NULL;
  }
}

#ifdef	USE_ZBUFFER
staticfnc void *InitDisplayZ(struct driverPrivate *priv)
{
  if (priv->ZBuffer)
    tfree(priv->ZBuffer);
  if ((priv->ZBuffer = (unsigned short int *)tmalloc(priv->ScreenWidth * priv->ScreenHeight * sizeof(unsigned short int))) == NULL)	/* BitMap allocation failed, what now?? */
    Error(failed_memoryunsize, "ZBuffer");

  return priv->ZBuffer;
}
#endif

struct DisplayDimension *OpenDisplay(short int width, short int height, char depth, struct rgb *Palette)
{
  struct driverPrivate *priv;
  struct DisplayDimension *disp;

  if(!(disp = tmalloc(sizeof(disp[0])))) {
    eprintf(failed_memory, "DisplayDimension", sizeof(disp[0])); return NULL; }
  if(!(priv = tmalloc(sizeof(priv[0])))) {
    eprintf(failed_memory, "driverPrivate", sizeof(priv[0])); return NULL; }

  if (!expunge++) {
    GfxBase = (struct GfxBase *)OpenLibrary((unsigned char *)"graphics.library", (unsigned long)39);
    IntuitionBase = (struct IntuitionBase *)OpenLibrary((unsigned char *)"intuition.library", (unsigned long)39);
    AslBase = OpenLibrary((unsigned char *)"asl.library", (unsigned long)37);
    CyberGfxBase = OpenLibrary((unsigned char *)"cybergraphics.library", (unsigned long)39);

    nNewList(&trackDisplay);
    atexit(CloseLibs);

    if ((GfxBase == NULL) || (IntuitionBase == NULL) || (AslBase == NULL))
      Error("cannot open one or more of the required libraries\n");
  }

  priv->Screen = LockPubScreen(NULL);
  priv->ScreenDepth = (depth == -1) ? GetBitMapAttr(priv->Screen->RastPort.BitMap, BMA_DEPTH) : depth;

  if ((priv->ScreenDepth > 8) && (GetBitMapAttr(priv->Screen->RastPort.BitMap, BMA_DEPTH) <= 8)) {
    eprintf("screen must have more than 8bits\n"); return NULL; }
  else if ((priv->ScreenDepth == 8) && (GetBitMapAttr(priv->Screen->RastPort.BitMap, BMA_DEPTH) < 8)) {
    eprintf("screen must have at least 8bits\n"); return NULL; }
  else {
    if (!(priv->Window = OpenWindowTags(NULL,
				 WA_InnerWidth, width,
				 WA_InnerHeight, height,
				 WA_MinWidth, 1,
				 WA_MinHeight, 1,
				 WA_MaxWidth, MAXWIDTH,
				 WA_MaxHeight, MAXHEIGHT,
				 WA_Left, (priv->Screen->Width - width) / 2,
				 WA_Top, (priv->Screen->Height - height) / 2,
				 WA_Flags, WFLG_GIMMEZEROZERO | WFLG_SIMPLE_REFRESH | WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_SIZEGADGET | WFLG_SIZEBBOTTOM | WFLG_ACTIVATE,
				 WA_PubScreen, (long unsigned int)priv->Screen,
				 WA_RMBTrap, TRUE,
				 WA_IDCMP, IDCMP_RAWKEY | IDCMP_NEWSIZE | IDCMP_CLOSEWINDOW | IDCMP_CHANGEWINDOW,
				 WA_Title, (long unsigned int)"Waiting ...",
				 WA_ScreenTitle, (long unsigned int)"aQView (by Niels Fröhling)",
				 TAG_DONE, NULL))) {		/* can't open window, what now?? */
      eprintf("cannot open window\n"); return NULL; }

    priv->RastPort = priv->Window->RPort;
    priv->ViewPort = &priv->Window->WScreen->ViewPort;
    if (priv->ViewPort && (priv->ScreenDepth == 8)) {
      GetRGB32(priv->ViewPort->ColorMap, 0, 256, &priv->OldColorMap[1]);
      priv->oldNFree = priv->ViewPort->ColorMap->PalExtra->pe_NFree;
      priv->ViewPort->ColorMap->PalExtra->pe_NFree = 0;
      priv->oldShareable = priv->ViewPort->ColorMap->PalExtra->pe_SharableColors;
      priv->ViewPort->ColorMap->PalExtra->pe_SharableColors = 0;
      priv->OldColorMap[0] = 0x01000000;
    }
  }

  nAddHead(&trackDisplay, &priv->drvNode);

  disp->driverPrivate = priv;
  priv->displayDim = disp;
  disp->X = priv->ScreenLeft = priv->Window->LeftEdge;
  disp->Y = priv->ScreenTop = priv->Window->TopEdge;
  disp->changedOffset = TRUE;
  disp->Width = priv->ScreenWidth = priv->Window->GZZWidth;
  disp->Height = priv->ScreenHeight = priv->Window->GZZHeight;
  disp->changedSize = TRUE;
  disp->dtX = priv->Screen->LeftEdge;
  disp->dtY = priv->Screen->TopEdge;
  disp->changedDesktopOffset = TRUE;
  disp->dtWidth = priv->Screen->Width;
  disp->dtHeight = priv->Screen->Height;
  disp->changedDesktopSize = TRUE;
  if (!(disp->frameBuffer = InitDisplay(priv)))
    return NULL;
#ifdef	USE_ZBUFFER
  if (!(disp->zBuffer = InitDisplayZ(priv)))
    return NULL;
#endif
  disp->frameDepth = priv->ScreenDepth;
  disp->frameBPP = priv->BytesPerPel;
  disp->frameSize = priv->ScreenWidth * priv->ScreenHeight;
  disp->changedBuffer = TRUE;

  ChangeDisplay(disp, priv->ScreenWidth, priv->ScreenHeight, priv->ScreenDepth, Palette, "Waiting ...");

  return disp;
}

void *SwapDisplay(struct DisplayDimension *disp, void *oldBuffer)
{
  struct driverPrivate *priv = disp->driverPrivate;

  if (priv->RastPort) {
    if (CyberGfxBase) {
      /*WaitBOVP(ViewPort); */
      if (priv->FrameFormat)
	WritePixelArray(oldBuffer, 0, 0, priv->BytesPerRow, priv->RastPort, 0, 0, priv->ScreenWidth, priv->ScreenHeight, priv->FrameFormat);
      else
	BltBitMapRastPort(priv->FrameBitMap, 0, 0, priv->RastPort, 0, 0, priv->ScreenWidth, priv->ScreenHeight, 0x00C0);
    }
    else
      WriteChunkyPixels(priv->RastPort, 0, 0, priv->ScreenWidth, priv->ScreenHeight, oldBuffer, priv->BytesPerRow);
  }

  return oldBuffer;
}

void *UpdateDisplay(struct DisplayDimension *disp, void *oldBuffer, short int x, short int y, short int width, short int height)
{
  struct driverPrivate *priv = disp->driverPrivate;

  if ((x < priv->ScreenWidth) && (y < priv->ScreenHeight) && (priv->RastPort)) {
    if (CyberGfxBase) {
      /*WaitBOVP(ViewPort); */
      if (priv->FrameFormat)
	WritePixelArray(oldBuffer, x, y, priv->BytesPerRow, priv->RastPort, 0, 0, width, height, priv->FrameFormat);
      else
	BltBitMapRastPort(priv->FrameBitMap, x, y, priv->RastPort, 0, 0, width, height, 0x00C0);
    }
    else
      WriteChunkyPixels(priv->RastPort, x, y, width, height, oldBuffer, priv->BytesPerRow);
  }

  return oldBuffer;
}

void ChangeDisplay(struct DisplayDimension *disp, short int width, short int height, char depth, struct rgb *Palette, char *Title)
{
  struct driverPrivate *priv = disp->driverPrivate;

  if (priv->Window) {
    bool change = FALSE;
  
    if ((priv->ScreenWidth != width) || (priv->ScreenHeight != height)) {
      do {
        ChangeWindowBox(priv->Window,
		        (priv->Screen->Width - width) / 2,
		        (priv->Screen->Height - height) / 2,
		        width + priv->Window->BorderLeft + priv->Window->BorderRight,
		        height + priv->Window->BorderTop + priv->Window->BorderBottom);
        WaitPort(priv->Window->UserPort);
      } while((priv->Window->GZZWidth != width) || (priv->Window->GZZHeight != height));

      disp->X = priv->ScreenLeft = priv->Window->LeftEdge;
      disp->Y = priv->ScreenTop = priv->Window->TopEdge;
      disp->changedOffset = TRUE;
      disp->Width = priv->ScreenWidth = priv->Window->GZZWidth;
      disp->Height = priv->ScreenHeight = priv->Window->GZZHeight;
      disp->changedSize = TRUE;
      
      change = TRUE;
    }

    if (depth != priv->ScreenDepth) {
      priv->ScreenDepth = (depth == -1) ? GetBitMapAttr(priv->Screen->RastPort.BitMap, BMA_DEPTH) :	/* if -1 use preset */
	                  (depth <= GetBitMapAttr(priv->Screen->RastPort.BitMap, BMA_DEPTH)) ? depth :	/* if valid */
	                  priv->ScreenDepth;								/* if invalid */
      
      change = TRUE;
    }

    if (change) {
      disp->frameBuffer = InitDisplay(priv);	/* FIX: fatal error */
#ifdef	USE_ZBUFFER
      disp->zBuffer = InitDisplayZ(priv);	/* FIX: fatal error */
#endif
      disp->frameDepth = priv->ScreenDepth;
      disp->frameBPP = priv->BytesPerPel;
      disp->frameSize = priv->ScreenWidth * priv->ScreenHeight;
      disp->changedBuffer = TRUE;
    }
  }

  if (priv->Window && Title)
    SetWindowTitles(priv->Window, Title, -1);

  if (priv->ViewPort && Palette && (priv->ScreenDepth == 8)) {
    long unsigned int *ColorMap = priv->NewColorMap;
    int c = 256 - 1;

    *ColorMap++ = 0x01000000;
    for (; c >= 0; c--) {
      *ColorMap++ = ((long unsigned int)(*((unsigned char *)Palette)++)) << 24;		/* red   */
      *ColorMap++ = ((long unsigned int)(*((unsigned char *)Palette)++)) << 24;		/* green */
      *ColorMap++ = ((long unsigned int)(*((unsigned char *)Palette)++)) << 24;		/* blue  */
    }
    LoadRGB32(priv->ViewPort, priv->NewColorMap);
  }
}

void CloseDisplay(struct DisplayDimension *disp)
{
  struct driverPrivate *priv = disp->driverPrivate;

  if (priv->inputPort == priv->Window->UserPort)
    CloseKeys(disp);
  if (priv->Window) {
    if (priv->ViewPort && (priv->ScreenDepth == 8)) {
      LoadRGB32(priv->ViewPort, &priv->OldColorMap[0]);
      priv->ViewPort->ColorMap->PalExtra->pe_NFree = priv->oldNFree;
      priv->ViewPort->ColorMap->PalExtra->pe_SharableColors = priv->oldShareable;
    }
    CloseWindow(priv->Window);
    priv->Window = NULL;
    UnlockPubScreen(NULL, priv->Screen);
    priv->Screen = NULL;
    ExitDisplay(priv);
#ifdef	USE_ZBUFFER
    tfree(disp->ZBuffer);
    disp->ZBuffer = NULL;
#endif
  }

  nRemove(&trackDisplay, &priv->drvNode);
  tfree(priv->displayDim);
  tfree(priv);
}

staticfnc void CloseLibs(void) {
  if (!--expunge) {
    struct DisplayDimension *disp;
    
    while((disp = (struct DisplayDimension *)nGetHead(&trackDisplay)))
      CloseDisplay(disp);
  
    if (CyberGfxBase) {
      CloseLibrary(CyberGfxBase);
      CyberGfxBase = NULL;
    }
    if (IntuitionBase) {
      CloseLibrary((struct Library *)IntuitionBase);
      IntuitionBase = NULL;
    }
    if (GfxBase) {
      CloseLibrary((struct Library *)GfxBase);
      GfxBase = NULL;
    }
    if (AslBase) {
      CloseLibrary(AslBase);
      AslBase = NULL;
    }
  }
  
  if (expunge < 0)
    expunge = 0;
}

/*
 * input
 */

void OpenKeys(struct DisplayDimension *disp)
{
  struct driverPrivate *priv = disp->driverPrivate;

  if (priv->Window)
    priv->inputPort = priv->Window->UserPort;
}

bool GetKeys(struct DisplayDimension *disp, struct keyEvent *eventBuffer)
{
  struct IntuiMessage *intuiMsg;
  bool reallyAKey;
  struct driverPrivate *priv = disp->driverPrivate;

  eventBuffer->pressed = RAWKEY_NOTHING;

  if (priv->inputPort) {
    Forbid();
/*  while ((intuiMsg = (struct IntuiMessage *)GetMsg(priv->inputPort))) { */
    do {
      reallyAKey = TRUE;
      if ((intuiMsg = (struct IntuiMessage *)GetMsg(priv->inputPort))) {
        long unsigned int Class = intuiMsg->Class;
        unsigned short int Code = intuiMsg->Code;
        unsigned short int Qual = intuiMsg->Qualifier;
        struct Window *IDCMPWindow = intuiMsg->IDCMPWindow;

        ReplyMsg((struct Message *)intuiMsg);

	if (priv->Window == IDCMPWindow)
        switch (Class) {
	  case IDCMP_RAWKEY:
	    eventBuffer->pressed = (unsigned char)Code;
	    eventBuffer->qualifier = (unsigned char)Qual;
	    break;
	  case IDCMP_CLOSEWINDOW:
	    eventBuffer->pressed = RAWKEY_ESCAPE;
	    break;
	  case IDCMP_NEWSIZE:{
	      disp->Width = priv->ScreenWidth = IDCMPWindow->GZZWidth;
	      disp->Height = priv->ScreenHeight = IDCMPWindow->GZZHeight;
	      disp->changedSize = TRUE;
	      disp->frameBuffer = InitDisplay(priv);	/* FIX: fatal error */
#ifdef	USE_ZBUFFER
	      disp->zBuffer = InitDisplayZ(priv);	/* FIX: fatal error */
#endif
	      disp->frameDepth = priv->ScreenDepth;
	      disp->frameBPP = priv->BytesPerPel;
	      disp->frameSize = priv->ScreenWidth * priv->ScreenHeight;
	      disp->changedBuffer = TRUE;
	      reallyAKey = FALSE;
	    }
	    break;
	  case IDCMP_CHANGEWINDOW:{
	      disp->X = priv->ScreenLeft = IDCMPWindow->LeftEdge;
	      disp->Y = priv->ScreenTop = IDCMPWindow->TopEdge;
	      disp->changedOffset = TRUE;
	      reallyAKey = FALSE;
	    }
	    break;
        }
      }
    } while(!reallyAKey);
    Permit();
    intuiMsg = (struct IntuiMessage *)-1;
  }

  return (intuiMsg != NULL);
}

void CloseKeys(struct DisplayDimension *disp)
{
  struct driverPrivate *priv = disp->driverPrivate;

  if (priv->inputPort) {
    struct IntuiMessage *intuiMsg;

    Forbid();
    while ((intuiMsg = (struct IntuiMessage *)GetMsg(priv->inputPort)))
      ReplyMsg((struct Message *)intuiMsg);
    Permit();
    
    priv->inputPort = 0;
  }
}
