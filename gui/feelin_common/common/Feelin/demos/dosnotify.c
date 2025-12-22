#include <libraries/feelin.h>

#include <proto/feelin.h>
#include <proto/exec.h>
#include <proto/dos.h>

struct FeelinBase *FeelinBase;

#ifdef __amigaos4__
struct FeelinIFace *IFeelin;
#endif

#ifdef F_NEW_LISTENERS

F_HOOKM(uint32, Hook_Update, FS_Listener_Trigger)
{
	IFEELIN F_Log(FV_LOG_USER, "DOS object '%s' has been modified", Msg->Value);

	return 0;
}

#else

struct FS_DOSNotify_Update
{
	STRPTR						   	Name;
};

F_HOOKM(uint32, Hook_Update, FS_DOSNotify_Update)
{
	IFEELIN F_Log(FV_LOG_USER, "DOS object '%s' has been modified", Msg->Name);

	return 0;
}

#endif

int main(void)
{
	if (F_FEELIN_OPEN)
	{
		FObject dn = DOSNotifyObject,
			
			"Name", "ram:test.txt",

			End;
		   
		if (dn)
		{
			#ifdef F_NEW_LISTENERS
			struct Hook update = { { NULL, NULL }, (HOOKFUNC) Hook_Update, NULL, NULL };

			IFEELIN F_Do(dn, FM_AddListener, "Update", &update, TAG_DONE);

			#else

			IFEELIN F_Do
			(
				dn, FM_Notify, "Update", FV_Notify_Always,
				FV_Notify_Self, FM_CallHookEntry, 2, Hook_Update, FV_Notify_Value
			);

			#endif

			IDOS_ Printf("Watching 'ram:test.txt'. Use Ctrl-C to terminate the demo.\n");

			IEXEC Wait(SIGBREAKF_CTRL_C);

			IFEELIN F_DisposeObj(dn);
		}
		
		F_FEELIN_CLOSE;
	}
	return 0;
}

