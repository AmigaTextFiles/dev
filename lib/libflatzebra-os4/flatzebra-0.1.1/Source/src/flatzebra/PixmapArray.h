/*  $Id: PixmapArray.h,v 1.1 2003/04/26 04:19:06 sarrazip Exp $
    PixmapArray.h - Object containing an array of Pixmaps.

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

#ifndef _H_PixmapArray
#define _H_PixmapArray

#include <flatzebra/Couple.h>

#include <SDL.h>
#include <SDL_image.h>

#include <vector>


namespace flatzebra {


class PixmapArray
/*  Object containing an array of Pixmaps.
*/
{
public:

    PixmapArray(size_t numImages);
    /*  Creates a pixmap array capable of containing 'numImages' images.
	'numImages' must be positive.
	This object is the owner of the pixmaps, and the destructor will
	take care of freeing them.
    */

    ~PixmapArray();
    /*  Calls freePixmaps().
    */

    SDL_Surface *getImage(size_t i) const;
    size_t getNumImages() const;
    /*  Returns the pixmap of the image at index 'i' of the
	arrays given to the constructor of this object.
	'i' must be lower than the value returned by getNumImages().
	This method must not be called if freePixmaps() has been called
	on this object.
    */

    void setArrayElement(size_t i, SDL_Surface *image);
    /*  'i' must be a valid index in the array.
	'image' must not be null.
    */

    void setImageSize(Couple size);
    Couple getImageSize() const;
    /*  Sets or gets the size in pixels of the images in the pixmap array.
	All images in the array are assumed to be of the same size.
	Neither size.x nor size.y are allowed to be zero.
    */

private:

    std::vector<SDL_Surface *> images;
    Couple imageSize;  // size in pixels of the images; all assumed same size


    /*	Forbidden operations:
    */
    PixmapArray(const PixmapArray &x);
    PixmapArray &operator = (const PixmapArray &x);

};


/*  INLINE METHODS
*/

inline SDL_Surface *
PixmapArray::getImage(size_t i) const { return images[i]; }
inline size_t
PixmapArray::getNumImages() const { return images.size(); }
inline Couple
PixmapArray::getImageSize() const { return imageSize; }


}  // namespace flatzebra


#endif  /* _H_PixmapArray */
