#ifndef TWICPP_TWIMUI_LABEL_H
#define TWICPP_TWIMUI_LABEL_H

//
//  $VER: Label.h       2.0 (10 feb 1997)
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

/// Includes

#ifndef TWICPP_TWIMUI_TEXT_H
#include <twiclasses/twimui/text.h>
#endif

///

/// class MUILabel

class MUILabel : public MUIText
    {
    public:
        MUILabel(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_PreParse, MUIX_R,
                    TAG_DONE)
            { };
        MUILabel(const MUILabel &p) : MUIText((MUIText &)p) { };
        virtual ~MUILabel();
        MUILabel &operator= (const MUILabel &);
    };

///
/// class MUILabel1

class MUILabel1 : public MUIText
    {
    public:
        MUILabel1(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Frame, MUIV_Frame_Button,
                    MUIA_Text_PreParse, MUIX_R,
                    TAG_DONE)
            { };
        MUILabel1(const MUILabel1 &p) : MUIText((MUIText &)p) { };
        virtual ~MUILabel1();
        MUILabel1 &operator= (const MUILabel1 &);
    };

///
/// class MUILabel2

class MUILabel2 : public MUIText
    {
    public:
        MUILabel2(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Frame, MUIV_Frame_String,
                    MUIA_Text_PreParse, MUIX_R,
                    TAG_DONE)
            { };
        MUILabel2(const MUILabel2 &p) : MUIText((MUIText &)p) { };
        virtual ~MUILabel2();
        MUILabel2 &operator= (const MUILabel2 &);
    };

///
/// class MUILLabel

class MUILLabel : public MUIText
    {
    public:
        MUILLabel(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    TAG_DONE)
            { };
        MUILLabel(const MUILLabel &p) : MUIText((MUIText &)p) { };
        virtual ~MUILLabel();
        MUILLabel &operator= (const MUILLabel &);
    };

///
/// class MUILLabel1

class MUILLabel1 : public MUIText
    {
    public:
        MUILLabel1(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Frame, MUIV_Frame_Button,
                    TAG_DONE)
            { };
        MUILLabel1(const MUILLabel1 &p) : MUIText((MUIText &)p) { };
        virtual ~MUILLabel1();
        MUILLabel1 &operator= (const MUILLabel1 &);
    };

///
/// class MUILLabel2

class MUILLabel2 : public MUIText
    {
    public:
        MUILLabel2(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Frame, MUIV_Frame_String,
                    TAG_DONE)
            { };
        MUILLabel2(const MUILLabel2 &p) : MUIText((MUIText &)p) { };
        virtual ~MUILLabel2();
        MUILLabel2 &operator= (const MUILLabel2 &);
    };

///
/// class MUICLabel

class MUICLabel : public MUIText
    {
    public:
        MUICLabel(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_PreParse, MUIX_C,
                    TAG_DONE)
            { };
        MUICLabel(const MUICLabel &p) : MUIText((MUIText &)p) { };
        virtual ~MUICLabel();
        MUICLabel &operator= (const MUICLabel &);
    };

///
/// class MUICLabel1

class MUICLabel1 : public MUIText
    {
    public:
        MUICLabel1(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_PreParse, MUIX_C,
                    MUIA_Frame, MUIV_Frame_Button,
                    TAG_DONE)
            { };
        MUICLabel1(const MUICLabel1 &p) : MUIText((MUIText &)p) { };
        virtual ~MUICLabel1();
        MUICLabel1 &operator= (const MUICLabel1 &);
    };

///
/// class MUICLabel2

class MUICLabel2 : public MUIText
    {
    public:
        MUICLabel2(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_PreParse, MUIX_C,
                    MUIA_Frame, MUIV_Frame_String,
                    TAG_DONE)
            { };
        MUICLabel2(const MUICLabel2 &p) : MUIText((MUIText &)p) { };
        virtual ~MUICLabel2();
        MUICLabel2 &operator= (const MUICLabel2 &);
    };

///
/// class MUIKeyLabel

class MUIKeyLabel : public MUIText
    {
    public:
        MUIKeyLabel(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_HiChar, hichar,
                    MUIA_Text_PreParse, MUIX_R,
                    TAG_DONE)
            { };
        MUIKeyLabel(const MUIKeyLabel &p) : MUIText((MUIText &)p) { };
        virtual ~MUIKeyLabel();
        MUIKeyLabel &operator= (const MUIKeyLabel &);
    };

///
/// class MUIKeyLabel1

class MUIKeyLabel1 : public MUIText
    {
    public:
        MUIKeyLabel1(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_HiChar, hichar,
                    MUIA_Frame, MUIV_Frame_Button,
                    MUIA_Text_PreParse, MUIX_R,
                    TAG_DONE)
            { };
        MUIKeyLabel1(const MUIKeyLabel1 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIKeyLabel1();
        MUIKeyLabel1 &operator= (const MUIKeyLabel1 &);
    };

///
/// class MUIKeyLabel2

class MUIKeyLabel2 : public MUIText
    {
    public:
        MUIKeyLabel2(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_HiChar, hichar,
                    MUIA_Frame, MUIV_Frame_String,
                    MUIA_Text_PreParse, MUIX_R,
                    TAG_DONE)
            { };
        MUIKeyLabel2(const MUIKeyLabel2 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIKeyLabel2();
        MUIKeyLabel2 &operator= (const MUIKeyLabel2 &);
    };

///
/// class MUIKeyLLabel

class MUIKeyLLabel : public MUIText
    {
    public:
        MUIKeyLLabel(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_HiChar, hichar,
                    TAG_DONE)
            { };
        MUIKeyLLabel(const MUIKeyLLabel &p) : MUIText((MUIText &)p) { };
        virtual ~MUIKeyLLabel();
        MUIKeyLLabel &operator= (const MUIKeyLLabel &);
    };

///
/// class MUIKeyLLabel1

class MUIKeyLLabel1 : public MUIText
    {
    public:
        MUIKeyLLabel1(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_HiChar, hichar,
                    MUIA_Frame, MUIV_Frame_Button,
                    TAG_DONE)
            { };
        MUIKeyLLabel1(const MUIKeyLLabel1 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIKeyLLabel1();
        MUIKeyLLabel1 &operator= (const MUIKeyLLabel1 &);
    };

///
/// class MUIKeyLLabel2

class MUIKeyLLabel2 : public MUIText
    {
    public:
        MUIKeyLLabel2(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_HiChar, hichar,
                    MUIA_Frame, MUIV_Frame_String,
                    TAG_DONE)
            { };
        MUIKeyLLabel2(const MUIKeyLLabel2 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIKeyLLabel2();
        MUIKeyLLabel2 &operator= (const MUIKeyLLabel2 &);
    };

///
/// class MUIKeyCLabel

class MUIKeyCLabel : public MUIText
    {
    public:
        MUIKeyCLabel(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_HiChar, hichar,
                    MUIA_Text_PreParse, MUIX_C,
                    TAG_DONE)
            { };
        MUIKeyCLabel(const MUIKeyCLabel &p) : MUIText((MUIText &)p) { };
        virtual ~MUIKeyCLabel();
        MUIKeyCLabel &operator= (const MUIKeyCLabel &);
    };

///
/// class MUIKeyCLabel1

class MUIKeyCLabel1 : public MUIText
    {
    public:
        MUIKeyCLabel1(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_HiChar, hichar,
                    MUIA_Text_PreParse, MUIX_C,
                    MUIA_Frame, MUIV_Frame_Button,
                    TAG_DONE)
            { };
        MUIKeyCLabel1(const MUIKeyCLabel1 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIKeyCLabel1();
        MUIKeyCLabel1 &operator= (const MUIKeyCLabel1 &);
    };

///
/// class MUIKeyCLabel2

class MUIKeyCLabel2 : public MUIText
    {
    public:
        MUIKeyCLabel2(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_HiChar, hichar,
                    MUIA_Text_PreParse, MUIX_C,
                    MUIA_Frame, MUIV_Frame_String,
                    TAG_DONE)
            { };
        MUIKeyCLabel2(const MUIKeyCLabel2 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIKeyCLabel2();
        MUIKeyCLabel2 &operator= (const MUIKeyCLabel2 &);
    };

///
/// class MUIFreeLabel

class MUIFreeLabel : public MUIText
    {
    public:
        MUIFreeLabel(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    MUIA_Text_PreParse, MUIX_R,
                    TAG_DONE)
            { };
        MUIFreeLabel(const MUIFreeLabel &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeLabel();
        MUIFreeLabel &operator= (const MUIFreeLabel &);
    };

///
/// class MUIFreeLabel1

class MUIFreeLabel1 : public MUIText
    {
    public:
        MUIFreeLabel1(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    MUIA_Frame, MUIV_Frame_Button,
                    MUIA_Text_PreParse, MUIX_R,
                    TAG_DONE)
            { };
        MUIFreeLabel1(const MUIFreeLabel1 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeLabel1();
        MUIFreeLabel1 &operator= (const MUIFreeLabel1 &);
    };

///
/// class MUIFreeLabel2

class MUIFreeLabel2 : public MUIText
    {
    public:
        MUIFreeLabel2(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    MUIA_Frame, MUIV_Frame_String,
                    MUIA_Text_PreParse, MUIX_R,
                    TAG_DONE)
            { };
        MUIFreeLabel2(const MUIFreeLabel2 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeLabel2();
        MUIFreeLabel2 &operator= (const MUIFreeLabel2 &);
    };

///
/// class MUIFreeLLabel

class MUIFreeLLabel : public MUIText
    {
    public:
        MUIFreeLLabel(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    TAG_DONE)
            { };
        MUIFreeLLabel(const MUIFreeLLabel &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeLLabel();
        MUIFreeLLabel &operator= (const MUIFreeLLabel &);
    };

///
/// class MUIFreeLLabel1

class MUIFreeLLabel1 : public MUIText
    {
    public:
        MUIFreeLLabel1(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    MUIA_Frame, MUIV_Frame_Button,
                    TAG_DONE)
            { };
        MUIFreeLLabel1(const MUIFreeLLabel1 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeLLabel1();
        MUIFreeLLabel1 &operator= (const MUIFreeLLabel1 &);
    };

///
/// class MUIFreeLLabel2

class MUIFreeLLabel2 : public MUIText
    {
    public:
        MUIFreeLLabel2(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    MUIA_Frame, MUIV_Frame_String,
                    TAG_DONE)
            { };
        MUIFreeLLabel2(const MUIFreeLLabel2 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeLLabel2();
        MUIFreeLLabel2 &operator= (const MUIFreeLLabel2 &);
    };

///
/// class MUIFreeCLabel

class MUIFreeCLabel : public MUIText
    {
    public:
        MUIFreeCLabel(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    MUIA_Text_PreParse, MUIX_C,
                    TAG_DONE)
            { };
        MUIFreeCLabel(const MUIFreeCLabel &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeCLabel();
        MUIFreeCLabel &operator= (const MUIFreeCLabel &);
    };

///
/// class MUIFreeCLabel1

class MUIFreeCLabel1 : public MUIText
    {
    public:
        MUIFreeCLabel1(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    MUIA_Text_PreParse, MUIX_C,
                    MUIA_Frame, MUIV_Frame_Button,
                    TAG_DONE)
            { };
        MUIFreeCLabel1(const MUIFreeCLabel1 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeCLabel1();
        MUIFreeCLabel1 &operator= (const MUIFreeCLabel1 &);
    };

///
/// class MUIFreeCLabel2

class MUIFreeCLabel2 : public MUIText
    {
    public:
        MUIFreeCLabel2(const STRPTR lab)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    MUIA_Text_PreParse, MUIX_C,
                    MUIA_Frame, MUIV_Frame_String,
                    TAG_DONE)
            { };
        MUIFreeCLabel2(const MUIFreeCLabel2 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeCLabel2();
        MUIFreeCLabel2 &operator= (const MUIFreeCLabel2 &);
    };

///
/// class MUIFreeKeyLabel

class MUIFreeKeyLabel : public MUIText
    {
    public:
        MUIFreeKeyLabel(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    MUIA_Text_HiChar, hichar,
                    MUIA_Text_PreParse, MUIX_R,
                    TAG_DONE)
            { };
        MUIFreeKeyLabel(const MUIFreeKeyLabel &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeKeyLabel();
        MUIFreeKeyLabel &operator= (const MUIFreeKeyLabel &);
    };

///
/// class MUIFreeKeyLabel1

class MUIFreeKeyLabel1 : public MUIText
    {
    public:
        MUIFreeKeyLabel1(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    MUIA_Text_HiChar, hichar,
                    MUIA_Frame, MUIV_Frame_Button,
                    MUIA_Text_PreParse, MUIX_R,
                    TAG_DONE)
            { };
        MUIFreeKeyLabel1(const MUIFreeKeyLabel1 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeKeyLabel1();
        MUIFreeKeyLabel1 &operator= (const MUIFreeKeyLabel1 &);
    };

///
/// class MUIFreeKeyLabel2

class MUIFreeKeyLabel2 : public MUIText
    {
    public:
        MUIFreeKeyLabel2(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    MUIA_Text_HiChar, hichar,
                    MUIA_Frame, MUIV_Frame_String,
                    MUIA_Text_PreParse, MUIX_R,
                    TAG_DONE)
            { };
        MUIFreeKeyLabel2(const MUIFreeKeyLabel2 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeKeyLabel2();
        MUIFreeKeyLabel2 &operator= (const MUIFreeKeyLabel2 &);
    };

///
/// class MUIFreeKeyLLabel

class MUIFreeKeyLLabel : public MUIText
    {
    public:
        MUIFreeKeyLLabel(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    MUIA_Text_HiChar, hichar,
                    TAG_DONE)
            { };
        MUIFreeKeyLLabel(const MUIFreeKeyLLabel &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeKeyLLabel();
        MUIFreeKeyLLabel &operator= (const MUIFreeKeyLLabel &);
    };

///
/// class MUIFreeKeyLLabel1

class MUIFreeKeyLLabel1 : public MUIText
    {
    public:
        MUIFreeKeyLLabel1(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    MUIA_Text_HiChar, hichar,
                    MUIA_Frame, MUIV_Frame_Button,
                    TAG_DONE)
            { };
        MUIFreeKeyLLabel1(const MUIFreeKeyLLabel1 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeKeyLLabel1();
        MUIFreeKeyLLabel1 &operator= (const MUIFreeKeyLLabel1 &);
    };

///
/// class MUIFreeKeyLLabel2

class MUIFreeKeyLLabel2 : public MUIText
    {
    public:
        MUIFreeKeyLLabel2(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    MUIA_Text_HiChar, hichar,
                    MUIA_Frame, MUIV_Frame_String,
                    TAG_DONE)
            { };
        MUIFreeKeyLLabel2(const MUIFreeKeyLLabel2 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeKeyLLabel2();
        MUIFreeKeyLLabel2 &operator= (const MUIFreeKeyLLabel2 &);
    };

///
/// class MUIFreeKeyCLabel

class MUIFreeKeyCLabel : public MUIText
    {
    public:
        MUIFreeKeyCLabel(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    MUIA_Text_HiChar, hichar,
                    MUIA_Text_PreParse, MUIX_C,
                    TAG_DONE)
            { };
        MUIFreeKeyCLabel(const MUIFreeKeyCLabel &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeKeyCLabel();
        MUIFreeKeyCLabel &operator= (const MUIFreeKeyCLabel &);
    };

///
/// class MUIFreeKeyCLabel1

class MUIFreeKeyCLabel1 : public MUIText
    {
    public:
        MUIFreeKeyCLabel1(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    MUIA_Text_HiChar, hichar,
                    MUIA_Text_PreParse, MUIX_C,
                    MUIA_Frame, MUIV_Frame_Button,
                    TAG_DONE)
            { };
        MUIFreeKeyCLabel1(const MUIFreeKeyCLabel1 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeKeyCLabel1();
        MUIFreeKeyCLabel1 &operator= (const MUIFreeKeyCLabel1 &);
    };

///
/// class MUIFreeKeyCLabel2

class MUIFreeKeyCLabel2 : public MUIText
    {
    public:
        MUIFreeKeyCLabel2(const STRPTR lab, const UBYTE hichar)
            :   MUIText(
                    MUIA_Text_Contents, lab,
                    MUIA_Weight, 0,
                    MUIA_InnerLeft, 0,
                    MUIA_InnerRight, 0,
                    MUIA_FramePhantomHoriz, TRUE,
                    MUIA_Text_SetVMax, FALSE,
                    MUIA_Text_HiChar, hichar,
                    MUIA_Text_PreParse, MUIX_C,
                    MUIA_Frame, MUIV_Frame_String,
                    TAG_DONE)
            { };
        MUIFreeKeyCLabel2(const MUIFreeKeyCLabel2 &p) : MUIText((MUIText &)p) { };
        virtual ~MUIFreeKeyCLabel2();
        MUIFreeKeyCLabel2 &operator= (const MUIFreeKeyCLabel2 &);
    };

///

#endif
