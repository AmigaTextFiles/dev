#ifndef TWICPP_TWIMUI_CYCLE_H
#define TWICPP_TWIMUI_CYCLE_H

//
//  $VER: Cycle.h       2.0 (10 Feb 1997)
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
//  10 Feb 1997 :   2.0 : Änderungen:
//                        - Anpassungen an MUI 3.7
//

/// Includes

#ifndef TWICPP_TWIMUI_LABEL_H
#include <twiclasses/twimui/label.h>
#endif

#ifndef TWICPP_TWIMUI_GROUP_H
#include <twiclasses/twimui/group.h>
#endif

///

/// class MUICycle

class MUICycle : public MUIGroup
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUICycle(const struct TagItem *t)
            :   MUIGroup(MUIC_Cycle)
            {
            init(t);
            };
        MUICycle(const Tag, ...);
        MUICycle(const STRPTR *entries)
            :   MUIGroup(MUIC_Cycle)
            {
            init(MUIA_Cycle_Entries, entries,
                MUIA_Font, MUIV_Font_Button,
                TAG_DONE);
            };
        MUICycle(const STRPTR *entries, const UBYTE cc)
            :   MUIGroup(MUIC_Cycle)
            {
            init(MUIA_Cycle_Entries, entries,
                MUIA_Font, MUIV_Font_Button,
                MUIA_ControlChar, cc,
                TAG_DONE);
            };
        MUICycle() : MUIGroup(MUIC_Cycle) { };
        MUICycle(const MUICycle &);
        virtual ~MUICycle();
        MUICycle &operator= (const MUICycle &);
        VOID Active(const LONG p) { set(MUIA_Cycle_Active,(ULONG)p); };
        VOID ActiveNext() { set(MUIA_Cycle_Active,MUIV_Cycle_Active_Next); };
        VOID ActivePrev() { set(MUIA_Cycle_Active,MUIV_Cycle_Active_Prev); };
        LONG Active() const { return((LONG)get(MUIA_Cycle_Active,0L)); };
    };

///
/// class MUILabCycle

class MUILabCycle
    :   public MUILabelHelp,
        public MUICycle
    {
    private:
        MUIKeyLabel2 MUILab;
    public:
        MUILabCycle(const STRPTR lab, const STRPTR *entries)
            :   MUILabelHelp(lab),
                MUICycle(entries,MUILabelHelp::gCC()),
                MUILab(MUILabelHelp::gLab(),MUILabelHelp::gCC())
            { };
        MUILabCycle(const MUILabCycle &p)
            :   MUILabelHelp((MUILabelHelp &)p),
                MUICycle((MUICycle &)p),
                MUILab(p.MUILab)
            { };
        virtual ~MUILabCycle();
        MUILabCycle &operator= (const MUILabCycle &);
        Object *label() { return(MUILab); };
    };

///

#endif
