#ifndef TWICPP_TWIMUI_SLIDER_H
#define TWICPP_TWIMUI_SLIDER_H

//
//  $VER: Slider.h      2.0 (10 Feb 1997)
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

#ifndef TWICPP_TWIMUI_LABEL_H
#include <twiclasses/twimui/label.h>
#endif

///

/// class MUISlider

class MUISlider : public MUINumeric
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUISlider(const struct TagItem *t)
            :   MUINumeric(MUIC_Slider)
            {
            init(t);
            };
        MUISlider(const Tag, ...);
        MUISlider(const LONG min, const LONG max)
            :   MUINumeric(MUIC_Slider)
            {
            init(MUIA_Numeric_Min, min,
                MUIA_Numeric_Max, max,
                TAG_DONE);
            };
        MUISlider(const LONG min, const LONG max, const UBYTE cc)
            :   MUINumeric(MUIC_Slider)
            {
            init(MUIA_Numeric_Min, min,
                MUIA_Numeric_Max, max,
                MUIA_ControlChar, cc,
                TAG_DONE);
            };
        MUISlider() : MUINumeric(MUIC_Slider) { };
        MUISlider(const MUISlider &);
        virtual ~MUISlider();
        MUISlider &operator= (const MUISlider &);
        VOID Horiz(const BOOL p) { set(MUIA_Slider_Horiz,(ULONG)p); };
        BOOL Horiz() const { return((BOOL)get(MUIA_Slider_Horiz,FALSE)); };
    };

///
/// class MUILabSlider

class MUILabSlider
    :   public MUILabelHelp,
        public MUISlider
    {
    private:
        MUIKeyLabel2 MUILab;
    public:
        MUILabSlider(const STRPTR lab, const LONG min, const LONG max)
            :   MUILabelHelp(lab),
                MUISlider(min,max,MUILabelHelp::gCC()),
                MUILab(MUILabelHelp::gLab(),MUILabelHelp::gCC())
            { };
        MUILabSlider(const MUILabSlider &p)
            :   MUILabelHelp((MUILabelHelp &)p),
                MUISlider((MUISlider &)p),
                MUILab(p.MUILab)
            { };
        virtual ~MUILabSlider();
        MUILabSlider &operator= (const MUILabSlider &);
        Object *label() { return(MUILab); };
    };

///

#endif
