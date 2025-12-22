#ifndef TWICPP_TWIMUI_WINDOW_H
#define TWICPP_TWIMUI_WINDOW_H

//
//  $VER: Window.h      2.0 (10 Feb 1997)
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
//                        - Die Methode AddEventHandler() wurde für MUI 3.6 hinzugefügt
//                        - Die Methode RemEventHandler() wurde für MUI 3.6 hinzugefügt
//                        - ClassNum() für Exception-Handling.
//                        Änderungen:
//                        - Parameter des Copy-Konstruktor als 'const'-Parameter definiert
//
//  15 Feb 1997 :   2.0 : Änderungen:
//                        - Anpassungen an MUI 3.8
//

/// Includes

#ifndef TWICPP_TWIMUI_NOTIFY_H
#include <twiclasses/twimui/notify.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef INTUITION_SCREENS_H
#include <intuition/screens.h>
#endif

///

/// class MUIWindow

class MUIWindow : public MUINotify
    {
    private:
        BOOL ParSwitch;
        virtual ULONG Dispatch(struct IClass *, Object *, Msg);
    protected:
        virtual const ULONG ClassNum() const;
        MUIWindow(STRPTR cl) : MUINotify(cl), ParSwitch(FALSE) { };
    public:
        MUIWindow(const struct TagItem *t) : MUINotify(MUIC_Window), ParSwitch(FALSE) { init(t); };
        MUIWindow(const Tag, ...);
        MUIWindow() : MUINotify(MUIC_Window), ParSwitch(FALSE) { };
        MUIWindow(const MUIWindow &);
        virtual ~MUIWindow();
        MUIWindow &operator= (const MUIWindow &);
        VOID Activate(const BOOL p) { set(MUIA_Window_Activate,(ULONG)p); };
        BOOL Activate() const { return((BOOL)get(MUIA_Window_Activate,FALSE)); };
        VOID ActiveObject(const Object *p) { set(MUIA_Window_ActiveObject,(ULONG)p); };
        VOID ActiveObjectNone() { set(MUIA_Window_ActiveObject,MUIV_Window_ActiveObject_None); };
        VOID ActiveObjectNext() { set(MUIA_Window_ActiveObject,MUIV_Window_ActiveObject_Next); };
        VOID ActiveObjectPrev() { set(MUIA_Window_ActiveObject,MUIV_Window_ActiveObject_Prev); };
        Object *ActiveObject() const { return((Object *)get(MUIA_Window_ActiveObject)); };
        LONG AltHeight() const { return((LONG)get(MUIA_Window_AltHeight,0L)); };
        LONG AltLeftEdge() const { return((LONG)get(MUIA_Window_AltLeftEdge,0L)); };
        LONG AltTopEdge() const { return((LONG)get(MUIA_Window_AltTopEdge,0L)); };
        LONG AltWidth() const { return((LONG)get(MUIA_Window_AltWidth,0L)); };
        BOOL CloseRequest() const { return((BOOL)get(MUIA_Window_CloseRequest,FALSE)); };
        VOID DefaultObject(const Object *p) { set(MUIA_Window_DefaultObject,(ULONG)p); };
        Object *DefaultObject() const { return((Object *)get(MUIA_Window_DefaultObject)); };
        VOID FancyDrawing(const BOOL p) { set(MUIA_Window_FancyDrawing,(ULONG)p); };
        BOOL FancyDrawing() const { return((BOOL)get(MUIA_Window_FancyDrawing)); };
        LONG Height() const { return((LONG)get(MUIA_Window_Height,0L)); };
        ULONG ID() const { return(get(MUIA_Window_ID,0L)); };
        struct InputEvent *InputEvent() const { return((struct InputEvent *)get(MUIA_Window_InputEvent,NULL)); };
        LONG LeftEdge() const { return((LONG)get(MUIA_Window_LeftEdge,0L)); };
        VOID MenuAction(const ULONG p) { set(MUIA_Window_MenuAction,p); };
        ULONG MenuAction() const { return(get(MUIA_Window_MenuAction,0L)); };
        Object *Menustrip() const { return((Object *)get(MUIA_Window_Menustrip)); };
        Object *MouseObject() const { return((Object *)get(MUIA_Window_MouseObject)); };
        VOID NoMenus(const BOOL p) { set(MUIA_Window_NoMenus,(ULONG)p); };
        VOID Open(const BOOL p) { set(MUIA_Window_Open,(ULONG)p); };
        BOOL Open() const { return((BOOL)get(MUIA_Window_Open,FALSE)); };
        VOID PublicScreen(const STRPTR p) { set(MUIA_Window_PublicScreen,(ULONG)p); };
        STRPTR PublicScreen() const { return((STRPTR)get(MUIA_Window_PublicScreen)); };
        VOID RefWindow(const Object *p) { set(MUIA_Window_RefWindow,(ULONG)p); };
        VOID RootObject(const Object *p) { set(MUIA_Window_RootObject,(ULONG)p); };
        Object *RootObject() const { return((Object *)get(MUIA_Window_RootObject)); };
        VOID ScreenP(const struct Screen *p) { set(MUIA_Window_Screen,(ULONG)p); };
        struct Screen *ScreenP() const { return((struct Screen *)get(MUIA_Window_Screen)); };
        VOID ScreenTitle(const STRPTR p) { set(MUIA_Window_ScreenTitle,(ULONG)p); };
        STRPTR ScreenTitle() const { return((STRPTR)get(MUIA_Window_ScreenTitle)); };
        VOID Sleep(const BOOL p) { set(MUIA_Window_Sleep,(ULONG)p); };
        BOOL Sleep() const { return((BOOL)get(MUIA_Window_Sleep,FALSE)); };
        VOID Title(const STRPTR p) { set(MUIA_Window_Title,(ULONG)p); };
        STRPTR Title() const { return((STRPTR)get(MUIA_Window_Title)); };
        LONG TopEdge() const { return((LONG)get(MUIA_Window_TopEdge,0L)); };
        VOID UseBottomBorderScroller(const BOOL p) { set(MUIA_Window_UseBottomBorderScroller,(ULONG)p); };
        BOOL UseBottomBorderScroller() const { return((BOOL)get(MUIA_Window_UseBottomBorderScroller,FALSE)); };
        VOID UseLeftBorderScroller(const BOOL p) { set(MUIA_Window_UseLeftBorderScroller,(ULONG)p); };
        BOOL UseLeftBorderScroller() const { return((BOOL)get(MUIA_Window_UseLeftBorderScroller,FALSE)); };
        VOID UseRightBorderScroller(const BOOL p) { set(MUIA_Window_UseRightBorderScroller,(ULONG)p); };
        BOOL UseRightBorderScroller() const { return((BOOL)get(MUIA_Window_UseRightBorderScroller,FALSE)); };
        LONG Width() const { return((LONG)get(MUIA_Window_Width,0L)); };
        struct Window *WindowP() const { return((struct Window *)get(MUIA_Window_Window)); };
        VOID AddEventHandler(struct MUI_EventHandlerNode *p) { dom(MUIM_Window_AddEventHandler,(ULONG)p); };
        VOID RemEventHandler(struct MUI_EventHandlerNode *p) { dom(MUIM_Window_RemEventHandler,(ULONG)p); };
        VOID ScreenToBack() { dom(MUIM_Window_ScreenToBack); };
        VOID ScreenToFront() { dom(MUIM_Window_ScreenToFront); };
        VOID Snapshot(LONG p) { dom(MUIM_Window_Snapshot,(ULONG)p); };
        VOID ToBack() { dom(MUIM_Window_ToBack); };
        VOID ToFront() { dom(MUIM_Window_ToFront); };
        //
        //  Die folgenden 2 Methoden bitte NICHT benutzen. Sie sind
        //  nur zur Umgehung eines MUI-Bugs gedacht.
        //
        VOID ParSwitchSet(const Object *p) { ParSwitch = TRUE; Par = (Object *)p; };
        VOID ParSwitchClear() { ParSwitch = TRUE; Par = NULL; };
    };

///

#endif
