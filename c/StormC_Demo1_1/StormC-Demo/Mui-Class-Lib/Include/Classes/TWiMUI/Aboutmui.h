//
//  $VER: Aboutmui.h    1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_ABOUTMUI_H
#define CPP_TWIMUI_ABOUTMUI_H

#ifndef CPP_TWIMUI_WINDOW_H
#include <classes/twimui/window.h>
#endif

class MUIAboutmui : public MUIWindow
	{
	public:
		MUIAboutmui(const struct TagItem *t) : MUIWindow(MUIC_Aboutmui) { init(t); };
		MUIAboutmui(const Tag, ...);
		MUIAboutmui() : MUIWindow(MUIC_Aboutmui) { };
		MUIAboutmui(MUIAboutmui &p) : MUIWindow(p) { };
		virtual ~MUIAboutmui();
		MUIAboutmui &operator= (MUIAboutmui &);
	};

#endif
