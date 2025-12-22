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
#include <stdio.h>


static void __SDLayer_InitLayer (SDLayer * layer,
				 Uint32 flags, float sfactor,
				 int width, int height, int bitsPerPixel,
				 Uint32 Rmask, Uint32 Gmask, Uint32 Bmask, Uint32 Amask)
{
	SDL_Surface 	* surf;

	surf = SDL_CreateRGBSurface (flags, width, height, bitsPerPixel,
					       Rmask, Gmask, Bmask, Amask);

	if ( surf == (SDL_Surface *)0 )
	{
		fprintf (stderr,
		"Cannot allocate memory for a new SDL_Surface with properties:\n"
		"%dx%d@%d bpp (masks: %d,%d,%d,%d)\n"
		"SDL reports: %s\n", 
		width, height, bitsPerPixel, Rmask, Gmask, Bmask, Amask, SDL_GetError());
		
		return;	
	}

	/* Convert the layer surface to the display format */
	layer->surface = SDL_DisplayFormat(surf);

	if ( layer->surface == (SDL_Surface *)0 )
	{
		fprintf (stderr,
		"Cannot convert the layer surface to the display format.\n"
		"SDL reports: %s\n", SDL_GetError());
		SDL_FreeSurface (surf);

		return;
	}

	SDL_FreeSurface(surf);
	surf = (SDL_Surface *)0;

	layer->rect.x = 0;
	layer->rect.y = 0;
	layer->rect.w = width;
	layer->rect.h = height;

	layer->visible = 1;
	layer->sfactor = sfactor;

	/* No dirty rectangles */
	layer->rects	= (SDL_Rect *)0;
	layer->n_rects	= 0;
	layer->n_chunks = 0;

	return;
}

static void __SDLayer_ClearLayer (SDLayer * layer)
{
	/* The dirty rectangles are automatically discarded
 	 * by SDLayer_Update(), called at the beginning of
 	 * SDLayer_FreeLayeredDisplay()
 	 */
	SDL_FreeSurface (layer->surface);
	layer->surface = (SDL_Surface *)0;
}

void SDLayer_DiscardRects (SDLayer * l)
{
	
	l->n_rects	= 0;
	l->n_chunks	= 0;

	free ( l->rects );
	l->rects	= (SDL_Rect *)0;

}

SDLayer_Display * 
SDLayer_CreateRGBLayeredDisplay (Uint32 flags, int refresh_method,
				 int n_layers, int * widths, int * heights,
				 int bitsPerPixel, 
                                 Uint32 Rmask, Uint32 Gmask, Uint32 Bmask,
				 Uint32 Amask)
{

	int k;

	SDLayer_Display	* ldisplay = (void *)0;
	SDL_Surface *display;

	display = SDL_GetVideoSurface ();

	if ( display == (SDL_Surface *)0 )
	{
		fprintf (stderr,
	"Error (from %s): You must initialize a video surface before\n"
		"creating a new layered display.\n", __func__);
		exit (-1);
	}

	ldisplay = (SDLayer_Display *)calloc( 1, sizeof(SDLayer_Display) );

	if ( ldisplay == (SDLayer_Display *)0 )
	{
		fprintf (stderr,
	"Error (from %s): Cannot allocate memory for a new SDLayer_Display.\n",	__func__);
		exit (-1);
	}

	/* Store a pointer to the video surface to avoid
 	 * calling SDL_GetVideoSurface() each time ... */
	ldisplay->display = display;

	ldisplay->layers = (SDLayer *)calloc (
		n_layers, sizeof(SDLayer));

	if ( ldisplay->layers == (SDLayer *)0 )
	{
		fprintf (stderr,
	"Error (from %s): Cannot allocate memory for %d layers\n",
		__func__, n_layers);
		free ( ldisplay );
		exit (-1);
	}
	
	ldisplay->n_layers = n_layers;

	for ( k = 0; k < n_layers; k++ )
		/* Default scrolling factor is 1.0 */
		__SDLayer_InitLayer(&LAYER(ldisplay,k),
				    flags, 1.0f,
				    widths[k], heights[k], bitsPerPixel,
				    Rmask, Gmask, Bmask, Amask);
	
	/* Default viewport is aligned with the top-left corner
 	 * of the display.
 	 */
	ldisplay->viewport.x = 0;
	ldisplay->viewport.y = 0;
	ldisplay->viewport.w = display->w;
	ldisplay->viewport.h = display->h;

	/* Whole refresh is needed for the first blit */
	ldisplay->force_whole_refresh = 1;

	/* No need to refresh when nothing is blit yet */
	ldisplay->need_refresh = 0;

	/* Set the refresh method to use */
	ldisplay->refresh_method = refresh_method;

	return ldisplay;

}

void SDLayer_FreeLayeredDisplay (SDLayer_Display * ldisplay)
{

	int k;

	/* Perform a last update of the display, which will
 	 * discard all the dirty rectangles.
 	 */
	SDLayer_Update(ldisplay);

	for ( k = 0; k < ldisplay->n_layers; k++ )
		__SDLayer_ClearLayer (&LAYER(ldisplay,k));

	free ( ldisplay->layers );
	ldisplay->layers = (SDLayer *)0;

	/* By security */
	ldisplay->n_layers = 0;
}

void SDLayer_SetColorKey (SDLayer_Display * ldisplay, Uint32 flags,
			  Uint32 key)
{

	int k;

	for ( k = 0; k < ldisplay->n_layers; k++ )
		SDL_SetColorKey (LAYER(ldisplay,k).surface, flags, key);

}

SDL_Surface * SDLayer_GetLayer (SDLayer_Display * ldisplay, int layer_number)
{

#ifdef SDLAYER_CHECK_PARAMETERS
	SDLAYER_CHECK_LAYER_INDICE(ldisplay,layer_number);
#endif

	return LAYER(ldisplay,layer_number).surface;
	
}

void SDLayer_ForceWholeRefresh (SDLayer_Display * ldisplay)
{

	ldisplay->force_whole_refresh = 1;
	ldisplay->need_refresh	      = 1;

}

void SDLayer_Fill (SDLayer_Display * ldisplay, Uint32 color)
{
	int k;

	for ( k = 0; k < ldisplay->n_layers; k++ )
		SDL_FillRect (LAYER(ldisplay,k).surface,
			      &(LAYER(ldisplay,k).rect),
			      color);

	SDLayer_ForceWholeRefresh (ldisplay);
}

void	SDLayer_SetScrollingFactor (SDLayer_Display * ldisplay,
				    int layer_number, float sfactor)
{

#ifdef SDLAYER_CHECK_PARAMETERS
	SDLAYER_CHECK_LAYER_INDICE(ldisplay, layer_number);
#endif

	LAYER(ldisplay,layer_number).sfactor = sfactor;

}

void	SDLayer_SetViewport (SDLayer_Display * ldisplay,
			      Sint16 x, Sint16 y)
{

	SDL_Rect * rect;

	rect = &(ldisplay->viewport);

	/* Check if there were changes */
	if ( (rect->x == x) && (rect->y == y) )
		return;

	rect->x = x;
	rect->y = y;
	
	/* Request a whole refresh */
	SDLayer_ForceWholeRefresh(ldisplay);

}

void	SDLayer_SetVisible (SDLayer_Display * ldisplay, int n,
			    int toggle)
{

#ifdef SDLAYER_CHECK_PARAMETERS
	SDLAYER_CHECK_LAYER_INDICE(ldisplay, n);
#endif

	if ( ((toggle) && (LAYER(ldisplay,n).visible == 1))
	        ||
	      ((!toggle) && (LAYER(ldisplay,n).visible == 0))
 	   )
	{
		/* No change */
		printf ("No change !\n");
		return;
	}

	/* Change visibility */
	if ( toggle )
		LAYER(ldisplay,n).visible = 1;
	else
		LAYER(ldisplay,n).visible = 0;

	/* Force whole refresh */
	SDLayer_ForceWholeRefresh (ldisplay);

}

void	SDLayer_ToggleFullScreen (SDLayer_Display *ldisplay)
{
	Uint32 flags;

	flags = ldisplay->display->flags;

	/* Switch back to windowed mode */
	if ( flags & SDL_FULLSCREEN )
		flags &= ~SDL_FULLSCREEN;
	/* Switch to fullscreen mode */
	else
		flags |= SDL_FULLSCREEN;

	/* Initialize a new display surface */
	ldisplay->display = 
			SDL_SetVideoMode(ldisplay->display->w, ldisplay->display->h,
					 ldisplay->display->format->BitsPerPixel,
					 flags);
	
	SDLayer_ForceWholeRefresh(ldisplay);

}

