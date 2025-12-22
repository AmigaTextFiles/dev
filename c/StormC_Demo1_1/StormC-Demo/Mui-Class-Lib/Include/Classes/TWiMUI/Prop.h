//
//  $VER: Prop.h        1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_PROP_H
#define CPP_TWIMUI_PROP_H

#ifndef CPP_TWIMUI_GADGET_H
#include <classes/twimui/gadget.h>
#endif

class MUIProp : public MUIGadget
	{
	public:
		MUIProp(const struct TagItem *t) : MUIGadget(MUIC_Prop) { init(t); };
		MUIProp(const Tag, ...);
		MUIProp() : MUIGadget(MUIC_Prop) { };
		MUIProp(MUIProp &p) : MUIGadget(p) { };
		virtual ~MUIProp();
		MUIProp &operator= (MUIProp &);
		void Entries(const LONG p) { set(MUIA_Prop_Entries,(ULONG)p); };
		LONG Entries() const { return((LONG)get(MUIA_Prop_Entries,0L)); };
		void First(const LONG p) { set(MUIA_Prop_First,(ULONG)p); };
		LONG First() const { return((LONG)get(MUIA_Prop_First,0L)); };
		BOOL Horiz() const { return((BOOL)get(MUIA_Prop_Horiz,FALSE)); };
		void PSlider(const BOOL p) { set(MUIA_Prop_Slider,(ULONG)p); };
		BOOL PSlider() const { return((BOOL)get(MUIA_Prop_Slider,0L)); };
		void Visible(const LONG p) { set(MUIA_Prop_Visible,(ULONG)p); };
		LONG Visible() const { return((LONG)get(MUIA_Prop_Visible,0L)); };
	};

#endif
