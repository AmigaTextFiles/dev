#ifndef TWICPP_TWIMUI_BUSY_H
#define TWICPP_TWIMUI_BUSY_H

//
//  $VER: Busy.h        1.0 (19 Feb 1997)
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
//  19 Feb 1997 :   1.0 : first Release
//

/// Includes

#ifndef TWICPP_TWIMUI_AREA_H
#include <twiclasses/twimui/area.h>
#endif

#ifndef  BUSY_MCC_H
#include <mui/busy_mcc.h>
#endif

///

/// class MUIBusy

class MUIBusy : public MUIArea
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIBusy(const struct TagItem *t) : MUIArea(MUIC_Busy) { init(t); };
        MUIBusy(const Tag t, ...);
        MUIBusy() : MUIArea(MUIC_Busy) { };
        MUIBusy(const MUIBusy &);
        virtual ~MUIBusy();
        MUIBusy &operator= (const MUIBusy &);
        VOID Speed(const LONG p) { set(MUIA_Busy_Speed,(ULONG)p); };
        VOID SpeedOff() { set(MUIA_Busy_Speed,(ULONG)MUIV_Busy_Speed_Off); };
        VOID SpeedUser() { set(MUIA_Busy_Speed,(ULONG)MUIV_Busy_Speed_User); };
        LONG Speed() const { return((LONG)get(MUIA_Busy_Speed,0L)); };
        VOID Move() { dom(MUIM_Busy_Move); };
    };

///

#endif

