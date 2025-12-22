#ifndef TWICPP_DATASTRUCTURES_BUFFER_H
#define TWICPP_DATASTRUCTURES_BUFFER_H

//
//  $VER: Buffer.h      1.0 (23 Jan 1997)
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

#ifndef TWICPP_EXCEPTIONS_EXCEPTIONS_H
#include <twiclasses/exceptions/exceptions.h>
#endif

///

/// class TWiBuffer

class TWiBuffer
    {
    private:
        STRPTR Buffer;
        ULONG Size;
    public:
        TWiBuffer(const ULONG initsize = 256) : Buffer(NULL), Size(initsize) { setSize(Size,FALSE); };
        TWiBuffer(const TWiBuffer &);
        ~TWiBuffer() { delete[] Buffer; };
        TWiBuffer &operator= (const TWiBuffer &);
        operator APTR() const { return(Buffer); };
        APTR buffer() const { return(Buffer); };
        ULONG size() const { return(Buffer != NULL ? Size : 0); };
        VOID doubleBuffer(const BOOL copy = TRUE) { setSize(Size == 0 ? 256 : Size << 1,copy); };
        VOID setSize(const ULONG newsize, const BOOL copy = TRUE);
        VOID setMinSize(const ULONG minsize, const BOOL copy = TRUE);
        VOID extendBuffer(const ULONG addsize, const BOOL copy = TRUE) { setSize(Size+addsize,copy); };
        VOID eraseBuffer() { setSize(0,FALSE); };
    };

///

#endif
