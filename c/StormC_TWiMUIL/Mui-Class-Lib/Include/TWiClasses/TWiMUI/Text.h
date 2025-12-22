#ifndef TWICPP_TWIMUI_TEXT_H
#define TWICPP_TWIMUI_TEXT_H

//
//  $VER: Text.h        2.0 (10 Feb 1997)
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
//                        Bug Fixes:
//                        - Der Konstruktor ohne Parameter hat die Basisklasse
//                          falsch konstruiert.
//                        Änderungen:
//                        - Parameter des Copy-Konstruktor als 'const'-Parameter definiert
//

/// Includes

#ifndef TWICPP_TWIMUI_AREA_H
#include <twiclasses/twimui/area.h>
#endif

///

/// class MUIText

class MUIText : public MUIArea
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIText(const struct TagItem *t) : MUIArea(MUIC_Text) { init(t); };
        MUIText(const Tag t, ...);
        MUIText() : MUIArea(MUIC_Text) { };
        MUIText(const MUIText &);
        virtual ~MUIText();
        MUIText &operator= (const MUIText &);
        VOID Contents(const STRPTR p) { set(MUIA_Text_Contents,(ULONG)p); };
        STRPTR Contents() const { return((STRPTR)get(MUIA_Text_Contents,NULL)); };
        VOID PreParse(const STRPTR p) { set(MUIA_Text_PreParse,(ULONG)p); };
        STRPTR PreParse() const { return((STRPTR)get(MUIA_Text_PreParse,NULL)); };
    };

///

#endif
