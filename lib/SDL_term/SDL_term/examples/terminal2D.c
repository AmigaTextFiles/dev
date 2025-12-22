/* 
 * Copyright (c) 2005 Nicolas P. Rougier
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this software; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include <stdlib.h>
#include <SDL.h>
#include "SDL_terminal.h"


void key_press (SDL_keysym *keysym)
{
    switch (keysym->sym) {
	case SDLK_ESCAPE:
		SDL_Quit ();
		exit (EXIT_SUCCESS);
	    break;
	default:
	    break;
	}
}

int main (int argc, char **argv)
{
    Uint32 last_tick = 0;
    int fps = 100;
    SDL_Surface *screen, *image;

    if (SDL_Init (SDL_INIT_VIDEO) < 0) {
	    fprintf (stderr, "Video initialization failed: %s", SDL_GetError());
		SDL_Quit();
		exit (EXIT_FAILURE);
	}    
    screen = SDL_SetVideoMode(800, 600, 32, SDL_SWSURFACE | SDL_DOUBLEBUF);
    image = SDL_LoadBMP ("gnu-tux.bmp");
    if (!image) {
        fprintf (stderr, "Cannot load image");
		SDL_Quit();
		exit (EXIT_FAILURE);
    }

    SDL_WM_SetCaption ("SDL Terminal without OpenGL", NULL);


    SDL_Terminal *terminal =  SDL_CreateTerminal ();
    SDL_TerminalSetFont (terminal, "./VeraMono.ttf", 12);
    SDL_TerminalSetSize (terminal, 80, 25);
    SDL_TerminalSetPosition (terminal, 0, 0);


    SDL_TerminalSetColor (terminal, 255,255,255,128);
    SDL_TerminalSetBorderColor (terminal, 255,255,255,255);
    SDL_TerminalSetForeground (terminal, 0,0,0,255);
    SDL_TerminalSetBackground (terminal, 0,0,0,0); /* No background since alpha=0 */

    SDL_TerminalClear (terminal);
    SDL_TerminalPrint (terminal, "Terminal initialized\n");
    SDL_TerminalPrint (terminal, "Using font VeraMono, %d\n", terminal->font_size);
    SDL_TerminalPrint (terminal, "Terminal geometry: %d x %d\n\n", terminal->size.column, terminal->size.row);
    SDL_TerminalPrint (terminal, "\033[1mBold on\033[22m - Bold off\n");
    SDL_TerminalPrint (terminal, "\033[3mItalic on\033[23m - Italic off\n");
    SDL_TerminalPrint (terminal, "\033[4mUnderline on\033[24m - Underline off\n");

    SDL_TerminalPrint (terminal,
                       "\033[30mBlack"
                       "\033[31m - Red"
                       "\033[32m - Green"
                       "\033[33m - Yellow"
                       "\033[34m - Blue"
                       "\033[35m - Magenta"
                       "\033[36m - Cyan"
                       "\033[37m - White\033[30m\n");
    SDL_TerminalReset(terminal);
    SDL_TerminalPrint (terminal,
                       "\033[40;37mBlack\033[30m"
                       "\033[49m - \033[41mRed"
                       "\033[49m - \033[42mGreen"
                       "\033[49m - \033[43mYellow"
                       "\033[49m - \033[44mBlue"
                       "\033[49m - \033[45mMagenta"
                       "\033[49m - \033[46mCyan"
                       "\033[49m - \033[47mWhite\033[49m\n");

    int done = 0;
    SDL_Event event;
    last_tick = SDL_GetTicks();

    while (!done) {
	    while (SDL_PollEvent(&event)) {
		    switch (event.type) {
			case SDL_KEYDOWN:
			    key_press (&event.key.keysym);
			    break;
			case SDL_QUIT:
			    done = 1;
			    break;
            case SDL_TERMINALEVENT:
                printf ("Terminal event: %s\n", (char *) event.user.data2);
                break;
			default:
			    break;
			}
		}

        Uint32 wait = (Uint32)(1000.0f/fps);
        Uint32 new_tick  = SDL_GetTicks();
        if ((new_tick - last_tick) < wait)
            SDL_Delay (wait - (new_tick-last_tick));
        last_tick = SDL_GetTicks();

        SDL_FillRect (screen, 0, 0);
        SDL_Rect dst = {(800-image->w)/2, (600-image->h)/2, 0,0};
        SDL_BlitSurface (image, NULL, screen, &dst);
        SDL_TerminalBlit (terminal);

        SDL_Flip(screen);
	}
	
    SDL_Quit ();
    exit (EXIT_SUCCESS);
	return 0;
}

