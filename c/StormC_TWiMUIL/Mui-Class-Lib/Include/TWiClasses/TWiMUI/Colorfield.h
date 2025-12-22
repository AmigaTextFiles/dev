#ifndef TWICPP_TWIMUI_COLORFIELD_H
#define TWICPP_TWIMUI_COLORFIELD_H

//
//  $VER: Colorfield.h  2.0 (10 feb 1997)
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

/// class MUIColorfield

class MUIColorfield : public MUIArea
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIColorfield(const struct TagItem *t) : MUIArea(MUIC_Colorfield) { init(t); };
        MUIColorfield(const Tag, ...);
        MUIColorfield() : MUIArea(MUIC_Colorfield) { };
        MUIColorfield(const MUIColorfield &);
        virtual ~MUIColorfield();
        MUIColorfield &operator= (const MUIColorfield &);
        VOID Blue(const ULONG p) { set(MUIA_Colorfield_Blue,p); };
        ULONG Blue() const { return(get(MUIA_Colorfield_Blue,0UL)); };
        VOID Green(const ULONG p) { set(MUIA_Colorfield_Green,p); };
        ULONG Green() const { return(get(MUIA_Colorfield_Green,0UL)); };
        ULONG Pen() const { return(get(MUIA_Colorfield_Pen,0UL)); };
        VOID Red(const ULONG p) { set(MUIA_Colorfield_Red,p); };
        ULONG Red() const { return(get(MUIA_Colorfield_Red,0UL)); };
        VOID RGB(const ULONG *p) { set(MUIA_Colorfield_RGB,(ULONG)p); };
        ULONG *RGB() const { return((ULONG *)get(MUIA_Colorfield_RGB,NULL)); };
    };

///

#endif
