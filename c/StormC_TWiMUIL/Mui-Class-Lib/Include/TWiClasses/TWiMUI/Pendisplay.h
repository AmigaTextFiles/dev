#ifndef TWICPP_TWIMUI_PENDISPLAY_H
#define TWICPP_TWIMUI_PENDISPLAY_H

//
//  $VER: Pendisplay.h  2.0 (10 Feb 1997)
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

#ifndef TWICPP_TWIMUI_AREA_H
#include <twiclasses/twimui/area.h>
#endif

///

/// class MUIPendisplay

class MUIPendisplay : public MUIArea
    {
    protected:
        virtual const ULONG ClassNum() const;
        MUIPendisplay(const STRPTR cl) : MUIArea(cl) { };
    public:
        MUIPendisplay(const struct TagItem *t) : MUIArea(MUIC_Pendisplay) { init(t); };
        MUIPendisplay(const Tag, ...);
        MUIPendisplay() : MUIArea(MUIC_Pendisplay) { };
        MUIPendisplay(const MUIPendisplay &);
        virtual ~MUIPendisplay();
        MUIPendisplay &operator= (const MUIPendisplay &);
        Object *Pen() const { return((Object *)get(MUIA_Pendisplay_Pen,NULL)); };
        VOID Reference(const Object *p) { set(MUIA_Pendisplay_Reference,(ULONG)p); };
        Object *Reference() const { return((Object *)get(MUIA_Pendisplay_Reference,NULL)); };
        VOID RGBcolor(const struct MUI_RGBcolor *p) { set(MUIA_Pendisplay_RGBcolor,(ULONG)p); };
        struct MUI_RGBcolor *RBGcolor() const { return((struct MUI_RGBcolor *)get(MUIA_Pendisplay_RGBcolor,NULL)); };
        VOID Spec(const struct MUI_PenSpec *p) { set(MUIA_Pendisplay_Spec,(ULONG)p); };
        struct MUI_PenSpec *Spec() const { return((struct MUI_PenSpec *)get(MUIA_Pendisplay_Spec,NULL)); };
        VOID SetColormap(LONG p) { dom(MUIM_Pendisplay_SetColormap,(ULONG)p); };
        VOID SetMUIPen(LONG p) { dom(MUIM_Pendisplay_SetMUIPen,(ULONG)p); };
        VOID SetRGB(ULONG p1, ULONG p2, ULONG p3) { dom(MUIM_Pendisplay_SetRGB,p1,p2,p3); };
    };

///

#endif
