#ifndef TWICPP_TWIMUI_REGISTER_H
#define TWICPP_TWIMUI_REGISTER_H

//
//  $VER: Register.h    2.0 (10 Feb 1997)
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

/// class MUIRegister

class MUIRegister : public MUIGroup
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIRegister(const struct TagItem *t) : MUIGroup(MUIC_Register) { init(t); };
        MUIRegister(const Tag, ...);
        MUIRegister() : MUIGroup(MUIC_Register) { };
        MUIRegister(const MUIRegister &);
        virtual ~MUIRegister();
        MUIRegister &operator= (const MUIRegister &);
        BOOL Frame() const { return((BOOL)get(MUIA_Register_Frame,FALSE)); };
        STRPTR *Titles() const { return((STRPTR *)get(MUIA_Register_Titles,FALSE)); };
    };

///

#endif
