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

#ifndef	PAK_H
#define	PAK_H
/*
 * ============================================================================
 * structures
 * ============================================================================
 */

#define MAGIC_PACK	MKID('P','A','C','K')	/* 0x5041434B */

struct packheader {
  magick magic;
  /*
   * PACK 
   */
  int offset, size;
};

#define NAMELEN_PAK 0x38
struct packentry {
  char name[0x38];
  int offset, size;
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

bool AddPAK(struct palpic *inPic, struct rawdata *inData, char *pakName, operation procOper);
bool ExtractPAK(HANDLE file, FILE * script, char *destDir, char *entryName, unsigned char convert, operation procOper, bool recurse);
bool CheckPAK(HANDLE pakFile, struct packheader *Header, bool newWad);
struct packentry *FindPAK(HANDLE pakFile, char *entryName, struct packheader *Header, struct packentry **Entry);
struct packentry *SearchPAK(char *entryName, struct packheader *Header, struct packentry *allEntries);

#endif
