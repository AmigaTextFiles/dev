/************************************************************************
 * SDL_Layer - A layered display mechanism for SDL
 * Copyright (C) 2008  Julien CLEMENT
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ************************************************************************/


#ifndef _SDL_Layer_Viewport_h_
#define _SDL_Layer_Viewport_h_

/* Get the viewport rectangle for the specified layer.
 * The resulting rectangle is clipped to the layer
 * surface boundaries.
 */
void SDLayer_GetViewport (SDL_Rect * vprect, SDLayer_Display * ld,
			  int layer_number);

/* Clip a rectangle to the viewport of a layer.
 */
void SDLayer_GetViewportRect (SDL_Rect * vprect, SDLayer_Display * ld,
			      SDL_Rect * rect, int layer_number);

#endif

