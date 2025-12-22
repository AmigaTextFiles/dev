//
//  $VER: Scale.h       1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_SCALE_H
#define CPP_TWIMUI_SCALE_H

#ifndef CPP_TWIMUI_AREA_H
#include <classes/twimui/area.h>
#endif

class MUIScale : public MUIArea
	{
	public:
		MUIScale(const struct TagItem *t) : MUIArea(MUIC_Scale) { init(t); };
		MUIScale(const Tag, ...);
		MUIScale() : MUIArea(MUIC_Scale) { };
		MUIScale(MUIScale &p) : MUIArea(p) { };
		virtual ~MUIScale();
		MUIScale &operator= (MUIScale &);
		void Horiz(const BOOL p) { set(MUIA_Scale_Horiz,(ULONG)p); };
		BOOL Horiz() const { return((BOOL)get(MUIA_Scale_Horiz,FALSE)); };
	};

#endif
