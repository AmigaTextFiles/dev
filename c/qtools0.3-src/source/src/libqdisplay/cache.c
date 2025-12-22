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
#include "../include/libqdisplay.h"

struct texture **cachedFaces;

staticvar const struct {
  struct mipmap fakemip {
    'f','a','k','e','-','t','e','x','t','u','r','e',' ','.','.','.',
    0x10000000, 0x10000000,	/* LittleLong 16x16 */
    0x28000000, 0x28000000,
    0x28000000, 0x28000000	/* offsets into fakebody are 40 bytes */
  };
  unsigned char fakebody[256];	/* all black, can be something other */
} fakeTexture;

void InitFaceCache(bspBase bspMem)
{
  if (!(cachedFaces = (struct texture **)kmalloc(bspMem->shared.quake1.numfaces * sizeof(struct texture *))))
    Error(failed_memory, bspMem->shared.quake1.numfaces * sizeof(struct texture *), "face-cache");
}

staticfnc void GetMipMaps(bspBase bspMem, struct texture *Text, int TMipMap)
{
  struct dmiptexlump_t *mtl = (struct dmiptexlump_t *)bspMem->shared.quake1.dtexdata;
  struct mipmap *mip = (struct mipmap *)(bspMem->shared.quake1.dtexdata + mtl->dataofs[TMipMap]);
  char *mipname = mip->name;
  short int i;

  /* use default and faked texture if no texture available */
  if (mtl->dataofs[TMipMap] == -1)
    mip = &fakeTexture.fakemip;

  /* default is no animation */
  Text->animMax = 0;
  Text->animState = 0;
  
  /* animations behaviour is the same as that of the mipmaps below */
  if (isAnim(mipname)) {
    Text->textureType = ANIM_TYPE;
      
    /* register anim frames */
    for (i = 1; (i < MAX_ANIMFRAMES) && (i < bspMem->shared.quake1.numtexinfo); i++) {
      struct mipmap *animmip = (struct mipmap *)(bspMem->shared.quake1.dtexdata + mtl->dataofs[i + TMipMap]);
        
      /* look for */
      if (isAnim(animmip->name) && !__strcmp(mipname + 2, animmip->name + 2)) {
        Text->animMax++;
	Text->mipMaps[MIPMAP_0].rawBody.data[Text->animMax] = (unsigned char *)animmip + LittleLong(mip->offsets[MIPMAP_0]);
	Text->mipMaps[MIPMAP_1].rawBody.data[Text->animMax] = (unsigned char *)animmip + LittleLong(mip->offsets[MIPMAP_1]);
	Text->mipMaps[MIPMAP_2].rawBody.data[Text->animMax] = (unsigned char *)animmip + LittleLong(mip->offsets[MIPMAP_2]);
	Text->mipMaps[MIPMAP_3].rawBody.data[Text->animMax] = (unsigned char *)animmip + LittleLong(mip->offsets[MIPMAP_3]);
      }
    }
  }

#if 0
  /* possible? */
  if (isClip(mipname)) {
    Text->textureType = CLIP_TYPE;					/* can't be animatable */

    /* smallest possible mipmap */
    Text->mipMaps[MIPMAP_0].rawBody.width = 16;
    Text->mipMaps[MIPMAP_0].rawBody.height = 16;
    Text->mipMaps[MIPMAP_0].rawBody.size = 256;
    Text->mipMaps[MIPMAP_0].newBody.width = 16;
    Text->mipMaps[MIPMAP_0].newBody.height = 16;
    Text->mipMaps[MIPMAP_0].newBody.size = 256;
    Text->textGradient.u = 0;
    Text->textGradient.v = 0;
  }
  /* mirrors are generated dynamicaly in GetTMap */
  else if (isMirror(mipname)) {
    Text->textureType = MIRROR_TYPE;					/* can't be animatable */
  
    /* smallest possible mipmap */
    Text->mipMaps[MIPMAP_0].rawBody.width = 16;
    Text->mipMaps[MIPMAP_0].rawBody.height = 16;
    Text->mipMaps[MIPMAP_0].rawBody.size = 256;
    Text->mipMaps[MIPMAP_0].newBody.width = 16;
    Text->mipMaps[MIPMAP_0].newBody.height = 16;
    Text->mipMaps[MIPMAP_0].newBody.size = 256;
    Text->textGradient.u = Text->faceExtent.u0;
    Text->textGradient.v = Text->faceExtent.v0;
  }
  else
#endif
  if (isWarp(mipname)) {
    switch (isAnim(mipname) ? mipname[3] : mipname[1]) {
      case 'w':	Text->textureType |= WATER_TYPE;    break;		/* *w(ater),w(aves)... */
      case 's':	Text->textureType |= SLIME_TYPE;    break;		/* *s(lime),s(wamp)... */
      case 'l':	Text->textureType |= LAVA_TYPE;	    break;		/* *l(ava)... */
      case 't':	Text->textureType |= TELEPORT_TYPE; break;		/* *t(eleport),t(wirl)... */
      default:	Text->textureType |= OTHER_TYPE;    break;		/* *... */
    }
    Text->mipMaps[MIPMAP_0].rawBody.width = WARP_X;
    Text->mipMaps[MIPMAP_0].rawBody.height = WARP_Y;
    Text->mipMaps[MIPMAP_0].rawBody.size = WARP_X * WARP_Y;
    Text->mipMaps[MIPMAP_0].newBody.width = WARP_X;
    Text->mipMaps[MIPMAP_0].newBody.height = WARP_Y;
    Text->mipMaps[MIPMAP_0].newBody.size = WARP_X * WARP_Y;
    Text->textGradient.u = 0;
    Text->textGradient.v = 0;
  }
  else if (isSky(mipname)) {
    Text->textureType |= SKY_TYPE;
    Text->mipMaps[MIPMAP_0].rawBody.width = SKY_X;
    Text->mipMaps[MIPMAP_0].rawBody.height = SKY_Y;
    Text->mipMaps[MIPMAP_0].rawBody.size = SKY_X * SKY_Y;
    Text->mipMaps[MIPMAP_0].newBody.width = SKY_X;
    Text->mipMaps[MIPMAP_0].newBody.height = SKY_Y;
    Text->mipMaps[MIPMAP_0].newBody.size = SKY_X * SKY_Y;
    Text->textGradient.u = 0;
    Text->textGradient.v = 0;
  }
  else {
    Text->textureType |= WALL_TYPE;

    Text->mipMaps[MIPMAP_0].rawBody.width = LittleLong(mip->width);
    Text->mipMaps[MIPMAP_0].rawBody.height = LittleLong(mip->height);
    Text->mipMaps[MIPMAP_0].rawBody.size = Text->mipMaps[MIPMAP_0].rawBody.width * Text->mipMaps[MIPMAP_0].rawBody.height;
    Text->mipMaps[MIPMAP_0].newBody.width = Text->faceExtent.u10;
    Text->mipMaps[MIPMAP_0].newBody.height = Text->faceExtent.v10;
    Text->mipMaps[MIPMAP_0].newBody.size = Text->mipMaps[MIPMAP_0].newBody.width * Text->mipMaps[MIPMAP_0].newBody.height;
    Text->textGradient.u = Text->faceExtent.u0;
    Text->textGradient.v = Text->faceExtent.v0;
  }

  Text->mipMaps[MIPMAP_0].rawBody.data[0] = (unsigned char *)mip + LittleLong(mip->offsets[MIPMAP_0]);
  Text->mipMaps[MIPMAP_0].step = 16;
  Text->mipMaps[MIPMAP_0].shift = 4;
  Text->mipMaps[MIPMAP_0].row = Text->mipMaps[MIPMAP_0].newBody.width - Text->mipMaps[MIPMAP_0].step;
  if ((Text->mipMaps[MIPMAP_0].y = Text->faceExtent.v0 % Text->mipMaps[MIPMAP_0].rawBody.height) < 0)
    Text->mipMaps[MIPMAP_0].y += Text->mipMaps[MIPMAP_0].rawBody.height;
  if ((Text->mipMaps[MIPMAP_0].x0 = Text->faceExtent.u0 % Text->mipMaps[MIPMAP_0].rawBody.width) < 0)
    Text->mipMaps[MIPMAP_0].x0 += Text->mipMaps[MIPMAP_0].rawBody.width;
  Text->mipMaps[MIPMAP_0].rescale = scalw((double)(8), -3);	/* / 8.0; */

  for (i = MIPMAP_1; i < MIPMAP_MAX; i++) {			/* an enum cycles, produces no overflow */
    /* check against underflow? "1 >> 1 = 0" */
    Text->mipMaps[i].rawBody.data[0] = (unsigned char *)mip + LittleLong(mip->offsets[i]);
    Text->mipMaps[i].rawBody.width = Text->mipMaps[MIPMAP_0].rawBody.width >> i;
    Text->mipMaps[i].rawBody.height = Text->mipMaps[MIPMAP_0].rawBody.height >> i;
    Text->mipMaps[i].rawBody.size = Text->mipMaps[MIPMAP_0].rawBody.size >> i >> i;
    Text->mipMaps[i].newBody.width = Text->mipMaps[MIPMAP_0].newBody.width >> i;
    Text->mipMaps[i].newBody.height = Text->mipMaps[MIPMAP_0].newBody.height >> i;
    Text->mipMaps[i].newBody.size = Text->mipMaps[MIPMAP_0].newBody.size >> i >> i;
    Text->mipMaps[i].step = 16 >> i;
    Text->mipMaps[i].shift = 4 - i;
    Text->mipMaps[i].row = Text->mipMaps[i].newBody.width - Text->mipMaps[i].step;
    Text->mipMaps[i].rescale = scalw(Text->mipMaps[MIPMAP_0].rescale, -i);
    Text->mipMaps[i].y = Text->mipMaps[MIPMAP_0].y >> i;
    Text->mipMaps[i].x0 = Text->mipMaps[MIPMAP_0].x0 >> i;
  }

  {
    int j;
    int r = 0, g = 0, b = 0;
    struct rgb rgb;
    unsigned char *textFlow = Text->mipMaps[MIPMAP_0].rawBody.data[0];

    for (j = Text->mipMaps[MIPMAP_0].rawBody.size; j > 0; j--) {
      int k = (int)*textFlow++;

      r += cachedPalette[k].r;
      g += cachedPalette[k].g;
      b += cachedPalette[k].b;
    }
    rgb.r = r / Text->mipMaps[MIPMAP_0].rawBody.size;
    rgb.g = g / Text->mipMaps[MIPMAP_0].rawBody.size;
    rgb.b = b / Text->mipMaps[MIPMAP_0].rawBody.size;
    Text->textureColor = (unsigned char)Match(&rgb, cachedPalette);
  }

  for (i = 0; i <= Text->animMax; i++) {
    if (!(Text->tiled[i] = (void *)kmalloc((Text->mipMaps[MIPMAP_0].newBody.size + 1) * localDim.frameBPP)))
      Error(failed_memory, (Text->mipMaps[MIPMAP_0].newBody.size + 1) * localDim.frameBPP, mipname);
    Text->texChanged[i] = TRUE;					/* be very safe */
  }
}

staticfnc void GetExtents(bspBase bspMem, int face, struct texture *Text, int TInfo)
{
  vec1D uv[32][2], *u, *v, umin, umax, vmin, vmax;
  short int i, n = bspMem->shared.quake1.dfaces[face].numedges;
  int *se = &bspMem->shared.quake1.dsurfedges[bspMem->shared.quake1.dfaces[face].firstedge + n];

  u = bspMem->shared.quake1.texinfo[TInfo].vecs[0];
  v = bspMem->shared.quake1.texinfo[TInfo].vecs[1];

  for (i = n - 1; i >= 0; --i) {
    int j = *--se;
    vec1D *loc;

    if (j < 0)
      loc = bspMem->shared.quake1.dvertexes[bspMem->shared.quake1.dedges[-j].v[1]].point;
    else
      loc = bspMem->shared.quake1.dvertexes[bspMem->shared.quake1.dedges[ j].v[0]].point;

    uv[i][0] = DotProduct(loc, u) + u[3];
    uv[i][1] = DotProduct(loc, v) + v[3];
  }
  umin = umax = uv[0][0];
  vmin = vmax = uv[0][1];
  for (i = n - 1; i >= 0; --i) {
    if (uv[i][0] < umin)
      umin = uv[i][0];
    if (uv[i][0] > umax)
      umax = uv[i][0];
    if (uv[i][1] < vmin)
      vmin = uv[i][1];
    if (uv[i][1] > vmax)
      vmax = uv[i][1];
  }

  Text->faceExtent.u0 = (int)(umin) & ~15;
  Text->faceExtent.v0 = (int)(vmin) & ~15;
  Text->faceExtent.u1 = (int)(ceil(scalw(umax, -4))) << 4;	/* / 16 */
  Text->faceExtent.v1 = (int)(ceil(scalw(vmax, -4))) << 4;	/* / 16 */
  Text->faceExtent.u10 = Text->faceExtent.u1 - Text->faceExtent.u0;
  Text->faceExtent.v10 = Text->faceExtent.v1 - Text->faceExtent.v0;

  if ((bspMem->shared.quake1.dfaces[face].lightofs != -1) && (bspMem->shared.quake1.lightdatasize)) {
    Text->lightdata = &bspMem->shared.quake1.dlightdata[bspMem->shared.quake1.dfaces[face].lightofs];

    Text->lightmap.width = ((Text->faceExtent.u10) >> 4) + 1;
    Text->lightmap.height = ((Text->faceExtent.v10) >> 4) + 1;
    Text->lightmap.size = Text->lightmap.width * Text->lightmap.height;
    if (!(Text->lightmap.data = (unsigned char *)kmalloc((Text->lightmap.size + 1) * sizeof(int))))
      Error(failed_memory, (Text->lightmap.size + 1) * sizeof(int), "lightmap");

    for (i = 0; i < MAXLIGHTMAPS; i++) {
      short int lightStyle;

      lightStyle = (short int)bspMem->shared.quake1.dfaces[face].styles[i];

      if (lightStyle == 255)
	break;
      if (lightStyle > 11)
	lightStyle = 0;

      Text->lightSString[i] = &lightstyleStrings[lightStyle][0];
      Text->lightSLength[i] = lightstyleLengths[lightStyle];
    }
  }
  else
    Text->lightdata = 0;

  for (i = 0; i <= Text->animMax; i++)
    Text->texChanged[i] = TRUE;					/* be very safe */
}

staticfnc void GetGradients(bspBase bspMem, int face, struct texture *Text, int TInfo)
{
  struct dplane_t *plane = Text->textGradient.plane = &bspMem->shared.quake1.dplanes[bspMem->shared.quake1.dfaces[face].planenum];
  vec1D dot, dot0, dot1;
  vec3D norm;
  vec1D *vec0 = bspMem->shared.quake1.texinfo[TInfo].vecs[0];
  vec1D *vec1 = bspMem->shared.quake1.texinfo[TInfo].vecs[1];
  short int i;

  CrossProduct(vec0, vec1, norm);

  dot = DotProduct(norm, plane->normal);

  if ((dot0 = -DotProduct(vec0, plane->normal) / dot))		/* for setup_uv_vector */
    VectorMA(vec0, dot0, norm, Text->textGradient.uv0);
  else
    VectorCopy(vec0, Text->textGradient.uv0);

  if ((dot1 = -DotProduct(vec1, plane->normal) / dot))		/* for setup_uv_vector */
    VectorMA(vec1, dot1, norm, Text->textGradient.uv1);
  else
    VectorCopy(vec1, Text->textGradient.uv1);

  VectorScale(norm, (plane->dist / dot), Text->textGradient.scaled);	/* for setup_origin_vector; */

  Text->textGradient.u -= vec0[3];
  Text->textGradient.v -= vec1[3];
  for (i = 0; i <= Text->animMax; i++)
    Text->texChanged[i] = TRUE;					/* be very safe */
}

struct texture *CacheFace(bspBase bspMem, int face)
{
  struct texture *Text;
  int TInfo = bspMem->shared.quake1.dfaces[face].texinfo;
  int TMipMap = bspMem->shared.quake1.texinfo[TInfo].miptex;
  short int i;

  if (!(Text = (struct texture *)kmalloc(sizeof(struct texture))))
    Error(failed_memory, sizeof(struct texture), "texture cache");

  GetExtents(bspMem, face, Text, TInfo);
  GetMipMaps(bspMem, Text, TMipMap);
  GetGradients(bspMem, face, Text, TInfo);
  for (i = 0; i <= Text->animMax; i++)
    Text->texChanged[i] = TRUE;					/* be very safe */

  return Text;
}
