#ifndef TWICPP_TWIMUI_FLOATTEXT_H
#define TWICPP_TWIMUI_FLOATTEXT_H

//
//  $VER: Floattext.h   2.0 (10 Feb 1997)
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

#ifndef TWICPP_TWIMUI_LIST_H
#include <twiclasses/twimui/list.h>
#endif

///

/// class MUIFloattext

class MUIFloattext : public MUIList
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIFloattext(const struct TagItem *t) : MUIList(MUIC_Floattext) { init(t); };
        MUIFloattext(const Tag, ...);
        MUIFloattext() : MUIList(MUIC_Floattext) { };
        MUIFloattext(const MUIFloattext &);
        virtual ~MUIFloattext();
        MUIFloattext &operator= (const MUIFloattext &);
        VOID Justify(const BOOL p) { set(MUIA_Floattext_Justify,(ULONG)p); };
        BOOL Justify() const { return((BOOL)get(MUIA_Floattext_Justify,FALSE)); };
        VOID SkipChars(const STRPTR p) { set(MUIA_Floattext_SkipChars,(ULONG)p); };
        VOID TabSize(const LONG p) { set(MUIA_Floattext_TabSize,(ULONG)p); };
        VOID Text(const STRPTR p) { set(MUIA_Floattext_Text,(ULONG)p); };
        STRPTR Text() const { return((STRPTR)get(MUIA_Floattext_Text,NULL)); };
    };

///

#endif
