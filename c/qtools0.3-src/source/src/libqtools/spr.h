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

/**********************************************************
 * This file must be identical in the spritegen directory *
 * and in the Quake directory, because it's used to       *
 * pass data from one to the other via .spr files.        *
 **********************************************************/

/*
 * -------------------------------------------------------
 *  This program generates .spr sprite package files.
 *  The format of the files is as follows:
 *
 *  dsprite_t file header structure
 *  <repeat dsprite_t.numframes times>
 *    <if spritegroup, repeat dspritegroup_t.numframes times>
 *      dspriteframe_t frame header structure
 *      sprite bitmap
 *    <else (single sprite frame)>
 *      dspriteframe_t frame header structure
 *      sprite bitmap
 *  <endrepeat>
 * -------------------------------------------------------
 */

#ifndef	SPR_H
#define	SPR_H

/*
 * ============================================================================
 * structures
 * ============================================================================
 */
#define	MAGIC_SPR_Q1	MKID('I','D','S','P')
#define	MAGIC_SPR_Q2	MKID('I','D','S','2')

#define SPR_VERSION_Q1	1
#define SPR_VERSION_Q2	2

#define	MAX_SKINNAME	64

/*
 * disk-structures
 */

#define SPR_VP_PARALLEL_UPRIGHT		0
#define SPR_FACING_UPRIGHT		1
#define SPR_VP_PARALLEL			2
#define SPR_ORIENTED			3
#define SPR_VP_PARALLEL_ORIENTED	4

struct dspriteframe_t {
  int origin[2];
  int width;
  int height;
};

struct dspriteframe2_t {
  int width, height;
  int origin_x, origin_y;						       /* raster coordinates inside pic */
  char name[MAX_SKINNAME];						       /* name of pcx file */
};

/* TODO: shorten these? */
struct dsprite_t {
  int ident;
  int version;
  int type;
  float boundingradius;
  int width;
  int height;
  int numframes;
  float beamlength;
  synctype_t synctype;
};

struct dsprite2_t {
  int ident;
  int version;
  int numframes;
  struct dspriteframe2_t frames[0];						       /* variable sized */
};

struct dspritegroup_t {
  int numframes;
};

struct dspriteinterval_t {
  float interval;
};

enum spriteframetype {
  SPR_SINGLE = 0, SPR_GROUP
};

struct dspriteframetype_t {
  enum spriteframetype type;
};

struct spritepackage {
  enum spriteframetype type;						       /* single frame or group of frames */
  void *pdata;								       /* either a dspriteframe_t or group info */
  vec1D interval;							       /* only used for frames in groups */
  int numgroupframes;							       /* only used by group headers */
};

/*
 * ============================================================================
 * globals
 * ============================================================================
 */

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */

#endif
