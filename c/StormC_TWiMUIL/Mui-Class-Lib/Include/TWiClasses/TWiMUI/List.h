#ifndef TWICPP_TWIMUI_LIST_H
#define TWICPP_TWIMUI_LIST_H

//
//  $VER: List.h        2.0 (10 Feb 1997)
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
//  27 Jul 1996 :   1.1 : Bug Fixes:
//                        - List.h
//                          Bei der Methode Visible() hatte ich einen Schreibfehler.
//                          Vielen Dank an Thorsten Rinn für den Bug-Report.
//                        Neu:
//                        - Für die vordefinierten speziellen Werte MUIV_List_Insert_Top,
//                          MUIV_List_Insert_Active, MUIV_List_Insert_Sorted und
//                          MUIV_List_Inserted_Bottom sind eigene Methoden definiert
//                          worden.
//
//  02 Sep 1996 :   1.2 : Neu:
//                        - operator=() und der Copy-Kunstroktor übernehmen auch alle Entries
//                        - ClassNum() für Exception-Handling.
//                        Änderungen:
//                        - NextSelected() gibt den Wert der der Variablen auch als
//                          Return-Wert zurück.
//                        - Parameter des Copy-Konstruktor als 'const'-Parameter definiert
//

/// Includes

#ifndef TWICPP_TWIMUI_AREA_H
#include <twiclasses/twimui/area.h>
#endif

#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif

///

/// class MUIListCompareHook

class MUIListCompareHook
    {
    private:
        struct Hook comparehook;
        static LONG CompareHookEntry(register __a0 struct Hook *, register __a2 APTR, register __a1 APTR);
        virtual LONG CompareHookFunc(struct Hook *, APTR, APTR);
    protected:
        MUIListCompareHook();
        MUIListCompareHook(const MUIListCompareHook &p);
        ~MUIListCompareHook();
        MUIListCompareHook &operator= (const MUIListCompareHook &);
    public:
        struct Hook *compare() { return(&comparehook); };
    };

///
/// class MUIListConstructHook

class MUIListConstructHook
    {
    private:
        struct Hook constructhook;
        static APTR ConstructHookEntry(register __a0 struct Hook *, register __a2 APTR, register __a1 APTR);
        virtual APTR ConstructHookFunc(struct Hook *, APTR, APTR);
    protected:
        MUIListConstructHook();
        MUIListConstructHook(const MUIListConstructHook &p);
        ~MUIListConstructHook();
        MUIListConstructHook &operator= (const MUIListConstructHook &);
    public:
        struct Hook *construct() { return(&constructhook); };
    };

///
/// class MUIListDestructHook

class MUIListDestructHook
    {
    private:
        struct Hook destructhook;
        static VOID DestructHookEntry(register __a0 struct Hook *, register __a2 APTR, register __a1 APTR);
        virtual VOID DestructHookFunc(struct Hook *, APTR, APTR);
    protected:
        MUIListDestructHook();
        MUIListDestructHook(const MUIListDestructHook &p);
        ~MUIListDestructHook();
        MUIListDestructHook &operator= (const MUIListDestructHook &);
    public:
        struct Hook *destruct() { return(&destructhook); };
    };

///
/// class MUIListDisplayHook

class MUIListDisplayHook
    {
    private:
        struct Hook displayhook;
        static VOID DisplayHookEntry(register __a0 struct Hook *, register __a2 STRPTR *, register __a1 APTR);
        virtual VOID DisplayHookFunc(struct Hook *, STRPTR *, APTR);
    protected:
        MUIListDisplayHook();
        MUIListDisplayHook(const MUIListDisplayHook &p);
        ~MUIListDisplayHook();
        MUIListDisplayHook &operator= (const MUIListDisplayHook &);
    public:
        struct Hook *display() { return(&displayhook); };
    };

///
/// class MUIListMultiTestHook

class MUIListMultiTestHook
    {
    private:
        struct Hook multitesthook;
        static BOOL MultiTestHookEntry(register __a0 struct Hook *, register __a1 APTR);
        virtual BOOL MultiTestHookFunc(struct Hook *, APTR);
    protected:
        MUIListMultiTestHook();
        MUIListMultiTestHook(const MUIListMultiTestHook &p);
        ~MUIListMultiTestHook();
        MUIListMultiTestHook &operator= (const MUIListMultiTestHook &);
    public:
        struct Hook *multitest() { return(&multitesthook); };
    };

///
/// class MUIList

class MUIList
    :   public MUIArea,
        public MUIListCompareHook,
        public MUIListConstructHook,
        public MUIListDestructHook,
        public MUIListDisplayHook,
        public MUIListMultiTestHook
    {
    protected:
        virtual const ULONG ClassNum() const;
        MUIList(const STRPTR cl)
            :   MUIArea(cl),
                MUIListCompareHook(),
                MUIListConstructHook(),
                MUIListDestructHook(),
                MUIListDisplayHook(),
                MUIListMultiTestHook()
            { };
    public:
        MUIList(const struct TagItem *t)
            :   MUIArea(MUIC_List),
                MUIListCompareHook(),
                MUIListConstructHook(),
                MUIListDestructHook(),
                MUIListDisplayHook(),
                MUIListMultiTestHook()
            {
            init(t);
            };
        MUIList(const Tag, ...);
        MUIList()
            :   MUIArea(MUIC_List),
                MUIListCompareHook(),
                MUIListConstructHook(),
                MUIListDestructHook(),
                MUIListDisplayHook(),
                MUIListMultiTestHook()
            { };
        MUIList(const MUIList &p);
        virtual ~MUIList();
        MUIList &operator= (const MUIList &);
        VOID Active(const LONG p) { set(MUIA_List_Active,(ULONG)p); };
        VOID ActiveOff() { set(MUIA_List_Active,MUIV_List_Active_Off); };
        VOID ActiveTop() { set(MUIA_List_Active,MUIV_List_Active_Top); };
        VOID ActiveBottom() { set(MUIA_List_Active,MUIV_List_Active_Bottom); };
        VOID ActiveUp() { set(MUIA_List_Active,MUIV_List_Active_Up); };
        VOID ActiveDown() { set(MUIA_List_Active,MUIV_List_Active_Down); };
        VOID ActivePageUp() { set(MUIA_List_Active,MUIV_List_Active_PageUp); };
        VOID ActivePageDown() { set(MUIA_List_Active,MUIV_List_Active_PageDown); };
        LONG Active() const { return((LONG)get(MUIA_List_Active,MUIV_List_Active_Off)); };
        VOID AutoVisible(const BOOL p) { set(MUIA_List_AutoVisible,(ULONG)p); };
        BOOL AutoVisible() const { return((BOOL)get(MUIA_List_AutoVisible,FALSE)); };
        VOID CompareHook(const struct Hook *p) { set(MUIA_List_CompareHook,(ULONG)p); };
        VOID ConstructHook(const struct Hook *p) { set(MUIA_List_ConstructHook,(ULONG)p); };
        VOID ConstructHookString() { set(MUIA_List_ConstructHook,MUIV_List_ConstructHook_String); };
        VOID DestructHook(const struct Hook *p) { set(MUIA_List_DestructHook,(ULONG)p); };
        VOID DestructHookString() { set(MUIA_List_DestructHook,MUIV_List_DestructHook_String); };
        VOID DisplayHook(const struct Hook *p) { set(MUIA_List_DisplayHook,(ULONG)p); };
        VOID DragSortable(const BOOL p) { set(MUIA_List_DragSortable,(ULONG)p); };
        BOOL DragSortable() const { return((BOOL)get(MUIA_List_DragSortable,FALSE)); };
        LONG DropMark() const { return((LONG)get(MUIA_List_DropMark,0L)); };
        LONG Entries() const { return((LONG)get(MUIA_List_Entries,0L)); };
        LONG First() const { return((LONG)get(MUIA_List_First,0L)); };
        VOID Format(const STRPTR p) { set(MUIA_List_Format,(ULONG)p); };
        STRPTR Format() const { return((STRPTR)get(MUIA_List_Format,NULL)); };
        LONG InsertPosition() const { return((LONG)get(MUIA_List_InsertPosition,0L)); };
        VOID MultiTestHook(const struct Hook *p) { set(MUIA_List_MultiTestHook,(ULONG)p); };
        VOID Quiet(const BOOL p) { set(MUIA_List_Quiet,(ULONG)p); };
        VOID ShowDropMarks(const BOOL p) { set(MUIA_List_ShowDropMarks,(ULONG)p); };
        BOOL ShowDropMarks() const { return((BOOL)get(MUIA_List_ShowDropMarks,FALSE)); };
        VOID Title(const STRPTR p) { set(MUIA_List_Title,(ULONG)p); };
        STRPTR Title() const { return((STRPTR)get(MUIA_List_Title,NULL)); };
        LONG Visible() const { return((LONG)get(MUIA_List_Visible,0L)); };
        VOID Clear() { dom(MUIM_List_Clear); };
        APTR CreateImage(Object *p1, ULONG p2) { return((APTR)dom(MUIM_List_CreateImage,(ULONG)p1,(ULONG)p2)); };
        VOID DeleteImage(APTR p) { dom(MUIM_List_DeleteImage,(ULONG)p); };
        VOID Exchange(LONG p1, LONG p2) { dom(MUIM_List_Exchange,(ULONG)p1,(ULONG)p2); };
        APTR GetEntry(LONG p) { APTR t; dom(MUIM_List_GetEntry,(ULONG)p,(ULONG)&t); return(t); };
        APTR GetEntryActive() { APTR t; dom(MUIM_List_GetEntry,MUIV_List_GetEntry_Active,(ULONG)&t); return(t); };
        VOID Insert(APTR *p1, LONG p2, LONG p3) { dom(MUIM_List_Insert,(ULONG)p1,(ULONG)p2,(ULONG)p3); };
        VOID InsertTop(APTR *p1, LONG p2) { dom(MUIM_List_Insert,(ULONG)p1,(ULONG)p2,MUIV_List_Insert_Top); };
        VOID InsertActive(APTR *p1, LONG p2) { dom(MUIM_List_Insert,(ULONG)p1,(ULONG)p2,MUIV_List_Insert_Active); };
        VOID InsertSorted(APTR *p1, LONG p2) { dom(MUIM_List_Insert,(ULONG)p1,(ULONG)p2,MUIV_List_Insert_Sorted); };
        VOID InsertBottom(APTR *p1, LONG p2) { dom(MUIM_List_Insert,(ULONG)p1,(ULONG)p2,MUIV_List_Insert_Bottom); };
        VOID InsertSingle(APTR p1, LONG p2) { dom(MUIM_List_InsertSingle,(ULONG)p1,(ULONG)p2); };
        VOID InsertSingleTop(APTR p) { dom(MUIM_List_InsertSingle,(ULONG)p,MUIV_List_Insert_Top); };
        VOID InsertSingleActive(APTR p) { dom(MUIM_List_InsertSingle,(ULONG)p,MUIV_List_Insert_Active); };
        VOID InsertSingleSorted(APTR p) { dom(MUIM_List_InsertSingle,(ULONG)p,MUIV_List_Insert_Sorted); };
        VOID InsertSingleBottom(APTR p) { dom(MUIM_List_InsertSingle,(ULONG)p,MUIV_List_Insert_Bottom); };
        VOID Jump(LONG p) { dom(MUIM_List_Jump,(ULONG)p); };
        VOID Move(LONG p1, LONG p2) { dom(MUIM_List_Move,(ULONG)p1,(ULONG)p2); };
        LONG NextSelected(LONG *p) { dom(MUIM_List_NextSelected,(ULONG)p); return(*p); };
        VOID Redraw(LONG p) { dom(MUIM_List_Redraw,(ULONG)p); };
        VOID RedrawActive() { dom(MUIM_List_Redraw,MUIV_List_Redraw_Active); };
        VOID RedrawAll() { dom(MUIM_List_Redraw,MUIV_List_Redraw_All); };
        VOID Remove(LONG p) { dom(MUIM_List_Remove,(ULONG)p); };
        VOID RemoveFirst() { dom(MUIM_List_Remove,MUIV_List_Remove_First); };
        VOID RemoveActive() { dom(MUIM_List_Remove,MUIV_List_Remove_Active); };
        VOID RemoveLast() { dom(MUIM_List_Remove,MUIV_List_Remove_Last); };
        VOID Select(LONG p1, LONG p2, LONG *p3) { dom(MUIM_List_Select,(ULONG)p1,(ULONG)p2,(ULONG)p3); };
        VOID Sort() { dom(MUIM_List_Sort); };
        VOID TestPos(LONG p1, LONG p2, struct MUI_List_TestPos_Result *p3) { dom(MUIM_List_TestPos,(ULONG)p1,(ULONG)p2,(ULONG)p3); };
    };

///

#endif
