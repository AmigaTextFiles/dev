/*
  lesson4.cpp
  Cone3D GFX with SDL lesson 4.
  Made by Marius Andra 2002
  http://cone3d.gamedev.net

  You can use the code for anything you like.
  Even in a commercial project.
  But please let me know where it ends up.
  I'm just curious. That's all.
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

#include <SDL/SDL.h>

#include "font.h"

SDL_Surface *screen;   // The screen surface
SDLFont *font1;        // 2 fonts
SDLFont *font2;
int y=480;             // Position of the scrolling text

char *string="Cone3D GFX with SDL Lesson 4"; // The scrolling text

void DrawScene()
{
  SDL_FillRect(screen,NULL,0x000000);   // Clear the entire screen with black

  // Draw the string 'string' to the center of the screen, position: y
  drawString(screen,font1,320-stringWidth(font1,string)/2,y,string);

  // Draw a counter to the top-left of the screen
  drawString(screen,font2,1,1,"Scroll location: %d",y);

  // Draw the webspace url to the bottom-right of the screen
  drawString(screen,font2,639-stringWidth(font2,"http://cone3d.gamedev.net"),
                                         480-16,"http://cone3d.gamedev.net");
  SDL_Flip(screen);
}

int main(int argc, char *argv[])
{
  // Initalize SDL
  if ( SDL_Init(SDL_INIT_AUDIO|SDL_INIT_VIDEO) < 0 )
  {
    printf("Unable to init SDL: %s\n", SDL_GetError());
    exit(1);
  }
  atexit(SDL_Quit);

  // Load a bmp file as the icon of the program
  SDL_WM_SetIcon(SDL_LoadBMP("icon.bmp"),NULL);

  // Initalize the video mode
  screen=SDL_SetVideoMode(640,480,0,SDL_SWSURFACE|SDL_HWPALETTE|SDL_FULLSCREEN);
  if ( screen == NULL )
  {
    printf("Unable to set 640x480 video: %s\n", SDL_GetError());
    exit(1);
  }

  // Load in the fonts
  font1 = initFont("data/font1");
  font2 = initFont("data/font2",1,1,0);

  // Loop a bit
  int done=0;
  while(done == 0)
  {
    SDL_Event event;

    while ( SDL_PollEvent(&event) )
    {
      // If someone closes the prorgam, then quit
      if ( event.type == SDL_QUIT )  {  done = 1;  }

      if ( event.type == SDL_KEYDOWN )
      {
        // If someone presses ESC, then quit
        if ( event.key.keysym.sym == SDLK_ESCAPE ) { done = 1; }
      }
    }

    // Draw the scene
    DrawScene();

    // Scroll the text
    y-=1;if(y<-32) y=480;
  }

  // Let's clean up...
  freeFont(font1);
  freeFont(font2);

  return 0;
}

