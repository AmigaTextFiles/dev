#include "SDLHeaders.h"
#include "Clown_HEADERS.h"
#include "mouse.h"

SDL_Surface *screen;
MouseState theMouse;

int StartGraphicsManager(void)
{
    /* Init SDL stuff */
    if(!InitSDL())
    {
        printf("SDL initialization failed !\n");
        return 0;
    }

    CreateGameScreen(&screen, SDL_DOUBLEBUF | SDL_ANYFORMAT, SCREEN_WIDTH, SCREEN_HEIGHT);
    return 1;
}

void GMDrawRect(int x, int y, int w, int h, int r, int g, int b)
{
    SDL_Rect theRect;
    Uint32 theColor;

    theColor = SDL_MapRGB(screen->format, r, g, b);

    theRect.x = x;
    theRect.y = y;
    theRect.w = w;
    theRect.h = h;

    SDL_FillRect(screen, &theRect, theColor);
}

int GMManageEvents(void)
{
    short qr = 0;
    ManageGameEvents(&theMouse, &qr);
    return qr;
}

int GetMouseX(void)
{
    return theMouse.x;
}

int GetMouseY(void)
{
    return theMouse.y;
}

void FlipVideo(void)
{
    SDL_Flip(screen);
}

void CloseGraphicsManager(void)
{
    SDL_FreeSurface(screen);
    SDL_Quit();
}
