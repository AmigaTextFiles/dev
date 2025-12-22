//
//  $VER: Poppen.h      1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_POPPEN_H
#define CPP_TWIMUI_POPPEN_H

#ifndef CPP_TWIMUI_PENDISPLAY_H
#include <classes/twimui/pendisplay.h>
#endif

class MUIPoppen : public MUIPendisplay
	{
	public:
		MUIPoppen(const struct TagItem *t) : MUIPendisplay(MUIC_Poppen) { init(t); };
		MUIPoppen(const Tag, ...);
		MUIPoppen() : MUIPendisplay(MUIC_Poppen) { };
		MUIPoppen(MUIPoppen &p) : MUIPendisplay(p) { };
		virtual ~MUIPoppen();
		MUIPoppen &operator= (MUIPoppen &);
	};

#endif
