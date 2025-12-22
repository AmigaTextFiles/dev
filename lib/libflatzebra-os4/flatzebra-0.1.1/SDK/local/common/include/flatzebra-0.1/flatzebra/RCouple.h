/*  $Id: RCouple.h,v 1.1 2003/10/21 04:05:06 sarrazip Exp $
    RCouple.h - Class representing a couple of integers.

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

#ifndef _H_RCouple
#define _H_RCouple

#include <flatzebra/Couple.h>

#include <math.h>


namespace flatzebra {


class RCouple
/*  Class representing a RCouple of floating point numbers.
*/
{
public:
    double x, y;
    /*  The components.
    */

    RCouple();
    /*  Builds a RCouple with ZERO values for the components.
    */

    RCouple(double a, double b);
    /*  Initiliazes a RCouple with x equal to a and y equal to b.
    */

    RCouple(const RCouple &c);
    /*  Copies the components of the RCouple 'c' into the current RCouple.
    */

    RCouple(const Couple &c);
    /*  Converts the integer couple 'c' into the current floating
	point RCouple.
    */

    RCouple &operator = (const RCouple &c);
    /*  Replaces the components of the current RCouple by those of 'c'.
    */

    RCouple &operator = (const Couple &c);
    /*  Replaces the components of the current RCouple by a conversion
	of the integer couple 'c' into a floating point couple.
    */

    ~RCouple();
    /*  Does nothing.
    */

    RCouple &zero();
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
    /*  Returns the length of the vector represented by the RCouple.
    */

    Couple round() const;
    /*  Returns an integer couple created from the rounded values of
	this floating point couple.
    */

    RCouple &operator += (const RCouple &c);
    RCouple &operator -= (const RCouple &c);
    RCouple &operator *= (double n);
    RCouple &operator /= (double n);
    /*  Return the current object as modified.
    */

    friend RCouple operator + (const RCouple &c1, const RCouple &c2);
    friend RCouple operator - (const RCouple &c1, const RCouple &c2);
    friend RCouple operator * (const RCouple &c1, double n);
    friend RCouple operator * (double n, const RCouple &c1);
    friend RCouple operator / (const RCouple &c1, double n);
    friend bool operator == (const RCouple &c1, const RCouple &c2);
    friend bool operator != (const RCouple &c1, const RCouple &c2);

};


//
//  IMPLEMENTATION (inline functions)
//


inline RCouple::RCouple()
  : x(0), y(0)
{
}


inline RCouple::RCouple(double a, double b)
  : x(a), y(b)
{
}


inline RCouple::RCouple(const RCouple &c)
  : x(c.x), y(c.y)
{
}


inline RCouple::RCouple(const Couple &c)
  : x(c.x), y(c.y)
{
}


inline RCouple &RCouple::operator = (const RCouple &c)
{
    x = c.x;
    y = c.y;
    return *this;
}


inline RCouple &RCouple::operator = (const Couple &c)
{
    x = c.x;
    y = c.y;
    return *this;
}


inline RCouple::~RCouple()
{
}


inline RCouple &RCouple::zero()
{
    x = y = 0;
    return *this;
}


inline bool RCouple::isZero() const
{
    return (x == 0 && y == 0);
}


inline bool RCouple::isNonZero() const
{
    return (x != 0 || y != 0);
}


inline RCouple &RCouple::operator += (const RCouple &c)
{
    x += c.x;
    y += c.y;
    return *this;
}


inline RCouple &RCouple::operator -= (const RCouple &c)
{
    x -= c.x;
    y -= c.y;
    return *this;
}


inline RCouple &RCouple::operator *= (double n)
{
    x *= n;
    y *= n;
    return *this;
}


inline RCouple &RCouple::operator /= (double n)
{
    x /= n;
    y /= n;
    return *this;
}


inline RCouple operator + (const RCouple &c1, const RCouple &c2)
{
    RCouple c(c1);
    return c += c2;
}


inline RCouple operator - (const RCouple &c1, const RCouple &c2)
{
    RCouple c(c1);
    return c -= c2;
}


inline RCouple operator * (const RCouple &c1, double n)
{
    RCouple c(c1);
    return c *= n;
}


inline RCouple operator * (double n, const RCouple &c1)
{
    RCouple c(c1);
    return c *= n;
}


inline RCouple operator / (const RCouple &c1, double n)
{
    RCouple c(c1);
    return c /= n;
}


inline bool operator == (const RCouple &c1, const RCouple &c2)
{
    return (c1.x == c2.x && c1.y == c2.y);
}


inline bool operator != (const RCouple &c1, const RCouple &c2)
{
    return !(c1 == c2);
}


inline double RCouple::length() const
{
    return hypot(x, y);
}


inline Couple RCouple::round() const
{
    return Couple(
	int(x >= 0 ? (x + 0.5) : (x - 0.5)),
	int(y >= 0 ? (y + 0.5) : (y - 0.5)));
}


}  // namespace flatzebra


#endif  /* _H_RCouple */
