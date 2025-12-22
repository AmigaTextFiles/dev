//
//  $VER: Area.h        1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_AREA_H
#define CPP_TWIMUI_AREA_H

#ifndef CPP_TWIMUI_NOTIFY_H
#include <classes/twimui/notify.h>
#endif

#ifndef CPP_TWIMUI_WINDOW_H
#include <classes/twimui/window.h>
#endif

class MUIArea : public MUINotify
	{
	protected:
		MUIArea(const STRPTR cl) : MUINotify(cl) { };
	public:
		MUIArea(const struct TagItem *t) : MUINotify(MUIC_Area) { init(t); };
		MUIArea(const Tag, ...);
		MUIArea() : MUINotify(MUIC_Area) { };
		MUIArea(MUIArea &p) : MUINotify(p) { };
		virtual ~MUIArea();
		MUIArea &operator= (MUIArea &p);
		void Background(const LONG p) { set(MUIA_Background,(ULONG)p); };
		LONG BottomEdge() const { return((LONG)get(MUIA_BottomEdge,0L)); };
		void ContextMenu(const Object *p) { set(MUIA_ContextMenu,(ULONG)p); };
		Object *ContextMenu() const { return((Object *)get(MUIA_ContextMenu)); };
		Object *ContextMenuTr() const { return((Object *)get(MUIA_ContextMenuTrigger)); };
		void ControlChar(const UBYTE p) { set(MUIA_ControlChar,(ULONG)p); };
		UBYTE ControlChar() const { return((UBYTE)get(MUIA_ControlChar)); };
		void CycleChain(const LONG p) { set(MUIA_CycleChain,(ULONG)p); };
		LONG CycleChain() const { return((LONG)get(MUIA_CycleChain,0L)); };
		void Disabled(const BOOL p) { set(MUIA_Disabled,(ULONG)p); };
		BOOL Disabled() const { return((BOOL)get(MUIA_Disabled,FALSE)); };
		void Draggable(const BOOL p) { set(MUIA_Draggable,(ULONG)p); };
		BOOL Draggable() const { return((BOOL)get(MUIA_Draggable,FALSE)); };
		void Dropable(const BOOL p) { set(MUIA_Dropable,(ULONG)p); };
		BOOL Dropable() const { return((BOOL)get(MUIA_Dropable,FALSE)); };
		struct TextFont *Font() const { return((struct TextFont *)get(MUIA_Font)); };
		LONG Height() const { return((LONG)get(MUIA_Height,0L)); };
		void HorizDisappear(const LONG p) { set(MUIA_HorizDisappear,(ULONG)p); };
		LONG HorizDisappear() const { return((LONG)get(MUIA_HorizDisappear,0L)); };
		LONG LeftEdge() const { return((LONG)get(MUIA_LeftEdge,0L)); };
		void ObjectID(const ULONG p) { set(MUIA_ObjectID,p); };
		ULONG ObjectID() const { return(get(MUIA_ObjectID,0L)); };
		BOOL Pressed() const { return((BOOL)get(MUIA_Pressed,FALSE)); };
		LONG RightEdge() const { return((LONG)get(MUIA_RightEdge,0L)); };
		void Selected(const BOOL p) { set(MUIA_Selected,(ULONG)p); };
		BOOL Selected() const { return((BOOL)get(MUIA_Selected,FALSE)); };
		void ShortHelp(const STRPTR p) { set(MUIA_ShortHelp,(ULONG)p); };
		STRPTR ShortHelp() const { return((STRPTR)get(MUIA_ShortHelp)); };
		void ShowMe(const BOOL p) { set(MUIA_ShowMe,(ULONG)p); };
		BOOL ShowMe() const { return((BOOL)get(MUIA_ShowMe,FALSE)); };
		LONG Timer() const { return((LONG)get(MUIA_Timer,0L)); };
		LONG TopEdge() const { return((LONG)get(MUIA_TopEdge,0L)); };
		void VertDisappear(const LONG p) { set(MUIA_VertDisappear,(ULONG)p); };
		LONG VertDisappear() const { return((LONG)get(MUIA_VertDisappear,0L)); };
		LONG Width() const { return((LONG)get(MUIA_Width,0L)); };
		struct Window *WindowP() const { return((struct Window *)get(MUIA_Window)); };
		Object *WinObject() const { return((Object *)get(MUIA_WindowObject)); };
		MUIWindow *WinClass() const;
	};

#endif
