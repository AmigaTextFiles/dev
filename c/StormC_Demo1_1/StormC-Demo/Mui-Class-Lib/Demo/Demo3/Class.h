#ifndef CPP_TWIMUI_APPLICATION_H
#include <classes/twimui/application.h>
#endif

#ifndef CPP_TWIMUI_BUTTON_H
#include <classes/twimui/button.h>
#endif

#ifndef CPP_TWIMUI_LIST_H
#include <classes/twimui/list.h>
#endif

#ifndef CPP_TWIMUI_LISTVIEW_H
#include <classes/twimui/listview.h>
#endif

#ifndef CPP_TWIMUI_REQUEST_H
#include <classes/twimui/request.h>
#endif

#ifndef CPP_TWIMUI_WINDOW_H
#include <classes/twimui/window.h>
#endif

const ULONG MUIM_Demo_Save   = (TAGBASE_WILLI | 0x0001);
const ULONG MUIM_Demo_Use    = (TAGBASE_WILLI | 0x0002);
const ULONG MUIM_Demo_Cancel = (TAGBASE_WILLI | 0x0003);

class ListCont
	{
	private:
		TWiStr str;
	public:
		ListCont(const STRPTR p) : str(p) { };
		~ListCont() { };
		const TWiStr &getStr() const { return(str); };
	};

class TWiList : public MUIList
	{
	private:
		virtual LONG CompareHookFunc(struct Hook *, APTR, APTR);
		virtual APTR ConstructHookFunc(struct Hook *, APTR, APTR);
		virtual void DestructHookFunc(struct Hook *, APTR, APTR);
		virtual void DisplayHookFunc(struct Hook *, STRPTR *, APTR);
	public:
		TWiList();
		~TWiList() { };
	};

class TWiWin : public MUIWindow
	{
	private:
		TWiList Liste;
		MUIListview lv;
		MUILabButton BSave;
		MUILabButton BUse;
		MUILabButton BCancel;
		MUIRequest MsgSave;
		MUIRequest MsgUse;
		MUIRequest MsgCan;
		virtual ULONG UserDispatch(struct IClass *, Object *, Msg);
		void save();
		void use();
		void cancel();
	public:
		TWiWin();
		~TWiWin();
	};
