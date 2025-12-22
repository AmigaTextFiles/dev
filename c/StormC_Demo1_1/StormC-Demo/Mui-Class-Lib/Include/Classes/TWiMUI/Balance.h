//
//  $VER: Balance.h     1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_BALANCE_H
#define CPP_TWIMUI_BALANCE_H

#ifndef CPP_TWIMUI_AREA_H
#include <classes/twimui/area.h>
#endif

class MUIBalance : public MUIArea
	{
	public:
		MUIBalance(const struct TagItem *t) : MUIArea(MUIC_Balance) { init(t); };
		MUIBalance(const Tag, ...);
		MUIBalance() : MUIArea(MUIC_Balance) { };
		MUIBalance(MUIBalance &p) : MUIArea(p) { };
		virtual ~MUIBalance();
		MUIBalance &operator= (MUIBalance &);
	};

#endif
