#ifndef TWICPP_TWIMUI_AREA_H
#define TWICPP_TWIMUI_AREA_H

//
//  $VER: Area.h        2.0 (10 Feb 1997)
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
//  27 Jul 1996 :   1.1 : Neu:
//                        - Die Drag&Drop-Methoden sind hinzugefügt worden.
//
//  02 Sep 1996 :   1.2 : Neu:
//                        - Die Methoden DrawBackground und HandleEvent sind für
//                          MUI 3.6 hinzugefügt worden.
//                        - ClassNum() für Exception-Handling.
//                        Änderungen:
//                        - Die Methode ObjectID() wurde wegen MUI 3.6 nach
//                          MUINotify verschoben.
//                        - Parameter des Copy-Konstruktor als 'const'-Parameter definiert
//
//  10 Feb 1997 :   2.0 : Änderungen:
//                        - Anpassungen an MUI 3.7
//

/// Includes

#ifndef TWICPP_TWIMUI_NOTIFY_H
#include <twiclasses/twimui/notify.h>
#endif

#ifndef TWICPP_TWIMUI_WINDOW_H
#include <twiclasses/twimui/window.h>
#endif

///

/// class MUIArea

class MUIArea : public MUINotify
    {
    protected:
        virtual const ULONG ClassNum() const;
        MUIArea(const STRPTR cl) : MUINotify(cl) { };
    public:
        MUIArea(const struct TagItem *t) : MUINotify(MUIC_Area) { init(t); };
        MUIArea(const Tag, ...);
        MUIArea() : MUINotify(MUIC_Area) { };
        MUIArea(const MUIArea &);
        virtual ~MUIArea();
        MUIArea &operator= (const MUIArea &p);
        VOID Background(const LONG p) { set(MUIA_Background,(ULONG)p); };
        LONG BottomEdge() const { return((LONG)get(MUIA_BottomEdge,0L)); };
        VOID ContextMenu(const Object *p) { set(MUIA_ContextMenu,(ULONG)p); };
        Object *ContextMenu() const { return((Object *)get(MUIA_ContextMenu)); };
        Object *ContextMenuTrigger() const { return((Object *)get(MUIA_ContextMenuTrigger)); };
        VOID ControlChar(const UBYTE p) { set(MUIA_ControlChar,(ULONG)p); };
        UBYTE ControlChar() const { return((UBYTE)get(MUIA_ControlChar)); };
        VOID CycleChain(const LONG p) { set(MUIA_CycleChain,(ULONG)p); };
        LONG CycleChain() const { return((LONG)get(MUIA_CycleChain,0L)); };
        VOID Disabled(const BOOL p) { set(MUIA_Disabled,(ULONG)p); };
        BOOL Disabled() const { return((BOOL)get(MUIA_Disabled,FALSE)); };
        VOID Draggable(const BOOL p) { set(MUIA_Draggable,(ULONG)p); };
        BOOL Draggable() const { return((BOOL)get(MUIA_Draggable,FALSE)); };
        VOID Dropable(const BOOL p) { set(MUIA_Dropable,(ULONG)p); };
        BOOL Dropable() const { return((BOOL)get(MUIA_Dropable,FALSE)); };
        struct TextFont *Font() const { return((struct TextFont *)get(MUIA_Font)); };
        LONG Height() const { return((LONG)get(MUIA_Height,0L)); };
        VOID HorizDisappear(const LONG p) { set(MUIA_HorizDisappear,(ULONG)p); };
        LONG HorizDisappear() const { return((LONG)get(MUIA_HorizDisappear,0L)); };
        LONG LeftEdge() const { return((LONG)get(MUIA_LeftEdge,0L)); };
        BOOL Pressed() const { return((BOOL)get(MUIA_Pressed,FALSE)); };
        LONG RightEdge() const { return((LONG)get(MUIA_RightEdge,0L)); };
        VOID Selected(const BOOL p) { set(MUIA_Selected,(ULONG)p); };
        BOOL Selected() const { return((BOOL)get(MUIA_Selected,FALSE)); };
        VOID ShortHelp(const STRPTR p) { set(MUIA_ShortHelp,(ULONG)p); };
        STRPTR ShortHelp() const { return((STRPTR)get(MUIA_ShortHelp)); };
        VOID ShowMe(const BOOL p) { set(MUIA_ShowMe,(ULONG)p); };
        BOOL ShowMe() const { return((BOOL)get(MUIA_ShowMe,FALSE)); };
        LONG Timer() const { return((LONG)get(MUIA_Timer,0L)); };
        LONG TopEdge() const { return((LONG)get(MUIA_TopEdge,0L)); };
        VOID VertDisappear(const LONG p) { set(MUIA_VertDisappear,(ULONG)p); };
        LONG VertDisappear() const { return((LONG)get(MUIA_VertDisappear,0L)); };
        LONG Width() const { return((LONG)get(MUIA_Width,0L)); };
        struct Window *WindowP() const { return((struct Window *)get(MUIA_Window)); };
        Object *WinObject() const { return((Object *)get(MUIA_WindowObject)); };
        Object *ContextMenuBuild(LONG p1, LONG p2) { return((Object *)dom(MUIM_ContextMenuBuild,(ULONG)p1,(ULONG)p2)); };
        VOID ContextMenuChoice(Object *p) { dom(MUIM_ContextMenuChoice,(ULONG)p); };
        APTR CreateBubble(LONG p1, LONG p2, STRPTR p3, ULONG p4) { return((APTR)dom(MUIM_CreateBubble,(ULONG)p1,(ULONG)p2,(ULONG)p3,(ULONG)p4)); };
        STRPTR CreateShortHelp(LONG p1, LONG p2) { return((STRPTR)dom(MUIM_CreateShortHelp,(ULONG)p1,(ULONG)p2)); };
        VOID DeleteBubble(APTR p) { dom(MUIM_DeleteBubble,(ULONG)p); };
        VOID DeleteShortHelp(STRPTR p) { dom(MUIM_DeleteShortHelp,(ULONG)p); };
        VOID DragBegin(Object *p) { dom(MUIM_DragBegin,(ULONG)p); };
        VOID DragDrop(Object *p1, LONG p2, LONG p3) { dom(MUIM_DragDrop,(ULONG)p1,(ULONG)p2,(ULONG)p3); };
        VOID DragFinish(Object *p) { dom(MUIM_DragFinish,(ULONG)p); };
        VOID DragQuery(Object *p) { dom(MUIM_DragQuery,(ULONG)p); };
        VOID DragReport(Object *p1, LONG p2, LONG p3, LONG p4) { dom(MUIM_DragReport,(ULONG)p1,(ULONG)p2,(ULONG)p3,(ULONG)p4); };
        VOID Draw(ULONG p) { dom(MUIM_Draw,p); };
        VOID Drawbackground(LONG p1, LONG p2, LONG p3, LONG p4, LONG p5, LONG p6, LONG p7) { dom(MUIM_DrawBackground,(ULONG)p1,(ULONG)p2,(ULONG)p3,(ULONG)p4,(ULONG)p5,(ULONG)p6,(ULONG)p7); };
        LONGBITS HandleEvent(struct IntuiMessage *p1, LONG p2) { return((LONGBITS)dom(MUIM_HandleEvent,(ULONG)p1,(ULONG)p2)); };
        MUIWindow *WinClass() const;
    };

///

#endif
