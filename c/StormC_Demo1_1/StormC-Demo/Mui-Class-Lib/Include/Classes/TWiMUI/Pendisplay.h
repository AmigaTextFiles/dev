//
//  $VER: Pendisplay.h  1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_PENDISPLAY_H
#define CPP_TWIMUI_PENDISPLAY_H

#ifndef CPP_TWIMUI_AREA_H
#include <classes/twimui/area.h>
#endif

class MUIPendisplay : public MUIArea
	{
	protected:
		MUIPendisplay(STRPTR cl) : MUIArea(cl) { };
	public:
		MUIPendisplay(const struct TagItem *t) : MUIArea(MUIC_Pendisplay) { init(t); };
		MUIPendisplay(const Tag, ...);
		MUIPendisplay() : MUIArea(MUIC_Pendisplay) { };
		MUIPendisplay(MUIPendisplay &p) : MUIArea(p) { };
		virtual ~MUIPendisplay();
		MUIPendisplay &operator= (MUIPendisplay &);
		Object *Pen() const { return((Object *)get(MUIA_Pendisplay_Pen,NULL)); };
		void Reference(const Object *p) { set(MUIA_Pendisplay_Reference,(ULONG)p); };
		Object *Reference() const { return((Object *)get(MUIA_Pendisplay_Reference,NULL)); };
		void Spec(const struct MUI_PenSpec *p) { set(MUIA_Pendisplay_Spec,(ULONG)p); };
		struct MUI_PenSpec *Spec() const { return((struct MUI_PenSpec *)get(MUIA_Pendisplay_Spec,NULL)); };
		void SetColormap(LONG p) { dom(MUIM_Pendisplay_SetColormap,(ULONG)p); };
		void SetMUIPen(LONG p) { dom(MUIM_Pendisplay_SetMUIPen,(ULONG)p); };
		void SetRGB(ULONG p1, ULONG p2, ULONG p3) { dom(MUIM_Pendisplay_SetRGB,p1,p2,p3); };
	};

#endif
