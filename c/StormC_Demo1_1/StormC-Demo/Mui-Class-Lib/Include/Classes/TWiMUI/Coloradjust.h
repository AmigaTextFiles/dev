//
//  $VER: Coloradjust.h 1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_COLORADJUST_H
#define CPP_TWIMUI_COLORADJUST_H

#ifndef CPP_TWIMUI_GROUP_H
#include <classes/twimui/group.h>
#endif

class MUIColoradjust : public MUIGroup
	{
	public:
		MUIColoradjust(const struct TagItem *t) : MUIGroup(MUIC_Coloradjust) { init(t); };
		MUIColoradjust(const Tag, ...);
		MUIColoradjust() : MUIGroup(MUIC_Coloradjust) { };
		MUIColoradjust(MUIColoradjust &p) : MUIGroup(p) { };
		virtual ~MUIColoradjust();
		MUIColoradjust &operator= (MUIColoradjust &);
		void Blue(const ULONG p) { set(MUIA_Coloradjust_Blue,p); };
		ULONG Blue() const { return(get(MUIA_Coloradjust_Blue,0UL)); };
		void Green(const ULONG p) { set(MUIA_Coloradjust_Green,p); };
		ULONG Green() const { return(get(MUIA_Coloradjust_Green,0UL)); };
		void ModeID(const ULONG p) { set(MUIA_Coloradjust_ModeID,p); };
		ULONG ModeID() const { return(get(MUIA_Coloradjust_ModeID,0UL)); };
		void Red(const ULONG p) { set(MUIA_Coloradjust_Red,p); };
		ULONG Red() const { return(get(MUIA_Coloradjust_Red,0UL)); };
		void RGB(const ULONG *p) { set(MUIA_Coloradjust_RGB,(ULONG)p); };
		ULONG *RGB() const { return((ULONG *)get(MUIA_Coloradjust_RGB,NULL)); };
	};

#endif
