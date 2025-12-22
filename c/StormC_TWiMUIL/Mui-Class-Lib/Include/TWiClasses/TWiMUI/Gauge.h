#ifndef TWICPP_TWIMUI_GAUGE_H
#define TWICPP_TWIMUI_GAUGE_H

//
//  $VER: Gauge.h       2.0 (10 Feb 1997)
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
//  02 Sep 1996 :   1.2 : Neu:
//                        - ClassNum() für Exception-Handling.
//                        Änderungen:
//                        - Parameter des Copy-Konstruktor als 'const'-Parameter definiert
//

/// Includes

#ifndef TWICPP_TWIMUI_AREA_H
#include <twiclasses/twimui/area.h>
#endif

///

/// class MUIGauge

class MUIGauge : public MUIArea
    {
    protected:
        virtual const ULONG ClassNum() const;
        MUIGauge(STRPTR cl) : MUIArea(cl) { };
    public:
        MUIGauge(const struct TagItem *t) : MUIArea(MUIC_Gauge) { init(t); };
        MUIGauge(const Tag, ...);
        MUIGauge() : MUIArea(MUIC_Gauge) { };
        MUIGauge(const MUIGauge &);
        virtual ~MUIGauge();
        MUIGauge &operator= (const MUIGauge &);
        VOID Current(const LONG p) { set(MUIA_Gauge_Current,(ULONG)p); };
        LONG Current() const { return((LONG)get(MUIA_Gauge_Current,0L)); };
        VOID Divide(const LONG p) { set(MUIA_Gauge_Divide,(ULONG)p); };
        LONG Divide() const { return((LONG)get(MUIA_Gauge_Divide,0L)); };
        VOID InfoText(const STRPTR p) { set(MUIA_Gauge_InfoText,(ULONG)p); };
        STRPTR InfoText() const { return((STRPTR)get(MUIA_Gauge_InfoText,NULL)); };
        VOID Max(const LONG p) { set(MUIA_Gauge_Max,(ULONG)p); };
        LONG Max() const { return((LONG)get(MUIA_Gauge_Max,0L)); };
    };

///

#endif
