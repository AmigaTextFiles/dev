//
//  $VER: Volumelist.h  1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_VOLUMELIST_H
#define CPP_TWIMUI_VOLUMELIST_H

#ifndef CPP_TWIMUI_LIST_H
#include <classes/twimui/list.h>
#endif

class MUIVolumelist : public MUIList
	{
	public:
		MUIVolumelist(const struct TagItem *t) : MUIList(MUIC_Volumelist) { init(t); };
		MUIVolumelist(const Tag, ...);
		MUIVolumelist() : MUIList(MUIC_Volumelist) { };
		MUIVolumelist(MUIVolumelist &p) : MUIList(p) { };
		virtual ~MUIVolumelist();
		MUIVolumelist &operator= (MUIVolumelist &);
	};

#endif
