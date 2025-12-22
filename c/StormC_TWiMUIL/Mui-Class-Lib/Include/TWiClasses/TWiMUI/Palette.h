#ifndef TWICPP_TWIMUI_PALETTE_H
#define TWICPP_TWIMUI_PALETTE_H

//
//  $VER: Palette.h     2.0 (10 Feb 1997)
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

/// class MUIPalette

class MUIPalette : public MUIGroup
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIPalette(const struct TagItem *t) : MUIGroup(MUIC_Palette) { init(t); };
        MUIPalette(const Tag, ...);
        MUIPalette() : MUIGroup(MUIC_Palette) { };
        MUIPalette(const MUIPalette &);
        virtual ~MUIPalette();
        MUIPalette &operator= (const MUIPalette &);
        struct MUI_Palette_Entry *Entries() const { return((MUI_Palette_Entry *)get(MUIA_Palette_Entries,NULL)); };
        VOID Groupable(const BOOL p) { set(MUIA_Palette_Groupable,(ULONG)p); };
        BOOL Groupable() const { return((BOOL)get(MUIA_Palette_Groupable,TRUE)); };
        VOID Names(const STRPTR *p) { set(MUIA_Palette_Names,(ULONG)p); };
        STRPTR *Names() const { return((STRPTR *)get(MUIA_Palette_Names,NULL)); };
    };

///

#endif
