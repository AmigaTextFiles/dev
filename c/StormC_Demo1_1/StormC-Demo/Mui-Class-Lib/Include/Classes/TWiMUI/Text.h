//
//  $VER: Text.h        1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_TEXT_H
#define CPP_TWIMUI_TEXT_H

#ifndef CPP_TWIMUI_AREA_H
#include <classes/twimui/area.h>
#endif

class MUIText : public MUIArea
	{
	public:
		MUIText(const struct TagItem *t) : MUIArea(MUIC_Text) { init(t); };
		MUIText(const Tag t, ...);
		MUIText() : MUIArea(NULL,MUIC_Text) { };
		MUIText(MUIText &p) : MUIArea(p) { };
		virtual ~MUIText();
		MUIText &operator= (MUIText &);
		void Contents(const STRPTR p) { set(MUIA_Text_Contents,(ULONG)p); };
		STRPTR Contents() const { return((STRPTR)get(MUIA_Text_Contents,NULL)); };
		void PreParse(const STRPTR p) { set(MUIA_Text_PreParse,(ULONG)p); };
		STRPTR PreParse() const { return((STRPTR)get(MUIA_Text_PreParse,NULL)); };
	};

#endif
