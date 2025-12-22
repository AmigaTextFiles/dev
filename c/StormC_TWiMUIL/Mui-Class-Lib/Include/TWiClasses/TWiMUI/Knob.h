#ifndef TWICPP_TWIMUI_KNOB_H
#define TWICPP_TWIMUI_KNOB_H

//
//  $VER: Knob.h        2.0 (10 Feb 1997)
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

/// class MUIKnob

class MUIKnob : public MUINumeric
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIKnob(const struct TagItem *t) : MUINumeric(MUIC_Knob) { init(t); };
        MUIKnob(const Tag, ...);
        MUIKnob() : MUINumeric(MUIC_Knob) { };
        MUIKnob(const MUIKnob &);
        virtual ~MUIKnob();
        MUIKnob &operator= (const MUIKnob &);
    };

///

#endif
