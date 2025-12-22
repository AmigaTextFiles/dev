#ifndef TWICPP_TWIMUI_NUMERIC_H
#define TWICPP_TWIMUI_NUMERIC_H

//
//  $VER: Numeric.h     2.0 (10 Feb 1997)
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
//  10 Feb 1997 :   2.0 : Änderungen:
//                        - Anpassungen an MUI 3.7
//

/// Includes

#ifndef TWICPP_TWIMUI_AREA_H
#include <twiclasses/twimui/area.h>
#endif

///

/// class MUINumeric

class MUINumeric : public MUIArea
    {
    protected:
        virtual const ULONG ClassNum() const;
        MUINumeric(STRPTR cl) : MUIArea(cl) { };
    public:
        MUINumeric(const struct TagItem *t) : MUIArea(MUIC_Numeric) { init(t); };
        MUINumeric(const Tag, ...);
        MUINumeric() : MUIArea(MUIC_Numeric) { };
        MUINumeric(const MUINumeric &);
        virtual ~MUINumeric();
        MUINumeric &operator= (const MUINumeric &);
        VOID CheckAllSizes(const BOOL p) { set(MUIA_Numeric_CheckAllSizes,(ULONG)p); };
        BOOL CheckAllSizes() const { return((BOOL)get(MUIA_Numeric_CheckAllSizes,FALSE)); };
        VOID Default(const LONG p) { set(MUIA_Numeric_Default,(ULONG)p); };
        LONG Default() const { return((LONG)get(MUIA_Numeric_Default,0L)); };
        VOID Format(const STRPTR p) { set(MUIA_Numeric_Format,(ULONG)p); };
        STRPTR Format() const { return((STRPTR)get(MUIA_Numeric_Format,NULL)); };
        VOID Max(const LONG p) { set(MUIA_Numeric_Max,(ULONG)p); };
        LONG Max() const { return((LONG)get(MUIA_Numeric_Max,0L)); };
        VOID Min(const LONG p) { set(MUIA_Numeric_Min,(ULONG)p); };
        LONG Min() const { return((LONG)get(MUIA_Numeric_Min,0L)); };
        VOID Reverse(const BOOL p) { set(MUIA_Numeric_Reverse,(ULONG)p); };
        BOOL Reverse() const { return((BOOL)get(MUIA_Numeric_Reverse,FALSE)); };
        VOID RevLeftRight(const BOOL p) { set(MUIA_Numeric_RevLeftRight,(ULONG)p); };
        BOOL RevLeftRight() const { return((BOOL)get(MUIA_Numeric_RevLeftRight,FALSE)); };
        VOID RevUpDown(const BOOL p) { set(MUIA_Numeric_RevUpDown,(ULONG)p); };
        BOOL RevUpDown() const { return((BOOL)get(MUIA_Numeric_RevUpDown,FALSE)); };
        VOID Value(const LONG p) { set(MUIA_Numeric_Value,(ULONG)p); };
        LONG Value() const { return((LONG)get(MUIA_Numeric_Value,0L)); };
        VOID Decrease(LONG p) { dom(MUIM_Numeric_Decrease,(ULONG)p); };
        VOID Increase(LONG p) { dom(MUIM_Numeric_Increase,(ULONG)p); };
        LONG ScaleToValue(LONG p1, LONG p2, LONG p3) { return((LONG)dom(MUIM_Numeric_ScaleToValue,(ULONG)p1,(ULONG)p2,(ULONG)p3)); };
        VOID SetDefault() { dom(MUIM_Numeric_SetDefault); };
        STRPTR Stringify(LONG p) { return((STRPTR)dom(MUIM_Numeric_Stringify,(ULONG)p)); };
        LONG ValueToScale(LONG p1, LONG p2) { return((LONG)dom(MUIM_Numeric_ValueToScale,(ULONG)p1,(ULONG)p2)); };
    };

///

#endif
