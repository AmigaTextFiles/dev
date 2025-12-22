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

#ifndef	RAWMOUSE_H
#define	RAWMOUSE_H

struct mouseEvent {
  unsigned char pressed;					/* -1 if nothing */
  short int mouseX, mouseY;					/* these are absolute values, not delta-moves */
};

#define RAWMOUSE_LEFT		0x68
#define RAWMOUSE_RIGHT		0x69
#define RAWMOUSE_MID		0x6A

#define	RAWMOUSE_NOTHING	0xFF

#define RAWQUAL_MIDBUTTON	0x1000
#define RAWQUAL_RBUTTON		0x2000
#define RAWQUAL_LEFTBUTTON	0x4000

#endif
