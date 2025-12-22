/*******************************************************************************

 LayGroup.mcc - An automatic IMAGE_SMILEY arranger layout MUI Custom Class
 Copyright (C) 1997-1999 by Alessandro Zummo
 Copyright (C) 2008      by LayGroup.mcc Open Source Team

 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.

 LayGroup class Support Site: http://sourceforge.net/projects/laygroup-mcc

 $Id:$

*******************************************************************************/

#ifndef LAYGROUP_IMAGE_SMILEY_H
#define LAYGROUP_IMAGE_SMILEY_H

#include <exec/types.h>
#include <libraries/mui.h>
#include <datatypes/pictureclass.h>

#define LAYGROUP_IMAGE_SMILEY_WIDTH        46
#define LAYGROUP_IMAGE_SMILEY_HEIGHT       46
#define LAYGROUP_IMAGE_SMILEY_DEPTH         8
#define LAYGROUP_IMAGE_SMILEY_COMPRESSION   1
#define LAYGROUP_IMAGE_SMILEY_MASKING       0

extern const ULONG LAYGROUP_IMAGE_SMILEY_COLORS[];
extern const struct BitMapHeader LAYGROUP_IMAGE_SMILEY_HEADER;
extern const UBYTE LAYGROUP_IMAGE_SMILEY_BODY[];

#define LAYGROUP_IMAGE_SMILEY \
   BodychunkObject,\
      MUIA_FixWidth,              LAYGROUP_IMAGE_SMILEY_WIDTH,\
      MUIA_FixHeight,             LAYGROUP_IMAGE_SMILEY_HEIGHT,\
      MUIA_Bitmap_Width,          LAYGROUP_IMAGE_SMILEY_WIDTH ,\
      MUIA_Bitmap_Height,         LAYGROUP_IMAGE_SMILEY_HEIGHT,\
      MUIA_Bodychunk_Depth,       LAYGROUP_IMAGE_SMILEY_DEPTH,\
      MUIA_Bodychunk_Body,        (UBYTE *) LAYGROUP_IMAGE_SMILEY_BODY,\
      MUIA_Bodychunk_Compression, LAYGROUP_IMAGE_SMILEY_COMPRESSION,\
      MUIA_Bodychunk_Masking,     LAYGROUP_IMAGE_SMILEY_MASKING,\
      MUIA_Bitmap_SourceColors,   (ULONG *) LAYGROUP_IMAGE_SMILEY_COLORS,\
      MUIA_Bitmap_Transparent,    0,\
      End

#endif /* LAYGROUP_IMAGE_SMILEY_H */

