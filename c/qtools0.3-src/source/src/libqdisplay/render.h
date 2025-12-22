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

#ifndef RENDER_H
#define RENDER_H

extern int type;
extern int model;

extern unsigned char *visibleFaces;				/*[MAX_MAP_FACES / 8 + 1]; */
extern unsigned char *visibleLeafs;				/*[MAX_MAP_LEAFS / 8 + 1]; */
extern unsigned char *visibleNodes;				/*[MAX_MAP_NODES]; */

#define is_marked_leaf(x)	(visibleLeafs[(x) >> 3] &   (1 << ((x) & 7)))
#define is_marked_node(x)	(visibleNodes[(x) >> 3] &   (1 << ((x) & 7)))
#define is_marked_face(x)	(visibleFaces[(x)])
#define mark_leaf(x)		(visibleLeafs[(x) >> 3] |=  (1 << ((x) & 7)))
#define mark_node(x)		(visibleNodes[(x) >> 3] |=  (1 << ((x) & 7)))
#define mark_face(x)		(visibleFaces[(x)] = contents)
#define unmark_leaf(x)		(visibleLeafs[(x) >> 3] &= ~(1 << ((x) & 7)))
#define unmark_node(x)		(visibleNodes[(x) >> 3] &= ~(1 << ((x) & 7)))
#define unmark_face(x)		(visibleFaces[(x)] = 0)

bool leaf_in_frustrum(register struct dleaf_t *node);
bool node_in_frustrum(register struct dnode_t *node);

void mark_leaf_faces(bspBase bspMem, register short int leaf);
void render_node_faces(bspBase bspMem, register short int node, register short int side);
void renderWorld(bspBase bspMem);
int visit_visible_leaves(bspBase bspMem);

#endif
