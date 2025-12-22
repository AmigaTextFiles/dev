//
//  $VER: Image.h       1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_IMAGE_H
#define CPP_TWIMUI_IMAGE_H

#ifndef CPP_TWIMUI_AREA_H
#include <classes/twimui/area.h>
#endif

class MUIImage : public MUIArea
	{
	public:
		MUIImage(const struct TagItem *t) : MUIArea(MUIC_Image) { init(t); };
		MUIImage(const Tag, ...);
		MUIImage() : MUIArea(MUIC_Image) { };
		MUIImage(MUIImage &p) : MUIArea(p) { };
		virtual ~MUIImage();
		MUIImage &operator= (MUIImage &);
		void State(const LONG p) { set(MUIA_Image_State,(ULONG)p); };
	};

#endif
