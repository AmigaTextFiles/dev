//
//  $VER: Virtgroup.h   1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_VIRTGROUP_H
#define CPP_TWIMUI_VIRTGROUP_H

#ifndef CPP_TWIMUI_GROUP_H
#include <classes/twimui/group.h>
#endif

class MUIVirtgroup : public MUIGroup
	{
	public:
		MUIVirtgroup(const struct TagItem *t) : MUIGroup(MUIC_Virtgroup) { init(t); };
		MUIVirtgroup(const Tag, ...);
		MUIVirtgroup() : MUIGroup(MUIC_Virtgroup) { };
		MUIVirtgroup(MUIVirtgroup &p) : MUIGroup(p) { };
		virtual ~MUIVirtgroup();
		MUIVirtgroup &operator= (MUIVirtgroup &);
		LONG Height() const { return((LONG)get(MUIA_Virtgroup_Height,0L)); };
		void Left(const LONG p) { set(MUIA_Virtgroup_Left,(ULONG)p); };
		LONG Left() const { return((LONG)get(MUIA_Virtgroup_Left,0L)); };
		void Top(const LONG p) { set(MUIA_Virtgroup_Top,(ULONG)p); };
		LONG Top() const { return((LONG)get(MUIA_Virtgroup_Top,0L)); };
		LONG Width() const { return((LONG)get(MUIA_Virtgroup_Width,0L)); };
	};

#endif
