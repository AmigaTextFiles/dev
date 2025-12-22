//
//  $VER: Poplist.h     1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_POPLIST_H
#define CPP_TWIMUI_POPLIST_H

#ifndef CPP_TWIMUI_POPOBJECT_H
#include <classes/twimui/popobject.h>
#endif

class MUIPoplist : public MUIPopobject
	{
	public:
		MUIPoplist(const struct TagItem *t) : MUIPopobject(MUIC_Poplist) { init(t); };
		MUIPoplist(const Tag, ...);
		MUIPoplist() : MUIPopobject(MUIC_Poplist) { };
		MUIPoplist(MUIPoplist &p) : MUIPopobject(p) { };
		virtual ~MUIPoplist();
		MUIPoplist &operator= (MUIPoplist &);
	};

#endif
