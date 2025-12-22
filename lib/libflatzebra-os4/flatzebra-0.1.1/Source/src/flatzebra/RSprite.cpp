/*  $Id: RSprite.cpp,v 1.1 2003/10/21 04:05:06 sarrazip Exp $
    RSprite.cpp - Sprite with floating point coordinates in a 2D game.

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

#include <flatzebra/RSprite.h>

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


RSprite::RSprite(const PixmapArray &pixmapArray,
		const RCouple &_pos,
		const RCouple &_speed,
		const RCouple &_accel,
		const RCouple &_collBoxPos,
		const RCouple &_collBoxSize)
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


RSprite::~RSprite()
{
}


bool RSprite::collidesWithRSprite(const RSprite &s) const
{
    const RSprite &s1 = *this;
    const RSprite &s2 = s;
    const RCouple &pos1  = s1.getPos() + s1.collBoxPos;
    const RCouple &size1 = s1.collBoxSize;
    const RCouple &pos2  = s2.getPos() + s2.collBoxPos;
    const RCouple &size2 = s2.collBoxSize;

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


void RSprite::boundPosition(Couple settingSizeInPixels)
/*  If the position of sprite 's' is out of the setting, then this
    position is adjusted to bring the sprite back in.
*/
{
    int x = int(pos.x);
    int y = int(pos.y);
    ::boundVariable(x, 0, settingSizeInPixels.x - size.x);
    ::boundVariable(y, 0, settingSizeInPixels.y - size.y);
    pos = RCouple(x, y);

    // Assert that the sprite is still in the setting:
    assert(pos.x >= 0);
    assert(pos.x + size.x <= settingSizeInPixels.x);
    assert(pos.y >= 0);
    assert(pos.y + size.y <= settingSizeInPixels.y);
}
