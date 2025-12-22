/*
 * The following code was copied from my other
 * project, "ColorTileMatch".
 */

#include "mouse.h"
#include "SDL_events.h"

void ManageGameEvents(MouseState* mouse_state, short *quit_request)
{
    SDL_Event event;
    Uint8  *keystate;

    keystate=SDL_GetKeyState(NULL);

    if(keystate[SDLK_q] || keystate[SDLK_ESCAPE])
        *quit_request = 1;

    while(SDL_PollEvent(&event))
    {

        if (event.type==SDL_MOUSEMOTION)
        {
            mouse_state->x = event.motion.x;
            mouse_state->y = event.motion.y;
        }

        if (event.type==SDL_MOUSEBUTTONDOWN)
        {
            mouse_state->down=1;
        }

        if (event.type==SDL_MOUSEBUTTONUP)
        {
            mouse_state->down=0;
        }

        if(event.type==SDL_QUIT)
        {
            *quit_request=1;
        }
    }
}

