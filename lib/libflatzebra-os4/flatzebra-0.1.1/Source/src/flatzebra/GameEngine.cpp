/*  $Id: GameEngine.cpp,v 1.2 2004/04/21 02:19:14 sarrazip Exp $
    GameEngine.cpp - Abstract class representing an X11 Game Engine.

    flatzebra - Generic 2D Game Engine library
    Copyright (C) 1999, 2000, 2001 Pierre Sarrazin <http://sarrazip.com/>

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
    02111-1307, USA.
*/

#include <flatzebra/GameEngine.h>

#include "font_13x7.xpm"

#include <assert.h>

using namespace std;
using namespace flatzebra;


GameEngine::GameEngine(Couple screenSizeInPixels,
			const string &wmCaption,
			bool fullScreen) throw(string)
  : theScreenSizeInPixels(screenSizeInPixels),
    theSDLScreen(NULL),
    fixedWidthFontPixmap(NULL),
    theDepth(0)
{
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER) < 0)
	throw string(SDL_GetError());

    SDL_WM_SetCaption(wmCaption.c_str(), wmCaption.c_str());

    theDepth = SDL_VideoModeOK(
			screenSizeInPixels.x, screenSizeInPixels.y,
			32, SDL_HWSURFACE);
    Uint32 flags = (fullScreen
			? SDL_FULLSCREEN
			: SDL_HWSURFACE);
    theSDLScreen = SDL_SetVideoMode(
    			screenSizeInPixels.x, screenSizeInPixels.y,
			theDepth, flags);
    if (theSDLScreen == NULL)
    {
	string errMsg = SDL_GetError();
	SDL_Quit();
	throw errMsg;
    }

    // Deselect unused event types:
    for (int i = SDL_NOEVENT; i < SDL_NUMEVENTS; i++)
    {
	switch (i)
	{
	    case SDL_KEYDOWN:
	    case SDL_KEYUP:
	    case SDL_QUIT:
		break;
	    default:
		SDL_EventState((Uint8) i, SDL_IGNORE);
	}
    }

    // Prepare a fixed width font pixmap:
    try
    {
	Couple dummy;
	loadPixmap(font_13x7_xpm, fixedWidthFontPixmap, dummy);
	assert(fixedWidthFontPixmap != NULL);
    }
    catch (PixmapLoadError)
    {
	throw string("Could not load fixed width font pixmap");
    }
}


GameEngine::~GameEngine()
{
    SDL_Quit();
}


void GameEngine::run(int millisecondsPerFrame)
{
    for (;;)
    {
	Uint32 lastTime = SDL_GetTicks();

	SDL_Event event;
	while (SDL_PollEvent(&event))
	{
	    if (event.type == SDL_KEYDOWN)
		processKey(event.key.keysym.sym, true);   // virtual function
	    else if (event.type == SDL_KEYUP)
		processKey(event.key.keysym.sym, false);  // virtual function
	    else if (event.type == SDL_QUIT)
		return;
	}

	if (!tick())  // virtual function
	    return;

	SDL_Flip(theSDLScreen);

	// Pause for the rest of the current animation frame.
	Uint32 limit = lastTime + millisecondsPerFrame;
	Uint32 delay = limit - SDL_GetTicks();
	if (delay <= (Uint32) millisecondsPerFrame)
	    SDL_Delay(delay);
    }
}


void
GameEngine::loadPixmap(char **xpmData, PixmapArray &pa, size_t index) const
						throw(PixmapLoadError)
{
    // Masks are not be relevant with SDL.

    SDL_Surface *pixmap;
    Couple size;
    loadPixmap(xpmData, pixmap, size);
    pa.setArrayElement(index, pixmap);
    pa.setImageSize(size);
}


void
GameEngine::loadPixmap(char **xpmData,
		SDL_Surface *&pixmap,
		Couple &pixmapSize) const throw(PixmapLoadError)
{
    pixmapSize.zero();

    if (xpmData == NULL || xpmData[0] == NULL)
	throw PixmapLoadError(PixmapLoadError::INVALID_ARGS, NULL);

    pixmap = IMG_ReadXPMFromArray(xpmData);
    if (pixmap == NULL)
	throw PixmapLoadError(PixmapLoadError::UNKNOWN, NULL);

    pixmapSize.x = pixmap->w;
    pixmapSize.y = pixmap->h;
}


void
GameEngine::writeString(const char *s, Couple pos, SDL_Surface *surface)
{
    assert(fixedWidthFontPixmap != NULL);
    if (s == NULL)
	return;
    if (surface == NULL)
	surface = theSDLScreen;
    Couple fontDim = getFontDimensions();
    SDL_Rect dest = { pos.x, pos.y, fontDim.x, fontDim.y };
    for (size_t i = 0; s[i] != '\0'; i++, dest.x += fontDim.x)
    {
	unsigned char c = (unsigned char) s[i];
	if (c < 32 || c >= 127 && c <= 160)  // if ctrl char or undef char
	    c = 32;  // replace by space

	/*  Compute the subrectangle of fixedWidthFontPixmap that
	    contains the character:
	*/
	int x = (c % 16) * fontDim.x;
	int y = (c - 32) / 16;
	if (y >= 8)
	    y -= 2;
	y *= fontDim.y;

	SDL_Rect src  = { x, y, fontDim.x, fontDim.y };
	SDL_BlitSurface(fixedWidthFontPixmap, &src, surface, &dest);
    }
}


void
GameEngine::writeStringCentered(const char *s, Couple pos, SDL_Surface *surface)
{
    Couple fontDim = getFontDimensions();
    Couple stringSizeInPixels(strlen(s) * fontDim.x, fontDim.y);
    writeString(s, pos - stringSizeInPixels / 2, surface);
}


void
GameEngine::writeStringXCentered(
			const char *s, Couple pos, SDL_Surface *surface)
{
    Couple fontDim = getFontDimensions();
    int stringWidthInPixels = strlen(s) * fontDim.x;
    Couple adjustedPos(pos.x - stringWidthInPixels / 2, pos.y);
    writeString(s, adjustedPos, surface);
}


void
GameEngine::writeStringRightJustified(
			const char *s, Couple pos, SDL_Surface *surface)
{
    Couple fontDim = getFontDimensions();
    int stringWidthInPixels = strlen(s) * fontDim.x;
    Couple adjustedPos(pos.x - stringWidthInPixels, pos.y);
    writeString(s, adjustedPos, surface);
}
