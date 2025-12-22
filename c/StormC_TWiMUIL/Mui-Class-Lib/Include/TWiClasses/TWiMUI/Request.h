#ifndef TWICPP_TWIMUI_REQUEST_H
#define TWICPP_TWIMUI_REQUEST_H

//
//  $VER: Request.h     2.0 (10 Feb 1997)
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
//  31 Aug 1996 :   1.2 : Änderungen:
//                        - Bei den Konstruktoren für das Array der Parameter
//                          wird die Anzahl mitgegeben.
//

/// Includes

#ifndef TWICPP_DATASTRUCTURES_ARRAY_H
#include <twiclasses/datastructures/array.h>
#endif

#ifndef TWICPP_DATASTRUCTURES_STRING_H
#include <twiclasses/datastructures/string.h>
#endif

#ifndef TWICPP_TWIMUI_APPLICATION_H
#include <twiclasses/twimui/application.h>
#endif

#ifndef TWICPP_TWIMUI_WINDOW_H
#include <twiclasses/twimui/window.h>
#endif

#ifndef _INCLUDE_PRAGMA_MUIMASTER_LIB_H
#include <pragma/muimaster_lib.h>
#endif

///

/// class MUIRequest

class MUIRequest
    {
    private:
        Object *app;
        Object *win;
        LONGBITS flags;
        TWiStr title;
        TWiStr gadgets;
        TWiStr format;
        TWiArray<ULONG> parms;
        VOID initparms(const ULONG, const ULONG *);
    public:
        MUIRequest(const MUIApplication &a, const MUIWindow &w, const LONGBITS b, const STRPTR t, const STRPTR g, const STRPTR f, const ULONG c, const ULONG *p)
            :   app(a),
                win(w),
                flags(b),
                title(t),
                gadgets(g),
                format(f),
                parms(c)
            { initparms(c,p); };
        MUIRequest(const MUIWindow &w, const LONGBITS b, const STRPTR t, const STRPTR g, const STRPTR f, const ULONG c, const ULONG *p)
            :   app(NULL),
                win(w),
                flags(b),
                title(t),
                gadgets(g),
                format(f),
                parms(c)
            { initparms(c,p); };
        MUIRequest(const MUIApplication &a, const LONGBITS b, const STRPTR t, const STRPTR g, const STRPTR f, const ULONG c, const ULONG *p)
            :   app(a),
                win(NULL),
                flags(b),
                title(t),
                gadgets(g),
                format(f),
                parms(c)
            { initparms(c,p); };
        MUIRequest(const LONGBITS b, const STRPTR t, const STRPTR g, const STRPTR f, const ULONG c, const ULONG *p)
            :   app(NULL),
                win(NULL),
                flags(b),
                title(t),
                gadgets(g),
                format(f),
                parms(c)
            { initparms(c,p); };
        MUIRequest()
            :   app(NULL),
                win(NULL),
                flags(0UL),
                title(),
                gadgets(),
                format(),
                parms(0)
            { };
        MUIRequest(const MUIRequest &p)
            :   app(p.app),
                win(p.win),
                flags(p.flags),
                title(p.title),
                gadgets(p.gadgets),
                format(p.format),
                parms(p.parms)
            { };
        MUIRequest(const MUIApplication &, const MUIWindow &, const LONGBITS, const STRPTR, const STRPTR, const STRPTR, const ULONG, ...);
        MUIRequest(const MUIWindow &, const LONGBITS, const STRPTR, const STRPTR, const STRPTR, const ULONG, ...);
        MUIRequest(const MUIApplication &, const LONGBITS, const STRPTR, const STRPTR, const STRPTR, const ULONG, ...);
        MUIRequest(const LONGBITS, const STRPTR, const STRPTR, const STRPTR, const ULONG, ...);
        virtual ~MUIRequest();
        MUIRequest &operator=(const MUIRequest &);
        VOID setApp(const MUIApplication &p) { app = p; };
        VOID setWin(const MUIWindow &p) { win = p; };
        VOID setFlags(const ULONG p) { flags = p; };
        VOID setTitle(const STRPTR p) { title = p; };
        VOID setGadgets(const STRPTR p) { gadgets = p; };
        VOID setFormat(const STRPTR p) { format = p; };
        VOID setParms(const ULONG c, const ULONG *p) { initparms(c,p); };
        VOID setParms(const ULONG c, ...);
        ULONG show() { return(MUI_RequestA((APTR)app,(APTR)win,flags,title,gadgets,format,(APTR)parms)); };
        ULONG show(const MUIApplication &p) { return(MUI_RequestA((APTR)((Object *)p),(APTR)win,flags,title,gadgets,format,(APTR)parms)); };
        ULONG show(const MUIWindow &p) { return(MUI_RequestA((APTR)app,(APTR)((Object *)p),flags,title,gadgets,format,(APTR)parms)); };
        ULONG show(const MUIApplication &p1, const MUIWindow &p2) { return(MUI_RequestA((APTR)((Object *)p1),(APTR)((Object *)p2),flags,title,gadgets,format,(APTR)parms)); };
    };

///

#endif
