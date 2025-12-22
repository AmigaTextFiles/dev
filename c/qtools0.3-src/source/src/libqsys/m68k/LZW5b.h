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

extern int LZWSCrunch(register int inlen __asm__("d0"),
		      register int outlen __asm__("d1"),
		      register int maxnodes __asm__("d2"),
		      register char *input __asm__("a0"),
		      register char *output __asm__("a1"));
extern int LZWSDecrunch(register int outLen __asm__("d0"),
			register char *input __asm__("a0"),
			register char *output __asm__("a1"));
extern int LZWSSize(register char *input __asm__("a0"));

#define	IDENTIFIER		0x4C5A				/* 'LZ' */

#define	NOERROR			1
#define	ERROR			0
#define	ERROR_NOTCRUNCHED	-1
#define	ERROR_LESSMEM		-2
#define	ERROR_OVERFLOW		-3
