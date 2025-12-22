/*  $Id: Sprite.h,v 1.1 2003/04/26 04:19:06 sarrazip Exp $
    Sprite.h - Sprite in a 2D game.

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

#ifndef _H_Sprite
#define _H_Sprite

#include <flatzebra/Couple.h>
#include <flatzebra/PixmapArray.h>

#include <vector>


namespace flatzebra {


typedef std::vector<class Sprite *> SpriteList;


class Sprite
/*  Sprite in a 2D game.
*/
{
public:
    Sprite(const PixmapArray &pixmapArray,
	    const Couple &pos,
	    const Couple &speed,
	    const Couple &accel,
	    const Couple &collBoxPos,
	    const Couple &collBoxSize);
    /*  Initializes the sprite with the given pixmap array and coordinates.
	Keeps a pointer to 'pixmapArray' but does NOT become the owner
	of the pixmap array.
	Keeps copies of the other parameters.

	The "collision box" is the box that is used in detecting
	collisions between this sprite and other sprites.
	'collBoxPos' must be a position with respect to top left corner
	of sprite's rectangle.
    */

    virtual ~Sprite();
    /*  Does not free the pixmap array given to the constructor.
    */

    size_t getNumPixmaps() const;
    /*  Returns the number of pixmaps in this sprite.
    */

    SDL_Surface *getPixmap(size_t i) const;
    /*  Returns the pixmap at index 'i' is this sprite's pixmap list.
	This index is zero-based.
	No check is made to ensure that i is valid.
    */

    const PixmapArray *getPixmapArray() const;
    /*  Returns the (non null) pointer to this sprite's pixmap array.
    */

    const Couple &getPos() const;
    const Couple &getSpeed() const;
    const Couple &getAccel() const;
    const Couple &getSize() const;
    Couple &getPos();
    Couple &getSpeed();
    Couple &getAccel();
    Couple &getSize();
    /*  Returns a reference to the coordinates of this sprite.
    */

    Couple getCenterPos() const;
    /*	Returns the position of the center of this sprite.
    */

    Couple getLowerRightPos() const;
    /*  Returns the position of the lower right corner of the rectangle
	that contains the sprite.
	This position is the sum of the sprite's position and its size.
    */

    Couple getCollBoxPos() const;
    Couple getCollBoxSize() const;
    void setCollBoxPos(const Couple &c);
    void setCollBoxSize(const Couple &c);
    /*  Returns or changes the coordinates of this sprite's collision box.
	The position is relative to the top left corner of the sprite.
    */

    void setPos(const Couple &c);
    void setSpeed(const Couple &c);
    void setAccel(const Couple &c);
    void addSpeedToPos();
    void subSpeedFromPos();
    void addAccelToSpeed();
    void subAccelFromSpeed();
    /*  Change the coordinates of the sprite.
    */

    bool collidesWithSprite(const Sprite &s) const;
    /*  Returns true if the collision box of sprite 's' has an intersection
	with the collision box of this sprite.
    */

    void setTimeToLive(unsigned long t);
    unsigned long getTimeToLive() const;
    unsigned long decTimeToLive();
    void clearTimeToLive();
    /*  Manage the time to live variable.
	decTimeToLive() does not decrement the value if it is already zero;
	it returns the resulting value.
    */


    size_t currentPixmapIndex;  // index into thePixmapArray
    /*  The current pixmap index can be used to have this sprite object
	remember which image is currently used.
	setCurrentPixmapIndex() does not check if 'i' is valid;
	'i' must be lower than the size of this sprite's PixmapArray.

	'currentPixmapIndex' is initially zero.
    */

    
    long *values;  // array
    size_t numUserValues;

    void boundPosition(Couple settingSizeInPixels);
    /*  If the position of sprite 's' is out of the setting (whose size
	is given by 'settingSizeInPixels'), then this position is adjusted
	to bring the sprite back in.
	It is assumed that the top left corner of the setting is (0, 0).
    */

protected:  // data became protected with version 0.1 @sarrazip 20010203

    /*  All the following Couple objects are in pixels.
	All pixmaps in the pixmap array must have the same size.
    */

    const PixmapArray *thePixmapArray;  // not owned by this object

    Couple pos;    // in pixels
    Couple speed;  // in pixels
    Couple accel;  // in pixels
    Couple size;
    unsigned long timeToLive;
	    // number of ticks left for this sprite;
	    // often used to count other things.

    Couple collBoxPos;
	    // position of collision box w.r.t. to top left corner of sprite
    Couple collBoxSize;

private:
    /*	Forbidden operations:
    */
    Sprite(const Sprite &x);
    Sprite &operator = (const Sprite &x);
};


/*  INLINE METHODS
*/

inline
const Couple &
Sprite::getPos() const
{
    return pos;
}

inline
const Couple &
Sprite::getSpeed() const
{
    return speed;
}

inline
const Couple &
Sprite::getAccel() const
{
    return accel;
}

inline
const Couple &
Sprite::getSize() const
{
    return size;
}

inline
Couple &
Sprite::getPos()
{
    return pos;
}

inline
Couple &
Sprite::getSpeed()
{
    return speed;
}

inline
Couple &
Sprite::getAccel()
{
    return accel;
}

inline
Couple &
Sprite::getSize()
{
    return size;
}

inline
Couple
Sprite::getCenterPos() const
{
    return pos + size / 2;
}

inline
Couple
Sprite::getLowerRightPos() const
{
    return pos + size;
}

inline
Couple
Sprite::getCollBoxPos() const
{
    return collBoxPos;
}

inline
Couple
Sprite::getCollBoxSize() const
{
    return collBoxSize;
}

inline
void
Sprite::setCollBoxPos(const Couple &c)
{
    collBoxPos = c;
}

inline
void
Sprite::setCollBoxSize(const Couple &c)
{
    collBoxSize = c;
}

inline
void
Sprite::setPos(const Couple &c)
{
    pos = c;
}

inline
void
Sprite::setSpeed(const Couple &c)
{
    speed = c;
}

inline
void
Sprite::setAccel(const Couple &c)
{
    accel = c;
}

inline
void
Sprite::addSpeedToPos()
{
    pos += speed;
}

inline
void
Sprite::subSpeedFromPos()
{
    pos -= speed;
}

inline
void
Sprite::addAccelToSpeed()
{
    speed += accel;
}

inline
void
Sprite::subAccelFromSpeed()
{
    speed -= accel;
}

inline
void
Sprite::setTimeToLive(unsigned long t)
{
    timeToLive = t;
}

inline
unsigned long
Sprite::getTimeToLive() const
{
    return timeToLive;
}

inline
unsigned long
Sprite::decTimeToLive()
{
    if (timeToLive != 0) timeToLive--; return timeToLive;
}

inline
void
Sprite::clearTimeToLive()
{
    timeToLive = 0;
}

inline
size_t
Sprite::getNumPixmaps() const
{
    return thePixmapArray->getNumImages();
}

inline
SDL_Surface *
Sprite::getPixmap(size_t i) const
{
    return thePixmapArray->getImage(i);
}

inline
const PixmapArray *
Sprite::getPixmapArray() const
{
    return thePixmapArray;
}


}  // namespace flatzebra


#endif  /* _H_Sprite */
