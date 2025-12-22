
/*
 * [!BGN - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 * Program   : Hexy (Binary file viewer/editor for the Amiga.)
 * Version   : 1.6
 * File      : Work:Source/!WIP/HisoftProjects/Hexy/Hexy_asm.h
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

/*
 * File created: Fri.30.Oct.1998
 *
 * Prototypes for assembly functions located in 'Hexy_asm.s'.
 *
 */


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


extern void AdjustView( register __a0 struct VCtrl *, register __d0 LONG);
extern void UpdateView( register __a0 struct VCtrl *, register __d0 ULONG);
extern ULONG StrLen( register __a0 UBYTE *String);
extern void LongToHex( register __d0 ULONG, register __a1 UBYTE *Dest);

extern ULONG SearchMem( register __a0 void *Mem, register __d0 ULONG MemLen, register __a1 UBYTE *CmpStr, register __d1 ULONG CmpStrLen);
extern ULONG SearchMemRev( register __a0 void *Mem, register __d0 ULONG MemLen, register __a1 UBYTE *CmpStr, register __d1 ULONG CmpStrLen);

