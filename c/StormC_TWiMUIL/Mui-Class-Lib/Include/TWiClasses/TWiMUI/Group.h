#ifndef TWICPP_TWIMUI_GROUP_H
#define TWICPP_TWIMUI_GROUP_H

//
//  $VER: Group.h       2.0 (10 Feb 1997)
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
//                        - MUIGroupH::MUIGroupH();
//                          MUIGroupV::MUIGroupV();
//                          MUIGroupCol::MUIGroupCol(const LONG);
//                          MUIGroupRow::MUIGroupRow(const LONG);
//                          Bei diesen Konstruktoren war ein Fehler der dazu führte, daß
//                          die Methode Create() die falschen Parameter bekam.
//                        Änderungen:
//                        - Add(), Rem()
//                          Der Parameter wurde von 'MUIGroup &' auf 'Object *' geändert.
//
//  02 Sep 1996 :   1.2 : Bug Fixes:
//                        - MUIGroupH::MUIGroupH();
//                          MUIGroupV::MUIGroupV();
//                          MUIGroupCol::MUIGroupCol(const LONG);
//                          MUIGroupRow::MUIGroupRow(const LONG);
//                          Die Konstruktoren mit Parameter 'struct TagItem *' und NULL
//                          als Wert hatten TAG_MORE mit NULL als Zeiger.
//                        Neu:
//                        - Die Methode Sort() wurde für MUI 3.6 hinzugefügt.
//                        - ClassNum() für Exception-Handling.
//                        Änderungen:
//                        - Parameter des Copy-Konstruktor als 'const'-Parameter definiert
//

/// Includes

#ifndef TWICPP_TWIMUI_AREA_H
#include <twiclasses/twimui/area.h>
#endif

#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif

#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif

///

/// class MUIGroupLayoutHook

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

///
/// class MUIGroup

class MUIGroup
    :   public MUIArea,
        public MUIGroupLayoutHook
    {
    protected:
        virtual const ULONG ClassNum() const;
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
        MUIGroup(const MUIGroup &);
        virtual ~MUIGroup();
        MUIGroup &operator= (const MUIGroup &);
        VOID ActivePage(const LONG p) { set(MUIA_Group_ActivePage,(ULONG)p); };
        VOID ActivePageFirst() { set(MUIA_Group_ActivePage,MUIV_Group_ActivePage_First); };
        VOID ActivePageLast() { set(MUIA_Group_ActivePage,MUIV_Group_ActivePage_Last); };
        VOID ActivePagePrev() { set(MUIA_Group_ActivePage,MUIV_Group_ActivePage_Prev); };
        VOID ActivePageNext() { set(MUIA_Group_ActivePage,MUIV_Group_ActivePage_Next); };
        LONG ActivePage() const { return((LONG)get(MUIA_Group_ActivePage,0L)); };
        struct List *ChildList() const { return((struct List *)get(MUIA_Group_ChildList,NULL)); };
        VOID Columns(const LONG p) { set(MUIA_Group_Columns,(ULONG)p); };
        VOID HorizSpacing(const LONG p) { set(MUIA_Group_HorizSpacing,(ULONG)p); };
        VOID Rows(const LONG p) { set(MUIA_Group_Rows,(ULONG)p); };
        VOID VertSpacing(const LONG p) { set(MUIA_Group_VertSpacing,(ULONG)p); };
        VOID ExitChange() { dom(MUIM_Group_ExitChange,0); };
        APTR InitChange() { return((APTR)dom(MUIM_Group_InitChange,0)); };
        VOID Sort(Object *, ...);
        VOID Add(Object *p) { dom(OM_ADDMEMBER,(ULONG)p); };
        VOID Rem(Object *p) { dom(OM_REMMEMBER,(ULONG)p); };
    };

///
/// class MUIGroupV

class MUIGroupV : public MUIGroup
    {
    public:
        MUIGroupV(const struct TagItem *);
        MUIGroupV(const Tag, ...);
        MUIGroupV() : MUIGroup() { Tags.append(MUIA_Group_Horiz,FALSE,TAG_DONE); };
        MUIGroupV(const MUIGroupV &p) : MUIGroup((MUIGroup &)p) { };
        virtual ~MUIGroupV();
        MUIGroupV &operator= (const MUIGroupV &);
    };

///
/// class MUIGroupH

class MUIGroupH : public MUIGroup
    {
    public:
        MUIGroupH(const struct TagItem *);
        MUIGroupH(const Tag, ...);
        MUIGroupH() : MUIGroup() { Tags.append(MUIA_Group_Horiz,TRUE,TAG_DONE); };
        MUIGroupH(const MUIGroupH &p) : MUIGroup((MUIGroup &)p) { };
        virtual ~MUIGroupH();
        MUIGroupH &operator= (const MUIGroupH &);
    };

///
/// class MUIGroupCol

class MUIGroupCol : public MUIGroup
    {
    public:
        MUIGroupCol(const LONG c, const struct TagItem *);
        MUIGroupCol(const LONG, const Tag, ...);
        MUIGroupCol(const LONG c = 0) : MUIGroup() { Tags.append(MUIA_Group_Columns,c,TAG_DONE); };
        MUIGroupCol(const MUIGroupCol &p) : MUIGroup((MUIGroup &)p) { };
        virtual ~MUIGroupCol();
        MUIGroupCol &operator= (const MUIGroupCol &);
    };

///
/// class MUIGroupRow

class MUIGroupRow : public MUIGroup
    {
    public:
        MUIGroupRow(const LONG r, const struct TagItem *);
        MUIGroupRow(const LONG, const Tag, ...);
        MUIGroupRow(const LONG r = 0) : MUIGroup() { Tags.append(MUIA_Group_Rows,r,TAG_DONE); };
        MUIGroupRow(const MUIGroupRow &p) : MUIGroup((MUIGroup &)p) { };
        virtual ~MUIGroupRow();
        MUIGroupRow &operator= (const MUIGroupRow &p);
    };

///

#endif
