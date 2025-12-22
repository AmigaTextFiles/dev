//
//  $VER: List.h        1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_LIST_H
#define CPP_TWIMUI_LIST_H

#ifndef CPP_TWIMUI_AREA_H
#include <classes/twimui/area.h>
#endif

#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif

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

class MUIListDestructHook
	{
	private:
		struct Hook destructhook;
		static void DestructHookEntry(register __a0 struct Hook *, register __a2 APTR, register __a1 APTR);
		virtual void DestructHookFunc(struct Hook *, APTR, APTR);
	protected:
		MUIListDestructHook();
		MUIListDestructHook(const MUIListDestructHook &p);
		~MUIListDestructHook();
		MUIListDestructHook &operator= (const MUIListDestructHook &);
	public:
		struct Hook *destruct() { return(&destructhook); };
	};

class MUIListDisplayHook
	{
	private:
		struct Hook displayhook;
		static void DisplayHookEntry(register __a0 struct Hook *, register __a2 STRPTR *, register __a1 APTR);
		virtual void DisplayHookFunc(struct Hook *, STRPTR *, APTR);
	protected:
		MUIListDisplayHook();
		MUIListDisplayHook(const MUIListDisplayHook &p);
		~MUIListDisplayHook();
		MUIListDisplayHook &operator= (const MUIListDisplayHook &);
	public:
		struct Hook *display() { return(&displayhook); };
	};

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

class MUIList
	:   public MUIArea,
		public MUIListCompareHook,
		public MUIListConstructHook,
		public MUIListDestructHook,
		public MUIListDisplayHook,
		public MUIListMultiTestHook
	{
	protected:
		MUIList(STRPTR cl)
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
		MUIList(MUIList &p)
			:   MUIArea(p),
				MUIListCompareHook(),
				MUIListConstructHook(),
				MUIListDestructHook(),
				MUIListDisplayHook(),
				MUIListMultiTestHook()
			{ };
		virtual ~MUIList();
		MUIList &operator= (MUIList &);
		void Active(const LONG p) { set(MUIA_List_Active,(ULONG)p); };
		void ActiveOff() { set(MUIA_List_Active,MUIV_List_Active_Off); };
		void ActiveTop() { set(MUIA_List_Active,MUIV_List_Active_Top); };
		void ActiveBottom() { set(MUIA_List_Active,MUIV_List_Active_Bottom); };
		void ActiveUp() { set(MUIA_List_Active,MUIV_List_Active_Up); };
		void ActiveDown() { set(MUIA_List_Active,MUIV_List_Active_Down); };
		void ActivePageUp() { set(MUIA_List_Active,MUIV_List_Active_PageUp); };
		void ActivePageDown() { set(MUIA_List_Active,MUIV_List_Active_PageDown); };
		LONG Active() const { return((LONG)get(MUIA_List_Active,MUIV_List_Active_Off)); };
		void AutoVisible(const BOOL p) { set(MUIA_List_AutoVisible,(ULONG)p); };
		BOOL AutoVisible() const { return((BOOL)get(MUIA_List_AutoVisible,FALSE)); };
		void CompareHook(const struct Hook *p) { set(MUIA_List_CompareHook,(ULONG)p); };
		void ConstructHook(const struct Hook *p) { set(MUIA_List_ConstructHook,(ULONG)p); };
		void ConstructHookString() { set(MUIA_List_ConstructHook,MUIV_List_ConstructHook_String); };
		void DestructHook(const struct Hook *p) { set(MUIA_List_DestructHook,(ULONG)p); };
		void DestructHookString() { set(MUIA_List_DestructHook,MUIV_List_DestructHook_String); };
		void DisplayHook(const struct Hook *p) { set(MUIA_List_DisplayHook,(ULONG)p); };
		void DragSortable(const BOOL p) { set(MUIA_List_DragSortable,(ULONG)p); };
		BOOL DragSortable() const { return((BOOL)get(MUIA_List_DragSortable,FALSE)); };
		LONG DropMark() const { return((LONG)get(MUIA_List_DropMark,0L)); };
		LONG Entries() const { return((LONG)get(MUIA_List_Entries,0L)); };
		LONG First() const { return((LONG)get(MUIA_List_First,0L)); };
		void Format(const STRPTR p) { set(MUIA_List_Format,(ULONG)p); };
		STRPTR Format() const { return((STRPTR)get(MUIA_List_Format,NULL)); };
		LONG InsertPosition() const { return((LONG)get(MUIA_List_InsertPosition,0L)); };
		void MultiTestHook(const struct Hook *p) { set(MUIA_List_MultiTestHook,(ULONG)p); };
		void Quiet(const BOOL p) { set(MUIA_List_Quiet,(ULONG)p); };
		void ShowDropMarks(const BOOL p) { set(MUIA_List_ShowDropMarks,(ULONG)p); };
		BOOL ShowDropMarks() const { return((BOOL)get(MUIA_List_ShowDropMarks,FALSE)); };
		void Title(const STRPTR p) { set(MUIA_List_Title,(ULONG)p); };
		STRPTR Title() const { return((STRPTR)get(MUIA_List_Title,NULL)); };
		LONG Vivible() const { return((LONG)get(MUIA_List_Visible,0L)); };
		void Clear() { dom(MUIM_List_Clear); };
		APTR CreateImage(Object *p1, ULONG p2) { return((APTR)dom(MUIM_List_CreateImage,(ULONG)p1,(ULONG)p2)); };
		void DeleteImage(APTR p) { dom(MUIM_List_DeleteImage,(ULONG)p); };
		void Exchange(LONG p1, LONG p2) { dom(MUIM_List_Exchange,(ULONG)p1,(ULONG)p2); };
		APTR GetEntry(LONG p) { APTR t; dom(MUIM_List_GetEntry,(ULONG)p,(ULONG)&t); return(t); };
		APTR GetEntryActive() { APTR t; dom(MUIM_List_GetEntry,MUIV_List_GetEntry_Active,(ULONG)&t); return(t); };
		void Insert(APTR *p1, LONG p2, LONG p3) { dom(MUIM_List_Insert,(ULONG)p1,(ULONG)p2,(ULONG)p3); };
		void InsertTop(APTR *p1, LONG p2) { dom(MUIM_List_Insert,(ULONG)p1,(ULONG)p2,MUIV_List_Insert_Top); };
		void InsertActive(APTR *p1, LONG p2) { dom(MUIM_List_Insert,(ULONG)p1,(ULONG)p2,MUIV_List_Insert_Active); };
		void InsertSorted(APTR *p1, LONG p2) { dom(MUIM_List_Insert,(ULONG)p1,(ULONG)p2,MUIV_List_Insert_Sorted); };
		void InsertBottom(APTR *p1, LONG p2) { dom(MUIM_List_Insert,(ULONG)p1,(ULONG)p2,MUIV_List_Insert_Bottom); };
		void InsertSingle(APTR p1, LONG p2) { dom(MUIM_List_InsertSingle,(ULONG)p1,(ULONG)p2); };
//      void InsertSingleTop(APTR p) { dom(MUIM_List_InsertSingle,(ULONG)p,MUIV_List_InsertSingle_Top); };
//      void InsertSingleActive(APTR p) { dom(MUIM_List_InsertSingle,(ULONG)p,MUIV_List_InsertSingle_Active); };
//      void InsertSingleSorted(APTR p) { dom(MUIM_List_InsertSingle,(ULONG)p,MUIV_List_InsertSingle_Sorted); };
//      void InsertSingleBottom(APTR p) { dom(MUIM_List_InsertSingle,(ULONG)p,MUIV_List_InsertSingle_Bottom); };
		void Jump(LONG p) { dom(MUIM_List_Jump,(ULONG)p); };
		void Move(LONG p1, LONG p2) { dom(MUIM_List_Move,(ULONG)p1,(ULONG)p2); };
		void NextSelected(LONG *p) { dom(MUIM_List_NextSelected,(ULONG)p); };
		void Redraw(LONG p) { dom(MUIM_List_Redraw,(ULONG)p); };
		void RedrawActive() { dom(MUIM_List_Redraw,MUIV_List_Redraw_Active); };
		void RedrawAll() { dom(MUIM_List_Redraw,MUIV_List_Redraw_All); };
		void Remove(LONG p) { dom(MUIM_List_Remove,(ULONG)p); };
		void RemoveFirst() { dom(MUIM_List_Remove,MUIV_List_Remove_First); };
		void RemoveActive() { dom(MUIM_List_Remove,MUIV_List_Remove_Active); };
		void RemoveLast() { dom(MUIM_List_Remove,MUIV_List_Remove_Last); };
		void Select(LONG p1, LONG p2, LONG *p3) { dom(MUIM_List_Select,(ULONG)p1,(ULONG)p2,(ULONG)p3); };
		void Sort() { dom(MUIM_List_Sort); };
		void TestPos(LONG p1, LONG p2, struct MUI_List_TestPos_Result *p3) { dom(MUIM_List_TestPos,(ULONG)p1,(ULONG)p2,(ULONG)p3); };
	};

#endif
