//
//  $VER: Scrollbar.h   1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_SCROLLBAR_H
#define CPP_TWIMUI_SCROLLBAR_H

#ifndef CPP_TWIMUI_GROUP_H
#include <classes/twimui/group.h>
#endif

class MUIScrollbar : public MUIGroup
	{
	public:
		MUIScrollbar(const struct TagItem *t) : MUIGroup(MUIC_Scrollbar) { init(t); };
		MUIScrollbar(const Tag, ...);
		MUIScrollbar() : MUIGroup(MUIC_Scrollbar) { };
		MUIScrollbar(MUIScrollbar &p) : MUIGroup(p) { };
		virtual ~MUIScrollbar();
		MUIScrollbar &operator= (MUIScrollbar &);
	};

#endif
