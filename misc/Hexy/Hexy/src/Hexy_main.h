
/*
 * [!BGN - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 * Program   : Hexy (Binary file viewer/editor for the Amiga.)
 * Version   : 1.6
 * File      : Work:Source/!WIP/HisoftProjects/Hexy/Hexy_main.h
 * Author    : Andrew Bell
 * Copyright : Copyright © 1998-1999 Andrew Bell (See GNU GPL)
 * Created   : Saturday 28-Feb-98 16:00:00
 * Modified  : Sunday 22-Aug-99 23:31:45
 * Comment   : 
 *
 * (Generated with StampSource 1.2 by Andrew Bell)
 *
 * [!END - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 */

/* Fri/30/Oct/1998 */


/*
 *  Hexy, binary file viewer and editor for the Amiga.
 *  Copyright (C) 1999 Andrew Bell
 *
 *  Author's email address: andrew.ab2000@bigfoot.com
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

enum { HEXYMODE_HEX = 0, HEXYMODE_ASCII };

struct VCtrl
{
  UBYTE *VC_FileAddress;
  ULONG VC_FileLength;
  ULONG VC_CurrentPoint;
  struct RastPort *VC_RPort;
  UWORD VC_InitialYPos;
  UWORD VC_YAmount;
  UWORD VC_XPos;
  UWORD VC_Mode;
  struct FileInfoBlock *VC_FIB;
};

#define XBYTES      20
#define YLINES      24
#define XAMOUNT_ASCII 64
#define XAMOUNT_HEX   20

enum { ARG_FILE = 0, ARG_ASCII, ARG_AMT };
enum { HEXYUCODE_NOTPACKED = 0, HEXYUCODE_OK, HEXYUCODE_ABORT };
