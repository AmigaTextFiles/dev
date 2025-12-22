/*
	SDL Tutorial based on: http://cone3d.gamedev.net/

	to build a binary use this compiler line:
	gcc -O2 `sdl-config --cflags` tutorial_02.c -o tutorial_02 `sdl-config --libs`

	http://sdl.innoidea.hu
*/

#include <stdio.h>
#include <stdlib.h>

#include <SDL/SDL.h>

SDL_Surface *back;
SDL_Surface *image;
SDL_Surface *screen;

int xpos=0,ypos=0;

char pic_back[]="pictures/bg.bmp";
char pic_image[]="pictures/image.bmp";


void Slock(SDL_Surface *screen)
{
	if ( SDL_MUSTLOCK(screen) )
	{
		//if ( SDL_LockSurface(screen) < 0 )
		{
			return;
		}
	}
}

void Sulock(SDL_Surface *screen)
{
	if ( SDL_MUSTLOCK(screen) )
	{
		//SDL_UnlockSurface(screen);
	}
}

int InitImages()
{
	back = SDL_LoadBMP(pic_back);
	image = SDL_LoadBMP(pic_image);
	return 0;
}

void DrawIMG(SDL_Surface *img, int x, int y)
{
	SDL_Rect dest;
	dest.x = x;
	dest.y = y;
	SDL_BlitSurface(img, NULL, screen, &dest);
}

void DrawIMG2(SDL_Surface *img, int x, int y, int w, int h, int x2, int y2)
{
	SDL_Rect dest;
	SDL_Rect dest2;

	dest.x = x;
	dest.y = y;
	dest2.x = x2;
	dest2.y = y2;
	dest2.w = w;
	dest2.h = h;
	SDL_BlitSurface(img, &dest2, screen, &dest);
}

void DrawBG()
{
	Slock(screen);
	DrawIMG(back, 0, 0);
	Sulock(screen);
}

void DrawScene()
{
	Slock(screen);
	DrawIMG2(back, xpos-2, ypos-2, 132, 132, xpos-2, ypos-2);
	DrawIMG(image, xpos, ypos);

	SDL_Flip(screen);
	Sulock(screen);
}

int main(int argc, char *argv[])
{
	Uint8* keys;
	SDL_Event event;
	int done=0;

	if ( SDL_Init(SDL_INIT_AUDIO|SDL_INIT_VIDEO) < 0 )
	{
		printf("Unable to init SDL: %s\n", SDL_GetError());
		exit(1);
	}
	atexit(SDL_Quit);

	screen=SDL_SetVideoMode(640,480,0,SDL_HWSURFACE|SDL_DOUBLEBUF);
	if ( screen == NULL )
	{
		printf("Unable to set 640x480 video: %s\n", SDL_GetError());
		exit(1);
	}

	InitImages();
	DrawBG();

	while(done == 0)
	{
		while ( SDL_PollEvent(&event) )
		{
			if ( event.type == SDL_QUIT )  {  done = 1;  }

			if ( event.type == SDL_KEYDOWN )
			{
				if ( event.key.keysym.sym == SDLK_ESCAPE ) { done = 1; }
			}
		}
	
		keys = SDL_GetKeyState(NULL);
		if ( keys[SDLK_UP] ) { ypos -= 1; }
		if ( keys[SDLK_DOWN] ) { ypos += 1; }
		if ( keys[SDLK_LEFT] ) { xpos -= 1; }
		if ( keys[SDLK_RIGHT] ) { xpos += 1; }

		DrawScene();
	}

	return 0;
}
