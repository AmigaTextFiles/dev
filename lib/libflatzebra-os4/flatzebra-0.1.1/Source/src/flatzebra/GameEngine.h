/*  $Id: GameEngine.h,v 1.3 2004/04/21 02:19:14 sarrazip Exp $
    GameEngine.h - Abstract class representing an X11 Game Engine.

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

#ifndef _H_GameEngine
#define _H_GameEngine

#include <flatzebra/Couple.h>
#include <flatzebra/RCouple.h>
#include <flatzebra/Sprite.h>
#include <flatzebra/RSprite.h>

#include <flatzebra/PixmapArray.h>
#include <flatzebra/PixmapLoadError.h>
/*  Include directive instead of forward declaration, because of the
    exception specifications that mention PixmapLoadError.
    This is necessary for g++ 2.96, but it was not for g++ 2.95.2.
    @sarrazip 20010324
*/

#include <SDL_types.h>
#include <SDL_keysym.h>

#include <string>


namespace flatzebra {


class GameEngine
/*  Abstract class representing a Generic Game Engine.
*/
{
public:

    GameEngine(Couple screenSizeInPixels,
    		const std::string &wmCaption,
		bool fullScreen)
			throw(std::string);
    /*  Initializes SDL and an adequate video mode.

	The x and y fields of 'screenSizeInPixels' specify the size of
	the screen in pixels.

	'wmCaption' must be the caption to be used by the window manager
	as the window and icon titles.

	If 'fullScreen' is true, an attempt is made to use the
	full-screen mode.

	The run() method should be called after successfully constructing
	this object.
    */

    virtual ~GameEngine();
    /*  Calls SDL_Quit().
    */

    virtual void processKey(SDLKey keysym, bool pressed) = 0;
    /*  Called upon a key event.
	'keysym' is an SDL key symbol, e.g., SDLK_ESCAPE.
	'pressed' indicates the new state of the key.
    */

    virtual bool tick() = 0;
    /*  Called at the beginning of every animation period.
	Must return true to ask to be called again at the next period.
	Must return false to ask not to be called anymore.
    */

    void run(int millisecondsPerFrame = 50);
    /*  Main loop.
	To be called after the object has been successfully constructed.
	Runs until the user asks to quit the program.

	'millisecondsPerFrame' must be the number of milliseconds
	between the start of each frame of animation.  50 ms means
	20 frames per second, which is about the minimum speed needed
	to fool the human eye into seeing smooth motion.
    */

    int getScreenWidthInPixels() const;
    int getScreenHeightInPixels() const;
    /*  Mumble.
    */

protected:

    Couple theScreenSizeInPixels;
	/*  After initialization, this variable should not be modified
	    by derived class methods.
	*/

    SDL_Surface *theSDLScreen;

    SDL_Surface *fixedWidthFontPixmap;

    int theDepth;  // the SDL "depth" used in the video mode

protected:

    void loadPixmap(char **xpmData,
		    PixmapArray &pa,
		    size_t index) const throw(PixmapLoadError);
    void loadPixmap(char **xpmData,
		    SDL_Surface *&pixmap,
		    Couple &pixmapSize) const throw(PixmapLoadError);
    /*  Loads a pixmap from the specified file or data and stores the results
	in the other parameters.
	Throws an exception to signal errors.
    */

    void copyPixmap(SDL_Surface *src, Couple dest,
    			SDL_Surface *surface = NULL) const;
    /*  Copies 'src' at the specified destination in the drawing pixmap.
	If 'surface' is null, the visible screen is used.
    */

    void copySpritePixmap(const Sprite &s,
    			size_t pixmapNo,
			Couple posInSurface,
			SDL_Surface *surface = NULL);
    void copySpritePixmap(const RSprite &s,
    			size_t pixmapNo,
			RCouple posInSurface,
			SDL_Surface *surface = NULL);
    /*  Copies sprite s's pixmap number 'pixmapNo' into the surface
	at the specified position.
	Uses the sprite's size but not its position.
	If 'surface' is null, the visible screen is used.
    */

    void writeString(const char *s, Couple pos,
    			SDL_Surface *surface = NULL);
    void writeString(const std::string &s, Couple pos,
    			SDL_Surface *surface = NULL);
    void writeStringCentered(const char *s, Couple pos,
    			SDL_Surface *surface = NULL);
    void writeStringCentered(const std::string &s, Couple pos,
    			SDL_Surface *surface = NULL);
    void writeStringXCentered(const char *s, Couple pos,
    			SDL_Surface *surface = NULL);
    void writeStringXCentered(const std::string &s, Couple pos,
    			SDL_Surface *surface = NULL);
    void writeStringRightJustified(const char *s, Couple pos,
    			SDL_Surface *surface = NULL);
    void writeStringRightJustified(const std::string &s, Couple pos,
    			SDL_Surface *surface = NULL);
    /*  Writes the given zero-terminated Latin-1 (ISO-8859-1) string
	at the given position.
	Uses a fixed width font whose dimensions are given by
	getFontDimensions().
	The text appears at the right and below 'pos'.
	If 'surface' is null, the visible screen is used.
    */

    Couple getFontDimensions() const;
    /*  Returns the width and height (in the x and y fields) of the fixed
	font used by writeString().
    */

private:

    /*	Forbidden operations:
    */
    GameEngine(const GameEngine &x);
    GameEngine &operator = (const GameEngine &x);
};


inline
int
GameEngine::getScreenWidthInPixels() const
{
    return theScreenSizeInPixels.x;
}


inline
int
GameEngine::getScreenHeightInPixels() const
{
    return theScreenSizeInPixels.y;
}


inline
void
GameEngine::copyPixmap(SDL_Surface *src, Couple dest,
				SDL_Surface *surface) const
{
    if (surface == NULL)
	surface = theSDLScreen;
    SDL_Rect dstrect = { dest.x, dest.y, 0, 0 };
    SDL_BlitSurface(src, NULL, surface, &dstrect);
}


inline
void
GameEngine::copySpritePixmap(const Sprite &s, size_t pixmapNo,
			    Couple posInSurface, SDL_Surface *surface)
{
    if (surface == NULL)
	surface = theSDLScreen;
    SDL_Surface *image = s.getPixmap(pixmapNo);
    SDL_Rect dstrect = { posInSurface.x, posInSurface.y, 0, 0 };
    SDL_BlitSurface(image, NULL, surface, &dstrect);
        /*  We suppose that the image has a color key that indicates
            which pixel is of the transparent color.
            See SDL doc re: SDL_SetColorKey().
        */
}


inline
void
GameEngine::copySpritePixmap(const RSprite &s, size_t pixmapNo,
			    RCouple posInSurface, SDL_Surface *surface)
{
    if (surface == NULL)
	surface = theSDLScreen;
    SDL_Surface *image = s.getPixmap(pixmapNo);
    Couple p = posInSurface.round();
    SDL_Rect dstrect = { p.x, p.y, 0, 0 };
    SDL_BlitSurface(image, NULL, surface, &dstrect);
        /*  We suppose that the image has a color key that indicates
            which pixel is of the transparent color.
            See SDL doc re: SDL_SetColorKey().
        */
}


inline
void
GameEngine::writeString(const std::string &s, Couple pos,
					SDL_Surface *surface)
{
    writeString(s.c_str(), pos, surface);
}


inline
void
GameEngine::writeStringCentered(const std::string &s, Couple pos,
					SDL_Surface *surface)
{
    writeStringCentered(s.c_str(), pos, surface);
}


inline
void
GameEngine::writeStringXCentered(const std::string &s, Couple pos,
					SDL_Surface *surface)
{
    writeStringXCentered(s.c_str(), pos, surface);
}


inline
void
GameEngine::writeStringRightJustified(const std::string &s, Couple pos,
					SDL_Surface *surface)
{
    writeStringRightJustified(s.c_str(), pos, surface);
}


inline
Couple
GameEngine::getFontDimensions() const
{
    return Couple(7, 13);
}


}  // namespace flatzebra


#endif  /* _H_GameEngine */
