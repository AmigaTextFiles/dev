#ifndef TWICPP_TWIMUI_VIRTGROUP_H
#define TWICPP_TWIMUI_VIRTGROUP_H

//
//  $VER: Virtgroup.h   2.0 (10 Feb 1997)
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

/// class MUIVirtgroup

class MUIVirtgroup : public MUIGroup
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIVirtgroup(const struct TagItem *t) : MUIGroup(MUIC_Virtgroup) { init(t); };
        MUIVirtgroup(const Tag, ...);
        MUIVirtgroup() : MUIGroup(MUIC_Virtgroup) { };
        MUIVirtgroup(const MUIVirtgroup &);
        virtual ~MUIVirtgroup();
        MUIVirtgroup &operator= (const MUIVirtgroup &);
        LONG Height() const { return((LONG)get(MUIA_Virtgroup_Height,0L)); };
        VOID Left(const LONG p) { set(MUIA_Virtgroup_Left,(ULONG)p); };
        LONG Left() const { return((LONG)get(MUIA_Virtgroup_Left,0L)); };
        VOID Top(const LONG p) { set(MUIA_Virtgroup_Top,(ULONG)p); };
        LONG Top() const { return((LONG)get(MUIA_Virtgroup_Top,0L)); };
        LONG Width() const { return((LONG)get(MUIA_Virtgroup_Width,0L)); };
    };

///

#endif
