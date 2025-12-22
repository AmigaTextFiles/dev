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

#ifndef	CACHE_H
#define	CACHE_H

   /*
    * I think this is the best point to implement an _effective_ cache
    * the brute force method fills in an array of "struct cachedface *faceCache[numfaces][MIPMAP_MAX]"
    * next step: the definition of an cacheface holds the different mip-sizes
    */

struct animbitmap {
  short int width, height;					/* */
  int size;							/* */
  unsigned char *data[MAX_ANIMFRAMES];				/* always 8bit indexed datas */
};

struct bitmap {
  short int width, height;					/* */
  int size;							/* */
  unsigned char *data;						/* always 8bit indexed datas */
};

struct bitdim {
  short int width, height;					/* */
  int size;							/* */
};

struct faceextent {
  int u0, u1;							/* u0 is also the u for texture-gradients (except water/sky/..) */
  int v0, v1;							/* v0 is also the v for texture-gradients (except water/sky/..) */
  int u10, v10;							/* */
};

struct textgradient {
  vec1D u, v;							/* same as u0/v0 or 0 subtracted by vec[j][3] */
  vec3D uv0, uv1;						/* */
  vec3D scaled;							/* */
  struct dplane_t *plane;					/* textures plane */
};

struct fastmipmap {
  struct animbitmap rawBody;					/* */
  struct bitdim newBody;					/* */
  int step, shift, row;						/* */
  int y, x0;							/* */
  double rescale;						/* (8 >> mip) / 8.0 */
};

struct texture {
  bool texChanged[MAX_ANIMFRAMES];				/* interface to dynamic changing and updating */
  short int lastMip;						/*  */

  short int textureType;					/* the type of texture (constant) */
  unsigned char textureColor;					/* flat-color of the texture */
  char animState, animMax;					/* anim */
  struct fastmipmap mipMaps[MIPMAP_MAX];			/* four sizes and four pointer to the textures (allmost constant, except for animating textures) */

  short int *lightSString[MAXLIGHTMAPS];			/* the type of lighting (points directly into the lightstringtable) */
  short int lightSLength[MAXLIGHTMAPS];				/* the type of lighting (points directly into the lightlengthtable) */
  struct bitmap lightmap;					/* the buffer for holding the lightmap (constant size) */
  unsigned char *lightdata;					/* the raw lightmap (always 8bit alpha) */

  struct faceextent faceExtent;
  struct textgradient textGradient;

  void *tiled[MAX_ANIMFRAMES];					/* the buffer for holding the temporary datas in 8, 16 or 24 bit */
};

   /*
    */

extern struct texture **cachedFaces;

void InitFaceCache(bspBase bspMem);
struct texture *CacheFace(bspBase bspMem, int face);
void UnCacheFace(bspBase bspMem, int face);

extern inline struct texture *GetCache(bspBase bspMem, int face);
extern inline struct texture *GetCache(bspBase bspMem, int face)
#ifndef	PROFILE
{
  struct texture *ret;

  if (!(ret = cachedFaces[face]))
    ret = cachedFaces[face] = CacheFace(bspMem, face);

  return ret;
}
#endif
;

#endif
