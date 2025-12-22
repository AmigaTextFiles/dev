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

#ifndef DISPLAY_H
#define DISPLAY_H

#ifdef CALCULATE_PIXELDRAW
extern int pixelDraw;
extern int pixelOverdraw;
#endif

struct baseDisplay {
  void (*draw_poly) (int n, point_3d ** vl);			/* 8/16/24/32bit/wire/flat */
};

extern unsigned char *frameBuffer;
extern int frameCounter;
extern int frameSize;
extern struct view *actView;

void run_demo(bspBase bspMem);

#endif
