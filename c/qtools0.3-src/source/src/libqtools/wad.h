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

#ifndef	WAD_H
#define	WAD_H
/*
 * ============================================================================
 * structures
 * ============================================================================
 */

#define MAGIC_WAD2	MKID('W','A','D','2')	/* 0x57414432 */

struct wadheader {
  magick magic;
  /*
   * WAD2 
   */
  int numentries, offset;
};

#define NAMELEN_WAD 16
struct wadentry {
  int offset, wadsize, memsize;
  unsigned char type, compr;
  short int dummy;
  char name[16];
};

#define	CMP_NONE		0
/* bitdefs */
#define	CMP_LZSS		(1<<0)
#define	CMP_LZ77		(1<<1)				/* compressed with a LZ77 */
#define	CMP_BTPC		(1<<2)				/* compressed with a subtype of BTPC (lossless/lossy, 0-100) */
#define CMP_MIP0		(1<<3)				/* store only mip0 instead of all */
#define CMP_ALL			((1<<4)-1)

#define WAD2_PALETTE	'@'
#define WAD2_MIPMAP	'D'
#define WAD2_STATUSBAR	'B'
#define WAD2_CONPIC	'E'

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

struct palpic *GetWAD2Picture(HANDLE wadFile, struct wadentry *Entry);
struct rawdata *GetWAD2Raw(HANDLE wadFile, struct wadentry *Entry);
bool AddWAD2(struct palpic *inPic, struct rawdata *inData, char *wadName, operation procOper, filetype wadType);
bool ExtractWAD2(HANDLE file, FILE * script, char *destDir, char *entryName, unsigned char convert, operation procOper, filetype wadType);
bool CheckWAD2(HANDLE wadFile, struct wadheader *Header, bool newWad);
struct wadentry *FindWAD2(HANDLE wadFile, char *entryName, struct wadheader *Header, struct wadentry **Entry, filetype wadType);
struct wadentry *SearchWAD2(char *entryName, struct wadheader *Header, struct wadentry *allEntries, filetype wadType);

#endif
