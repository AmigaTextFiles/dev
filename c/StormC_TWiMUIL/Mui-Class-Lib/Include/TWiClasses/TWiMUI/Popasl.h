#ifndef TWICPP_TWIMUI_POPASL_H
#define TWICPP_TWIMUI_POPASL_H

//
//  $VER: Popasl.h      2.0 (10 Feb 1997)
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
//  26 Nov 1996 :   1.3 : BugFix:
//                        - Parameter von MUIPopaslStartHookEntry::StartHookEntry() korrigiert.
//

/// Includes

#ifndef TWICPP_TWIMUI_POPSTRING_H
#include <twiclasses/twimui/popstring.h>
#endif

#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif

///

/// class MUIPopaslStartHook

class MUIPopaslStartHook
    {
    private:
        struct Hook starthook;
        static BOOL StartHookEntry(register __a0 struct Hook *, register __a2 Object *, register __a1 struct TagItem *);
        virtual BOOL StartHookFunc(struct Hook *, Object *, struct TagItem *);
    protected:
        MUIPopaslStartHook();
        MUIPopaslStartHook(const MUIPopaslStartHook &p);
        ~MUIPopaslStartHook();
        MUIPopaslStartHook &operator= (const MUIPopaslStartHook &);
    public:
        struct Hook *start() { return(&starthook); };
    };

///
/// class MUIPopaslStopHook

class MUIPopaslStopHook
    {
    private:
        struct Hook stophookFile;
        struct Hook stophookFont;
        struct Hook stophookScreenMode;
        static VOID StopHookEntryFile(register __a0 struct Hook *, register __a2 Object *, register __a1 struct FileRequester *);
        static VOID StopHookEntryFont(register __a0 struct Hook *, register __a2 Object *, register __a1 struct FontRequester *);
        static VOID StopHookEntryScreenMode(register __a0 struct Hook *, register __a2 Object *, register __a1 struct ScreenModeRequester *);
        virtual VOID StopHookFunc(struct Hook *, Object *, struct FileRequester *);
        virtual VOID StopHookFunc(struct Hook *, Object *, struct FontRequester *);
        virtual VOID StopHookFunc(struct Hook *, Object *, struct ScreenModeRequester *);
    protected:
        MUIPopaslStopHook();
        MUIPopaslStopHook(const MUIPopaslStopHook &p);
        ~MUIPopaslStopHook();
        MUIPopaslStopHook &operator= (const MUIPopaslStopHook &);
    public:
        struct Hook *stopFile() { return(&stophookFile); };
        struct Hook *stopFont() { return(&stophookFont); };
        struct Hook *stopScreenMode() { return(&stophookScreenMode); };
    };

///
/// class MUIPopasl

class MUIPopasl
    :   public MUIPopstring,
        public MUIPopaslStartHook,
        public MUIPopaslStopHook
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIPopasl(const struct TagItem *t)
            :   MUIPopstring(MUIC_Popasl),
                MUIPopaslStartHook(),
                MUIPopaslStopHook()
            {
            init(t);
            };
        MUIPopasl(const Tag, ...);
        MUIPopasl()
            :   MUIPopstring(MUIC_Popasl),
                MUIPopaslStartHook(),
                MUIPopaslStopHook()
            { };
        MUIPopasl(const MUIPopasl &);
        virtual ~MUIPopasl();
        MUIPopasl &operator= (const MUIPopasl &);
        BOOL Active() const { return((BOOL)get(MUIA_Popasl_Active,FALSE)); };
        VOID StartHook(const struct Hook *p) { set(MUIA_Popasl_StartHook,(ULONG)p); };
        struct Hook *StartHook() const { return((struct Hook *)get(MUIA_Popasl_StartHook)); };
        VOID StopHook(const struct Hook *p) { set(MUIA_Popasl_StopHook,(ULONG)p); };
        struct Hook *StopHook() const { return((struct Hook *)get(MUIA_Popasl_StopHook)); };
        ULONG Type() const { return(get(MUIA_Popasl_Type,0UL)); };
    };

///

#endif
