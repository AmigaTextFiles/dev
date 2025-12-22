#ifndef TWICPP_TWIMUI_MENU_H
#define TWICPP_TWIMUI_MENU_H

//
//  $VER: Menu.h        2.0 (10 Feb 1997)
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
//                        - Der Konstruktor:
//                          MUIMenuitem(const STRPTR, const MUIMenuitem *, ...);
//                        - Die Methode MUIMenuitem::CommandString wurde für MUI 3.6 hinzugefügt.
//                        - ClassNum() für Exception-Handling.
//                        Änderungen:
//                        - Parameter des Copy-Konstruktor als 'const'-Parameter definiert
//

/// Includes

#ifndef TWICPP_TWIMUI_FAMILY_H
#include <twiclasses/twimui/family.h>
#endif

#ifndef LIBRARIES_GADTOOLS_H
#include <libraries/gadtools.h>
#endif

///

/// class MUIMenuitem

class MUIMenuitem : public MUIFamily
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIMenuitem(const struct TagItem *t) : MUIFamily(MUIC_Menuitem) { init(t); };
        MUIMenuitem(const Tag, ...);
        MUIMenuitem() : MUIFamily(MUIC_Menuitem) { };
        MUIMenuitem(const MUIMenuitem &);
        MUIMenuitem(const STRPTR, const Object *, ...);
        MUIMenuitem(const STRPTR, const MUIMenuitem *, ...);
        virtual ~MUIMenuitem();
        MUIMenuitem &operator= (const MUIMenuitem &);
        VOID Checked(const BOOL p) { set(MUIA_Menuitem_Checked,(ULONG)p); };
        BOOL Checked() const { return((BOOL)get(MUIA_Menuitem_Checked,FALSE)); };
        VOID Checkit(const BOOL p) { set(MUIA_Menuitem_Checkit,(ULONG)p); };
        BOOL Checkit() const { return((BOOL)get(MUIA_Menuitem_Checkit,FALSE)); };
        VOID CommandString(const BOOL p) { set(MUIA_Menuitem_CommandString,(ULONG)p); };
        BOOL CommandString() const { return((BOOL)get(MUIA_Menuitem_CommandString,FALSE)); };
        VOID Enabled(const BOOL p) { set(MUIA_Menuitem_Enabled,(ULONG)p); };
        BOOL Enabled() const { return((BOOL)get(MUIA_Menuitem_Enabled,FALSE)); };
        VOID Exclude(const LONG p) { set(MUIA_Menuitem_Exclude,(ULONG)p); };
        LONG Exclude() const { return((LONG)get(MUIA_Menuitem_Exclude,0L)); };
        VOID Shortcut(const STRPTR p) { set(MUIA_Menuitem_Shortcut,(ULONG)p); };
        VOID ShortcutCheck() { set(MUIA_Menuitem_Shortcut,MUIV_Menuitem_Shortcut_Check); };
        STRPTR Shortcut() const { return((STRPTR)get(MUIA_Menuitem_Shortcut,NULL)); };
        VOID Title(const STRPTR p) { set(MUIA_Menuitem_Title,(ULONG)p); };
        STRPTR Title() const { return((STRPTR)get(MUIA_Menuitem_Title,NULL)); };
        VOID Toggle(const BOOL p) { set(MUIA_Menuitem_Toggle,(ULONG)p); };
        BOOL Toggle() const { return((BOOL)get(MUIA_Menuitem_Toggle,FALSE)); };
        struct MenuItem *Trigger() const { return((struct MenuItem *)get(MUIA_Menuitem_Trigger,NULL)); };
    };

///
/// class MUIMenusep

class MUIMenusep : public MUIMenuitem
    {
    public:
        MUIMenusep() : MUIMenuitem(MUIA_Menuitem_Title, NM_BARLABEL,TAG_DONE) { };
        MUIMenusep(const MUIMenusep &p) : MUIMenuitem((MUIMenuitem &)p) { };
        virtual ~MUIMenusep();
        MUIMenusep &operator= (const MUIMenusep &);
    };

///
/// class MUIMenu

class MUIMenu : public MUIFamily
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIMenu(const struct TagItem *t) : MUIFamily(MUIC_Menu) { init(t); };
        MUIMenu(const Tag, ...);
        MUIMenu() : MUIFamily(MUIC_Menu) { };
        MUIMenu(const MUIMenu &);
        MUIMenu(const STRPTR, const Object *, ...);
        MUIMenu(const STRPTR, const MUIMenuitem *, ...);
        virtual ~MUIMenu();
        MUIMenu &operator= (const MUIMenu &);
        VOID Enabled(const BOOL p) { set(MUIA_Menu_Enabled,(ULONG)p); };
        BOOL Enabled() const { return((BOOL)get(MUIA_Menu_Enabled,FALSE)); };
        VOID Title(const STRPTR p) { set(MUIA_Menu_Title,(ULONG)p); };
        STRPTR Title() const { return((STRPTR)get(MUIA_Menu_Title,NULL)); };
    };

///
/// class MUIMenustrip

class MUIMenustrip : public MUIFamily
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIMenustrip(const struct TagItem *t) : MUIFamily(MUIC_Menustrip) { init(t); };
        MUIMenustrip(const Tag t, ...);
        MUIMenustrip() : MUIFamily(MUIC_Menustrip) { };
        MUIMenustrip(const MUIMenustrip &);
        MUIMenustrip(const Object *, ...);
        MUIMenustrip(const MUIMenu *, ...);
        virtual ~MUIMenustrip();
        MUIMenustrip &operator= (const MUIMenustrip &);
        VOID Enabled(const BOOL p) { set(MUIA_Menustrip_Enabled,(ULONG)p); };
        BOOL Enabled() const { return((BOOL)get(MUIA_Menustrip_Enabled,FALSE)); };
    };

///

#endif
