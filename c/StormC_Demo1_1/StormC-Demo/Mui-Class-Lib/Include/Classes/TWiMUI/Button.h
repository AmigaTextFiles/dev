//
//  $VER: NButton.h     1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_BUTTON_H
#define CPP_TWIMUI_BUTTON_H

#ifndef CPP_TWIMUI_TEXT_H
#include <classes/twimui/text.h>
#endif

class MUIButton : public MUIText
	{
	public:
		MUIButton(const STRPTR name)
			:   MUIText(
					MUIA_Frame, MUIV_Frame_Button,
					MUIA_InputMode, MUIV_InputMode_RelVerify,
					MUIA_Background, MUII_ButtonBack,
					MUIA_Text_Contents, name,
					MUIA_Text_PreParse, MUIX_C,
					TAG_DONE)
			{ };
		MUIButton(const STRPTR name, const UBYTE cc)
			:   MUIText(
					MUIA_Frame, MUIV_Frame_Button,
					MUIA_ControlChar, cc,
					MUIA_InputMode, MUIV_InputMode_RelVerify,
					MUIA_Background, MUII_ButtonBack,
					MUIA_Text_Contents, name,
					MUIA_Text_PreParse, MUIX_C,
					MUIA_Text_HiChar, cc,
					TAG_DONE)
			{ };
		MUIButton(MUIButton &p) : MUIText(p) { };
		virtual ~MUIButton();
		MUIButton &operator= (MUIButton &);
	};

class MUILabButton
	:   public MUILabelHelp,
		public MUIButton
	{
	public:
		MUILabButton(const STRPTR lab)
			:   MUILabelHelp(lab),
				MUIButton(MUILabelHelp::gLab(),MUILabelHelp::gCC())
			{ };
		virtual ~MUILabButton();
		MUILabButton &operator= (MUILabButton &);
	};

#endif
