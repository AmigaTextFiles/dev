//
//  $VER: Gauge.h       1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_GAUGE_H
#define CPP_TWIMUI_GAUGE_H

#ifndef CPP_TWIMUI_AREA_H
#include <classes/twimui/area.h>
#endif

class MUIGauge : public MUIArea
	{
	protected:
		MUIGauge(STRPTR cl) : MUIArea(cl) { };
	public:
		MUIGauge(const struct TagItem *t) : MUIArea(MUIC_Gauge) { init(t); };
		MUIGauge(const Tag, ...);
		MUIGauge() : MUIArea(MUIC_Gauge) { };
		MUIGauge(MUIGauge &p) : MUIArea(p) { };
		virtual ~MUIGauge();
		MUIGauge &operator= (MUIGauge &);
		void Current(const LONG p) { set(MUIA_Gauge_Current,(ULONG)p); };
		LONG Current() const { return((LONG)get(MUIA_Gauge_Current,0L)); };
		void Divide(const LONG p) { set(MUIA_Gauge_Divide,(ULONG)p); };
		LONG Divide() const { return((LONG)get(MUIA_Gauge_Divide,0L)); };
		void InfoText(const STRPTR p) { set(MUIA_Gauge_InfoText,(ULONG)p); };
		STRPTR InfoText() const { return((STRPTR)get(MUIA_Gauge_InfoText,NULL)); };
		void Max(const LONG p) { set(MUIA_Gauge_Max,(ULONG)p); };
		LONG Max() const { return((LONG)get(MUIA_Gauge_Max,0L)); };
	};

#endif
