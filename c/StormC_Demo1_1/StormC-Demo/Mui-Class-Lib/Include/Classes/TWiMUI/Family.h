//
//  $VER: Family.h      1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_FAMILY_H
#define CPP_TWIMUI_FAMILY_H

#ifndef CPP_TWIMUI_NOTIFY_H
#include <classes/twimui/notify.h>
#endif

#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif

class MUIFamily : public MUINotify
	{
	protected:
		MUIFamily(const STRPTR cl) : MUINotify(cl) { };
		MUIFamily(MUIFamily &p) : MUINotify(p) { };
		virtual ~MUIFamily();
		MUIFamily &operator= (MUIFamily &);
	public:
		struct MinList *List() const { return((struct MinList *)get(MUIA_Family_List,NULL)); };
		void AddHead(Object *p) { dom(MUIM_Family_AddHead,(ULONG)p); };
		void AddTail(Object *p) { dom(MUIM_Family_AddTail,(ULONG)p); };
		void Insert(Object *p1, Object *p2) { dom(MUIM_Family_Insert,(ULONG)p1,(ULONG)p2); };
		void Remove(Object *p) { dom(MUIM_Family_Remove,(ULONG)p); };
		void Sort(Object **p) { dom(MUIM_Family_Sort,(ULONG)p); };
		void Transfer(Object *p) { dom(MUIM_Family_Transfer,(ULONG)p); };
	};

#endif
