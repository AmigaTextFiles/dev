//
//  $VER: Popbutton.h   1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_POPBUTTON_H
#define CPP_TWIMUI_POPBUTTON_H

#ifndef CPP_TWIMUI_IMAGE_H
#include <classes/twimui/image.h>
#endif

class MUIPopbutton : public MUIImage
	{
	public:
		MUIPopbutton(const ULONG img)
			:   MUIImage(
					MUIA_Image_FreeVert, TRUE,
					MUIA_Image_FontMatchWidth, TRUE,
					MUIA_Image_Spec, img,
					MUIA_InputMode, MUIV_InputMode_RelVerify,
					MUIA_Frame, MUIV_Frame_ImageButton,
					MUIA_Background, MUII_BACKGROUND,
					TAG_DONE)
			{ };
		MUIPopbutton(MUIPopbutton &p) : MUIImage(p) { };
		virtual ~MUIPopbutton();
		MUIPopbutton &operator= (MUIPopbutton &);
	};

#endif
