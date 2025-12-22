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
#include "../include/libqtools.h"

/*
 * MIP-tools
 */

struct palpic *GetMipMap(HANDLE file, enum mipmapoffset MipLevel)
{
  struct mipmap MipMap;
  struct palpic *Picture = 0;

  __read(file, &MipMap, sizeof(struct mipmap));

  if ((Picture = pmalloc(LittleLong(MipMap.width) >> MipLevel, LittleLong(MipMap.height) >> MipLevel, 0, MipMap.name))) {
    __lseek(file, LittleLong(MipMap.offsets[MipLevel]) - sizeof(struct mipmap), SEEK_CUR);
    __read(file, Picture->rawdata, Picture->width * Picture->height);
  }

  return Picture;
}

struct palpic *ParseMipMap(struct mipmap *MipMap, enum mipmapoffset MipLevel)
{
  struct palpic *Picture = 0;

  if ((Picture = pmalloc(LittleLong(MipMap->width) >> MipLevel, LittleLong(MipMap->height) >> MipLevel, 0, MipMap->name))) {
    __memcpy(Picture->rawdata, ((char *)MipMap) + LittleLong(MipMap->offsets[MipLevel]),
	     Picture->width * Picture->height);
  }

  return Picture;
}

/*
 * returns the offset or -1 for fail 
 */
bool PutMipMap(HANDLE file, struct palpic * Picture)
{
  struct mipmap MipMap;
  int MipMapSize;
  unsigned char *MipBody;
  bool retval = FALSE;

  /*
   * fix!!! OP_UPDATE offsets ??? 
   */
  MipMapSize = Picture->width * Picture->height;
  if ((MipBody = (unsigned char *)tmalloc(MipMapSize))) {
    short int x, y, num, dwidth = 1, dheight = 1, dshift = 1;
    unsigned char *bodySrc, *bodyDst;
    struct rgb *Palette = Picture->palette;

    __strncpy(MipMap.name, Picture->name, NAMELEN_MIP);
    MipMap.height = LittleLong(Picture->height);
    MipMap.width = LittleLong(Picture->width);

    MipMap.offsets[MIPMAP_0] = LittleLong(sizeof(struct mipmap));
    MipMap.offsets[MIPMAP_1] = LittleLong(LittleLong(MipMap.offsets[MIPMAP_0]) + (MipMapSize / (1 * 1)));
    MipMap.offsets[MIPMAP_2] = LittleLong(LittleLong(MipMap.offsets[MIPMAP_1]) + (MipMapSize / (2 * 2)));
    MipMap.offsets[MIPMAP_3] = LittleLong(LittleLong(MipMap.offsets[MIPMAP_2]) + (MipMapSize / (4 * 4)));

    __write(file, &MipMap, sizeof(struct mipmap));
    __write(file, bodySrc = Picture->rawdata, MipMapSize);

    for (num = 0; num < 3; num++) {
      bodyDst = MipBody;
      dwidth <<= 1;
      dheight <<= 1;
      dshift++;
      for (y = 0; y < Picture->height; y += dheight) {
	for (x = 0; x < Picture->width; x += dwidth) {
	  short int dx, dy;
	  short int R = 0, G = 0, B = 0;
	  struct rgb rawpix;

	  for (dy = 0; dy < dheight; dy++) {
	    for (dx = 0; dx < dheight; dx++) {
	      short int palpix = (short int)bodySrc[((y + dy) * Picture->width) + x + dx];

	      R += (short int)Palette[palpix].r;
	      G += (short int)Palette[palpix].g;
	      B += (short int)Palette[palpix].b;
	    }
	  }
	  rawpix.r = (unsigned char)(R >> dshift);
	  rawpix.g = (unsigned char)(G >> dshift);
	  rawpix.b = (unsigned char)(B >> dshift);
	  *bodyDst++ = Match(&rawpix, Palette);
	}
      }
      __write(file, MipBody, MipMapSize / (dheight * dwidth));
      mprogress(3, num + 1);
    }
    tfree(MipBody);
    retval = TRUE;
  }
  else
    eprintf(failed_memory, MipMapSize, "mipmap");

  return retval;
}

bool PutMipMap0(HANDLE file, struct palpic * Picture)
{
  struct mipmap MipMap;

  __strncpy(MipMap.name, Picture->name, NAMELEN_MIP);
  MipMap.height = LittleLong(Picture->height);
  MipMap.width = LittleLong(Picture->width);

  MipMap.offsets[MIPMAP_0] = LittleLong(sizeof(struct mipmap));
  MipMap.offsets[MIPMAP_1] = 0;
  MipMap.offsets[MIPMAP_2] = 0;
  MipMap.offsets[MIPMAP_3] = 0;

  __write(file, &MipMap, sizeof(struct mipmap));
  __write(file, Picture->rawdata, Picture->width * Picture->height);

  return TRUE;
}

bool PasteMipMap(struct mipmap * MipMap, struct palpic * Picture)
{
  int MipMapSize;
  unsigned char *MipBody;
  bool retval = FALSE;

  /*
   * fix!!! OP_UPDATE offsets ??? 
   */
  MipMapSize = Picture->width * Picture->height;
  if ((MipBody = (unsigned char *)tmalloc(MipMapSize))) {
    short int x, y, num, dwidth = 1, dheight = 1, dshift = 1, pos;
    unsigned char *bodySrc, *bodyDst;
    struct rgb *Palette = Picture->palette;

    __strncpy(MipMap->name, Picture->name, NAMELEN_MIP);
    MipMap->height = LittleLong(Picture->height);
    MipMap->width = LittleLong(Picture->width);

    MipMap->offsets[MIPMAP_0] = LittleLong(sizeof(struct mipmap));
    MipMap->offsets[MIPMAP_1] = LittleLong(LittleLong(MipMap->offsets[MIPMAP_0]) + (MipMapSize / (1 * 1)));
    MipMap->offsets[MIPMAP_2] = LittleLong(LittleLong(MipMap->offsets[MIPMAP_1]) + (MipMapSize / (2 * 2)));
    MipMap->offsets[MIPMAP_3] = LittleLong(LittleLong(MipMap->offsets[MIPMAP_2]) + (MipMapSize / (4 * 4)));

    pos = sizeof(struct mipmap);
    __memcpy(((char *)MipMap) + pos, bodySrc = Picture->rawdata, MipMapSize);
    pos += MipMapSize;

    for (num = 0; num < 3; num++) {
      bodyDst = MipBody;
      dwidth <<= 1;
      dheight <<= 1;
      dshift++;
      for (y = 0; y < Picture->height; y += dheight) {
	for (x = 0; x < Picture->width; x += dwidth) {
	  short int dx, dy;
	  short int R = 0, G = 0, B = 0;
	  struct rgb rawpix;

	  for (dy = 0; dy < dheight; dy++) {
	    for (dx = 0; dx < dheight; dx++) {
	      short int palpix = (short int)bodySrc[((y + dy) * Picture->width) + x + dx];

	      R += (short int)Palette[palpix].r;
	      G += (short int)Palette[palpix].g;
	      B += (short int)Palette[palpix].b;
	    }
	  }
	  rawpix.r = (unsigned char)(R >> dshift);
	  rawpix.g = (unsigned char)(G >> dshift);
	  rawpix.b = (unsigned char)(B >> dshift);
	  *bodyDst++ = Match(&rawpix, Palette);
	}
      }
      __memcpy(((char *)MipMap) + pos, MipBody, MipMapSize / (dheight * dwidth));
      pos += MipMapSize / (dheight * dwidth);
      mprogress(3, num + 1);
    }
    tfree(MipBody);
    retval = TRUE;
  }
  else
    eprintf(failed_memory, MipMapSize, "mipmap");

  return retval;
}

bool PasteMipMap0(struct mipmap * MipMap, struct palpic * Picture)
{
  __strncpy(MipMap->name, Picture->name, NAMELEN_MIP);
  MipMap->height = LittleLong(Picture->height);
  MipMap->width = LittleLong(Picture->width);

  MipMap->offsets[MIPMAP_0] = LittleLong(sizeof(struct mipmap));
  MipMap->offsets[MIPMAP_1] = 0;
  MipMap->offsets[MIPMAP_2] = 0;
  MipMap->offsets[MIPMAP_3] = 0;

  __memcpy(((char *)MipMap) + sizeof(struct mipmap), Picture->rawdata, Picture->width * Picture->height);

  return TRUE;
}
