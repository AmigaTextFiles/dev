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

#define	LIBQTOOLS_CORE
#define	LIBQDISPLAY_CORE
#include "../include/libqdisplay.h"
#include "../include/libqsys.h"

int frameCounter;
struct view *actView;
struct view mainView;

#ifdef CALCULATE_PIXELDRAW
int pixelDraw;
int pixelOverdraw;
#endif

void run_demo(bspBase bspMem)
{
  int flyMode = FALSE;
  int updownHeight, leftrightWidth;
  vec1D updownAngles, leftrightAngles;
  int position = CONTENTS_EMPTY;				/* content */

#ifdef AUTORUN
  for (frameCounter = 0; frameCounter < 18; frameCounter++) {
#else
  struct keyEvent inPut;

  for (frameCounter = 0;; frameCounter++) {
#endif
    /*
     * first verify the validity of the display and the renderers informations
     */
    if (actView->viewDim->changedBuffer) {				/* changedSize need not implicate changeBuffer */
      InitMultTables(actView->viewDim->Width, actView->viewDim->Height);
      set_clip_values(0, 0, actView->viewDim->Width, actView->viewDim->Height);
      actView->viewDim->changedBuffer = FALSE;
      actView->viewCamera.changedAngles = TRUE;
    }
    if (actView->viewDim->changedOffset || actView->viewDim->changedSize) {
      if (flyMode) {
	actView->viewCamera.cameraAngles.tx = (int)((actView->viewDim->X - updownHeight) * updownAngles);
	actView->viewCamera.cameraAngles.tz = (int)((actView->viewDim->Y - leftrightWidth) * leftrightAngles);
	actView->viewCamera.changedAngles = TRUE;
      }
      if (actView->viewDim->changedSize) {
	updownHeight = (actView->viewDim->dtHeight - actView->viewDim->Height) / 2;
	leftrightWidth = (actView->viewDim->dtWidth - actView->viewDim->Width) / 2;
	updownAngles = 90.0 / updownHeight;
	leftrightAngles = 180.0 / leftrightWidth;
      }
      actView->viewDim->changedOffset = FALSE;
      actView->viewDim->changedSize = FALSE;
    }
    if (actView->viewDim->changedDesktopOffset) {
      actView->viewDim->changedDesktopOffset = FALSE;
    }
    if (actView->viewDim->changedDesktopSize) {
      updownHeight = (actView->viewDim->dtHeight - actView->viewDim->Height) / 2;
      leftrightWidth = (actView->viewDim->dtWidth - actView->viewDim->Width) / 2;
      updownAngles = 90.0 / updownHeight;
      leftrightAngles = 180.0 / leftrightWidth;
      actView->viewDim->changedDesktopSize = FALSE;
    }
    __bzero(actView->viewDim->frameBuffer, actView->viewDim->frameSize * actView->viewDim->frameBPP);

#ifdef CALCULATE_PIXELDRAW
    __bzero(actView->viewDim->frameBuffer, actView->viewDim->frameSize * actView->viewDim->frameBPP);
    mprintf("draw pixel: %d, overdrawn pixel: %d\n", pixelDraw, pixelOverdraw);
    pixelDraw = pixelOverdraw = 0;
#endif
#ifndef AUTORUN
    /*
     * parse inputevents, this is also the only way to communicate 
     * with the user-interface, if the display changes, verify it in
     * that routine
     */
    while (GetKeys(&actView->viewDim, &inPut)) {
      if (inPut.pressed == RAWKEY_NOTHING)
	break;

      switch (inPut.pressed) {
	case RAWKEY_ESCAPE:
	case RAWKEY_q:
	  return;
	  break;

	case RAWKEY_w:
	  actView->displayType = DISPLAY_WIRE;
	  break;
	case RAWKEY_l:
	  actView->displayType = DISPLAY_FLAT;
	  break;
	case RAWKEY_t:
	  actView->displayType = DISPLAY_TEXTURED;
	  break;

	case RAWKEY_NUMPAD_PGDN:
	  actView->viewCamera.cameraAngles.tx += (inPut.qualifier == RAWQUAL_RSHIFT ? 20 : 10);
	  actView->viewCamera.changedAngles = TRUE;
	  break;
	case RAWKEY_NUMPAD_PGUP:
	  actView->viewCamera.cameraAngles.tx -= (inPut.qualifier == RAWQUAL_RSHIFT ? 20 : 10);
	  actView->viewCamera.changedAngles = TRUE;
	  break;
	case RAWKEY_NUMPAD_HOME:
	  currentSpeed[2] += (inPut.qualifier == RAWQUAL_RSHIFT ? 2 * actView->viewCamera.incSpeed : actView->viewCamera.incSpeed);
	  actView->viewCamera.changedLocation = TRUE;
	  break;
	case RAWKEY_NUMPAD_END:
	  currentSpeed[2] -= (inPut.qualifier == RAWQUAL_RSHIFT ? 2 * actView->viewCamera.incSpeed : actView->viewCamera.incSpeed);
	  actView->viewCamera.changedLocation = TRUE;
	  break;
	case RAWKEY_NUMPAD_AWUP:
	  currentSpeed[0] += (inPut.qualifier == RAWQUAL_RSHIFT ? 2 * actView->viewCamera.incSpeed : actView->viewCamera.incSpeed);
	  actView->viewCamera.changedLocation = TRUE;
	  break;
	case RAWKEY_NUMPAD_AWDN:
	  currentSpeed[0] -= (inPut.qualifier == RAWQUAL_RSHIFT ? 2 * actView->viewCamera.incSpeed : actView->viewCamera.incSpeed);
	  actView->viewCamera.changedLocation = TRUE;
	  break;
	case RAWKEY_NUMPAD_AWRIGHT:
	  actView->viewCamera.cameraAngles.tz += (inPut.qualifier == RAWQUAL_RSHIFT ? 20 : 10);
	  actView->viewCamera.changedAngles = TRUE;
	  break;
	case RAWKEY_NUMPAD_AWLEFT:
	  actView->viewCamera.cameraAngles.tz -= (inPut.qualifier == RAWQUAL_RSHIFT ? 20 : 10);
	  actView->viewCamera.changedAngles = TRUE;
	  break;
	case RAWKEY_NUMPAD_PLUS:
	  actView->viewCamera.cameraAngles.ty += (inPut.qualifier == RAWQUAL_RSHIFT ? 20 : 10);
	  actView->viewCamera.changedAngles = TRUE;
	  break;
	case RAWKEY_NUMPAD_MINUS:
	  actView->viewCamera.cameraAngles.ty -= (inPut.qualifier == RAWQUAL_RSHIFT ? 20 : 10);
	  actView->viewCamera.changedAngles = TRUE;
	  break;
	case RAWKEY_f:
	  if ((flyMode ^= TRUE) == TRUE)
	    currentSpeed[0] = currentSpeed[2] = (actView->viewCamera.maxSpeed / 3);
	  else
	    currentSpeed[2] = -(actView->viewCamera.maxSpeed / 3);
	  actView->viewCamera.changedLocation = TRUE;
	  break;
      }
    }
#else
    switch (frameCounter) {
      case 0:
	actView->viewCamera.cameraAngles.tx += 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
      case 1:
	actView->viewCamera.cameraAngles.tx += 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
      case 2:
	actView->viewCamera.cameraAngles.tx += 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
      case 3:
	actView->viewCamera.cameraAngles.tx -= 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
      case 4:
	actView->viewCamera.cameraAngles.tx -= 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
      case 5:
	actView->viewCamera.cameraAngles.tx -= 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
      case 6:
	actView->viewCamera.cameraAngles.tx -= 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
      case 7:
	actView->viewCamera.cameraAngles.tx -= 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
      case 8:
	actView->viewCamera.cameraAngles.tx -= 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
      case 9:
	actView->viewCamera.cameraAngles.tx += 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
      case 10:
	actView->viewCamera.cameraAngles.tx += 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
      case 11:
	actView->viewCamera.cameraAngles.tx += 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
      case 12:
	actView->viewCamera.cameraAngles.tx += 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
      case 13:
	actView->viewCamera.cameraAngles.tx += 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
      case 14:
	actView->viewCamera.cameraAngles.tx += 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
      case 15:
	actView->viewCamera.cameraAngles.tx -= 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
      case 16:
	actView->viewCamera.cameraAngles.tx -= 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
      case 17:
	actView->viewCamera.cameraAngles.tx -= 15;
	actView->viewCamera.cameraAngles.tz += 10;
	actView->viewCamera.changedAngles = TRUE;
	break;
    }
#endif

    /* validate input events */
    if (flyMode) {
      if (actView->viewCamera.cameraAngles.tz - lastCamera.tz) {
	actView->viewCamera.cameraAngles.ty -= (actView->viewCamera.cameraAngles.tz - lastCamera.tz) / 4;
	actView->viewCamera.changedAngles = TRUE;
      }
      currentSpeed[0] += actView->viewCamera.decSpeed;
      actView->viewCamera.changedLocation = TRUE;
    }

    if (actView->viewCamera.changedAngles) {
      if (actView->viewCamera.cameraAngles.tx > 360)
	actView->viewCamera.cameraAngles.tx -= 360;
      else if (actView->viewCamera.cameraAngles.tx < 0)
	actView->viewCamera.cameraAngles.tx += 360;

      if (actView->viewCamera.cameraAngles.ty > 360)
	actView->viewCamera.cameraAngles.ty -= 360;
      else if (actView->viewCamera.cameraAngles.ty < 0)
	actView->viewCamera.cameraAngles.ty += 360;
      if ((actView->viewCamera.cameraAngles.ty > 45) && (actView->viewCamera.cameraAngles.ty < 180))
	actView->viewCamera.cameraAngles.ty = 45;
      else if ((actView->viewCamera.cameraAngles.ty < 315) && (actView->viewCamera.cameraAngles.ty > 180))
	actView->viewCamera.cameraAngles.ty = 315;

      if (actView->viewCamera.cameraAngles.tz > 360)
	actView->viewCamera.cameraAngles.tz -= 360;
      else if (actView->viewCamera.cameraAngles.tz < 0)
	actView->viewCamera.cameraAngles.tz += 360;

      lastCamera.tz = actView->viewCamera.cameraAngles.tz;
    }

    if (actView->viewCamera.changedLocation) {
      if (currentSpeed[0] >= actView->viewCamera.maxSpeed)
	currentSpeed[0] = actView->viewCamera.maxSpeed;
      else if (currentSpeed[0] <= -actView->viewCamera.maxSpeed)
	currentSpeed[0] = -actView->viewCamera.maxSpeed;

      if (currentSpeed[2] >= actView->viewCamera.maxSpeed)
	currentSpeed[2] = actView->viewCamera.maxSpeed;
      else if (currentSpeed[2] <= -actView->viewCamera.maxSpeed)
	currentSpeed[2] = -actView->viewCamera.maxSpeed;

      position = find_contents(bspMem);
      switch (position) {
	case CONTENTS_EMPTY:					/* not possible */
	  break;
	case CONTENTS_SOLID:					/* correct position */
	  break;
	case CONTENTS_WATER:					/* swim */
	  break;
	case CONTENTS_SLIME:					/* damage */
	  break;
	case CONTENTS_LAVA:					/* more damage */
	  break;
	case CONTENTS_SKY:					/* not possible */
	  break;
      }
    }

    updateTimings();						/* liquid, sky */

    /* recalc renderer if nessecary and render and display */
    set_view_info();
    renderWorld(bspMem);
    actView->viewDim->frameBuffer = SwapDisplay(&actView->viewDim, actView->viewDim->frameBuffer);	/* FIX: move framebufferchanges completely into SwapDisplay */
  }
}

staticvar bool inited = FALSE;

struct view *OpenView(void) {
  mainView.viewDim = &localDim;

  return &mainView;
}

/*
 * TODO:
 *  parameter for dim, if 0 create a static one, else use the given
 */
bool DisplayBSP(bspBase bspMem, char *Title, int width, int height, int depth, int display, bool wait) {
  struct entity *plEnt;
  mapBase mapMem;
  
  actView->displayType = display;
  actView = OpenView();

  if(!(mapMem = kmalloc(sizeof(struct mapmemory))))
    Error(failed_memoryunsize, "map");
  mapMem->mapOptions |= MAP_LOADLIGHTS;
  AllocMapClusters(mapMem, MAP_ENTITIES);
  LoadMapFile(bspMem, mapMem, bspMem->shared.quake1.dentdata);

  if (!(visibleFaces = (unsigned char *)kmalloc((bspMem->shared.quake1.numfaces + 32) * sizeof(unsigned char))))
    Error(failed_memory, (bspMem->shared.quake1.numfaces + 32) * sizeof(unsigned char), "visible faces");
  if (!(visibleLeafs = (unsigned char *)kmalloc(((bspMem->shared.quake1.numleafs >> 3) + 32) * sizeof(unsigned char))))
    Error(failed_memory, ((bspMem->shared.quake1.numleafs >> 3) + 32) * sizeof(unsigned char), "visible leafs");
  __memset(visibleLeafs, 0xFF, ((bspMem->shared.quake1.numleafs >> 3) + 1) * sizeof(unsigned char));
  if (!(visibleNodes = (unsigned char *)kmalloc(((bspMem->shared.quake1.numnodes >> 3) + 32) * sizeof(unsigned char))))
    Error(failed_memory, ((bspMem->shared.quake1.numnodes >> 3) + 32) * sizeof(unsigned char), "visible nodes");
  __memset(visibleNodes, 0xFF, ((bspMem->shared.quake1.numnodes >> 3) + 1) * sizeof(unsigned char));

  /* find players start-point */
  if ((plEnt = FindEntityWithKeyPair(mapMem, "classname", "info_player_start"))) {
    VectorCopy(plEnt->origin, actView->viewCamera.cameraLocation);
    actView->viewCamera.cameraAngles.tx = 0;
    actView->viewCamera.cameraAngles.ty = 0;
    actView->viewCamera.cameraAngles.tz = plEnt->angle;
    mprintf("Current Pos - [" VEC_CONV1D "] [" VEC_CONV1D "] [" VEC_CONV1D "]\nAngle [%d]\n", actView->viewCamera.cameraLocation[0], actView->viewCamera.cameraLocation[1], actView->viewCamera.cameraLocation[2], actView->viewCamera.cameraAngles.tz);
    actView->viewCamera.changedAngles = TRUE;
    actView->viewCamera.changedLocation = TRUE;
  }

  /* force load of palette and colormap */
  darkness = 63;
  tfree(GetPalette());

  if (cachedColormap && cachedPalette) {
    if(!inited) {
      struct DisplayDimension *dim;
  
      if (!(dim = OpenDisplay(width, height, depth, cachedPalette))) {
        kfree(); return FALSE; }
      actView->viewDim = dim;
      OpenKeys(&actView->viewDim);
      __bzero(actView->viewDim->frameBuffer, actView->viewDim->frameSize * actView->viewDim->frameBPP);
      actView->viewDim->frameBuffer = SwapDisplay(&actView->viewDim, actView->viewDim->frameBuffer);	/* FIX: */

      inited = TRUE;
    }
    ChangeDisplay(&actView->viewDim, width, height, 0, 0, Title);

#ifdef	DRIVER_8BIT
    if (actView->viewDim->frameDepth == 8) {
/*    UpdateDisplay(cachedColormap, 0, 0, 256, 64);               // only 8bit */

      /* setup water                                              // only 8bit */
      waterTransparency = GetTransparency(DENSITY_WATER);
/*    UpdateDisplay(waterTransparency, 0, 0, 256, 256);           // only 8bit */

      /* setup slime                                              // only 8bit */
      slimeTransparency = GetTransparency(DENSITY_SLIME);
/*    UpdateDisplay(slimeTransparency, 0, 0, 256, 256);           // only 8bit */

      /* setup lava                                               // only 8bit */
      lavaTransparency = GetTransparency(DENSITY_LAVA);
/*    UpdateDisplay(lavaTransparency, 0, 0, 256, 256);            // only 8bit */

      /* setup teleport                                           // only 8bit */
      teleTransparency = GetTransparency(DENSITY_TELEPORT);
/*    UpdateDisplay(teleTransparency, 0, 0, 256, 256);            // only 8bit */
    }
#endif

    InitSinCosTables();
    InitFaceCache(bspMem);
    setup_default_point_list();
    run_demo(bspMem);
  }

  kfree();

  if(!wait)
    DisplayEnd();
  
  return TRUE;
}

/*
 * TODO:
 *  parameter for dim, if 0 create a static one, else use the given
 */
bool DisplayPicture(void *pic, char *Title, int width, int height, int depth, bool wait) {
  bool noContinue = FALSE;
  struct keyEvent inPut;

  actView = OpenView();

  if(!inited) {
    struct DisplayDimension *dim;
  
    if (!(dim = OpenDisplay(width, height, depth, cachedPalette)))
      return TRUE;
    actView->viewDim = dim;
    OpenKeys(&actView->viewDim);
    __bzero(actView->viewDim->frameBuffer, actView->viewDim->frameSize * actView->viewDim->frameBPP);
    actView->viewDim->frameBuffer = SwapDisplay(&actView->viewDim, actView->viewDim->frameBuffer);

    inited = TRUE;
  }
  
  ChangeDisplay(&actView->viewDim, width, height, depth, cachedPalette, Title);
  __bzero(actView->viewDim->frameBuffer, actView->viewDim->frameSize * actView->viewDim->frameBPP);
  UpdateDisplay(&actView->viewDim, pic, 0, 0, width, height);

  while (GetKeys(&actView->viewDim, &inPut)) {
    /* leave display-loop */
    if (inPut.pressed == RAWKEY_ESCAPE) {
      noContinue = TRUE;
      break;
    }
    /* next picture */
    if (inPut.pressed == RAWKEY_SPACE) {
      noContinue = FALSE;
      break;
    }
  }
  
  if(!wait)
    DisplayEnd();
  
  return noContinue;
}

bool wideView = FALSE;

/*
 * TODO:
 *  parameter for dim, if 0 create a static one, else use the given
 */
bool DisplayMipMap(void *pic, char *Title, int width, int height, int depth, bool wait) {
  bool noContinue = FALSE;

  if (wideView) {
    struct palpic *newpic;
    struct mipmap *mipmap;
    
    if ((newpic = tmalloc(      2 * (width * height) + sizeof(struct palpic)))) {
      if ((mipmap = tmalloc(MIP_MULT(width * height) + sizeof(struct mipmap)))) {
	newpic->width = width;
	newpic->height = height;
	newpic->name = Title;
	__memcpy(pic, &newpic->rawdata[0], width * height);			/* FIX: different depths */

	if (PasteMipMap(mipmap, newpic)) {
	  unsigned char *paste;
	  unsigned char *mip0, *mip1, *mip2, *mip3;
	  int rows, cols;
	  
	  paste = pic = &newpic->rawdata[0];
	  mip0 = ((char *)mipmap) + LittleLong(mipmap->offsets[0]);
	  mip1 = ((char *)mipmap) + LittleLong(mipmap->offsets[1]);
	  mip2 = ((char *)mipmap) + LittleLong(mipmap->offsets[2]);
	  mip3 = ((char *)mipmap) + LittleLong(mipmap->offsets[3]);
	  
	  __bzero(pic, 2 * (width * height));
	  for (rows = (height / 8); --rows >= 0; paste += (width / 8)) {
	    for (cols = width / 1 ; --cols >= 0; *paste++ = *mip0++);
	    for (cols = width / 2 ; --cols >= 0; *paste++ = *mip1++);
	    for (cols = width / 4 ; --cols >= 0; *paste++ = *mip2++);
	    for (cols = width / 8 ; --cols >= 0; *paste++ = *mip3++);
	  }
	  for (rows = (height / 4); --rows >= 0; paste += (width / 4)) {
	    for (cols = width / 1 ; --cols >= 0; *paste++ = *mip0++);
	    for (cols = width / 2 ; --cols >= 0; *paste++ = *mip1++);
	    for (cols = width / 4 ; --cols >= 0; *paste++ = *mip2++);
	  }
	  for (rows = (height / 2); --rows >= 0; paste += (width / 2)) {
	    for (cols = width / 1 ; --cols >= 0; *paste++ = *mip0++);
	    for (cols = width / 2 ; --cols >= 0; *paste++ = *mip1++);
	  }
	  for (rows = (height / 1); --rows >= 0; paste += (width / 1)) {
	    for (cols = width / 1 ; --cols >= 0; *paste++ = *mip0++);
	  }

	  noContinue = DisplayPicture(pic, Title, 2 * width, height, depth, wait);
	}
	else
	  noContinue = TRUE;
	tfree(mipmap);
      }
      else
        noContinue = TRUE;
      tfree(newpic);
    }
    else
      noContinue = TRUE;
  }
  else
    noContinue = DisplayPicture(pic, Title, width, height, depth, wait);

  return noContinue;
}

/*
 * TODO:
 *  parameter for dim, if 0 remove the static one, else remove the given
 */
void DisplayEnd(void) {
  if(inited) {
    CloseKeys(&actView->viewDim);
    CloseDisplay(&actView->viewDim);

    inited = FALSE;
  }
}
