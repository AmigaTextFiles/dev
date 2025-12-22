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

#ifndef	MERGE_H
#define	MERGE_H

/* merge.c */

/*============================================================================= */

/*============================================================================= */

struct visfacet *FreeMergeListScraps(struct visfacet *merged);
void MergeAll(mapBase mapMem, struct surface *surfhead);
struct visfacet *MergeFaceToList(mapBase mapMem, struct visfacet *face, struct visfacet *list);
void MergePlaneFaces(mapBase mapMem, struct surface *plane);

#endif
