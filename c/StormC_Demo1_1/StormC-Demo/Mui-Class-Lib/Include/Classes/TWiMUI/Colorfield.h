//
//  $VER: Colorfield.h  1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_COLORFIELD_H
#define CPP_TWIMUI_COLORFIELD_H

#ifndef CPP_TWIMUI_AREA_H
#include <classes/twimui/area.h>
#endif

class MUIColorfield : public MUIArea
	{
	public:
		MUIColorfield(const struct TagItem *t) : MUIArea(MUIC_Colorfield) { init(t); };
		MUIColorfield(const Tag, ...);
		MUIColorfield() : MUIArea(MUIC_Colorfield) { };
		MUIColorfield(MUIColorfield &p) : MUIArea(p) { };
		virtual ~MUIColorfield();
		MUIColorfield &operator= (MUIColorfield &);
		void Blue(const ULONG p) { set(MUIA_Colorfield_Blue,p); };
		ULONG Blue() const { return(get(MUIA_Colorfield_Blue,0UL)); };
		void Green(const ULONG p) { set(MUIA_Colorfield_Green,p); };
		ULONG Green() const { return(get(MUIA_Colorfield_Green,0UL)); };
		ULONG Pen() const { return(get(MUIA_Colorfield_Pen,0UL)); };
		void Red(const ULONG p) { set(MUIA_Colorfield_Red,p); };
		ULONG Red() const { return(get(MUIA_Colorfield_Red,0UL)); };
		void RGB(const ULONG *p) { set(MUIA_Colorfield_RGB,(ULONG)p); };
		ULONG *RGB() const { return((ULONG *)get(MUIA_Colorfield_RGB,NULL)); };
	};

#endif
