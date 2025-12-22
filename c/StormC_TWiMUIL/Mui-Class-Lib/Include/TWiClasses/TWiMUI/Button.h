#ifndef TWICPP_TWIMUI_BUTTON_H
#define TWICPP_TWIMUI_BUTTON_H

//
//  $VER: Button.h      2.0 (10 Feb 1997)
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
//  31 Aug 1996 :   1.2 : Änderungen:
//                        - Parameter des Copy-Konstruktor als 'const'-Parameter definiert
//
//  10 Feb 1997 :   2.0 : Änderungen:
//                        - Anpassungen an MUI 3.7
//

/// Includes

#ifndef TWICPP_TWIMUI_TEXT_H
#include <twiclasses/twimui/text.h>
#endif

///

/// class MUIButton

class MUIButton : public MUIText
    {
    public:
        MUIButton(const STRPTR name)
            :   MUIText(
                    MUIA_Font, MUIV_Font_Button,
                    MUIA_Frame, MUIV_Frame_Button,
                    MUIA_InputMode, MUIV_InputMode_RelVerify,
                    MUIA_Background, MUII_ButtonBack,
                    MUIA_Text_Contents, name,
                    MUIA_Text_PreParse, MUIX_C,
                    TAG_DONE)
            { };
        MUIButton(const STRPTR name, const UBYTE cc)
            :   MUIText(
                    MUIA_Font, MUIV_Font_Button,
                    MUIA_Frame, MUIV_Frame_Button,
                    MUIA_ControlChar, cc,
                    MUIA_InputMode, MUIV_InputMode_RelVerify,
                    MUIA_Background, MUII_ButtonBack,
                    MUIA_Text_Contents, name,
                    MUIA_Text_PreParse, MUIX_C,
                    MUIA_Text_HiChar, cc,
                    TAG_DONE)
            { };
        MUIButton(const MUIButton &p) : MUIText((MUIText &)p) { };
        virtual ~MUIButton();
        MUIButton &operator= (const MUIButton &);
    };

///
/// class MUILabButton

class MUILabButton
    :   public MUILabelHelp,
        public MUIButton
    {
    public:
        MUILabButton(const STRPTR lab)
            :   MUILabelHelp(lab),
                MUIButton(MUILabelHelp::gLab(),MUILabelHelp::gCC())
            { };
        MUILabButton(const MUILabButton &p)
            :   MUILabelHelp((MUILabelHelp &)p),
                MUIButton((MUIButton &)p)
            { };
        virtual ~MUILabButton();
        MUILabButton &operator= (const MUILabButton &);
    };

///

#endif
