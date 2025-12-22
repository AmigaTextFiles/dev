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

#ifndef	QBSP_H
#define	QBSP_H
/*
 * ============================================================================
 * structures
 * ============================================================================
 */

#define	MAX_THREADS			4

/*
 * ============================================================================
 * globals
 * ============================================================================
 */

extern int subdivide_size;
extern struct brushset *brushset;
extern int valid;

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */

struct brush *AllocBrush(void);
struct visfacet *AllocFace(register int points);
void FreeLeaf(register struct visleaf *l);
void CopyFace(register struct visfacet *out, register struct visfacet *in);
void RecalcFace(register struct visfacet *f);
void RecalcLeaf(register struct visleaf *l);
struct node *AllocNode(void);
struct visleaf *AllocLeaf(register int portals);
struct portal *AllocPortal(void);
struct surface *AllocSurface(void);
void FreeFace(register struct visfacet *f);
void FreePortal(register struct portal *p);
void FreeSurface(register struct surface *s);

void PrintMemory(void);

#endif
