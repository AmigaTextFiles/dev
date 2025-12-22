//
//  $VER: Scrollgroup.h 1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_SCROLLGROUP_H
#define CPP_TWIMUI_SCROLLGROUP_H

#ifndef CPP_TWIMUI_GROUP_H
#include <classes/twimui/group.h>
#endif

class MUIScrollgroup : public MUIGroup
	{
	public:
		MUIScrollgroup(const struct TagItem *t) : MUIGroup(MUIC_Scrollgroup) { init(t); };
		MUIScrollgroup(const Tag, ...);
		MUIScrollgroup() : MUIGroup(MUIC_Scrollgroup) { };
		MUIScrollgroup(MUIScrollgroup &p) : MUIGroup(p) { };
		virtual ~MUIScrollgroup();
		MUIScrollgroup &operator= (MUIScrollgroup &);
	};

#endif
