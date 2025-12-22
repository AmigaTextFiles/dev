#ifndef CPP_TWIMUI_APPLICATION_H
#include <classes/twimui/application.h>
#endif

#ifndef CPP_TWIMUI_BUTTON_H
#include <classes/twimui/button.h>
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

class TWiWin : public MUIWindow
	{
	private:
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
