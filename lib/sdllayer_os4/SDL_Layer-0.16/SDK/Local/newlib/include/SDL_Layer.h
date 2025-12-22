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

#ifndef _SDL_Layer_h_
#define _SDL_Layer_h_

#include "SDL.h"

/** @file	SDL_Layer.h
 *  @author	Julien CLEMENT
 *  @brief	A generic system to manage multiple blit layers
 *  		with the SDL library (http://www.libsdl.org)
 *  @note	You can use it either with the dirty rectangles
 *  		method (SDL_UpdateRects) or with a whole refresh
 *  		method (SDL_Flip).
 *  @note	Comments, suggestions, bugs are welcomed.
 *  		Email me at:
 *  		clementj2005@yahoo.fr
 */


/** @struct	SDLayer
 *  @brief	A surface to blit at a particular plane of the display.
 */
typedef struct
{

	SDL_Surface	*surface; /**< Bitmap to blit on the screen	*/
	
	SDL_Rect	rect;	  /**< Surface rectangle 		*/
	int		visible;  /**< Current visibility		
				       0 (invisible) 1 (visible)	*/
	float		sfactor;  /**< Scrolling factor 		*/

	SDL_Rect	* rects;  /**< Dirty rectangles			*/
	int		n_rects;  /**< Number of dirty rectangles	*/
	int		n_chunks; /**< Number of memory chunks		*/

} SDLayer;

/** @struct	SDLayer_Display
 *  @note   	The lowest layer is the layer at indice 0 (zero).
 */
typedef struct
{

	SDL_Surface	*display;		/**<	Display surface					*/

	SDLayer		*layers;		/**<	Layers						*/
	int		n_layers;		/**<	Number of layers				*/

	int		refresh_method; 	/**<	Decide whether we use a dirty rect (1)
							or a whole refresh method (0).
							Default is whole refresh. 			*/
	
	/* Actually the "w" and "h" fields are not changeable,
	 * they're initialized to the size of the display surface.
	 */
	SDL_Rect viewport;	/**< Sliding window moving on each layer used for scrolling effects. */
	int	 need_refresh; 	/**< Set to one when a blit affect the display */
	int	 force_whole_refresh; /**< In the dirty rectangles method, discard all the
					   pending refresh stacks and refresh the whole screen instead. */

} SDLayer_Display;

/** Refresh method to use */
#define SDLAYER_RECTS	(0x1) /**< Dirty rectangles */
#define SDLAYER_FLIP	(0x0) /**< Flip (SDL_Flip)  */

/** When using a dirty rectangle method, we avoid frequent calls to malloc
 *  by managing memory "chunks".
 *  This constant specifies the size of those memory chunks.
 *
 *  Default value: 128
 */
#define	SDLAYER_CHUNK_SIZE	( 128 )

/** Distance to decide if we should merge 2 rectangles or not
  * (Experimental)
  * The default value (8) has been established experimentally.
  * Merging rectangles slightly improves the FPS (~ +20 frames)
  * You can desactivate it by commenting out the SDLAYER_USE_MERGE macro
  */
#define SDLAYER_USE_MERGE
#define SDLAYER_MERGE_DISTANCE	( 8 )


/** Create a new LayeredDisplay with each surface beeing allocated and
 *  converted into the display format.
 *  
 *  Parameters are exactly the same as the ones of SDL_CreateRGBSurface.
 *  See the SDL documentation for more information.
 *  
 *  @param	flags	SDL flags plus the specific flag <b>SDL_DIRTYRECTS</b> if you want to use
 *  			a dirty refresh method. If this flag is not set, a whole refresh policy
 *  			is choosen, using SDL_Flip().
 *  @param	refresh_method	Either SDLAYER_FLIP (use SDL_Flip) or SDLAYER_RECTS (use SDL_UpdateRects)
 *  @param	n_layers	Number of layers of the layered display
 *  @param	width		Width of each surface/layer
 *  @param	height		Height of each surface/layer
 *  @param	bitsPerPixel	number of bits per pixel for each surface/layer
 *  @param	Rmask,Gmask,Bmask,Amask		RGBA masks for each surface/layer
 *  @return	A newly allocated layered display
 *
 *  @see	SDLayer_FreeLayeredDisplay
 *  @see	SDL_CreateRGBSurface
 */
SDLayer_Display * 
	SDLayer_CreateRGBLayeredDisplay (Uint32 flags, int refresh_method,
					 int n_layers, int *widths, int *heights, int bitsPerPixel,
                                     	 Uint32 Rmask, Uint32 Gmask, Uint32 Bmask, Uint32 Amask);


/** Sets a global color key value for all the layers of a layered display.
 *
 *  @param	layered_display		The layered display to which we set the global colorkey
 *  @param	flags			SDL Flags passed to SDL_SetColorKey
 *  @param	key			Value of the color used as a transparent value
 *  
 *  @see	SDL_SetColorKey
 */
void	SDLayer_SetColorKey (SDLayer_Display * layered_display, Uint32 flags, Uint32 key);


/** Get a pointer to the layer at <i>layer_number</i>.
 *  Useful to perform custom operations on a particular layer other than a simple blit.
 *  For instance, modifying the Alpha value or drawing primitives through direct access to
 *  the pixel data.
 *  Beware of the fact that any operation on the pixels which doesn't use the
 *  SDLayer_Blit function will not benefit from the refresh management system of the library.
 *
 *  @param	layered_display		The layered display to get a surface/layer from
 *  @param	layer_number		Number of the layer to get
 *  @return	A pointer to the layer at <i>layer_number</i>
 *
 */
SDL_Surface * SDLayer_GetLayer (SDLayer_Display * layered_display, int layer_number);


/** Frees the memory allocated for the layered display.
 *  It internally calls SDL_FreeSurface on each layer surface.
 *
 *  @param	layered_display		The layered display to free
 */
void	SDLayer_FreeLayeredDisplay	    (SDLayer_Display * layered_display);


/** Blits a surface onto a particular layer of the layered display.
 *  This function also performs various operations like adding dirty rectangles
 *  (if needed), clipping, and more.
 *
 *  @param	src		Surface to blit from
 *  @param	srcrect		Area of the source surface to blit
 *  @param	layered_display	Layered display to blit to
 *  @param	dstrect		Area of the layered display to which the blit is performed
 *  @param	layer_number	Layer number on which the blit will be performed
 *
 *  @see SDLayer_Update
 *  @see SDL_BlitSurface
 */
void	SDLayer_Blit (SDL_Surface * src, SDL_Rect * srcrect,
		      SDLayer_Display * layered_display, SDL_Rect * dstrect,
		      int layer_number);

/** Make a blit of all the layers of the layered display on the display surface (screen),
 *  beginning from the lowest layer (layer at indice 0).
 *  Then, update the screen according to the selected refresh method (dirty rectangles or flip).
 *
 *  @param	layered_display		The layered display to blit on the screen
 *
 *  @see	SDL_UpdateRects
 *  @see	SDL_Flip
 */
void	SDLayer_Update (SDLayer_Display * layered_display);

/** Set the "force_whole_refresh" flag to one so that the next call to
  * SDL_UpdateLayeredDisplay performs a whole refresh of the display,
  * even if there're pending dirty rectangles to update.
  * If any, there will be discarded.
  */
void	SDLayer_ForceWholeRefresh (SDLayer_Display * layered_display);

/** Fill each layer with an uniform color.
 *
 *  @param	layered_display		The layered display to fill with color
 *  @param	color			The color used to fill each surface/layer
 *
 *  @see	SDL_FillRect
 */
void	SDLayer_Fill	(SDLayer_Display * layered_display, Uint32 color);


/** Toggle whether or not a given layer is show on the screen.
 *  
 *  @param	layered_display		The layered display
 *  @param	layer_number		Number of the layer to change the visilibity
 *  @param	toggle			1: show layer, 0: hide layer
 *
 *  @note	If any change is provided to the layer, this function will trigger a whole refresh
 *  		of the display.
 *  @note	By default, all the layers are visible.
 */
void	SDLayer_SetVisible	(SDLayer_Display * layered_display, int layer_number, int toggle);

/** Change the scrolling factor of a given layer.
  * Useful only when the layer size is bigger than the display size.
  * It is represented with a single precision floating point number.
  */
void	SDLayer_SetScrollingFactor	(SDLayer_Display * layered_display, int layer_number, float scrolling_factor);

/** Changes the current position of the viewport.
  * Note that the coordinates can go beyond a layer's size, including negative coordinates.
  * The blit will then be clipped to the visible part of the layers.
  */
void	SDLayer_SetViewport	(SDLayer_Display * layered_display, Sint16 x, Sint16 y);


/** A replacement to SDL_WM_ToggleFullScreen.
 *  This function is supposed to work on all systems. It simply makes a copy of the current
 *  screen and attempt to switch to fullscreen mode by calling SDL_SetVideoMode another
 *  time.
 *  In case of failure, the program remains in windowed mode.
 *  If already in fullscreen mode, switch back to windowed mode.
 */
void	SDLayer_ToggleFullScreen (SDLayer_Display * layered_display);

#endif

