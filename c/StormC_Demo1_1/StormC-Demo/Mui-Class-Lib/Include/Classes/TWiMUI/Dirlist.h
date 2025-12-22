//
//  $VER: Dirlist.h     1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_DIRLIST_H
#define CPP_TWIMUI_DIRLIST_H

#ifndef CPP_TWIMUI_LIST_H
#include <classes/twimui/list.h>
#endif

class MUIDirlistFilterHook
	{
	private:
		struct Hook filterhook;
		static BOOL FilterHookEntry(register __a0 struct Hook *, register __a2 Object *, register __a1 struct ExAllData *);
		virtual BOOL FilterHookFunc(struct Hook *, Object *, struct ExAllData *);
	protected:
		MUIDirlistFilterHook();
		MUIDirlistFilterHook(const MUIDirlistFilterHook &p);
		~MUIDirlistFilterHook();
		MUIDirlistFilterHook &operator= (const MUIDirlistFilterHook &);
	public:
		struct Hook *filter() { return(&filterhook); };
	};

class MUIDirlist
	:   public MUIList,
		public MUIDirlistFilterHook
	{
	public:
		MUIDirlist(const struct TagItem *t)
			:   MUIList(MUIC_Dirlist),
				MUIDirlistFilterHook()
			{
			init(t);
			};
		MUIDirlist(const Tag, ...);
		MUIDirlist()
			:   MUIList(MUIC_Dirlist),
				MUIDirlistFilterHook()
			{ };
		MUIDirlist(MUIDirlist &p)
			:   MUIList(p),
				MUIDirlistFilterHook(p)
			{ };
		virtual ~MUIDirlist();
		MUIDirlist &operator= (MUIDirlist &);
		void AcceptPattern(const STRPTR p) { set(MUIA_Dirlist_AcceptPattern,(ULONG)p); };
		void Directory(const STRPTR p) { set(MUIA_Dirlist_Directory,(ULONG)p); };
		STRPTR Directory() const { return((STRPTR)get(MUIA_Dirlist_Directory,NULL)); };
		void DrawersOnly(const BOOL p) { set(MUIA_Dirlist_DrawersOnly,(ULONG)p); };
		void FilesOnly(const BOOL p) { set(MUIA_Dirlist_FilesOnly,(ULONG)p); };
		void FilterDrawers(const BOOL p) { set(MUIA_Dirlist_FilterDrawers,(ULONG)p); };
		void FilterHook(const struct Hook *p) { set(MUIA_Dirlist_FilterHook,(ULONG)p); };
		void MultiSelDirs(const BOOL p) { set(MUIA_Dirlist_MultiSelDirs,(ULONG)p); };
		LONG NumBytes() const { return((LONG)get(MUIA_Dirlist_NumBytes,0L)); };
		LONG NumDrawers() const { return((LONG)get(MUIA_Dirlist_NumDrawers,0L)); };
		LONG NumFiles() const { return((LONG)get(MUIA_Dirlist_NumFiles,0L)); };
		STRPTR Path() const { return((STRPTR)get(MUIA_Dirlist_Path,NULL)); };
		void RejectIcons(const BOOL p) { set(MUIA_Dirlist_RejectIcons,(ULONG)p); };
		void RejectPattern(const STRPTR p) { set(MUIA_Dirlist_RejectPattern,(ULONG)p); };
		void SortDirs(const LONG p) { set(MUIA_Dirlist_SortDirs,(ULONG)p); };
		void SortHighLow(const BOOL p) { set(MUIA_Dirlist_SortHighLow,(ULONG)p); };
		void SortType(const LONG p) { set(MUIA_Dirlist_SortType,(ULONG)p); };
		LONG Status() const { return((LONG)get(MUIA_Dirlist_Status,0L)); };
		void ReRead() { dom(MUIM_Dirlist_ReRead); };
	};

#endif
