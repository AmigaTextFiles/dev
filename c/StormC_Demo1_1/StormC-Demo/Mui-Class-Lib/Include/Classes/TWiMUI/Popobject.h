//
//  $VER: Popobject.h   1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_POPOBJECT_H
#define CPP_TWIMUI_POPOBJECT_H

#ifndef CPP_TWIMUI_POPSTRING_H
#include <classes/twimui/popstring.h>
#endif

#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif

class MUIPopobjectObjStrHook
	{
	private:
		struct Hook objstrhook;
		static void ObjStrHookEntry(register __a0 struct Hook *, register __a2 Object *, register __a1 Object *);
		virtual void ObjStrHookFunc(struct Hook *, Object *, Object *);
	protected:
		MUIPopobjectObjStrHook();
		MUIPopobjectObjStrHook(const MUIPopobjectObjStrHook &p);
		~MUIPopobjectObjStrHook();
		MUIPopobjectObjStrHook &operator= (const MUIPopobjectObjStrHook &);
	public:
		struct Hook *objstr() { return(&objstrhook); };
	};

class MUIPopobjectStrObjHook
	{
	private:
		struct Hook strobjhook;
		static BOOL StrObjHookEntry(register __a0 struct Hook *, register __a2 Object *, register __a1 Object *);
		virtual BOOL StrObjHookFunc(struct Hook *, Object *, Object *);
	protected:
		MUIPopobjectStrObjHook();
		MUIPopobjectStrObjHook(const MUIPopobjectStrObjHook &p);
		~MUIPopobjectStrObjHook();
		MUIPopobjectStrObjHook &operator= (const MUIPopobjectStrObjHook &);
	public:
		struct Hook *strobj() { return(&strobjhook); };
	};

class MUIPopobjectWindowHook
	{
	private:
		struct Hook windowhook;
		static void WindowHookEntry(register __a0 struct Hook *, register __a2 Object *, register __a1 Object *);
		virtual void WindowHookFunc(struct Hook *, Object *, Object *);
	protected:
		MUIPopobjectWindowHook();
		MUIPopobjectWindowHook(const MUIPopobjectWindowHook &p);
		~MUIPopobjectWindowHook();
		MUIPopobjectWindowHook &operator= (const MUIPopobjectWindowHook &);
	public:
		struct Hook *window() { return(&windowhook); };
	};

class MUIPopobject
	:   public MUIPopstring,
		public MUIPopobjectObjStrHook,
		public MUIPopobjectStrObjHook,
		public MUIPopobjectWindowHook
	{
	protected:
		MUIPopobject(STRPTR cl)
			:   MUIPopstring(cl),
				MUIPopobjectObjStrHook(),
				MUIPopobjectStrObjHook(),
				MUIPopobjectWindowHook()
			{ };
	public:
		MUIPopobject(const struct TagItem *t)
			:   MUIPopstring(MUIC_Popobject),
				MUIPopobjectObjStrHook(),
				MUIPopobjectStrObjHook(),
				MUIPopobjectWindowHook()
			{
			init(t);
			};
		MUIPopobject(const Tag, ...);
		MUIPopobject()
			:   MUIPopstring(MUIC_Popobject),
				MUIPopobjectObjStrHook(),
				MUIPopobjectStrObjHook(),
				MUIPopobjectWindowHook()
			{ };
		MUIPopobject(MUIPopobject &p)
			:   MUIPopstring(p),
				MUIPopobjectObjStrHook(p),
				MUIPopobjectStrObjHook(p),
				MUIPopobjectWindowHook(p)
			{ };
		virtual ~MUIPopobject();
		MUIPopobject &operator= (MUIPopobject &);
		void Follow(const BOOL p) { set(MUIA_Popobject_Follow,(ULONG)p); };
		BOOL Follow() const { return((BOOL)get(MUIA_Popobject_Follow,FALSE)); };
		void Light(const BOOL p) { set(MUIA_Popobject_Light,(ULONG)p); };
		BOOL Light() const { return((BOOL)get(MUIA_Popobject_Light,TRUE)); };
		Object *ObjectP() const { return((Object *)get(MUIA_Popobject_Object,NULL)); };
		void ObjStrHook(const struct Hook *p) { set(MUIA_Popobject_ObjStrHook,(ULONG)p); };
		struct Hook *ObjStrHook() const { return((struct Hook *)get(MUIA_Popobject_ObjStrHook,TRUE)); };
		void StrObjHook(const struct Hook *p) { set(MUIA_Popobject_StrObjHook,(ULONG)p); };
		struct Hook *StrObjHook() const { return((struct Hook *)get(MUIA_Popobject_StrObjHook,TRUE)); };
		void Volatile(const BOOL p) { set(MUIA_Popobject_Volatile,(ULONG)p); };
		BOOL Volatile() const { return((BOOL)get(MUIA_Popobject_Volatile,TRUE)); };
		void WindowHook(const struct Hook *p) { set(MUIA_Popobject_WindowHook,(ULONG)p); };
		struct Hook *WindowHook() const { return((struct Hook *)get(MUIA_Popobject_WindowHook,TRUE)); };
	};

#endif
