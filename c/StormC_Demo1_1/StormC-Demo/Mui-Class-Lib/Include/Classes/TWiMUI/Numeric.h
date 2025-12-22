//
//  $VER: Numeric.h     1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_NUMERIC_H
#define CPP_TWIMUI_NUMERIC_H

#ifndef CPP_TWIMUI_AREA_H
#include <classes/twimui/area.h>
#endif

class MUINumeric : public MUIArea
	{
	protected:
		MUINumeric(STRPTR cl) : MUIArea(cl) { };
	public:
		MUINumeric(const struct TagItem *t) : MUIArea(MUIC_Numeric) { init(t); };
		MUINumeric(const Tag, ...);
		MUINumeric() : MUIArea(MUIC_Numeric) { };
		MUINumeric(MUINumeric &p) : MUIArea(p) { };
		virtual ~MUINumeric();
		MUINumeric &operator= (MUINumeric &);
		void Default(const LONG p) { set(MUIA_Numeric_Default,(ULONG)p); };
		LONG Default() const { return((LONG)get(MUIA_Numeric_Default,0L)); };
		void Format(const STRPTR p) { set(MUIA_Numeric_Format,(ULONG)p); };
		STRPTR Format() const { return((STRPTR)get(MUIA_Numeric_Format,NULL)); };
		void Max(const LONG p) { set(MUIA_Numeric_Max,(ULONG)p); };
		LONG Max() const { return((LONG)get(MUIA_Numeric_Max,0L)); };
		void Min(const LONG p) { set(MUIA_Numeric_Min,(ULONG)p); };
		LONG Min() const { return((LONG)get(MUIA_Numeric_Min,0L)); };
		void Reverse(const BOOL p) { set(MUIA_Numeric_Reverse,(ULONG)p); };
		BOOL Reverse() const { return((BOOL)get(MUIA_Numeric_Reverse,FALSE)); };
		void RevLeftRight(const BOOL p) { set(MUIA_Numeric_RevLeftRight,(ULONG)p); };
		BOOL RevLeftRight() const { return((BOOL)get(MUIA_Numeric_RevLeftRight,FALSE)); };
		void RevUpDown(const BOOL p) { set(MUIA_Numeric_RevUpDown,(ULONG)p); };
		BOOL RevUpDown() const { return((BOOL)get(MUIA_Numeric_RevUpDown,FALSE)); };
		void Value(const LONG p) { set(MUIA_Numeric_Value,(ULONG)p); };
		LONG Value() const { return((LONG)get(MUIA_Numeric_Value,0L)); };
		void Decrease(LONG p) { dom(MUIM_Numeric_Decrease,(ULONG)p); };
		void Increase(LONG p) { dom(MUIM_Numeric_Increase,(ULONG)p); };
		LONG ScaleToValue(LONG p1, LONG p2, LONG p3) { return((LONG)dom(MUIM_Numeric_ScaleToValue,(ULONG)p1,(ULONG)p2,(ULONG)p3)); };
		void SetDefault() { dom(MUIM_Numeric_SetDefault); };
		STRPTR Stringify(LONG p) { return((STRPTR)dom(MUIM_Numeric_Stringify,(ULONG)p)); };
		LONG ValueToScale(LONG p1, LONG p2) { return((LONG)dom(MUIM_Numeric_ValueToScale,(ULONG)p1,(ULONG)p2)); };
	};

#endif
