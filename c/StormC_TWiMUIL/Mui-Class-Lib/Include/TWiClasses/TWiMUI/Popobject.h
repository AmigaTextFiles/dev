#ifndef TWICPP_TWIMUI_POPOBJECT_H
#define TWICPP_TWIMUI_POPOBJECT_H

//
//  $VER: Popobject.h   2.0 (10 Feb 1997)
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

#ifndef TWICPP_TWIMUI_POPSTRING_H
#include <twiclasses/twimui/popstring.h>
#endif

#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif

///

/// class MUIPopobjectObjStrHook

class MUIPopobjectObjStrHook
    {
    private:
        struct Hook objstrhook;
        static VOID ObjStrHookEntry(register __a0 struct Hook *, register __a2 Object *, register __a1 Object *);
        virtual VOID ObjStrHookFunc(struct Hook *, Object *, Object *);
    protected:
        MUIPopobjectObjStrHook();
        MUIPopobjectObjStrHook(const MUIPopobjectObjStrHook &p);
        ~MUIPopobjectObjStrHook();
        MUIPopobjectObjStrHook &operator= (const MUIPopobjectObjStrHook &);
    public:
        struct Hook *objstr() { return(&objstrhook); };
    };

///
/// class MUIPopobjectStrObjHook

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

///
/// class MUIPopobjectWindowHook

class MUIPopobjectWindowHook
    {
    private:
        struct Hook windowhook;
        static VOID WindowHookEntry(register __a0 struct Hook *, register __a2 Object *, register __a1 Object *);
        virtual VOID WindowHookFunc(struct Hook *, Object *, Object *);
    protected:
        MUIPopobjectWindowHook();
        MUIPopobjectWindowHook(const MUIPopobjectWindowHook &p);
        ~MUIPopobjectWindowHook();
        MUIPopobjectWindowHook &operator= (const MUIPopobjectWindowHook &);
    public:
        struct Hook *window() { return(&windowhook); };
    };

///
/// class MUIPopobject

class MUIPopobject
    :   public MUIPopstring,
        public MUIPopobjectObjStrHook,
        public MUIPopobjectStrObjHook,
        public MUIPopobjectWindowHook
    {
    protected:
        virtual const ULONG ClassNum() const;
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
        MUIPopobject(const MUIPopobject &);
        virtual ~MUIPopobject();
        MUIPopobject &operator= (const MUIPopobject &);
        VOID Follow(const BOOL p) { set(MUIA_Popobject_Follow,(ULONG)p); };
        BOOL Follow() const { return((BOOL)get(MUIA_Popobject_Follow,FALSE)); };
        VOID Light(const BOOL p) { set(MUIA_Popobject_Light,(ULONG)p); };
        BOOL Light() const { return((BOOL)get(MUIA_Popobject_Light,TRUE)); };
        Object *ObjectP() const { return((Object *)get(MUIA_Popobject_Object,NULL)); };
        VOID ObjStrHook(const struct Hook *p) { set(MUIA_Popobject_ObjStrHook,(ULONG)p); };
        struct Hook *ObjStrHook() const { return((struct Hook *)get(MUIA_Popobject_ObjStrHook,TRUE)); };
        VOID StrObjHook(const struct Hook *p) { set(MUIA_Popobject_StrObjHook,(ULONG)p); };
        struct Hook *StrObjHook() const { return((struct Hook *)get(MUIA_Popobject_StrObjHook,TRUE)); };
        VOID Volatile(const BOOL p) { set(MUIA_Popobject_Volatile,(ULONG)p); };
        BOOL Volatile() const { return((BOOL)get(MUIA_Popobject_Volatile,TRUE)); };
        VOID WindowHook(const struct Hook *p) { set(MUIA_Popobject_WindowHook,(ULONG)p); };
        struct Hook *WindowHook() const { return((struct Hook *)get(MUIA_Popobject_WindowHook,TRUE)); };
    };

///

#endif
