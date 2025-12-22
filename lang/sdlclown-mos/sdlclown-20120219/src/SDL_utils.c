/*
 * The following code was copied from my other
 * project, "ColorTileMatch".
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "SDL_utils.h"

int InitSDL(void)
{
    return (SDL_Init(SDL_INIT_EVERYTHING)==0);
}

void CreateGameScreen(SDL_Surface **screen, Uint32 SDLVideoFlags, int width, int height)
{
    int chosenBitDepth;

    /* Get the "best" bitdepth */
    chosenBitDepth = SDL_GetVideoInfo() -> vfmt -> BitsPerPixel;

    /* Setup video mode */
    *screen = SDL_SetVideoMode(width, height, chosenBitDepth,
                               SDLVideoFlags);

    /* Window title */
    SDL_WM_SetCaption("SDL_clown output window", NULL);
}

