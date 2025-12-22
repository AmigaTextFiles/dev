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


#ifndef _SDL_Layer_Rects_h_
#define _SDL_Layer_Rects_h_

#include "SDL_Layer.h"
#include "SDL.h"

/* An invalid rectangle is a rectangle
 * with a null area.
 */
#define SDLAYER_INVALID_RECT(rect_ptr)	\
	( ((rect_ptr)->w) * ((rect_ptr)->h) == 0 )


/*@name Dirty rectangles specific functions
 *@note Useful only when you plan to use your own blit functions
 *	instead of SDLayer_Blit.
 *@note Use with care
 */
/*{*/

/** Given two rectangles, calculate the intersection
 *  rectangle.
 *  The intersection can be an invalid rectangle.
 */
void SDLayer_IntersectRect (SDL_Rect * inter,
			    SDL_Rect * rect1,
			    SDL_Rect * rect2);

/* Given two rectangles, calculate the bounding box of the
 * region covered by the union of the two rectangles.
 * Said differently, merge the two rectangles.
 * You can make rect1 pointing to the same memory area as merge,
 * but rect2 cannot.
 */
void SDLayer_MergeRect (SDL_Rect * merge,
			SDL_Rect * rect1,
			SDL_Rect * rect2);

/* Convert a rectangle from one base system to another.
 * The purpose is to find matching rectangles between
 * layers and between a layer and the display.
 */
void SDLayer_ConvertRect (SDL_Rect * dst, SDL_Rect * src,
			  float sfactor_dst, float sfactor_src,
			  Sint16 vpx, Sint16 vpy);

/* Utility function for converting a rectangle in
 * the display coordinates.
 * Special case of SDLayer_ConvertRect.
 */
void SDLayer_DisplayRect (SDL_Rect * dst, SDL_Rect * src,
			  float sfactor, Sint16 vpx, Sint16 vpy);

#endif

