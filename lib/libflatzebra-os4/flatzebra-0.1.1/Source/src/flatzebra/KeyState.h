/*  $Id: KeyState.h,v 1.1 2003/04/26 04:19:06 sarrazip Exp $
    KeyState.h - Representation of the state of a keyboard key

    flatzebra - Generic 2D Game Engine library
    Copyright (C) 2003 Pierre Sarrazin <http://sarrazip.com/>

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

#ifndef _H_KeyState
#define _H_KeyState

#include <SDL_keysym.h>


namespace flatzebra {


class KeyState
{
public:

    KeyState(SDLKey k0, SDLKey k1 = SDLK_UNKNOWN)
      : key(k0), otherKey(k1), now(false), before(false)
    {
    }

    void check(SDLKey keysym, bool pressed)
    {
	if (keysym == key || keysym == otherKey)
	    now = pressed;
    }

    bool isPressed() const
    {
	return now;
    }

    bool justPressed() const
    {
	return !before && now;
    }

    void remember()
    {
	before = now;
    }

private:

    SDLKey key;
    SDLKey otherKey;
    bool now;     // pressed now or not
    bool before;  // pressed before or not

    /*	Forbidden operations:
    */
    KeyState(const KeyState &x);
    KeyState &operator = (const KeyState &x);
};


}  // namespace flatzebra


#endif  /* _H_KeyState */
