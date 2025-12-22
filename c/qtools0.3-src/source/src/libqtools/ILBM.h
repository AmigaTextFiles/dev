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

#ifndef	ILBM_H
#define	ILBM_H

/*
 * ============================================================================
 * structures
 * ============================================================================
 */

/* definitions for BMHD */
struct BitMapHeader {
  unsigned short w, h;
  short x, y;
  unsigned char nPlanes, masking, compression, pad1;
  unsigned short transparentColor;
  unsigned char xAspect, yAspect;
  short pageWidth, pageHeight;
};

#define mskNone                 0
#define mskHasMask              1
#define mskHasTransparentColor  2
#define mskLasso                3

#define cmpNone                 0
#define cmpByteRun1             1

/* definitions for CAMG */
#define vmLACE                  0x0004				/* not used */
#define vmEXTRA_HALFBRITE       0x0080
#define vmHAM	                0x0800
#define vmHIRES         	0x8000				/* not used */

#define HAMCODE_CMAP   	        0				/* look up color in colormap */
#define HAMCODE_BLUE   	        1				/* new blue component */
#define HAMCODE_RED    	        2				/* new red component */
#define HAMCODE_GREEN	        3				/* new green component */

/* multipalette PCHG chunk definitions */
struct PCHGHeader {
  unsigned short Compression;
  unsigned short Flags;
  short StartLine;						/* may be negative */
  unsigned short LineCount;
  unsigned short ChangedLines;
  unsigned short MinReg;
  unsigned short MaxReg;
  unsigned short MaxChanges;
  unsigned long TotalChanges;
};

/* Compression modes */
#define PCHG_COMP_NONE      0
#define PCHG_COMP_HUFFMAN   1

/* Flags */
#define PCHGF_12BIT         (1 << 0)				/* use SmallLineChanges */
#define PCHGF_32BIT         (1 << 1)				/* use BigLineChanges */
#define PCHGF_USE_ALPHA     (1 << 2)				/* meaningful only if PCHG_32BIT is on:
								 * use the Alpha channel info */
struct PCHGCompHeader {
  unsigned long CompInfoSize;
  unsigned long OriginalDataSize;
};

/*
 * the next three structures are used internally by ilbmtoppm
 * The PCHG BigLineChanges and SmallLineChanges are converted
 * to these structures
 */
struct PaletteChange {
  unsigned short Register;
  pixval Alpha, Red, Green, Blue;
};

struct LineChanges {
  unsigned short Count;
  PaletteChange *Palette;
};

struct PCHGInfo {
  PCHGHeader *PCHG;
  unsigned char *LineMask;
  LineChanges *Change;
  PaletteChange *Palette;
  pixval maxval;						/* maxval of colors in Palette */
  pixel *colormap;						/* original colormap */
  int colors;							/* colors in colormap */
};

#define	MAXBITPLANES	16
typedef unsigned short rawtype;

#define MAXCMAPCOLORS   (1 << MAXPLANES)
#define MAXCOLVAL       255					/* max value of color component */

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
