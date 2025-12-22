/*
	SDL_anim:  an animation library for SDL
	Copyright (C) 2001  Michael Leonhard

	This library is under the GNU Library General Public License.
	See the file "COPYING" for details.

	Michael Leonhard
	mike@tamale.net
"sh" 1st
g++ -m68020 -m68881 -noixemul -g -O2 -o showanim showanim.c -lSDL_image -ljpeg -lpng_2 -lz -lSDL_anim `sdl-config2 --libs --cflags`

*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <SDL.h>
#include <SDL_image.h>
#include "SDL_anim.h"

void Checkered_Background( SDL_Surface *screen ) {
    int x, y, size, startcolor, c;
	Uint32 color[2];
	SDL_Rect rect;

    color[0] = SDL_MapRGB(screen->format, 0x66, 0x66, 0x66);
    color[1] = SDL_MapRGB(screen->format, 0x99, 0x99, 0x99);
    
	size = (screen->w > screen->h)? screen->w : screen->h;
	size /= 8;
	startcolor = 0;
	for( y = 0; y < screen->h; y += size ) {
		c = startcolor;
		for( x = 0; x < screen->w; x += size ) {
			rect.x = x;
			rect.y = y;
			rect.w = size;
			rect.h = size;
			SDL_FillRect( screen, &rect, color[c] );
			c++;
			c &= 1;
			}
		startcolor++;
		startcolor &= 1;
		}
	}

int main(int argc, char *argv[])
{
	SDL_Surface *screen;
	SDL_Animation *anim;
	SDL_Rect rect;
	SDL_Event event;
	int done;
	Uint32 black, start;

	/* Check command line usage */
	if( argc != 2 ) {
		fprintf( stderr, "Usage: %s <anim_file>\n", argv[0] );
		return 1;
		}

	/* Initialize the SDL library */
	if( SDL_Init( SDL_INIT_VIDEO ) < 0 ) {
		fprintf( stderr, "Couldn't initialize SDL: %s\n",SDL_GetError() );
		return 255;
		}

	/* Load the animation */
	/* Use SDL_image's IMG_Load function to read the image file */
	anim = ANIM_Load( argv[1], IMG_Load );
	if( anim == NULL ) {
		fprintf( stderr, "Couldn't load %s: %s\n", argv[1], ANIM_GetError() );
		SDL_Quit();
		return 2;
		}

	// Create a display for the anim
/*	depth = SDL_VideoModeOK(anim->w + 1, anim->h, 32, SDL_SWSURFACE);
	// Use the deepest native mode, except that we emulate 32bpp for
	// viewing non-indexed anims on 8bpp screens
	if ( (anim->surface->format->BytesPerPixel > 1) && (depth == 8) ) {
	    depth = 32;
	}
*/
	screen = SDL_SetVideoMode( anim->w, anim->h, 16, SDL_SWSURFACE );//SDL_FULLSCREEN
	if( screen == NULL ) {
		fprintf( stderr, "SDL_SetVideoMode() failed: %s\n", SDL_GetError() );
		SDL_Quit();
		return 3;
		}

	SDL_WM_SetCaption( argv[1], "showanim" );

	// Set the palette, if one exists
	if( anim->surface->format->palette ) SDL_SetColors( screen, anim->surface->format->palette->colors, 0, anim->surface->format->palette->ncolors );

/**/	if( !ANIM_DisplayFormat( anim ) ) {
		fprintf( stderr, "Anim_DisplayFormat() failed: %s\n", ANIM_GetError() );
		return 4;
		}

	black = SDL_MapRGB( screen->format, 0, 0, 0 );

	done = 0;
	start = SDL_GetTicks();
	while( !done ) {
		while( SDL_PollEvent( &event ) ) {
			switch( event.type ) {
				case SDL_QUIT:
					done = 1;
					break;
				case SDL_KEYDOWN:
					if( event.key.keysym.sym == SDLK_ESCAPE ) done = 1;
					start = SDL_GetTicks();
					break;
				}
			}

		Checkered_Background( screen );
		rect.x = 0;
		rect.y = 0;
		ANIM_BlitFrame( anim, start, SDL_GetTicks(), screen, &rect );
		SDL_UpdateRect( screen, 0, 0, 0, 0 );
		SDL_Delay( 100 );
		}

	ANIM_Free(anim);
	SDL_Quit();
	return 0;
	}
