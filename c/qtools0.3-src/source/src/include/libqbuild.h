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

#ifndef	LIBQBUILD_H
#define	LIBQBUILD_H

#include "./init.h"

/* ============================================================================ */

#ifdef	LIBQBUILD_CORE
#define	LIBQTOOLS_CORE
#include "./libqtools.h"
#include "../libqbuild/brush.h"
#include "../libqbuild/csg4.h"
#include "../libqbuild/merge.h"
#include "../libqbuild/solidbsp.h"
#include "../libqbuild/surfaces.h"

#include "../libqbuild/portals.h"
#include "../libqbuild/winding.h"

#include "../libqbuild/writebsp.h"
#include "../libqbuild/writemdl.h"
#include "../libqbuild/writespr.h"

#include "../libqbuild/tjunc.h"
#include "../libqbuild/region.h"
#include "../libqbuild/outside.h"
#include "../libqbuild/nodraw.h"
#include "../libqbuild/mdl.h"
#include "../libqbuild/spr.h"
#endif

#include "./mathlib.h"

/* ============================================================================ */

#ifdef	LIBQBUILD_CORE
#include "../libqbuild/qbsp.h"
#endif

#define	QBSP_WATERVIS		(1<<0)
#define	QBSP_SLIMEVIS		(1<<1)
#define	QBSP_NOFILL		(1<<2)
#define	QBSP_NOTJUNC		(1<<3)
#define	QBSP_NOCLIP		(1<<4)
#define	QBSP_ONLYENTS		(1<<5)
#define	QBSP_USEHULLS		(1<<6)
#define	QBSP_NOTEXTURES		(1<<7)

void BeginBSPFile(bspBase bspMem, mapBase mapMem);			/* start these before qbsp */
bool qbsp(bspBase bspMem, mapBase mapMem, int hullNum, int subDivide, char *filebase);
void FinishBSPFile(bspBase bspMem, mapBase mapMem, HANDLE bspFile);

/* ============================================================================ */

bool qcc(FILE * srcFile, char *destDir, operation procOper);
bool unqcc(HANDLE srcFile, char *destDir, operation procOper);

/* ============================================================================ */

#ifdef	LIBQBUILD_CORE
#include "../libqbuild/vis.h"
#endif

#define	VIS_FAST		(1<<0)
#define	VIS_MEM			(1<<1)
#define	VIS_VERBOSE		(1<<2)

bool vis(bspBase, int level, char *prtBuf);

/* ============================================================================ */

#ifdef	LIBQBUILD_CORE
#include "../libqbuild/light.h"
#include "../libqbuild/rad.h"
#endif

#define DEFAULTLIGHTLEVEL	300

#define	LIGHT_EXTRA		(1<<0)
#define	LIGHT_WATERLIT		(1<<1)
#define	LIGHT_MEM		(1<<2)
#define	LIGHT_RADIOSITY		(1<<3)

bool light(bspBase bspMem, mapBase mapMem, vec1D scale, vec1D range);

/* ============================================================================ */

#endif
