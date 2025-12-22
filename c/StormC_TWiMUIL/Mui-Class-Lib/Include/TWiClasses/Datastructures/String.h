#ifndef TWICPP_DATASTRUCTURES_STRING_H
#define TWICPP_DATASTRUCTURES_STRING_H

//
//  $VER: String.h      1.0 (23 Jan 1997)
//
//    c 1997 Thomas Wilhelmi
//
//
// Address : Taunusstrasse 14
//           61138 Niederdorfelden
//           Germany
//
//  E-Mail : willi@twi.rhein-main.de
//
//   Phone : +49 (0)6101 531060
//   Fax   : +49 (0)6101 531061
//
//
//  $HISTORY:
//
//  06 Jan 1997 :   1.0 : first public Release
//

/// Includes

#ifndef TWICPP_DATASTRUCTURES_BUFFER_H
#include <twiclasses/datastructures/buffer.h>
#endif

#ifndef _INCLUDE_IOSTREAM_H
#include <iostream.h>
#endif

#ifndef _INCLUDE_STRING_H
#include <string.h>
#endif

///

/// class TWiStr

class TWiStr
    {
    private:
        TWiBuffer Buffer;
    public:
        TWiStr(const STRPTR = NULL);
        TWiStr(const STRPTR, const ULONG);
        TWiStr(const UBYTE);
        TWiStr(const TWiStr &s) : Buffer(s.Buffer) { };
        ~TWiStr() { };
        operator STRPTR() const { return((STRPTR)((APTR)Buffer)); };
        TWiStr &operator= (const TWiStr &);
        TWiStr &operator= (const STRPTR);
        TWiStr &operator= (const UBYTE);
        TWiStr &operator= (const ULONG);
        TWiStr &operator= (const LONG);
        UBYTE &operator[] (ULONG);
        TWiStr &operator+= (const TWiStr &);
        TWiStr &operator+= (const STRPTR);
        TWiStr &operator+= (UBYTE);
        TWiStr &operator+= (ULONG);
        TWiStr &operator+= (LONG);
        ULONG size() const { return((APTR)Buffer == NULL ? 0 : Buffer.size()); };
        ULONG length() const { return((APTR)Buffer == NULL ? 0 : strlen((STRPTR)((APTR)Buffer))); };
        TWiStr left(ULONG) const;
        TWiStr mid(ULONG, ULONG) const;
        TWiStr right(ULONG) const;
        LONG pos(const STRPTR cont, const LONG start = 0) const;
        VOID cut(const ULONG);
        VOID shrinkBuffer();
        VOID doubleBuffer() { Buffer.doubleBuffer(TRUE); };
    };

TWiStr   operator+ (const TWiStr &, const TWiStr &);
ostream &operator<< (ostream &, const TWiStr &);
istream &operator>> (istream &, TWiStr &);

inline const BOOL operator== (const TWiStr &s1, const TWiStr &s2) const { return(strcmp((STRPTR)s1,(STRPTR)s2) == 0); };
inline const BOOL operator!= (const TWiStr &s1, const TWiStr &s2) const { return(strcmp((STRPTR)s1,(STRPTR)s2) != 0); };
inline const BOOL operator<  (const TWiStr &s1, const TWiStr &s2) const { return(strcmp((STRPTR)s1,(STRPTR)s2) <  0); };
inline const BOOL operator>  (const TWiStr &s1, const TWiStr &s2) const { return(strcmp((STRPTR)s1,(STRPTR)s2) >  0); };
inline const BOOL operator<= (const TWiStr &s1, const TWiStr &s2) const { return(strcmp((STRPTR)s1,(STRPTR)s2) <= 0); };
inline const BOOL operator>= (const TWiStr &s1, const TWiStr &s2) const { return(strcmp((STRPTR)s1,(STRPTR)s2) >= 0); };

///

#endif
