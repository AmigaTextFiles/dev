#ifndef TWICPP_TWIMUI_LEVELMETER_H
#define TWICPP_TWIMUI_LEVELMETER_H

//
//  $VER: Levelmeter.h  2.0 (10 Feb 1997)
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

#ifndef TWICPP_TWIMUI_NUMERIC_H
#include <twiclasses/twimui/numeric.h>
#endif

///

/// class MUILevelmeter

class MUILevelmeter : public MUINumeric
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUILevelmeter(const struct TagItem *t) : MUINumeric(MUIC_Levelmeter) { init(t); };
        MUILevelmeter(const Tag, ...);
        MUILevelmeter() : MUINumeric(MUIC_Levelmeter) { };
        MUILevelmeter(const MUILevelmeter &);
        virtual ~MUILevelmeter();
        MUILevelmeter &operator= (const MUILevelmeter &);
        VOID Lab(const STRPTR p) { set(MUIA_Levelmeter_Label,(ULONG)p); };
        STRPTR Lab() const { return((STRPTR)get(MUIA_Levelmeter_Label,NULL)); };
    };

///

#endif
