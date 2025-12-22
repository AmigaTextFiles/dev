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

#ifndef DRAWc_H
#define DRAWc_H

typedef union {
  unsigned char *indexed;					/*  8bit indexed */
  unsigned short int *hicolor;					/* 16bit 5/6/5 rgb */
  struct rgb *truecolor;					/* 24bit 8/8/8 rgb */
} displaypointer;

extern displaypointer texture;
extern int textureMask1, textureMask2;
extern int textureRow;
extern short int textureShift1, textureShift2;
extern short int textureMip;
extern short int textureType;
extern unsigned char textureColor;

void draw_face(bspBase bspMem, int face);
void setup_default_point_list(void);

#endif
