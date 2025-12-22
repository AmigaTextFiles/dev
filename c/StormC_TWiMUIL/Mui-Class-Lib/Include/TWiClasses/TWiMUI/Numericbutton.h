#ifndef TWICPP_TWIMUI_NUMERICBUTTON_H
#define TWICPP_TWIMUI_NUMERICBUTTON_H

//
//  $VER: Numericbutton.h 2.0 (10 Feb 1997)
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

/// class MUINumericbutton

class MUINumericbutton : public MUINumeric
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUINumericbutton(const struct TagItem *t) : MUINumeric(MUIC_Numericbutton) { init(t); };
        MUINumericbutton(const Tag, ...);
        MUINumericbutton(const STRPTR form, const ULONG min, const ULONG max) : MUINumeric(MUIC_Numeric)
            {
            init(MUIA_Frame, MUIV_Frame_Button,
                MUIA_Background, MUII_ButtonBack,
                MUIA_Numeric_Min, min,
                MUIA_Numeric_Max, max,
                MUIA_Numeric_Format, form,
                TAG_DONE)
            };
        MUINumericbutton(const STRPTR form, const ULONG min, const ULONG max, const UBYTE cc) : MUINumeric(MUIC_Numeric)
            {
            init(MUIA_Frame, MUIV_Frame_Button,
                MUIA_Background, MUII_ButtonBack,
                MUIA_ControlChar, cc,
                MUIA_Numeric_Min, min,
                MUIA_Numeric_Max, max,
                MUIA_Numeric_Format, form,
                TAG_DONE)
            };
        MUINumericbutton() : MUINumeric(MUIC_Numericbutton) { };
        MUINumericbutton(const MUINumericbutton &);
        virtual ~MUINumericbutton();
        MUINumericbutton &operator= (const MUINumericbutton &);
    };

///
/// class MUILabNumericbutton

class MUILabNumericbutton
    :   public MUILabelHelp,
        public MUINumericbutton
    {
    public:
        MUILabNumericbutton(const STRPTR lab, const STRPTR form, const ULONG min, const ULONG max)
            :   MUILabelHelp(lab),
                MUINumericbutton(form, min, max, MUILabelHelp::gCC())
            { };
        virtual ~MUILabNumericbutton();
        MUILabNumericbutton &operator= (const MUILabNumericbutton &);
    };

///

#endif
