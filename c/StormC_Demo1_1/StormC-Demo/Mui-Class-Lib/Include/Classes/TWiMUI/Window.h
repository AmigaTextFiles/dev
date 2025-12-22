//
//  $VER: Window.h      1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_WINDOW_H
#define CPP_TWIMUI_WINDOW_H

#ifndef CPP_TWIMUI_NOTIFY_H
#include <classes/twimui/notify.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef INTUITION_SCREENS_H
#include <intuition/screens.h>
#endif

class MUIWindow : public MUINotify
	{
	private:
		virtual ULONG Dispatch(struct IClass *, Object *, Msg);
	protected:
		MUIWindow(STRPTR cl) : MUINotify(cl) { };
	public:
		MUIWindow(const struct TagItem *t) : MUINotify(MUIC_Window) { init(t); };
		MUIWindow(const Tag, ...);
		MUIWindow() : MUINotify(MUIC_Window) { };
		MUIWindow(MUIWindow &p) : MUINotify(p) { };
		virtual ~MUIWindow();
		MUIWindow &operator= (MUIWindow &);
		void Activate(const BOOL p) { set(MUIA_Window_Activate,(ULONG)p); };
		BOOL Activate() const { return((BOOL)get(MUIA_Window_Activate,FALSE)); };
		void ActiveObject(const Object *p) { set(MUIA_Window_ActiveObject,(ULONG)p); };
		void ActiveObjectNone() { set(MUIA_Window_ActiveObject,MUIV_Window_ActiveObject_None); };
		void ActiveObjectNext() { set(MUIA_Window_ActiveObject,MUIV_Window_ActiveObject_Next); };
		void ActiveObjectPrev() { set(MUIA_Window_ActiveObject,MUIV_Window_ActiveObject_Prev); };
		Object *ActiveObject() const { return((Object *)get(MUIA_Window_ActiveObject)); };
		LONG AltHeight() const { return((LONG)get(MUIA_Window_AltHeight,0L)); };
		LONG AltLeftEdge() const { return((LONG)get(MUIA_Window_AltLeftEdge,0L)); };
		LONG AltTopEdge() const { return((LONG)get(MUIA_Window_AltTopEdge,0L)); };
		LONG AltWidth() const { return((LONG)get(MUIA_Window_AltWidth,0L)); };
		BOOL CloseRequest() const { return((BOOL)get(MUIA_Window_CloseRequest,FALSE)); };
		void DefaultObject(const Object *p) { set(MUIA_Window_DefaultObject,(ULONG)p); };
		Object *DefaultObject() const { return((Object *)get(MUIA_Window_DefaultObject)); };
		void FancyDrawing(const BOOL p) { set(MUIA_Window_FancyDrawing,(ULONG)p); };
		BOOL FancyDrawing() const { return((BOOL)get(MUIA_Window_FancyDrawing)); };
		LONG Height() const { return((LONG)get(MUIA_Window_Height,0L)); };
		ULONG ID() const { return(get(MUIA_Window_ID,0L)); };
		struct InputEvent *InputEvent() const { return((struct InputEvent *)get(MUIA_Window_InputEvent,NULL)); };
		LONG LeftEdge() const { return((LONG)get(MUIA_Window_LeftEdge,0L)); };
		void MenuAction(const ULONG p) { set(MUIA_Window_MenuAction,p); };
		ULONG MenuAction() const { return(get(MUIA_Window_MenuAction,0L)); };
		Object *Menustrip() const { return((Object *)get(MUIA_Window_Menustrip)); };
		Object *MouseObject() const { return((Object *)get(MUIA_Window_MouseObject)); };
		void NoMenus(const BOOL p) { set(MUIA_Window_NoMenus,(ULONG)p); };
		void Open(const BOOL p) { set(MUIA_Window_Open,(ULONG)p); };
		BOOL Open() const { return((BOOL)get(MUIA_Window_Open,FALSE)); };
		void PublicScreen(const STRPTR p) { set(MUIA_Window_PublicScreen,(ULONG)p); };
		STRPTR PublicScreen() const { return((STRPTR)get(MUIA_Window_PublicScreen)); };
		void RefWindow(const Object *p) { set(MUIA_Window_RefWindow,(ULONG)p); };
		void RootObject(const Object *p) { set(MUIA_Window_RootObject,(ULONG)p); };
		Object *RootObject() const { return((Object *)get(MUIA_Window_RootObject)); };
		void ScreenP(const struct Screen *p) { set(MUIA_Window_Screen,(ULONG)p); };
		struct Screen *ScreenP() const { return((struct Screen *)get(MUIA_Window_Screen)); };
		void ScreenTitle(const STRPTR p) { set(MUIA_Window_ScreenTitle,(ULONG)p); };
		STRPTR ScreenTitle() const { return((STRPTR)get(MUIA_Window_ScreenTitle)); };
		void Sleep(const BOOL p) { set(MUIA_Window_Sleep,(ULONG)p); };
		BOOL Sleep() const { return((BOOL)get(MUIA_Window_Sleep,FALSE)); };
		void Title(const STRPTR p) { set(MUIA_Window_Title,(ULONG)p); };
		STRPTR Title() const { return((STRPTR)get(MUIA_Window_Title)); };
		LONG TopEdge() const { return((LONG)get(MUIA_Window_TopEdge,0L)); };
		LONG Width() const { return((LONG)get(MUIA_Window_Width,0L)); };
		struct Window *WindowP() const { return((struct Window *)get(MUIA_Window_Window)); };
		void ScreenToBack() { dom(MUIM_Window_ScreenToBack); };
		void ScreenToFront() { dom(MUIM_Window_ScreenToFront); };
		void ToBack() { dom(MUIM_Window_ToBack); };
		void ToFront() { dom(MUIM_Window_ToFront); };
	};

#endif
