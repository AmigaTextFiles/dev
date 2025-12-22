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


#include "SDL_Layer.h"
#include "SDL_Layer_internal.h"
#include "SDL_Layer_Viewport.h"
#include "SDL_Layer_Rects.h"

/* Get the viewport rectangle for the specified layer.
 * The resulting rectangle is clipped to the layer
 * surface boundaries.
 */
void SDLayer_GetViewport (SDL_Rect * vprect, SDLayer_Display * ld,
			  int layer_number)
{

	SDL_Rect vprect_noclip;

#ifdef SDLAYER_CHECK_PARAMETERS
	SDLAYER_CHECK_LAYER_INDICE(ld,layer_number);
#endif

	/* The reference viewport is equivalent to
 	 * a sliding window on the layer with a scrolling factor
 	 * of 1.0
 	 */
	SDLayer_ConvertRect (&vprect_noclip, &(ld->viewport),
			     LAYER(ld,layer_number).sfactor,
			     1.0f, ld->viewport.x, ld->viewport.y);
	
	/* Clip this rectangle to the layer */
	SDLayer_IntersectRect (vprect, &vprect_noclip,
			       &(LAYER(ld,layer_number).rect));
			     
	/* Finished */

}

/* Clip a rectangle to the viewport of a layer.
 */
void SDLayer_GetViewportRect (SDL_Rect * vprect, SDLayer_Display * ld,
			      SDL_Rect * rect, int layer_number)
{

	SDL_Rect vp;

#ifdef SDLAYER_CHECK_PARAMETERS
	SDLAYER_CHECK_LAYER_INDICE(ld,layer_number);
#endif
	
	/* Get the clipped viewport of this layer */
	SDLayer_GetViewport(&vp, ld, layer_number);

	/* Intersect the rectangle with it */
	SDLayer_IntersectRect (vprect, &vp, rect);
	
	/* Finished */
	
}

