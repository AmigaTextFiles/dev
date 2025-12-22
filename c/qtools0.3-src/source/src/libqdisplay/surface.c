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

#define	LIBQDISPLAY_CORE
#define	LIBQTOOLS_CORE
#define	LIBQBUILD_CORE
#include "../include/libqdisplay.h"

/* lightmap related */
staticvar int row, lightmapWidth, step, shift;
staticvar int *lightmapIndex;

#ifdef	DRIVER_8BIT
#include "surface8.c"
#endif
#ifdef	DRIVER_16BIT
#include "surface16.c"
#endif
#ifdef	DRIVER_24BIT
#include "surface24.c"
#endif
#ifdef	DRIVER_32BIT
#endif

short int lightstyleStrings[16][64] =
{
  /* 0 normal */
  /* "m", */
  {12 * 22 >> 2},

  /* 1 FLICKER (first variety) */
  /* "mmnmmommommnonmmonqnmmo", */
  {12 * 22 >> 2, 12 * 22 >> 2, 13 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 14 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 14 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 13 * 22 >> 2, 14 * 22 >> 2,
   13 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 14 * 22 >> 2, 13 * 22 >> 2, 16 * 22 >> 2, 13 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 14 * 22 >> 2},

  /* 2 SLOW STRONG PULSE */
  /* "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba", */
  {0 * 22 >> 2, 1 * 22 >> 2, 2 * 22 >> 2, 3 * 22 >> 2, 4 * 22 >> 2, 5 * 22 >> 2, 6 * 22 >> 2, 7 * 22 >> 2, 8 * 22 >> 2, 9 * 22 >> 2, 10 * 22 >> 2, 11 * 22 >> 2, 12 * 22 >> 2, 13 * 22 >> 2, 14 * 22 >> 2,
   15 * 22 >> 2, 16 * 22 >> 2, 17 * 22 >> 2, 18 * 22 >> 2, 19 * 22 >> 2, 20 * 22 >> 2, 21 * 22 >> 2, 22 * 22 >> 2, 23 * 22 >> 2, 24 * 22 >> 2, 25 * 22 >> 2, 24 * 22 >> 2, 23 * 22 >> 2,
   22 * 22 >> 2, 21 * 22 >> 2, 20 * 22 >> 2, 19 * 22 >> 2, 18 * 22 >> 2, 17 * 22 >> 2, 16 * 22 >> 2, 15 * 22 >> 2, 14 * 22 >> 2, 13 * 22 >> 2, 12 * 22 >> 2, 11 * 22 >> 2, 10 * 22 >> 2,
   9 * 22 >> 2, 8 * 22 >> 2, 7 * 22 >> 2, 6 * 22 >> 2, 5 * 22 >> 2, 4 * 22 >> 2, 3 * 22 >> 2, 2 * 22 >> 2, 1 * 22 >> 2, 0 * 22 >> 2},

  /* 3 CANDLE (first variety) */
  /* "mmmmmaaaaammmmmaaaaaabcdefgabcdefg", */
  {12 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2,
   12 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 01 * 22 >> 2, 02 * 22 >> 2, 03 * 22 >> 2, 04 * 22 >> 2, 05 * 22 >> 2,
   06 * 22 >> 2, 00 * 22 >> 2, 01 * 22 >> 2, 02 * 22 >> 2, 03 * 22 >> 2, 04 * 22 >> 2, 05 * 22 >> 2, 06 * 22 >> 2},

  /* 4 FAST STROBE */
  /* "mamamamamama", */
  {12 * 22 >> 2, 00 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2},

  /* 5 GENTLE PULSE 1 */
  /* "jklmnopqrstuvwxyzyxwvutsrqponmlkj", */
  {9 * 22 >> 2, 10 * 22 >> 2, 11 * 22 >> 2, 12 * 22 >> 2, 13 * 22 >> 2, 14 * 22 >> 2, 15 * 22 >> 2, 16 * 22 >> 2, 17 * 22 >> 2, 18 * 22 >> 2, 19 * 22 >> 2, 20 * 22 >> 2, 21 * 22 >> 2, 22 * 22 >> 2,
   23 * 22 >> 2, 24 * 22 >> 2, 25 * 22 >> 2, 24 * 22 >> 2, 23 * 22 >> 2, 22 * 22 >> 2, 21 * 22 >> 2, 20 * 22 >> 2, 19 * 22 >> 2, 18 * 22 >> 2, 17 * 22 >> 2, 16 * 22 >> 2, 15 * 22 >> 2, 14 * 22 >> 2,
   13 * 22 >> 2, 12 * 22 >> 2, 11 * 22 >> 2, 10 * 22 >> 2, 9 * 22 >> 2},

  /* 6 FLICKER (second variety) */
  /* "nmonqnmomnmomomno", */
  {13 * 22 >> 2, 12 * 22 >> 2, 14 * 22 >> 2, 13 * 22 >> 2, 16 * 22 >> 2, 13 * 22 >> 2, 12 * 22 >> 2, 14 * 22 >> 2, 12 * 22 >> 2, 13 * 22 >> 2, 12 * 22 >> 2, 14 * 22 >> 2, 12 * 22 >> 2, 14 * 22 >> 2,
   12 * 22 >> 2, 13 * 22 >> 2, 14 * 22 >> 2},

  /* 7 CANDLE (second variety) */
  /* "mmmaaaabcdefgmmmmaaaammmaamm", */
  {12 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 01 * 22 >> 2, 02 * 22 >> 2, 03 * 22 >> 2, 04 * 22 >> 2, 05 * 22 >> 2, 06 * 22 >> 2, 12 * 22 >> 2,
   12 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2},

  /* 8 CANDLE (third variety) */
  /* "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa", */
  {12 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2,
   12 * 22 >> 2, 00 * 22 >> 2, 01 * 22 >> 2, 02 * 22 >> 2, 03 * 22 >> 2, 04 * 22 >> 2, 05 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2,
   12 * 22 >> 2, 00 * 22 >> 2, 01 * 22 >> 2, 02 * 22 >> 2, 03 * 22 >> 2, 04 * 22 >> 2, 05 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2},

  /* 9 SLOW STROBE (fourth variety) */
  /* "aaaaaaaazzzzzzzz", */
  {00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 25 * 22 >> 2, 25 * 22 >> 2, 25 * 22 >> 2, 25 * 22 >> 2, 25 * 22 >> 2, 25 * 22 >> 2,
   25 * 22 >> 2, 25 * 22 >> 2},

  /* 10 FLUORESCENT FLICKER */
  /* "mmamammmmammamamaaamammma", */
  {12 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 12 * 22 >> 2,
   00 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 00 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 12 * 22 >> 2, 00 * 22 >> 2},

  /* 11 SLOW PULSE NOT FADE TO BLACK */
  /* "abcdefghijklmnopqrrqponmlkjihgfedcba" */
  {0 * 22 >> 2, 1 * 22 >> 2, 2 * 22 >> 2, 3 * 22 >> 2, 4 * 22 >> 2, 5 * 22 >> 2, 6 * 22 >> 2, 7 * 22 >> 2, 8 * 22 >> 2, 9 * 22 >> 2, 10 * 22 >> 2, 11 * 22 >> 2, 12 * 22 >> 2, 13 * 22 >> 2, 14 * 22 >> 2, 15 * 22 >> 2,
   16 * 22 >> 2, 17 * 22 >> 2, 17 * 22 >> 2, 16 * 22 >> 2, 15 * 22 >> 2, 14 * 22 >> 2, 13 * 22 >> 2, 12 * 22 >> 2, 11 * 22 >> 2, 10 * 22 >> 2, 9 * 22 >> 2, 8 * 22 >> 2, 7 * 22 >> 2, 6 * 22 >> 2, 5 * 22 >> 2,
   4 * 22 >> 2, 3 * 22 >> 2, 2 * 22 >> 2, 1 * 22 >> 2, 0 * 22 >> 2}
};

int lightstyleLengths[11] =
{
  1, 23, 51, 33, 12, 17, 28, 42, 16, 25, 36
};

/*
 * void UpdateDisplayII(void *oldBuffer, short int x, short int y, short int width, short int height) {
 *   int spanCount, spanSize;
 *   unsigned short int *spanOut = localDim.frameBuffer;
 *   unsigned short int *spanIn = oldBuffer;
 * 
 *   spanOut += (y * localDim.Width) + (x);
 * 
 *   if((width + x) > localDim.Width)
 *     spanSize = localDim.Width - x;
 *   else
 *     spanSize = width;
 * 
 *   if((height + y) > localDim.Height)
 *     spanCount = localDim.Height - y;
 *   else
 *     spanCount = height;
 * 
 *   for(; spanCount >= 0; spanCount--, spanOut += localDim.Width, spanIn += width)
 *     memcpy(spanOut, spanIn, spanSize);
 * 
 *   SwapDisplay(localDim.frameBuffer);
 * }    
 */

/* location of mirror-calculation */
staticvar vec3D mirrorLocation = {0,0,0};
/* we need a hole copy of the old state to calculate a new view :(  *
 * but which? everything? maybe change the API for multiple cameras */

void GetTMap(bspBase bspMem, struct texture *Text, short int mip)
{
  int i, j, x, y, x0, rows, lines;
  unsigned char *lightmap;
  int *lightindex;
  struct fastmipmap *fastMM;
  displaypointer data;

  if (++Text->animState > Text->animMax)
    Text->animState = 0;

  fastMM = &Text->mipMaps[mip];
  textureType = Text->textureType & (~ANIM_TYPE);	/* filter out animation */
  textureColor = Text->textureColor;
  
  /* flat or wire dont need texture-informations */
  if(actView->displayType != DISPLAY_TEXTURED)
    return;

  /* skies have no lighting infos, and are not mipmapped */
  /* and can be animated */
  if (textureType == SKY_TYPE) {
    rows = Text->mipMaps[MIPMAP_0].rawBody.width;
    if (Text->mipMaps[MIPMAP_0].newBody.width == rows) {
      Text->mipMaps[MIPMAP_0].newBody.width = ~rows;		/* identifier for first converted face-sky */
#ifdef	DRIVER_8BIT
      if (localDim.frameDepth <= 8)
	BuildSky8(Text->tiled[Text->animState], Text->mipMaps[MIPMAP_0].rawBody.data);
      else
#endif
#ifdef	DRIVER_16BIT
      if (localDim.frameDepth <= 16)
	BuildSky16(Text->tiled[Text->animState], Text->mipMaps[MIPMAP_0].rawBody.data);
      else
#endif
#ifdef	DRIVER_24BIT
      if (localDim.frameDepth <= 24)
	BuildSky24(Text->tiled[Text->animState], Text->mipMaps[MIPMAP_0].rawBody.data);
      else
#endif
#ifdef	DRIVER_32BIT
#endif
	;
    }
    Text->texChanged[Text->animState] = FALSE;
  }
  /*
   * implement mirrors here:
   *  -the possibly mirror is visible
   * check if the mirror-buffer is allready rendered
   * if not so, calculate a miplevel-dependent sized mirror-buffer
   */

  /* non-walls can have lighting info, but no special properties in size */
  /* and can be animated */
  else if (!((textureType == WALL_TYPE) || (textureType == ANIM_TYPE))) {
    rows = fastMM->rawBody.width;
    lines = fastMM->rawBody.height;
    textureMask1 = ((rows - 1) << WARP_SHIFT) >> mip;
    textureMask2 = (rows - 1) >> mip;
    textureShift1 = 16 - WARP_SHIFT + mip;
    textureShift2 = 16 - mip;

#ifdef	DRIVER_8BIT
#ifdef	FAST_WARP
    swim_u = swim_um[mip];
    swim_v = swim_vm[mip];
#endif
    switch (textureType) {
      case WATER_TYPE:    preTransparency = waterTransparency; break;	/* 50 */
      case SLIME_TYPE:    preTransparency = slimeTransparency; break;	/* 75 */
      case LAVA_TYPE:     preTransparency = lavaTransparency;  break;	/* 90 */
      case TELEPORT_TYPE:
      case OTHER_TYPE:
      default:            preTransparency = teleTransparency;  break;	/* 100 */
    }
#endif
  }
  /* walls are the most complex */
  /* and can be animated */
  else {
    rows = fastMM->newBody.width;
    lines = fastMM->newBody.height;
  }
  textureRow = rows;

#ifdef	DRIVER_8BIT
  if (localDim.frameDepth <= 8)
    texture.indexed = data.indexed = (unsigned char *)Text->tiled[Text->animState];
  else
#endif
#ifdef	DRIVER_16BIT
  if (localDim.frameDepth <= 16)
    texture.hicolor = data.hicolor = (unsigned short int *)Text->tiled[Text->animState];
  else
#endif
#ifdef	DRIVER_24BIT
  if (localDim.frameDepth <= 24)
    texture.truecolor = data.truecolor = (struct rgb *)Text->tiled[Text->animState];
  else
#endif
#ifdef	DRIVER_32BIT
#endif
    ;

  if (Text->texChanged[Text->animState]) {
    Text->texChanged[Text->animState] = FALSE;

    step = fastMM->step;
    shift = fastMM->shift;
    row = fastMM->row;

    y = fastMM->y;
    x0 = fastMM->x0;

    /* this could be if we have no lightinformation, or if the face emits no light */
    if (!(lightmap = Text->lightdata)) {
#ifdef	DRIVER_8BIT
      if (localDim.frameDepth <= 8) {
	if ((bspMem->shared.quake1.lightdatasize) && (textureType == WALL_TYPE))
	  brightColormap = &cachedColormap[0x0003D00];		/* standard ambient */
	else
	  brightColormap = &cachedColormap[0x0001F00];		/* full bright (no lights), for waters etc. and if no lightinfo */
      }
      else
#endif
#if defined(DRIVER_16BIT) || defined(DRIVER_24BIT) || defined(DRIVER_32BIT)
      {
	if ((bspMem->shared.quake1.lightdatasize) && (textureType == WALL_TYPE))
	  brightColorshift = 1;					/* standard ambient */
	else
	  brightColorshift = 0;					/* full bright (no lights), for waters etc. and if no lightinfo */
      }
#endif
      ;

      for (j = 0; j < lines; j += step) {
	x = x0;
	for (i = 0; i < rows; i += step) {
#ifdef	DRIVER_8BIT
	  if (localDim.frameDepth <= 8)
	    BuildBrightBlock8((data.indexed + lookup(j, rows) + i), &fastMM->rawBody, x, y);
	  else
#endif
#ifdef	DRIVER_16BIT
	  if (localDim.frameDepth <= 16)
	    BuildBrightBlock16((data.hicolor + lookup(j, rows) + i), &fastMM->rawBody, x, y);
	  else
#endif
#ifdef	DRIVER_24BIT
	  if (localDim.frameDepth <= 24)
	    BuildBrightBlock24((data.truecolor + lookup(j, rows) + i), &fastMM->rawBody, x, y);
	  else
#endif
#ifdef	DRIVER_32BIT
#endif
	    ;
	  x += step;
	  if (x >= fastMM->rawBody.width)
	    x -= fastMM->rawBody.width;
	}
	y += step;
	if (y >= fastMM->rawBody.height)
	  y -= fastMM->rawBody.height;
      }
    }
    else {
      /*
       * so, we need a framecounter, the lights state is "lightstate = lighttable[lightstyle][framecounter % strlen(lighttable[lightstyle])]"
       * lighttable is an array into the lightstyle-strings
       * we have 26 different chars (a - z), a is total darkness and z is maxbright, m (12) is fullbright
       * we need a double calculated as "(lightstate - 'a') / 12.0" (0.0-2.16) or as "(lightstate - 'a') * 21.25"
       * normal brightness is 0x1F, so "0x1F * 0.0 = 0" and "0x1F * 2.16 ~= 0x3F"
       */
      lightmapWidth = Text->lightmap.width;
      lightmapIndex = (int *)Text->lightmap.data;
      __bzero(lightmapIndex, Text->lightmap.size * sizeof(int));

      for (j = 0; (j < MAXLIGHTMAPS); j++) {			/* max 4 */
	int lightState;
	short int *lightStyle;

	if (!(lightStyle = Text->lightSString[j]))
	  break;
	if (Text->lightSLength[j] > 1)				/* dynamic texture changing, next frame must also be processed by this routine */
	  Text->texChanged[Text->animState] = TRUE;		/* if the string is only one pattern long, there is no changing from frame to frame */

	lightState = lightStyle[frameCounter % Text->lightSLength[j]];
	lightindex = lightmapIndex;

	for (i = 0; i < Text->lightmap.size; i++)
	  *lightindex++ += (*lightmap++ * lightState);		/* all the light-styles */
      }

      lightindex = lightmapIndex;
      for (i = 0; i < Text->lightmap.size; i++) {		/* over- and underflow-correction */
	int sum = *lightindex + (10 << 6);			/* ambient light */

	if (sum > (255 << 6))					/* 64 = 1<<6 light-values */
	  sum = (255 << 6);
	else if (sum < (0 << 6))
	  sum = (0 << 6);

	*lightindex++ = sum;
      }

      for (j = 0; j < lines; j += step) {
	x = x0;
	for (i = 0; i < rows; i += step, ++lightmapIndex) {
#ifdef	DRIVER_8BIT
	  if (localDim.frameDepth <= 8)
	    BuildLightBlock8((data.indexed + lookup(j, rows) + i), &fastMM->rawBody, x, y);
	  else
#endif
#ifdef	DRIVER_16BIT
	  if (localDim.frameDepth <= 16)
	    BuildLightBlock16((data.hicolor + lookup(j, rows) + i), &fastMM->rawBody, x, y);
	  else
#endif
#ifdef	DRIVER_24BIT
	  if (localDim.frameDepth <= 24)
	    BuildLightBlock24((data.truecolor + lookup(j, rows) + i), &fastMM->rawBody, x, y);
	  else
#endif
#ifdef	DRIVER_32BIT
#endif
	    ;
	  x += step;
	  if (x >= fastMM->rawBody.width)
	    x -= fastMM->rawBody.width;
	}
	++lightmapIndex;
	y += step;
	if (y >= fastMM->rawBody.height)
	  y -= fastMM->rawBody.height;
      }
    }
  }
}
