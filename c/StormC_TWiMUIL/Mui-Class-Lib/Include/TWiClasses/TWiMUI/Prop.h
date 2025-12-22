#ifndef TWICPP_TWIMUI_PROP_H
#define TWICPP_TWIMUI_PROP_H

//
//  $VER: Prop.h        2.0 (10 Feb 1997)
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
//                        - Die Methode Decrease() wurde für MUI 3.6 hinzugefügt.
//                        - Die Methode Increase() wurde für MUI 3.6 hinzugefügt.
//                        - ClassNum() für Exception-Handling.
//

/// Includes

#ifndef TWICPP_TWIMUI_GADGET_H
#include <twiclasses/twimui/gadget.h>
#endif

///

/// class MUIProp

class MUIProp : public MUIGadget
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIProp(const struct TagItem *t) : MUIGadget(MUIC_Prop) { init(t); };
        MUIProp(const Tag, ...);
        MUIProp() : MUIGadget(MUIC_Prop) { };
        MUIProp(const MUIProp &);
        virtual ~MUIProp();
        MUIProp &operator= (const MUIProp &);
        VOID Entries(const LONG p) { set(MUIA_Prop_Entries,(ULONG)p); };
        LONG Entries() const { return((LONG)get(MUIA_Prop_Entries,0L)); };
        VOID First(const LONG p) { set(MUIA_Prop_First,(ULONG)p); };
        LONG First() const { return((LONG)get(MUIA_Prop_First,0L)); };
        BOOL Horiz() const { return((BOOL)get(MUIA_Prop_Horiz,FALSE)); };
        VOID PSlider(const BOOL p) { set(MUIA_Prop_Slider,(ULONG)p); };
        BOOL PSlider() const { return((BOOL)get(MUIA_Prop_Slider,0L)); };
        VOID Visible(const LONG p) { set(MUIA_Prop_Visible,(ULONG)p); };
        LONG Visible() const { return((LONG)get(MUIA_Prop_Visible,0L)); };
        VOID Decrease(LONG p) { dom(MUIM_Prop_Decrease,(ULONG)p); };
        VOID Increase(LONG p) { dom(MUIM_Prop_Increase,(ULONG)p); };
    };

///

#endif
