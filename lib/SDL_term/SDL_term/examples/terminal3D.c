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
#include <SDL_opengl.h>
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
    SDL_Surface *surface;
    SDL_Surface *image;
    GLuint texture;
    Uint32 last_tick;
    int fps = 100;

    int videoFlags;
    int done = 0;
    SDL_Event event;
    const SDL_VideoInfo *videoInfo;

    if (SDL_Init( SDL_INIT_VIDEO ) < 0) {
	    fprintf (stderr, "Video initialization failed: %s\n", SDL_GetError( ));
		SDL_Quit();
		exit (EXIT_FAILURE);
	}
    videoInfo = SDL_GetVideoInfo ();
    if (!videoInfo) {
	    fprintf (stderr, "Video query failed: %s\n", SDL_GetError());
		SDL_Quit();
		exit (EXIT_FAILURE);
	}

    videoFlags  = SDL_OPENGL;          /* Enable OpenGL in SDL */
    videoFlags |= SDL_GL_DOUBLEBUFFER; /* Enable double buffering */
    videoFlags |= SDL_HWPALETTE;       /* Store the palette in hardware */
    if ( videoInfo->hw_available )
        videoFlags |= SDL_HWSURFACE;
    else
        videoFlags |= SDL_SWSURFACE;
    if ( videoInfo->blit_hw )
        videoFlags |= SDL_HWACCEL;
    SDL_GL_SetAttribute (SDL_GL_DOUBLEBUFFER, 1);
    surface = SDL_SetVideoMode (800, 600, 32, videoFlags);
    if (!surface) {
	    fprintf (stderr,  "Video mode set failed: %s\n", SDL_GetError( ));
		SDL_Quit();
		exit (EXIT_FAILURE);
	}

    image = SDL_LoadBMP ("gnu-tux.bmp");
    if (!image) {
        fprintf (stderr, "Cannot load image");
        exit (0);
    }

    glGenTextures (1, &texture);
    glBindTexture (GL_TEXTURE_2D, texture);
    glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    char *data = (char *) malloc (512*512*3*sizeof(char));
    glTexImage2D (GL_TEXTURE_2D, 0, 3, 512, 512, 0, GL_BGR, GL_UNSIGNED_BYTE, data);
    free(data);
    glTexSubImage2D (GL_TEXTURE_2D, 0, 0, 0, image->w, image->h, GL_BGR, GL_UNSIGNED_BYTE, image->pixels);

    glEnable (GL_TEXTURE_2D);
    glShadeModel (GL_SMOOTH);
    glClearColor (0.0f, 0.0f, 0.0f, 0.0f);
    glClearDepth (1.0f);
    glEnable (GL_DEPTH_TEST);
    glDepthFunc (GL_LEQUAL);
    glHint (GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
    glDisable (GL_BLEND);    
    glPolygonMode (GL_FRONT_AND_BACK, GL_FILL);
    
    glViewport(0, 0, 800, 600);
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity ();
    glOrtho (0, (GLdouble) 800, 0, (GLdouble) 600, -1, 1);
    glMatrixMode (GL_MODELVIEW);
    glLoadIdentity ();
    SDL_WM_SetCaption ("SDL Terminal with OpenGL", NULL);
    


    SDL_Terminal *terminal =  SDL_CreateTerminal ();
    SDL_TerminalSetFont (terminal, "./VeraMono.ttf", 12);
    SDL_TerminalSetSize (terminal, 80, 24);
    SDL_TerminalSetPosition (terminal, 0, 0);

    SDL_TerminalSetColor (terminal, 255,255,255,128);
    SDL_TerminalSetBorderColor (terminal, 255,255,255,255);
    SDL_TerminalSetForeground (terminal, 0,0,0,255);
    SDL_TerminalSetBackground (terminal, 0,0,0,0);

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
/*    SDL_TerminalReset(terminal);*/


    last_tick = SDL_GetTicks();
    while (!done)	{
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


        glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        glPushMatrix();
        glTranslated ((surface->w-image->w)/2, surface->h- (surface->h-image->h)/2, 0);
        glBindTexture (GL_TEXTURE_2D, texture);
        glBegin (GL_QUADS);
        glTexCoord2f (0,              0);				glVertex2i (0, 0);
        glTexCoord2f (image->w/512.0, 0);				glVertex2i (image->w, 0);
        glTexCoord2f (image->w/512.0, image->h/512.0);	glVertex2i (image->w, -image->h);
        glTexCoord2f (0,              image->h/512.0);	glVertex2i (0, -image->h);
        glEnd ();
        glPopMatrix();

        SDL_TerminalBlit (terminal);
        SDL_GL_SwapBuffers ();
    }
	
    SDL_Quit ();
    exit (EXIT_SUCCESS);
	return 0;
}

