#ifndef TWICPP_TWIMUI_POPPEN_H
#define TWICPP_TWIMUI_POPPEN_H

//
//  $VER: Poppen.h      2.0 (10 Feb 1997)
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

#ifndef TWICPP_TWIMUI_PENDISPLAY_H
#include <twiclasses/twimui/pendisplay.h>
#endif

///

/// class MUIPoppen

class MUIPoppen : public MUIPendisplay
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIPoppen(const struct TagItem *t) : MUIPendisplay(MUIC_Poppen) { init(t); };
        MUIPoppen(const Tag, ...);
        MUIPoppen() : MUIPendisplay(MUIC_Poppen) { };
        MUIPoppen(const MUIPoppen &);
        virtual ~MUIPoppen();
        MUIPoppen &operator= (const MUIPoppen &);
    };

///

#endif
