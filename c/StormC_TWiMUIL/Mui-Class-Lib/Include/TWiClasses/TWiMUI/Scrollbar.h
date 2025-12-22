#ifndef TWICPP_TWIMUI_SCROLLBAR_H
#define TWICPP_TWIMUI_SCROLLBAR_H

//
//  $VER: Scrollbar.h   2.0 (10 Feb 1997)
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
//  16 Jun 1996 :   1.0 : first public Release
//
//  02 Sep 1996 :   1.2 : Neu:
//                        - ClassNum() für Exception-Handling.
//                        Änderungen:
//                        - Parameter des Copy-Konstruktor als 'const'-Parameter definiert
//

/// Includes

#ifndef TWICPP_TWIMUI_GROUP_H
#include <twiclasses/twimui/group.h>
#endif

///

/// class MUIScrollbar

class MUIScrollbar : public MUIGroup
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIScrollbar(const struct TagItem *t) : MUIGroup(MUIC_Scrollbar) { init(t); };
        MUIScrollbar(const Tag, ...);
        MUIScrollbar() : MUIGroup(MUIC_Scrollbar) { };
        MUIScrollbar(const MUIScrollbar &);
        virtual ~MUIScrollbar();
        MUIScrollbar &operator= (const MUIScrollbar &);
    };

///

#endif
