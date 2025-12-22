//
//  $VER: Checkmark.h   1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_CHECKMARK_H
#define CPP_TWIMUI_CHECKMARK_H

#ifndef CPP_TWIMUI_IMAGE_H
#include <classes/twimui/image.h>
#endif

#ifndef CPP_TWIMUI_LABEL_H
#include <classes/twimui/label.h>
#endif

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
		MUICheckmark(MUICheckmark &p) : MUIImage(p) { };
		virtual ~MUICheckmark();
		MUICheckmark &operator= (MUICheckmark &);
	};

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
		virtual ~MUILabCheckmark();
		MUILabCheckmark &operator= (MUILabCheckmark &);
		Object *label() { return(MUILab); };
	};

#endif
