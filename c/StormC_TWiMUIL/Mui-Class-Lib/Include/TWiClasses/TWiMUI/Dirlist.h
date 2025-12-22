#ifndef TWICPP_TWIMUI_DIRLIST_H
#define TWICPP_TWIMUI_DIRLIST_H

//
//  $VER: Dirlist.h     2.0 (10 Feb 1997)
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
//                        - ClassNum() für Exception-Handling.
//                        Änderungen:
//                        - Parameter des Copy-Konstruktor als 'const'-Parameter definiert
//

/// Includes

#ifndef TWICPP_TWIMUI_LIST_H
#include <twiclasses/twimui/list.h>
#endif

///

/// class MUIDirlistFilterHook

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

///
/// class MUIDirlist

class MUIDirlist
    :   public MUIList,
        public MUIDirlistFilterHook
    {
    protected:
        virtual const ULONG ClassNum() const;
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
        MUIDirlist(const MUIDirlist &);
        virtual ~MUIDirlist();
        MUIDirlist &operator= (const MUIDirlist &);
        VOID AcceptPattern(const STRPTR p) { set(MUIA_Dirlist_AcceptPattern,(ULONG)p); };
        VOID Directory(const STRPTR p) { set(MUIA_Dirlist_Directory,(ULONG)p); };
        STRPTR Directory() const { return((STRPTR)get(MUIA_Dirlist_Directory,NULL)); };
        VOID DrawersOnly(const BOOL p) { set(MUIA_Dirlist_DrawersOnly,(ULONG)p); };
        VOID FilesOnly(const BOOL p) { set(MUIA_Dirlist_FilesOnly,(ULONG)p); };
        VOID FilterDrawers(const BOOL p) { set(MUIA_Dirlist_FilterDrawers,(ULONG)p); };
        VOID FilterHook(const struct Hook *p) { set(MUIA_Dirlist_FilterHook,(ULONG)p); };
        VOID MultiSelDirs(const BOOL p) { set(MUIA_Dirlist_MultiSelDirs,(ULONG)p); };
        LONG NumBytes() const { return((LONG)get(MUIA_Dirlist_NumBytes,0L)); };
        LONG NumDrawers() const { return((LONG)get(MUIA_Dirlist_NumDrawers,0L)); };
        LONG NumFiles() const { return((LONG)get(MUIA_Dirlist_NumFiles,0L)); };
        STRPTR Path() const { return((STRPTR)get(MUIA_Dirlist_Path,NULL)); };
        VOID RejectIcons(const BOOL p) { set(MUIA_Dirlist_RejectIcons,(ULONG)p); };
        VOID RejectPattern(const STRPTR p) { set(MUIA_Dirlist_RejectPattern,(ULONG)p); };
        VOID SortDirs(const LONG p) { set(MUIA_Dirlist_SortDirs,(ULONG)p); };
        VOID SortHighLow(const BOOL p) { set(MUIA_Dirlist_SortHighLow,(ULONG)p); };
        VOID SortType(const LONG p) { set(MUIA_Dirlist_SortType,(ULONG)p); };
        LONG Status() const { return((LONG)get(MUIA_Dirlist_Status,0L)); };
        VOID ReRead() { dom(MUIM_Dirlist_ReRead); };
    };

///

#endif
