#ifndef TWICPP_DATASTRUCTURES_FORMAT_H
#define TWICPP_DATASTRUCTURES_FORMAT_H

//
//  $VER: Format.h      1.0 (23 Jan 1997)
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

#ifndef TWICPP_DATASTRUCTURES_STRING_H
#include <twiclasses/datastructures/string.h>
#endif

///

/// class TWiFormat

class TWiFormat
    {
    private:
        TWiStr ErgStr;
        TWiStr FormatStr;
        static VOID put_char(register __d0 const UBYTE, register __a3 TWiFormat *);
        VOID PutChar(const UBYTE, TWiFormat *);
    public:
        TWiFormat(const STRPTR f = NULL) : FormatStr(f), ErgStr(NULL,0UL) { };
        TWiFormat(const STRPTR f, const ULONG l) : FormatStr(f), ErgStr(NULL,l) { };
        TWiFormat(const ULONG l) : FormatStr(), ErgStr(NULL,l) { };
        TWiFormat(const TWiFormat &p) : FormatStr(p.FormatStr), ErgStr(p.ErgStr) { };
        ~TWiFormat() { };
        TWiFormat &operator= (const TWiFormat &);
        VOID Format(const STRPTR p) { FormatStr = p; };
        const TWiStr &Format() const { return(FormatStr); };
        const TWiStr &Result() const { return(ErgStr); };
        operator const STRPTR() const { return(ErgStr); };
        TWiStr &format(const ULONG, ...);
        TWiStr &format(const APTR);
    };

ostream &operator<< (ostream &, const TWiFormat &);

///

#endif
