/*  $Id: Couple.h,v 1.1 2003/04/26 04:19:06 sarrazip Exp $
    Couple.h - Class representing a couple of integers.

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

#ifndef _H_Couple
#define _H_Couple

#include <math.h>


namespace flatzebra {


class Couple
/*  Class representing a couple of integers.
*/
{
public:
    int x, y;
    /*  The components.
    */

    Couple();
    /*  Builds a couple with ZERO values for the components.
    */

    Couple(int a, int b);
    /*  Initiliazes a couple with x equal to a and y equal to b.
    */

    Couple(const Couple &c);
    /*  Copies the components of the couple 'c' into the current couple.
    */

    Couple &operator = (const Couple &c);
    /*  Replaces the components of the current couple by those of 'c'.
    */

    ~Couple();
    /*  Does nothing.
    */

    Couple &zero();
    /*  Assign zero to both components.
	Returns a reference to this object.
	Was void until version 0.1.
    */

    bool isZero() const;
    /*  Returns true iff both components are zero.
    */

    bool isNonZero() const;
    /*  Returns true iff one or both components differ from zero.
    */

    double length() const;
    /*  Returns the length of the vector represented by the couple.
    */

    Couple &operator += (const Couple &c);
    Couple &operator -= (const Couple &c);
    Couple &operator *= (int n);
    Couple &operator /= (int n);
    /*  Return the current object as modified.
    */

    friend Couple operator + (const Couple &c1, const Couple &c2);
    friend Couple operator - (const Couple &c1, const Couple &c2);
    friend Couple operator * (const Couple &c1, int n);
    friend Couple operator * (int n, const Couple &c1);
    friend Couple operator / (const Couple &c1, int n);
    friend bool operator == (const Couple &c1, const Couple &c2);
    friend bool operator != (const Couple &c1, const Couple &c2);

};


//
//  IMPLEMENTATION (inline functions)
//


inline Couple::Couple()
  : x(0), y(0)
{
}


inline Couple::Couple(int a, int b)
  : x(a), y(b)
{
}


inline Couple::Couple(const Couple &c)
  : x(c.x), y(c.y)
{
}


inline Couple &Couple::operator = (const Couple &c)
{
    x = c.x;
    y = c.y;
    return *this;
}


inline Couple::~Couple()
{
}


inline Couple &Couple::zero()
{
    x = y = 0;
    return *this;
}


inline bool Couple::isZero() const
{
    return (x == 0 && y == 0);
}


inline bool Couple::isNonZero() const
{
    return (x != 0 || y != 0);
}


inline Couple &Couple::operator += (const Couple &c)
{
    x += c.x;
    y += c.y;
    return *this;
}


inline Couple &Couple::operator -= (const Couple &c)
{
    x -= c.x;
    y -= c.y;
    return *this;
}


inline Couple &Couple::operator *= (int n)
{
    x *= n;
    y *= n;
    return *this;
}


inline Couple &Couple::operator /= (int n)
{
    x /= n;
    y /= n;
    return *this;
}


inline Couple operator + (const Couple &c1, const Couple &c2)
{
    Couple c(c1);
    return c += c2;
}


inline Couple operator - (const Couple &c1, const Couple &c2)
{
    Couple c(c1);
    return c -= c2;
}


inline Couple operator * (const Couple &c1, int n)
{
    Couple c(c1);
    return c *= n;
}


inline Couple operator * (int n, const Couple &c1)
{
    Couple c(c1);
    return c *= n;
}


inline Couple operator / (const Couple &c1, int n)
{
    Couple c(c1);
    return c /= n;
}


inline bool operator == (const Couple &c1, const Couple &c2)
{
    return (c1.x == c2.x && c1.y == c2.y);
}


inline bool operator != (const Couple &c1, const Couple &c2)
{
    return !(c1 == c2);
}


inline double Couple::length() const
{
    return sqrt(double(x) * x + double(y) * y);
}


}  // namespace flatzebra


#endif  /* _H_Couple */
