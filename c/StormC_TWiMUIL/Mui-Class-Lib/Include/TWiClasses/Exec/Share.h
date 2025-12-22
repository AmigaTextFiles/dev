#ifndef TWICPP_EXEC_SHARE_H
#define TWICPP_EXEC_SHARE_H

//
//  $VER: Share.h       1.0 (24 Jan 1997)
//
//    c 1996 Thomas Wilhelmi
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
//  24 Jan 1997 :   1.0 : first public Release
//

/// Includes

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef TWICPP_EXCEPTIONS_EXCEPTIONS_H
#include <twiclasses/exceptions/exceptions.h>
#endif

///

/// class TWiShare

class TWiShare
    {
    private:
        ULONG *counter;
    public:
        TWiShare();
        TWiShare(const TWiShare &);
        ~TWiShare();
        TWiShare &operator= (const TWiShare &);
        BOOL only() const { return((*counter) == 0); };
    };

///
/// class TWiShareManual

class TWiShareManual : private TWiShare
    {
    private:
        ULONG *references;
    public:
        TWiShareManual();
        TWiShareManual(const TWiShareManual &);
        ~TWiShareManual();
        TWiShareManual &operator = (const TWiShareManual &);
        VOID reference();
        VOID dereference();
        BOOL only() const;
    };

#endif
