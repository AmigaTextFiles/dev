/*  $Id: PixmapLoadError.h,v 1.1 2003/04/26 04:19:06 sarrazip Exp $
    PixmapLoadError.h - Exception describing an error when loading a pixmap

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

#ifndef _H_PixmapLoadError
#define _H_PixmapLoadError

#include <string>


namespace flatzebra {


class PixmapLoadError
/*  Exception describing an error when loading a pixmap.
*/
{
public:
    enum Code
    {
	INVALID_ARGS = 1, OPEN_FAILED, INVALID_FILE,
	NO_MEMORY, NULL_PIXMAP, INVALID_SIZE,
	COLOR_FAILED, COLOR_ERROR, UNKNOWN
    };

    PixmapLoadError(Code c, const char *filename);
    /*  Keeps a copy of the code and the string, but not of the
	pointer 'filename'.
	'filename' should be the name of the file that caused
	the loading error.
	'filename' is allowed to be empty or null.
	A null value is typically used when there is no
	filename; e.g., when the source is data instead of a file.
    */

    PixmapLoadError(const PixmapLoadError &x);
    /*  Makes a complete copy.
    */

    ~PixmapLoadError();
    /*  Nothing interesting.
    */

    Code getCode() const;
    std::string getFilename() const;
    /*  Get the description of this exception.
	If the 'filename' argument passed to the constructor was null,
	then getFilename() returned an empty string.
    */


private:
    Code theCode;
    std::string theFilename;


    /*	Forbidden operations:
    */
    PixmapLoadError &operator = (const PixmapLoadError &x);
};


}  // namespace flatzebra


#endif  /* _H_PixmapLoadError */
