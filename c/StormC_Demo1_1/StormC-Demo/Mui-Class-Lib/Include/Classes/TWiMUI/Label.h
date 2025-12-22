//
//  $VER: Label.h       1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_LABEL_H
#define CPP_TWIMUI_LABEL_H

#ifndef CPP_TWIMUI_TEXT_H
#include <classes/twimui/text.h>
#endif

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
		MUILabel(MUILabel &p) : MUIText(p) { };
		virtual ~MUILabel();
		MUILabel &operator= (MUILabel &);
	};

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
		MUILabel1(MUILabel1 &p) : MUIText(p) { };
		virtual ~MUILabel1();
		MUILabel1 &operator= (MUILabel1 &);
	};

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
		MUILabel2(MUILabel2 &p) : MUIText(p) { };
		virtual ~MUILabel2();
		MUILabel2 &operator= (MUILabel2 &);
	};

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
		MUILLabel(MUILLabel &p) : MUIText(p) { };
		virtual ~MUILLabel();
		MUILLabel &operator= (MUILLabel &);
	};

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
		MUILLabel1(MUILLabel1 &p) : MUIText(p) { };
		virtual ~MUILLabel1();
		MUILLabel1 &operator= (MUILLabel1 &);
	};

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
		MUILLabel2(MUILLabel2 &p) : MUIText(p) { };
		virtual ~MUILLabel2();
		MUILLabel2 &operator= (MUILLabel2 &);
	};

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
		MUICLabel(MUICLabel &p) : MUIText(p) { };
		virtual ~MUICLabel();
		MUICLabel &operator= (MUICLabel &);
	};

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
		MUICLabel1(MUICLabel1 &p) : MUIText(p) { };
		virtual ~MUICLabel1();
		MUICLabel1 &operator= (MUICLabel1 &);
	};

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
		MUICLabel2(MUICLabel2 &p) : MUIText(p) { };
		virtual ~MUICLabel2();
		MUICLabel2 &operator= (MUICLabel2 &);
	};

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
		MUIKeyLabel(MUIKeyLabel &p) : MUIText(p) { };
		virtual ~MUIKeyLabel();
		MUIKeyLabel &operator= (MUIKeyLabel &);
	};

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
		MUIKeyLabel1(MUIKeyLabel1 &p) : MUIText(p) { };
		virtual ~MUIKeyLabel1();
		MUIKeyLabel1 &operator= (MUIKeyLabel1 &);
	};

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
		MUIKeyLabel2(MUIKeyLabel2 &p) : MUIText(p) { };
		virtual ~MUIKeyLabel2();
		MUIKeyLabel2 &operator= (MUIKeyLabel2 &);
	};

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
		MUIKeyLLabel(MUIKeyLLabel &p) : MUIText(p) { };
		virtual ~MUIKeyLLabel();
		MUIKeyLLabel &operator= (MUIKeyLLabel &);
	};

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
		MUIKeyLLabel1(MUIKeyLLabel1 &p) : MUIText(p) { };
		virtual ~MUIKeyLLabel1();
		MUIKeyLLabel1 &operator= (MUIKeyLLabel1 &);
	};

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
		MUIKeyLLabel2(MUIKeyLLabel2 &p) : MUIText(p) { };
		virtual ~MUIKeyLLabel2();
		MUIKeyLLabel2 &operator= (MUIKeyLLabel2 &);
	};

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
		MUIKeyCLabel(MUIKeyCLabel &p) : MUIText(p) { };
		virtual ~MUIKeyCLabel();
		MUIKeyCLabel &operator= (MUIKeyCLabel &);
	};

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
		MUIKeyCLabel1(MUIKeyCLabel1 &p) : MUIText(p) { };
		virtual ~MUIKeyCLabel1();
		MUIKeyCLabel1 &operator= (MUIKeyCLabel1 &);
	};

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
		MUIKeyCLabel2(MUIKeyCLabel2 &p) : MUIText(p) { };
		virtual ~MUIKeyCLabel2();
		MUIKeyCLabel2 &operator= (MUIKeyCLabel2 &);
	};

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
		MUIFreeLabel(MUIFreeLabel &p) : MUIText(p) { };
		virtual ~MUIFreeLabel();
		MUIFreeLabel &operator= (MUIFreeLabel &);
	};

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
		MUIFreeLabel1(MUIFreeLabel1 &p) : MUIText(p) { };
		virtual ~MUIFreeLabel1();
		MUIFreeLabel1 &operator= (MUIFreeLabel1 &);
	};

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
		MUIFreeLabel2(MUIFreeLabel2 &p) : MUIText(p) { };
		virtual ~MUIFreeLabel2();
		MUIFreeLabel2 &operator= (MUIFreeLabel2 &);
	};

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
		MUIFreeLLabel(MUIFreeLLabel &p) : MUIText(p) { };
		virtual ~MUIFreeLLabel();
		MUIFreeLLabel &operator= (MUIFreeLLabel &);
	};

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
		MUIFreeLLabel1(MUIFreeLLabel1 &p) : MUIText(p) { };
		virtual ~MUIFreeLLabel1();
		MUIFreeLLabel1 &operator= (MUIFreeLLabel1 &);
	};

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
		MUIFreeLLabel2(MUIFreeLLabel2 &p) : MUIText(p) { };
		virtual ~MUIFreeLLabel2();
		MUIFreeLLabel2 &operator= (MUIFreeLLabel2 &);
	};

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
		MUIFreeCLabel(MUIFreeCLabel &p) : MUIText(p) { };
		virtual ~MUIFreeCLabel();
		MUIFreeCLabel &operator= (MUIFreeCLabel &);
	};

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
		MUIFreeCLabel1(MUIFreeCLabel1 &p) : MUIText(p) { };
		virtual ~MUIFreeCLabel1();
		MUIFreeCLabel1 &operator= (MUIFreeCLabel1 &);
	};

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
		MUIFreeCLabel2(MUIFreeCLabel2 &p) : MUIText(p) { };
		virtual ~MUIFreeCLabel2();
		MUIFreeCLabel2 &operator= (MUIFreeCLabel2 &);
	};

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
		MUIFreeKeyLabel(MUIFreeKeyLabel &p) : MUIText(p) { };
		virtual ~MUIFreeKeyLabel();
		MUIFreeKeyLabel &operator= (MUIFreeKeyLabel &);
	};

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
		MUIFreeKeyLabel1(MUIFreeKeyLabel1 &p) : MUIText(p) { };
		virtual ~MUIFreeKeyLabel1();
		MUIFreeKeyLabel1 &operator= (MUIFreeKeyLabel1 &);
	};

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
		MUIFreeKeyLabel2(MUIFreeKeyLabel2 &p) : MUIText(p) { };
		virtual ~MUIFreeKeyLabel2();
		MUIFreeKeyLabel2 &operator= (MUIFreeKeyLabel2 &);
	};

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
		MUIFreeKeyLLabel(MUIFreeKeyLLabel &p) : MUIText(p) { };
		virtual ~MUIFreeKeyLLabel();
		MUIFreeKeyLLabel &operator= (MUIFreeKeyLLabel &);
	};

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
		MUIFreeKeyLLabel1(MUIFreeKeyLLabel1 &p) : MUIText(p) { };
		virtual ~MUIFreeKeyLLabel1();
		MUIFreeKeyLLabel1 &operator= (MUIFreeKeyLLabel1 &);
	};

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
		MUIFreeKeyLLabel2(MUIFreeKeyLLabel2 &p) : MUIText(p) { };
		virtual ~MUIFreeKeyLLabel2();
		MUIFreeKeyLLabel2 &operator= (MUIFreeKeyLLabel2 &);
	};

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
		MUIFreeKeyCLabel(MUIFreeKeyCLabel &p) : MUIText(p) { };
		virtual ~MUIFreeKeyCLabel();
		MUIFreeKeyCLabel &operator= (MUIFreeKeyCLabel &);
	};

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
		MUIFreeKeyCLabel1(MUIFreeKeyCLabel1 &p) : MUIText(p) { };
		virtual ~MUIFreeKeyCLabel1();
		MUIFreeKeyCLabel1 &operator= (MUIFreeKeyCLabel1 &);
	};

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
		MUIFreeKeyCLabel2(MUIFreeKeyCLabel2 &p) : MUIText(p) { };
		virtual ~MUIFreeKeyCLabel2();
		MUIFreeKeyCLabel2 &operator= (MUIFreeKeyCLabel2 &);
	};

#endif
