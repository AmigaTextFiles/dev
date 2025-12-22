//
//  $VER: Busy.cpp       1.0 (19 Feb 1997)
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
//  19 Feb 1997 :   1.0 : first Release
//

/// Includes

#ifndef TWICPP_TWIMUI_BUSY_H
#include <twiclasses/twimui/busy.h>
#endif

#ifndef  CLIB_ALIB_PROTOS_H
#include <clib/alib_protos.h>
#endif

#ifndef _INCLUDE_PRAGMA_ALL_LIB_H
#include <pragma/all_lib.h>
#endif

#ifndef _INCLUDE_STDARG_H
#include <stdarg.h>
#endif

///

/// Constants

const ULONG MUIV_TWiMUI_MUIErrorX_Busy = 51;

///

///             MUIBusy::MUIBusy(const Tag, ...)

MUIBusy::MUIBusy(const Tag t, ...)
    :   MUIArea(MUIC_Busy)
    {
    TWiTag ta();
    if (t != TAG_DONE)
        {
        va_list plst;
        Tag tmp;
        BOOL end;
        va_start(plst,t);
        ta.append(t,va_arg(plst,Tag),TAG_DONE);
        for (end = FALSE  ;  !end  ;  )
            if ((tmp = (Tag)va_arg(plst,Tag)) != TAG_DONE)
                ta.append(tmp,va_arg(plst,Tag),TAG_DONE);
            else
                end = TRUE;
        va_end(plst);
        }
    else
        ;
    init(ta.tags());
    };

///
///             MUIBusy::MUIBusy(const MUIBusy &)

MUIBusy::MUIBusy(const MUIBusy &p)
    :   MUIArea(MUIC_Text)
    {
    TWiTag ta(p.Tags.tags());
    init(ta.tags());
    };

///
/// const ULONG MUIBusy::ClassNum() const

const ULONG MUIBusy::ClassNum() const
    {
    return(MUIV_TWiMUI_MUIErrorX_Busy);
    };

///
///             MUIBusy::~MUIBusy()

MUIBusy::~MUIBusy()
    {
    };

///
/// MUIBusy    &MUIBusy::operator= (const MUIBusy &)

MUIBusy &MUIBusy::operator= (const MUIBusy &p)
    {
    if (this != &p)
        {
        MUIArea::operator=(p);
        TWiTag ta(p.Tags.tags());
        init(ta.tags());
        }
    else
        ;
    return(*this);
    };

///
