#ifndef TWICPP_TWIMUI_STRING_H
#define TWICPP_TWIMUI_STRING_H

//
//  $VER: String.h      2.0 (10 Feb 1997)
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
//  10 Feb 1997 :   2.0 : Änderungen:
//                        - Anpassungen an MUI 3.7
//

/// Includes

#ifndef TWICPP_TWIMUI_GADGET_H
#include <twiclasses/twimui/gadget.h>
#endif

#ifndef TWICPP_TWIMUI_LABEL_H
#include <twiclasses/twimui/label.h>
#endif

#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif

///

/// class MUIStringEditHook

class MUIStringEditHook
    {
    private:
        struct Hook edithook;
        static VOID EditHookEntry(register __a0 struct Hook *, register __a2 struct SGWork *, register __a1 Msg);
        virtual VOID EditHookFunc(struct Hook *, struct SGWork *, Msg);
    protected:
        MUIStringEditHook();
        MUIStringEditHook(const MUIStringEditHook &p);
        ~MUIStringEditHook();
        MUIStringEditHook &operator= (const MUIStringEditHook &);
    public:
        struct Hook *edit() { return(&edithook); };
    };

///
/// class MUIString

class MUIString
    :   public MUIGadget,
        public MUIStringEditHook
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIString(const struct TagItem *t)
            :   MUIGadget(MUIC_String),
                MUIStringEditHook()
            {
            init(t);
            };
        MUIString(const Tag, ...);
        MUIString(const STRPTR cont, const ULONG len)
            :   MUIGadget(MUIC_String),
                MUIStringEditHook()
            {
            init(MUIA_String_Contents, cont,
                MUIA_String_MaxLen, len,
                MUIA_Frame, MUIV_Frame_String,
                TAG_DONE);
            };
        MUIString(const STRPTR cont, const ULONG len, const UBYTE cc)
            :   MUIGadget(MUIC_String),
                MUIStringEditHook()
            {
            init(MUIA_String_Contents, cont,
                MUIA_String_MaxLen, len,
                MUIA_ControlChar, cc,
                MUIA_Frame, MUIV_Frame_String,
                TAG_DONE);
            };
        MUIString(const ULONG cont, const ULONG len)
            :   MUIGadget(MUIC_String),
                MUIStringEditHook()
            {
            init(MUIA_String_Integer, cont,
                MUIA_String_Accept,"1234567890-+",
                MUIA_String_MaxLen, len,
                MUIA_Frame, MUIV_Frame_String,
                TAG_DONE);
            };
        MUIString(const ULONG len)
            :   MUIGadget(MUIC_String),
                MUIStringEditHook()
            {
            init(MUIA_String_Accept,"1234567890-+",
                MUIA_String_MaxLen, len,
                MUIA_Frame, MUIV_Frame_String,
                TAG_DONE);
            };
        MUIString(const ULONG cont, const ULONG len, const UBYTE cc)
            :   MUIGadget(MUIC_String),
                MUIStringEditHook()
            {
            init(MUIA_String_Integer, cont,
                MUIA_String_Accept,"1234567890-+",
                MUIA_String_MaxLen, len,
                MUIA_ControlChar, cc,
                MUIA_Frame, MUIV_Frame_String,
                TAG_DONE);
            };
        MUIString(const ULONG len, const UBYTE cc)
            :   MUIGadget(MUIC_String),
                MUIStringEditHook()
            {
            init(MUIA_String_Accept,"1234567890-+",
                MUIA_String_MaxLen, len,
                MUIA_ControlChar, cc,
                MUIA_Frame, MUIV_Frame_String,
                TAG_DONE);
            };
        MUIString()
            :   MUIGadget(MUIC_String),
                MUIStringEditHook()
            { };
        MUIString(const MUIString &);
        virtual ~MUIString();
        MUIString &operator= (const MUIString &);
        VOID Accept(const STRPTR p) { set(MUIA_String_Accept,(ULONG)p); };
        STRPTR Accept() const { return((STRPTR)get(MUIA_String_Accept,NULL)); };
        STRPTR Acknowledge() const { return((STRPTR)get(MUIA_String_Acknowledge,NULL)); };
        VOID AdvanceOnCR(const BOOL p) { set(MUIA_String_AdvanceOnCR,(ULONG)p); };
        BOOL AdvanceOnCR() const { return((BOOL)get(MUIA_String_AdvanceOnCR,FALSE)); };
        VOID AttachedList(const Object *p) { set(MUIA_String_AttachedList,(ULONG)p); };
        Object *AttachedList() const { return((Object *)get(MUIA_String_AttachedList,NULL)); };
        VOID BufferPos(const LONG p) { set(MUIA_String_BufferPos,(ULONG)p); };
        VOID Contents(const STRPTR p) { set(MUIA_String_Contents,(ULONG)p); };
        STRPTR Contents() const { return((STRPTR)get(MUIA_String_Contents,NULL)); };
        VOID DisplayPos(const LONG p) { set(MUIA_String_DisplayPos,(ULONG)p); };
        VOID EditHook(const struct Hook *p) { set(MUIA_String_EditHook,(ULONG)p); };
        struct Hook *EditHook() const { return((struct Hook *)get(MUIA_String_EditHook)); };
        LONG Format() const { return((LONG)get(MUIA_String_Format,0L)); };
        VOID Integer(const ULONG p) { set(MUIA_String_Integer,p); };
        ULONG Integer() const { return(get(MUIA_String_Integer,0L)); };
        VOID LonelyEditHook(const BOOL p) { set(MUIA_String_LonelyEditHook,(ULONG)p); };
        BOOL LonelyEditHook() const { return((BOOL)get(MUIA_String_LonelyEditHook,FALSE)); };
        LONG MaxLen() const { return((LONG)get(MUIA_String_MaxLen,0L)); };
        VOID Reject(const STRPTR p) { set(MUIA_String_Reject,(ULONG)p); };
        STRPTR Reject() const { return((STRPTR)get(MUIA_String_Reject,NULL)); };
        BOOL Secret() const { return((BOOL)get(MUIA_String_Secret,FALSE)); };
    };

///
/// class MUILabString

class MUILabString
    :   public MUILabelHelp,
        public MUIString
    {
    private:
        MUIKeyLabel2 MUILab;
    public:
        MUILabString(const STRPTR lab, const STRPTR cont, const ULONG len)
            :   MUILabelHelp(lab),
                MUIString(cont,len,MUILabelHelp::gCC()),
                MUILab(MUILabelHelp::gLab(),MUILabelHelp::gCC())
            {
            };
        MUILabString(const STRPTR lab, const ULONG cont, const ULONG len)
            :   MUILabelHelp(lab),
                MUIString(cont,len,MUILabelHelp::gCC()),
                MUILab(MUILabelHelp::gLab(),MUILabelHelp::gCC())
            {
            };
        MUILabString(const MUILabString &p)
            :   MUILabelHelp((MUILabelHelp &)p),
                MUIString((MUIString &)p),
                MUILab(p.MUILab)
            { };
        virtual ~MUILabString();
        MUILabString &operator= (const MUILabString &);
        Object *label() { return(MUILab); };
    };

///

#endif
