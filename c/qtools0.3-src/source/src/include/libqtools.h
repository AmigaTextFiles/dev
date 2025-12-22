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

#ifndef	LIBQTOOLS_H
#define	LIBQTOOLS_H

#include "./init.h"

/* ============================================================================ */

#include "./libqsys.h"
#include "./mathlib.h"

#include "../libqtools/misc.h"
#include "../libqtools/graphics.h"
#include "../libqtools/raw.h"
#include "../libqtools/parse.h"

#include "../libqtools/script.h"
#include "../libqtools/pak.h"
#include "../libqtools/wad.h"
#include "../libqtools/mip.h"
#include "../libqtools/mdl.h"
#include "../libqtools/spr.h"
#include "../libqtools/bsp.h"
#include "../libqtools/3DS.h"
#include "../libqtools/memory.h"
#include "../libqtools/crc.h"

/* ============================================================================ */

#ifdef	LIBQTOOLS_CORE
#include "../libqtools/map.h"
#endif

#define	MAP_LOADLIGHTS		(1<<0)
#define	MAP_VERBOSE1		(1<<1)
#define	MAP_VERBOSE2		(1<<2)

bool LoadMapFile(bspBase bspMem, mapBase mapMem, char *);
bool SaveMapFile(bspBase bspMem, mapBase mapMem, FILE *);
bool LoadBSPFile(bspBase bspMem, mapBase mapMem);

/* ============================================================================ */

bool LoadTDDDFile(bspBase bspMem, mapBase mapMem, unsigned char *);
bool SaveTDDDFile(bspBase bspMem, mapBase mapMem, HANDLE);

/* ============================================================================ */

#endif
