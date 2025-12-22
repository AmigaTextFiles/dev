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

#ifndef	DRAW_H
#define	DRAW_H

/* draw.c */

/*============================================================================= */

/*============================================================================= */

void Draw_Init(void);
void DrawBrush(struct brush *b);
void DrawLeaf(struct node *l, int color);
void DrawPoint(vec3D v);
void DrawPortal(struct portal *portal);
void DrawTri(vec3D p1, vec3D p2, vec3D p3);
void DrawWinding(struct winding *w);
void Draw_AddToBounds(vec3D v);
void Draw_ClearBounds(void);
void Draw_ClearWindow(void);
void Draw_DrawFace(struct visfacet *f);
void Draw_SetBlack(void);
void Draw_SetGrey(void);
void Draw_SetRed(void);

#endif
