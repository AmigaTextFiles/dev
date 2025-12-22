#ifndef TWICPP_TWIMUI_BALANCE_H
#define TWICPP_TWIMUI_BALANCE_H

//
//  $VER: Balance.h     2.0 (10 Feb 1997)
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

#ifndef TWICPP_TWIMUI_AREA_H
#include <twiclasses/twimui/area.h>
#endif

///

/// class MUIBalance

class MUIBalance : public MUIArea
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIBalance(const struct TagItem *t) : MUIArea(MUIC_Balance) { init(t); };
        MUIBalance(const Tag, ...);
        MUIBalance() : MUIArea(MUIC_Balance) { };
        MUIBalance(const MUIBalance &);
        virtual ~MUIBalance();
        MUIBalance &operator= (const MUIBalance &);
    };

///

#endif
