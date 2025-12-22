#ifndef TWICPP_TWIMUI_NOTIFY_H
#define TWICPP_TWIMUI_NOTIFY_H

//
//  $VER: Notify.h      2.0 (10 Feb 1997)
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
//                        - Die Methode ObjectID() wurde für MUI 3.6 von MUIARea
//                          übernommen.
//                        - Die Methode GetConfigItem() wurde für MUI 3.6 hinzugefügt.
//                        - Die Methode KillNotifyObj() wurde für MUI 3.6 hinzugefügt.
//                        - ClassNum() für Exception-Handling.
//                        Änderungen:
//                        - MakeId() aus Konsistenzgründen in MakeID() geändert.
//                        - Parameter des Copy-Konstruktor als 'const'-Parameter definiert
//                        - MUIT aus Konsistenzgründen in MUIErrorX geändert.
//
//  10 Feb 1997 :   2.0 : Neu:
//                        - Die Methode OwnMethod()
//

/// Includes

#ifndef TWICPP_DATASTRUCTURES_ARRAY_H
#include <twiclasses/datastructures/array.h>
#endif

#ifndef TWICPP_DATASTRUCTURES_STRING_H
#include <twiclasses/datastructures/string.h>
#endif

#ifndef TWICPP_EXCEPTIONS_EXCEPTIONS_H
#include <twiclasses/exceptions/exceptions.h>
#endif

#ifndef TWICPP_UTILITY_TAG_H
#include <twiclasses/utility/tag.h>
#endif

#ifndef INTUITION_CLASSUSR_H
#include <intuition/classusr.h>
#endif

#ifndef LIBRARIES_MUI_H
#include <libraries/mui.h>
#endif

#ifndef _INCLUDE_PRAGMA_MUIMASTER_LIB_H
#include <pragma/muimaster_lib.h>
#endif

#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif

#ifndef WORKBENCH_WORKBENCH_H
#include <workbench/workbench.h>
#endif

///

/// TAGBASE

const ULONG MUISERIALNR_WILLI = (ULONG)0x06af;
const ULONG TAGBASE_WILLI     = (TAG_USER | ( MUISERIALNR_WILLI << 16));

///
/// Attributs

const ULONG MUIA_TWiMUI_AppClass = (TAGBASE_WILLI | 0xffff);
const ULONG MUIA_TWiMUI_WinClass = (TAGBASE_WILLI | 0xfffe);

///
/// Error-Codes

const ULONG MUIV_TWiMUI_MUIErrorX_Notify        = 1;
const ULONG MUIV_TWiMUI_MUIErrorX_Family        = 2;
const ULONG MUIV_TWiMUI_MUIErrorX_Menustrip     = 3;
const ULONG MUIV_TWiMUI_MUIErrorX_Menu          = 4;
const ULONG MUIV_TWiMUI_MUIErrorX_Menuitem      = 5;
const ULONG MUIV_TWiMUI_MUIErrorX_Application   = 6;
const ULONG MUIV_TWiMUI_MUIErrorX_Window        = 7;
const ULONG MUIV_TWiMUI_MUIErrorX_Aboutmui      = 8;
const ULONG MUIV_TWiMUI_MUIErrorX_Area          = 9;
const ULONG MUIV_TWiMUI_MUIErrorX_Rectangle     = 10;
const ULONG MUIV_TWiMUI_MUIErrorX_Balance       = 11;
const ULONG MUIV_TWiMUI_MUIErrorX_Image         = 12;
const ULONG MUIV_TWiMUI_MUIErrorX_Bitmap        = 13;
const ULONG MUIV_TWiMUI_MUIErrorX_Bodychunk     = 14;
const ULONG MUIV_TWiMUI_MUIErrorX_Text          = 15;
const ULONG MUIV_TWiMUI_MUIErrorX_Gadget        = 16;
const ULONG MUIV_TWiMUI_MUIErrorX_String        = 17;
const ULONG MUIV_TWiMUI_MUIErrorX_Boopsi        = 18;
const ULONG MUIV_TWiMUI_MUIErrorX_Prop          = 19;
const ULONG MUIV_TWiMUI_MUIErrorX_Gauge         = 20;
const ULONG MUIV_TWiMUI_MUIErrorX_Scale         = 21;
const ULONG MUIV_TWiMUI_MUIErrorX_Colorfield    = 22;
const ULONG MUIV_TWiMUI_MUIErrorX_List          = 23;
const ULONG MUIV_TWiMUI_MUIErrorX_Floattext     = 24;
const ULONG MUIV_TWiMUI_MUIErrorX_Volumelist    = 25;
const ULONG MUIV_TWiMUI_MUIErrorX_Dirlist       = 26;
const ULONG MUIV_TWiMUI_MUIErrorX_Numeric       = 27;
const ULONG MUIV_TWiMUI_MUIErrorX_Knob          = 28;
const ULONG MUIV_TWiMUI_MUIErrorX_Levelmeter    = 29;
const ULONG MUIV_TWiMUI_MUIErrorX_Numericbutton = 30;
const ULONG MUIV_TWiMUI_MUIErrorX_Slider        = 31;
const ULONG MUIV_TWiMUI_MUIErrorX_Pendisplay    = 32;
const ULONG MUIV_TWiMUI_MUIErrorX_Poppen        = 33;
const ULONG MUIV_TWiMUI_MUIErrorX_Group         = 34;
const ULONG MUIV_TWiMUI_MUIErrorX_Register      = 35;
const ULONG MUIV_TWiMUI_MUIErrorX_Penadjust     = 36;
const ULONG MUIV_TWiMUI_MUIErrorX_Virtgroup     = 37;
const ULONG MUIV_TWiMUI_MUIErrorX_Scrollgroup   = 38;
const ULONG MUIV_TWiMUI_MUIErrorX_Scrollbar     = 39;
const ULONG MUIV_TWiMUI_MUIErrorX_Listview      = 40;
const ULONG MUIV_TWiMUI_MUIErrorX_Radio         = 41;
const ULONG MUIV_TWiMUI_MUIErrorX_Cycle         = 42;
const ULONG MUIV_TWiMUI_MUIErrorX_Coloradjust   = 43;
const ULONG MUIV_TWiMUI_MUIErrorX_Palette       = 44;
const ULONG MUIV_TWiMUI_MUIErrorX_Popstring     = 45;
const ULONG MUIV_TWiMUI_MUIErrorX_Popobject     = 46;
const ULONG MUIV_TWiMUI_MUIErrorX_Poplist       = 47;
const ULONG MUIV_TWiMUI_MUIErrorX_Popasl        = 48;
const ULONG MUIV_TWiMUI_MUIErrorX_Semaphore     = 49;
const ULONG MUIV_TWiMUI_MUIErrorX_Dataspace     = 50;
const ULONG MUIV_TWiMUI_MUIErrorX_CreateClass   = 100;

///

/// inline ULONG MakeID(const UBYTE, const UBYTE, const UBYTE, const UBYTE)

inline ULONG MakeID(const UBYTE a, const UBYTE b, const UBYTE c, const UBYTE d)
    {
    return((ULONG)(a)<<24 | (ULONG)(b)<<16 | (ULONG)(c)<<8 | (ULONG)(d));
    };

///
/// inline Object *Make...(...)

inline Object *MakeLabel(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,0));
    };

inline Object *MakeLabel1(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_SingleFrame));
    };

inline Object *MakeLabel2(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_DoubleFrame));
    };

inline Object *MakeLLabel(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_LeftAligned));
    };

inline Object *MakeLLabel1(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_LeftAligned|MUIO_Label_SingleFrame));
    };

inline Object *MakeLLabel2(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_LeftAligned|MUIO_Label_DoubleFrame));
    };

inline Object *MakeCLabel(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_Centered));
    };

inline Object *MakeCLabel1(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_Centered|MUIO_Label_SingleFrame));
    };

inline Object *MakeCLabel2(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_Centered|MUIO_Label_DoubleFrame));
    };

inline Object *MakeFreeLabel(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert));
    };

inline Object *MakeFreeLabel1(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert|MUIO_Label_SingleFrame));
    };

inline Object *MakeFreeLabel2(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert|MUIO_Label_DoubleFrame));
    };

inline Object *MakeFreeLLabel(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert|MUIO_Label_LeftAligned));
    };

inline Object *MakeFreeLLabel1(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|MUIO_Label_SingleFrame));
    };

inline Object *MakeFreeLLabel2(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|MUIO_Label_DoubleFrame));
    };

inline Object *MakeFreeCLabel(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert|MUIO_Label_Centered));
    };

inline Object *MakeFreeCLabel1(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert|MUIO_Label_Centered|MUIO_Label_SingleFrame));
    };

inline Object *MakeFreeCLabel2(const STRPTR lab)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert|MUIO_Label_Centered|MUIO_Label_DoubleFrame));
    };

inline Object *MakeKeyLabel(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,key));
    };

inline Object *MakeKeyLabel1(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_SingleFrame|(key)));
    };

inline Object *MakeKeyLabel2(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_DoubleFrame|(key)));
    };

inline Object *MakeKeyLLabel(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_LeftAligned|(key)));
    };

inline Object *MakeKeyLLabel1(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_LeftAligned|MUIO_Label_SingleFrame|(key)));
    };

inline Object *MakeKeyLLabel2(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_LeftAligned|MUIO_Label_DoubleFrame|(key)));
    };

inline Object *MakeKeyCLabel(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_Centered|(key)));
    };

inline Object *MakeKeyCLabel1(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_Centered|MUIO_Label_SingleFrame|(key)));
    };

inline Object *MakeKeyCLabel2(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_Centered|MUIO_Label_DoubleFrame|(key)));
    };

inline Object *MakeFreeKeyLabel(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert|(key)));
    };

inline Object *MakeFreeKeyLabel1(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert|MUIO_Label_SingleFrame|(key)));
    };

inline Object *MakeFreeKeyLabel2(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert|MUIO_Label_DoubleFrame|(key)));
    };

inline Object *MakeFreeKeyLLabel(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|(key)));
    };

inline Object *MakeFreeKeyLLabel1(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|MUIO_Label_SingleFrame|(key)));
    };

inline Object *MakeFreeKeyLLabel2(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|MUIO_Label_DoubleFrame|(key)));
    };

inline Object *MakeFreeKeyCLabel(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert|MUIO_Label_Centered|(key)));
    };

inline Object *MakeFreeKeyCLabel1(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert|MUIO_Label_Centered|MUIO_Label_SingleFrame|(key)));
    };

inline Object *MakeFreeKeyCLabel2(const STRPTR lab, const UBYTE key)
    {
    return(MUI_MakeObject(MUIO_Label,lab,MUIO_Label_FreeVert|MUIO_Label_Centered|MUIO_Label_DoubleFrame|(key)));
    };

inline Object *MakeHBar(const ULONG size)
    {
    return(MUI_MakeObject(MUIO_HBar,size));
    };

inline Object *MakeVBar(const ULONG size)
    {
    return(MUI_MakeObject(MUIO_VBar,size));
    };

inline Object *MakeHSpace(const ULONG size)
    {
    return(MUI_MakeObject(MUIO_HSpace,size));
    };

inline Object *MakeVSpace(const ULONG size)
    {
    return(MUI_MakeObject(MUIO_VSpace,size));
    };

///

/// class MUIErrorX

class MUIErrorX : public TWiResourceX
    {
    private:
        TWiStr ClassName;
        ULONG Typ;
        LONG Error;
    public:
        MUIErrorX(const TWiStr &c, const ULONG t) : ClassName(c), Typ(t), Error(MUI_Error()) { };
        MUIErrorX(const MUIErrorX &t) : ClassName(t.ClassName), Typ(t.Typ), Error(t.Error) { };
        ~MUIErrorX() { };
        const TWiStr &name() const { return(ClassName); };
        ULONG typ() const { return(Typ); };
        LONG error() const { return(Error); };
    };

///
/// class MUILabelHelp

class MUILabelHelp
    {
    private:
        TWiStr labstr;
        UBYTE cc;
    protected:
        MUILabelHelp(const STRPTR);
        MUILabelHelp(const MUILabelHelp &p) : labstr(p.labstr), cc(p.cc) { };
        virtual ~MUILabelHelp();
        MUILabelHelp &operator=(const MUILabelHelp &);
        TWiStr &gLab() { return(labstr); };
        UBYTE gCC() { return(cc); };
    };

///
/// class MUINotify

class MUINotify
    {
    private:
        static TWiArray<MUI_CustomClass *> ClassArray;
        static ULONG Counter;
        static ULONG dispatcher(register __a0 struct IClass *, register __a2 Object *, register __a1 Msg);

    private:
        TWiStr ClassName;
        struct MUI_CustomClass *mcc;
    protected:
        TWiTag Tags;
        Object *Obj;
        Object *Par;

    private:
        VOID createclass();
        VOID terminate();
        virtual ULONG Dispatch(struct IClass *, Object *, Msg);
        virtual const ULONG ClassNum() const;
    protected:
        MUINotify(const struct TagItem *t);
        MUINotify(const Tag, ...);
        MUINotify(const STRPTR cl = MUIC_Notify);
        MUINotify(const MUINotify &);
        virtual ~MUINotify();
        MUINotify &operator= (const MUINotify &);
        VOID set(const Tag, const ULONG);
        ULONG get(const Tag, const ULONG p = NULL) const;
        ULONG dom(const Tag);
        ULONG dom(const Tag, ULONG);
        ULONG dom(const Tag, ULONG, ULONG);
        ULONG dom(const Tag, ULONG, ULONG, ULONG);
        ULONG dom(const Tag, ULONG, ULONG, ULONG, ULONG);
        ULONG dom(const Tag, ULONG, ULONG, ULONG, ULONG, ULONG);
        ULONG dom(const Tag, ULONG, ULONG, ULONG, ULONG, ULONG, ULONG);
        ULONG dom(const Tag, ULONG, ULONG, ULONG, ULONG, ULONG, ULONG, ULONG);
        VOID init(const struct TagItem *);
        VOID init(const Tag, ...);
        virtual ULONG Dispose(struct IClass *, Object *, Msg);
        virtual ULONG UserDispatch(struct IClass *, Object *, Msg);
    public:
        BOOL Create(const struct TagItem *t = NULL);
        BOOL Create(const Tag, ...);
        Object *object() const { return(Obj); };
        operator Object*() const { return(Obj); };
        Object *AppObject() const { return((Object *)get(MUIA_ApplicationObject)); };
        class MUIApplication *AppClass() const;
        struct AppMessage *AppMessage() const { return((struct AppMessage *)get(MUIA_AppMessage)); };
        VOID HelpLine(const LONG p) { set(MUIA_HelpLine,(ULONG)p); };
        LONG HelpLine() const { return((LONG)get(MUIA_HelpLine,0L)); };
        VOID HelpNode(const STRPTR p) { set(MUIA_HelpNode,(ULONG)p); };
        STRPTR HelpNode() const { return((STRPTR)get(MUIA_HelpNode)); };
        VOID ObjectID(const ULONG p) { set(MUIA_ObjectID,p); };
        ULONG ObjectID() const { return(get(MUIA_ObjectID,0L)); };
        Object *Parent() const { return((Object *)get(MUIA_Parent)); };
        LONG Revision() const { return((LONG)get(MUIA_Revision,0L)); };
        VOID UserData(const ULONG p) { set(MUIA_UserData,p); };
        ULONG UserData() const { return(get(MUIA_UserData,0L)); };
        LONG VersionN() const { return((LONG)get(MUIA_Version,0L)); };
        VOID CallHook(struct Hook *h, ULONG c = 0UL, ...);
        Object *FindUData(ULONG p) { return((Object *)dom(MUIM_FindUData,p)); };
        ULONG GetConfigItem(ULONG p) { ULONG r; dom(MUIM_GetConfigItem,p,(ULONG)&r); return(r); };
        ULONG GetUData(ULONG p1, ULONG *p2) { return(dom(MUIM_GetUData,p1,(ULONG)p2)); };
        VOID KillNotify(ULONG p) { dom(MUIM_KillNotify,p); };
        VOID KillNotifyObj(ULONG p1, Object *p2) { dom(MUIM_KillNotifyObj,p1,(ULONG)p2); };
        VOID NoNotifySet(ULONG p1, ULONG p2) { dom(MUIM_NoNotifySet,p1,p2); };
        VOID Notify(const Tag t, ULONG v, Object *o, ULONG c = 0UL, ...);
        VOID Set(ULONG p1, ULONG p2) { dom(MUIM_Set,p1,p2); };
        VOID SetAsString(const Tag t, STRPTR f, ULONG c = 0UL, ...);
        VOID SetUData(ULONG p1, ULONG p2, ULONG p3) { dom(MUIM_SetUData,p1,p2,p3); };
        VOID SetUDataOnce(ULONG p1, ULONG p2, ULONG p3) { dom(MUIM_SetUDataOnce,p1,p2,p3); };
        VOID OwnMethod(const ULONG id, const ULONG count = 0UL, ...);
    };

///

#endif
