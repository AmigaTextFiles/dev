#ifndef TWICPP_TWIMUI_SCROLLGROUP_H
#define TWICPP_TWIMUI_SCROLLGROUP_H

//
//  $VER: Scrollgroup.h 2.0 (10 Feb 1997)
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
//                        - Die Methode Contents() wurde für MUI 3.6 hinzugefügt
//                        - Die Methode HorizBar() wurde für MUI 3.6 hinzugefügt
//                        - Die Methode VertBar() wurde für MUI 3.6 hinzugefügt
//                        - ClassNum() für Exception-Handling.
//                        Änderungen:
//                        - Parameter des Copy-Konstruktor als 'const'-Parameter definiert
//

/// Includes

#ifndef TWICPP_TWIMUI_GROUP_H
#include <twiclasses/twimui/group.h>
#endif

///

/// class MUIScrollgroup

class MUIScrollgroup : public MUIGroup
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIScrollgroup(const struct TagItem *t) : MUIGroup(MUIC_Scrollgroup) { init(t); };
        MUIScrollgroup(const Tag, ...);
        MUIScrollgroup() : MUIGroup(MUIC_Scrollgroup) { };
        MUIScrollgroup(const MUIScrollgroup &);
        virtual ~MUIScrollgroup();
        MUIScrollgroup &operator= (const MUIScrollgroup &);
        Object *Contents() const { return((Object *)get(MUIA_Scrollgroup_Contents,NULL)); };
        Object *HorizBar() const { return((Object *)get(MUIA_Scrollgroup_HorizBar,NULL)); };
        Object *VertBar() const { return((Object *)get(MUIA_Scrollgroup_VertBar,NULL)); };
    };

///

#endif
