/* This bench tries to determine what is the most costly
 * between having a lot of little rectangles to update and
 * having less but bigger rectangles to update.
 */

/* A screen of 640x480 is divided in smaller regions.
 * The size of the grid is specified as input parameters
 * of the program.
 */

/* The benchmark measures the SDL_UpdateRects function call *only*
 */

#include <stdio.h>
#include "SDL.h"

#define WIDTH	640
#define HEIGHT	480
#define NITER	1024

static void bench_SDL_UpdateRects (int gridx, int gridy)
{

	SDL_Rect * regions;
	SDL_Surface * screen;
	Uint32	min_time, max_time, av_time, timer;
	Uint16  rw, rh, nrects;
	int i, j, k;

	nrects = gridx * gridy;
	regions = (SDL_Rect *)calloc( nrects, sizeof(SDL_Rect) );
	if ( regions == (SDL_Rect *)0 )
	{
	fprintf (stderr,
	"Not enough memory to allocate %d SDL rectangles\n", gridx*gridy);
	return;
	}
	
	SDL_Init (SDL_INIT_VIDEO);
	atexit(SDL_Quit);
	
	screen = SDL_SetVideoMode(WIDTH, HEIGHT, 0, SDL_ANYFORMAT);	
	if ( screen == (SDL_Surface *)0 )
	{
	fprintf (stderr,
	"Cannot initialize a 640x480@%d bpp windowed video mode.\n",
	screen->format->BitsPerPixel);
	goto endbench;
	}
	
	/* Size of each region */
	rw = WIDTH 	/ gridx;
	rh = HEIGHT	/ gridy;

	/* Initialize each region */
	for ( k = 0, j = 0; j < gridy; j++ )
	{
		for ( i = 0; i < gridx; i++, k++ )
		{
			regions[k].x = i * rw;
			regions[k].y = j * rh;
			regions[k].w = rw;
			regions[k].h = rh;
		}
	}

	/* BENCH LOOP */
	min_time = 999999999;
	max_time = 0;
	av_time  = 0;

	for ( k = 0; k < NITER; k++ )
	{

		/* Random fill the screen */
		SDL_FillRect (screen, (SDL_Rect *)0, SDL_MapRGB(screen->format,
								rand() * 255.0 / (RAND_MAX+1.0),
								rand() * 255.0 / (RAND_MAX+1.0),
								rand() * 255.0 / (RAND_MAX+1.0)
							       )
			     );

		/* Start benchmark time */
		timer = SDL_GetTicks();
		SDL_UpdateRects (screen, nrects, regions);
		/* Stop benchmark time */
		timer = SDL_GetTicks() - timer;
	
		if ( timer > max_time ) max_time = timer;
		if ( timer < min_time ) min_time = timer;
		av_time += timer;

	}

	av_time = (double)av_time / (double)NITER;

endbench:
	free (regions);
	regions = (SDL_Rect *)0;

	printf (">>> BENCHMARK RESULTS\n");
	printf ("\n");
	printf ("Number of iterations: %d\n", NITER);
	printf ("Number of regions: %d\n", nrects);
	printf ("Minimum time: %d\n", min_time);
	printf ("Maximum time: %d\n", max_time);
	printf ("Average time: %d\n", av_time);

}



static void help (const char * progname)
{

	printf ("Syntax is: %s [n_grid_x] [n_grid_y]\n",
		progname);
	exit (-1);

}

int main (int argc, char ** argv)
{
	int gridx, gridy;

	if ( argc < 3 ) help(argv[0]);

	gridx = atoi(argv[1]);
	gridy = atoi(argv[2]);

	bench_SDL_UpdateRects(gridx, gridy);

	exit (0);
}

