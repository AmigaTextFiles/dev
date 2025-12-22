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

#ifndef	GRAPHICS_H
#define	GRAPHICS_H
#include "script.h"

/*
 * ============================================================================
 * structures
 * ============================================================================
 */

struct palpic {
  char *name;
  short int width, height;
  struct rgb *palette;
  
  union {
    struct {
      bool compress;
    } ILBM;
    struct {
      short int quality;
    } JPEG;
    struct {
    } PNG;
    struct {
    } wal;
  } options;
  
  unsigned char rawdata[0];
} __packed;

struct rawpic {
  char *name;
  short int width, height;
  struct rgb rawdata[0];
} __packed;

struct lump {
  int width, height;
  unsigned char rawdata[0];
} __packed;

/*
 * ============================================================================
 * globals
 * ============================================================================
 */

extern bool dither;
extern short int dithervalue;
extern bool smoothing;
extern short int smoothingvalue;
extern HANDLE palFile;
extern HANDLE colrFile;
extern short int darkness, transparency;
extern struct rgb *cachedPalette;
extern unsigned char *cachedColormap;
extern unsigned char *cachedTransparency;

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */

struct palpic *pmalloc(register short int width, register short int height, register struct rgb *palette, register char *picName);
bool pfree(register struct palpic *Picture);

unsigned char *GetTransparency(int transVal);
struct rgb *GetDarkness(struct rgb *Palette);
struct rgb *GetPalette(void);
bool RemapPalettes(unsigned char *dataBody, int dataSize, struct rgb *oldPalette, struct rgb *newPalette);

struct palpic *GetImage(FILE * file, char *picName, short int alignX, short int alignY);
bool PutImage(FILE * file, struct palpic *Picture, filetype picType);
struct palpic *GetLMP(register HANDLE file, register char *lmpName);
struct palpic *ParseLMP(register struct lump *Lump, register char *lmpName);
bool PutLMP(register HANDLE file, register struct palpic *Picture);
bool PasteLMP(register struct lump *Lump, register struct palpic *Picture);

#endif
