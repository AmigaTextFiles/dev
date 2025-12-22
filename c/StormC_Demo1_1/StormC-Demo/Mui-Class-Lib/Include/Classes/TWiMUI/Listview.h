//
//  $VER: Listview.h    1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_LISTVIEW_H
#define CPP_TWIMUI_LISTVIEW_H

#ifndef CPP_TWIMUI_GROUP_H
#include <classes/twimui/group.h>
#endif

class MUIListview : public MUIGroup
	{
	public:
		MUIListview(const struct TagItem *t) : MUIGroup(MUIC_Listview) { init(t); };
		MUIListview(const Tag, ...);
		MUIListview() : MUIGroup(MUIC_Listview) { };
		MUIListview(MUIListview &p) : MUIGroup(p) { };
		virtual ~MUIListview();
		MUIListview &operator= (MUIListview &);
		LONG ClickColumn() const { return((LONG)get(MUIA_Listview_ClickColumn,0L)); };
		void DefClickColumn(const LONG p) { set(MUIA_Listview_DefClickColumn,(ULONG)p); };
		LONG DefClickColumn() const { return((LONG)get(MUIA_Listview_DefClickColumn,0L)); };
		BOOL DoubleClick() const { return((BOOL)get(MUIA_Listview_DoubleClick,FALSE)); };
		void DragType(const LONG p) { set(MUIA_Listview_DragType,(ULONG)p); };
		void DragTypeNone() { set(MUIA_Listview_DragType,MUIV_Listview_DragType_None); };
		void DragTypeImmediate() { set(MUIA_Listview_DragType,MUIV_Listview_DragType_Immediate); };
		LONG DragType() const { return((LONG)get(MUIA_Listview_DragType,MUIV_Listview_DragType_None)); };
		Object *List() const { return((Object *)get(MUIA_Listview_List,NULL)); };
		BOOL SelectChange() const { return((BOOL)get(MUIA_Listview_SelectChange,FALSE)); };
	};

#endif
