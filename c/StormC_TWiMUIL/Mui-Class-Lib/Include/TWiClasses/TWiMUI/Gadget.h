#ifndef TWICPP_TWIMUI_GADGET_H
#define TWICPP_TWIMUI_GADGET_H

//
//  $VER: Gadget.h      2.0 (10 Feb 1997)
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
//  02 Sep 1996 :   1.2 : Neu:
//                        - ClassNum() für Exception-Handling.
//                        Änderungen:
//                        - Parameter des Copy-Konstruktor als 'const'-Parameter definiert
//

/// Includes

#ifndef TWICPP_TWIMUI_AREA_H
#include <twiclasses/twimui/area.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

///

/// class MUIGadget

class MUIGadget : public MUIArea
    {
    protected:
        virtual const ULONG ClassNum() const;
        MUIGadget(STRPTR cl) : MUIArea(cl) { };
    public:
        MUIGadget(const struct TagItem *t) : MUIArea(MUIC_Gadget) { init(t); };
        MUIGadget(const Tag, ...);
        MUIGadget() : MUIArea(MUIC_Gadget) { };
        MUIGadget(const MUIGadget &);
        virtual ~MUIGadget();
        MUIGadget &operator= (const MUIGadget &);
        struct Gadget *GadgetP() const { return((struct Gadget *)get(MUIA_Gadget_Gadget,NULL)); };
    };

///

#endif
