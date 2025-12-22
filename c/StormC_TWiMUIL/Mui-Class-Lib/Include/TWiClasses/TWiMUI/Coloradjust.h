#ifndef TWICPP_TWIMUI_COLORADJUST_H
#define TWICPP_TWIMUI_COLORADJUST_H

//
//  $VER: Coloradjust.h 2.0 (10 Feb 1997)
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

/// class MUIColoradjust

class MUIColoradjust : public MUIGroup
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIColoradjust(const struct TagItem *t) : MUIGroup(MUIC_Coloradjust) { init(t); };
        MUIColoradjust(const Tag, ...);
        MUIColoradjust() : MUIGroup(MUIC_Coloradjust) { };
        MUIColoradjust(const MUIColoradjust &);
        virtual ~MUIColoradjust();
        MUIColoradjust &operator= (const MUIColoradjust &);
        VOID Blue(const ULONG p) { set(MUIA_Coloradjust_Blue,p); };
        ULONG Blue() const { return(get(MUIA_Coloradjust_Blue,0UL)); };
        VOID Green(const ULONG p) { set(MUIA_Coloradjust_Green,p); };
        ULONG Green() const { return(get(MUIA_Coloradjust_Green,0UL)); };
        VOID ModeID(const ULONG p) { set(MUIA_Coloradjust_ModeID,p); };
        ULONG ModeID() const { return(get(MUIA_Coloradjust_ModeID,0UL)); };
        VOID Red(const ULONG p) { set(MUIA_Coloradjust_Red,p); };
        ULONG Red() const { return(get(MUIA_Coloradjust_Red,0UL)); };
        VOID RGB(const ULONG *p) { set(MUIA_Coloradjust_RGB,(ULONG)p); };
        ULONG *RGB() const { return((ULONG *)get(MUIA_Coloradjust_RGB,NULL)); };
    };

///

#endif
