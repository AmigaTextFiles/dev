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
#include "SDL_Layer_Rects.h"
#include "SDL_image.h"
#include <time.h>
#include <string.h>
#include "libgen.h"


/* This is not a good practice, but we redefine the default chunk size
 * in SDL_Layer.h
 */
#undef SDLAYER_CHUNK_SIZE
#define SDLAYER_CHUNK_SIZE	512

static void print_gpl_message (const char * program)
{

    const char * msg = "\n\n%s  Copyright (C) 2008  Julien CLEMENT\n"
    "This program comes with ABSOLUTELY NO WARRANTY;\n"
    "This is free software, and you are welcome to redistribute it\n"
    "under certain conditions;.\n\n"
	;

	printf (msg, basename((char *)program));

}


typedef struct
{
	double	proba_flake;
	int	bench_mode;
	int	fullscreen;
	int	refresh_method;
}SnowState;

SnowState state;

#define WIDTH		1024
#define HEIGHT		768
#define BPP		32

/* Maximum value calculated experimentally */
#define NSPRITES	512

#define COLORKEY	0

static SDLayer_Display * ld;

static long count_sprites = 0;
static long max_sprites   = 0;
static long frames	  = 0;
static Uint32 timer	  = 0;

static long wind = 0;

#define CopyRect(dstptr,srcptr)		\
	do{				\
	(dstptr)->x = (srcptr)->x;	\
	(dstptr)->y = (srcptr)->y;	\
	(dstptr)->w = (srcptr)->w;	\
	(dstptr)->h = (srcptr)->h;	\
	}while(0)

typedef struct
{
	double weight;
}Flake;

typedef struct
{
	SDL_Surface * mask;
	SDL_Surface * surf;
	SDL_Rect      rect;
	int	      firstblit;
	int	      layer;
	
	/* Physics */
	Flake	      phys;
}Sprite;

static Sprite **sprites;

static Sprite * Sprite_Create (SDL_Surface * img, int layer_number);
static void	Sprite_Delete (Sprite * s);
static void	Sprite_Clear  (Sprite * s);
static void	Sprite_Blit   (Sprite * s);
static void	Sprite_Move   (Sprite * s);
static void	Sprite_Update (Sprite * s);
static void	Sprite_Position (Sprite * s, int x, int y);


/* Create a new sprite from an image */
static Sprite * Sprite_Create (SDL_Surface * img, int layer_number)
{
	Sprite * s;

	s = (Sprite *)calloc(1, sizeof(Sprite));	
	
	s->rect.x = 0;
	s->rect.y = 0;

	s->surf = SDL_DisplayFormat(img);
	s->mask = SDL_DisplayFormat(s->surf);
	
	s->rect.w = s->surf->w;
	s->rect.h = s->surf->h;

	SDL_FillRect (s->mask, &s->rect, COLORKEY);

	s->firstblit = 1;
	s->layer = layer_number;

	count_sprites ++;

	if ( count_sprites > max_sprites )
		max_sprites = count_sprites;

	/* Bigger and heavier flakes are on higher level layer */
	s->phys.weight = layer_number + rand() / (RAND_MAX + 1.0);

	return (s);
}



/* Free a sprite */
static void Sprite_Delete (Sprite * s)
{

	/* Blit the mask before deleting so that
 	 * there is no residual artifact on the display
 	 */
	Sprite_Clear(s);
	SDL_FreeSurface ( s->surf );
	SDL_FreeSurface ( s->mask );
	s->surf = (SDL_Surface *)0;
	s->mask = (SDL_Surface *)0;
	free ( s );
	count_sprites --;
}

/* Blit the mask back to the destination surface */
static void Sprite_Clear (Sprite * s)
{
	SDL_Rect src;

	CopyRect (&src, &s->rect);
	
	/* Translate rect to zero */
	src.x = src.y = 0;
	SDLayer_Blit (s->mask, &src, ld, &s->rect, s->layer); 
}	

/* Blit the sprite surface to the destination surface */
static void Sprite_Blit (Sprite * s)
{

	SDL_Rect src;

	CopyRect (&src, &s->rect);
	
	/* Translate rect to zero */
	src.x = src.y = 0;

	SDLayer_Blit (s->surf, &src, ld, &s->rect, s->layer); 

}

/* Move the sprite at the given speed */
static void Sprite_Move (Sprite * s)
{
	s->rect.y += s->phys.weight * 2.0;
	s->rect.x +=
		(int)( -1.0 + 3.0* rand() / (RAND_MAX + 1.0) );

	/* Apply wind */
	s->rect.x += ((double)wind / s->phys.weight + s->phys.weight*2.0*(-1.0+2.0*rand()/(RAND_MAX+1.0)));
}

/* Place a sprite at the given coordinates */
static void Sprite_Position (Sprite * s, int x, int y)
{
	s->rect.x = x;
	s->rect.y = y;
}


/* Update a sprite movement */
static void Sprite_Update (Sprite * s)
{
	Sprite_Clear(s);
	Sprite_Move(s);
	Sprite_Blit(s);
}

static void AllocSprites (void)
{
	sprites = (Sprite **)calloc(NSPRITES, sizeof(Sprite *));
}

static void FreeSprites (void)
{
	int k;

	for ( k = 0; k < NSPRITES; k++ )
	{
		if ( sprites[k] != (Sprite *)0 )
		{
			Sprite_Delete(sprites[k]);
			sprites[k] = (Sprite *)0;
		}
	}

	free ( sprites );
	sprites = (Sprite **)0;
}

/* Although this can seem costly in CPU, it is not.
 * I've printed the time spent in finding a new id
 * with this method, which is never greater than ...
 * zero ms.
 */
static int GetSpriteId (void)
{
	int k;

	for ( k = 0; k < NSPRITES; k++ )
	{
		if ( sprites[k] == (Sprite *)0 ){
			return k;
		}
	}

	fprintf (stderr,
	"No more space for another sprite !\n");
	
	exit (-1);
	return (-1);

}

static void helpAndQuit (void)
{
	printf ("--- snow demo help ---\n");
	printf ("\n");
	printf ("Options:\n");
	printf ("	-fs:\033[50Gtoggle optimize fullscreen mode if possible\n");
	printf ("	-flip:\033[50GUse SDL_Flip instead of SDL_UpdateRects\n");
	printf ("	-bench:\033[50Gtoggle benchmark mode, no delay between frames\n");
	printf ("	-p [proba_flake]:\033[50GProbability for a new flake to appear at each frame [0-100]");
	printf ("\033[50GDefault value is 60");
	printf ("\n");
	
	exit (0);
}

void parse_args (int argc, char ** argv)
{

	/* Default values */
	state.fullscreen 	= 0;
	state.proba_flake	= 60.0;
	state.bench_mode	= 0;
	state.refresh_method	= SDLAYER_RECTS;

	char ** arg = &argv[0];
	for ( ; argc > 1; argc -- )
	{
		/* Next arg */
		arg++;

		if ( !strcmp(*arg, "-fs") )
			state.fullscreen = 1;
		else
		if ( !strcmp(*arg, "-bench") )
				state.bench_mode = 1;
		else
		if ( !strcmp(*arg, "-p") )
		{
			argc --;
			if ( (argc == 0) )
			{
				fprintf (stderr,
						"Bad value for proba flake.\n");
				helpAndQuit();
			}
			else
			{
				arg++;
				state.proba_flake = atof (*arg);
			}
		}
		else
		if ( !strcmp(*arg, "-flip") )
			state.refresh_method = SDLAYER_FLIP;
		else
		if ( !strcmp(*arg, "-help") )
			helpAndQuit();
		else
		{
			fprintf (stderr,
					"Unrecognized option: %s\n", *arg);
			helpAndQuit();
		}
	}



}

static void welcome (void)
{
	char c;

	printf ("SDL_Layer Snow demo:\n");
	printf ("\n");
	printf ("- Escape to quit\n");
	printf ("- Click somewhere to change the viewport\n");
	printf ("- Space bar to restore the default viewport\n");
	printf ("- Press keypad 0,1,2,3,4 to show/hide a specific layer.\n");
	printf ("- Press 'f' to switch between fullscreen and windowed mode.\n");
	printf ("- Try launching with option \"-help\" to see the possible options.\n");
	printf ("EnJoY ! (press any key to start)\n");
	printf ("\n");
	
	fflush(stdin);
	c = getchar();
}

int main (int argc, char ** argv)
{
	SDL_Surface * screen = (SDL_Surface *)0;
	SDL_Surface * snow_back, * snow_little, * snow_middle, * snow_big, * cloud;
	SDL_Surface * surf;
	int w[5] = {WIDTH,WIDTH,WIDTH,WIDTH,1920}, h[5] = {HEIGHT,HEIGHT,HEIGHT,HEIGHT,1200};

	print_gpl_message(argv[0]);


	/* Core init */
	SDL_Init (SDL_INIT_VIDEO);
	atexit(SDL_Quit);
	srand(time(0));

	/* Parse args */
	parse_args (argc, argv);

	welcome();
	
	/* Init video */
	if ( state.fullscreen )
	{
		screen = SDL_SetVideoMode (800, 600, BPP, SDL_FULLSCREEN|SDL_DOUBLEBUF|SDL_HWSURFACE);
		if ( screen == (SDL_Surface *)0 )
			fprintf (stderr, "Fullscreen mode failed, stay in windowed mode.\n");
	}
	if ( (screen == (SDL_Surface *)0) || !state.fullscreen )
		screen = SDL_SetVideoMode (800, 600, BPP, SDL_ANYFORMAT);

	/* Remind options */
	printf ("Benchmark mode:\033[24G%s\n", (state.bench_mode) ? ("Yes") : ("No"));
	printf ("Proba flake:\033[24G%lf\n", state.proba_flake);
	printf ("Refresh method:\033[24G%s\n",
			(state.refresh_method == SDLAYER_RECTS) ? ("Rects") : ("Flip"));

	/* Create layered display */
	ld = SDLayer_CreateRGBLayeredDisplay (SDL_ANYFORMAT, state.refresh_method,
					      5, w, h, BPP, 0, 0, 0, 0);


	/* Create layers */

	/* Set color key to black: important or you will only see the foreground layer ! */
	SDLayer_SetColorKey(ld, SDL_SRCCOLORKEY, 0);

	SDL_SetAlpha (SDLayer_GetLayer(ld,2), SDL_SRCALPHA, 128);
	SDL_SetAlpha (SDLayer_GetLayer(ld,3), SDL_SRCALPHA, 100);
	SDL_SetAlpha (SDLayer_GetLayer(ld,4), SDL_SRCALPHA, 80);
	
	SDLayer_SetScrollingFactor (ld, 4, 3.0);

	/* Load resources */
	surf = IMG_Load("cloud.jpg");
	if ( surf == (SDL_Surface *)0 )
	{
		fprintf (stderr,
		"Missing resource: cloud.jpg\n");
		exit (-1);
	}	
	
	cloud = SDL_DisplayFormat(surf);
	SDL_FreeSurface(surf);


	surf = IMG_Load("snow_back.jpg");
	if ( surf == (SDL_Surface *)0 )
	{
		fprintf (stderr,
		"Missing resource: snow_back.jpg\n");
		exit (-1);
	}	
	
	snow_back = SDL_DisplayFormat(surf);
	SDL_FreeSurface(surf);

	surf = IMG_Load("snow_little.png");
	if ( surf == (SDL_Surface *)0 )
	{
		fprintf (stderr,
		"Missing resource: snow_little.png\n");
		exit (-1);
	}	
	
	snow_little = SDL_DisplayFormat(surf);
	SDL_FreeSurface(surf);

	surf = IMG_Load("snow_middle.png");
	if ( surf == (SDL_Surface *)0 )
	{
		fprintf (stderr,
		"Missing resource: snow_middle.png\n");
		exit (-1);
	}	
	
	snow_middle = SDL_DisplayFormat(surf);
	SDL_FreeSurface(surf);

	surf = IMG_Load("snow_big.png");
	if ( surf == (SDL_Surface *)0 )
	{
		fprintf (stderr,
		"Missing resource: snow_big.png\n");
		exit (-1);
	}	
	
	snow_big = SDL_DisplayFormat(surf);
	SDL_FreeSurface(surf);


	/* Allocate sprite table */
	AllocSprites();

	/* Blit background image */
	SDL_Rect src;

	src.x = 0;
	src.y = 0;
	src.w = snow_back->w;
	src.h = snow_back->h;
	SDLayer_Blit (snow_back, &src, ld, &src, 0);

	/* Blit clouds (foreground layer) */
	src.x = 0;
	src.y = 0;
	src.w = cloud->w;
	src.h = cloud->h;
	SDLayer_Blit (cloud, &src, ld, &src, 4);

	/* Main loop */
	int done = 0;
	int k;	
	SDL_Event evt;

	SDL_Surface * flake[3] = {
		snow_little,
		snow_middle,
		snow_big
	}; 
	int vis0 = 1, vis1 = 1, vis2 = 1, vis3 = 1, vis4 = 1;

	/* Start timer */
	timer = SDL_GetTicks();

	/* Avoid the yellow line on the border ... */
	SDLayer_SetViewport(ld, 200, 128);

	for ( ; !done ; )
	{
	
		/* Manage user events */
		while ( SDL_PollEvent(&evt) > 0 )
		{
			switch (evt.type)
			{
				case SDL_KEYDOWN:
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
					
					case SDLK_KP3:
						vis3 = (vis3 != 0) ?  (0) : (1);
						SDLayer_SetVisible(ld, 3,  vis3);
						printf ("Layer 2 visibility: %d\n", vis3);
						break;

					case SDLK_KP4:
						vis4 = (vis4 != 0) ?  (0) : (1);
						SDLayer_SetVisible(ld, 4,  vis4);
						printf ("Layer 4 visibility: %d\n", vis4);
						break;

					case SDLK_SPACE:
						SDLayer_SetViewport (ld, 200, 128);
						break;

					case SDLK_f:
						SDLayer_ToggleFullScreen(ld);
						break;

					case SDLK_ESCAPE:
						done = 1;
						break;
					
					default:
						;
					}
				
				break;

				case SDL_MOUSEBUTTONDOWN:
					SDLayer_SetViewport(ld,
						evt.motion.x-400,
						evt.motion.y-300);
					break;

				default:
					;
			}
		}

		/* Random change the wind force */
		if ( rand() / (RAND_MAX + 1.0) >= 0.98 )
			wind += -2.0 + 4.0*rand() / (RAND_MAX + 1.0);

		/* Create a new snowflake */
		if ( rand() / (RAND_MAX + 1.0) >= (100.0-(double)state.proba_flake)/100.0)
		{
			Sprite * s;
			Sint16 x, y;
			int layer;
			
			x = (double)WIDTH * rand() / (RAND_MAX + 1.0);
			y = 32.0  * rand() / (RAND_MAX + 1.0);

			/* Randomly choose a layer: the closer the bigger */
			double rsort = rand() / (RAND_MAX + 1.0);			
			
			if ( rsort >= 0.9 ) layer = 3;
			else if (rsort >= 0.75 ) layer = 2;
			else layer = 1;

			/* Create a new sprite on layer 1 */
			s = Sprite_Create( flake[layer-1], layer );
			
			/* Position it */
			Sprite_Position (s, x, y);

			/* Reference if in the sprite table */
			int id;
			id = GetSpriteId ();
			sprites[id] = s;
		}

		/* Animate the sprites */
		for  ( k = 0; k < NSPRITES; k++ )
		{
			if ( sprites[k] != (Sprite *)0 )
			{
				if ( sprites[k]->firstblit == 1 )
				{
					Sprite_Blit(sprites[k]);
					/* Ready for update at next step */
					sprites[k]->firstblit = 0;
					continue;
				}else
					Sprite_Update(sprites[k]);
	
				/* If the current sprite is beyond the lower Y limit of the screen,
 				 * discard it
 				 */
				if ( sprites[k]->rect.y >= HEIGHT )
				{
					Sprite_Delete(sprites[k]);
					sprites[k] = (Sprite *)0;
				}
			}
		}

		/* Refresh Layered Display */
		SDLayer_Update (ld);
		
		/* Slow down a little when using a dirty rectangles refresh method for
 		   it is fast ! */
		if ( (ld->refresh_method == SDLAYER_RECTS) && !(state.bench_mode) )
			SDL_Delay(10);

		frames ++;

	}

	/* End timer */
	timer = SDL_GetTicks() - timer;
		
	FreeSprites();

	SDL_FreeSurface ( snow_back );
	SDL_FreeSurface ( snow_little );
	SDL_FreeSurface ( snow_middle );
	SDL_FreeSurface ( snow_big );
	SDL_FreeSurface ( cloud );

	SDLayer_FreeLayeredDisplay(ld);

	if ( state.bench_mode )
	{
		printf ("Benchmark report:\n");
		printf ("Maximum of sprites drawn: %ld\n", max_sprites);
		printf ("Average number of frames per second: %ld\n", 1000 * frames / timer);
		printf ("Memory chunk size: %d\n", SDLAYER_CHUNK_SIZE);
	}

	exit (0);

}

