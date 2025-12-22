/*  $Id: RSprite.h,v 1.1 2003/10/21 04:05:06 sarrazip Exp $
    RSprite.h - Sprite with floating point coordinates in a 2D game.

    flatzebra - Generic 2D Game Engine library
    Copyright (C) 1999-2003 Pierre Sarrazin <http://sarrazip.com/>

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

#ifndef _H_RSprite
#define _H_RSprite

#include <flatzebra/Couple.h>
#include <flatzebra/RCouple.h>
#include <flatzebra/PixmapArray.h>

#include <vector>


namespace flatzebra {


typedef std::vector<class RSprite *> RSpriteList;


class RSprite
/*  RSprite in a 2D game.
*/
{
public:
    RSprite(const PixmapArray &pixmapArray,
	    const RCouple &pos = RCouple(),
	    const RCouple &speed = RCouple(),
	    const RCouple &accel = RCouple(),
	    const RCouple &collBoxPos = RCouple(),
	    const RCouple &collBoxSize = RCouple());
    /*  Initializes the sprite with the given pixmap array and coordinates.
	Keeps a pointer to 'pixmapArray' but does NOT become the owner
	of the pixmap array.
	Keeps copies of the other parameters.

	The "collision box" is the box that is used in detecting
	collisions between this sprite and other sprites.
	'collBoxPos' must be a position with respect to top left corner
	of sprite's rectangle.
    */

    virtual ~RSprite();
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

    const RCouple &getPos() const;
    const RCouple &getSpeed() const;
    const RCouple &getAccel() const;
    const Couple &getSize() const;
    RCouple &getPos();
    RCouple &getSpeed();
    RCouple &getAccel();
    Couple &getSize();
    /*  Returns a reference to the coordinates of this sprite.
    */

    RCouple getCenterPos() const;
    /*	Returns the position of the center of this sprite.
    */

    RCouple getLowerRightPos() const;
    /*  Returns the position of the lower right corner of the rectangle
	that contains the sprite.
	This position is the sum of the sprite's position and its size.
    */

    RCouple getCollBoxPos() const;
    RCouple getCollBoxSize() const;
    void setCollBoxPos(const RCouple &c);
    void setCollBoxSize(const RCouple &c);
    /*  Returns or changes the coordinates of this sprite's collision box.
	The position is relative to the top left corner of the sprite.
    */

    void setPos(const RCouple &c);
    void setSpeed(const RCouple &c);
    void setAccel(const RCouple &c);
    void addSpeedToPos();
    void subSpeedFromPos();
    void addAccelToSpeed();
    void subAccelFromSpeed();
    /*  Change the coordinates of the sprite.
    */

    bool collidesWithRSprite(const RSprite &s) const;
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

    /*  All the following RCouple objects are in pixels.
	All pixmaps in the pixmap array must have the same size.
    */

    const PixmapArray *thePixmapArray;  // not owned by this object

    RCouple pos;    // in pixels
    RCouple speed;  // in pixels
    RCouple accel;  // in pixels
    Couple size;    // in (integer) pixels
    unsigned long timeToLive;
	    // number of ticks left for this sprite;
	    // often used to count other things.

    RCouple collBoxPos;
	    // position of collision box w.r.t. to top left corner of sprite
    RCouple collBoxSize;

private:
    /*	Forbidden operations:
    */
    RSprite(const RSprite &x);
    RSprite &operator = (const RSprite &x);
};


/*  INLINE METHODS
*/

inline
const RCouple &
RSprite::getPos() const
{
    return pos;
}

inline
const RCouple &
RSprite::getSpeed() const
{
    return speed;
}

inline
const RCouple &
RSprite::getAccel() const
{
    return accel;
}

inline
const Couple &
RSprite::getSize() const
{
    return size;
}

inline
RCouple &
RSprite::getPos()
{
    return pos;
}

inline
RCouple &
RSprite::getSpeed()
{
    return speed;
}

inline
RCouple &
RSprite::getAccel()
{
    return accel;
}

inline
Couple &
RSprite::getSize()
{
    return size;
}

inline
RCouple
RSprite::getCenterPos() const
{
    return pos + size / 2;
}

inline
RCouple
RSprite::getLowerRightPos() const
{
    return pos + size;
}

inline
RCouple
RSprite::getCollBoxPos() const
{
    return collBoxPos;
}

inline
RCouple
RSprite::getCollBoxSize() const
{
    return collBoxSize;
}

inline
void
RSprite::setCollBoxPos(const RCouple &c)
{
    collBoxPos = c;
}

inline
void
RSprite::setCollBoxSize(const RCouple &c)
{
    collBoxSize = c;
}

inline
void
RSprite::setPos(const RCouple &c)
{
    pos = c;
}

inline
void
RSprite::setSpeed(const RCouple &c)
{
    speed = c;
}

inline
void
RSprite::setAccel(const RCouple &c)
{
    accel = c;
}

inline
void
RSprite::addSpeedToPos()
{
    pos += speed;
}

inline
void
RSprite::subSpeedFromPos()
{
    pos -= speed;
}

inline
void
RSprite::addAccelToSpeed()
{
    speed += accel;
}

inline
void
RSprite::subAccelFromSpeed()
{
    speed -= accel;
}

inline
void
RSprite::setTimeToLive(unsigned long t)
{
    timeToLive = t;
}

inline
unsigned long
RSprite::getTimeToLive() const
{
    return timeToLive;
}

inline
unsigned long
RSprite::decTimeToLive()
{
    if (timeToLive != 0) timeToLive--; return timeToLive;
}

inline
void
RSprite::clearTimeToLive()
{
    timeToLive = 0;
}

inline
size_t
RSprite::getNumPixmaps() const
{
    return thePixmapArray->getNumImages();
}

inline
SDL_Surface *
RSprite::getPixmap(size_t i) const
{
    return thePixmapArray->getImage(i);
}

inline
const PixmapArray *
RSprite::getPixmapArray() const
{
    return thePixmapArray;
}


}  // namespace flatzebra


#endif  /* _H_RSprite */
