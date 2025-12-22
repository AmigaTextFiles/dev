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
 *
 * ------------------------------------------------------------------
 * This code is an adaptation of a code created by Jeff Molofee '99 
 * and  ported to Linux/SDL by Ti Leggett '01.
 * Visit Jeff at http://nehe.gamedev.net/
 * ------------------------------------------------------------------
 */
 
#include <stdio.h>
#include <stdlib.h>
#include <SDL.h>
#include <SDL_opengl.h>
#include "SDL_terminal.h"

SDL_Surface *surface;

typedef struct face {
    int index;
    float vertices[4*3];
    float tex[4*2];
    float normal[3];
    float z;
} face;
    


void key_press (SDL_keysym *keysym)
{
    switch (keysym->sym) {
	case SDLK_ESCAPE:
		SDL_Quit ();
		exit (EXIT_SUCCESS);
	    break;
	case SDLK_F1:
	    SDL_WM_ToggleFullScreen( surface );
	    break;
	default:
	    break;
	}
}

int resize (int width, int height) {
    GLfloat ratio;
    if (height == 0)
        height = 1;
    ratio = (GLfloat)width / (GLfloat)height;
    glViewport (0, 0, (GLint)width, (GLint)height);
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity ();
    gluPerspective (45.0f, ratio, 0.1f, 100.0f);
    glMatrixMode (GL_MODELVIEW);
    glLoadIdentity ();
    return 1;
}

int initGL (GLvoid) {
    return (1);
}

int
compare (const void *a, const void *b) {
    const face *da = (const face *) a;
    const face *db = (const face *) b;
    return ((*da).z > (*db).z) - ((*da).z < (*db).z);
}

void glcube (SDL_Terminal *terminal, float dt) {
    GLfloat tex_w = terminal->psize.w/(GLfloat)(terminal->texture_size.w);
    GLfloat tex_h = terminal->psize.h/(GLfloat)(terminal->texture_size.h);
    int i;
	float m[16];
    face faces[6] = {
        {0, {-1,-1,1,  1,-1,1, 1,1,1,  -1,1,1},   {1,0, 0,0, 0,1, 1,1}, {0,0,1}, 0},
        {1, {-1,-1,-1, -1,1,-1, 1,1,-1, 1,-1,-1}, {0,0, 0,1, 1,1, 1,0}, {0,0,-1}, 0},
        {2, {-1,1,-1, -1,1,1, 1,1,1, 1,1,-1}, {1,1, 1,0, 0,0, 0,1}, {0,1,0}, 0},
        {3, {-1,-1,-1, 1,-1,-1, 1,-1,1, -1,-1,1}, {0,1, 1,1, 1,0, 0,0}, {0,-1,0}, 0},
        {4, {1,-1,-1, 1,1,-1, 1,1,1, 1,-1,1}, {0,0, 0,1, 1,1, 1,0}, {1,0,0}, 0},
        {5, {-1,-1,-1, -1,-1,1, -1,1,1, -1,1,-1}, {1,0, 0,0, 0,1, 1,1}, {-1,0,0}, 0}
    };
    

    static float xrot = 180;
    static float yrot = 180;
    
    xrot += dt*7;
    yrot += dt*6;

    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    glLoadIdentity( );
    glTranslatef( 0.0f, 0.0f, -4.0f );

    glRotatef (xrot, 1.0f, 0.0f, 0.0f);
    glRotatef (yrot, 0.0f, 1.0f, 0.0f);

    /* Cube faces are z sorted for correct translucency */
    /* z sorting is done on faces center */
	glGetFloatv (GL_MODELVIEW_MATRIX, m);
    faces[0].z =  0*m[2] +  0*m[6] +  1*m[10] + m[14];faces[0].index = 0;
    faces[1].z =  0*m[2] +  0*m[6] + -1*m[10] + m[14];faces[1].index = 1;
    faces[2].z =  0*m[2] +  1*m[6] +  0*m[10] + m[14];faces[2].index = 2;
    faces[3].z =  0*m[2] + -1*m[6] +  0*m[10] + m[14];faces[3].index = 3;
    faces[4].z =  1*m[2] +  0*m[6] +  0*m[10] + m[14];faces[4].index = 4;
    faces[5].z = -1*m[2] +  0*m[6] +  0*m[10] + m[14];faces[5].index = 5;

    qsort (faces, 6, sizeof (face), compare);

    glBindTexture (GL_TEXTURE_2D, terminal->texture);
    glBegin( GL_QUADS );
    for (i=0; i<6; i++) {
        glNormal3f (faces[i].normal[0],faces[i].normal[1],faces[i].normal[2]);

        glTexCoord2f (faces[i].tex[0]*tex_w, faces[i].tex[1]*tex_h);
        glVertex3f (faces[i].vertices[0], faces[i].vertices[1], faces[i].vertices[2]);

        glTexCoord2f (faces[i].tex[2]*tex_w, faces[i].tex[3]*tex_h);
        glVertex3f (faces[i].vertices[3], faces[i].vertices[4], faces[i].vertices[5]);

        glTexCoord2f (faces[i].tex[4]*tex_w, faces[i].tex[5]*tex_h);
        glVertex3f (faces[i].vertices[6], faces[i].vertices[7], faces[i].vertices[8]);

        glTexCoord2f (faces[i].tex[6]*tex_w, faces[i].tex[7]*tex_h);
        glVertex3f (faces[i].vertices[9], faces[i].vertices[10], faces[i].vertices[11]);
    }
    glEnd();
}


int main( int argc, char **argv ) {
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
    videoFlags |= SDL_RESIZABLE;       /* Enable window resizing */
    if (videoInfo->hw_available)
        videoFlags |= SDL_HWSURFACE;
    else
        videoFlags |= SDL_SWSURFACE;
    if (videoInfo->blit_hw)
        videoFlags |= SDL_HWACCEL;
    SDL_GL_SetAttribute (SDL_GL_DOUBLEBUFFER, 1);
    surface = SDL_SetVideoMode (800, 600, 32, videoFlags);
    if (!surface) {
	    fprintf (stderr,  "Video mode set failed: %s\n", SDL_GetError( ));
        SDL_Quit();
        exit (EXIT_FAILURE);
	}

    glEnable (GL_TEXTURE_2D);
    glShadeModel (GL_SMOOTH);
    glClearColor (0.0f, 0.0f, 0.0f, 0.0f);
    glClearDepth (1.0f);
    glDepthFunc (GL_LEQUAL);
    glHint (GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
    glEnable (GL_BLEND);
    glColor4f(1.0f,1.0f,1.0f,1.0f);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);    
    glDisable (GL_DEPTH_TEST);

    resize (800,600);
    SDL_WM_SetCaption ("SDL Terminal textured on a cube", NULL);

    
    SDL_Terminal *terminal =  SDL_CreateTerminal ();
    terminal->visible = 0;
    SDL_TerminalSetColor (terminal, 255,255,255,200);
    SDL_TerminalSetBorderColor (terminal, 255,255,255,255);
    SDL_TerminalSetForeground (terminal, 0,0,0,255);
    SDL_TerminalSetBackground (terminal, 0,0,0,0);

    SDL_TerminalSetFont (terminal, "./VeraMono.ttf", 24);
    SDL_TerminalSetSize (terminal, 40, 20);
    SDL_TerminalClear (terminal);
    SDL_TerminalPrint (terminal, "\033[1mTerminal initialized\033[22m\n");
    SDL_TerminalPrint (terminal, "Using font VeraMono, %d\n", terminal->font_size);
    SDL_TerminalPrint (terminal, "Terminal geometry: \033[34m%d x %d\033[39m\n",
                       terminal->size.column, terminal->size.row);

    last_tick = SDL_GetTicks();
    while (!done)	{
	    while (SDL_PollEvent(&event)) {
		    switch(event.type) {
			case SDL_VIDEORESIZE:
			    surface = SDL_SetVideoMode( event.resize.w, event.resize.h, 32, videoFlags);
			    if (!surface) {
				    fprintf( stderr, "Could not get a surface after resize: %s\n", SDL_GetError( ) );
                    SDL_Quit();
                    exit (EXIT_FAILURE);
				}
			    resize (event.resize.w, event.resize.h);
			    break;
			case SDL_KEYDOWN:
                if (SDL_TerminalProcessEvent (terminal, &event) == 1)
                    key_press (&event.key.keysym);
			    break;
			case SDL_QUIT:
			    done = 1;
			    break;
			default:
			    break;
			}
		}

        Uint32 wait = (Uint32)(1000.0f/fps);
        Uint32 new_tick  = SDL_GetTicks();
        if ((new_tick - last_tick) < wait)
            SDL_Delay (wait - (new_tick-last_tick));
        float dt = (SDL_GetTicks() - last_tick)/1000.0f;
        last_tick = SDL_GetTicks();
        
        SDL_TerminalBlit (terminal);
        glcube (terminal, dt);
        SDL_GL_SwapBuffers ();
    }

    SDL_Quit();
    exit (EXIT_SUCCESS);
    return (0);
}
