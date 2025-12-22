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
#include <stdio.h>

void	SDLayer_Blit (SDL_Surface * src, SDL_Rect * srcrect,
		      SDLayer_Display * ldisplay, SDL_Rect * dstrect,
		      int layer_number)
{

	SDL_Rect vprect;
	SDLayer	 *l;
	int i;

#ifdef SDLAYER_CHECK_PARAMETERS
	SDLAYER_CHECK_LAYER_INDICE(ldisplay, layer_number);
#endif

	l = &(LAYER(ldisplay,layer_number));

	SDL_BlitSurface (src, srcrect,
			 l->surface, dstrect);

	/* If the destination layer is not visible, no refresh management is needed . */
	if ( l->visible == 0 ) return;

	/* Clip the destination rectangle to the layer's viewport (itself clipped).
 	 * If it is outside of it (invalid intersection),
 	 * then we let the refresh flag as it is, whatever the refresh method.
 	 */
	SDLayer_GetViewportRect (&vprect, ldisplay, dstrect, layer_number);
	if ( SDLAYER_INVALID_RECT(&vprect) )
		return;

	/* The blit is visible on the screen so set the refresh flag. */
	ldisplay->need_refresh = 1;

	/* If using the dirty rectangles method or the
	 * whole refresh flag is not set, we need to add
 	 * a new dirty rectangle in the display's absolute coordinates
 	 * (by taking in consideration the scrolling factor and
 	 * the current viewport position)
	 */
	if ( (ldisplay->force_whole_refresh != 1) &&
	     (ldisplay->refresh_method == SDLAYER_RECTS)
	   )
	{

		/** Add a new dirty rectangle on the layer */
		
#ifdef SDLAYER_USE_MERGE
		/** Merge if necessary */
		int dist;

		for ( i = 0; i < l->n_rects; i++ )
		{
			/* Calulate the infinite distance between the new rectangle
			   and all the existing rectangles.
			*/
			dist = MAX ( ABS(vprect.x - l->rects[i].x),
				     ABS(vprect.y - l->rects[i].y) );
			
			/* Merge if this distance is small enough */
			if ( dist <= SDLAYER_MERGE_DISTANCE )
			{
				/* The two first arguments can point to the same location */
				SDLayer_MergeRect (&l->rects[i], &l->rects[i], &vprect);
			
				/* Note: it is possible to have an incremental approach and
					continue the merge process as long as there're rectangles
					close enough. But this approach can lead to
					update the whole screen ... let's forget about it for now. */
				
				/* Return immediatly from the function */
				return;
			}

		}
#else
		i = l->n_rects;
#endif

		if ( !(i % SDLAYER_CHUNK_SIZE) )
		//if ( i >= (l->n_chunks * SDLAYER_CHUNK_SIZE) )
		
		{
			l->n_chunks++;
			l->rects = (SDL_Rect *)realloc(
					l->rects,
					l->n_chunks * SDLAYER_CHUNK_SIZE * sizeof(SDL_Rect));
		}
	
		l->rects[i].x = vprect.x;
		l->rects[i].y = vprect.y;
		l->rects[i].w = vprect.w;
		l->rects[i].h = vprect.h;

		l->n_rects ++;

	}

}

/* Whole refresh */
static void __SDLayer_UpdateAll (SDLayer_Display * ldisplay)
{

	int 		k;
	SDL_Rect	viewport;
	SDL_Rect	disprect;

	/* Set the whole refresh flag back to zero
 	 * and force the discard of all pending dirty
 	 * rectangles if we were using this refresh method.
 	 */
	if ( ldisplay->refresh_method == SDLAYER_RECTS )
	{
		for ( k = 0; k < ldisplay->n_layers; k++ )
		{
		
			if ( LAYER(ldisplay,k).n_rects == 0 ) continue;

			/* We don't need the rectangles of the current layer,
			 * discard them */
			SDLayer_DiscardRects (&LAYER(ldisplay,k));
		}

	}

	ldisplay->force_whole_refresh = 0;

	/* Clear screen first ! */
	SDL_FillRect (ldisplay->display, (SDL_Rect *)0, 0);

	for ( k = 0; k < ldisplay->n_layers; k++ )
	{

		/* Skip invisible layers */
		if ( LAYER(ldisplay,k).visible == 0 )
			continue;

		/* Get the clipped viewport for the current layer.
 		 * It corresponds to the area of the layer to blit. */
		SDLayer_GetViewport (&viewport, ldisplay, k);

		/* If the viewport is invalid for that layer, skip
 		 * that layer. */
		if ( SDLAYER_INVALID_RECT(&viewport) ) continue;

		/* Convert it into its corresponding display rectangle */
		SDLayer_DisplayRect (&disprect, &viewport,
					LAYER(ldisplay,k).sfactor,
					ldisplay->viewport.x,
					ldisplay->viewport.y);

		/* Finally perform the blit on the screen */
		SDL_BlitSurface (LAYER(ldisplay,k).surface, &viewport,
				 ldisplay->display, &disprect);

	}

	SDL_Flip (ldisplay->display);

}

/* Dirty rectangles refresh */
static void __SDLayer_UpdateRects (SDLayer_Display * ldisplay)
{

	int k, r, l;
	SDL_Rect * drect, disprect, rect;
	SDL_Rect * refreshlist;
	SDLayer  * layer, * slayer;
	int n_refreshlist;
	int n_chunks;

	/* The rectangle refresh list
 	 * is a set of memory chunks with size
 	 * tunable through the macro SDLAYER_CHUNK_SIZE
 	 */
	n_chunks	= 0;
	n_refreshlist	= 0;
	refreshlist	= (SDL_Rect *)0;
	
	/* Bottom-Top projection */
	for ( k = 0; k < ldisplay->n_layers; k++ )
	{

		layer = &LAYER(ldisplay,k);

		/* Skip invisible layers */
		if ( layer->visible == 0 )
			continue;

		/* Skip if no dirty rectangles, faster */
		if ( layer->n_rects == 0 )
			continue;

		/* Get the next dirty rectangle of that layer,
 		 * already clipped in SDLayer_Blit()
 		 */
		for ( r = 0; r < layer->n_rects; r++ )
		{

			drect = &(layer->rects[r]);
			
			/* Calculate the associated display rectangle */
			SDLayer_DisplayRect (&disprect, drect,
					     layer->sfactor,
					     ldisplay->viewport.x,
					     ldisplay->viewport.y);
			/* Add it to the refresh list */
		
			/* Adjust the memory chunk as needed */
			/*if ( !(n_refreshlist % SDLAYER_CHUNK_SIZE) )*/
			if ( n_refreshlist >= n_chunks * SDLAYER_CHUNK_SIZE )	
			{
				n_chunks ++;
				refreshlist = (SDL_Rect *)realloc(
					refreshlist,
					n_chunks * SDLAYER_CHUNK_SIZE * sizeof(SDL_Rect));
			}

			refreshlist[n_refreshlist].x = disprect.x;
			refreshlist[n_refreshlist].y = disprect.y;
			refreshlist[n_refreshlist].w = disprect.w;
			refreshlist[n_refreshlist].h = disprect.h;
			n_refreshlist ++;

			/* Erase screen zone */
			SDL_FillRect (ldisplay->display, &disprect, 0);


			/* Then, project the dirty rectangle on each layer different
 			 * from the current layer and finally on the screen. */
			for ( l = 0; l < ldisplay->n_layers; l++ )
			{
			
				slayer = &LAYER(ldisplay,l);

				/* Skip invisible layers */
				if ( slayer->visible == 0 ) continue;
		
				if ( l != k )
				{
					/* It's not the current layer: we need to convert
 					   the rectangle. Faster using the display rectangle. */
					SDLayer_ConvertRect (&rect, &disprect,
							     slayer->sfactor,
							     0.0f,
							     ldisplay->viewport.x, ldisplay->viewport.y);
					SDL_BlitSurface (slayer->surface, &rect,
							 ldisplay->display, &disprect);
					
				}
				else
				{
					/* It's the current layer: no need to have extra
 					 * rectangle conversion for we already have
 					 * the rectangle to blit in "drect"
 					 */
					SDL_BlitSurface (slayer->surface, drect,
							 ldisplay->display, &disprect);		
				}

			} /* End for (l) */

		} /* End for (r) */

		/* We've finished with the rectangles of the current layer,
 		 * discard them */
		SDLayer_DiscardRects (layer);
		//layer->n_rects = 0;

	} /* End for (k) */

	/* Update the rectangles */
	if ( n_refreshlist > 0 )
	{
		SDL_UpdateRects (ldisplay->display, n_refreshlist, refreshlist);

		/* Discard the refresh list */
		free ( refreshlist );
		refreshlist = (SDL_Rect *)0;
		
	}

}

void	SDLayer_Update (SDLayer_Display * ldisplay)
{

	/* If no blit were visible on the display,
 	 * the refresh flag may be no set.
 	 * In that case, there's nothing to do.
 	 */
	if ( !(ldisplay->need_refresh) )
		return;

	/* Whole refresh occurs either when the flag
 	 * is set or when the refresh method is not a
 	 * dirty rectangles method.
 	 * In both cases, there should be no dirty rectangles.
 	 */
	if ( (ldisplay->force_whole_refresh == 1)
		||
	     ( ldisplay->refresh_method == SDLAYER_FLIP )
	   )
	{
	
		__SDLayer_UpdateAll (ldisplay);
	
	}
	else
	{
	
		__SDLayer_UpdateRects (ldisplay);
	
	}
	
	/* In both cases, set the need refresh flag to zero when
 	 * the refresh is performed.
 	 */
	ldisplay->need_refresh = 0;

}

