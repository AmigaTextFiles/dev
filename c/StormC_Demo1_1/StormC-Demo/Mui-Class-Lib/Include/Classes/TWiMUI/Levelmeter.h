//
//  $VER: Levelmeter.h  1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_LEVELMETER_H
#define CPP_TWIMUI_LEVELMETER_H

#ifndef CPP_TWIMUI_NUMERIC_H
#include <classes/twimui/numeric.h>
#endif

class MUILevelmeter : public MUINumeric
	{
	public:
		MUILevelmeter(const struct TagItem *t) : MUINumeric(MUIC_Levelmeter) { init(t); };
		MUILevelmeter(const Tag, ...);
		MUILevelmeter() : MUINumeric(MUIC_Levelmeter) { };
		MUILevelmeter(MUILevelmeter &p) : MUINumeric(p) { };
		virtual ~MUILevelmeter();
		MUILevelmeter &operator= (MUILevelmeter &);
		void Lab(const STRPTR p) { set(MUIA_Levelmeter_Label,(ULONG)p); };
		STRPTR Lab() const { return((STRPTR)get(MUIA_Levelmeter_Label,NULL)); };
	};

#endif
