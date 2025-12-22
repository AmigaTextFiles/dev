#ifndef TWICPP_TWIMUI_LISTVIEW_H
#define TWICPP_TWIMUI_LISTVIEW_H

//
//  $VER: Listview.h    2.0 (10 Feb 1997)
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

/// class MUIListview

class MUIListview : public MUIGroup
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIListview(const struct TagItem *t) : MUIGroup(MUIC_Listview) { init(t); };
        MUIListview(const Tag, ...);
        MUIListview() : MUIGroup(MUIC_Listview) { };
        MUIListview(const MUIListview &);
        virtual ~MUIListview();
        MUIListview &operator= (const MUIListview &);
        LONG ClickColumn() const { return((LONG)get(MUIA_Listview_ClickColumn,0L)); };
        VOID DefClickColumn(const LONG p) { set(MUIA_Listview_DefClickColumn,(ULONG)p); };
        LONG DefClickColumn() const { return((LONG)get(MUIA_Listview_DefClickColumn,0L)); };
        BOOL DoubleClick() const { return((BOOL)get(MUIA_Listview_DoubleClick,FALSE)); };
        VOID DragType(const LONG p) { set(MUIA_Listview_DragType,(ULONG)p); };
        VOID DragTypeNone() { set(MUIA_Listview_DragType,MUIV_Listview_DragType_None); };
        VOID DragTypeImmediate() { set(MUIA_Listview_DragType,MUIV_Listview_DragType_Immediate); };
        LONG DragType() const { return((LONG)get(MUIA_Listview_DragType,MUIV_Listview_DragType_None)); };
        Object *List() const { return((Object *)get(MUIA_Listview_List,NULL)); };
        BOOL SelectChange() const { return((BOOL)get(MUIA_Listview_SelectChange,FALSE)); };
    };

///

#endif
