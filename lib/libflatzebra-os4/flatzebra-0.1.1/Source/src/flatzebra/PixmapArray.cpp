/*  $Id: PixmapArray.cpp,v 1.1 2003/04/26 04:19:06 sarrazip Exp $
    PixmapArray.cpp - Object containing an array of Pixmaps.

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

#include <flatzebra/PixmapArray.h>

#include <assert.h>

using namespace std;
using namespace flatzebra;


PixmapArray::PixmapArray(size_t numImages)
  : images(numImages, NULL),
    imageSize(0, 0)
{
    assert(numImages > 0);
}


PixmapArray::~PixmapArray()
{
    for (vector<SDL_Surface *>::iterator it = images.begin();
					it != images.end(); it++)
	SDL_FreeSurface(*it);
}


void
PixmapArray::setArrayElement(size_t i, SDL_Surface *image)
{
    assert(i < images.size());
    assert(image != NULL);

    images[i] = image;
}


void
PixmapArray::setImageSize(Couple size)
{
    assert(size.x != 0 && size.y != 0);
    imageSize = size;
}
