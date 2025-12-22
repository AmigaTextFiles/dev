//
//  $VER: Menu.h        1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_MENU_H
#define CPP_TWIMUI_MENU_H

#ifndef CPP_TWIMUI_FAMILY_H
#include <classes/twimui/family.h>
#endif

#ifndef LIBRARIES_GADTOOLS_H
#include <libraries/gadtools.h>
#endif

class MUIMenuitem : public MUIFamily
	{
	public:
		MUIMenuitem(const struct TagItem *t) : MUIFamily(MUIC_Menuitem) { init(t); };
		MUIMenuitem(const Tag, ...);
		MUIMenuitem() : MUIFamily(MUIC_Menuitem) { };
		MUIMenuitem(MUIMenuitem &p) : MUIFamily(p) { };
		MUIMenuitem(const STRPTR, const Object *, ...);
		virtual ~MUIMenuitem();
		MUIMenuitem &operator= (MUIMenuitem &);
		void Checked(const BOOL p) { set(MUIA_Menuitem_Checked,(ULONG)p); };
		BOOL Checked() const { return((BOOL)get(MUIA_Menuitem_Checked,FALSE)); };
		void Checkit(const BOOL p) { set(MUIA_Menuitem_Checkit,(ULONG)p); };
		BOOL Checkit() const { return((BOOL)get(MUIA_Menuitem_Checkit,FALSE)); };
		void Enabled(const BOOL p) { set(MUIA_Menuitem_Enabled,(ULONG)p); };
		BOOL Enabled() const { return((BOOL)get(MUIA_Menuitem_Enabled,FALSE)); };
		void Exclude(const LONG p) { set(MUIA_Menuitem_Exclude,(ULONG)p); };
		LONG Exclude() const { return((LONG)get(MUIA_Menuitem_Exclude,0L)); };
		void Shortcut(const STRPTR p) { set(MUIA_Menuitem_Shortcut,(ULONG)p); };
		void ShortcutCheck() { set(MUIA_Menuitem_Shortcut,MUIV_Menuitem_Shortcut_Check); };
		STRPTR Shortcut() const { return((STRPTR)get(MUIA_Menuitem_Shortcut,NULL)); };
		void Title(const STRPTR p) { set(MUIA_Menuitem_Title,(ULONG)p); };
		STRPTR Title() const { return((STRPTR)get(MUIA_Menuitem_Title,NULL)); };
		void Toggle(const BOOL p) { set(MUIA_Menuitem_Toggle,(ULONG)p); };
		BOOL Toggle() const { return((BOOL)get(MUIA_Menuitem_Toggle,FALSE)); };
		struct MenuItem *Trigger() const { return((struct MenuItem *)get(MUIA_Menuitem_Trigger,NULL)); };
	};

class MUIMenusep : public MUIMenuitem
	{
	public:
		MUIMenusep() : MUIMenuitem(MUIA_Menuitem_Title, NM_BARLABEL,TAG_DONE) { };
		MUIMenusep(MUIMenusep &p) : MUIMenuitem(p) { };
		virtual ~MUIMenusep();
		MUIMenusep &operator= (MUIMenusep &);
	};

class MUIMenu : public MUIFamily
	{
	public:
		MUIMenu(const struct TagItem *t) : MUIFamily(MUIC_Menu) { init(t); };
		MUIMenu(const Tag, ...);
		MUIMenu() : MUIFamily(MUIC_Menu) { };
		MUIMenu(MUIMenu &p) : MUIFamily(p) { };
		MUIMenu(const STRPTR, const Object *, ...);
		MUIMenu(const STRPTR, const MUIMenuitem *, ...);
		virtual ~MUIMenu();
		MUIMenu &operator= (MUIMenu &);
		void Enabled(const BOOL p) { set(MUIA_Menu_Enabled,(ULONG)p); };
		BOOL Enabled() const { return((BOOL)get(MUIA_Menu_Enabled,FALSE)); };
		void Title(const STRPTR p) { set(MUIA_Menu_Title,(ULONG)p); };
		STRPTR Title() const { return((STRPTR)get(MUIA_Menu_Title,NULL)); };
	};

class MUIMenustrip : public MUIFamily
	{
	public:
		MUIMenustrip(const struct TagItem *t) : MUIFamily(MUIC_Menustrip) { init(t); };
		MUIMenustrip(const Tag t, ...);
		MUIMenustrip() : MUIFamily(MUIC_Menustrip) { };
		MUIMenustrip(MUIMenustrip &p) : MUIFamily(p) { };
		MUIMenustrip(const Object *, ...);
		MUIMenustrip(const MUIMenu *, ...);
		virtual ~MUIMenustrip();
		MUIMenustrip &operator= (MUIMenustrip &);
		void Enabled(const BOOL p) { set(MUIA_Menustrip_Enabled,(ULONG)p); };
		BOOL Enabled() const { return((BOOL)get(MUIA_Menustrip_Enabled,FALSE)); };
	};

#endif
