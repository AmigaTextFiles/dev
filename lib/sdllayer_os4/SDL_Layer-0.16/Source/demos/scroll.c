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
#include "SDL_image.h"
#include "libgen.h"

static void print_gpl_message (const char * program)
{

    const char * msg = "\n\n%s  Copyright (C) 2008  Julien CLEMENT\n"
    "This program comes with ABSOLUTELY NO WARRANTY;\n"
    "This is free software, and you are welcome to redistribute it\n"
    "under certain conditions;.\n\n"
	;

	printf (msg, basename((char *)program));

}


int main (int argc, char ** argv)
{

	SDL_Surface * screen;
	SDL_Surface * canyon, * demo, * cloud;
	SDLayer_Display * ld;
	SDL_Rect rect;
	int finished = 0;
	int w[3], h[3];

	print_gpl_message(argv[0]);

	SDL_Init(SDL_INIT_VIDEO);
	atexit (SDL_Quit);

	canyon = IMG_Load("canyon.jpg");
	demo   = IMG_Load("demo.png");
	cloud  = IMG_Load("cloud.jpg");

	if ( (canyon == NULL) || (demo == NULL) || (cloud == NULL) )
	{
		fprintf (stderr,
		"One of the necessary resources is missing. Are you in the \"demos\" subdirectory ?\n");
		exit (-1);
	}

	printf ("SDL_Layer Scrolling demo:\n");
	printf ("\n");
	printf ("- Escape to quit\n");
	printf ("- Move mouse to scroll (stop scrolling by moving the mouse to the center of the screen)\n");
	printf ("- Press keypad 0,1,2 to show/hide a specific layer.\n");
	printf ("- Press spacebar to switch to 800x600 (not optimal, clipped to a 640x480 viewport)\n");
	printf ("- Press 'f' to switch between fullscreen and windowed modes.\n");
	printf ("\n");
	printf ("Best viewed at 640x480 resolution.\n");
	printf ("EnJoY ! (press any key to start)\n");
	printf ("\n");

	fflush(stdin);
	char c;
	c = getchar();

	screen = SDL_SetVideoMode(640, 480, 32, SDL_ANYFORMAT);

	if ( screen == (SDL_Surface *)0 )
	{
		fprintf (stderr,
		"Cannot switch to 640x480@32 bpp  HWSURFACE, DOUBLEBUF, FULLSCREEN\n");
		fprintf (stderr,
		"Trying 800x600\n");
		screen = SDL_SetVideoMode(800, 600, 32, SDL_HWSURFACE|SDL_DOUBLEBUF|SDL_FULLSCREEN);
		
		if ( screen == (SDL_Surface *)0 )
		{
			fprintf (stderr,
		"Cannot switch to 800x600@32 bpp  HWSURFACE, DOUBLEBUF, FULLSCREEN\n");
			fprintf (stderr,
		"Trying a default windowed 640x480 mode\n");
			screen = SDL_SetVideoMode(640, 480, 0, SDL_HWSURFACE);
		}
	}

	atexit(SDL_Quit);
	
	/* Canyon */
	w[0] = 800;
	h[0] = 600;

	/* D E M O */
	w[1] = 3200;
	h[1] = 1920;

	/* Clouds */
	w[2] = 1920;
	h[2] = 1200;

	ld = SDLayer_CreateRGBLayeredDisplay (SDL_ANYFORMAT, SDLAYER_FLIP,
					      3, w, h, 32, 0, 0, 0, 0);

	if ( ld == NULL )
	{
	fprintf (stderr,
	"Failed to create an RGB layered display.\n");
	exit (-1);
	}

	rect.x = 0;
	rect.y = 0;
	rect.w = 800;
	rect.h = 600;
	
	SDLayer_Blit (canyon, &rect, ld, &rect, 0);

	rect.w = 1920;
	rect.h = 1200;
	SDLayer_Blit (cloud, &rect, ld, &rect,  2);

	rect.w = 3200;
	rect.h = 1920;
	SDLayer_Blit (demo, &rect, ld, &rect,   1);
	
	SDL_SetAlpha(SDLayer_GetLayer(ld,2), SDL_SRCALPHA, SDL_ALPHA_TRANSPARENT + 100);
	SDL_SetAlpha(SDLayer_GetLayer(ld,1), SDL_SRCALPHA, SDL_ALPHA_TRANSPARENT + 32);

	SDL_FreeSurface (canyon);
	SDL_FreeSurface (demo);
	SDL_FreeSurface (cloud);
	
	SDL_WarpMouse (screen->w/2, screen->h/2);

	SDLayer_SetScrollingFactor(ld, 2, 1.0);
	SDLayer_SetScrollingFactor(ld, 1, 2.0);
	SDLayer_SetScrollingFactor(ld, 0, 0.125);
	
	SDL_Event evt;
	/* Visibility flags */
	int vis0 = 1, vis1 = 1, vis2 = 1;
	Sint16 vpx = 0, vpy = 0, dx = 0, dy = 0;

	for ( ; finished == 0 ; )
	{

		

		while ( SDL_PollEvent(&evt) > 0 )
		{

			if (evt.type == SDL_KEYDOWN)
			{

				switch (evt.key.keysym.sym)
				{
					case SDLK_KP0:
						vis0 = (vis0 != 0) ?  (0) : (1);
						SDLayer_SetVisible(ld, 0,  vis0);
						printf ("Layer 0 visibility: %d\n", vis0);
						break;

					case SDLK_KP1:
						vis1 = (vis1 != 0) ?  (0) : (1);
						SDLayer_SetVisible(ld, 1,  vis1);
						printf ("Layer 1 visibility: %d\n", vis1);
						break;

					case SDLK_KP2:
						vis2 = (vis2 != 0) ?  (0) : (1);
						SDLayer_SetVisible(ld, 2,  vis2);
						printf ("Layer 2 visibility: %d\n", vis2);
						break;
		
					case SDLK_ESCAPE:
						finished = 1;
						break;

					case SDLK_SPACE:
						screen = SDL_SetVideoMode(800, 600, 32,
									SDL_HWSURFACE|SDL_DOUBLEBUF|SDL_FULLSCREEN);
						if ( screen == (SDL_Surface *)0 )
						{
							printf ("Switch to 800x600 failed.\n");
							finished = 1;
							break;
						}
						break;

					case SDLK_f:
						SDLayer_ToggleFullScreen(ld);
						break;

					default:
						break;
				}

			}
			else if (evt.type == SDL_MOUSEMOTION)
			{
				if ( evt.motion.x > 400 ) dx = 1;
				else if ( evt.motion.x < 200 ) dx = -1;
				else dx = 0;

				if ( evt.motion.y > 300 ) dy = 1;
				else if ( evt.motion.y < 200 ) dy = -1;
				else dy = 0;
			}
		}

		if ( dx > 0 ) { vpx ++; }
		else if ( dx < 0 ) vpx --;
	
		if ( dy > 0 ) vpy ++;
		else if ( dy < 0 ) vpy --;

		if ( dx || dy )
		{
			/* Clip viewport */
			if ( vpx < 0 ) vpx = 0;
			if ( vpy < 0 ) vpy = 0;
			if ( vpx > (1920-640) ) vpx = 1920-640;
			if ( vpy > (1200-480) ) vpy = 1200-480;

			SDLayer_SetViewport (ld, vpx, vpy);
		}

		SDLayer_Update(ld);
	}

	SDLayer_FreeLayeredDisplay(ld);

	exit(-1);

}

