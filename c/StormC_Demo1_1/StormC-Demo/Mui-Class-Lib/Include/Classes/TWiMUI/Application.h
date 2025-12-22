//
//  $VER: Application.h 1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_APPLICATION_H
#define CPP_TWIMUI_APPLICATION_H

#ifndef CPP_TWIMUI_NOTIFY_H
#include <classes/twimui/notify.h>
#endif

#ifndef CPP_TWIMUI_WINDOW_H
#include <classes/twimui/window.h>
#endif

#ifndef LIBRARIES_COMMODITIES_H
#include <libraries/commodities.h>
#endif

#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif

class MUIApplicationBrokerHook
	{
	private:
		struct Hook brokerhook;
		static void BrokerHookEntry(register __a0 struct Hook *, register __a2 Object *, register __a1 CxMsg *);
		virtual void BrokerHookFunc(struct Hook *, Object *, CxMsg *);
	protected:
		MUIApplicationBrokerHook();
		MUIApplicationBrokerHook(const MUIApplicationBrokerHook &);
		~MUIApplicationBrokerHook();
		MUIApplicationBrokerHook &operator= (const MUIApplicationBrokerHook &);
	public:
		struct Hook *broker() { return(&brokerhook); };
	};

class MUIApplicationRexxHook
	{
	private:
		struct Hook rexxhook;
		static ULONG RexxHookEntry(register __a0 struct Hook *, register __a2 Object *, register __a1 struct RexxMsg *);
		virtual ULONG RexxHookFunc(struct Hook *, Object *, struct RexxMsg *);
	protected:
		MUIApplicationRexxHook();
		MUIApplicationRexxHook(const MUIApplicationRexxHook &p);
		~MUIApplicationRexxHook();
		MUIApplicationRexxHook &operator= (const MUIApplicationRexxHook &);
	public:
		struct Hook *rexx() { return(&rexxhook); };
	};

class MUIApplication
	:   public MUINotify,
		public MUIApplicationBrokerHook,
		public MUIApplicationRexxHook
	{
	private:
		virtual ULONG Dispatch(struct IClass *, Object *, Msg);
	public:
		MUIApplication(const struct TagItem *t)
			:   MUINotify(MUIC_Application),
				MUIApplicationBrokerHook(),
				MUIApplicationRexxHook()
			{
			init(t);
			};
		MUIApplication(const Tag, ...);
		MUIApplication()
			:   MUINotify(MUIC_Application),
				MUIApplicationBrokerHook(),
				MUIApplicationRexxHook()
			{ };
		MUIApplication(MUIApplication &p)
			:   MUINotify(p),
				MUIApplicationBrokerHook(p),
				MUIApplicationRexxHook(p)
			{ };
		virtual ~MUIApplication();
		MUIApplication &operator= (MUIApplication &);
		void Loop();
		void Active(const BOOL p) { set(MUIA_Application_Active,(ULONG)p); };
		BOOL Active() const { return((BOOL)get(MUIA_Application_Active, FALSE)); };
		STRPTR Author() const { return((STRPTR)get(MUIA_Application_Author)); };
		STRPTR Base() const { return((STRPTR)get(MUIA_Application_Base)); };
		struct NewBroker *Broker() const { return((struct NewBroker *)get(MUIA_Application_Broker)); };
		void BrokerHook(const struct Hook *p) { set(MUIA_Application_BrokerHook,(ULONG)p); };
		struct Hook *BrokerHook() const { return((struct Hook *)get(MUIA_Application_BrokerHook)); };
		struct MsgPort *BrokerPort() const { return((struct MsgPort *)get(MUIA_Application_BrokerPort)); };
		LONG BrokerPri() const { return((LONG)get(MUIA_Application_BrokerPri,0L)); };
		void Commands(const struct MUI_Commands *p) { set(MUIA_Application_Commands,(ULONG)p); };
		struct MUI_Commands *Commands() const { return((struct MUI_Commands *)get(MUIA_Application_Commands)); };
		STRPTR Copyright() const { return((STRPTR)get(MUIA_Application_Copyright)); };
		STRPTR Description() const { return((STRPTR)get(MUIA_Application_Description)); };
		void DiskObject(const struct DiskObject *p) { set(MUIA_Application_DiskObject,(ULONG)p); };
		struct DiskObject *DiskObject() const { return((struct DiskObject *)get(MUIA_Application_DiskObject)); };
		BOOL DoubleStart() const { return((BOOL)get(MUIA_Application_DoubleStart,FALSE)); };
		void DropObject(const Object *p) { set(MUIA_Application_DropObject,(ULONG)p); };
		BOOL ForceQuit() const { return((BOOL)get(MUIA_Application_ForceQuit,FALSE)); };
		void HelpFile(const STRPTR p) { set(MUIA_Application_HelpFile,(ULONG)p); };
		STRPTR HelpFile() const { return((STRPTR)get(MUIA_Application_HelpFile)); };
		void Iconified(const BOOL p) { set(MUIA_Application_Iconified,(ULONG)p); };
		BOOL Iconified() const { return((BOOL)get(MUIA_Application_Iconified,FALSE)); };
		ULONG MenuAction() const { return(get(MUIA_Application_MenuAction,0L)); };
		ULONG MenuHelp() const { return(get(MUIA_Application_MenuHelp,0L)); };
		void RexxHook(const struct Hook *p) { set(MUIA_Application_RexxHook,(ULONG)p); };
		struct Hook *RexxHook() const { return((struct Hook *)get(MUIA_Application_RexxHook)); };
		struct RxMsg *RexxMsg() const { return((struct RxMsg *)get(MUIA_Application_RexxMsg)); };
		void RexxString(const STRPTR p) { set(MUIA_Application_RexxString,(ULONG)p); };
		void Sleep(const BOOL p) { set(MUIA_Application_Sleep,(ULONG)p); };
		STRPTR Title() const { return((STRPTR)get(MUIA_Application_Title)); };
		STRPTR Version() const { return((STRPTR)get(MUIA_Application_Version)); };
		void AddInputHandler(struct MUI_InputHandlerNode *p) { dom(MUIM_Application_AddInputHandler,(ULONG)p); };
		void CheckRefresh() { dom(MUIM_Application_CheckRefresh); };
		void InputBuffered() { dom(MUIM_Application_InputBuffered); };
		void Load(STRPTR p) { dom(MUIM_Application_Load,(ULONG)p); };
		void LoadENV() { dom(MUIM_Application_Load,(ULONG)MUIV_Application_Load_ENV); };
		void LoadENVARC() { dom(MUIM_Application_Load,(ULONG)MUIV_Application_Load_ENVARC); };
		ULONG NewInput(LONGBITS *p) { return(dom(MUIM_Application_NewInput,(ULONG)p)); };
		void OpenConfigWindow(ULONG p) { dom(MUIM_Application_OpenConfigWindow,p); };
		void RemInputHandler(struct MUI_InputHandlerNode *p) { dom(MUIM_Application_RemInputHandler,(ULONG)p); };
		void ReturnID(ULONG p) { dom(MUIM_Application_ReturnID,p); };
		void Save(STRPTR p) { dom(MUIM_Application_Save,(ULONG)p); };
		void SaveENV() { dom(MUIM_Application_Save,(ULONG)MUIV_Application_Save_ENV); };
		void SaveENVARC() { dom(MUIM_Application_Save,(ULONG)MUIV_Application_Save_ENVARC); };
		void ShowHelp(Object *p1, STRPTR p2, STRPTR p3, LONG p4) { dom(MUIM_Application_ShowHelp,(ULONG)p1,(ULONG)p2,(ULONG)p3,(ULONG)p4); };
		void Add(MUIWindow &p) { dom(OM_ADDMEMBER,(ULONG)((Object *)p)); };
		void Rem(MUIWindow &p) { dom(OM_REMMEMBER,(ULONG)((Object *)p)); };
	};

#endif
