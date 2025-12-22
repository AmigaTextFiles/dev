#ifndef TWICPP_TWIMUI_RADIO_H
#define TWICPP_TWIMUI_RADIO_H

//
//  $VER: Radio.h       2.0 (10 Feb 1997)
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

#ifndef TWICPP_TWIMUI_GROUP_H
#include <twiclasses/twimui/group.h>
#endif

///

/// class MUIRadio

class MUIRadio : public MUIGroup
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIRadio(const struct TagItem *t)
            :   MUIGroup(MUIC_Radio)
            {
            init(t);
            };
        MUIRadio(const Tag, ...);
        MUIRadio(const STRPTR *entries)
            :   MUIGroup(MUIC_Radio)
            {
            init(MUIA_Radio_Entries, entries,
                MUIA_Background, MUII_GroupBack,
                TAG_DONE);
            };
        MUIRadio(const STRPTR *entries, const UBYTE cc)
            :   MUIGroup(MUIC_Radio)
            {
            init(MUIA_Radio_Entries, entries,
                MUIA_Background, MUII_GroupBack,
                MUIA_ControlChar, cc,
                TAG_DONE);
            };
        MUIRadio() : MUIGroup(MUIC_Radio) { };
        MUIRadio(const MUIRadio &);
        virtual ~MUIRadio();
        MUIRadio &operator= (const MUIRadio &);
        VOID Active(const LONG p) { set(MUIA_Radio_Active,(ULONG)p); };
        LONG Active() const { return((LONG)get(MUIA_Radio_Active,0L)); };
    };

///
/// class MUILabRadio

class MUILabRadio
    :   public MUILabelHelp,
        public MUIRadio
    {
    public:
        MUILabRadio(const STRPTR lab, const STRPTR *entries)
            :   MUILabelHelp(lab),
                MUIRadio(MUIA_Radio_Entries, entries,
                    MUIA_Frame, MUIV_Frame_Group,
                    MUIA_FrameTitle, MUILabelHelp::gLab(),
                    MUIA_Background, MUII_GroupBack,
                    MUIA_ControlChar, MUILabelHelp::gCC(),
                    TAG_DONE)
            { };
        MUILabRadio(const MUILabRadio &p)
            :   MUILabelHelp((MUILabelHelp &)p),
                MUIRadio((MUIRadio &)p)
                { };
        virtual ~MUILabRadio();
        MUILabRadio &operator= (const MUILabRadio &);
    };

///

#endif
