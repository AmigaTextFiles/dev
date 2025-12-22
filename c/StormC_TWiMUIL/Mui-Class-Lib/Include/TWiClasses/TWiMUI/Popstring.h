#ifndef TWICPP_TWIMUI_POPSTRING_H
#define TWICPP_TWIMUI_POPSTRING_H

//
//  $VER: Popstring.h   2.0 (10 Feb 1997)
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

#ifndef TWICPP_TWIMUI_GROUP_H
#include <twiclasses/twimui/group.h>
#endif

#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif

///

/// class MUIPopstringCloseHook

class MUIPopstringCloseHook
    {
    private:
        struct MUI_Popstring_CloseHook { Object *str; LONG success; };
        struct Hook closehook;
        static VOID CloseHookEntry(register __a0 struct Hook *, register __a2 Object *, register __a1 struct MUI_Popstring_CloseHook *);
        virtual VOID CloseHookFunc(struct Hook *, Object *, struct MUI_Popstring_CloseHook *);
    protected:
        MUIPopstringCloseHook();
        MUIPopstringCloseHook(const MUIPopstringCloseHook &p);
        ~MUIPopstringCloseHook();
        MUIPopstringCloseHook &operator= (const MUIPopstringCloseHook &);
    public:
        struct Hook *close() { return(&closehook); };
    };

///
/// class MUIPopstringOpenHook

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

///
/// class MUIPopstring

class MUIPopstring
    :   public MUIGroup,
        public MUIPopstringCloseHook,
        public MUIPopstringOpenHook
    {
    protected:
        virtual const ULONG ClassNum() const;
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
        MUIPopstring(const MUIPopstring &);
        virtual ~MUIPopstring();
        MUIPopstring &operator= (const MUIPopstring &);
        Object *ButtonO() const { return((Object *)get(MUIA_Popstring_Button)); };
        VOID CloseHook(const struct Hook *p) { set(MUIA_Popstring_CloseHook,(ULONG)p); };
        struct Hook *CloseHook() const { return((struct Hook *)get(MUIA_Popstring_CloseHook)); };
        VOID OpenHook(const struct Hook *p) { set(MUIA_Popstring_OpenHook,(ULONG)p); };
        struct Hook *OpenHook() const { return((struct Hook *)get(MUIA_Popstring_OpenHook)); };
        Object *StringO() const { return((Object *)get(MUIA_Popstring_String)); };
        VOID Toggle(const BOOL p) { set(MUIA_Popstring_Toggle,(ULONG)p); };
        BOOL Toggle() const { return((BOOL)get(MUIA_Popstring_Toggle,FALSE)); };
        VOID Close(const LONG p) { dom(MUIM_Popstring_Close,(ULONG)p); };
        VOID Open() { dom(MUIM_Popstring_Open,0); };
    };

///

#endif
