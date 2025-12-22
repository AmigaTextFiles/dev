//
//  $VER: Request.h     1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_REQUEST_H
#define CPP_TWIMUI_REQUEST_H

#ifndef CPP_TWIMUI_APPLICATION_H
#include <classes/twimui/application.h>
#endif

#ifndef CPP_TWIMUI_WINDOW_H
#include <classes/twimui/window.h>
#endif

#ifndef CLIB_MUIMASTER_PROTOS_H
#include <clib/muimaster_protos.h>
#endif

#ifndef _INCLUDE_PRAGMA_MUIMASTER_LIB_H
#include <pragma/muimaster_lib.h>
#endif

class MUIRequest
	{
	private:
		Object *app;
		Object *win;
		LONGBITS flags;
		TWiStr title;
		TWiStr gadgets;
		TWiStr format;
		TWiArrayList<ULONG> parms;
		void initparms(const ULONG, const ULONG *);
	public:
		MUIRequest(const MUIApplication &a, const MUIWindow &w, const LONGBITS b, const STRPTR t, const STRPTR g, const STRPTR f, const ULONG c, const ULONG *p)
			:   app(a),
				win(w),
				flags(b),
				title(t),
				gadgets(g),
				format(f),
				parms(0)
			{ initparms(c,p); };
		MUIRequest(const MUIWindow &w, const LONGBITS b, const STRPTR t, const STRPTR g, const STRPTR f, const ULONG c, const ULONG *p)
			:   app(NULL),
				win(w),
				flags(b),
				title(t),
				gadgets(g),
				format(f),
				parms(0)
			{ initparms(c,p); };
		MUIRequest(const MUIApplication &a, const LONGBITS b, const STRPTR t, const STRPTR g, const STRPTR f, const ULONG c, const ULONG *p)
			:   app(a),
				win(NULL),
				flags(b),
				title(t),
				gadgets(g),
				format(f),
				parms(0)
			{ initparms(c,p); };
		MUIRequest(const LONGBITS b, const STRPTR t, const STRPTR g, const STRPTR f, const ULONG c, const ULONG *p)
			:   app(NULL),
				win(NULL),
				flags(b),
				title(t),
				gadgets(g),
				format(f),
				parms(0)
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
		void setApp(const MUIApplication &p) { app = p; };
		void setWin(const MUIWindow &p) { win = p; };
		void setFlags(const ULONG p) { flags = p; };
		void setTitle(const STRPTR p) { title = p; };
		void setGadgets(const STRPTR p) { gadgets = p; };
		void setFormat(const STRPTR p) { format = p; };
		void setParms(const ULONG c, const ULONG *p) { initparms(c,p); };
		void setParms(const ULONG c, ...);
		ULONG show() { return(MUI_RequestA((APTR)app,(APTR)win,flags,title,gadgets,format,(APTR)parms)); };
		ULONG show(const MUIApplication &p) { return(MUI_RequestA((APTR)((Object *)p),(APTR)win,flags,title,gadgets,format,(APTR)parms)); };
		ULONG show(const MUIWindow &p) { return(MUI_RequestA((APTR)app,(APTR)((Object *)p),flags,title,gadgets,format,(APTR)parms)); };
		ULONG show(const MUIApplication &p1, const MUIWindow &p2) { return(MUI_RequestA((APTR)((Object *)p1),(APTR)((Object *)p2),flags,title,gadgets,format,(APTR)parms)); };
	};

#endif
