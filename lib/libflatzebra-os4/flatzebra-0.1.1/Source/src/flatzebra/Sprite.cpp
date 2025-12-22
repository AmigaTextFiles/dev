/*  $Id: Sprite.cpp,v 1.1 2003/04/26 04:19:06 sarrazip Exp $
    Sprite.cpp - Sprite in a 2D game.

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

#include <flatzebra/Sprite.h>

#include <assert.h>

using namespace std;
using namespace flatzebra;


///////////////////////////////////////////////////////////////////////////////


template <class T>
inline T &
boundVariable(T &var, T lowerLimit, T upperLimit)
{
    if (var < lowerLimit)
	var = lowerLimit;
    else if (var > upperLimit)
	var = upperLimit;
    return var;
}


///////////////////////////////////////////////////////////////////////////////


Sprite::Sprite(const PixmapArray &pixmapArray,
		const Couple &_pos,
		const Couple &_speed,
		const Couple &_accel,
		const Couple &_collBoxPos,
		const Couple &_collBoxSize)
  : currentPixmapIndex(0),
    values(NULL),
    numUserValues(0),
    pos(_pos),
    speed(_speed),
    accel(_accel),
    timeToLive(0),
    collBoxPos(_collBoxPos),
    collBoxSize(_collBoxSize)
{
    thePixmapArray = &pixmapArray;
    size = thePixmapArray->getImageSize();
}


Sprite::~Sprite()
{
}


bool Sprite::collidesWithSprite(const Sprite &s) const
{
    const Sprite &s1 = *this;
    const Sprite &s2 = s;
    const Couple &pos1  = s1.getPos() + s1.collBoxPos;
    const Couple &size1 = s1.collBoxSize;
    const Couple &pos2  = s2.getPos() + s2.collBoxPos;
    const Couple &size2 = s2.collBoxSize;

    if (pos1.x + size1.x <= pos2.x)  // s1 at the left of s2
	return false;
    if (pos1.y + size1.y <= pos2.y)  // s1 above s2
	return false;
    if (pos2.x + size2.x <= pos1.x)  // s1 at the right of s2
	return false;
    if (pos2.y + size2.y <= pos1.y)  // s1 below s2
	return false;
    
    return true;
}


void Sprite::boundPosition(Couple settingSizeInPixels)
/*  If the position of sprite 's' is out of the setting, then this
    position is adjusted to bring the sprite back in.
*/
{
    ::boundVariable(pos.x, 0, settingSizeInPixels.x - size.x);
    ::boundVariable(pos.y, 0, settingSizeInPixels.y - size.y);

    // Assert that the sprite is still in the setting:
    assert(pos.x >= 0);
    assert(pos.x + size.x <= settingSizeInPixels.x);
    assert(pos.y >= 0);
    assert(pos.y + size.y <= settingSizeInPixels.y);
}
