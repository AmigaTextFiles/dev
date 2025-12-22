#ifndef TWICPP_TWIMUI_SCALE_H
#define TWICPP_TWIMUI_SCALE_H

//
//  $VER: Scale.h       2.0 (10 Feb 1997)
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

/// class MUIScale

class MUIScale : public MUIArea
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIScale(const struct TagItem *t) : MUIArea(MUIC_Scale) { init(t); };
        MUIScale(const Tag, ...);
        MUIScale() : MUIArea(MUIC_Scale) { };
        MUIScale(const MUIScale &);
        virtual ~MUIScale();
        MUIScale &operator= (const MUIScale &);
        VOID Horiz(const BOOL p) { set(MUIA_Scale_Horiz,(ULONG)p); };
        BOOL Horiz() const { return((BOOL)get(MUIA_Scale_Horiz,FALSE)); };
    };

///

#endif
