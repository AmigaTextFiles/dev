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

#ifndef	CRC_H
#define	CRC_H

#define CRC_INIT_VALUE	0xffff
#define CRC_XOR_VALUE	0x0000

extern unsigned short int crctable[256];

extern inline void CRC_Init(unsigned short int *crcvalue);
extern inline void CRC_ProcessByte(unsigned short int *crcvalue, unsigned char data);
extern inline unsigned short int CRC_Value(unsigned short int crcvalue);

extern inline void CRC_Init(unsigned short int *crcvalue)
#ifndef	PROFILE
{
  *crcvalue = CRC_INIT_VALUE;
}
#endif
;

extern inline void CRC_ProcessByte(unsigned short int *crcvalue, unsigned char data)
#ifndef	PROFILE
{
  *crcvalue = (*crcvalue << 8) ^ crctable[(*crcvalue >> 8) ^ data];
}
#endif
;

extern inline unsigned short int CRC_Value(unsigned short int crcvalue)
#ifndef	PROFILE
{
  return crcvalue ^ CRC_XOR_VALUE;
}
#endif
;

#endif
