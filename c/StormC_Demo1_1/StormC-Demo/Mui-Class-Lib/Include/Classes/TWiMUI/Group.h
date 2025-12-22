//
//  $VER: Group.h       1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_GROUP_H
#define CPP_TWIMUI_GROUP_H

#ifndef CPP_TWIMUI_AREA_H
#include <classes/twimui/area.h>
#endif

#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif

#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif

class MUIGroupLayoutHook
	{
	private:
		struct Hook layouthook;
		static ULONG LayoutHookEntry(register __a0 struct Hook *, register __a2 Object *, register __a1 struct MUI_LayoutMsg *);
		virtual ULONG LayoutHookFunc(struct Hook *, Object *, struct MUI_LayoutMsg *);
	protected:
		MUIGroupLayoutHook();
		MUIGroupLayoutHook(const MUIGroupLayoutHook &p);
		~MUIGroupLayoutHook();
		MUIGroupLayoutHook &operator= (const MUIGroupLayoutHook &);
	public:
		struct Hook *layout() { return(&layouthook); };
	};

class MUIGroup
	:   public MUIArea,
		public MUIGroupLayoutHook
	{
	protected:
		MUIGroup(const STRPTR cl)
			:   MUIArea(cl),
				MUIGroupLayoutHook()
			{ };
	public:
		MUIGroup(const struct TagItem *t)
			:   MUIArea(MUIC_Group),
				MUIGroupLayoutHook()
			{ init(t); };
		MUIGroup(const Tag, ...);
		MUIGroup()
			:   MUIArea(MUIC_Group),
				MUIGroupLayoutHook()
			{ };
		MUIGroup(MUIGroup &p)
			:   MUIArea(p),
				MUIGroupLayoutHook(p)
			{ };
		virtual ~MUIGroup();
		MUIGroup &operator= (MUIGroup &);
		void ActivePage(const LONG p) { set(MUIA_Group_ActivePage,(ULONG)p); };
		void ActivePageFirst() { set(MUIA_Group_ActivePage,MUIV_Group_ActivePage_First); };
		void ActivePageLast() { set(MUIA_Group_ActivePage,MUIV_Group_ActivePage_Last); };
		void ActivePagePrev() { set(MUIA_Group_ActivePage,MUIV_Group_ActivePage_Prev); };
		void ActivePageNext() { set(MUIA_Group_ActivePage,MUIV_Group_ActivePage_Next); };
		LONG ActivePage() const { return((LONG)get(MUIA_Group_ActivePage,0L)); };
		struct List *ChildList() const { return((struct List *)get(MUIA_Group_ChildList,NULL)); };
		void Columns(const LONG p) { set(MUIA_Group_Columns,(ULONG)p); };
		void HorizSpacing(const LONG p) { set(MUIA_Group_HorizSpacing,(ULONG)p); };
		void Rows(const LONG p) { set(MUIA_Group_Rows,(ULONG)p); };
		void VertSpacing(const LONG p) { set(MUIA_Group_VertSpacing,(ULONG)p); };
		void ExitChange() { dom(MUIM_Group_ExitChange,0); };
		APTR InitChange() { return((APTR)dom(MUIM_Group_InitChange,0)); };
		void Add(MUIGroup &p) { dom(OM_ADDMEMBER,(ULONG)((Object *)p)); };
		void Rem(MUIGroup &p) { dom(OM_REMMEMBER,(ULONG)((Object *)p)); };
	};

class MUIGroupV : public MUIGroup
	{
	public:
		MUIGroupV(const struct TagItem *t)
			:   MUIGroup(MUIA_Group_Horiz,FALSE,TAG_MORE,t)
			{ };
		MUIGroupV(const Tag, ...);
		MUIGroupV()
			:   MUIGroup(MUIA_Group_Horiz,FALSE,TAG_DONE)
			{ };
		MUIGroupV(MUIGroupV &p) : MUIGroup(p) { };
		virtual ~MUIGroupV();
		MUIGroupV &operator= (MUIGroupV &);
	};

class MUIGroupH : public MUIGroup
	{
	public:
		MUIGroupH(const struct TagItem *t)
			:   MUIGroup(MUIA_Group_Horiz,TRUE,TAG_MORE,t)
			{ };
		MUIGroupH(const Tag, ...);
		MUIGroupH()
			:   MUIGroup(MUIA_Group_Horiz,TRUE,TAG_DONE)
			{ };
		MUIGroupH(MUIGroupH &p) : MUIGroup(p) { };
		virtual ~MUIGroupH();
		MUIGroupH &operator= (MUIGroupH &);
	};

class MUIGroupCol : public MUIGroup
	{
	public:
		MUIGroupCol(const LONG c, const struct TagItem *t)
			:   MUIGroup(MUIA_Group_Columns,c,TAG_MORE,t)
			{ };
		MUIGroupCol(const LONG, const Tag, ...);
		MUIGroupCol(const LONG c = 0)
			:   MUIGroup(MUIA_Group_Columns,c,TAG_DONE)
			{ };
		MUIGroupCol(MUIGroupCol &p) : MUIGroup(p) { };
		virtual ~MUIGroupCol();
		MUIGroupCol &operator= (MUIGroupCol &);
	};

class MUIGroupRow : public MUIGroup
	{
	public:
		MUIGroupRow(const LONG r, const struct TagItem *t)
			:   MUIGroup(MUIA_Group_Rows,r,TAG_MORE,t)
			{ };
		MUIGroupRow(const LONG, const Tag, ...);
		MUIGroupRow(const LONG r = 0)
			:   MUIGroup(MUIA_Group_Rows,r,TAG_DONE)
			{ };
		MUIGroupRow(MUIGroupRow &p) : MUIGroup(p) { };
		virtual ~MUIGroupRow();
		MUIGroupRow &operator= (MUIGroupRow &p);
	};

#endif
