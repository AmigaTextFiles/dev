#ifndef TWICPP_TWIMUI_ABOUTMUI_H
#define TWICPP_TWIMUI_ABOUTMUI_H

//
//  $VER: Aboutmui.h    2.0 (10 Feb 1997)
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

#ifndef TWICPP_TWIMUI_WINDOW_H
#include <twiclasses/twimui/window.h>
#endif

///

/// class MUIAboutmui

class MUIAboutmui : public MUIWindow
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIAboutmui(const struct TagItem *t) : MUIWindow(MUIC_Aboutmui) { init(t); };
        MUIAboutmui(const Tag, ...);
        MUIAboutmui() : MUIWindow(MUIC_Aboutmui) { };
        MUIAboutmui(const MUIAboutmui &);
        virtual ~MUIAboutmui();
        MUIAboutmui &operator= (const MUIAboutmui &);
    };

///

#endif
