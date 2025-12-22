//
//  $VER: Knob.h        1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_KNOB_H
#define CPP_TWIMUI_KNOB_H

#ifndef CPP_TWIMUI_NUMERIC_H
#include <classes/twimui/numeric.h>
#endif

class MUIKnob : public MUINumeric
	{
	public:
		MUIKnob(const struct TagItem *t) : MUINumeric(MUIC_Knob) { init(t); };
		MUIKnob(const Tag, ...);
		MUIKnob() : MUINumeric(MUIC_Knob) { };
		MUIKnob(MUIKnob &p) : MUINumeric(p) { };
		virtual ~MUIKnob();
		MUIKnob &operator= (MUIKnob &);
	};

#endif
