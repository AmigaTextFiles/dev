//
//  $VER: Popstring.h   1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_POPSTRING_H
#define CPP_TWIMUI_POPSTRING_H

#ifndef CPP_TWIMUI_GROUP_H
#include <classes/twimui/group.h>
#endif

#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif

class MUIPopstringCloseHook
	{
	private:
		struct MUI_Popstring_CloseHook { Object *str; LONG success; };
		struct Hook closehook;
		static void CloseHookEntry(register __a0 struct Hook *, register __a2 Object *, register __a1 struct MUI_Popstring_CloseHook *);
		virtual void CloseHookFunc(struct Hook *, Object *, struct MUI_Popstring_CloseHook *);
	protected:
		MUIPopstringCloseHook();
		MUIPopstringCloseHook(const MUIPopstringCloseHook &p);
		~MUIPopstringCloseHook();
		MUIPopstringCloseHook &operator= (const MUIPopstringCloseHook &);
	public:
		struct Hook *close() { return(&closehook); };
	};

class MUIPopstringOpenHook
	{
	private:
		struct Hook openhook;
		static BOOL OpenHookEntry(register __a0 struct Hook *, register __a2 Object *, register __a1 Object **);
		virtual BOOL OpenHookFunc(struct Hook *, Object *, Object **);
	protected:
		MUIPopstringOpenHook();
		MUIPopstringOpenHook(const MUIPopstringOpenHook &p);
		~MUIPopstringOpenHook();
		MUIPopstringOpenHook &operator= (const MUIPopstringOpenHook &);
	public:
		struct Hook *open() { return(&openhook); };
	};

class MUIPopstring
	:   public MUIGroup,
		public MUIPopstringCloseHook,
		public MUIPopstringOpenHook
	{
	protected:
		MUIPopstring(STRPTR cl)
			:   MUIGroup(cl),
				MUIPopstringCloseHook(),
				MUIPopstringOpenHook()
			{ };
	public:
		MUIPopstring(const struct TagItem *t)
			:   MUIGroup(MUIC_Popstring),
				MUIPopstringCloseHook(),
				MUIPopstringOpenHook()
			{
			init(t);
			};
		MUIPopstring(const Tag, ...);
		MUIPopstring()
			:   MUIGroup(MUIC_Popstring),
				MUIPopstringCloseHook(),
				MUIPopstringOpenHook()
			{ };
		MUIPopstring(MUIPopstring &p)
			:   MUIGroup(p),
				MUIPopstringCloseHook(p),
				MUIPopstringOpenHook(p)
			{ };
		virtual ~MUIPopstring();
		MUIPopstring &operator= (MUIPopstring &);
		Object *ButtonO() const { return((Object *)get(MUIA_Popstring_Button)); };
		void CloseHook(const struct Hook *p) { set(MUIA_Popstring_CloseHook,(ULONG)p); };
		struct Hook *CloseHook() const { return((struct Hook *)get(MUIA_Popstring_CloseHook)); };
		void OpenHook(const struct Hook *p) { set(MUIA_Popstring_OpenHook,(ULONG)p); };
		struct Hook *OpenHook() const { return((struct Hook *)get(MUIA_Popstring_OpenHook)); };
		Object *StringO() const { return((Object *)get(MUIA_Popstring_String)); };
		void Toggle(const BOOL p) { set(MUIA_Popstring_Toggle,(ULONG)p); };
		BOOL Toggle() const { return((BOOL)get(MUIA_Popstring_Toggle,FALSE)); };
		void Close(const LONG p) { dom(MUIM_Popstring_Close,(ULONG)p); };
		void Open() { dom(MUIM_Popstring_Open,0); };
	};

#endif
