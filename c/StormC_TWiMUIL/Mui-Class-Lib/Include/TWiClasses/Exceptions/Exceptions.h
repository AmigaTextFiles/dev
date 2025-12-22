#ifndef TWICPP_EXCEPTIONS_EXCEPTIONS_H
#define TWICPP_EXCEPTIONS_EXCEPTIONS_H

//
//  $VER: Misc.h        1.0 (23 Jan 1997)
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

#ifndef EXEC_MEMORY_H
#include <exec/memory.h>
#endif

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef _INCLUDE_EXCEPTION_H
#include <exception.h>
#endif

///

/// class TWiResourceX

class TWiResourceX : public Exception
    {
    };

///
/// class TWiMemX

class TWiMemX : public TWiResourceX
    {
    private:
        ULONG WantedSize;
        ULONG WantedFlags;
    public:
        TWiMemX(const ULONG s, const ULONG f = MEMF_ANY) : WantedSize(s), WantedFlags(f) { };
        ULONG size() const { return(WantedSize); };
        ULONG flags() const { return(WantedFlags); };
    };

///
/// class TWiDosObjectX

class TWiDosObjectX : public TWiResourceX
    {
    private:
        ULONG dType;
    public:
        TWiDosObjectX(const ULONG type = ~0) : dType(type) { };
        ~TWiDosObjectX() { };
        ULONG type() const { return(dType); };
    };

///
/// class TWiRDArgsX

class TWiRDArgsX : public TWiResourceX
    {
    };

///

#endif
