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

#ifndef	SCRIPT_H
#define	SCRIPT_H

/*
 * ============================================================================
 * structures
 * ============================================================================
 */
typedef enum {
  OP_ADD = 'a',
  OP_DEFAULT = '?',
  OP_DELETE = 'd',
  OP_EXTRACT = 'e',
  OP_LIST = 'l',
  OP_REPLACE = 'r',
  OP_UPDATE = 'u',
  OP_VIEW = 'v'
} __packed operation;

typedef enum {
  /* raw */
  TYPE_UNKNOWN = 0,
#define	TYPE_NONE	TYPE_UNKNOWN
  TYPE_RAW = 'R',
  TYPE_PALETTE = '@',						/* WAD2_PALETTE, */

  /* archives */
  TYPE_WAD2 = 'w',	/* QuakeI and QuakeII are the same */
  TYPE_BSP = 'b',	/* QuakeI and QuakeII differs */
  TYPE_PACK = 'p',	/* QuakeI and QuakeII are the same */
  TYPE_MODEL = 'm',
  TYPE_SPRITE = 's',
  TYPE_CODE = 'c',
  TYPE_DEMO = 'd',

  /* pictures */
  TYPE_PPM = '6',
  TYPE_PGM = '5',
  TYPE_PBM = '1',
  TYPE_JPEG = 'J',
  TYPE_ILBM = 'I',
  TYPE_PNG = 'P',
#define	TYPE_IMAGE	TYPE_PPM

  /* quake pictures */
  TYPE_MIPMAP = 'D',						/* WAD2_MIPMAP, */
  TYPE_LUMP = 'E',						/* WAD2_CONPIC, */
  TYPE_STATUSBAR = 'B',						/* WAD2_STATUSBAR, */
  TYPE_SKIN = 'S',
  TYPE_FRAME = 'F',

  /* sounds */
  TYPE_WAVE = 'W',

  /* texts */
  TYPE_RESOURCE = 'R',
  TYPE_CONFIG = 'C',
  TYPE_QUAKEC = 'Q',
  TYPE_HEXENC = 'H',

  /* 3d infos */
  TYPE_TRIANGLE = 'T',
  TYPE_MAP = 'M',	/* QuakeI and QuakeII differs slightly */
  TYPE_IMAGINE = '3',

  /* specials */
  TYPE_INDEX = 'x',
  TYPE_DIRECTORY = 'y',

  /* very specials */
  TYPE_VIS = 'v',
  TYPE_LIT = 'l',
  TYPE_PRT = 'r',

  /* quakeII */
  TYPE_WAL = 'L',
  TYPE_MODEL2 = 'n',
  TYPE_SPRITE2 = 't'
} __packed filetype;

  /* raw */
#define	EXTBAS_RAW		"xxx"
#define	EXTEND_RAW		"." EXTBAS_RAW
#define	EXTBAS_PAL		"pal"
#define	EXTEND_PAL		"." EXTBAS_PAL

  /* archives */
#define	EXTBAS_WAD		"wad"
#define	EXTEND_WAD		"." EXTBAS_WAD
#define	EXTBAS_BSP		"bsp"
#define	EXTEND_BSP		"." EXTBAS_BSP
#define	EXTBAS_PACK		"pak"
#define	EXTEND_PACK		"." EXTBAS_PACK
#define	EXTBAS_MODEL		"mdl"
#define	EXTEND_MODEL		"." EXTBAS_MODEL
#define	EXTBAS_SPRITE		"spr"
#define	EXTEND_SPRITE		"." EXTBAS_SPRITE
#define	EXTBAS_CODE		"dat"
#define	EXTEND_CODE		"." EXTBAS_CODE
#define	EXTBAS_DEMO		"dem"
#define	EXTEND_DEMO		"." EXTBAS_DEMO

  /* pictures */
#define	EXTBAS_PNM		"pnm"
#define	EXTEND_PNM		"." EXTBAS_PNM
#define	EXTBAS_PPM		"ppm"
#define	EXTEND_PPM		"." EXTBAS_PPM
#define	EXTBAS_PGM		"pgm"
#define	EXTEND_PGM		"." EXTBAS_PGM
#define	EXTBAS_PBM		"pbm"
#define	EXTEND_PBM		"." EXTBAS_PBM
#define	EXTBAS_JPEG		"jpg"
#define	EXTEND_JPEG		"." EXTBAS_JPEG
#define	EXTBAS_IFF		"iff"
#define	EXTEND_IFF		"." EXTBAS_ILBM
#define	EXTBAS_ILBM		"lbm"
#define	EXTEND_ILBM		"." EXTBAS_ILBM
#define	EXTBAS_PNG		"png"
#define	EXTEND_PNG		"." EXTBAS_PNG

  /* quake pictures */
#define	EXTBAS_MIPMAP		"mip"
#define	EXTEND_MIPMAP		"." EXTBAS_MIPMAP
#define	EXTBAS_LUMP		"lmp"
#define	EXTEND_LUMP		"." EXTBAS_LUMP
#define	EXTBAS_STATUSBAR	"png"
#define	EXTEND_STATUSBAR	"." EXTBAS_STATUSBAR
#define	EXTBAS_SKIN		"skn"
#define	EXTEND_SKIN		"." EXTBAS_SKIN
#define	EXTBAS_FRAME		"frm"
#define	EXTEND_FRAME		"." EXTBAS_FRAME

  /* sounds */
#define	EXTBAS_WAVE		"wav"
#define	EXTEND_WAVE		"." EXTBAS_WAVE

  /* texts */
#define	EXTBAS_RESOURCE		"rc"
#define	EXTEND_RESOURCE		"." EXTBAS_RESOURCE
#define	EXTBAS_CONFIG		"cfg"
#define	EXTEND_CONFIG		"." EXTBAS_CONFIG
#define	EXTBAS_QUAKEC		"qc"
#define	EXTEND_QUAKEC		"." EXTBAS_QUAKEC
#define	EXTBAS_HEXENC		"hc"
#define	EXTEND_HEXENC		"." EXTBAS_HEXENC

  /* 3d infos */
#define	EXTBAS_TRIANGLE		"tri"
#define	EXTEND_TRIANGLE		"." EXTBAS_TRIANGLE
#define	EXTBAS_MAP		"map"
#define	EXTEND_MAP		"." EXTBAS_MAP
#define	EXTBAS_IMAGINE		"iob"
#define	EXTEND_IMAGINE		"." EXTBAS_IMAGINE

  /* specials */
#define	EXTBAS_INDEX		"idx"
#define	EXTEND_INDEX		"." EXTBAS_INDEX
#define	EXTBAS_DIRECTORY	"dir"
#define	EXTEND_DIRECTORY	"." EXTBAS_DIRECTORY

  /* very specials */
#define	EXTBAS_VIS		"vis"
#define	EXTEND_VIS		"." EXTBAS_VIS
#define	EXTBAS_LIT		"lit"
#define	EXTEND_LIT		"." EXTBAS_LIT
#define	EXTBAS_PRT		"prt"
#define	EXTEND_PRT		"." EXTBAS_PRT

  /* quakeII */
#define	EXTBAS_WAL		"wal"
#define	EXTEND_WAL		"." EXTBAS_WAL
#define	EXTBAS_MODEL2		"md2"
#define	EXTEND_MODEL2		"." EXTBAS_MODEL2
#define	EXTBAS_SPRITE2		"sp2"
#define	EXTEND_SPRITE2		"." EXTBAS_SPRITE2

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

char *OperationToText(operation Oper);
void AppendType(char *Original, filetype Type, char *Default);

bool processName(char *procName, char *destDir, char *outName, filetype outType, char *arcName, filetype arcType, operation procOper, bool script, bool recurse);
bool processType(char *procName, filetype procType,
		 char *destDir,
		 char *outName, filetype outType,
		 char *arcName, filetype arcType,
		 operation procOper,
		 bool script, bool recurse);

#endif
