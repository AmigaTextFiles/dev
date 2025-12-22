//
//  $VER: Notify.h      1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_NOTIFY_H
#define CPP_TWIMUI_NOTIFY_H

#ifndef CPP_TWIMUI_MISC_H
#include <classes/twimui/misc.h>
#endif

#ifndef	INTUITION_CLASSUSR_H
#include <intuition/classusr.h>
#endif

#ifndef LIBRARIES_MUI_H
#include <libraries/mui.h>
#endif

#ifndef _INCLUDE_PRAGMA_MUIMASTER_LIB_H
#include <pragma/muimaster_lib.h>
#endif

#ifndef WORKBENCH_WORKBENCH_H
#include <workbench/workbench.h>
#endif

const ULONG MUISERIALNR_WILLI = (ULONG)0x06af;
const ULONG TAGBASE_WILLI     = (TAG_USER | ( MUISERIALNR_WILLI << 16));

const ULONG MUIA_TWiClass_AppClass = (TAGBASE_WILLI | 0xffff);
const ULONG MUIA_TWiClass_WinClass = (TAGBASE_WILLI | 0xfffe);

inline ULONG MakeId(const UBYTE a, const UBYTE b, const UBYTE c, const UBYTE d)
	{
	return((ULONG)(a)<<24 | (ULONG)(b)<<16 | (ULONG)(c)<<8 | (ULONG)(d));
	};

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

class MUIT
	{
	protected:
		LONG Typ;
	public:
		MUIT(const LONG t) : Typ(t) { };
		MUIT(const MUIT &t) : Typ(t.Typ) { };
		~MUIT() { };
		LONG typ() const { return(Typ); };
	};

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

class MUIApplication;

class MUINotify
	{
	private:
		static TWiArrayList<MUI_CustomClass *> ClassArray;
		static ULONG Counter;
		static ULONG dispatcher(register __a0 struct IClass *, register __a2 Object *, register __a1 Msg);

	private:
		TWiTag Tags;
		TWiStr ClassName;
		struct MUI_CustomClass *mcc;
		ULONG *thisCounter;
	protected:
		Object *Obj;
		Object *Par;

	private:
		void terminate();
		virtual ULONG Dispatch(struct IClass *, Object *, Msg);
	protected:
		MUINotify(const STRPTR cl);
		MUINotify(const MUINotify &);
		virtual ~MUINotify();
		MUINotify &operator= (const MUINotify &);
		void set(const Tag, const ULONG);
		ULONG get(const Tag, const ULONG p = NULL) const;
		ULONG dom(const Tag);
		ULONG dom(const Tag, ULONG);
		ULONG dom(const Tag, ULONG, ULONG);
		ULONG dom(const Tag, ULONG, ULONG, ULONG);
		ULONG dom(const Tag, ULONG, ULONG, ULONG, ULONG);
		void init(const struct TagItem *);
		void init(const Tag, ...);
		virtual ULONG Dispose(struct IClass *, Object *, Msg);
		virtual ULONG UserDispatch(struct IClass *, Object *, Msg);
	public:
		BOOL Create(const struct TagItem *t = NULL);
		BOOL Create(const Tag, ...);
		Object *object() const { return(Obj); };
		operator Object*() const { return(Obj); };
		Object *AppObject() const { return((Object *)get(MUIA_ApplicationObject)); };
		MUIApplication *AppClass() const;
		struct AppMessage *AppMessage() const { return((struct AppMessage *)get(MUIA_AppMessage)); };
		void HelpLine(const LONG p) { set(MUIA_HelpLine,(ULONG)p); };
		LONG HelpLine() const { return((LONG)get(MUIA_HelpLine,0L)); };
		void HelpNode(const STRPTR p) { set(MUIA_HelpNode,(ULONG)p); };
		STRPTR HelpNode() const { return((STRPTR)get(MUIA_HelpNode)); };
		Object *Parent() const { return((Object *)get(MUIA_Parent)); };
		LONG Revision() const { return((LONG)get(MUIA_Revision,0L)); };
		void UserData(const ULONG p) { set(MUIA_UserData,p); };
		ULONG UserData() const { return(get(MUIA_UserData,0L)); };
		LONG VersionN() const { return((LONG)get(MUIA_Version,0L)); };
		void CallHook(struct Hook *h, ULONG c = 0UL, ...);
		Object *FindUData(ULONG p) { return((Object *)dom(MUIM_FindUData,p)); };
		ULONG GetUData(ULONG p1, ULONG *p2) { return(dom(MUIM_GetUData,p1,(ULONG)p2)); };
		void KillNotify(ULONG p) { dom(MUIM_KillNotify,p); };
		void NoNotifySet(ULONG p1, ULONG p2) { dom(MUIM_NoNotifySet,p1,p2); };
		void Notify(const Tag t, ULONG v, Object *o, ULONG c = 0UL, ...);
		void Set(ULONG p1, ULONG p2) { dom(MUIM_Set,p1,p2); };
		void SetAsString(Tag t, STRPTR f, ULONG c = 0UL, ...);
		void SetUData(ULONG p1, ULONG p2, ULONG p3) { dom(MUIM_SetUData,p1,p2,p3); };
		void SetUDataOnce(ULONG p1, ULONG p2, ULONG p3) { dom(MUIM_SetUDataOnce,p1,p2,p3); };
	};

#endif
