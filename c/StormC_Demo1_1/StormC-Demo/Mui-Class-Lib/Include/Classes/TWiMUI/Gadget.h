//
//  $VER: Gadget.h      1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_GADGET_H
#define CPP_TWIMUI_GADGET_H

#ifndef CPP_TWIMUI_AREA_H
#include <classes/twimui/area.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

class MUIGadget : public MUIArea
	{
	protected:
		MUIGadget(STRPTR cl) : MUIArea(cl) { };
	public:
		MUIGadget(const struct TagItem *t) : MUIArea(MUIC_Gadget) { init(t); };
		MUIGadget(const Tag, ...);
		MUIGadget() : MUIArea(MUIC_Gadget) { };
		MUIGadget(MUIGadget &p) : MUIArea(p) { };
		virtual ~MUIGadget();
		MUIGadget &operator= (MUIGadget &);
		struct Gadget *GadgetP() const { return((struct Gadget *)get(MUIA_Gadget_Gadget,NULL)); };
	};

#endif
