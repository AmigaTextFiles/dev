/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Library General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#ifndef	LIBQDISPLAY_H
#define	LIBQDISPLAY_H

#include "./init.h"

/* ============================================================================ */

#ifdef	LIBQDISPLAY_CORE
#include "./libqtools.h"
#include "../libqdisplay/3d.h"
#include "../libqdisplay/cache.h"
#include "../libqdisplay/clippoly.h"
#include "../libqdisplay/display.h"
#include "../libqdisplay/draw.h"
#include "../libqdisplay/render.h"
#include "../libqdisplay/surface.h"
#include "../libqdisplay/tables.h"
#include "../libqdisplay/tbsp.h"
#endif

#include "./mathlib.h"

#define	DISPLAY_TEXTURED	0
#define	DISPLAY_FLAT		1
#define	DISPLAY_WIRE		2

extern bool wideView;

bool DisplayBSP(bspBase, char *Title, int width, int height, int depth, int display, bool wait);
bool DisplayPicture(void *pic, char *Title, int width, int height, int depth, bool wait);
bool DisplayMipMap(void *pic, char *Title, int width, int height, int depth, bool wait);
void DisplayEnd(void);

#endif
