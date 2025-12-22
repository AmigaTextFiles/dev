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


#include "SDL_Layer_Rects.h"
#include "SDL_Layer.h"
#include "SDL_Layer_internal.h"

/* Given two rectangles, calculate the intersection
 * rectangle.
 * The intersection can be an invalid rectangle.
 * Mainly used to perform clipping.
 */
void SDLayer_IntersectRect (SDL_Rect * inter,
			    SDL_Rect * rect1,
			    SDL_Rect * rect2)
{

	/* If one of the rectangles is invalid
 	 * then the result is an invalid rectangle too.
 	 */
	if ( SDLAYER_INVALID_RECT(rect1) ||
	     SDLAYER_INVALID_RECT(rect2) )
	{
		inter->w = 0;
		inter->h = 0;
		return;
	}

	if ( (rect2->x + rect2->w <= rect1->x)
			||
	     (rect2->x >= rect1->x + rect1->w)
			||
	     (rect2->y + rect2->h <= rect1->y)
			||
	     (rect2->y >= rect1->y + rect1->h)
	   )
	{
		/* The intersection is reduced
 		 * to zero (invalid rectangle)
 		 */
		inter->w = 0;
		inter->h = 0;
		return;
	}

	/* The two rectangles intersect, calculate the
 	 * intersection rectangle.
 	 */
	inter->x = MAX(rect1->x, rect2->x);
	inter->y = MAX(rect1->y, rect2->y);
	inter->w = MIN(rect1->x+rect1->w - inter->x,
		       rect2->x+rect2->w - inter->x);
	inter->h = MIN(rect1->y+rect1->h - inter->y,
		       rect2->y+rect2->h - inter->y);


}

/* Given two rectangles, calculate the bounding box of the
 * region covered by the union of the two rectangles.
 * Said differently, merge the two rectangles.
 * You can make rect1 pointing to the same memory area as merge,
 * but rect2 cannot.
 */
void SDLayer_MergeRect (SDL_Rect * merge,
			SDL_Rect * rect1,
			SDL_Rect * rect2)
{

	Sint16 x, y;
	Uint16 w, h;

	/* If one of the rectangles is invalid
	 * then by convention the merge rectangle is itself
	 * invalid. 
	 */
	if ( SDLAYER_INVALID_RECT(rect1) || SDLAYER_INVALID_RECT(rect2) )
	{
		merge->w = 0;
		merge->h = 0;
		return;
	}

	x = rect1->x;
	y = rect1->y;
	w = rect1->w;
	h = rect1->h;

	merge->x = MIN(x, rect2->x);
	merge->y = MIN(y, rect2->y);
	merge->w = MAX(x+w-merge->x,
		       rect2->x+rect2->w-merge->x);
	merge->h = MAX(y+h-merge->y,
		       rect2->y+rect2->h-merge->y);

}

/* Convert a rectangle from one base system to another.
 * The purpose is to find matching rectangles between
 * layers and between a layer and the display.
 */
void SDLayer_ConvertRect (SDL_Rect * dst, SDL_Rect * src,
			  float sfactor_dst, float sfactor_src,
			  Sint16 vpx, Sint16 vpy)
{

	/* The formula is simple:
	 * 	x' = x - s*vpx + s'*vpx
	 */
	
	dst->x = src->x - sfactor_src*vpx + sfactor_dst*vpx;
	dst->y = src->y - sfactor_src*vpy + sfactor_dst*vpy;

	/* Size doesn't change */
	dst->w = src->w;
	dst->h = src->h;

}

/* Utility function for converting a rectangle in
 * the display coordinates.
 * Special case of SDLayer_ConvertRect.
 */
void SDLayer_DisplayRect (SDL_Rect * dst, SDL_Rect * src,
			  float sfactor, Sint16 vpx, Sint16 vpy)
{
	SDLayer_ConvertRect(dst,src,0.0f,sfactor,vpx,vpy);
}

