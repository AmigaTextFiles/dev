#ifndef TWICPP_TWIMUI_CHECKMARK_H
#define TWICPP_TWIMUI_CHECKMARK_H

//
//  $VER: Checkmark.h   2.0 (10 Feb 1997)
//
//    c 1996 Thomas Wilhelmig
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
//  31 Aug 1996 :   1.2 : Änderungen:
//                        - Parameter des Copy-Konstruktor als 'const'-Parameter definiert
//

/// Includes

#ifndef TWICPP_TWIMUI_IMAGE_H
#include <twiclasses/twimui/image.h>
#endif

#ifndef TWICPP_TWIMUI_LABEL_H
#include <twiclasses/twimui/label.h>
#endif

///

/// class MUICheckmark

class MUICheckmark : public MUIImage
    {
    public:
        MUICheckmark(const UBYTE c)
            :   MUIImage(
                    MUIA_Image_FreeVert, TRUE,
                    MUIA_Image_Spec, MUII_CheckMark,
                    MUIA_InputMode, MUIV_InputMode_Toggle,
                    MUIA_ControlChar, c,
                    MUIA_Frame, MUIV_Frame_ImageButton,
                    MUIA_Background, MUII_ButtonBack,
                    MUIA_ShowSelState, FALSE,
                    TAG_DONE)
            { };
        MUICheckmark(const STRPTR c)
            :   MUIImage(
                    MUIA_Image_FreeVert, TRUE,
                    MUIA_Image_Spec, MUII_CheckMark,
                    MUIA_InputMode, MUIV_InputMode_Toggle,
                    MUIA_ControlChar, *c,
                    MUIA_Frame, MUIV_Frame_ImageButton,
                    MUIA_Background, MUII_ButtonBack,
                    MUIA_ShowSelState, FALSE,
                    TAG_DONE)
            { };
        MUICheckmark(const MUICheckmark &p) : MUIImage((MUIImage &)p) { };
        virtual ~MUICheckmark();
        MUICheckmark &operator= (const MUICheckmark &);
    };

///
/// class MUILabCheckmark

class MUILabCheckmark
    :   public MUILabelHelp,
        public MUICheckmark
    {
    private:
        MUIKeyLabel2 MUILab;
    public:
        MUILabCheckmark(const STRPTR lab)
            :   MUILabelHelp(lab),
                MUICheckmark(MUILabelHelp::gCC()),
                MUILab(MUILabelHelp::gLab(),MUILabelHelp::gCC())
            { };
        MUILabCheckmark(const MUILabCheckmark &p)
            :   MUILabelHelp((MUILabelHelp &)p),
                MUICheckmark((MUICheckmark &)p),
                MUILab(p.MUILab)
            { };
        virtual ~MUILabCheckmark();
        MUILabCheckmark &operator= (const MUILabCheckmark &);
        Object *label() { return(MUILab); };
    };

///

#endif
